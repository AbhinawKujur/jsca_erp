<?php
// app/Models/PlayerModel.php
namespace App\Models;

use CodeIgniter\Model;

class PlayerModel extends Model
{
    protected $table         = 'players';
    protected $primaryKey    = 'id';
    protected $returnType    = 'array';
    protected $useSoftDeletes= false;
    protected $useTimestamps = true;
    protected $createdField  = 'created_at';
    protected $updatedField  = 'updated_at';

    protected $allowedFields = [
        'jsca_player_id','full_name','date_of_birth','gender','age_category',
        'district_id','role','batting_style','bowling_style',
        'aadhaar_number','aadhaar_verified','digilocker_id','photo_path',
        'address','guardian_name','guardian_phone','email','phone',
        'status','selection_pool','registered_by',
    ];

    protected $validationRules = [
        'full_name'     => 'required|min_length[3]|max_length[100]',
        'date_of_birth' => 'required|valid_date[Y-m-d]',
        'district_id'   => 'required|is_natural_no_zero',
        'role'          => 'required|in_list[Batsman,Bowler,All-rounder,Wicket-keeper]',
    ];

    // ── Scopes ───────────────────────────────────────────────
    public function active(): static
    {
        return $this->where('status', 'Active');
    }

    public function byCategory(string $category): static
    {
        return $this->where('age_category', $category);
    }

    public function byDistrict(int $districtId): static
    {
        return $this->where('district_id', $districtId);
    }

    public function verified(): static
    {
        return $this->where('aadhaar_verified', 1);
    }

    // ── Get player with full details ─────────────────────────
    public function getWithDetails(int $id): ?array
    {
        return $this->db->table('players p')
            ->select('p.*, d.name as district_name, d.zone, pcs.*')
            ->join('districts d', 'd.id = p.district_id')
            ->join('player_career_stats pcs', 'pcs.player_id = p.id', 'left')
            ->where('p.id', $id)
            ->get()->getRowArray() ?: null;
    }

    // ── Search ───────────────────────────────────────────────
    public function search(string $query): array
    {
        return $this->db->table('players p')
            ->select('p.id, p.jsca_player_id, p.full_name, p.age_category, p.role, d.name as district')
            ->join('districts d', 'd.id = p.district_id')
            ->where('p.status', 'Active')
            ->groupStart()
                ->like('p.full_name', $query)
                ->orLike('p.jsca_player_id', $query)
            ->groupEnd()
            ->limit(20)
            ->get()->getResultArray();
    }

    // ── Top performers ────────────────────────────────────────
    public function topScorers(int $limit = 10, ?string $category = null, ?int $tournamentId = null): array
    {
        $builder = $this->db->table('batting_stats bs')
            ->select('p.id, p.full_name, p.jsca_player_id, p.age_category, d.name as district,
                      SUM(bs.runs) as total_runs, MAX(bs.runs) as high_score,
                      ROUND(AVG(bs.runs), 1) as avg_runs,
                      COUNT(bs.id) as innings')
            ->join('players p', 'p.id = bs.player_id')
            ->join('districts d', 'd.id = p.district_id');

        if ($category)    $builder->where('p.age_category', $category);
        if ($tournamentId) {
            $builder->join('fixtures f', 'f.id = bs.fixture_id')
                    ->where('f.tournament_id', $tournamentId);
        }

        return $builder->groupBy('bs.player_id')
            ->orderBy('total_runs', 'DESC')
            ->limit($limit)
            ->get()->getResultArray();
    }

    public function topWicketTakers(int $limit = 10, ?string $category = null): array
    {
        $builder = $this->db->table('bowling_stats bs')
            ->select('p.id, p.full_name, p.jsca_player_id, p.age_category, d.name as district,
                      SUM(bs.wickets) as total_wickets,
                      ROUND(SUM(bs.runs_conceded)/NULLIF(SUM(bs.wickets),0), 2) as bowling_avg,
                      ROUND(SUM(bs.runs_conceded)/NULLIF(SUM(bs.overs),0), 2) as economy,
                      COUNT(bs.id) as innings')
            ->join('players p', 'p.id = bs.player_id')
            ->join('districts d', 'd.id = p.district_id');

        if ($category) $builder->where('p.age_category', $category);

        return $builder->groupBy('bs.player_id')
            ->orderBy('total_wickets', 'DESC')
            ->limit($limit)
            ->get()->getResultArray();
    }
}

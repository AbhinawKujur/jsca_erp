<?php
$file = 'app/Controllers/Fixtures.php';
$content = file_get_contents($file);

$newMap = <<<'PHP'
        $officialsToInsert = [];
        $officialMap = [
            'umpire1_id'  => ['type' => 1, 'fee' => 'umpire1_fee'],
            'umpire2_id'  => ['type' => 1, 'fee' => 'umpire2_fee'],
            'scorer_id'   => ['type' => 2, 'fee' => 'scorer_fee'],
            'referee_id'  => ['type' => 3, 'fee' => 'referee_fee'],
        ];
        foreach ($officialMap as $field => $meta) {
            if (empty($post[$field])) continue;
            $official = $this->db->table('officials')->select('full_name')->where('id', (int)$post[$field])->get()->getRowArray();
            if (!$official) continue;
            $officialsToInsert[] = [
                'match_id'         => $id,
                'official_type_id' => $meta['type'],
                'official_id'      => (int)$post[$field],
                'name'             => $official['full_name'],
                'PAmt'             => !empty($post[$meta['fee']]) ? (float)$post[$meta['fee']] : null,
                'status'           => 'Active',
            ];
        }
PHP;

// Replace store() block
$old1 = <<<'PHP'
        $officialsToInsert = [];
        $officialMap = [
            'umpire1_id'  => 1,
            'umpire2_id'  => 1,
            'scorer_id'   => 2,
            'referee_id'  => 3,
        ];
        foreach ($officialMap as $field => $typeId) {
            if (empty($post[$field])) continue;
            $official = $this->db->table('officials')->select('full_name')->where('id', (int)$post[$field])->get()->getRowArray();
            if (!$official) continue;
            $officialsToInsert[] = [
                'match_id'         => $id,
                'official_type_id' => $typeId,
                'official_id'      => (int)$post[$field],
                'name'             => $official['full_name'],
                'status'           => 'Active',

            ];
        }
PHP;

// Replace update() block
$old2 = <<<'PHP'
        $officialsToInsert = [];
        $officialMap = [
            'umpire1_id' => 1,
            'umpire2_id' => 1,
            'scorer_id'  => 2,
            'referee_id' => 3,
        ];
        foreach ($officialMap as $field => $typeId) {
            if (empty($post[$field])) continue;
            $official = $this->db->table('officials')->select('full_name')->where('id', (int)$post[$field])->get()->getRowArray();
            if (!$official) continue;
            $officialsToInsert[] = [
                'match_id'         => $id,
                'official_type_id' => $typeId,
                'official_id'      => (int)$post[$field],
                'name'             => $official['full_name'],
                'status'           => 'Active',
                'created_at'       => date('Y-m-d H:i:s'),
            ];
        }
PHP;

$content = str_replace($old1, $newMap, $content, $c1);
$content = str_replace($old2, $newMap, $content, $c2);
file_put_contents($file, $content);
echo "Replaced store()=$c1 update()=$c2\n";

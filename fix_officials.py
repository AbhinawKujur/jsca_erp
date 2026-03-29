import re

with open('app/Controllers/Fixtures.php', 'r') as f:
    content = f.read()

new_map = """        $officialsToInsert = [];
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
        }"""

old1 = """        $officialsToInsert = [];
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
        }"""

old2 = """        $officialsToInsert = [];
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
        }"""

content = content.replace(old1, new_map, 1)
content = content.replace(old2, new_map, 1)

with open('app/Controllers/Fixtures.php', 'w') as f:
    f.write(content)

print('Done - replaced', content.count("'fee' => 'umpire1_fee'"), 'occurrences')

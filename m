Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C469526C3BD
	for <kvmarm@lists.linux.dev>; Sun, 26 Jul 2026 15:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785080040; cv=none; b=AKJ7Sw1l3J4YqorYG5mIqGoomCRhVB8WEm9J8+6rHkl5IBKpS5sgEtdnFJqPRZI/6/PCsRUYaV6rgKqBpBI7pycr3WTq1NfK3aORsbEPC85In4bUDpIRrkgkcXGZaEhbqQTFr9cOiyDPHkZXJlVZhqbJea/49ILd5pYmvyWgObk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785080040; c=relaxed/simple;
	bh=UY/ONfRkrQhWDF0SsukhmAViKFCBDnuafBWGD/N1Ses=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=P1Z+ob9W1MIOZseqX9PY5Ku0wIUTwbeDtjJyncj8QFLqrtYoCni7Gufu/qmNFCZae3XGtcsQ2phQMAs0kKCWscjvkyq0HN3Di2n7nME2NrClRQM7pFVs/7S/29lwcaCVYfgsWLV82+L1PUVSXg7uNcimktILHdC3B4fyVevc+hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KTCHlaEI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KTCHlaEI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785080037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0MgtnSaVh9ax7ryBzZLi/K7BKaomljz1Cy0WeKLK4ak=;
	b=KTCHlaEI8t0MIl5AH354gQoO8IwlS36lPLqIvzYpaSjfOWQ68gHoMmLyXrvz7rpmmCLtQS
	xhqa2EFHyBQnys6JfUEaq+MOsNxNqInvQBRc+oWxc4wRgJuQs0FhbHBEksNFx9Zs3R5Vl5
	rg2d5755j45APyKnqkoBJtBR+9KG6RM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-520-pGKcaq8dMIiIaqkS8Beihg-1; Sun,
 26 Jul 2026 11:33:46 -0400
X-MC-Unique: pGKcaq8dMIiIaqkS8Beihg-1
X-Mimecast-MFC-AGG-ID: pGKcaq8dMIiIaqkS8Beihg_1785080024
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7ACE6195605B;
	Sun, 26 Jul 2026 15:33:44 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.32.63])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E4E4E180044F;
	Sun, 26 Jul 2026 15:33:33 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	shaju.abraham@nutanix.com,
	khushit.shah@nutanix.com,
	yangjinqian1@huawei.com,
	cohuck@redhat.com,
	richard.henderson@linaro.org,
	sebott@redhat.com,
	skolothumtho@nvidia.com,
	philmd@oss.qualcomm.com
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Subject: [RFC PATCH v7 06/18] scripts: Introduce scripts/update-aarch64-cpu-sysreg-properties.py
Date: Sun, 26 Jul 2026 17:29:44 +0200
Message-ID: <20260726153221.24773-7-eric.auger@redhat.com>
In-Reply-To: <20260726153221.24773-1-eric.auger@redhat.com>
References: <20260726153221.24773-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 4rhsfsPqqQCiulsev7VbsTr4Bex9ccgIRZhN4eLJ8Ik_1785080024
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Introduce a script that takes as input the Registers.json file
delivered in the AARCHMRS Features Model downloadable from the
Arm Developer A-Profile Architecture Exploration Tools page:
https://developer.arm.com/Architectures/A-Profile%20Architecture#Downloads
and automates the generation of system register properties definitions.

generates target/arm/cpu-idregs.h.inc containing definitions for
feature ID registers.

We only care about IDregs with opcodes satisfying:
op0 = 3, op1 = {0,1,3}, crn = 0, crm within [0, 7], op2 within [0, 7]

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v5 -> v6
- add ident
---
 .../update-aarch64-cpu-sysreg-properties.py   | 166 ++++++++++++++++++
 1 file changed, 166 insertions(+)
 create mode 100644 scripts/update-aarch64-cpu-sysreg-properties.py

diff --git a/scripts/update-aarch64-cpu-sysreg-properties.py b/scripts/update-aarch64-cpu-sysreg-properties.py
new file mode 100644
index 0000000000..6f5edb88d2
--- /dev/null
+++ b/scripts/update-aarch64-cpu-sysreg-properties.py
@@ -0,0 +1,166 @@
+#!/usr/bin/env python3
+
+# This script takes as input the Registers.json file delivered in
+# the AARCHMRS Features Model downloadable from the Arm Developer
+# A-Profile Architecture Exploration Tools page:
+# https://developer.arm.com/Architectures/A-Profile%20Architecture#Downloads
+# and outputs target/arm/cpu-idregs.h.inc content.
+# ID regs are defined using this pattern:
+#
+# IDREG_START(REG)
+#    IDREG_FIELD(REG, FIELD, SHIFT, LENGTH)
+# ...
+# IDREG_END(REG)
+#
+# Copyright (C) 2026 Red Hat, Inc.
+#
+# Authors: Eric Auger <eric.auger@redhat.com>
+#
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+
+import json
+import os
+import sys
+from aarch64_sysreg_helpers import extract_idregs_from_registers_json
+
+def collect_fields(item, bit_offset=0):
+    """
+    Recursively finds all field-like objects, handling Fields.Array,
+    Fields.ArrayField, and ConditionalField structures.
+    Applies bit_offset from containers to child fields.
+    """
+    fields = []
+    if not isinstance(item, dict):
+        return fields
+
+    _type = item.get('_type', '')
+
+    # Array types (for example CLIDR_EL1 Ctype<n>, Ttype<n>)
+    if _type == 'Fields.Array':
+        name_template = item.get('name') or item.get('label', '')
+        index_info = item.get('indexes', [{}])[0]
+        start_idx = index_info.get('start', 0)
+        count = index_info.get('width', 0)
+
+        full_range = item.get('rangeset', [{}])[0]
+        bit_start = full_range.get('start', 0) + bit_offset
+        elem_width = full_range.get('width', 0) // count if count else 0
+
+        for i in range(count):
+            idx = start_idx + i
+            # Correctly handle indexed names like Ctype1, Ctype2
+            field_name = name_template.replace('<n>', str(idx))
+            fields.append({
+                'name': field_name,
+                'rangeset': [{
+                    'start': bit_start + (i * elem_width),
+                    'width': elem_width
+                }],
+                '_type': 'Fields.Field'
+            })
+        return fields
+
+    # ConditionalFields
+    elif _type == 'Fields.ConditionalField':
+        inner_offset = bit_offset
+        if item.get('rangeset'):
+            # Parent container defines the absolute start bit
+            inner_offset = item['rangeset'][0].get('start', bit_offset)
+
+        for entry in item.get('fields', []):
+            inner = entry.get('field')
+            if inner:
+                fields.extend(collect_fields(inner, inner_offset))
+        return fields
+
+    # Normal Field Types
+    leaf_types = ['Fields.Field', 'Fields.ConstantField',
+                  'Fields.EnumeratedField', 'Fields.Bitfield']
+    if _type in leaf_types:
+        field_copy = item.copy()
+        if field_copy.get('rangeset'):
+            new_ranges = []
+            for r in field_copy['rangeset']:
+                nr = r.copy()
+                # Apply the cumulative offset to the field's start bit
+                nr['start'] = r.get('start', 0) + bit_offset
+                new_ranges.append(nr)
+            field_copy['rangeset'] = new_ranges
+        fields.append(field_copy)
+        return fields
+
+    # Traverse the hierarchy for other cases
+    for key in ['fields', 'values', 'fieldsets']:
+        for nested in item.get(key, []):
+            fields.extend(collect_fields(nested, bit_offset))
+
+    return fields
+
+
+def generate_sysreg_properties_from_registers_json(id_reg_names, raw_json_path):
+    with open(raw_json_path, 'r') as f:
+        register_data = json.load(f)
+
+    regs = {r.get('name'): r for r in register_data if r.get('_type') == 'Register'}
+
+    final_output = ""
+
+    for reg_name in id_reg_names:
+        register = regs.get(reg_name)
+        if not register:
+            continue
+
+        final_output += f"IDREG_START({reg_name})\n"
+
+        unique_fields = {}
+        for fieldset in register.get('fieldsets', []):
+            candidates = collect_fields(fieldset)
+            for val in candidates:
+                name = (val.get('name') or val.get('label', '')).strip()
+                if not name or "RESERVED" in name.upper():
+                    continue
+                for r in val.get('rangeset', []):
+                    lsb = int(r.get('start'))
+                    width = r.get('width')
+                    msb = lsb + int(width) - 1
+
+                    # Only keep the fields with the highest MSB
+                    # needed fir CCSIDR_EL1
+                    if name not in unique_fields or msb > unique_fields[name]['msb']:
+                        unique_fields[name] = {'lsb': lsb, 'msb': msb, 'width': width}
+
+        # Sort decreasing lsbs
+        sorted_fields = sorted(unique_fields.items(),
+                               key=lambda x: x[1]['lsb'], reverse=True)
+
+        for name, bits in sorted_fields:
+            line = (f"    IDREG_FIELD({reg_name}, "
+                    f"{name}, {bits['lsb']}, {bits['width']})\n")
+            final_output += line
+        final_output += f"IDREG_END({reg_name})\n"
+        final_output += "\n"
+
+    os.makedirs("target/arm", exist_ok=True)
+    with open("target/arm/cpu-idregs.h.inc", 'w') as f:
+        f.write("/* AUTOMATICALLY GENERATED, DO NOT MODIFY */\n\n")
+        f.write("/* SPDX-License-Identifier: GPL-2.0-or-later */\n\n")
+        f.write("/* IDREG_START(REG) */\n")
+        f.write("/*     IDREG_FIELD(REG, FIELD, SHIFT, LENGTH) */\n")
+        f.write("/* ... */\n")
+        f.write("/* IDREG_END(REG) */\n\n")
+        f.write(final_output)
+
+if __name__ == "__main__":
+    if len(sys.argv) < 2:
+        print("Usage: python scripts/update-aarch64-cpu-sysreg-properties.py "
+              "<path_to_registers_json>")
+    else:
+        json_path = sys.argv[1]
+
+        id_regs_dict = extract_idregs_from_registers_json(json_path)
+        sorted_names = sorted(id_regs_dict.keys())
+
+        if sorted_names:
+            generate_sysreg_properties_from_registers_json(sorted_names, json_path)
+            print("Generated target/arm/cpu-idregs.h.inc")
-- 
2.53.0


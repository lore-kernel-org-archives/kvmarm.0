Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381D2397689
	for <kvmarm@lists.linux.dev>; Sun,  3 May 2026 07:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777793795; cv=none; b=KGiO4Bw+ACrPIVkN8pDYgqXGzzVPQveMFCOiZcriwgXliMbdLasq9h1RIplPltnoLHBtmUkkhAp8/62oEcRK4YwvxG6pC0AHFEgXn11SI2qEbpLCB40ekdr38Z7juThMEMFE5cRbCktIBGZ5yimt1zYS4W5tamS8xcVvT54kWto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777793795; c=relaxed/simple;
	bh=cLflK2mZa2V9jbOrLtkGsVhEeevIFUZPkwC4RFwYE9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=g8UAGiUF/LWrP01oZL0Aj8DAfCS5GU+Zxl7ZRFvY2AFdX+ryYYcmyUymGzkqAbre0iMPegZgXE1UgAWdNsWkQoKg8laWlUgldV5NpOAJn8UQt57CzhLmNzN6pGz1R+yxrPhRgnxT3BIdEZEYYIc7qs5Fh94LsOvm/LdzrMtz3CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z8s5v73D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z8s5v73D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777793793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IrtxNwMsLGHcglifoSdXz79E9LQx4QjnnRg4VVSyOzw=;
	b=Z8s5v73DaZ6u1uP8hoxfyak5bXaI8oPaB5lNihQcMQs26DKfi7JP+t2Pxohthohvov6Qsw
	FPJIHWbpzgNUnlnwHWRJof7bulQGB7hJikFt0qR0ocqYLNpyZCrms/GKiX8hkwG6/Yvnqb
	n9MkWoCeoyBSrT2oyY1ebPkLX7wWcY4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-189-dQLbM5VNNMCVizrvDQbp4w-1; Sun,
 03 May 2026 03:36:29 -0400
X-MC-Unique: dQLbM5VNNMCVizrvDQbp4w-1
X-Mimecast-MFC-AGG-ID: dQLbM5VNNMCVizrvDQbp4w_1777793788
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E10691800352;
	Sun,  3 May 2026 07:36:27 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.25])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 832D61800480;
	Sun,  3 May 2026 07:36:22 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	richard.henderson@linaro.org,
	cohuck@redhat.com,
	sebott@redhat.com,
	skolothumtho@nvidia.com,
	philmd@linaro.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Subject: [PATCH v4 06/17] scripts: Introduce scripts/update-aarch64-cpu-sysreg-properties.py
Date: Sun,  3 May 2026 09:33:26 +0200
Message-ID: <20260503073541.790215-7-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-1-eric.auger@redhat.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: lZ_VE9ApETBBYhepAyxqTYgUKoxxvukH5sxKc85V21M_1777793788
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Introduce a script that takes as input the Registers.json file
delivered in the AARCHMRS Features Model downloadable from the
Arm Developer A-Profile Architecture Exploration Tools page:
https://developer.arm.com/Architectures/A-Profile%20Architecture#Downloads
and automates the generation of system register properties definitions.

generates target/arm/cpu-sysreg-properties.c containing
definitions for feature ID registers.

We only care about IDregs with opcodes satisfying:
op0 = 3, op1 = {0,1,3}, crn = 0, crm within [0, 7], op2 within [0, 7]

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 .../update-aarch64-cpu-sysreg-properties.py   | 171 ++++++++++++++++++
 1 file changed, 171 insertions(+)
 create mode 100644 scripts/update-aarch64-cpu-sysreg-properties.py

diff --git a/scripts/update-aarch64-cpu-sysreg-properties.py b/scripts/update-aarch64-cpu-sysreg-properties.py
new file mode 100644
index 0000000000..603faa2c80
--- /dev/null
+++ b/scripts/update-aarch64-cpu-sysreg-properties.py
@@ -0,0 +1,171 @@
+#!/usr/bin/env python3
+
+# This script takes as input the Registers.json file delivered in
+# the AARCHMRS Features Model downloadable from the Arm Developer
+# A-Profile Architecture Exploration Tools page:
+# https://developer.arm.com/Architectures/A-Profile%20Architecture#Downloads
+# and outputs target/arm/cpu-sysreg-properties.c content.
+# There, initialize_cpu_sysreg_properties() populates arm64_id_regs array
+# with the name of each ID register and definition of all its fields
+# including their name and min/max bit under the form of the below pattern:
+#
+# /* CCSIDR2_EL1 */
+# ARM64SysReg *CCSIDR2_EL1 = arm64_sysreg_get(CCSIDR2_EL1_IDX);
+# CCSIDR2_EL1->name = "CCSIDR2_EL1";
+# arm64_sysreg_add_field(CCSIDR2_EL1, "NumSets", 0, 23);
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
+    # Go down the hierarchy for other cases
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
+        final_output += f"    /* {reg_name} */\n"
+        final_output += (f"    ARM64SysReg *{reg_name} = "
+                         f"arm64_sysreg_get({reg_name}_IDX);\n")
+        final_output += f"    {reg_name}->name = \"{reg_name}\";\n"
+
+        # Collect all fields
+        field_entries = []
+        for fieldset in register.get('fieldsets', []):
+            candidates = collect_fields(fieldset)
+            for val in candidates:
+                name = (val.get('name') or val.get('label', '')).strip()
+                if not name or "RESERVED" in name.upper():
+                    continue
+                for r in val.get('rangeset', []):
+                    lsb = int(r.get('start'))
+                    msb = lsb + int(r.get('width')) - 1
+                    field_entries.append({'name': name, 'lsb': lsb, 'msb': msb})
+
+        # Sort fields by lsb (decreasing order)
+        field_entries.sort(key=lambda x: x['lsb'], reverse=True)
+
+        seen_fields = set()
+        for entry in field_entries:
+            f_id = f"{entry['name']}_{entry['lsb']}_{entry['msb']}"
+            if f_id in seen_fields:
+                continue
+            seen_fields.add(f_id)
+
+            line = (f"    arm64_sysreg_add_field({reg_name}, "
+                    f"\"{entry['name']}\", {entry['lsb']}, {entry['msb']});\n")
+            final_output += line
+        final_output += "\n"
+
+    os.makedirs("target/arm", exist_ok=True)
+    with open("target/arm/cpu-sysreg-properties.c", 'w') as f:
+        f.write("/* AUTOMATICALLY GENERATED, DO NOT MODIFY */\n\n")
+        f.write("/* SPDX-License-Identifier: GPL-2.0-or-later */\n\n\n")
+        f.write("#include \"cpu-idregs.h\"\n\n")
+        f.write("ARM64SysReg arm64_id_regs[NUM_ID_IDX];\n\n")
+        f.write("void initialize_cpu_sysreg_properties(void)\n{\n")
+        f.write(final_output)
+        f.write("}\n")
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
+            print("Generated target/arm/cpu-sysreg-properties.c")
-- 
2.53.0


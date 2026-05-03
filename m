Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A0439B954
	for <kvmarm@lists.linux.dev>; Sun,  3 May 2026 07:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777793803; cv=none; b=LhYWbDTQn1qRBXchFvvLtNJ0lTA4pTu5RkxeClYqMVEWH1dfEY4f5RF0fWeXV4MDL68DnZ8hg1DypciPoRWqrTcNKgE9UnSnSa7b8wG5rk/ptPDt5Bfa+oWWtTWkjEgu9NFb+VMq2xo1d4qlzRyHwJmhawiSHMAfRupHkxCw5wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777793803; c=relaxed/simple;
	bh=XrnaHIqCa0lp9MjplgDUedQmgKiv5CSIOhI+VMt8sM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=rZH0XZ4JMKdEC/Ft3HADLt2jlW957w12bopELlfntlfWZZoWl4hTbLlmDmmHxAaRwQpWje2ZGKqe84vdMA+sQsfCRnkl2gxg4Iv/7Hc+UP2P7T3fsgOvQGlxu0lFec7dTGlvNOl1TC4OTxaksKqirQ4a3oNRZC3H/o0/Wa7xwlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K3+6utlh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K3+6utlh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777793799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R7XUxYpiQa+yShuVKhiNhtDdyRrT8DoihlKy8CNNBis=;
	b=K3+6utlhAIy+wUy0Bbzp74vA8KMr7aPBGctBftKi0JKPgaEMTCiwu9e72F8xe/k2vh6Np4
	pTYg1ihXkPC/dMy+Lsm6P8JCqhfeSriqsx62qbmBEr9I4L2SZE6HUW6u4yRj5oRwLswcy3
	PGKBcdC3+gTtQaa46gvRPZT/QUkgx0Y=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-360-iHTJXnYOMq-rMnZ4o1U4CA-1; Sun,
 03 May 2026 03:36:35 -0400
X-MC-Unique: iHTJXnYOMq-rMnZ4o1U4CA-1
X-Mimecast-MFC-AGG-ID: iHTJXnYOMq-rMnZ4o1U4CA_1777793794
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D6F4A1800473;
	Sun,  3 May 2026 07:36:33 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.25])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4A2651800345;
	Sun,  3 May 2026 07:36:28 +0000 (UTC)
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
Subject: [PATCH v4 07/17] target/arm/cpu-sysreg-properties.c: Generate code with new script
Date: Sun,  3 May 2026 09:33:27 +0200
Message-ID: <20260503073541.790215-8-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-1-eric.auger@redhat.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 6l15_7q2nKJ96FLlMMUR-mg5m1_g3LDpU98RCEX4RBg_1777793794
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Generate the code with scripts/update-aarch64-cpu-sysreg-properties.py
based on AARCHMRS_OPENSOURCE_A_profile_FAT-2026-03 Registers.json

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 .../update-aarch64-cpu-sysreg-properties.py   |  24 +-
 target/arm/cpu-sysreg-properties.c            | 663 +++++++++++++++++-
 2 files changed, 664 insertions(+), 23 deletions(-)

diff --git a/scripts/update-aarch64-cpu-sysreg-properties.py b/scripts/update-aarch64-cpu-sysreg-properties.py
index 603faa2c80..b13700e73d 100644
--- a/scripts/update-aarch64-cpu-sysreg-properties.py
+++ b/scripts/update-aarch64-cpu-sysreg-properties.py
@@ -92,7 +92,7 @@ def collect_fields(item, bit_offset=0):
         fields.append(field_copy)
         return fields
 
-    # Go down the hierarchy for other cases
+    # Traverse the hierarchy for other cases
     for key in ['fields', 'values', 'fieldsets']:
         for nested in item.get(key, []):
             fields.extend(collect_fields(nested, bit_offset))
@@ -118,8 +118,7 @@ def generate_sysreg_properties_from_registers_json(id_reg_names, raw_json_path):
                          f"arm64_sysreg_get({reg_name}_IDX);\n")
         final_output += f"    {reg_name}->name = \"{reg_name}\";\n"
 
-        # Collect all fields
-        field_entries = []
+        unique_fields = {}
         for fieldset in register.get('fieldsets', []):
             candidates = collect_fields(fieldset)
             for val in candidates:
@@ -129,20 +128,19 @@ def generate_sysreg_properties_from_registers_json(id_reg_names, raw_json_path):
                 for r in val.get('rangeset', []):
                     lsb = int(r.get('start'))
                     msb = lsb + int(r.get('width')) - 1
-                    field_entries.append({'name': name, 'lsb': lsb, 'msb': msb})
 
-        # Sort fields by lsb (decreasing order)
-        field_entries.sort(key=lambda x: x['lsb'], reverse=True)
+                    # Only keep the fields with the highest MSB
+                    # needed fir CCSIDR_EL1
+                    if name not in unique_fields or msb > unique_fields[name]['msb']:
+                        unique_fields[name] = {'lsb': lsb, 'msb': msb}
 
-        seen_fields = set()
-        for entry in field_entries:
-            f_id = f"{entry['name']}_{entry['lsb']}_{entry['msb']}"
-            if f_id in seen_fields:
-                continue
-            seen_fields.add(f_id)
+        # Sort decreasing lsbs
+        sorted_fields = sorted(unique_fields.items(),
+                               key=lambda x: x[1]['lsb'], reverse=True)
 
+        for name, bits in sorted_fields:
             line = (f"    arm64_sysreg_add_field({reg_name}, "
-                    f"\"{entry['name']}\", {entry['lsb']}, {entry['msb']});\n")
+                    f"\"{name}\", {bits['lsb']}, {bits['msb']});\n")
             final_output += line
         final_output += "\n"
 
diff --git a/target/arm/cpu-sysreg-properties.c b/target/arm/cpu-sysreg-properties.c
index 5cc06c8f24..4fd348557a 100644
--- a/target/arm/cpu-sysreg-properties.c
+++ b/target/arm/cpu-sysreg-properties.c
@@ -1,12 +1,7 @@
-/*
- * QEMU ARM CPU SYSREG PROPERTIES
- * will be automatically generated
- *
- * Copyright (c) Red Hat, Inc. 2026
- *
- */
+/* AUTOMATICALLY GENERATED, DO NOT MODIFY */
+
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 
- /* SPDX-License-Identifier: GPL-2.0-or-later */
 
 #include "cpu-idregs.h"
 
@@ -14,7 +9,44 @@ ARM64SysReg arm64_id_regs[NUM_ID_IDX];
 
 void initialize_cpu_sysreg_properties(void)
 {
-    memset(arm64_id_regs, 0, sizeof(ARM64SysReg) * NUM_ID_IDX);
+    /* AIDR_EL1 */
+    ARM64SysReg *AIDR_EL1 = arm64_sysreg_get(AIDR_EL1_IDX);
+    AIDR_EL1->name = "AIDR_EL1";
+
+    /* CCSIDR2_EL1 */
+    ARM64SysReg *CCSIDR2_EL1 = arm64_sysreg_get(CCSIDR2_EL1_IDX);
+    CCSIDR2_EL1->name = "CCSIDR2_EL1";
+    arm64_sysreg_add_field(CCSIDR2_EL1, "NumSets", 0, 23);
+
+    /* CCSIDR_EL1 */
+    ARM64SysReg *CCSIDR_EL1 = arm64_sysreg_get(CCSIDR_EL1_IDX);
+    CCSIDR_EL1->name = "CCSIDR_EL1";
+    arm64_sysreg_add_field(CCSIDR_EL1, "NumSets", 32, 55);
+    arm64_sysreg_add_field(CCSIDR_EL1, "Associativity", 3, 23);
+    arm64_sysreg_add_field(CCSIDR_EL1, "LineSize", 0, 2);
+
+    /* CLIDR_EL1 */
+    ARM64SysReg *CLIDR_EL1 = arm64_sysreg_get(CLIDR_EL1_IDX);
+    CLIDR_EL1->name = "CLIDR_EL1";
+    arm64_sysreg_add_field(CLIDR_EL1, "Ttype7", 45, 46);
+    arm64_sysreg_add_field(CLIDR_EL1, "Ttype6", 43, 44);
+    arm64_sysreg_add_field(CLIDR_EL1, "Ttype5", 41, 42);
+    arm64_sysreg_add_field(CLIDR_EL1, "Ttype4", 39, 40);
+    arm64_sysreg_add_field(CLIDR_EL1, "Ttype3", 37, 38);
+    arm64_sysreg_add_field(CLIDR_EL1, "Ttype2", 35, 36);
+    arm64_sysreg_add_field(CLIDR_EL1, "Ttype1", 33, 34);
+    arm64_sysreg_add_field(CLIDR_EL1, "ICB", 30, 32);
+    arm64_sysreg_add_field(CLIDR_EL1, "LoUU", 27, 29);
+    arm64_sysreg_add_field(CLIDR_EL1, "LoC", 24, 26);
+    arm64_sysreg_add_field(CLIDR_EL1, "LoUIS", 21, 23);
+    arm64_sysreg_add_field(CLIDR_EL1, "Ctype7", 18, 20);
+    arm64_sysreg_add_field(CLIDR_EL1, "Ctype6", 15, 17);
+    arm64_sysreg_add_field(CLIDR_EL1, "Ctype5", 12, 14);
+    arm64_sysreg_add_field(CLIDR_EL1, "Ctype4", 9, 11);
+    arm64_sysreg_add_field(CLIDR_EL1, "Ctype3", 6, 8);
+    arm64_sysreg_add_field(CLIDR_EL1, "Ctype2", 3, 5);
+    arm64_sysreg_add_field(CLIDR_EL1, "Ctype1", 0, 2);
+
     /* CTR_EL0 */
     ARM64SysReg *CTR_EL0 = arm64_sysreg_get(CTR_EL0_IDX);
     CTR_EL0->name = "CTR_EL0";
@@ -26,5 +58,616 @@ void initialize_cpu_sysreg_properties(void)
     arm64_sysreg_add_field(CTR_EL0, "DminLine", 16, 19);
     arm64_sysreg_add_field(CTR_EL0, "L1Ip", 14, 15);
     arm64_sysreg_add_field(CTR_EL0, "IminLine", 0, 3);
-}
 
+    /* DCZID_EL0 */
+    ARM64SysReg *DCZID_EL0 = arm64_sysreg_get(DCZID_EL0_IDX);
+    DCZID_EL0->name = "DCZID_EL0";
+    arm64_sysreg_add_field(DCZID_EL0, "TBS", 5, 8);
+    arm64_sysreg_add_field(DCZID_EL0, "DZP", 4, 4);
+    arm64_sysreg_add_field(DCZID_EL0, "BS", 0, 3);
+
+    /* GMID_EL1 */
+    ARM64SysReg *GMID_EL1 = arm64_sysreg_get(GMID_EL1_IDX);
+    GMID_EL1->name = "GMID_EL1";
+    arm64_sysreg_add_field(GMID_EL1, "BS", 0, 3);
+
+    /* ID_AA64AFR0_EL1 */
+    ARM64SysReg *ID_AA64AFR0_EL1 = arm64_sysreg_get(ID_AA64AFR0_EL1_IDX);
+    ID_AA64AFR0_EL1->name = "ID_AA64AFR0_EL1";
+
+    /* ID_AA64AFR1_EL1 */
+    ARM64SysReg *ID_AA64AFR1_EL1 = arm64_sysreg_get(ID_AA64AFR1_EL1_IDX);
+    ID_AA64AFR1_EL1->name = "ID_AA64AFR1_EL1";
+
+    /* ID_AA64DFR0_EL1 */
+    ARM64SysReg *ID_AA64DFR0_EL1 = arm64_sysreg_get(ID_AA64DFR0_EL1_IDX);
+    ID_AA64DFR0_EL1->name = "ID_AA64DFR0_EL1";
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "HPMN0", 60, 63);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "ExtTrcBuff", 56, 59);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "BRBE", 52, 55);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "MTPMU", 48, 51);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "TraceBuffer", 44, 47);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "TraceFilt", 40, 43);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "DoubleLock", 36, 39);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "PMSVer", 32, 35);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "CTX_CMPs", 28, 31);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "WRPs", 20, 23);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "PMSS", 16, 19);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "BRPs", 12, 15);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "PMUVer", 8, 11);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "TraceVer", 4, 7);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "DebugVer", 0, 3);
+
+    /* ID_AA64DFR1_EL1 */
+    ARM64SysReg *ID_AA64DFR1_EL1 = arm64_sysreg_get(ID_AA64DFR1_EL1_IDX);
+    ID_AA64DFR1_EL1->name = "ID_AA64DFR1_EL1";
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "ABL_CMPs", 56, 63);
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "DPFZS", 52, 55);
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "EBEP", 48, 51);
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "ITE", 44, 47);
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "ABLE", 40, 43);
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "PMICNTR", 36, 39);
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "SPMU", 32, 35);
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "CTX_CMPs", 24, 31);
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "WRPs", 16, 23);
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "BRPs", 8, 15);
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "SYSPMUID", 0, 7);
+
+    /* ID_AA64DFR2_EL1 */
+    ARM64SysReg *ID_AA64DFR2_EL1 = arm64_sysreg_get(ID_AA64DFR2_EL1_IDX);
+    ID_AA64DFR2_EL1->name = "ID_AA64DFR2_EL1";
+    arm64_sysreg_add_field(ID_AA64DFR2_EL1, "TRBE_EXC", 24, 27);
+    arm64_sysreg_add_field(ID_AA64DFR2_EL1, "SPE_nVM", 20, 23);
+    arm64_sysreg_add_field(ID_AA64DFR2_EL1, "SPE_EXC", 16, 19);
+    arm64_sysreg_add_field(ID_AA64DFR2_EL1, "BWE", 4, 7);
+    arm64_sysreg_add_field(ID_AA64DFR2_EL1, "STEP", 0, 3);
+
+    /* ID_AA64FPFR0_EL1 */
+    ARM64SysReg *ID_AA64FPFR0_EL1 = arm64_sysreg_get(ID_AA64FPFR0_EL1_IDX);
+    ID_AA64FPFR0_EL1->name = "ID_AA64FPFR0_EL1";
+    arm64_sysreg_add_field(ID_AA64FPFR0_EL1, "F8CVT", 31, 31);
+    arm64_sysreg_add_field(ID_AA64FPFR0_EL1, "F8FMA", 30, 30);
+    arm64_sysreg_add_field(ID_AA64FPFR0_EL1, "F8DP4", 29, 29);
+    arm64_sysreg_add_field(ID_AA64FPFR0_EL1, "F8DP2", 28, 28);
+    arm64_sysreg_add_field(ID_AA64FPFR0_EL1, "F8MM8", 27, 27);
+    arm64_sysreg_add_field(ID_AA64FPFR0_EL1, "F8MM4", 26, 26);
+    arm64_sysreg_add_field(ID_AA64FPFR0_EL1, "F16MM2", 15, 15);
+    arm64_sysreg_add_field(ID_AA64FPFR0_EL1, "F8E4M3", 1, 1);
+    arm64_sysreg_add_field(ID_AA64FPFR0_EL1, "F8E5M2", 0, 0);
+
+    /* ID_AA64ISAR0_EL1 */
+    ARM64SysReg *ID_AA64ISAR0_EL1 = arm64_sysreg_get(ID_AA64ISAR0_EL1_IDX);
+    ID_AA64ISAR0_EL1->name = "ID_AA64ISAR0_EL1";
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "RNDR", 60, 63);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "TLB", 56, 59);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "TS", 52, 55);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "FHM", 48, 51);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "DP", 44, 47);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "SM4", 40, 43);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "SM3", 36, 39);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "SHA3", 32, 35);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "RDM", 28, 31);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "Atomic", 20, 23);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "CRC32", 16, 19);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "SHA2", 12, 15);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "SHA1", 8, 11);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "AES", 4, 7);
+
+    /* ID_AA64ISAR1_EL1 */
+    ARM64SysReg *ID_AA64ISAR1_EL1 = arm64_sysreg_get(ID_AA64ISAR1_EL1_IDX);
+    ID_AA64ISAR1_EL1->name = "ID_AA64ISAR1_EL1";
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "LS64", 60, 63);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "XS", 56, 59);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "I8MM", 52, 55);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "DGH", 48, 51);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "BF16", 44, 47);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "SPECRES", 40, 43);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "SB", 36, 39);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "FRINTTS", 32, 35);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "GPI", 28, 31);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "GPA", 24, 27);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "LRCPC", 20, 23);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "FCMA", 16, 19);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "JSCVT", 12, 15);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "API", 8, 11);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "APA", 4, 7);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "DPB", 0, 3);
+
+    /* ID_AA64ISAR2_EL1 */
+    ARM64SysReg *ID_AA64ISAR2_EL1 = arm64_sysreg_get(ID_AA64ISAR2_EL1_IDX);
+    ID_AA64ISAR2_EL1->name = "ID_AA64ISAR2_EL1";
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "ATS1A", 60, 63);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "LUT", 56, 59);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "CSSC", 52, 55);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "RPRFM", 48, 51);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "PCDPHINT", 44, 47);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "PRFMSLC", 40, 43);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "SYSINSTR_128", 36, 39);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "SYSREG_128", 32, 35);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "CLRBHB", 28, 31);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "PAC_frac", 24, 27);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "BC", 20, 23);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "MOPS", 16, 19);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "APA3", 12, 15);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "GPA3", 8, 11);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "RPRES", 4, 7);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "WFxT", 0, 3);
+
+    /* ID_AA64ISAR3_EL1 */
+    ARM64SysReg *ID_AA64ISAR3_EL1 = arm64_sysreg_get(ID_AA64ISAR3_EL1_IDX);
+    ID_AA64ISAR3_EL1->name = "ID_AA64ISAR3_EL1";
+    arm64_sysreg_add_field(ID_AA64ISAR3_EL1, "LSCP", 44, 47);
+    arm64_sysreg_add_field(ID_AA64ISAR3_EL1, "LSCSHINT", 40, 43);
+    arm64_sysreg_add_field(ID_AA64ISAR3_EL1, "MTETC", 36, 39);
+    arm64_sysreg_add_field(ID_AA64ISAR3_EL1, "PAC_frac2", 32, 35);
+    arm64_sysreg_add_field(ID_AA64ISAR3_EL1, "FPRCVT", 28, 31);
+    arm64_sysreg_add_field(ID_AA64ISAR3_EL1, "LSUI", 24, 27);
+    arm64_sysreg_add_field(ID_AA64ISAR3_EL1, "OCCMO", 20, 23);
+    arm64_sysreg_add_field(ID_AA64ISAR3_EL1, "LSFE", 16, 19);
+    arm64_sysreg_add_field(ID_AA64ISAR3_EL1, "PACM", 12, 15);
+    arm64_sysreg_add_field(ID_AA64ISAR3_EL1, "TLBIW", 8, 11);
+    arm64_sysreg_add_field(ID_AA64ISAR3_EL1, "FAMINMAX", 4, 7);
+    arm64_sysreg_add_field(ID_AA64ISAR3_EL1, "CPA", 0, 3);
+
+    /* ID_AA64MMFR0_EL1 */
+    ARM64SysReg *ID_AA64MMFR0_EL1 = arm64_sysreg_get(ID_AA64MMFR0_EL1_IDX);
+    ID_AA64MMFR0_EL1->name = "ID_AA64MMFR0_EL1";
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "ECV", 60, 63);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "FGT", 56, 59);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "ExS", 44, 47);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "TGran4_2", 40, 43);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "TGran64_2", 36, 39);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "TGran16_2", 32, 35);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "TGran4", 28, 31);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "TGran64", 24, 27);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "TGran16", 20, 23);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "BigEndEL0", 16, 19);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "SNSMem", 12, 15);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "BigEnd", 8, 11);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "ASIDBits", 4, 7);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "PARange", 0, 3);
+
+    /* ID_AA64MMFR1_EL1 */
+    ARM64SysReg *ID_AA64MMFR1_EL1 = arm64_sysreg_get(ID_AA64MMFR1_EL1_IDX);
+    ID_AA64MMFR1_EL1->name = "ID_AA64MMFR1_EL1";
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "ECBHB", 60, 63);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "CMOW", 56, 59);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "TIDCP1", 52, 55);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "nTLBPA", 48, 51);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "AFP", 44, 47);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "HCX", 40, 43);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "ETS", 36, 39);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "TWED", 32, 35);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "XNX", 28, 31);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "SpecSEI", 24, 27);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "PAN", 20, 23);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "LO", 16, 19);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "HPDS", 12, 15);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "VH", 8, 11);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "VMIDBits", 4, 7);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "HAFDBS", 0, 3);
+
+    /* ID_AA64MMFR2_EL1 */
+    ARM64SysReg *ID_AA64MMFR2_EL1 = arm64_sysreg_get(ID_AA64MMFR2_EL1_IDX);
+    ID_AA64MMFR2_EL1->name = "ID_AA64MMFR2_EL1";
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "E0PD", 60, 63);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "EVT", 56, 59);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "BBM", 52, 55);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "TTL", 48, 51);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "FWB", 40, 43);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "IDS", 36, 39);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "AT", 32, 35);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "ST", 28, 31);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "NV", 24, 27);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "CCIDX", 20, 23);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "VARange", 16, 19);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "IESB", 12, 15);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "LSM", 8, 11);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "UAO", 4, 7);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "CnP", 0, 3);
+
+    /* ID_AA64MMFR3_EL1 */
+    ARM64SysReg *ID_AA64MMFR3_EL1 = arm64_sysreg_get(ID_AA64MMFR3_EL1_IDX);
+    ID_AA64MMFR3_EL1->name = "ID_AA64MMFR3_EL1";
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "Spec_FPACC", 60, 63);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "ADERR", 56, 59);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "SDERR", 52, 55);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "ANERR", 44, 47);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "SNERR", 40, 43);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "D128_2", 36, 39);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "D128", 32, 35);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "MEC", 28, 31);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "AIE", 24, 27);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "S2POE", 20, 23);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "S1POE", 16, 19);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "S2PIE", 12, 15);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "S1PIE", 8, 11);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "SCTLRX", 4, 7);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "TCRX", 0, 3);
+
+    /* ID_AA64MMFR4_EL1 */
+    ARM64SysReg *ID_AA64MMFR4_EL1 = arm64_sysreg_get(ID_AA64MMFR4_EL1_IDX);
+    ID_AA64MMFR4_EL1->name = "ID_AA64MMFR4_EL1";
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "MTEFGT", 60, 63);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "SCRX", 56, 59);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "TEV", 52, 55);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "TPS", 48, 51);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "SRMASK", 44, 47);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "TLBID", 40, 43);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "E3DSE", 36, 39);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "EAESR", 32, 35);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "RMEGDI", 28, 31);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "E2H0", 24, 27);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "NV_frac", 20, 23);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "FGWTE3", 16, 19);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "HACDBS", 12, 15);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "ASID2", 8, 11);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "EIESB", 4, 7);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "PoPS", 0, 3);
+
+    /* ID_AA64PFR0_EL1 */
+    ARM64SysReg *ID_AA64PFR0_EL1 = arm64_sysreg_get(ID_AA64PFR0_EL1_IDX);
+    ID_AA64PFR0_EL1->name = "ID_AA64PFR0_EL1";
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "CSV3", 60, 63);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "CSV2", 56, 59);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "RME", 52, 55);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "DIT", 48, 51);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "AMU", 44, 47);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "MPAM", 40, 43);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "SEL2", 36, 39);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "SVE", 32, 35);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "RAS", 28, 31);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "GIC", 24, 27);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "AdvSIMD", 20, 23);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "FP", 16, 19);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "EL3", 12, 15);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "EL2", 8, 11);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "EL1", 4, 7);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "EL0", 0, 3);
+
+    /* ID_AA64PFR1_EL1 */
+    ARM64SysReg *ID_AA64PFR1_EL1 = arm64_sysreg_get(ID_AA64PFR1_EL1_IDX);
+    ID_AA64PFR1_EL1->name = "ID_AA64PFR1_EL1";
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "PFAR", 60, 63);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "DF2", 56, 59);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "MTEX", 52, 55);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "THE", 48, 51);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "GCS", 44, 47);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "MTE_frac", 40, 43);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "NMI", 36, 39);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "CSV2_frac", 32, 35);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "RNDR_trap", 28, 31);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "SME", 24, 27);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "MPAM_frac", 16, 19);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "RAS_frac", 12, 15);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "MTE", 8, 11);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "SSBS", 4, 7);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "BT", 0, 3);
+
+    /* ID_AA64PFR2_EL1 */
+    ARM64SysReg *ID_AA64PFR2_EL1 = arm64_sysreg_get(ID_AA64PFR2_EL1_IDX);
+    ID_AA64PFR2_EL1->name = "ID_AA64PFR2_EL1";
+    arm64_sysreg_add_field(ID_AA64PFR2_EL1, "VMTETCL", 44, 47);
+    arm64_sysreg_add_field(ID_AA64PFR2_EL1, "VMTETC", 40, 43);
+    arm64_sysreg_add_field(ID_AA64PFR2_EL1, "VMTE", 36, 39);
+    arm64_sysreg_add_field(ID_AA64PFR2_EL1, "FPMR", 32, 35);
+    arm64_sysreg_add_field(ID_AA64PFR2_EL1, "MPAM2", 28, 31);
+    arm64_sysreg_add_field(ID_AA64PFR2_EL1, "FGDT", 24, 27);
+    arm64_sysreg_add_field(ID_AA64PFR2_EL1, "MTEEIRG", 20, 23);
+    arm64_sysreg_add_field(ID_AA64PFR2_EL1, "UINJ", 16, 19);
+    arm64_sysreg_add_field(ID_AA64PFR2_EL1, "GCIE", 12, 15);
+    arm64_sysreg_add_field(ID_AA64PFR2_EL1, "MTEFAR", 8, 11);
+    arm64_sysreg_add_field(ID_AA64PFR2_EL1, "MTESTOREONLY", 4, 7);
+    arm64_sysreg_add_field(ID_AA64PFR2_EL1, "MTEPERM", 0, 3);
+
+    /* ID_AA64SMFR0_EL1 */
+    ARM64SysReg *ID_AA64SMFR0_EL1 = arm64_sysreg_get(ID_AA64SMFR0_EL1_IDX);
+    ID_AA64SMFR0_EL1->name = "ID_AA64SMFR0_EL1";
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "FA64", 63, 63);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "LUT6", 61, 61);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "LUTv2", 60, 60);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "SMEver", 56, 59);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "I16I64", 52, 55);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "F64F64", 48, 48);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "I16I32", 44, 47);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "B16B16", 43, 43);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "F16F16", 42, 42);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "F8F16", 41, 41);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "F8F32", 40, 40);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "I8I32", 36, 39);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "F16F32", 35, 35);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "B16F32", 34, 34);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "BI32I32", 33, 33);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "F32F32", 32, 32);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "SF8FMA", 30, 30);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "SF8DP4", 29, 29);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "SF8DP2", 28, 28);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "SBitPerm", 25, 25);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "AES", 24, 24);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "SFEXPA", 23, 23);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "STMOP", 16, 16);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "SMOP4", 0, 0);
+
+    /* ID_AA64ZFR0_EL1 */
+    ARM64SysReg *ID_AA64ZFR0_EL1 = arm64_sysreg_get(ID_AA64ZFR0_EL1_IDX);
+    ID_AA64ZFR0_EL1->name = "ID_AA64ZFR0_EL1";
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "F64MM", 56, 59);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "F32MM", 52, 55);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "F16MM", 48, 51);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "I8MM", 44, 47);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "SM4", 40, 43);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "SHA3", 32, 35);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "B16B16", 24, 27);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "BF16", 20, 23);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "BitPerm", 16, 19);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "EltPerm", 12, 15);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "AES", 4, 7);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "SVEver", 0, 3);
+
+    /* ID_AFR0_EL1 */
+    ARM64SysReg *ID_AFR0_EL1 = arm64_sysreg_get(ID_AFR0_EL1_IDX);
+    ID_AFR0_EL1->name = "ID_AFR0_EL1";
+
+    /* ID_DFR0_EL1 */
+    ARM64SysReg *ID_DFR0_EL1 = arm64_sysreg_get(ID_DFR0_EL1_IDX);
+    ID_DFR0_EL1->name = "ID_DFR0_EL1";
+    arm64_sysreg_add_field(ID_DFR0_EL1, "TraceFilt", 28, 31);
+    arm64_sysreg_add_field(ID_DFR0_EL1, "PerfMon", 24, 27);
+    arm64_sysreg_add_field(ID_DFR0_EL1, "MProfDbg", 20, 23);
+    arm64_sysreg_add_field(ID_DFR0_EL1, "MMapTrc", 16, 19);
+    arm64_sysreg_add_field(ID_DFR0_EL1, "CopTrc", 12, 15);
+    arm64_sysreg_add_field(ID_DFR0_EL1, "MMapDbg", 8, 11);
+    arm64_sysreg_add_field(ID_DFR0_EL1, "CopSDbg", 4, 7);
+    arm64_sysreg_add_field(ID_DFR0_EL1, "CopDbg", 0, 3);
+
+    /* ID_DFR1_EL1 */
+    ARM64SysReg *ID_DFR1_EL1 = arm64_sysreg_get(ID_DFR1_EL1_IDX);
+    ID_DFR1_EL1->name = "ID_DFR1_EL1";
+    arm64_sysreg_add_field(ID_DFR1_EL1, "HPMN0", 4, 7);
+    arm64_sysreg_add_field(ID_DFR1_EL1, "MTPMU", 0, 3);
+
+    /* ID_ISAR0_EL1 */
+    ARM64SysReg *ID_ISAR0_EL1 = arm64_sysreg_get(ID_ISAR0_EL1_IDX);
+    ID_ISAR0_EL1->name = "ID_ISAR0_EL1";
+    arm64_sysreg_add_field(ID_ISAR0_EL1, "Divide", 24, 27);
+    arm64_sysreg_add_field(ID_ISAR0_EL1, "Debug", 20, 23);
+    arm64_sysreg_add_field(ID_ISAR0_EL1, "Coproc", 16, 19);
+    arm64_sysreg_add_field(ID_ISAR0_EL1, "CmpBranch", 12, 15);
+    arm64_sysreg_add_field(ID_ISAR0_EL1, "BitField", 8, 11);
+    arm64_sysreg_add_field(ID_ISAR0_EL1, "BitCount", 4, 7);
+    arm64_sysreg_add_field(ID_ISAR0_EL1, "Swap", 0, 3);
+
+    /* ID_ISAR1_EL1 */
+    ARM64SysReg *ID_ISAR1_EL1 = arm64_sysreg_get(ID_ISAR1_EL1_IDX);
+    ID_ISAR1_EL1->name = "ID_ISAR1_EL1";
+    arm64_sysreg_add_field(ID_ISAR1_EL1, "Jazelle", 28, 31);
+    arm64_sysreg_add_field(ID_ISAR1_EL1, "Interwork", 24, 27);
+    arm64_sysreg_add_field(ID_ISAR1_EL1, "Immediate", 20, 23);
+    arm64_sysreg_add_field(ID_ISAR1_EL1, "IfThen", 16, 19);
+    arm64_sysreg_add_field(ID_ISAR1_EL1, "Extend", 12, 15);
+    arm64_sysreg_add_field(ID_ISAR1_EL1, "Except_AR", 8, 11);
+    arm64_sysreg_add_field(ID_ISAR1_EL1, "Except", 4, 7);
+    arm64_sysreg_add_field(ID_ISAR1_EL1, "Endian", 0, 3);
+
+    /* ID_ISAR2_EL1 */
+    ARM64SysReg *ID_ISAR2_EL1 = arm64_sysreg_get(ID_ISAR2_EL1_IDX);
+    ID_ISAR2_EL1->name = "ID_ISAR2_EL1";
+    arm64_sysreg_add_field(ID_ISAR2_EL1, "Reversal", 28, 31);
+    arm64_sysreg_add_field(ID_ISAR2_EL1, "PSR_AR", 24, 27);
+    arm64_sysreg_add_field(ID_ISAR2_EL1, "MultU", 20, 23);
+    arm64_sysreg_add_field(ID_ISAR2_EL1, "MultS", 16, 19);
+    arm64_sysreg_add_field(ID_ISAR2_EL1, "Mult", 12, 15);
+    arm64_sysreg_add_field(ID_ISAR2_EL1, "MultiAccessInt", 8, 11);
+    arm64_sysreg_add_field(ID_ISAR2_EL1, "MemHint", 4, 7);
+    arm64_sysreg_add_field(ID_ISAR2_EL1, "LoadStore", 0, 3);
+
+    /* ID_ISAR3_EL1 */
+    ARM64SysReg *ID_ISAR3_EL1 = arm64_sysreg_get(ID_ISAR3_EL1_IDX);
+    ID_ISAR3_EL1->name = "ID_ISAR3_EL1";
+    arm64_sysreg_add_field(ID_ISAR3_EL1, "T32EE", 28, 31);
+    arm64_sysreg_add_field(ID_ISAR3_EL1, "TrueNOP", 24, 27);
+    arm64_sysreg_add_field(ID_ISAR3_EL1, "T32Copy", 20, 23);
+    arm64_sysreg_add_field(ID_ISAR3_EL1, "TabBranch", 16, 19);
+    arm64_sysreg_add_field(ID_ISAR3_EL1, "SynchPrim", 12, 15);
+    arm64_sysreg_add_field(ID_ISAR3_EL1, "SVC", 8, 11);
+    arm64_sysreg_add_field(ID_ISAR3_EL1, "SIMD", 4, 7);
+    arm64_sysreg_add_field(ID_ISAR3_EL1, "Saturate", 0, 3);
+
+    /* ID_ISAR4_EL1 */
+    ARM64SysReg *ID_ISAR4_EL1 = arm64_sysreg_get(ID_ISAR4_EL1_IDX);
+    ID_ISAR4_EL1->name = "ID_ISAR4_EL1";
+    arm64_sysreg_add_field(ID_ISAR4_EL1, "SWP_frac", 28, 31);
+    arm64_sysreg_add_field(ID_ISAR4_EL1, "PSR_M", 24, 27);
+    arm64_sysreg_add_field(ID_ISAR4_EL1, "SynchPrim_frac", 20, 23);
+    arm64_sysreg_add_field(ID_ISAR4_EL1, "Barrier", 16, 19);
+    arm64_sysreg_add_field(ID_ISAR4_EL1, "SMC", 12, 15);
+    arm64_sysreg_add_field(ID_ISAR4_EL1, "Writeback", 8, 11);
+    arm64_sysreg_add_field(ID_ISAR4_EL1, "WithShifts", 4, 7);
+    arm64_sysreg_add_field(ID_ISAR4_EL1, "Unpriv", 0, 3);
+
+    /* ID_ISAR5_EL1 */
+    ARM64SysReg *ID_ISAR5_EL1 = arm64_sysreg_get(ID_ISAR5_EL1_IDX);
+    ID_ISAR5_EL1->name = "ID_ISAR5_EL1";
+    arm64_sysreg_add_field(ID_ISAR5_EL1, "VCMA", 28, 31);
+    arm64_sysreg_add_field(ID_ISAR5_EL1, "RDM", 24, 27);
+    arm64_sysreg_add_field(ID_ISAR5_EL1, "CRC32", 16, 19);
+    arm64_sysreg_add_field(ID_ISAR5_EL1, "SHA2", 12, 15);
+    arm64_sysreg_add_field(ID_ISAR5_EL1, "SHA1", 8, 11);
+    arm64_sysreg_add_field(ID_ISAR5_EL1, "AES", 4, 7);
+    arm64_sysreg_add_field(ID_ISAR5_EL1, "SEVL", 0, 3);
+
+    /* ID_ISAR6_EL1 */
+    ARM64SysReg *ID_ISAR6_EL1 = arm64_sysreg_get(ID_ISAR6_EL1_IDX);
+    ID_ISAR6_EL1->name = "ID_ISAR6_EL1";
+    arm64_sysreg_add_field(ID_ISAR6_EL1, "CLRBHB", 28, 31);
+    arm64_sysreg_add_field(ID_ISAR6_EL1, "I8MM", 24, 27);
+    arm64_sysreg_add_field(ID_ISAR6_EL1, "BF16", 20, 23);
+    arm64_sysreg_add_field(ID_ISAR6_EL1, "SPECRES", 16, 19);
+    arm64_sysreg_add_field(ID_ISAR6_EL1, "SB", 12, 15);
+    arm64_sysreg_add_field(ID_ISAR6_EL1, "FHM", 8, 11);
+    arm64_sysreg_add_field(ID_ISAR6_EL1, "DP", 4, 7);
+    arm64_sysreg_add_field(ID_ISAR6_EL1, "JSCVT", 0, 3);
+
+    /* ID_MMFR0_EL1 */
+    ARM64SysReg *ID_MMFR0_EL1 = arm64_sysreg_get(ID_MMFR0_EL1_IDX);
+    ID_MMFR0_EL1->name = "ID_MMFR0_EL1";
+    arm64_sysreg_add_field(ID_MMFR0_EL1, "InnerShr", 28, 31);
+    arm64_sysreg_add_field(ID_MMFR0_EL1, "FCSE", 24, 27);
+    arm64_sysreg_add_field(ID_MMFR0_EL1, "AuxReg", 20, 23);
+    arm64_sysreg_add_field(ID_MMFR0_EL1, "TCM", 16, 19);
+    arm64_sysreg_add_field(ID_MMFR0_EL1, "ShareLvl", 12, 15);
+    arm64_sysreg_add_field(ID_MMFR0_EL1, "OuterShr", 8, 11);
+    arm64_sysreg_add_field(ID_MMFR0_EL1, "PMSA", 4, 7);
+    arm64_sysreg_add_field(ID_MMFR0_EL1, "VMSA", 0, 3);
+
+    /* ID_MMFR1_EL1 */
+    ARM64SysReg *ID_MMFR1_EL1 = arm64_sysreg_get(ID_MMFR1_EL1_IDX);
+    ID_MMFR1_EL1->name = "ID_MMFR1_EL1";
+    arm64_sysreg_add_field(ID_MMFR1_EL1, "BPred", 28, 31);
+    arm64_sysreg_add_field(ID_MMFR1_EL1, "L1TstCln", 24, 27);
+    arm64_sysreg_add_field(ID_MMFR1_EL1, "L1Uni", 20, 23);
+    arm64_sysreg_add_field(ID_MMFR1_EL1, "L1Hvd", 16, 19);
+    arm64_sysreg_add_field(ID_MMFR1_EL1, "L1UniSW", 12, 15);
+    arm64_sysreg_add_field(ID_MMFR1_EL1, "L1HvdSW", 8, 11);
+    arm64_sysreg_add_field(ID_MMFR1_EL1, "L1UniVA", 4, 7);
+    arm64_sysreg_add_field(ID_MMFR1_EL1, "L1HvdVA", 0, 3);
+
+    /* ID_MMFR2_EL1 */
+    ARM64SysReg *ID_MMFR2_EL1 = arm64_sysreg_get(ID_MMFR2_EL1_IDX);
+    ID_MMFR2_EL1->name = "ID_MMFR2_EL1";
+    arm64_sysreg_add_field(ID_MMFR2_EL1, "HWAccFlg", 28, 31);
+    arm64_sysreg_add_field(ID_MMFR2_EL1, "WFIStall", 24, 27);
+    arm64_sysreg_add_field(ID_MMFR2_EL1, "MemBarr", 20, 23);
+    arm64_sysreg_add_field(ID_MMFR2_EL1, "UniTLB", 16, 19);
+    arm64_sysreg_add_field(ID_MMFR2_EL1, "HvdTLB", 12, 15);
+    arm64_sysreg_add_field(ID_MMFR2_EL1, "L1HvdRng", 8, 11);
+    arm64_sysreg_add_field(ID_MMFR2_EL1, "L1HvdBG", 4, 7);
+    arm64_sysreg_add_field(ID_MMFR2_EL1, "L1HvdFG", 0, 3);
+
+    /* ID_MMFR3_EL1 */
+    ARM64SysReg *ID_MMFR3_EL1 = arm64_sysreg_get(ID_MMFR3_EL1_IDX);
+    ID_MMFR3_EL1->name = "ID_MMFR3_EL1";
+    arm64_sysreg_add_field(ID_MMFR3_EL1, "Supersec", 28, 31);
+    arm64_sysreg_add_field(ID_MMFR3_EL1, "CMemSz", 24, 27);
+    arm64_sysreg_add_field(ID_MMFR3_EL1, "CohWalk", 20, 23);
+    arm64_sysreg_add_field(ID_MMFR3_EL1, "PAN", 16, 19);
+    arm64_sysreg_add_field(ID_MMFR3_EL1, "MaintBcst", 12, 15);
+    arm64_sysreg_add_field(ID_MMFR3_EL1, "BPMaint", 8, 11);
+    arm64_sysreg_add_field(ID_MMFR3_EL1, "CMaintSW", 4, 7);
+    arm64_sysreg_add_field(ID_MMFR3_EL1, "CMaintVA", 0, 3);
+
+    /* ID_MMFR4_EL1 */
+    ARM64SysReg *ID_MMFR4_EL1 = arm64_sysreg_get(ID_MMFR4_EL1_IDX);
+    ID_MMFR4_EL1->name = "ID_MMFR4_EL1";
+    arm64_sysreg_add_field(ID_MMFR4_EL1, "EVT", 28, 31);
+    arm64_sysreg_add_field(ID_MMFR4_EL1, "CCIDX", 24, 27);
+    arm64_sysreg_add_field(ID_MMFR4_EL1, "LSM", 20, 23);
+    arm64_sysreg_add_field(ID_MMFR4_EL1, "HPDS", 16, 19);
+    arm64_sysreg_add_field(ID_MMFR4_EL1, "CnP", 12, 15);
+    arm64_sysreg_add_field(ID_MMFR4_EL1, "XNX", 8, 11);
+    arm64_sysreg_add_field(ID_MMFR4_EL1, "AC2", 4, 7);
+    arm64_sysreg_add_field(ID_MMFR4_EL1, "SpecSEI", 0, 3);
+
+    /* ID_MMFR5_EL1 */
+    ARM64SysReg *ID_MMFR5_EL1 = arm64_sysreg_get(ID_MMFR5_EL1_IDX);
+    ID_MMFR5_EL1->name = "ID_MMFR5_EL1";
+    arm64_sysreg_add_field(ID_MMFR5_EL1, "nTLBPA", 4, 7);
+    arm64_sysreg_add_field(ID_MMFR5_EL1, "ETS", 0, 3);
+
+    /* ID_PFR0_EL1 */
+    ARM64SysReg *ID_PFR0_EL1 = arm64_sysreg_get(ID_PFR0_EL1_IDX);
+    ID_PFR0_EL1->name = "ID_PFR0_EL1";
+    arm64_sysreg_add_field(ID_PFR0_EL1, "RAS", 28, 31);
+    arm64_sysreg_add_field(ID_PFR0_EL1, "DIT", 24, 27);
+    arm64_sysreg_add_field(ID_PFR0_EL1, "AMU", 20, 23);
+    arm64_sysreg_add_field(ID_PFR0_EL1, "CSV2", 16, 19);
+    arm64_sysreg_add_field(ID_PFR0_EL1, "State3", 12, 15);
+    arm64_sysreg_add_field(ID_PFR0_EL1, "State2", 8, 11);
+    arm64_sysreg_add_field(ID_PFR0_EL1, "State1", 4, 7);
+    arm64_sysreg_add_field(ID_PFR0_EL1, "State0", 0, 3);
+
+    /* ID_PFR1_EL1 */
+    ARM64SysReg *ID_PFR1_EL1 = arm64_sysreg_get(ID_PFR1_EL1_IDX);
+    ID_PFR1_EL1->name = "ID_PFR1_EL1";
+    arm64_sysreg_add_field(ID_PFR1_EL1, "GIC", 28, 31);
+    arm64_sysreg_add_field(ID_PFR1_EL1, "Virt_frac", 24, 27);
+    arm64_sysreg_add_field(ID_PFR1_EL1, "Sec_frac", 20, 23);
+    arm64_sysreg_add_field(ID_PFR1_EL1, "GenTimer", 16, 19);
+    arm64_sysreg_add_field(ID_PFR1_EL1, "Virtualization", 12, 15);
+    arm64_sysreg_add_field(ID_PFR1_EL1, "MProgMod", 8, 11);
+    arm64_sysreg_add_field(ID_PFR1_EL1, "Security", 4, 7);
+    arm64_sysreg_add_field(ID_PFR1_EL1, "ProgMod", 0, 3);
+
+    /* ID_PFR2_EL1 */
+    ARM64SysReg *ID_PFR2_EL1 = arm64_sysreg_get(ID_PFR2_EL1_IDX);
+    ID_PFR2_EL1->name = "ID_PFR2_EL1";
+    arm64_sysreg_add_field(ID_PFR2_EL1, "RAS_frac", 8, 11);
+    arm64_sysreg_add_field(ID_PFR2_EL1, "SSBS", 4, 7);
+    arm64_sysreg_add_field(ID_PFR2_EL1, "CSV3", 0, 3);
+
+    /* MIDR_EL1 */
+    ARM64SysReg *MIDR_EL1 = arm64_sysreg_get(MIDR_EL1_IDX);
+    MIDR_EL1->name = "MIDR_EL1";
+    arm64_sysreg_add_field(MIDR_EL1, "Implementer", 24, 31);
+    arm64_sysreg_add_field(MIDR_EL1, "Variant", 20, 23);
+    arm64_sysreg_add_field(MIDR_EL1, "Architecture", 16, 19);
+    arm64_sysreg_add_field(MIDR_EL1, "PartNum", 4, 15);
+    arm64_sysreg_add_field(MIDR_EL1, "Revision", 0, 3);
+
+    /* MPIDR_EL1 */
+    ARM64SysReg *MPIDR_EL1 = arm64_sysreg_get(MPIDR_EL1_IDX);
+    MPIDR_EL1->name = "MPIDR_EL1";
+    arm64_sysreg_add_field(MPIDR_EL1, "Aff3", 32, 39);
+    arm64_sysreg_add_field(MPIDR_EL1, "U", 30, 30);
+    arm64_sysreg_add_field(MPIDR_EL1, "MT", 24, 24);
+    arm64_sysreg_add_field(MPIDR_EL1, "Aff2", 16, 23);
+    arm64_sysreg_add_field(MPIDR_EL1, "Aff1", 8, 15);
+    arm64_sysreg_add_field(MPIDR_EL1, "Aff0", 0, 7);
+
+    /* MVFR0_EL1 */
+    ARM64SysReg *MVFR0_EL1 = arm64_sysreg_get(MVFR0_EL1_IDX);
+    MVFR0_EL1->name = "MVFR0_EL1";
+    arm64_sysreg_add_field(MVFR0_EL1, "FPRound", 28, 31);
+    arm64_sysreg_add_field(MVFR0_EL1, "FPShVec", 24, 27);
+    arm64_sysreg_add_field(MVFR0_EL1, "FPSqrt", 20, 23);
+    arm64_sysreg_add_field(MVFR0_EL1, "FPDivide", 16, 19);
+    arm64_sysreg_add_field(MVFR0_EL1, "FPTrap", 12, 15);
+    arm64_sysreg_add_field(MVFR0_EL1, "FPDP", 8, 11);
+    arm64_sysreg_add_field(MVFR0_EL1, "FPSP", 4, 7);
+    arm64_sysreg_add_field(MVFR0_EL1, "SIMDReg", 0, 3);
+
+    /* MVFR1_EL1 */
+    ARM64SysReg *MVFR1_EL1 = arm64_sysreg_get(MVFR1_EL1_IDX);
+    MVFR1_EL1->name = "MVFR1_EL1";
+    arm64_sysreg_add_field(MVFR1_EL1, "SIMDFMAC", 28, 31);
+    arm64_sysreg_add_field(MVFR1_EL1, "FPHP", 24, 27);
+    arm64_sysreg_add_field(MVFR1_EL1, "SIMDHP", 20, 23);
+    arm64_sysreg_add_field(MVFR1_EL1, "SIMDSP", 16, 19);
+    arm64_sysreg_add_field(MVFR1_EL1, "SIMDInt", 12, 15);
+    arm64_sysreg_add_field(MVFR1_EL1, "SIMDLS", 8, 11);
+    arm64_sysreg_add_field(MVFR1_EL1, "FPDNaN", 4, 7);
+    arm64_sysreg_add_field(MVFR1_EL1, "FPFtZ", 0, 3);
+
+    /* MVFR2_EL1 */
+    ARM64SysReg *MVFR2_EL1 = arm64_sysreg_get(MVFR2_EL1_IDX);
+    MVFR2_EL1->name = "MVFR2_EL1";
+    arm64_sysreg_add_field(MVFR2_EL1, "FPMisc", 4, 7);
+    arm64_sysreg_add_field(MVFR2_EL1, "SIMDMisc", 0, 3);
+
+    /* REVIDR_EL1 */
+    ARM64SysReg *REVIDR_EL1 = arm64_sysreg_get(REVIDR_EL1_IDX);
+    REVIDR_EL1->name = "REVIDR_EL1";
+
+    /* SMIDR_EL1 */
+    ARM64SysReg *SMIDR_EL1 = arm64_sysreg_get(SMIDR_EL1_IDX);
+    SMIDR_EL1->name = "SMIDR_EL1";
+    arm64_sysreg_add_field(SMIDR_EL1, "NSMC", 56, 59);
+    arm64_sysreg_add_field(SMIDR_EL1, "HIP", 52, 55);
+    arm64_sysreg_add_field(SMIDR_EL1, "Affinity2", 32, 51);
+    arm64_sysreg_add_field(SMIDR_EL1, "Implementer", 24, 31);
+    arm64_sysreg_add_field(SMIDR_EL1, "Revision", 16, 23);
+    arm64_sysreg_add_field(SMIDR_EL1, "SMPS", 15, 15);
+    arm64_sysreg_add_field(SMIDR_EL1, "SH", 13, 14);
+    arm64_sysreg_add_field(SMIDR_EL1, "Affinity", 0, 11);
+
+}
-- 
2.53.0


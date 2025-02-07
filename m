Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361861A5B9F
	for <kvmarm@lists.linux.dev>; Fri,  7 Feb 2025 11:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738926396; cv=none; b=HrspO00k/vVec1zUJwzTNyP5cBKKZ0a1NJv0he/tDM5ExlTdQBsIV74sJwZuJYJ9WTvEKmI+Bkuh5GE2mdczrXJQYFF8dSiDIOfJGbjcm60/agxqfL0+JAOJg1z/gQo95ItLhbZAa+U1oKYw2bFlFukepQA7AB+BxOic8FNm900=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738926396; c=relaxed/simple;
	bh=9Vqcj8mzQwZ5VO+erkrHvxiktL5qUk4Yew5EvbRnliU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=ZCj1BLNtSISH2SzPgB5sFDFDTxf62NGViHqXXCe2WwvpUAJzF28yHI/imkO1RwGBAwbg86IJ+kb7ngZtleOfFAgWXMDeKWwnJd5FQ5BAimmoTyO5kcy02Hbygl3duT+SaqK1Z0jlt+pm6NGi9jJD/PZzo5l4ZgCQsljRQJrKvcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ELipN9el; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ELipN9el"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738926394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xuIB+L3qwG1C9pTC4cPxYXDJRfNndff7DnumNnne86A=;
	b=ELipN9elR/ZNi3gOIe9FOpyESJkQSXNkM3AksY4ufN1slSivzJhT46STuWS1B/CUVOd9o2
	M9LssJJW17a59Jlc1p0EdS+dYxlOxCa32szlkj6BN8Wpw3Fnc0IxUIgJ7dnoUUGuOQR1Z1
	nh+IqB6rqaHFim7GAEEQ032Mgy0RHcA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-repOt5p4M-uBjDzuCchDgg-1; Fri,
 07 Feb 2025 06:06:30 -0500
X-MC-Unique: repOt5p4M-uBjDzuCchDgg-1
X-Mimecast-MFC-AGG-ID: repOt5p4M-uBjDzuCchDgg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A16F91800877;
	Fri,  7 Feb 2025 11:06:28 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.67.24.130])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DEA3B19560A3;
	Fri,  7 Feb 2025 11:06:14 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	sebott@redhat.com,
	shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Cc: shahuang@redhat.com,
	mark.rutland@arm.com,
	philmd@linaro.org,
	pbonzini@redhat.com,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH 13/15] arm/cpu: Add infra to handle generated ID register definitions
Date: Fri,  7 Feb 2025 12:02:46 +0100
Message-ID: <20250207110248.1580465-14-cohuck@redhat.com>
In-Reply-To: <20250207110248.1580465-1-cohuck@redhat.com>
References: <20250207110248.1580465-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

From: Eric Auger <eric.auger@redhat.com>

The known ID regs are described in a new initialization function
dubbed initialize_cpu_sysreg_properties(). That code will be
automatically generated from linux arch/arm64/tools/sysreg. For the
time being let's just describe a single id reg, CTR_EL0. In this
description we only care about non RES/RAZ fields, ie. named fields.

The registers are populated in an array indexed by ARMIDRegisterIdx
and their fields are added in a sorted list.

[CH: adapted to reworked register storage]
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/cpu-custom.h            | 55 ++++++++++++++++++++++++++++++
 target/arm/cpu-sysreg-properties.c | 41 ++++++++++++++++++++++
 target/arm/cpu64.c                 |  2 ++
 target/arm/meson.build             |  1 +
 4 files changed, 99 insertions(+)
 create mode 100644 target/arm/cpu-custom.h
 create mode 100644 target/arm/cpu-sysreg-properties.c

diff --git a/target/arm/cpu-custom.h b/target/arm/cpu-custom.h
new file mode 100644
index 000000000000..17533765dacd
--- /dev/null
+++ b/target/arm/cpu-custom.h
@@ -0,0 +1,55 @@
+#ifndef ARM_CPU_CUSTOM_H
+#define ARM_CPU_CUSTOM_H
+
+#include "qemu/osdep.h"
+#include "qemu/error-report.h"
+#include "cpu.h"
+#include "cpu-sysregs.h"
+
+typedef struct ARM64SysRegField {
+    const char *name; /* name of the field, for instance CTR_EL0_IDC */
+    int index;
+    int lower;
+    int upper;
+} ARM64SysRegField;
+
+typedef struct ARM64SysReg {
+    const char *name;   /* name of the sysreg, for instance CTR_EL0 */
+    ARMSysRegs sysreg;
+    int index;
+    GList *fields; /* list of named fields, excluding RES* */
+} ARM64SysReg;
+
+void initialize_cpu_sysreg_properties(void);
+
+/*
+ * List of exposed ID regs (automatically populated from linux
+ * arch/arm64/tools/sysreg)
+ */
+extern ARM64SysReg arm64_id_regs[NUM_ID_IDX];
+
+/* Allocate a new field and insert it at the head of the @reg list */
+static inline GList *arm64_sysreg_add_field(ARM64SysReg *reg, const char *name,
+                                     uint8_t min, uint8_t max) {
+
+     ARM64SysRegField *field = g_new0(ARM64SysRegField, 1);
+
+     field->name = name;
+     field->lower = min;
+     field->upper = max;
+     field->index = reg->index;
+
+     reg->fields = g_list_append(reg->fields, field);
+     return reg->fields;
+}
+
+static inline ARM64SysReg *arm64_sysreg_get(ARMIDRegisterIdx index)
+{
+        ARM64SysReg *reg = &arm64_id_regs[index];
+
+        reg->index = index;
+        reg->sysreg = id_register_sysreg[index];
+        return reg;
+}
+
+#endif
diff --git a/target/arm/cpu-sysreg-properties.c b/target/arm/cpu-sysreg-properties.c
new file mode 100644
index 000000000000..8b7ef5badfb9
--- /dev/null
+++ b/target/arm/cpu-sysreg-properties.c
@@ -0,0 +1,41 @@
+/*
+ * QEMU ARM CPU SYSREG PROPERTIES
+ * to be generated from linux sysreg
+ *
+ * Copyright (c) Red Hat, Inc. 2024
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see
+ * <http://www.gnu.org/licenses/gpl-2.0.html>
+ */
+
+#include "cpu-custom.h"
+
+ARM64SysReg arm64_id_regs[NUM_ID_IDX];
+
+void initialize_cpu_sysreg_properties(void)
+{
+    memset(arm64_id_regs, 0, sizeof(ARM64SysReg) * NUM_ID_IDX);
+    /* CTR_EL0 */
+    ARM64SysReg *CTR_EL0 = arm64_sysreg_get(CTR_EL0_IDX);
+    CTR_EL0->name = "CTR_EL0";
+    arm64_sysreg_add_field(CTR_EL0, "TminLine", 32, 37);
+    arm64_sysreg_add_field(CTR_EL0, "DIC", 29, 29);
+    arm64_sysreg_add_field(CTR_EL0, "IDC", 28, 28);
+    arm64_sysreg_add_field(CTR_EL0, "CWG", 24, 27);
+    arm64_sysreg_add_field(CTR_EL0, "ERG", 20, 23);
+    arm64_sysreg_add_field(CTR_EL0, "DminLine", 16, 19);
+    arm64_sysreg_add_field(CTR_EL0, "L1Ip", 14, 15);
+    arm64_sysreg_add_field(CTR_EL0, "IminLine", 0, 3);
+}
+
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index beba1733c99f..8371aabce5f4 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -35,6 +35,7 @@
 #include "internals.h"
 #include "cpu-features.h"
 #include "cpregs.h"
+#include "cpu-custom.h"
 
 void arm_cpu_sve_finalize(ARMCPU *cpu, Error **errp)
 {
@@ -894,6 +895,7 @@ static void aarch64_cpu_register_types(void)
 {
     size_t i;
 
+    initialize_cpu_sysreg_properties();
     type_register_static(&aarch64_cpu_type_info);
 
     for (i = 0; i < ARRAY_SIZE(aarch64_cpus); ++i) {
diff --git a/target/arm/meson.build b/target/arm/meson.build
index 2e10464dbb6b..9c7a04ee1b26 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -14,6 +14,7 @@ arm_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
   'cpu64.c',
   'gdbstub64.c',
+  'cpu-sysreg-properties.c',
 ))
 
 arm_system_ss = ss.source_set()
-- 
2.48.1


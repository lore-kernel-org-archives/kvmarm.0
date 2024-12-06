Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49611FC7E9
	for <kvmarm@lists.linux.dev>; Fri,  6 Dec 2024 11:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733484233; cv=none; b=do/eQbBggeRMufLyHJR0PQ+PjDvQPo8u7rD9hV9tiAoJlkiBMpm3hGHhxHBDnGanWhvP1bkoGcXxVWpC80YwSEmF3A2AvjA/4e5dqPbKaKZeh6qsodiEgI7NlGNu6Kwv7iS6VWxLBXf3jmPt7+bxcmwiQ8Jl4C8doEx7+au7zFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733484233; c=relaxed/simple;
	bh=mzop2BoDmT+7eneRl2r6TB+W69U7BZJ3ImDnroZfMzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=UfBWEYsub/ZgHo0GAhFmij2jl8mxhUP1zpscYgHM6HfbTKlv6wgzGIcR2i0keKWRD7af3uqhX63cTChR6wo7fG6e57JR/nJZ1PzdM4IM6Ba61J3f/uAPLMSOMmCTaydySVkJzCYURFDo+V2F9w5bycS3Hewqt1tRJxIqM4yz3hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MmAr+/fU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MmAr+/fU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733484231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=deHT9KFNSb9UoJgsypIWs/wdH54gBPOkPmXGG5yU7us=;
	b=MmAr+/fUdTQ27yyEjENKUUtI3M20DYMzOqzTOOeHeF0Y6n1Ud4Lcl7oyVtTsG6z2ezi29M
	YM3+uax70JE8fbu9AIT/P/kUvmP8bC5YZmG7J1bA33U3z6dN97bbKPis7MXkBZhN8J9MtD
	GKgilYt3jeIM0xdKa9rGJtMEpgNI4pI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-528-ZY7CdZ0UOUKNi-AHsyd5Rg-1; Fri,
 06 Dec 2024 06:23:47 -0500
X-MC-Unique: ZY7CdZ0UOUKNi-AHsyd5Rg-1
X-Mimecast-MFC-AGG-ID: ZY7CdZ0UOUKNi-AHsyd5Rg
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ABDA31954ADC;
	Fri,  6 Dec 2024 11:23:45 +0000 (UTC)
Received: from gondolin.str.redhat.com (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F19C219560A2;
	Fri,  6 Dec 2024 11:23:39 +0000 (UTC)
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
Subject: [PATCH RFCv2 13/20] arm/cpu: Add infra to handle generated ID register definitions
Date: Fri,  6 Dec 2024 12:22:06 +0100
Message-ID: <20241206112213.88394-14-cohuck@redhat.com>
In-Reply-To: <20241206112213.88394-1-cohuck@redhat.com>
References: <20241206112213.88394-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Eric Auger <eric.auger@redhat.com>

The known ID regs are described in a new initialization function
dubbed initialize_cpu_sysreg_properties(). That code will be
automatically generated from linux arch/arm64/tools/sysreg. For the
time being let's just describe a single id reg, CTR_EL0. In this
description we only care about non RES/RAZ fields, ie. named fields.

The registers are populated in a 3x8x8 array and their fields are
added in a sorted list.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/cpu-custom.h            | 58 ++++++++++++++++++++++++++++++
 target/arm/cpu-sysreg-properties.c | 41 +++++++++++++++++++++
 target/arm/cpu64.c                 |  2 ++
 target/arm/meson.build             |  1 +
 4 files changed, 102 insertions(+)
 create mode 100644 target/arm/cpu-custom.h
 create mode 100644 target/arm/cpu-sysreg-properties.c

diff --git a/target/arm/cpu-custom.h b/target/arm/cpu-custom.h
new file mode 100644
index 000000000000..1952095bf7b8
--- /dev/null
+++ b/target/arm/cpu-custom.h
@@ -0,0 +1,58 @@
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
+    ARMSysReg *sysreg;
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
+extern ARM64SysReg arm64_id_regs[NR_ID_REGS];
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
+static inline ARM64SysReg *
+arm64_sysreg_get(int op0, int op1, int crn, int crm, int op2)
+{
+        uint64_t index = ARM_FEATURE_ID_RANGE_IDX(op0, op1, crn, crm, op2);
+        ARM64SysReg *reg = &arm64_id_regs[index];
+
+        reg->index = index;
+        reg->sysreg = g_new(ARMSysReg, 1);
+        *reg->sysreg = sys_reg(op0, op1, crn, crm, op2);
+        return reg;
+}
+
+#endif
diff --git a/target/arm/cpu-sysreg-properties.c b/target/arm/cpu-sysreg-properties.c
new file mode 100644
index 000000000000..7e6b9f526d32
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
+ARM64SysReg arm64_id_regs[NR_ID_REGS];
+
+void initialize_cpu_sysreg_properties(void)
+{
+    memset(arm64_id_regs, 0, sizeof(ARM64SysReg) * NR_ID_REGS);
+    /* CTR_EL0 */
+    ARM64SysReg *CTR_EL0 = arm64_sysreg_get(3, 3, 0, 0, 1);
+    CTR_EL0->name = "CTR_EL0";
+    arm64_sysreg_add_field(CTR_EL0, "TMinline", 32, 37);
+    arm64_sysreg_add_field(CTR_EL0, "DIC", 29, 29);
+    arm64_sysreg_add_field(CTR_EL0, "IDC", 28, 28);
+    arm64_sysreg_add_field(CTR_EL0, "CWG", 24, 27);
+    arm64_sysreg_add_field(CTR_EL0, "ERG", 20, 23);
+    arm64_sysreg_add_field(CTR_EL0, "DMinLine", 16, 19);
+    arm64_sysreg_add_field(CTR_EL0, "L1Ip", 14, 15);
+    arm64_sysreg_add_field(CTR_EL0, "IminLine", 0, 3);
+}
+
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index efc930ff8367..29558cda8186 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -35,6 +35,7 @@
 #include "internals.h"
 #include "cpu-features.h"
 #include "cpregs.h"
+#include "cpu-custom.h"
 
 void arm_cpu_sve_finalize(ARMCPU *cpu, Error **errp)
 {
@@ -851,6 +852,7 @@ static void aarch64_cpu_register_types(void)
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
2.47.0


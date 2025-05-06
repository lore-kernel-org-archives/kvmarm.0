Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0712E22FDF1
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 08:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746521585; cv=none; b=nzdLddmmh00CAql75lJUkeeoK4PiaISlhPArBLMjwFsugj7+qHAeWJVSL/C37NiUfJq4sCfggA/iw/pEhyZXDZIImdURSyd0FLlK72G3iCDMAK3ka6vX6uwfD352IbHBGyJrmfJvo5G/CwROH5rv1cb3PBSAeZ0MFURgQFcbssg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746521585; c=relaxed/simple;
	bh=raKC2oVmUFYn5csGKTYSlRyZphhKruSgO3XLtHa0qJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=P5eZRlVXBvmVyQQndYnefI3OdcHxXwKF0YtU13wOkMk9v8HZ+I/emWoUsYubSSMwwMB8l3d4cgagPR7rCpoXKjBH70JyT/jDPkezmcqKaOj+bzyFjoNPnZvpMbO5MXxwdOBh34DDYT/wdY4J99+CoiWLR5+e37FKr/vRyDuqiOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PN2Wq8s8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PN2Wq8s8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746521582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cWu7yhYIg9S184N2EXrIfnRJVOqujOAgsuFW5TuwvUw=;
	b=PN2Wq8s8f/r/wU5rsXoIbx9N79Zz8WYHlLpOqVXFmzpLq2a1GGAzXdp3Lf5DOlKDe0WrTI
	nlU+9Jb1rQbTRqOW0Uy1HkIXwXzCi/ZYhTrR8GAylMOCQqncMt42rf/m4YbENmAiIGQgln
	v0FegO0AOhNhDs6mY5Teg981GJ8ppyU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-433-vkuPirWzPuSS_ScRwUtVXg-1; Tue,
 06 May 2025 04:52:59 -0400
X-MC-Unique: vkuPirWzPuSS_ScRwUtVXg-1
X-Mimecast-MFC-AGG-ID: vkuPirWzPuSS_ScRwUtVXg_1746521578
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A279C1801A04;
	Tue,  6 May 2025 08:52:57 +0000 (UTC)
Received: from gondolin.str.redhat.com (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BE9E819560AB;
	Tue,  6 May 2025 08:52:46 +0000 (UTC)
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
	jdenemar@redhat.com,
	agraf@csgraf.de
Cc: shahuang@redhat.com,
	mark.rutland@arm.com,
	philmd@linaro.org,
	pbonzini@redhat.com,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v6 01/14] arm/cpu: Add sysreg definitions in cpu-sysregs.h
Date: Tue,  6 May 2025 10:52:21 +0200
Message-ID: <20250506085234.855779-2-cohuck@redhat.com>
In-Reply-To: <20250506085234.855779-1-cohuck@redhat.com>
References: <20250506085234.855779-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

From: Eric Auger <eric.auger@redhat.com>

This new header contains macros that define aarch64 registers.
In a subsequent patch, this will be replaced by a more exhaustive
version that will be generated from linux arch/arm64/tools/sysreg
file. Those macros are sufficient to migrate the storage of those
ID regs from named fields in isar struct to an array cell.

[CH: reworked to use different structures]
[CH: moved accessors from the patches first using them to here,
     dropped interaction with writable registers, which will happen
     later]
[CH: use DEF magic suggested by rth]
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/cpu-sysregs.h     | 42 +++++++++++++++++++++++++++++++
 target/arm/cpu-sysregs.h.inc | 35 ++++++++++++++++++++++++++
 target/arm/cpu.h             | 49 ++++++++++++++++++++++++++++++++++++
 target/arm/cpu64.c           | 22 ++++++++++++++++
 4 files changed, 148 insertions(+)
 create mode 100644 target/arm/cpu-sysregs.h
 create mode 100644 target/arm/cpu-sysregs.h.inc

diff --git a/target/arm/cpu-sysregs.h b/target/arm/cpu-sysregs.h
new file mode 100644
index 000000000000..7877a3b06a8e
--- /dev/null
+++ b/target/arm/cpu-sysregs.h
@@ -0,0 +1,42 @@
+/*
+ * Definitions for Arm ID system registers
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+#ifndef ARM_CPU_SYSREGS_H
+#define ARM_CPU_SYSREGS_H
+
+/*
+ * Following is similar to the coprocessor regs encodings, but with an argument
+ * ordering that matches the ARM ARM. We also reuse the various CP_REG_ defines
+ * that actually are the same as the equivalent KVM_REG_ values.
+ */
+#define ENCODE_ID_REG(op0, op1, crn, crm, op2)          \
+    (((op0) << CP_REG_ARM64_SYSREG_OP0_SHIFT) |         \
+     ((op1) << CP_REG_ARM64_SYSREG_OP1_SHIFT) |         \
+     ((crn) << CP_REG_ARM64_SYSREG_CRN_SHIFT) |         \
+     ((crm) << CP_REG_ARM64_SYSREG_CRM_SHIFT) |         \
+     ((op2) << CP_REG_ARM64_SYSREG_OP2_SHIFT))
+
+#define DEF(NAME, OP0, OP1, CRN, CRM, OP2) NAME##_IDX,
+
+typedef enum ARMIDRegisterIdx {
+#include "cpu-sysregs.h.inc"
+    NUM_ID_IDX,
+} ARMIDRegisterIdx;
+
+#undef DEF
+#define DEF(NAME, OP0, OP1, CRN, CRM, OP2) \
+    SYS_##NAME = ENCODE_ID_REG(OP0, OP1, CRN, CRM, OP2),
+
+typedef enum ARMSysRegs {
+#include "cpu-sysregs.h.inc"
+} ARMSysRegs;
+
+#undef DEF
+
+extern const uint32_t id_register_sysreg[NUM_ID_IDX];
+
+int get_sysreg_idx(ARMSysRegs sysreg);
+
+#endif /* ARM_CPU_SYSREGS_H */
diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
new file mode 100644
index 000000000000..6c9f9981cc5d
--- /dev/null
+++ b/target/arm/cpu-sysregs.h.inc
@@ -0,0 +1,35 @@
+DEF(ID_AA64PFR0_EL1, 3, 0, 0, 4, 0)
+DEF(ID_AA64PFR1_EL1, 3, 0, 0, 4, 1)
+DEF(ID_AA64SMFR0_EL1, 3, 0, 0, 4, 5)
+DEF(ID_AA64DFR0_EL1, 3, 0, 0, 5, 0)
+DEF(ID_AA64DFR1_EL1, 3, 0, 0, 5, 1)
+DEF(ID_AA64ISAR0_EL1, 3, 0, 0, 6, 0)
+DEF(ID_AA64ISAR1_EL1, 3, 0, 0, 6, 1)
+DEF(ID_AA64ISAR2_EL1, 3, 0, 0, 6, 2)
+DEF(ID_AA64MMFR0_EL1, 3, 0, 0, 7, 0)
+DEF(ID_AA64MMFR1_EL1, 3, 0, 0, 7, 1)
+DEF(ID_AA64MMFR2_EL1, 3, 0, 0, 7, 2)
+DEF(ID_AA64MMFR3_EL1, 3, 0, 0, 7, 3)
+DEF(ID_PFR0_EL1, 3, 0, 0, 1, 0)
+DEF(ID_PFR1_EL1, 3, 0, 0, 1, 1)
+DEF(ID_DFR0_EL1, 3, 0, 0, 1, 2)
+DEF(ID_MMFR0_EL1, 3, 0, 0, 1, 4)
+DEF(ID_MMFR1_EL1, 3, 0, 0, 1, 5)
+DEF(ID_MMFR2_EL1, 3, 0, 0, 1, 6)
+DEF(ID_MMFR3_EL1, 3, 0, 0, 1, 7)
+DEF(ID_ISAR0_EL1, 3, 0, 0, 2, 0)
+DEF(ID_ISAR1_EL1, 3, 0, 0, 2, 1)
+DEF(ID_ISAR2_EL1, 3, 0, 0, 2, 2)
+DEF(ID_ISAR3_EL1, 3, 0, 0, 2, 3)
+DEF(ID_ISAR4_EL1, 3, 0, 0, 2, 4)
+DEF(ID_ISAR5_EL1, 3, 0, 0, 2, 5)
+DEF(ID_MMFR4_EL1, 3, 0, 0, 2, 6)
+DEF(ID_ISAR6_EL1, 3, 0, 0, 2, 7)
+DEF(MVFR0_EL1, 3, 0, 0, 3, 0)
+DEF(MVFR1_EL1, 3, 0, 0, 3, 1)
+DEF(MVFR2_EL1, 3, 0, 0, 3, 2)
+DEF(ID_PFR2_EL1, 3, 0, 0, 3, 4)
+DEF(ID_DFR1_EL1, 3, 0, 0, 3, 5)
+DEF(ID_MMFR5_EL1, 3, 0, 0, 3, 6)
+DEF(ID_AA64ZFR0_EL1, 3, 0, 0, 4, 4)
+DEF(CTR_EL0, 3, 3, 0, 0, 1)
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index fdcf8cd1ae00..2b1b46475b13 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -32,6 +32,7 @@
 #include "qapi/qapi-types-common.h"
 #include "target/arm/multiprocessing.h"
 #include "target/arm/gtimer.h"
+#include "target/arm/cpu-sysregs.h"
 
 #define EXCP_UDEF            1   /* undefined instruction */
 #define EXCP_SWI             2   /* software interrupt */
@@ -837,6 +838,53 @@ typedef struct {
     uint32_t map, init, supported;
 } ARMVQMap;
 
+/* REG is ID_XXX */
+#define FIELD_DP64_IDREG(ISAR, REG, FIELD, VALUE)                       \
+    ({                                                                  \
+        ARMISARegisters *i_ = (ISAR);                                   \
+        uint64_t regval = i_->idregs[REG ## _EL1_IDX];                  \
+        regval = FIELD_DP64(regval, REG, FIELD, VALUE);                 \
+        i_->idregs[REG ## _EL1_IDX] = regval;                           \
+    })
+
+#define FIELD_DP32_IDREG(ISAR, REG, FIELD, VALUE)                       \
+    ({                                                                  \
+        ARMISARegisters *i_ = (ISAR);                                   \
+        uint64_t regval = i_->idregs[REG ## _EL1_IDX];                  \
+        regval = FIELD_DP32(regval, REG, FIELD, VALUE);                 \
+        i_->idregs[REG ## _EL1_IDX] = regval;                           \
+    })
+
+#define FIELD_EX64_IDREG(ISAR, REG, FIELD)                              \
+    ({                                                                  \
+        const ARMISARegisters *i_ = (ISAR);                             \
+        FIELD_EX64(i_->idregs[REG ## _EL1_IDX], REG, FIELD);            \
+    })
+
+#define FIELD_EX32_IDREG(ISAR, REG, FIELD)                              \
+    ({                                                                  \
+        const ARMISARegisters *i_ = (ISAR);                             \
+        FIELD_EX32(i_->idregs[REG ## _EL1_IDX], REG, FIELD);            \
+    })
+
+#define FIELD_SEX64_IDREG(ISAR, REG, FIELD)                             \
+    ({                                                                  \
+        const ARMISARegisters *i_ = (ISAR);                             \
+        FIELD_SEX64(i_->idregs[REG ## _EL1_IDX], REG, FIELD);           \
+    })
+
+#define SET_IDREG(ISAR, REG, VALUE)                                     \
+    ({                                                                  \
+        ARMISARegisters *i_ = (ISAR);                                   \
+        i_->idregs[REG ## _EL1_IDX] = VALUE;                            \
+    })
+
+#define GET_IDREG(ISAR, REG)                                            \
+    ({                                                                  \
+        const ARMISARegisters *i_ = (ISAR);                             \
+        i_->idregs[REG ## _EL1_IDX];                                    \
+    })
+
 /**
  * ARMCPU:
  * @env: #CPUARMState
@@ -1043,6 +1091,7 @@ struct ArchCPU {
         uint64_t id_aa64zfr0;
         uint64_t id_aa64smfr0;
         uint64_t reset_pmcr_el0;
+        uint64_t idregs[NUM_ID_IDX];
     } isar;
     uint64_t midr;
     uint32_t revidr;
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 00629a5d1d11..e3fdff92c1b4 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -36,6 +36,28 @@
 #include "cpu-features.h"
 #include "cpregs.h"
 
+/* convert between <register>_IDX and SYS_<register> */
+#define DEF(NAME, OP0, OP1, CRN, CRM, OP2)      \
+    [NAME##_IDX] = SYS_##NAME,
+
+const uint32_t id_register_sysreg[NUM_ID_IDX] = {
+#include "cpu-sysregs.h.inc"
+};
+
+#undef DEF
+#define DEF(NAME, OP0, OP1, CRN, CRM, OP2) \
+    case SYS_##NAME: return NAME##_IDX;
+
+int get_sysreg_idx(ARMSysRegs sysreg)
+{
+    switch (sysreg) {
+#include "cpu-sysregs.h.inc"
+    }
+    g_assert_not_reached();
+}
+
+#undef DEF
+
 void arm_cpu_sve_finalize(ARMCPU *cpu, Error **errp)
 {
     /*
-- 
2.49.0


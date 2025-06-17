Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4771F2EA487
	for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 15:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174801; cv=none; b=o9Wh+o/ayWCl/lFMQJnvKXiGeOHyx7hQicps99kHEJsn+Qh8tnQiM2+Rtmc4iyPO8WhSA8HY1ljEqZd/oiny/YgEnebmxwTEbmP5p0btzMOuJ0HojleINbC4OHDjieH4hzE2klgL/MxhcFz9gGeDNU07TUdbPS2YnMl+Vd5EW9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174801; c=relaxed/simple;
	bh=ZMX4bYR8mh5XvRklZNnH2E7wsE3+kp8EbSDfxBUD3PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=bXNAWwxTvj8vl/XK1+FPKdi4lETNN+EPSKtSNd0kIprn/IIn2z1Xpj8Q88D+XNesFBEU3dAvFi+sczlAqZK03+Ll3oeedhCjoGCw7hFzgBytyiFh6pqeEjVXKQjCRSXuWNeycIOzHhSP5GV657QBXMcWDjmyXjSb90WHsZhPp5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SJjOYTTL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SJjOYTTL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750174797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YaN6kB6+OE48wfdUHDtzjrqOVvauOnH0tktOv818dOg=;
	b=SJjOYTTLKh5VeefK8d2mczM8clfDU57ZhTE5WDfwEwLdfmnHGo5QqGqZMpXOHKkjKa3zBd
	DgG/9/FbLSg3ACj7bU4ev4gNlyDcV3sYz1VUEhKuTZ6VDO2duYsMOIrgsKksF3upBxl4sP
	gEn0OqDMx5GbKAQJkpX2KWO3lbOrBVs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-250-ul8Sf7A3MfSQbqSQp0mERw-1; Tue,
 17 Jun 2025 11:39:53 -0400
X-MC-Unique: ul8Sf7A3MfSQbqSQp0mERw-1
X-Mimecast-MFC-AGG-ID: ul8Sf7A3MfSQbqSQp0mERw_1750174791
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 879351800291;
	Tue, 17 Jun 2025 15:39:50 +0000 (UTC)
Received: from gondolin.str.redhat.com (pixel-6a.str.redhat.com [10.33.192.205])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 29D61180045B;
	Tue, 17 Jun 2025 15:39:43 +0000 (UTC)
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
Subject: [PATCH v8 01/14] arm/cpu: Add sysreg definitions in cpu-sysregs.h
Date: Tue, 17 Jun 2025 17:39:18 +0200
Message-ID: <20250617153931.1330449-2-cohuck@redhat.com>
In-Reply-To: <20250617153931.1330449-1-cohuck@redhat.com>
References: <20250617153931.1330449-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

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
 target/arm/cpu-sysregs.h.inc | 36 ++++++++++++++++++++++++++
 target/arm/cpu.h             | 49 ++++++++++++++++++++++++++++++++++++
 target/arm/cpu64.c           | 22 ++++++++++++++++
 4 files changed, 149 insertions(+)
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
index 000000000000..cb99286f7048
--- /dev/null
+++ b/target/arm/cpu-sysregs.h.inc
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
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
index 302c24e2324a..45409f84ef0f 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -32,6 +32,7 @@
 #include "qapi/qapi-types-common.h"
 #include "target/arm/multiprocessing.h"
 #include "target/arm/gtimer.h"
+#include "target/arm/cpu-sysregs.h"
 
 #define EXCP_UDEF            1   /* undefined instruction */
 #define EXCP_SWI             2   /* software interrupt */
@@ -834,6 +835,53 @@ typedef struct {
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
@@ -1040,6 +1088,7 @@ struct ArchCPU {
         uint64_t id_aa64zfr0;
         uint64_t id_aa64smfr0;
         uint64_t reset_pmcr_el0;
+        uint64_t idregs[NUM_ID_IDX];
     } isar;
     uint64_t midr;
     uint32_t revidr;
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 200da1c489b8..77054e0ec384 100644
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


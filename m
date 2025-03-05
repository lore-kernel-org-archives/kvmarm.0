Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D1125524A
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 16:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741192758; cv=none; b=q2jPNKO4kegQLCQ7xFXkl8mm1e/pWLJ2WIn+wpdDtU8cX2mFYWe8HL2vrhIZiccZoMDpmt3fYch+72Fre8i7m6hM6aeW9M87QXIll+PuFEKvtNi13zffJ4L12bQni4e9ZZ/XQGZ+hu4don0zijZUs0PASgGYsDPfFxg20n2pqE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741192758; c=relaxed/simple;
	bh=ymodjDMDFRcw6bYmI9LUEdAngRyI8u1fubLgtYg84Ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=dKpOTuP6WGhA800LhzILvOwghCj+VG/FjDULxLJV1AkY1cDmO0t4d7Qu/rFegVy0u90ota4ARMkFFimp+kJO5DmsDhQr3O3eJD/t0KE4c2qxWaWz+K1mZ7Lkw5wf7unZGThuMTZHD1CRONboHnciIFkKPdkSr0WYw4WXA4Bd6hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OKlLQc+D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OKlLQc+D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741192754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uUMQo/GFhIlPaJmbc9/NlgRu5qpMaVzUrYJkVynXBuE=;
	b=OKlLQc+D1td1Dk9ZcHdkT5NiazLFhZcAqJXzBPQtmihlFnzTcS5db5wO2DvE5t2B8GQdsp
	HuEvIPhyIxqNaAk3QWQOtewZD+v6rirmCYkBMabCWAoYtDH/lFwk+QGUoQEDqtcH1Zokws
	XbD1qzsX82be3wywuWQ5XYwzStaIx8I=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-331-cFv40QY9ORCkMCGynlov0A-1; Wed,
 05 Mar 2025 11:39:01 -0500
X-MC-Unique: cFv40QY9ORCkMCGynlov0A-1
X-Mimecast-MFC-AGG-ID: cFv40QY9ORCkMCGynlov0A_1741192739
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E3C0218001DB;
	Wed,  5 Mar 2025 16:38:58 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.67.24.9])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 738131956095;
	Wed,  5 Mar 2025 16:38:42 +0000 (UTC)
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
Subject: [PATCH v2 01/14] arm/cpu: Add sysreg definitions in cpu-sysregs.h
Date: Wed,  5 Mar 2025 17:38:06 +0100
Message-ID: <20250305163819.2477553-2-cohuck@redhat.com>
In-Reply-To: <20250305163819.2477553-1-cohuck@redhat.com>
References: <20250305163819.2477553-1-cohuck@redhat.com>
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
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/cpu-sysregs.h | 131 +++++++++++++++++++++++++++++++++++++++
 target/arm/cpu.h         |  49 +++++++++++++++
 2 files changed, 180 insertions(+)
 create mode 100644 target/arm/cpu-sysregs.h

diff --git a/target/arm/cpu-sysregs.h b/target/arm/cpu-sysregs.h
new file mode 100644
index 000000000000..de09ebae91a5
--- /dev/null
+++ b/target/arm/cpu-sysregs.h
@@ -0,0 +1,131 @@
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
+typedef enum ARMIDRegisterIdx {
+    ID_AA64PFR0_EL1_IDX,
+    ID_AA64PFR1_EL1_IDX,
+    ID_AA64SMFR0_EL1_IDX,
+    ID_AA64DFR0_EL1_IDX,
+    ID_AA64DFR1_EL1_IDX,
+    ID_AA64ISAR0_EL1_IDX,
+    ID_AA64ISAR1_EL1_IDX,
+    ID_AA64ISAR2_EL1_IDX,
+    ID_AA64MMFR0_EL1_IDX,
+    ID_AA64MMFR1_EL1_IDX,
+    ID_AA64MMFR2_EL1_IDX,
+    ID_AA64MMFR3_EL1_IDX,
+    ID_PFR0_EL1_IDX,
+    ID_PFR1_EL1_IDX,
+    ID_DFR0_EL1_IDX,
+    ID_MMFR0_EL1_IDX,
+    ID_MMFR1_EL1_IDX,
+    ID_MMFR2_EL1_IDX,
+    ID_MMFR3_EL1_IDX,
+    ID_ISAR0_EL1_IDX,
+    ID_ISAR1_EL1_IDX,
+    ID_ISAR2_EL1_IDX,
+    ID_ISAR3_EL1_IDX,
+    ID_ISAR4_EL1_IDX,
+    ID_ISAR5_EL1_IDX,
+    ID_MMFR4_EL1_IDX,
+    ID_ISAR6_EL1_IDX,
+    MVFR0_EL1_IDX,
+    MVFR1_EL1_IDX,
+    MVFR2_EL1_IDX,
+    ID_PFR2_EL1_IDX,
+    ID_DFR1_EL1_IDX,
+    ID_MMFR5_EL1_IDX,
+    ID_AA64ZFR0_EL1_IDX,
+    CTR_EL0_IDX,
+    NUM_ID_IDX,
+} ARMIDRegisterIdx;
+
+typedef enum ARMSysRegs {
+    SYS_ID_AA64PFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 4, 0),
+    SYS_ID_AA64PFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 4, 1),
+    SYS_ID_AA64SMFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 4, 5),
+    SYS_ID_AA64DFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 5, 0),
+    SYS_ID_AA64DFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 5, 1),
+    SYS_ID_AA64ISAR0_EL1 = ENCODE_ID_REG(3, 0, 0, 6, 0),
+    SYS_ID_AA64ISAR1_EL1 = ENCODE_ID_REG(3, 0, 0, 6, 1),
+    SYS_ID_AA64ISAR2_EL1 = ENCODE_ID_REG(3, 0, 0, 6, 2),
+    SYS_ID_AA64MMFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 7, 0),
+    SYS_ID_AA64MMFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 7, 1),
+    SYS_ID_AA64MMFR2_EL1 = ENCODE_ID_REG(3, 0, 0, 7, 2),
+    SYS_ID_AA64MMFR3_EL1 = ENCODE_ID_REG(3, 0, 0, 7, 3),
+    SYS_ID_PFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 0),
+    SYS_ID_PFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 1),
+    SYS_ID_DFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 2),
+    SYS_ID_MMFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 4),
+    SYS_ID_MMFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 5),
+    SYS_ID_MMFR2_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 6),
+    SYS_ID_MMFR3_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 7),
+    SYS_ID_ISAR0_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 0),
+    SYS_ID_ISAR1_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 1),
+    SYS_ID_ISAR2_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 2),
+    SYS_ID_ISAR3_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 3),
+    SYS_ID_ISAR4_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 4),
+    SYS_ID_ISAR5_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 5),
+    SYS_ID_MMFR4_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 6),
+    SYS_ID_ISAR6_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 7),
+    SYS_MVFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 0),
+    SYS_MVFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 1),
+    SYS_MVFR2_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 2),
+    SYS_ID_PFR2_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 4),
+    SYS_ID_DFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 5),
+    SYS_ID_MMFR5_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 6),
+    SYS_ID_AA64ZFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 4, 4),
+    SYS_CTR_EL0 = ENCODE_ID_REG(3, 3, 0, 0, 1),
+} ARMSysRegs;
+
+static const uint32_t id_register_sysreg[NUM_ID_IDX] = {
+    [ID_AA64PFR0_EL1_IDX] = SYS_ID_AA64PFR0_EL1,
+    [ID_AA64PFR1_EL1_IDX] = SYS_ID_AA64PFR1_EL1,
+    [ID_AA64SMFR0_EL1_IDX] = SYS_ID_AA64SMFR0_EL1,
+    [ID_AA64DFR0_EL1_IDX] = SYS_ID_AA64DFR0_EL1,
+    [ID_AA64DFR1_EL1_IDX] = SYS_ID_AA64DFR1_EL1,
+    [ID_AA64ISAR0_EL1_IDX] = SYS_ID_AA64ISAR0_EL1,
+    [ID_AA64ISAR1_EL1_IDX] = SYS_ID_AA64ISAR1_EL1,
+    [ID_AA64ISAR2_EL1_IDX] = SYS_ID_AA64ISAR2_EL1,
+    [ID_AA64MMFR0_EL1_IDX] = SYS_ID_AA64MMFR0_EL1,
+    [ID_AA64MMFR1_EL1_IDX] = SYS_ID_AA64MMFR1_EL1,
+    [ID_AA64MMFR2_EL1_IDX] = SYS_ID_AA64MMFR2_EL1,
+    [ID_AA64MMFR3_EL1_IDX] = SYS_ID_AA64MMFR3_EL1,
+    [ID_PFR0_EL1_IDX] = SYS_ID_PFR0_EL1,
+    [ID_PFR1_EL1_IDX] = SYS_ID_PFR1_EL1,
+    [ID_DFR0_EL1_IDX] = SYS_ID_DFR0_EL1,
+    [ID_MMFR0_EL1_IDX] = SYS_ID_MMFR0_EL1,
+    [ID_MMFR1_EL1_IDX] = SYS_ID_MMFR1_EL1,
+    [ID_MMFR2_EL1_IDX] = SYS_ID_MMFR2_EL1,
+    [ID_MMFR3_EL1_IDX] = SYS_ID_MMFR3_EL1,
+    [ID_ISAR0_EL1_IDX] = SYS_ID_ISAR0_EL1,
+    [ID_ISAR1_EL1_IDX] = SYS_ID_ISAR1_EL1,
+    [ID_ISAR2_EL1_IDX] = SYS_ID_ISAR2_EL1,
+    [ID_ISAR3_EL1_IDX] = SYS_ID_ISAR3_EL1,
+    [ID_ISAR4_EL1_IDX] = SYS_ID_ISAR4_EL1,
+    [ID_ISAR5_EL1_IDX] = SYS_ID_ISAR5_EL1,
+    [ID_MMFR4_EL1_IDX] = SYS_ID_MMFR4_EL1,
+    [ID_ISAR6_EL1_IDX] = SYS_ID_ISAR6_EL1,
+    [MVFR0_EL1_IDX] = SYS_MVFR0_EL1,
+    [MVFR1_EL1_IDX] = SYS_MVFR1_EL1,
+    [MVFR2_EL1_IDX] = SYS_MVFR2_EL1,
+    [ID_PFR2_EL1_IDX] = SYS_ID_PFR2_EL1,
+    [ID_DFR1_EL1_IDX] = SYS_ID_DFR1_EL1,
+    [ID_MMFR5_EL1_IDX] = SYS_ID_MMFR5_EL1,
+    [ID_AA64ZFR0_EL1_IDX] = SYS_ID_AA64ZFR0_EL1,
+    [CTR_EL0_IDX] = SYS_CTR_EL0,
+};
+
+#endif /* ARM_CPU_SYSREGS_H */
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 215845c7e256..60335f8893fa 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -30,6 +30,7 @@
 #include "qapi/qapi-types-common.h"
 #include "target/arm/multiprocessing.h"
 #include "target/arm/gtimer.h"
+#include "target/arm/cpu-sysregs.h"
 
 #ifdef TARGET_AARCH64
 #define KVM_HAVE_MCE_INJECTION 1
@@ -855,6 +856,53 @@ typedef struct {
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
@@ -1063,6 +1111,7 @@ struct ArchCPU {
         uint64_t id_aa64zfr0;
         uint64_t id_aa64smfr0;
         uint64_t reset_pmcr_el0;
+        uint64_t idregs[NUM_ID_IDX];
     } isar;
     uint64_t midr;
     uint32_t revidr;
-- 
2.48.1


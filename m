Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE54E2770B
	for <kvmarm@lists.linux.dev>; Wed,  3 May 2023 17:16:30 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-559e281c5dfso54505927b3.3
        for <kvmarm@lists.linux.dev>; Wed, 03 May 2023 10:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683134189; x=1685726189;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KXolz7Q2DIi1pPRNwoAhG/QZ2/DoPomr2tw+WOeyqjM=;
        b=d6h/Lq1CdWSTYNh4fTzn74IWerXgs12TfMR2A6rCDVM850fJjNlFnQVh42F22QG3e7
         ussmRTTpljb1jUi1/ZIqbVZ0iNKowvhMfhbQgRHL1yfYm5OVSkcilZMB+BqIcxHJy8jR
         XvdIIalMHaYTfiQDDkXefM7/to/WishTQNdHcCN3SSoLLmFMLha5Wiw/DiO4K1X+zktW
         dpHZcB/BBHRwHvfMOSfmZsCAp72dhEHU99VT5tIXUIRobYRRgTtTP8sewdYPDCTt+spv
         jVHSY+Ggj7Q137C9GoecxGsoi01Dq56/FRUWASFE7pCg8gt49CKdP05a10RA/PK87qCw
         IWkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683134189; x=1685726189;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KXolz7Q2DIi1pPRNwoAhG/QZ2/DoPomr2tw+WOeyqjM=;
        b=WiJFVhQ5EBggi4R8diDRe9EaH8zXwafKBnNEbEeaYckS4U9pyqj6jZqvddE5UWcLnV
         Cv9Oacuh9/tbNH5ng6KTIKrTh9EJQ/PHOnERoGgPiEH8e06yBs4SJsRyOqSBFVlBE6vs
         dbjCXBNk4A9srnV6vF/MYtudKiFCxN9Ys5rY3NIJnNiCGj5NtEW8mFSLGuinhIPVG72g
         HFXMt74J7a194pxlBYgKKZtfCNbZ+4FgrktowLmdM4zEtUZPlrd7uMkV81ylAB2Eqihx
         lwjThlItour+N6X47mR48falvBLaNDwyuK/ll/22x7Z1+J0Z7TFr6117njOTBSuBASiu
         DlyA==
X-Gm-Message-State: AC+VfDzwRntTtv8DNjQwD7dl6nGFRmDqXH2cJg2AAEvO728tZAEscLcm
	2KmrvbVW/tjIizrjyLyCPELuQiqol6S89iymWw==
X-Google-Smtp-Source: ACHHUZ4Uis1L58miXkgjaeqj7MVHDaCS/lTmCIQ9EHFXnlUHG0VlmkhfuZTCMo/MRfsgCeCPIAmC9IBGfMLKebC4RA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a81:7649:0:b0:54f:646d:19bf with SMTP
 id j9-20020a817649000000b0054f646d19bfmr13354258ywk.1.1683134189629; Wed, 03
 May 2023 10:16:29 -0700 (PDT)
Date: Wed,  3 May 2023 17:16:16 +0000
In-Reply-To: <20230503171618.2020461-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230503171618.2020461-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230503171618.2020461-5-jingzhangos@google.com>
Subject: [PATCH v8 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

With per guest ID registers, PMUver settings from userspace
can be stored in its corresponding ID register.

No functional change intended.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 11 ++--
 arch/arm64/kvm/arm.c              |  6 --
 arch/arm64/kvm/id_regs.c          | 94 +++++++++++++++++++++++++------
 include/kvm/arm_pmu.h             |  5 +-
 4 files changed, 87 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4699f6b829b2..009f6ff41078 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -236,6 +236,12 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_EL1_32BIT				4
 	/* PSCI SYSTEM_SUSPEND enabled for the guest */
 #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED		5
+	/*
+	 * AA64DFR0_EL1.PMUver was set as ID_AA64DFR0_EL1_PMUVer_IMP_DEF
+	 * or DFR0_EL1.PerfMon was set as ID_DFR0_EL1_PerfMon_IMPDEF from
+	 * userspace for VCPUs without PMU.
+	 */
+#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU		6
 
 	unsigned long flags;
 
@@ -248,11 +254,6 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
-	struct {
-		u8 imp:4;
-		u8 unimp:4;
-	} dfr0_pmuver;
-
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0f71b10a2f05..9ecd0c5d0754 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -138,12 +138,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_arm_init_hypercalls(kvm);
 	kvm_arm_init_id_regs(kvm);
 
-	/*
-	 * Initialise the default PMUver before there is a chance to
-	 * create an actual PMU.
-	 */
-	kvm->arch.dfr0_pmuver.imp = kvm_arm_pmu_get_pmuver_limit();
-
 	return 0;
 
 err_free_cpumask:
diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 5e0fd4c8b375..0a04a90a8676 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -21,9 +21,12 @@
 static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
 {
 	if (kvm_vcpu_has_pmu(vcpu))
-		return vcpu->kvm->arch.dfr0_pmuver.imp;
+		return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+				 IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1));
+	else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags))
+		return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
 
-	return vcpu->kvm->arch.dfr0_pmuver.unimp;
+	return 0;
 }
 
 static u8 perfmon_to_pmuver(u8 perfmon)
@@ -244,8 +247,11 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
+	struct kvm_arch *arch = &vcpu->kvm->arch;
 	u8 pmuver, host_pmuver;
 	bool valid_pmu;
+	u64 sval = val;
+	int ret = 0;
 
 	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
 
@@ -265,26 +271,50 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
 		return -EINVAL;
 
+	mutex_lock(&arch->config_lock);
 	/* We can only differ with PMUver, and anything else is an error */
 	val ^= read_id_reg(vcpu, rd);
 	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-	if (val)
-		return -EINVAL;
+	if (val) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
+	/* Only allow userspace to change the idregs before VM running */
+	if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &vcpu->kvm->arch.flags)) {
+		if (sval != read_id_reg(vcpu, rd))
+			ret = -EBUSY;
+	} else {
+		if (valid_pmu) {
+			val = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
+			val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
+			val |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, pmuver);
+			IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) = val;
+
+			val = IDREG(vcpu->kvm, SYS_ID_DFR0_EL1);
+			val &= ~ID_DFR0_EL1_PerfMon_MASK;
+			val |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, pmuver_to_perfmon(pmuver));
+			IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) = val;
+		} else {
+			assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
+				   pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
+		}
+	}
 
-	return 0;
+out:
+	mutex_unlock(&arch->config_lock);
+	return ret;
 }
 
 static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 			   const struct sys_reg_desc *rd,
 			   u64 val)
 {
+	struct kvm_arch *arch = &vcpu->kvm->arch;
 	u8 perfmon, host_perfmon;
 	bool valid_pmu;
+	u64 sval = val;
+	int ret = 0;
 
 	host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
 
@@ -305,18 +335,39 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
 		return -EINVAL;
 
+	mutex_lock(&arch->config_lock);
 	/* We can only differ with PerfMon, and anything else is an error */
 	val ^= read_id_reg(vcpu, rd);
 	val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
-	if (val)
-		return -EINVAL;
+	if (val) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
+	/* Only allow userspace to change the idregs before VM running */
+	if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &vcpu->kvm->arch.flags)) {
+		if (sval != read_id_reg(vcpu, rd))
+			ret = -EBUSY;
+	} else {
+		if (valid_pmu) {
+			val = IDREG(vcpu->kvm, SYS_ID_DFR0_EL1);
+			val &= ~ID_DFR0_EL1_PerfMon_MASK;
+			val |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, perfmon);
+			IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) = val;
+
+			val = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
+			val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
+			val |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, perfmon_to_pmuver(perfmon));
+			IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) = val;
+		} else {
+			assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
+				   perfmon == ID_DFR0_EL1_PerfMon_IMPDEF);
+		}
+	}
 
-	return 0;
+out:
+	mutex_unlock(&arch->config_lock);
+	return ret;
 }
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
@@ -517,4 +568,15 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 	}
 
 	IDREG(kvm, SYS_ID_AA64PFR0_EL1) = val;
+	/*
+	 * Initialise the default PMUver before there is a chance to
+	 * create an actual PMU.
+	 */
+	val = IDREG(kvm, SYS_ID_AA64DFR0_EL1);
+
+	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+			  kvm_arm_pmu_get_pmuver_limit());
+
+	IDREG(kvm, SYS_ID_AA64DFR0_EL1) = val;
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 628775334d5e..e486347b297d 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -92,8 +92,9 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 /*
  * Evaluates as true when emulating PMUv3p5, and false otherwise.
  */
-#define kvm_pmu_is_3p5(vcpu)						\
-	(vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P5)
+#define kvm_pmu_is_3p5(vcpu)									\
+	 (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),					\
+		    IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1)) >= ID_AA64DFR0_EL1_PMUVer_V3P5)
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 
-- 
2.40.1.495.gc816e09b53d-goog


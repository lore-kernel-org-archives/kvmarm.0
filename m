Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EB7567E
	for <kvmarm@lists.linux.dev>; Wed, 17 May 2023 06:10:25 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-25345cf3343so170166a91.0
        for <kvmarm@lists.linux.dev>; Tue, 16 May 2023 23:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684303824; x=1686895824;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XO3TUGalcBEoGqQoQgLnoXNy9a4rhPSsy38V7ktJx3Q=;
        b=Rp8HJ2Pf7/iV6CYb2MY9p6/V6NMPYdO0/cPrq3NRQj8ildvZ323QEIVem1LV45yYm+
         dWEmvA1JZJr5xhV9Ao1JjKNciBti9S7CiesTML7cBmbVtYb7xXRIZaB/6bIuKuK1NBMr
         hE3zF6gDdXg0siHYrprzgt2kFaqsyjQdSJiG4fxpatA6UMcGAHbgFl/kNdb6b0VAodc4
         pu4bPzRZib6MmOj8VqhBITCTFCj2MnE/6pcG1oHbj0AUWS8sV0uiQ4Eqe3KtLLTfmsDU
         MHPc711oeNOqXqKuiSpaprTudR/BhnFGHwLPOPSylSfzLGScq38WAJWfUeA6ctMadrlj
         sPUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684303824; x=1686895824;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XO3TUGalcBEoGqQoQgLnoXNy9a4rhPSsy38V7ktJx3Q=;
        b=F+YEEafrjIw8lY3UKiFGLvdPhmX3r/YP3FldCLMfRNvrVwWS7JwgMvzTP7M4y4Bi0u
         Br4IBAD5VpUPU4BzxequT0KhYt9ar2ksFmv5PLSzz21poviWbqQV8gf83DxnBU85jhYd
         zWwJRmZrVs6DKtpdfQ2EoscFwypXAsnmh0Iha0kYSHTQfcr17956txhjELLRNlb1I65k
         1DBGmtyW9ClU1GmZlmILtL2QICUG+0ji4jGTyu2lI/1qtRQec3WONhnuXSHihlmk1i34
         4pMDeXvEmotrnVInmGcjwZSgle/BfaKTpW6UAUUlhe6W0VQxNus7SBVYfwkt1ksmsbxu
         l7tA==
X-Gm-Message-State: AC+VfDxL5uli/3Zo4uD3Iu02u/68/dKxxO6g6S9833ybTMSWmBcuHDEp
	hf+rIi7ZVwt/afk83HHJFyLz4ziamrARlakd7Q==
X-Google-Smtp-Source: ACHHUZ5h2ONPiwwVa1h3dyukSZOXybejqgzKNQ4sINXkhYMzo67UaHc6YRMvOsticuRp43xAsi184TLeQXVwGB5/mQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90a:9b8b:b0:246:7023:2ee6 with
 SMTP id g11-20020a17090a9b8b00b0024670232ee6mr11507162pjp.8.1684303824522;
 Tue, 16 May 2023 23:10:24 -0700 (PDT)
Date: Wed, 17 May 2023 06:10:12 +0000
In-Reply-To: <20230517061015.1915934-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230517061015.1915934-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230517061015.1915934-4-jingzhangos@google.com>
Subject: [PATCH v9 3/5] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
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
 arch/arm64/include/asm/kvm_host.h | 12 ++--
 arch/arm64/kvm/arm.c              |  6 --
 arch/arm64/kvm/sys_regs.c         | 94 +++++++++++++++++++++++++------
 include/kvm/arm_pmu.h             |  5 +-
 4 files changed, 88 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 07f0e091ae48..9a5f82161083 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -246,6 +246,13 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE		7
 	/* SMCCC filter initialized for the VM */
 #define KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED		8
+	/*
+	 * AA64DFR0_EL1.PMUver was set as ID_AA64DFR0_EL1_PMUVer_IMP_DEF
+	 * or DFR0_EL1.PerfMon was set as ID_DFR0_EL1_PerfMon_IMPDEF from
+	 * userspace for VCPUs without PMU.
+	 */
+#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU		9
+
 	unsigned long flags;
 
 	/*
@@ -257,11 +264,6 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
-	struct {
-		u8 imp:4;
-		u8 unimp:4;
-	} dfr0_pmuver;
-
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 	struct maple_tree smccc_filter;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5114521ace60..ca18c09ccf82 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -148,12 +148,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3c52b136ade3..fefe83f8deda 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1178,9 +1178,12 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
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
@@ -1402,8 +1405,11 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
+	struct kvm_arch *arch = &vcpu->kvm->arch;
 	u8 pmuver, host_pmuver;
 	bool valid_pmu;
+	u64 sval = val;
+	int ret = 0;
 
 	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
 
@@ -1423,26 +1429,50 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
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
 
@@ -1463,18 +1493,39 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
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
 
 /*
@@ -3421,6 +3472,17 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
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
 
 int __init kvm_sys_reg_table_init(void)
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 1a6a695ca67a..8d70dbdc1e0a 100644
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
2.40.1.606.ga4b1b128d6-goog


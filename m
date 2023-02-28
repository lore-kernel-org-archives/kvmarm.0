Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D44807
	for <kvmarm@lists.linux.dev>; Tue, 28 Feb 2023 06:23:17 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id t11-20020a170902e84b00b0019e399b2efaso113718plg.11
        for <kvmarm@lists.linux.dev>; Mon, 27 Feb 2023 22:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ksmKTtmSjXd5Cz3+4oYXyLBynC+x6diBnvSRhIvjy0o=;
        b=n9XU35B8tynwKYgi4xrspPhRLm5F5nehMO6wT4NG0uyPuobSuNOYzFq91o6l2tjkql
         IYqjRrh7r0e5DFw2cGF19q5QUSUNFoUVl3jXo7fGRNl6tRgwEJ5R6AHouG8NsOFYoOwv
         4Pdu7m/Hfeja1fxuy6qaCpOVfPOHue7iEW682cl/a4etVYJPhL6si2fvXcaW7/G4LW0M
         tyitRYM8djmWZ/ZZn7XS4CEfx58+KAolwtbOApoCYWhAkacIQhT9F2tkWq2hmlZ87sY9
         TpG9kiwWEIRq5ux/SlaHB+DSngmSjnPeDSGqO08cdXllPXg8vIU17qEdkXXvEMmjmoUL
         Qe4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ksmKTtmSjXd5Cz3+4oYXyLBynC+x6diBnvSRhIvjy0o=;
        b=sXBR3XRLsswos3vMoRWc90aXeFZjG2bxe5XEpZ9DMQ+eDgcZ+kHdifv7SEIZvO9XvS
         2qFNJASoErFzXwCUXKgdQfoimCM5/fUzwkqKORZiHHP3ptExJOCSQJf3jR31/xclPz7Q
         pYwqSJe+m341TJMo3MZSMRlEsf1g9gxX/CLW6EnlzVswZkQIDWdvoIC5B58Ma0yw/X0/
         wbAEH62fbbS3JFFkavaQTN3aVn/nfxdTLOkg62ullaWjgiBAzx9aUemP8CbO6nNGKSRK
         1cGwl3kP5MxBVlywiXhl5m96hK1mNvkHRmmVevWosisoA1fYShLJlAp8rFcwfBpJTinY
         cMUg==
X-Gm-Message-State: AO0yUKV0qZc4iDr1golzIjYfGrrFsXP9iUonsKg+nIfsXf+6JGgVDdO3
	FoFhyZyfMVkYBiR/lWJmmyoEwcTTvGOtpsa9BA==
X-Google-Smtp-Source: AK7set+5JyLrcmMolmaG7a5YGTJXYFOnxgrw77brtPDDmlnF5XevYDwEcIfwLazuMVLZM4ifJlQW4aedvahgXfdT1A==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90a:9482:b0:233:d64d:4c29 with
 SMTP id s2-20020a17090a948200b00233d64d4c29mr710336pjo.4.1677565396504; Mon,
 27 Feb 2023 22:23:16 -0800 (PST)
Date: Tue, 28 Feb 2023 06:22:44 +0000
In-Reply-To: <20230228062246.1222387-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230228062246.1222387-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230228062246.1222387-5-jingzhangos@google.com>
Subject: [PATCH v3 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

With per guest ID registers, PMUver settings from userspace
can be stored in its corresponding ID register.

No functional change intended.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 11 ++++---
 arch/arm64/kvm/arm.c              |  6 ----
 arch/arm64/kvm/id_regs.c          | 52 ++++++++++++++++++++++++-------
 include/kvm/arm_pmu.h             |  6 ++--
 4 files changed, 51 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f64347eb77c2..effb61a9a855 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -218,6 +218,12 @@ struct kvm_arch {
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
 
@@ -230,11 +236,6 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
-	struct {
-		u8 imp:4;
-		u8 unimp:4;
-	} dfr0_pmuver;
-
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c78d68d011cb..fb2de2cb98cb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -138,12 +138,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_arm_set_default_id_regs(kvm);
 	kvm_arm_init_hypercalls(kvm);
 
-	/*
-	 * Initialise the default PMUver before there is a chance to
-	 * create an actual PMU.
-	 */
-	kvm->arch.dfr0_pmuver.imp = kvm_arm_pmu_get_pmuver_limit();
-
 	return 0;
 
 err_free_cpumask:
diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 36859e4caf02..21ec8fc10d79 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -21,9 +21,12 @@
 static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
 {
 	if (kvm_vcpu_has_pmu(vcpu))
-		return vcpu->kvm->arch.dfr0_pmuver.imp;
-
-	return vcpu->kvm->arch.dfr0_pmuver.unimp;
+		return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+				IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1));
+	else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags))
+		return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
+	else
+		return 0;
 }
 
 static u8 perfmon_to_pmuver(u8 perfmon)
@@ -256,10 +259,19 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
+	if (valid_pmu) {
+		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=
+			FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), pmuver);
+
+		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
+		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=
+			FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), pmuver);
+	} else if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF) {
+		set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+	} else {
+		clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+	}
 
 	return 0;
 }
@@ -296,10 +308,19 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
+	if (valid_pmu) {
+		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
+		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |= FIELD_PREP(
+			ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), perfmon_to_pmuver(perfmon));
+
+		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |= FIELD_PREP(
+			ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), perfmon_to_pmuver(perfmon));
+	} else if (perfmon == ID_DFR0_EL1_PerfMon_IMPDEF) {
+		set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+	} else {
+		clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+	}
 
 	return 0;
 }
@@ -543,4 +564,13 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
 	}
 
 	IDREG(kvm, SYS_ID_AA64PFR0_EL1) = val;
+
+	/*
+	 * Initialise the default PMUver before there is a chance to
+	 * create an actual PMU.
+	 */
+	IDREG(kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+	IDREG(kvm, SYS_ID_AA64DFR0_EL1) |=
+		FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+			   kvm_arm_pmu_get_pmuver_limit());
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 628775334d5e..eef67b7d9751 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -92,8 +92,10 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 /*
  * Evaluates as true when emulating PMUv3p5, and false otherwise.
  */
-#define kvm_pmu_is_3p5(vcpu)						\
-	(vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P5)
+#define kvm_pmu_is_3p5(vcpu)									\
+	(kvm_vcpu_has_pmu(vcpu) &&								\
+	 FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),					\
+		 IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1)) >= ID_AA64DFR0_EL1_PMUVer_V3P5)
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 
-- 
2.39.2.722.g9855ee24e9-goog


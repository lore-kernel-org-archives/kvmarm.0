Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4347470
	for <kvmarm@lists.linux.dev>; Mon, 24 Apr 2023 23:47:15 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1a69ae5e220so56934185ad.2
        for <kvmarm@lists.linux.dev>; Mon, 24 Apr 2023 16:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682380035; x=1684972035;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RIy+HzYxVdD9wg5y3WVcnsXEaA4ZDP3kYn5Iam7xw70=;
        b=bGM7JAtgvhlwpfOLnHiMC4Skh35UX1c3KZE9nB1vqzQt9kVdnCbIIHc267lwOHPLU3
         EtKwny7BzN/DqqGK31zy4oIvYdaveQUtYd5UcLAlLaX0gWOThSSGKNwcBC1BTTTILTKj
         I7/2JhiPwFLN5qhKJ+CC387bT3GvCDYbCqmj9LwM+ebJ+HH3gVodtFbrU6QIi8ZEfcrj
         gfbxbP76pAX655ZpHddBpkdaBgllFhFjpRvTA2uEGLOz1ZBEfB3M2AsK1Rxc1ZmfMzvq
         Vxw4zNqKWvb/2gZ6Ha8aEkOHd2Ted7nIR1h3z+ppkxd4//5QhAvvftUaY0Vb3jPeqeqc
         y2Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682380035; x=1684972035;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RIy+HzYxVdD9wg5y3WVcnsXEaA4ZDP3kYn5Iam7xw70=;
        b=aNIHthhgYbY9E2petdZbDL5/2k96vZ/4wMbfNd2Bg276yfUizNJBui03wwupFVA5W6
         r4xBPVQCJzLVvN1RtlisrTjbHPKUrhdRqRdwz8BIYj90h7+gWERt8+jOy3QREL9qoEpM
         HesuFm8sfQTP5t6iHiXR4zQxmddCvkzHpEg2xLOe1iJgd0CTOhY5f8YSMKUcTvnTdeyz
         Pjh4jgz8Ji9sT3UwxXTdmrFfmHSZr/J+7WDt2AORAu3lyVNfywx6YrgsGAU7Zy8zCxea
         3nnQhjoZeK7mRNFpZIDfPet/ohMl12as+RArSkmiDZS/DiwJ4rjs7eXITtCOAoR8EFCc
         T11g==
X-Gm-Message-State: AAQBX9fhdDaDSUv/lVaABiDVmC5I54y3PLyWM0U77HnLeCTIuK7M6jAe
	5yExmPqjAh5Sa7DEMEsiRwM/7LN1Y40nMQ45JQ==
X-Google-Smtp-Source: AKy350a7BJBMaUH21SnPtBI5rgAd4sPJoigUViak0LTLAgVA96CWiVCY8QqJgIq5ts1if0CFDp5OhHpM1TQk13UxtQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:c411:b0:1a6:b221:daa1 with
 SMTP id k17-20020a170902c41100b001a6b221daa1mr5344183plk.0.1682380034902;
 Mon, 24 Apr 2023 16:47:14 -0700 (PDT)
Date: Mon, 24 Apr 2023 23:47:02 +0000
In-Reply-To: <20230424234704.2571444-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230424234704.2571444-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424234704.2571444-5-jingzhangos@google.com>
Subject: [PATCH v7 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
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
 arch/arm64/include/asm/kvm_host.h | 11 +++---
 arch/arm64/kvm/arm.c              |  6 ---
 arch/arm64/kvm/id_regs.c          | 66 +++++++++++++++++++++++++------
 include/kvm/arm_pmu.h             |  5 ++-
 4 files changed, 63 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0c719c34f5b4..3b583b055d07 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -235,6 +235,12 @@ struct kvm_arch {
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
 
@@ -247,11 +253,6 @@ struct kvm_arch {
 
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
index 18c39af3e319..15f79a654be8 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -21,9 +21,12 @@
 static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
 {
 	if (kvm_vcpu_has_pmu(vcpu))
-		return vcpu->kvm->arch.dfr0_pmuver.imp;
+		return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+				 idreg_read(&vcpu->kvm->arch, SYS_ID_AA64DFR0_EL1));
+	else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags))
+		return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
 
-	return vcpu->kvm->arch.dfr0_pmuver.unimp;
+	return 0;
 }
 
 static u8 perfmon_to_pmuver(u8 perfmon)
@@ -254,10 +257,24 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
+	if (valid_pmu) {
+		mutex_lock(&vcpu->kvm->arch.config_lock);
+
+		val = _idreg_read(&vcpu->kvm->arch, SYS_ID_AA64DFR0_EL1);
+		val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
+		val |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, pmuver);
+		_idreg_write(&vcpu->kvm->arch, SYS_ID_AA64DFR0_EL1, val);
+
+		val = _idreg_read(&vcpu->kvm->arch, SYS_ID_DFR0_EL1);
+		val &= ~ID_DFR0_EL1_PerfMon_MASK;
+		val |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, pmuver_to_perfmon(pmuver));
+		_idreg_write(&vcpu->kvm->arch, SYS_ID_DFR0_EL1, val);
+
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
+	} else {
+		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
+			   pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
+	}
 
 	return 0;
 }
@@ -294,10 +311,24 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
+	if (valid_pmu) {
+		mutex_lock(&vcpu->kvm->arch.config_lock);
+
+		val = _idreg_read(&vcpu->kvm->arch, SYS_ID_DFR0_EL1);
+		val &= ~ID_DFR0_EL1_PerfMon_MASK;
+		val |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, perfmon);
+		_idreg_write(&vcpu->kvm->arch, SYS_ID_DFR0_EL1, val);
+
+		val = _idreg_read(&vcpu->kvm->arch, SYS_ID_AA64DFR0_EL1);
+		val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
+		val |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, perfmon_to_pmuver(perfmon));
+		_idreg_write(&vcpu->kvm->arch, SYS_ID_AA64DFR0_EL1, val);
+
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
+	} else {
+		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
+			   perfmon == ID_DFR0_EL1_PerfMon_IMPDEF);
+	}
 
 	return 0;
 }
@@ -483,6 +514,7 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 		idreg_write(&kvm->arch, id, val);
 	}
 
+	mutex_lock(&kvm->arch.config_lock);
 	/*
 	 * The default is to expose CSV2 == 1 if the HW isn't affected.
 	 * Although this is a per-CPU feature, we make it global because
@@ -491,8 +523,6 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 	 * Userspace can override this as long as it doesn't promise
 	 * the impossible.
 	 */
-	mutex_lock(&kvm->arch.config_lock);
-
 	val = _idreg_read(&kvm->arch, SYS_ID_AA64PFR0_EL1);
 
 	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED) {
@@ -506,5 +536,17 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 
 	_idreg_write(&kvm->arch, SYS_ID_AA64PFR0_EL1, val);
 
+	/*
+	 * Initialise the default PMUver before there is a chance to
+	 * create an actual PMU.
+	 */
+	val = _idreg_read(&kvm->arch, SYS_ID_AA64DFR0_EL1);
+
+	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+			  kvm_arm_pmu_get_pmuver_limit());
+
+	_idreg_write(&kvm->arch, SYS_ID_AA64DFR0_EL1, val);
+
 	mutex_unlock(&kvm->arch.config_lock);
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 628775334d5e..e850432f8c09 100644
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
+		 idreg_read(&vcpu->kvm->arch, SYS_ID_AA64DFR0_EL1)) >= ID_AA64DFR0_EL1_PMUVer_V3P5)
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 
-- 
2.40.0.634.g4ca3ef3211-goog


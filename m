Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D617F7EF
	for <kvmarm@lists.linux.dev>; Tue, 28 Feb 2023 06:23:15 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-536a4eba107so190455137b3.19
        for <kvmarm@lists.linux.dev>; Mon, 27 Feb 2023 22:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b7qcQFJSuiip7+Vjf8JwVOhSGg/xEvb3za3Oa7OR1Rw=;
        b=QwKrJ3DSEd+Ic3Utfm8QKacIBb7w6voEB2tVpT3sHFZtuqTgdck7tSCLXio674Fz9M
         ThvfvEsNaUxxvyQN8nsBGAzQtYeisYf0XyOJiDkStYHNad2gDU5vDWY7bGUfDTewJNM5
         pl36HcQt46MonGwk76VQ3NhmJ3Vbgt2aVAknxvHJzqYKVo/AWYZACMfKPkWuev+ZPBtJ
         WJ1vENhLSFunKQ+E3EPMICOQ1iDSj96kDAdruA2tHKRX1nP0TVs8/N73bL+v9BgVpxQY
         pdHchhqnWw5SQXueV0XcGlPDR80zcZmEWmE2V5rUCOT4TBD2CNVaCKZkT5Q3mVHL6+Bf
         4EDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b7qcQFJSuiip7+Vjf8JwVOhSGg/xEvb3za3Oa7OR1Rw=;
        b=mVICcBT5Sp1LDlQD3YlsPVI/8TrEhknmWlTY1eVTXIoEZkHL89oCZtk+S1CDvZIdY2
         /Mru+ewJ5yXxWZ8hdeoXPfj52VRbZR0zdO0S7v9LaLDxfAEFOjGaFzTB8MbTNdOmMxh4
         /8olaSUJsMBperdPfG6oNV+I6BlKxE17XC89P4FOWgFdegLSoNgi/MJ1RXnx5cAYxm58
         c3WeP9SRCJ8eeKPcZN6iboccBQbULUfvLeImQpb/et2tCAsrINWvqCBCVh44HCkstW3K
         ELGPjTvNP1e0gUtvTj7Ga91paoaQbzKxDILCXezxCpXw9I7wwHhB0/ksUcevBBgWcknW
         4l2Q==
X-Gm-Message-State: AO0yUKUIxEFGLtGznszwrQKVKzdARE+cqWlG/RMFGYDU2YUdV1RhOsMI
	fZ57lNp9iPRtZ6T10Nn9IxdGppvum3iCuFJ2FA==
X-Google-Smtp-Source: AK7set/Texya5+LKjJJeQH9j9Fpl2DqSyUuun/zi1UfU+YtPa4ew0CMdzKctR49NPtqs4benoPMUZHTLLVQojaYdFA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6902:161a:b0:8a3:d147:280b with
 SMTP id bw26-20020a056902161a00b008a3d147280bmr1884830ybb.3.1677565394831;
 Mon, 27 Feb 2023 22:23:14 -0800 (PST)
Date: Tue, 28 Feb 2023 06:22:43 +0000
In-Reply-To: <20230228062246.1222387-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230228062246.1222387-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230228062246.1222387-4-jingzhangos@google.com>
Subject: [PATCH v3 3/6] KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
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

With per guest ID registers, ID_AA64PFR0_EL1.[CSV2|CSV3] settings from
userspace can be stored in its corresponding ID register.

No functional change intended.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h  |  3 +--
 arch/arm64/kvm/arm.c               | 19 +------------------
 arch/arm64/kvm/hyp/nvhe/sys_regs.c |  7 +++----
 arch/arm64/kvm/id_regs.c           | 30 ++++++++++++++++++++++--------
 4 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5c1cec4efa37..f64347eb77c2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -230,8 +230,6 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
-	u8 pfr0_csv2;
-	u8 pfr0_csv3;
 	struct {
 		u8 imp:4;
 		u8 unimp:4;
@@ -254,6 +252,7 @@ struct kvm_arch {
 #define KVM_ARM_ID_REG_NUM	56
 #define IDREG_IDX(id)		(((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id))
 #define IDREG(kvm, id)		kvm->arch.id_regs[IDREG_IDX(id)]
+#define IDREG_RD(kvm, rd)	IDREG(kvm, reg_to_encoding(rd))
 	u64 id_regs[KVM_ARM_ID_REG_NUM];
 };
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4579c878ab30..c78d68d011cb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -104,22 +104,6 @@ static int kvm_arm_default_max_vcpus(void)
 	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
 }
 
-static void set_default_spectre(struct kvm *kvm)
-{
-	/*
-	 * The default is to expose CSV2 == 1 if the HW isn't affected.
-	 * Although this is a per-CPU feature, we make it global because
-	 * asymmetric systems are just a nuisance.
-	 *
-	 * Userspace can override this as long as it doesn't promise
-	 * the impossible.
-	 */
-	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
-		kvm->arch.pfr0_csv2 = 1;
-	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED)
-		kvm->arch.pfr0_csv3 = 1;
-}
-
 /**
  * kvm_arch_init_vm - initializes a VM data structure
  * @kvm:	pointer to the KVM struct
@@ -151,9 +135,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->max_vcpus = kvm_arm_default_max_vcpus();
 
-	set_default_spectre(kvm);
-	kvm_arm_init_hypercalls(kvm);
 	kvm_arm_set_default_id_regs(kvm);
+	kvm_arm_init_hypercalls(kvm);
 
 	/*
 	 * Initialise the default PMUver before there is a chance to
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 08d2b004f4b7..ff486e78b32b 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -93,10 +93,9 @@ static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
 		PVM_ID_AA64PFR0_RESTRICT_UNSIGNED);
 
 	/* Spectre and Meltdown mitigation in KVM */
-	set_mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2),
-			       (u64)kvm->arch.pfr0_csv2);
-	set_mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3),
-			       (u64)kvm->arch.pfr0_csv3);
+	set_mask |= IDREG(kvm, SYS_ID_AA64PFR0_EL1) &
+		(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
+			ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
 
 	return (id_aa64pfr0_el1_sys_val & allow_mask) | set_mask;
 }
diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 811f01361d12..36859e4caf02 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -61,12 +61,6 @@ u64 kvm_arm_read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
 		if (!vcpu_has_sve(vcpu))
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2),
-				  (u64)vcpu->kvm->arch.pfr0_csv2);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3),
-				  (u64)vcpu->kvm->arch.pfr0_csv3);
 		if (kvm_vgic_global_state.type == VGIC_V3) {
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
 			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
@@ -201,6 +195,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 			       u64 val)
 {
 	u8 csv2, csv3;
+	u64 sval = val;
 
 	/*
 	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
@@ -225,8 +220,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	vcpu->kvm->arch.pfr0_csv2 = csv2;
-	vcpu->kvm->arch.pfr0_csv3 = csv3;
+	IDREG_RD(vcpu->kvm, rd) = sval;
 
 	return 0;
 }
@@ -529,4 +523,24 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
 		val = read_sanitised_ftr_reg(id);
 		IDREG(kvm, id) = val;
 	}
+	/*
+	 * The default is to expose CSV2 == 1 if the HW isn't affected.
+	 * Although this is a per-CPU feature, we make it global because
+	 * asymmetric systems are just a nuisance.
+	 *
+	 * Userspace can override this as long as it doesn't promise
+	 * the impossible.
+	 */
+	val = IDREG(kvm, SYS_ID_AA64PFR0_EL1);
+
+	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED) {
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2), 1);
+	}
+	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED) {
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3), 1);
+	}
+
+	IDREG(kvm, SYS_ID_AA64PFR0_EL1) = val;
 }
-- 
2.39.2.722.g9855ee24e9-goog


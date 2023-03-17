Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979A464A
	for <kvmarm@lists.linux.dev>; Fri, 17 Mar 2023 05:06:49 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id g13-20020a63f40d000000b005015be7b9faso1061993pgi.15
        for <kvmarm@lists.linux.dev>; Thu, 16 Mar 2023 22:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679029609;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qi4CYMe4M1PBtkpLLK5m9h/4D/wAB6aSbE76cc81UuY=;
        b=NLy1crdFD0h1D0+YYdrkj+1TfuhfR1BkbSgWnQtAOY/INGEUORDtSZslLKHF83F72O
         E/n8bbz59TfWd9lzhYVa6NMrSSjm8M9VAAzJVJMcOGBPKFiMkBs+xEAfdgPRGvMyQ0pH
         gJ0teOmUVCzGguLQC4MN2b2H2gvGyNtlh/bISfky57nhZd8os7Ufz3BgpmDpiq+4On/X
         izPlNjUkSZxFX4GK743DApmFKW46TWdok+EHzZHO56QMl5NEvE31bopEoi/vac4ZcUyt
         aIhtXQo0OOLe9n+IfU0h44MOhHijTgfaNp/LwCSpDxyrmxi38ojaQo4gkAY61G7mTDEf
         3+kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679029609;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qi4CYMe4M1PBtkpLLK5m9h/4D/wAB6aSbE76cc81UuY=;
        b=r23w3PeJiwwhFqHJWgh8HrZob1vQSzEZwMbCltWpNRFvF2OAY5ejavbssaSH7hsdM9
         O9+ghBQx8HGPGqweKwVomdcgqcB9N5mFsF4NOe4TctlA/eNxy9ZZRAI9t1CLZIh/R4vu
         yAJD2KlA5pFgnEuWJl1jz9J1Mpeor8qYLWYRnrjwLTjTpG2NjrfXtLqzKBh5c0N0R/ty
         MHqfGHHrx7+xPyvB2Bth8XzM0XNwCtDa0mNl0w0t/tzgXQldFS20O6IgTNRQZPWcogez
         p3meEz7Z5gbZgHzmRoNSC7Qr0O18mIFIgOeFccqlX2YQA+itjFVnz1PChhfVVLZUGAX4
         4KZA==
X-Gm-Message-State: AO0yUKU3iLXiBnYNa5ZQcPzDdqnYjDE3RE86Jg3xzaKzhfez56lIeEu9
	PJxdXOCeVXQjwgtNW9PzmbgMnQB1n6ftXarzGA==
X-Google-Smtp-Source: AK7set9O5n6eyLrWml1aCC+9jbgEplGLq6m7jeShYBDO0kl6DGyaUtwp0zOfK34OZTNGF4ldhnQ6rivIodnN33Wt1Q==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90b:a0b:b0:23b:419d:8efe with SMTP
 id gg11-20020a17090b0a0b00b0023b419d8efemr1926700pjb.3.1679029609085; Thu, 16
 Mar 2023 22:06:49 -0700 (PDT)
Date: Fri, 17 Mar 2023 05:06:34 +0000
In-Reply-To: <20230317050637.766317-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230317050637.766317-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230317050637.766317-4-jingzhangos@google.com>
Subject: [PATCH v4 3/6] KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
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
 arch/arm64/include/asm/kvm_host.h  |  2 --
 arch/arm64/kvm/arm.c               | 19 +------------------
 arch/arm64/kvm/hyp/nvhe/sys_regs.c |  7 +++----
 arch/arm64/kvm/id_regs.c           | 30 ++++++++++++++++++++++--------
 4 files changed, 26 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fb6b50b1f111..e926ea91a73c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -230,8 +230,6 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
-	u8 pfr0_csv2;
-	u8 pfr0_csv3;
 	struct {
 		u8 imp:4;
 		u8 unimp:4;
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
index 08d2b004f4b7..0e1988740a65 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -93,10 +93,9 @@ static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
 		PVM_ID_AA64PFR0_RESTRICT_UNSIGNED);
 
 	/* Spectre and Meltdown mitigation in KVM */
-	set_mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2),
-			       (u64)kvm->arch.pfr0_csv2);
-	set_mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3),
-			       (u64)kvm->arch.pfr0_csv3);
+	set_mask |= vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] &
+		(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
+			ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
 
 	return (id_aa64pfr0_el1_sys_val & allow_mask) | set_mask;
 }
diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index e393b5730557..b60ca1058301 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -61,12 +61,6 @@ u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
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
+	vcpu->kvm->arch.id_regs[IDREG_IDX(reg_to_encoding(rd))] = sval;
 
 	return 0;
 }
@@ -529,4 +523,24 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
 		val = read_sanitised_ftr_reg(id);
 		kvm->arch.id_regs[IDREG_IDX(id)] = val;
 	}
+	/*
+	 * The default is to expose CSV2 == 1 if the HW isn't affected.
+	 * Although this is a per-CPU feature, we make it global because
+	 * asymmetric systems are just a nuisance.
+	 *
+	 * Userspace can override this as long as it doesn't promise
+	 * the impossible.
+	 */
+	val = kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64PFR0_EL1)];
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
+	kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = val;
 }
-- 
2.40.0.rc1.284.g88254d51c5-goog


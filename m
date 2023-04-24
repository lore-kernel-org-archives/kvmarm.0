Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3B8748D
	for <kvmarm@lists.linux.dev>; Mon, 24 Apr 2023 23:47:14 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-54f809d82bcso81912647b3.1
        for <kvmarm@lists.linux.dev>; Mon, 24 Apr 2023 16:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682380033; x=1684972033;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hBRirRGWthjx+Mjpp0R7iqomIsI0z6DFJ7PkuKK4rG8=;
        b=5uEQC87jgz+l3ZAvYKoqSKwDcxe0APavr7Jx+zOWvP2imq6B0pVK/D77jxBpFSy4H7
         wbN+/cbl9v6hkWPXnXOsotpJXnGTX1zHpqIuV8ARxI5HHppULT4BqOVwID5kDDkQZUxP
         txDjod1IYP1InUzw9WEKwNRR8XPXC2UU2cpzIN5Yg3E5c4jSDX28bEaVvC3bnqNe8KJ/
         mv+OsI/hLjHYIq4il/3ADVm+Cz02gCE1DvIFVzT83aGRKaD/mU/P1VlD8yOuVMIQFkDu
         r0EdPJGLabopoGVIJdLfYO56rAiUHf57mCMxApjJmi3Yhso9YEp5l9YEsP0IdxEvPSnW
         +0sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682380033; x=1684972033;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hBRirRGWthjx+Mjpp0R7iqomIsI0z6DFJ7PkuKK4rG8=;
        b=V6/epluw4ElHgbu6GndfaehjbrT0BwhInBfJswqWtIP7eStI8DVqkrskJJiU3LHV3/
         c4BiCqa8Lj2lmnQKX68WptAMaHBKDbX2L4vrm2p2oE4T3lPnDD/e3Tydh5L3+pxjsftd
         LCZmpmgoqQ/yDw2mLBucE29BlFwM/EJR8UYrYvBVNV/oGWAeTzqZQ8ANpIg4O7ayNmkS
         gqcnEezUx58qjSncazL3ONCP/CmC4wVcPDRiHdWTryNGTkiCkliirWvaoOQ9i4asOhCp
         l51CY2pYgmQk4620j2h0Rhd06UlGUPdfh3wJMZmMYskqIIO8DgPp9PCGJMMo/EDrqjVS
         TMVw==
X-Gm-Message-State: AAQBX9ePYOE9FeF20IueumvpKXS76dz+mw5SUvGlJ0iRE1Mnbpi58F9x
	rE2VSvZezYulJNsUdOc5X+umAe3Rn4ua4H1hTA==
X-Google-Smtp-Source: AKy350bGdJlzo+k/dHHXPT5SO/f0OAcoFeZFhUsFF7KAUTF4TiYgJN/2q/VCMaRhm43hjebFl6EgeI8LsoNsstoAZQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a81:e24c:0:b0:546:5b84:b558 with SMTP
 id z12-20020a81e24c000000b005465b84b558mr6891742ywl.10.1682380033225; Mon, 24
 Apr 2023 16:47:13 -0700 (PDT)
Date: Mon, 24 Apr 2023 23:47:01 +0000
In-Reply-To: <20230424234704.2571444-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230424234704.2571444-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424234704.2571444-4-jingzhangos@google.com>
Subject: [PATCH v7 3/6] KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
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

With per guest ID registers, ID_AA64PFR0_EL1.[CSV2|CSV3] settings from
userspace can be stored in its corresponding ID register.

The setting of CSV bits for protected VMs are removed according to the
discussion from Fuad below:
https://lore.kernel.org/all/CA+EHjTwXA9TprX4jeG+-D+c8v9XG+oFdU1o6TSkvVye145_OvA@mail.gmail.com

Besides the removal of CSV bits setting for protected VMs, No other
functional change intended.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 --
 arch/arm64/kvm/arm.c              | 17 ---------------
 arch/arm64/kvm/id_regs.c          | 35 ++++++++++++++++++++++++-------
 3 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2b1fe90a1790..0c719c34f5b4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -247,8 +247,6 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
-	u8 pfr0_csv2;
-	u8 pfr0_csv3;
 	struct {
 		u8 imp:4;
 		u8 unimp:4;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e34744c36406..0f71b10a2f05 100644
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
@@ -151,7 +135,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->max_vcpus = kvm_arm_default_max_vcpus();
 
-	set_default_spectre(kvm);
 	kvm_arm_init_hypercalls(kvm);
 	kvm_arm_init_id_regs(kvm);
 
diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index d2fba2fde01c..18c39af3e319 100644
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
@@ -223,8 +218,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	vcpu->kvm->arch.pfr0_csv2 = csv2;
-	vcpu->kvm->arch.pfr0_csv3 = csv3;
+	idreg_write(&vcpu->kvm->arch, reg_to_encoding(rd), sval);
 
 	return 0;
 }
@@ -488,4 +482,29 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 		val = read_sanitised_ftr_reg(id);
 		idreg_write(&kvm->arch, id, val);
 	}
+
+	/*
+	 * The default is to expose CSV2 == 1 if the HW isn't affected.
+	 * Although this is a per-CPU feature, we make it global because
+	 * asymmetric systems are just a nuisance.
+	 *
+	 * Userspace can override this as long as it doesn't promise
+	 * the impossible.
+	 */
+	mutex_lock(&kvm->arch.config_lock);
+
+	val = _idreg_read(&kvm->arch, SYS_ID_AA64PFR0_EL1);
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
+	_idreg_write(&kvm->arch, SYS_ID_AA64PFR0_EL1, val);
+
+	mutex_unlock(&kvm->arch.config_lock);
 }
-- 
2.40.0.634.g4ca3ef3211-goog


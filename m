Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5DC2770B
	for <kvmarm@lists.linux.dev>; Wed,  3 May 2023 17:16:28 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5144902c15eso2701253a12.2
        for <kvmarm@lists.linux.dev>; Wed, 03 May 2023 10:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683134188; x=1685726188;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3y4Kfy2GUjobcHYyZ9SUkPkVgouus99so38CmZIGmsw=;
        b=3Hyjf7etkPKKM0ybJACAkNN8mm+a0hOyJxUOW5Mq2keXbylvfQW5rR6AHCpCDn/k1G
         dJa0PeL2IMoCqMYQI9RJ0BFiRNOi9CT7BdP7PTwxQtE1v5HdIfrBH5OMQrOaBwbJFta/
         VuQDRa+JmQ5M72sP+SsUhtdoVqJWXCEBt+fD1nozxCEYi+dv78jPJu2OGqaX7XN+Z0Pg
         6BrFr+AmBYR5zhrK8BPIvbKweRL1WHbUdxXq1UpU2ooGbvWINSNIFtwli2Pr7Mz99AeT
         /+alq2THcfmnTGOtf8XNgOOjkUGrVCwytNGe8/ufvdOcu7So8V+s88/AkErRvajPbg0A
         7SmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683134188; x=1685726188;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3y4Kfy2GUjobcHYyZ9SUkPkVgouus99so38CmZIGmsw=;
        b=XhVvnhWMLzE5EwLS7xGI6GrB1HydYEwL2vSq4tO8uGGSz44N3azNueU5rCyVIV6K0S
         1AJvY/JOWf+bz5DdNFYnHbqhQ+NMG4h7Sq1d+cV3LUpDD/EtOci4oCayMYDDVPQPt160
         xUPilhTLmeUqi5f9rCIyQXaFvh27nHuBHtdsJjpi09K3fLdiDFAU9HTo3++FtqdgpbQ/
         qv3S2rQn4VFMsHpKeYMsOtbPM4gQql5Xj6caIab/ncP/7dCn2id6PXwviv7zn2wypEnS
         0CnTnHlBbU3llepkOT/U8UeKcgijCffEGleWiy7h5yTncRhoVlu7PPs8iBNY5/yE+cCm
         qBEQ==
X-Gm-Message-State: AC+VfDzwplnWXt/0hxkLeDSO4he83k3v6r/+jaHsOWN4BDfCRL2qtmII
	DhblTOnIHqtV7svfK2YsxMSpohTJec13QAxpSw==
X-Google-Smtp-Source: ACHHUZ7HyW0X0PuEZ5h1NTsn+Yc9wlltFm4DnqLWUCPn4gbRTUI8UVahVGoJjwi+wUbDvsWj1Gnc94TA0j76jbxUUw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:95:0:b0:51f:343e:7df8 with SMTP id
 143-20020a630095000000b0051f343e7df8mr720786pga.8.1683134187890; Wed, 03 May
 2023 10:16:27 -0700 (PDT)
Date: Wed,  3 May 2023 17:16:15 +0000
In-Reply-To: <20230503171618.2020461-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230503171618.2020461-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230503171618.2020461-4-jingzhangos@google.com>
Subject: [PATCH v8 3/6] KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
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
 arch/arm64/kvm/arm.c              | 17 ----------
 arch/arm64/kvm/id_regs.c          | 56 ++++++++++++++++++++++++-------
 3 files changed, 44 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a7d4d9e093e3..4699f6b829b2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -248,8 +248,6 @@ struct kvm_arch {
 
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
index e769223bcee2..5e0fd4c8b375 100644
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
@@ -153,7 +147,12 @@ static bool access_id_reg(struct kvm_vcpu *vcpu,
 static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 *val)
 {
+	struct kvm_arch *arch = &vcpu->kvm->arch;
+
+	mutex_lock(&arch->config_lock);
 	*val = read_id_reg(vcpu, rd);
+	mutex_unlock(&arch->config_lock);
+
 	return 0;
 }
 
@@ -200,7 +199,10 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
+	struct kvm_arch *arch = &vcpu->kvm->arch;
+	u64 sval = val;
 	u8 csv2, csv3;
+	int ret = 0;
 
 	/*
 	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
@@ -216,17 +218,26 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	if (csv3 > 1 || (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
 		return -EINVAL;
 
+	mutex_lock(&arch->config_lock);
 	/* We can only differ with CSV[23], and anything else is an error */
 	val ^= read_id_reg(vcpu, rd);
 	val &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
 		 ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
-	if (val)
-		return -EINVAL;
-
-	vcpu->kvm->arch.pfr0_csv2 = csv2;
-	vcpu->kvm->arch.pfr0_csv3 = csv3;
+	if (val) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	return 0;
+	/* Only allow userspace to change the idregs before VM running */
+	if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &vcpu->kvm->arch.flags)) {
+		if (sval != read_id_reg(vcpu, rd))
+			ret = -EBUSY;
+	} else {
+		IDREG(vcpu->kvm, reg_to_encoding(rd)) = sval;
+	}
+out:
+	mutex_unlock(&arch->config_lock);
+	return ret;
 }
 
 static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
@@ -485,4 +496,25 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 		val = read_sanitised_ftr_reg(id);
 		IDREG(kvm, id) = val;
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
2.40.1.495.gc816e09b53d-goog


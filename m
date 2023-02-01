Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931FD7E5
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 02:51:41 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id z9-20020a170902d54900b00196680ec8bbso5671776plf.16
        for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 18:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jtA8OJbXoe0QFW21mEwKtvXGHpBgnZe8L3qzReVjKUA=;
        b=fXhhMzOwr3O8t7BTYHm6r+S8OYvBdR5e23axs9ydQrZLDuRrtsEcC9WN1XNkFH2rWT
         amAnslZyg0UvJYOxuIdorLuWvurkkJsK13o8aV3N+ryHgZoVudjgOxkBpMAVDE/e4amb
         eEToFfW9YWOdngPLol95yHqDQ3b3Ppzo+VcQjK1nMOu0jByqHKz8dtZj8v8z00Y0M5ky
         1dC3MZTwf6PhFemMBE9oXTHhAwecmZeoeGlRk40bB8Fp07T9r/pEa6TR8KiZraM5L/L1
         t3uwkiT8irpHqk6eIXzK58tH5e15mzz8MJGR6BdIRhP6VgF3Pw0HEsbtDXj8rZp08hHI
         2HRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jtA8OJbXoe0QFW21mEwKtvXGHpBgnZe8L3qzReVjKUA=;
        b=BoPNAX626FJQ2ro9mFplrSLG60RR5rthzaHXeL76SET1gjqU5N5kExuNxn6bmLLblh
         J7ScuufZBxHShgrd8Ipe3vMcw+y3cTs876xHdFVlBW1Z+KMh6uraeYLG9byU1gqMqbrF
         wr2LPRL4DCj+3pPQjgNI7vpH83qQh8srU8qxyagTg5D03ZbMZ/epYXfvFRhUeTCaux0C
         1Xx7yw9ZAXbAPO9LS2j8FSW2PkBV/vg42Stro/prEGpr10JdzLcI1wECNZKzx8wAP47H
         8+cBI9THO5QY8p4jIUyqOZoRAx09tNL8Jiw4OVVtrpe/EC0xc034W0j49hP+J7SNVMhT
         TuXA==
X-Gm-Message-State: AO0yUKXpDW4XHKZzM5YZpyBWWPEgaJV76dPfgFHaa5h3Doo2RaVEoqn8
	DHiuMBEbdjMoPKhoIV9Ja5YzhXi4LTqdIqRW5w==
X-Google-Smtp-Source: AK7set/iZnCZiaWSDZD4YPdKBK98pfHE92kCKD48HnVnF5FD/69mopaG2vFmhcK4wXYYXo99CDCTOcty5ugXK3Mgnw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90a:74cf:b0:22c:dfb:a9da with SMTP
 id p15-20020a17090a74cf00b0022c0dfba9damr84622pjl.115.1675219901051; Tue, 31
 Jan 2023 18:51:41 -0800 (PST)
Date: Wed,  1 Feb 2023 02:50:45 +0000
In-Reply-To: <20230201025048.205820-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230201025048.205820-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230201025048.205820-4-jingzhangos@google.com>
Subject: [PATCH v1 3/6] KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
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
index b1beef93465c..fabb30185a4a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -225,8 +225,6 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
-	u8 pfr0_csv2;
-	u8 pfr0_csv3;
 	struct {
 		u8 imp:4;
 		u8 unimp:4;
@@ -249,6 +247,7 @@ struct kvm_arch {
 #define KVM_ARM_ID_REG_NUM	56
 #define IDREG_IDX(id)		(((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id))
 #define IDREG(kvm, id)		kvm->arch.id_regs[IDREG_IDX(id)]
+#define IDREG_RD(kvm, rd)	IDREG(kvm, reg_to_encoding(rd))
 	u64 id_regs[KVM_ARM_ID_REG_NUM];
 };
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d525b71d0523..d8ba5106bf51 100644
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
index 0f9ac25afdf4..03919d342136 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -92,10 +92,9 @@ static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
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
index f53ce00ab14d..bc5d9bc84eb1 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -71,12 +71,6 @@ u64 kvm_arm_read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
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
@@ -208,6 +202,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 			       u64 val)
 {
 	u8 csv2, csv3;
+	u64 sval = val;
 
 	/*
 	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
@@ -232,8 +227,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	vcpu->kvm->arch.pfr0_csv2 = csv2;
-	vcpu->kvm->arch.pfr0_csv3 = csv3;
+	IDREG_RD(vcpu->kvm, rd) = sval;
 
 	return 0;
 }
@@ -516,4 +510,24 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
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
2.39.1.456.gfc5497dd1b-goog


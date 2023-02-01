Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76511658
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 02:51:39 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id z10-20020a170902ccca00b001898329db72so9316835ple.21
        for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 18:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RNQAAG2W257cIjJOfB4F5pMjBmkEAgg15MTy1dMbGKU=;
        b=e2rhYxh4lvuezENrCxsjvMBhhTiYNjicQiLAwaDRrEc/bj90lbp3Ps3IdSmtDcFS2R
         spgDEWuekLijUGc1S+aWqhJMTJ0bL7xpEnO6w4JE/7InNQmjxveF+guYLp+LgXYC/wBA
         DqzmFqMh3dawJBLOa6Hmae1YSVPjKGo+Zo71SDwq2KaoddFptP58e4Y3wc/0B/COUkky
         Cu7bmWlpBWegasQxz8WQwxm937t+wwmCTw11DU6LYtQRMmcPT1mrVAwzrImvCbUrKK82
         6Xb9ogiZpbfWHeI4Djkq/F5xfYLxghOQDcrjPJP2Hk9I5JaD9G881i8JkmxptwM8YZzU
         ULMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RNQAAG2W257cIjJOfB4F5pMjBmkEAgg15MTy1dMbGKU=;
        b=479Hol7k4MMw1qmeV8Wfm3LKGXB1HHsmJmMv+/XPkowUBI4/FeU7/348YdwoHWCsef
         AzTNFS16v/2yB4NGrfKElGiIG2JVFQRRcXLTCnXsVq4Qpc09gCZMO4Bvpo69cDrbiR0g
         rq3MK3RgcLfp7b0NyIq6uCaMB4zD46ozu8xiQHuxSyR1AWYHQyzadqBVQtia2GZ+NFNZ
         JGt5/1ase9Rm7+cTwlvycMBGhMZ49zulSiOCv2LRcKqkMplTvjzjhaYAb60SLSHbe60j
         bLLMhPlOsITlvWprJzZEBHWSH/8wpIy/wAyKbWR1K1CtV1z+X2QIvl+vJ2dHHM87a8md
         OnRQ==
X-Gm-Message-State: AO0yUKU1PS1G4qjd0iEeWf1mv94R2fF2hdOjNQ5dTCLQAgJzgONWqJ2l
	o4dphGdq2DeV7mQVES/Q07TVmyjfUV+t90lemg==
X-Google-Smtp-Source: AK7set+coY/luGJv2OCNri1R5naNanlcg1VDMzCffP+dZOxRoQPBg4GDTmZ+xZo0tPFe2ju1m00VI/AkLCHfWe5grw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:7608:b0:196:7555:f810 with
 SMTP id k8-20020a170902760800b001967555f810mr258252pll.7.1675219898896; Tue,
 31 Jan 2023 18:51:38 -0800 (PST)
Date: Wed,  1 Feb 2023 02:50:44 +0000
In-Reply-To: <20230201025048.205820-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230201025048.205820-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230201025048.205820-3-jingzhangos@google.com>
Subject: [PATCH v1 2/6] KVM: arm64: Save ID registers' sanitized value per guest
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

From: Reiji Watanabe <reijiw@google.com>

Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
and save ID registers' sanitized value in the array at KVM_CREATE_VM.
Use the saved ones when ID registers are read by the guest or
userspace (via KVM_GET_ONE_REG).

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Co-developed-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 12 +++++++
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/id_regs.c          | 53 ++++++++++++++++++++++++++-----
 arch/arm64/kvm/sys_regs.c         |  2 +-
 arch/arm64/kvm/sys_regs.h         |  1 +
 5 files changed, 60 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b14a0199eba4..b1beef93465c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -240,6 +240,16 @@ struct kvm_arch {
 	 * the associated pKVM instance in the hypervisor.
 	 */
 	struct kvm_protected_vm pkvm;
+
+	/*
+	 * Save ID registers for the guest in id_regs[].
+	 * (Op0, Op1, CRn, CRm, Op2) of the ID registers to be saved in it
+	 * is (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8.
+	 */
+#define KVM_ARM_ID_REG_NUM	56
+#define IDREG_IDX(id)		(((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id))
+#define IDREG(kvm, id)		kvm->arch.id_regs[IDREG_IDX(id)]
+	u64 id_regs[KVM_ARM_ID_REG_NUM];
 };
 
 struct kvm_vcpu_fault_info {
@@ -967,6 +977,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
+void kvm_arm_set_default_id_regs(struct kvm *kvm);
+
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 698787ed87e9..d525b71d0523 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -153,6 +153,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	set_default_spectre(kvm);
 	kvm_arm_init_hypercalls(kvm);
+	kvm_arm_set_default_id_regs(kvm);
 
 	/*
 	 * Initialise the default PMUver before there is a chance to
diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 386b3fbdee9f..f53ce00ab14d 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -51,16 +51,20 @@ static u8 pmuver_to_perfmon(u8 pmuver)
 	}
 }
 
-/* Read a sanitised cpufeature ID register by sys_reg_desc */
-static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
+/*
+ * Return true if the register's (Op0, Op1, CRn, CRm, Op2) is
+ * (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8.
+ */
+static bool is_id_reg(u32 id)
 {
-	u32 id = reg_to_encoding(r);
-	u64 val;
-
-	if (sysreg_visible_as_raz(vcpu, r))
-		return 0;
+	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
+		sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 1 &&
+		sys_reg_CRm(id) < 8);
+}
 
-	val = read_sanitised_ftr_reg(id);
+u64 kvm_arm_read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
+{
+	u64 val = IDREG(vcpu->kvm, id);
 
 	switch (id) {
 	case SYS_ID_AA64PFR0_EL1:
@@ -125,6 +129,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r
 	return val;
 }
 
+static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
+{
+	if (sysreg_visible_as_raz(vcpu, r))
+		return 0;
+
+	return kvm_arm_read_id_reg_with_encoding(vcpu, reg_to_encoding(r));
+}
+
 /* cpufeature ID register access trap handlers */
 
 static bool access_id_reg(struct kvm_vcpu *vcpu,
@@ -480,3 +492,28 @@ int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
 	}
 	return total;
 }
+
+/*
+ * Set the guest's ID registers that are defined in id_reg_descs[]
+ * with ID_SANITISED() to the host's sanitized value.
+ */
+void kvm_arm_set_default_id_regs(struct kvm *kvm)
+{
+	int i;
+	u32 id;
+	u64 val;
+
+	for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++) {
+		id = reg_to_encoding(&id_reg_descs[i]);
+		if (WARN_ON_ONCE(!is_id_reg(id)))
+			/* Shouldn't happen */
+			continue;
+
+		if (id_reg_descs[i].visibility == raz_visibility)
+			/* Hidden or reserved ID register */
+			continue;
+
+		val = read_sanitised_ftr_reg(id);
+		IDREG(kvm, id) = val;
+	}
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 56b0c596ddf6..4dec5b038d77 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -333,7 +333,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	u64 val = kvm_arm_read_id_reg_with_encoding(vcpu, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
 	if (!(val & (0xfUL << ID_AA64MMFR1_EL1_LO_SHIFT))) {
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 3a7792679481..3b59cc940148 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -238,6 +238,7 @@ int kvm_arm_get_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 bool kvm_arm_check_idreg_table(void);
 int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind);
+u64 kvm_arm_read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id);
 
 #define AA32(_x)	.aarch32_map = AA32_##_x
 #define Op0(_x) 	.Op0 = _x
-- 
2.39.1.456.gfc5497dd1b-goog


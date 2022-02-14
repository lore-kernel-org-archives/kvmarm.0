Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ABE9C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 06:58:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2DEB4005D;
	Mon, 14 Feb 2022 01:58:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gauT3Kcfd1ba; Mon, 14 Feb 2022 01:58:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B37840307;
	Mon, 14 Feb 2022 01:58:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CBE240307
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 01:58:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MV-aiNE5MTqT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 01:58:51 -0500 (EST)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4BD974005D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 01:58:51 -0500 (EST)
Received: by mail-pf1-f202.google.com with SMTP id
 t24-20020aa79398000000b004e025989ac7so11067643pfe.18
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 22:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Vgj7XyLBFPYAYQwkppKUlj1n4wNsE6rj/FNpKMfCu98=;
 b=X8PhvwO70NUYonvD0HTdnUHU45JRDfKSdCmvbdLYMMheOGPxsobxzpmQhhn1JV5yR1
 3ey9KZIk/4L3L4EIsMLnaV1y6pdpBc87/NJt/Pdx/rGnnp+vCVhu8njDIUOjfRiZ61wC
 DU7vJHp1bEL8nxohyWy6w6VKOo7X5As1m6Yr5cm53gGSuSJCTCSViTuUiFuF/4l0nOJS
 tQav1nnI8GPYYBjy2wyHZ/jA2bgjk1hc61vkmCLYE1L1iiNrnvL2zdv5H0UmUqUd7RWP
 e94RxB4l0pG3h13FawkIHYO4LvZeQphnc44AIoBH76BKpnj688RL7Hqy4ZWssIP+eSPr
 1kcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Vgj7XyLBFPYAYQwkppKUlj1n4wNsE6rj/FNpKMfCu98=;
 b=men78VmiC5dngfzRpyyU7b5pxn7brza7oh7UewWuPG0V6vt9hwNQHGn4r+Co2xChzP
 HLAIsxKeni6MqHrQed816WDQAkP0q/oD3UKIp5/Dh7Xr/asN1cJhMdfQVstmSrAUyTtn
 nZVmevMm/9A8ruCQYm/k/7ZPFDDZ89QXJ4gKDWBgIvQaIHYapJQKj6Apvlc21lJJh4li
 ShHRMP1qNkHG6ULZw67ED0iIcXsAGlgRCfiSx09eR1AwtZKLz4SGhIX+ouk01QTc4235
 OuCS5/SCnuFgl6bnkb+E0OyDHXwZxf4Rut0iWk1K5J4QO+CahUwnD+/3DMc62Du1LlET
 TYrQ==
X-Gm-Message-State: AOAM533fqvqG7eyWZIrX3YO16qicNmO1tt5U8g5IoYNxlCb15ar2zeGE
 XDBwbtUB3dhkAKXHcWGZQnKWrM8NvhY=
X-Google-Smtp-Source: ABdhPJy8Hzl4YbaIt8QMfE4WTT3z8QzyQIgGU0BcTS5sA4D2u0uCKZBxRlvVDTAvuEN6TnANhGtjHvLk0fs=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a62:e508:: with SMTP id
 n8mr12935031pff.83.1644821930480; 
 Sun, 13 Feb 2022 22:58:50 -0800 (PST)
Date: Sun, 13 Feb 2022 22:57:21 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-3-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 02/27] KVM: arm64: Save ID registers' sanitized value per
 guest
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
and save ID registers' sanitized value in the array at KVM_CREATE_VM.
Use the saved ones when ID registers are read by the guest or
userspace (via KVM_GET_ONE_REG).

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 12 ++++++
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/sys_regs.c         | 65 ++++++++++++++++++++++++-------
 3 files changed, 63 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2869259e10c0..c041e5afe3d2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -101,6 +101,13 @@ struct kvm_s2_mmu {
 struct kvm_arch_memory_slot {
 };
 
+/*
+ * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
+ * where 0<=crm<8, 0<=op2<8.
+ */
+#define KVM_ARM_ID_REG_MAX_NUM	64
+#define IDREG_IDX(id)		((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
+
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
@@ -137,6 +144,9 @@ struct kvm_arch {
 	/* Memory Tagging Extension enabled for the guest */
 	bool mte_enabled;
 	bool ran_once;
+
+	/* ID registers for the guest. */
+	u64 id_regs[KVM_ARM_ID_REG_MAX_NUM];
 };
 
 struct kvm_vcpu_fault_info {
@@ -736,6 +746,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
+void set_default_id_regs(struct kvm *kvm);
+
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4783dbf66df2..91110d996ed6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -156,6 +156,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
 
 	set_default_spectre(kvm);
+	set_default_id_regs(kvm);
 
 	return ret;
 out_free_stage2_pgd:
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4dc2fba316ff..080908c60fa6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -33,6 +33,8 @@
 
 #include "trace.h"
 
+static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
+
 /*
  * All of this file is extremely similar to the ARM coproc.c, but the
  * types are different. My gut feeling is that it should be pretty
@@ -273,7 +275,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	u64 val = __read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
 	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
@@ -1059,17 +1061,16 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-/* Read a sanitised cpufeature ID register by sys_reg_desc */
-static u64 read_id_reg(const struct kvm_vcpu *vcpu,
-		struct sys_reg_desc const *r, bool raz)
+static bool is_id_reg(u32 id)
 {
-	u32 id = reg_to_encoding(r);
-	u64 val;
-
-	if (raz)
-		return 0;
+	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
+		sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 0 &&
+		sys_reg_CRm(id) < 8);
+}
 
-	val = read_sanitised_ftr_reg(id);
+static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
+{
+	u64 val = vcpu->kvm->arch.id_regs[IDREG_IDX(id)];
 
 	switch (id) {
 	case SYS_ID_AA64PFR0_EL1:
@@ -1119,6 +1120,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	return val;
 }
 
+static u64 read_id_reg(const struct kvm_vcpu *vcpu,
+		       struct sys_reg_desc const *r, bool raz)
+{
+	u32 id = reg_to_encoding(r);
+
+	return raz ? 0 : __read_id_reg(vcpu, id);
+}
+
 static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
 				  const struct sys_reg_desc *r)
 {
@@ -1223,9 +1232,8 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 /*
  * cpufeature ID register user accessors
  *
- * For now, these registers are immutable for userspace, so no values
- * are stored, and for set_id_reg() we don't allow the effective value
- * to be changed.
+ * For now, these registers are immutable for userspace, so for set_id_reg()
+ * we don't allow the effective value to be changed.
  */
 static int __get_id_reg(const struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
@@ -1837,8 +1845,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 	if (p->is_write) {
 		return ignore_write(vcpu, p);
 	} else {
-		u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
-		u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+		u64 dfr = __read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
+		u64 pfr = __read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
 		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
 
 		p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
@@ -2850,3 +2858,30 @@ void kvm_sys_reg_table_init(void)
 	/* Clear all higher bits. */
 	cache_levels &= (1 << (i*3))-1;
 }
+
+/*
+ * Set the guest's ID registers that are defined in sys_reg_descs[]
+ * with ID_SANITISED() to the host's sanitized value.
+ */
+void set_default_id_regs(struct kvm *kvm)
+{
+	int i;
+	u32 id;
+	const struct sys_reg_desc *rd;
+	u64 val;
+
+	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
+		rd = &sys_reg_descs[i];
+		if (rd->access != access_id_reg)
+			/* Not ID register, or hidden/reserved ID register */
+			continue;
+
+		id = reg_to_encoding(rd);
+		if (WARN_ON_ONCE(!is_id_reg(id)))
+			/* Shouldn't happen */
+			continue;
+
+		val = read_sanitised_ftr_reg(id);
+		kvm->arch.id_regs[IDREG_IDX(id)] = val;
+	}
+}
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

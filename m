Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94718C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:57:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 388F94089E;
	Tue, 19 Apr 2022 02:57:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JOfLcSVfofao; Tue, 19 Apr 2022 02:57:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAE3D4B1D5;
	Tue, 19 Apr 2022 02:57:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 821D84B1D0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e92hp-OPcdBY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:10 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 19E524B1BF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:10 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 oj16-20020a17090b4d9000b001c7552b7546so1165849pjb.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=wwGm9HLNSmhYfgL+YutMxTHGZ3Nf+ncKTp/wt1uJeaM=;
 b=XZHkzRY5NcvY30i9Q68ueVyPZmpJrlgUXM6h2+Ht++CNJhuk9Ab/S5OX4prgP9L0li
 cLCdb4V+SosvjKsZ6zrGUmpNHG44sSBViRtKLIAtooDqePFK+BHwMTLERxF4xXmGqZJS
 kd0FA792uE+WB6Ae6g8la4N52N/vvh/GLoKLbCYkjymgCHFVJuM+lJQUCBISgG+vnqQ7
 rXX1eO+2zd+2m4tM/P/GrBXZIL0apQkxpz12n35DCTaG5w9/M2MNdx3NjQV5Ch0KdHOt
 oNM1EjISJ13+fZxQq2W9FTESsyIjid3v+3tFbIRgHvqR1jxfPH1qLJ4Amcp/ws75Fvf1
 W5gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wwGm9HLNSmhYfgL+YutMxTHGZ3Nf+ncKTp/wt1uJeaM=;
 b=lxtVlZFz3ZxdaOcMxdNzTbg6QLtUw/G7LgFPHejlFS40rAf7TlvgrDcgg95UwrWFYf
 pgmS481l6yhjQT/o66xl1xtmGYrpBA385gS0ZfsAmg9n4Yo/BPZailiaEnHINMRhAfZD
 eSaFswRMAHfp5i7kql4ZxoQQ/SnVP9589TaEp3VkjHyUyhkDC/Zr3BbUESoUBusIPI2q
 hfpu3tMAUydGQIke0hNXynMTrmoLzdtbPMLDw95ZyfPiA8pXk+dSUza07bvObzPZf+fp
 uKVim21IiieYi06RCv6G1lzHYmRudFtjZFURRMpeTDlq/13G6oD3FfNwx42U9if8Nt7e
 To2A==
X-Gm-Message-State: AOAM532RkOFGSZMr7sGOLsvNz9ZflLTr4Xoj77lw9vpZmN9HJoj8JdOL
 /TJDLJH8V1/zWBWRmlwYZ1MRxMjza1k=
X-Google-Smtp-Source: ABdhPJxn5yJvOYBVq+YRQNQ/f8W+joFEc2Uin92mJVYL2mkjO+sikRGNfunowGA6J8dBpaXEP7qKj3+ikfM=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:2d7:b0:508:383e:249e with SMTP id
 b23-20020a056a0002d700b00508383e249emr16114091pft.71.1650351428925; Mon, 18
 Apr 2022 23:57:08 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:08 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-3-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 02/38] KVM: arm64: Save ID registers' sanitized value per
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
 arch/arm64/include/asm/kvm_host.h | 11 +++++
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/sys_regs.c         | 81 +++++++++++++++++++++++++------
 3 files changed, 78 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 94a27a7520f4..fc836df84748 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -150,6 +150,15 @@ struct kvm_arch {
 
 	u8 pfr0_csv2;
 	u8 pfr0_csv3;
+
+	/*
+	 * Save ID registers for the guest in id_regs[].
+	 * (Op0, Op1, CRn, CRm, Op2) of the ID registers to be saved in it
+	 * is (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8.
+	 */
+#define KVM_ARM_ID_REG_MAX_NUM	56
+#define IDREG_IDX(id)		(((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id))
+	u64 id_regs[KVM_ARM_ID_REG_MAX_NUM];
 };
 
 struct kvm_vcpu_fault_info {
@@ -775,6 +784,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
+void set_default_id_regs(struct kvm *kvm);
+
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 523bc934fe2f..04312f7ee0da 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -156,6 +156,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
 
 	set_default_spectre(kvm);
+	set_default_id_regs(kvm);
 
 	return ret;
 out_free_stage2_pgd:
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7b45c040cc27..5b813a0b7b1c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -33,6 +33,8 @@
 
 #include "trace.h"
 
+static u64 read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id);
+
 /*
  * All of this file is extremely similar to the ARM coproc.c, but the
  * types are different. My gut feeling is that it should be pretty
@@ -277,7 +279,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	u64 val = read_id_reg_with_encoding(vcpu, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
 	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
@@ -1102,17 +1104,20 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-/* Read a sanitised cpufeature ID register by sys_reg_desc */
-static u64 read_id_reg(const struct kvm_vcpu *vcpu,
-		struct sys_reg_desc const *r, bool raz)
+/*
+ * Return true if the register's (Op0, Op1, CRn, CRm, Op2) is
+ * (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8.
+ */
+static bool is_id_reg(u32 id)
 {
-	u32 id = reg_to_encoding(r);
-	u64 val;
-
-	if (raz)
-		return 0;
+	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
+		sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 1 &&
+		sys_reg_CRm(id) < 8);
+}
 
-	val = read_sanitised_ftr_reg(id);
+static u64 read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
+{
+	u64 val = vcpu->kvm->arch.id_regs[IDREG_IDX(id)];
 
 	switch (id) {
 	case SYS_ID_AA64PFR0_EL1:
@@ -1167,6 +1172,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	return val;
 }
 
+static u64 read_id_reg(const struct kvm_vcpu *vcpu,
+		       struct sys_reg_desc const *r, bool raz)
+{
+	u32 id = reg_to_encoding(r);
+
+	return raz ? 0 : read_id_reg_with_encoding(vcpu, id);
+}
+
 static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
 				  const struct sys_reg_desc *r)
 {
@@ -1267,9 +1280,8 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -1882,8 +1894,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 	if (p->is_write) {
 		return ignore_write(vcpu, p);
 	} else {
-		u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
-		u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+		u64 dfr = read_id_reg_with_encoding(vcpu, SYS_ID_AA64DFR0_EL1);
+		u64 pfr = read_id_reg_with_encoding(vcpu, SYS_ID_AA64PFR0_EL1);
 		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
 
 		p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
@@ -2895,3 +2907,42 @@ void kvm_sys_reg_table_init(void)
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
+	struct sys_reg_params params = {
+		Op0(sys_reg_Op0(SYS_ID_PFR0_EL1)),
+		Op1(sys_reg_Op1(SYS_ID_PFR0_EL1)),
+		CRn(sys_reg_CRn(SYS_ID_PFR0_EL1)),
+		CRm(sys_reg_CRm(SYS_ID_PFR0_EL1)),
+		Op2(sys_reg_Op2(SYS_ID_PFR0_EL1)),
+	};
+
+	/*
+	 * Find the first entry of the ID register (ID_PFR0_EL1) from
+	 * sys_reg_descs table, and walk through only the ID register
+	 * entries in the table.
+	 */
+	rd = find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+	for (i = 0; i < KVM_ARM_ID_REG_MAX_NUM; i++, rd++) {
+		id = reg_to_encoding(rd);
+		if (WARN_ON_ONCE(!is_id_reg(id)))
+			/* Shouldn't happen */
+			continue;
+
+		if (rd->access != access_id_reg)
+			/* Hidden or reserved ID register */
+			continue;
+
+		val = read_sanitised_ftr_reg(id);
+		kvm->arch.id_regs[IDREG_IDX(id)] = val;
+	}
+}
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

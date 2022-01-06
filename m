Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2639C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 04:28:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44B4D49F23;
	Wed,  5 Jan 2022 23:28:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vptfQYr6fu2E; Wed,  5 Jan 2022 23:28:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 924C449F2B;
	Wed,  5 Jan 2022 23:28:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E58740CE3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ei-NvB-j6b-V for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 23:28:36 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD9E940BBF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:36 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 62-20020a17090a0fc400b001b31e840054so3079311pjz.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 20:28:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Cmw0YPZBvJnkSOnzwn2ej6WEs9laqQ+8DrquJ83QiUU=;
 b=F7xxjNweTbKdWDdPup8jmxysqWjcowj4zeq6O4I5wiMvtlaRAZCAHLkQ3NNjV2nA4J
 4RGYmtuM6bDsxmuBtevR8XFxIJbMT3qJGHxH3BWc90zgS5keKdRRFY3i4FhpLyBcOKtI
 GvhDhCsd8XGIVz3oupyXYHj+YFQz1csuu0rsPjBVMIRHV7GJvLisdK7sXfKex5xgI7pX
 DpLVYerMKEo5NrHUM4N67cWY01trTP3XbVVhfHCEcQM57rPtaaVXIw6wZ/vs4ZHrUWt3
 65OnM16YygpQD2mgoHE/T3Kvfu+M1vr4WEuuVyMF9Wf/CzuuRl4dNe/8j5sa45N/mbSA
 6ZOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Cmw0YPZBvJnkSOnzwn2ej6WEs9laqQ+8DrquJ83QiUU=;
 b=JZ/OVlNbP15YsvYyWfjfcra3a92Ay4VJVJdiF7iuP+BDjQXA3dLf0gTdVv4Z6Y21ZX
 gSqp1pFjLLJYDMAmHBr9iSyvyPpjBmSakTz0O+IOBwumrNutMQ6b6IQ4c/GTRft1F3m2
 f9Oj7YgLjkiJIogFRy8oSmvgWODecz4Tt+D1XRIJwbIr8Ghlm06c3+ykm/EAllXQZ49l
 6KH5R5iFzX56X5um44tQV5bJwnb5EZ0CosP423SZvC6CI3f86waAiwME4JsbInN9n+f/
 mArMTLF/n4eJhjH/OePp+tBJKYJhje5HlrWjQrC9wBd+UpDMd2Vq+XtQatrQYXVX+euc
 A8rQ==
X-Gm-Message-State: AOAM531+21KnhtQ7sFdl4MnNrp9pHay0m+RUx+74BwHE16rROsJ9JpPY
 CDuMNTSH6QpxAktVP+SuqJk+ZNHf41s=
X-Google-Smtp-Source: ABdhPJxQR/LEc2pV+ysPtVeFivGLmW2KgaAjCBufFgVI58gN6UvBfs5Ayr/3UrmDszM1lx16JNG5w8SBAX8=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a63:4d17:: with SMTP id
 a23mr51755292pgb.179.1641443315947; 
 Wed, 05 Jan 2022 20:28:35 -0800 (PST)
Date: Wed,  5 Jan 2022 20:26:46 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-5-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 04/26] KVM: arm64: Make ID_AA64PFR0_EL1 writable
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

This patch adds id_reg_info for ID_AA64PFR0_EL1 to make it writable by
userspace.

Return an error if userspace tries to set SVE/GIC field of the register
to a value that conflicts with SVE/GIC configuration for the guest.
SIMD/FP/SVE fields of the requested value are validated according to
Arm ARM.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |   1 +
 arch/arm64/include/asm/sysreg.h   |   2 +
 arch/arm64/kvm/sys_regs.c         | 177 +++++++++++++++++++-----------
 arch/arm64/kvm/vgic/vgic-init.c   |   5 +
 4 files changed, 123 insertions(+), 62 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c789a0137f58..4509f9e7472d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -749,6 +749,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
 void set_default_id_regs(struct kvm *kvm);
+int kvm_set_id_reg_feature(struct kvm *kvm, u32 id, u8 field_shift, u8 fval);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 16b3f1a1d468..e26027817171 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -798,6 +798,7 @@
 #define ID_AA64PFR0_ASIMD_SUPPORTED	0x0
 #define ID_AA64PFR0_ELx_64BIT_ONLY	0x1
 #define ID_AA64PFR0_ELx_32BIT_64BIT	0x2
+#define ID_AA64PFR0_GIC3		0x1
 
 /* id_aa64pfr1 */
 #define ID_AA64PFR1_MPAMFRAC_SHIFT	16
@@ -1197,6 +1198,7 @@
 #define ICH_VTR_TDS_MASK	(1 << ICH_VTR_TDS_SHIFT)
 
 #define ARM64_FEATURE_FIELD_BITS	4
+#define ARM64_FEATURE_FIELD_MASK	((1ull << ARM64_FEATURE_FIELD_BITS) - 1)
 
 /* Create a mask for the feature bits of the specified feature. */
 #define ARM64_FEATURE_MASK(x)	(GENMASK_ULL(x##_SHIFT + ARM64_FEATURE_FIELD_BITS - 1, x##_SHIFT))
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 971018288bee..1eb5c5fb614f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -318,6 +318,92 @@ static void id_reg_info_init(struct id_reg_info *id_reg)
 		id_reg->init(id_reg);
 }
 
+static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
+				    const struct id_reg_info *id_reg, u64 val)
+{
+	int fp, simd;
+	unsigned int gic;
+	bool vcpu_has_sve = vcpu_has_sve(vcpu);
+	bool pfr0_has_sve = id_aa64pfr0_sve(val);
+
+	simd = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_ASIMD_SHIFT);
+	fp = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_FP_SHIFT);
+	if (simd != fp)
+		return -EINVAL;
+
+	/* fp must be supported when sve is supported */
+	if (pfr0_has_sve && (fp < 0))
+		return -EINVAL;
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
+	if (vcpu_has_sve ^ pfr0_has_sve)
+		return -EPERM;
+
+	if ((irqchip_in_kernel(vcpu->kvm) &&
+	     vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)) {
+		gic = cpuid_feature_extract_unsigned_field(val,
+							ID_AA64PFR0_GIC_SHIFT);
+		if (gic == 0)
+			return -EPERM;
+
+		if (gic > ID_AA64PFR0_GIC3)
+			return -E2BIG;
+	} else {
+		u64 mask = ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
+		int err = arm64_check_features(id_reg->sys_reg, val & mask,
+					       id_reg->vcpu_limit_val & mask);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
+{
+	u64 limit = id_reg->vcpu_limit_val;
+	unsigned int gic;
+
+	limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_AMU);
+	if (!system_supports_sve())
+		limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
+
+	/*
+	 * The default is to expose CSV2 == 1 and CSV3 == 1 if the HW
+	 * isn't affected.  Userspace can override this as long as it
+	 * doesn't promise the impossible.
+	 */
+	limit &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2) |
+		   ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3));
+
+	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
+		limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2), 1);
+	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED)
+		limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), 1);
+
+	gic = cpuid_feature_extract_unsigned_field(limit, ID_AA64PFR0_GIC_SHIFT);
+	if (gic > 1) {
+		/* Limit to GICv3.0/4.0 */
+		limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
+		limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), ID_AA64PFR0_GIC3);
+	}
+	id_reg->vcpu_limit_val = limit;
+}
+
+static u64 vcpu_mask_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu,
+					 const struct id_reg_info *idr)
+{
+	return vcpu_has_sve(vcpu) ? 0 : ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
+}
+
+static struct id_reg_info id_aa64pfr0_el1_info = {
+	.sys_reg = SYS_ID_AA64PFR0_EL1,
+	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR0_GIC),
+	.init = init_id_aa64pfr0_el1_info,
+	.validate = validate_id_aa64pfr0_el1,
+	.vcpu_mask = vcpu_mask_id_aa64pfr0_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -326,7 +412,9 @@ static void id_reg_info_init(struct id_reg_info *id_reg)
  * validation, etc.)
  */
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
-static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {};
+static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
+	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
+};
 
 static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
 {
@@ -1161,12 +1249,12 @@ static u64 read_kvm_id_reg(struct kvm *kvm, u32 id)
 	return kvm->arch.id_regs[IDREG_IDX(id)];
 }
 
-static int modify_kvm_id_reg(struct kvm *kvm, u32 id, u64 val,
+static int __modify_kvm_id_reg(struct kvm *kvm, u32 id, u64 val,
 			     u64 preserve_mask)
 {
 	u64 old, new;
 
-	mutex_lock(&kvm->lock);
+	lockdep_assert_held(&kvm->lock);
 
 	old = kvm->arch.id_regs[IDREG_IDX(id)];
 
@@ -1179,11 +1267,21 @@ static int modify_kvm_id_reg(struct kvm *kvm, u32 id, u64 val,
 		return -EBUSY;
 
 	WRITE_ONCE(kvm->arch.id_regs[IDREG_IDX(id)], new);
-	mutex_unlock(&kvm->lock);
 
 	return 0;
 }
 
+static int modify_kvm_id_reg(struct kvm *kvm, u32 id, u64 val,
+			     u64 preserve_mask)
+{
+	int ret;
+
+	mutex_lock(&kvm->lock);
+	ret = __modify_kvm_id_reg(kvm, id, val, preserve_mask);
+	mutex_unlock(&kvm->lock);
+
+	return ret;
+}
 static int write_kvm_id_reg(struct kvm *kvm, u32 id, u64 val)
 {
 	return modify_kvm_id_reg(kvm, id, val, 0);
@@ -1233,20 +1331,6 @@ static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 		val &= ~(id_reg->vcpu_mask(vcpu, id_reg));
 
 	switch (id) {
-	case SYS_ID_AA64PFR0_EL1:
-		if (!vcpu_has_sve(vcpu))
-			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_AMU);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
-		if (irqchip_in_kernel(vcpu->kvm) &&
-		    vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
-			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
-			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), 1);
-		}
-		break;
 	case SYS_ID_AA64PFR1_EL1:
 		if (!kvm_has_mte(vcpu->kvm))
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
@@ -1347,48 +1431,6 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
-static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
-			       const struct sys_reg_desc *rd,
-			       const struct kvm_one_reg *reg, void __user *uaddr)
-{
-	const u64 id = sys_reg_to_index(rd);
-	u8 csv2, csv3;
-	int err;
-	u64 val;
-
-	err = reg_from_user(&val, uaddr, id);
-	if (err)
-		return err;
-
-	/*
-	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
-	 * it doesn't promise more than what is actually provided (the
-	 * guest could otherwise be covered in ectoplasmic residue).
-	 */
-	csv2 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_CSV2_SHIFT);
-	if (csv2 > 1 ||
-	    (csv2 && arm64_get_spectre_v2_state() != SPECTRE_UNAFFECTED))
-		return -EINVAL;
-
-	/* Same thing for CSV3 */
-	csv3 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_CSV3_SHIFT);
-	if (csv3 > 1 ||
-	    (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
-		return -EINVAL;
-
-	/* We can only differ with CSV[23], and anything else is an error */
-	val ^= read_id_reg(vcpu, rd, false);
-	val &= ~((0xFUL << ID_AA64PFR0_CSV2_SHIFT) |
-		 (0xFUL << ID_AA64PFR0_CSV3_SHIFT));
-	if (val)
-		return -EINVAL;
-
-	vcpu->kvm->arch.pfr0_csv2 = csv2;
-	vcpu->kvm->arch.pfr0_csv3 = csv3 ;
-
-	return 0;
-}
-
 /* cpufeature ID register user accessors */
 static int __get_id_reg(const struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
@@ -1702,8 +1744,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* AArch64 ID registers */
 	/* CRm=4 */
-	{ SYS_DESC(SYS_ID_AA64PFR0_EL1), .access = access_id_reg,
-	  .get_user = get_id_reg, .set_user = set_id_aa64pfr0_el1, },
+	ID_SANITISED(ID_AA64PFR0_EL1),
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
@@ -3095,3 +3136,15 @@ void set_default_id_regs(struct kvm *kvm)
 		(void)write_kvm_id_reg(kvm, id, val);
 	}
 }
+
+/*
+ * Update the ID register's field with @fval for the guest.
+ * The caller is expected to hold the kvm->lock.
+ */
+int kvm_set_id_reg_feature(struct kvm *kvm, u32 id, u8 field_shift, u8 fval)
+{
+	u64 val = ((u64)fval & ARM64_FEATURE_FIELD_MASK) << field_shift;
+	u64 preserve_mask = ~(ARM64_FEATURE_FIELD_MASK << field_shift);
+
+	return __modify_kvm_id_reg(kvm, id, val, preserve_mask);
+}
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 0a06d0648970..28d9bf0e178c 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -116,6 +116,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	else
 		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
 
+	if (type == KVM_DEV_TYPE_ARM_VGIC_V3)
+		/* Set ID_AA64PFR0_EL1.GIC to 1 */
+		(void)kvm_set_id_reg_feature(kvm, SYS_ID_AA64PFR0_EL1,
+				     ID_AA64PFR0_GIC3, ID_AA64PFR0_GIC_SHIFT);
+
 out_unlock:
 	unlock_all_vcpus(kvm);
 	return ret;
-- 
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

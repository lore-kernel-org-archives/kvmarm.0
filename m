Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB4BC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:50:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 73C9E63222
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:50:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 73C9E63222
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1657C4B104;
	Wed, 17 Nov 2021 01:50:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lYKxg-ZvTrFY; Wed, 17 Nov 2021 01:49:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A3994B0F4;
	Wed, 17 Nov 2021 01:49:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 176434A500
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:49:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rPwZxWRBKApF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 01:49:55 -0500 (EST)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BBED249E5F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:49:55 -0500 (EST)
Received: by mail-pg1-f202.google.com with SMTP id
 s8-20020a63af48000000b002e6c10ac245so692560pgo.21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 22:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=pnVV0dDUXWANaZ8aWNvfjhrF5PhVCI804E2zH0wOM3E=;
 b=ceapl6AvPZI3/vC2mwRnLl7KjxDguO+n/2FhAKPMEsWeJcr6nh2z5ML5Zyspn+X+oi
 eOG5b9oMdf4M0ijZrTl3BB+twEpz7SLT3PQGPwwee7YEWvqiKhz4kpHkQkPFScEOubhh
 PHmDRXKLhg8b0bK463OW3zcR6hYneuOfXGsKWWo0vpCxB5Qab3vX428m4V6U9V6ADRMU
 LHifHn8XYOmf6vtXXDBZNhcbWng3mx7aesw+zV7tK1qcFe0GJ3Eed3XMfN+CafmGWV7W
 3nbmgaPA40qIFpGunX/KR6GztN7/vjVwbUY5DsFDQ2Av8jeR4NKCYgtkakr8LNjARLVp
 VoQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=pnVV0dDUXWANaZ8aWNvfjhrF5PhVCI804E2zH0wOM3E=;
 b=LGvuHEXdsaYILoFh+TlFtsooU8QPiBcBRUeHfZv6L+F3XdFb/M6XHcMcWelr6VscLP
 4Xx5tM5sn/BgMePSQdsjlw9TNgogNbYB5RYGz0KcmMPxG6SBae8HdyC04k8uJm4YaZcZ
 2YpZ5YhHr6WLrjDMgAI8Xt1PHRxF5PgI1NETdggonSZPwJMqQCoD97DAVgtP4W9qj51+
 fa3BT/ADiCrPs0IPC5eABgRmoBvYdoPXuprnsjogKw0paAmgDJWHLXxA0Vivc8TrS4Ib
 Hop646euqkve1rCmXiGkQlTV0oXqp92j50M9PRr9ji5Gq2TNYdhnLaGNpax/3C/qy4QL
 u9bw==
X-Gm-Message-State: AOAM530E3qxUdo+cXj3JQFTLHlxUcKaUi9VeGHF9xZyVTP8T5VQ42Tq5
 QvjPpP0hMJ2khGFpJs6X6oh+iBUL7ZQ=
X-Google-Smtp-Source: ABdhPJyGFmsrlVNrwecF2T+roRV3vrXO6UsZB0R8DGqP/IeotHb/4HF1tiOSvziAZ09+qdqIbL0UHS+Zs7Q=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:903:408c:b0:142:45a9:672c with SMTP id
 z12-20020a170903408c00b0014245a9672cmr51484560plc.7.1637131794924; Tue, 16
 Nov 2021 22:49:54 -0800 (PST)
Date: Tue, 16 Nov 2021 22:43:34 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-5-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 04/29] KVM: arm64: Make ID_AA64PFR0_EL1 writable
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

The CSV2/CSV3 fields of the register were already writable and values
that were written for them affected all vCPUs before. Now they only
affect the vCPU.
Return an error if userspace tries to set SVE/GIC field of the register
to a value that conflicts with SVE/GIC configuration for the guest.
SIMD/FP/SVE fields of the requested value are validated according to
Arm ARM.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 159 ++++++++++++++++++++++++--------------
 1 file changed, 103 insertions(+), 56 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1552cd5581b7..35400869067a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -401,6 +401,92 @@ static void id_reg_info_init(struct id_reg_info *id_reg)
 		id_reg->init(id_reg);
 }
 
+#define	kvm_has_gic3(kvm)		\
+	(irqchip_in_kernel(kvm) &&	\
+	 (kvm)->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
+
+static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
+				    const struct id_reg_info *id_reg, u64 val)
+{
+	int fp, simd;
+	bool vcpu_has_sve = vcpu_has_sve(vcpu);
+	bool pfr0_has_sve = id_aa64pfr0_sve(val);
+	int gic;
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
+	gic = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_GIC_SHIFT);
+	if ((gic > 0) ^ kvm_has_gic3(vcpu->kvm))
+		return -EPERM;
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
+		limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), 1);
+	}
+	id_reg->vcpu_limit_val = limit;
+}
+
+static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
+				     const struct id_reg_info *idr)
+{
+	u64 val = idr->vcpu_limit_val;
+
+	if (!vcpu_has_sve(vcpu))
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
+
+	if (!kvm_has_gic3(vcpu->kvm))
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
+
+	return val;
+}
+
+static struct id_reg_info id_aa64pfr0_el1_info = {
+	.sys_reg = SYS_ID_AA64PFR0_EL1,
+	.ftr_check_types = S_FCT(ID_AA64PFR0_ASIMD_SHIFT, FCT_LOWER_SAFE) |
+			   S_FCT(ID_AA64PFR0_FP_SHIFT, FCT_LOWER_SAFE),
+	.init = init_id_aa64pfr0_el1_info,
+	.validate = validate_id_aa64pfr0_el1,
+	.get_reset_val = get_reset_id_aa64pfr0_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -409,7 +495,9 @@ static void id_reg_info_init(struct id_reg_info *id_reg)
  * validation, etc.)
  */
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
-static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {};
+static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
+	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
+};
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
 			   const struct sys_reg_desc *rd, u64 val)
@@ -1239,20 +1327,22 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 {
 	u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
+	u64 lim, gic, gic_lim;
+	const struct id_reg_info *id_reg;
 
 	switch (id) {
 	case SYS_ID_AA64PFR0_EL1:
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
+		gic = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_GIC_SHIFT);
+		if (kvm_has_gic3(vcpu->kvm) && (gic == 0)) {
+			/*
+			 * This is a case where userspace configured gic3 after
+			 * the vcpu was created, and then it didn't set
+			 * ID_AA64PFR0_EL1.
+			 */
+			id_reg = GET_ID_REG_INFO(id);
+			lim = id_reg->vcpu_limit_val;
+			gic_lim = cpuid_feature_extract_unsigned_field(lim, ID_AA64PFR0_GIC_SHIFT);
+			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), gic_lim);
 		}
 		break;
 	case SYS_ID_AA64PFR1_EL1:
@@ -1373,48 +1463,6 @@ static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
 	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = val;
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
@@ -1705,8 +1753,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* AArch64 ID registers */
 	/* CRm=4 */
-	{ SYS_DESC(SYS_ID_AA64PFR0_EL1), .access = access_id_reg,
-	  .get_user = get_id_reg, .set_user = set_id_aa64pfr0_el1, },
+	ID_SANITISED(ID_AA64PFR0_EL1),
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

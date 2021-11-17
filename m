Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 358DBC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C22DE63232
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C22DE63232
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 753004B166;
	Wed, 17 Nov 2021 01:53:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4m9pBeF94DIo; Wed, 17 Nov 2021 01:53:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24A0C4B156;
	Wed, 17 Nov 2021 01:53:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74E3F4B15A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0mkPC6IrRnkJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 01:53:35 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A7BC04B08D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:34 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 x25-20020aa79199000000b0044caf0d1ba8so1142126pfa.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 22:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=psTrxtwmxcm5rWooRpuQaAR3nVgY0IlcZBqer69Z6tc=;
 b=UBXpZukQ5zrpL7SsqvdkAikI4NJd2P3kp46lyiX+NiYdeleul7dfOIZgS5AoRGDAT4
 YT8MM21cnN42v5+kuoXy96L507UgNYucGn+LJ1AWuJFcPmKKav0LaCJxD6GZf2bPQ/qd
 0thX01zvsbvmKoRZ4xTE+OFYeFCwKTEYUwP7iwEK5b7lYJGki0/dVul6DGDRieTcsONv
 oLw0mgBPd3y16/s9uWKcxKV2SvXuPMl+jA6dHY1bMwEeiOpYdg0teT7dZWlpwwrm6D7l
 VJgrzmujyZHFg1hc/Dx3ZdLy2MkcA/+Je/I/Bm8skN9QNUpa/DD3ABdw+EjxlPRfxwkN
 9cqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=psTrxtwmxcm5rWooRpuQaAR3nVgY0IlcZBqer69Z6tc=;
 b=XWH2wQfUzF8IX0KqScRmZwviNRwuGGr0OS2P3dQFJ/LSjVxHxQzUlxIWx/P3w7tvQ/
 xLR6PP7t8auX6XaFKMT/tluXnQhmg/t//6CQFaMP3E82YxRTG5keA/FR1T2iOzBlvD+3
 HwXke8r7xI/qghcNH2gbyD/DmqumL9DfOHxU1ISlx90AXdirDhPmWQJGBUXFr/2uJBSg
 ZYuTvm/U2K38fAgttFQkd2AN+ZiemHa1mnend4eHHOj/09k9U40jW92quMYVqwlMU5RV
 w8UmOhQRI/Aou2Iu9LngcgIdmqb6BUxQf3LXOT0X49KGaljP+X/WWH2jpwjZqNjIdXCQ
 5eng==
X-Gm-Message-State: AOAM531F8XF6mt13fC6RL5EWuUdaztTXOFxHHd1wpUR/a288AYnfKgT0
 k4RVvolin02FiHVOBqLdsOKrCxLDMLQ=
X-Google-Smtp-Source: ABdhPJw8RPq/1UnPllZ/jYUntq5PJiPUgqtorRSt/EgY0E8lnwwEIidYAysxQZUIwRz0bj4FwGjlkwwQcX8=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:390a:: with SMTP id
 ob10mr6950955pjb.216.1637132013923; Tue, 16 Nov 2021 22:53:33 -0800 (PST)
Date: Tue, 16 Nov 2021 22:43:46 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-17-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 16/29] KVM: arm64: Add consistency checking for frac
 fields of ID registers
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

Feature fractional field of an ID register cannot be simply validated
at KVM_SET_ONE_REG because its validity depends on its (main) feature
field value, which could be in a different ID register (and might be
set later).
Validate fractional fields at the first KVM_RUN instead.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |   2 +
 arch/arm64/kvm/arm.c              |   3 +
 arch/arm64/kvm/sys_regs.c         | 125 +++++++++++++++++++++++++++++-
 3 files changed, 127 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 72db73c79403..9dc9970a2d46 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -746,6 +746,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
+int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu);
+
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2f03cbfefe67..19c4a78f931d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -588,6 +588,9 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	if (!kvm_arm_vcpu_is_finalized(vcpu))
 		return -EPERM;
 
+	if (!kvm_vm_is_protected(kvm) && kvm_id_regs_consistency_check(vcpu))
+		return -EPERM;
+
 	vcpu->arch.has_run_once = true;
 
 	kvm_arm_vcpu_init_debug(vcpu);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 35e458cc1e1d..b848ecea0c59 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -841,9 +841,6 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 
 static struct id_reg_info id_aa64pfr1_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR1_EL1,
-	.ftr_check_types = U_FCT(ID_AA64PFR1_RASFRAC_SHIFT, FCT_IGNORE) |
-			   U_FCT(ID_AA64PFR1_MPAMFRAC_SHIFT, FCT_IGNORE) |
-			   U_FCT(ID_AA64PFR1_CSV2FRAC_SHIFT, FCT_IGNORE),
 	.init = init_id_aa64pfr1_el1_info,
 	.validate = validate_id_aa64pfr1_el1,
 	.get_reset_val = get_reset_id_aa64pfr1_el1,
@@ -3460,10 +3457,106 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
+/* ID register's fractional field information with its feature field. */
+struct feature_frac {
+	u32	id;
+	u32	shift;
+	u32	frac_id;
+	u32	frac_shift;
+	u8	frac_ftr_check;
+};
+
+static struct feature_frac feature_frac_table[] = {
+	{
+		.frac_id = SYS_ID_AA64PFR1_EL1,
+		.frac_shift = ID_AA64PFR1_RASFRAC_SHIFT,
+		.id = SYS_ID_AA64PFR0_EL1,
+		.shift = ID_AA64PFR0_RAS_SHIFT,
+	},
+	{
+		.frac_id = SYS_ID_AA64PFR1_EL1,
+		.frac_shift = ID_AA64PFR1_MPAMFRAC_SHIFT,
+		.id = SYS_ID_AA64PFR0_EL1,
+		.shift = ID_AA64PFR0_MPAM_SHIFT,
+	},
+	{
+		.frac_id = SYS_ID_AA64PFR1_EL1,
+		.frac_shift = ID_AA64PFR1_CSV2FRAC_SHIFT,
+		.id = SYS_ID_AA64PFR0_EL1,
+		.shift = ID_AA64PFR0_CSV2_SHIFT,
+	},
+};
+
+/*
+ * Return non-zero if the feature/fractional fields pair are not
+ * supported. Return zero otherwise.
+ * This function only checks fractional feature field and assumes
+ * the feature field is valid.
+ */
+static int vcpu_id_reg_feature_frac_check(const struct kvm_vcpu *vcpu,
+					  const struct feature_frac *ftr_frac)
+{
+	u32 id;
+	int fval, flim, ret;
+	u64 val, lim, mask;
+	const struct id_reg_info *id_reg;
+	bool sign = FCT_SIGN(ftr_frac->frac_ftr_check);
+	enum feature_check_type type = FCT_TYPE(ftr_frac->frac_ftr_check);
+
+	/* Check if the feature field value is same as the limit */
+	id = ftr_frac->id;
+	id_reg = GET_ID_REG_INFO(id);
+
+	val = __read_id_reg(vcpu, id);
+	lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
+
+	mask = (u64)ARM64_FEATURE_FIELD_MASK << ftr_frac->shift;
+	if ((val & mask) != (lim & mask))
+		/*
+		 * The feature level is smaller than the limit.
+		 * Any fractional version should be fine.
+		 */
+		return 0;
+
+	/* Check the fractional feature field */
+	id = ftr_frac->frac_id;
+	id_reg = GET_ID_REG_INFO(id);
+
+	val = __read_id_reg(vcpu, id);
+	fval = cpuid_feature_extract_field(val, ftr_frac->frac_shift, sign);
+
+	lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
+	flim = cpuid_feature_extract_field(lim, ftr_frac->frac_shift, sign);
+
+	ret = arm64_check_feature_one(type, fval, flim);
+	return ret ? -E2BIG : 0;
+}
+
+int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu)
+{
+	int i, err;
+	const struct feature_frac *frac;
+
+	/*
+	 * Check ID registers' fractional fields, which aren't checked
+	 * at KVM_SET_ONE_REG.
+	 */
+	for (i = 0; i < ARRAY_SIZE(feature_frac_table); i++) {
+		frac = &feature_frac_table[i];
+		err = vcpu_id_reg_feature_frac_check(vcpu, frac);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 static void id_reg_info_init_all(void)
 {
 	int i;
 	struct id_reg_info *id_reg;
+	struct feature_frac *frac;
+	u64 mask = ARM64_FEATURE_FIELD_MASK;
+	u64 org;
 
 	for (i = 0; i < ARRAY_SIZE(id_reg_info_table); i++) {
 		id_reg = (struct id_reg_info *)id_reg_info_table[i];
@@ -3472,6 +3565,32 @@ static void id_reg_info_init_all(void)
 
 		id_reg_info_init(id_reg);
 	}
+
+	for (i = 0; i < ARRAY_SIZE(feature_frac_table); i++) {
+		frac = &feature_frac_table[i];
+		id_reg = GET_ID_REG_INFO(frac->frac_id);
+
+		/*
+		 * An ID register that has fractional fields is expected
+		 * to have its own id_reg_info.
+		 */
+		if (WARN_ON_ONCE(!id_reg))
+			continue;
+
+		/*
+		 * Update the id_reg's ftr_check_types for the fractional
+		 * field with FCT_IGNORE so that the field won't be validated
+		 * when the ID register is set by userspace, which could
+		 * temporarily cause an inconsistency if its (main) feature
+		 * field is not set yet.  Save the original ftr_check_types
+		 * for the fractional field to validate the field later.
+		 */
+		org = (id_reg->ftr_check_types >> frac->frac_shift) & mask;
+		id_reg->ftr_check_types &= ~(mask << frac->frac_shift);
+		id_reg->ftr_check_types |=
+			MAKE_FCT(frac->frac_shift, FCT_IGNORE, FCT_SIGN(org));
+		frac->frac_ftr_check = org;
+	}
 }
 
 void kvm_sys_reg_table_init(void)
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

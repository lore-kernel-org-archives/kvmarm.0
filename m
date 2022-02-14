Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CF9C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 07:01:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A2FE49EBA;
	Mon, 14 Feb 2022 02:01:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Vy0Wvo2yGbN6; Mon, 14 Feb 2022 02:01:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B3B649E27;
	Mon, 14 Feb 2022 02:01:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6F7F40C0A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:01:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id htt1DOuc2Zvq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 02:01:22 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 407B549E08
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:01:22 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 gf24-20020a17090ac7d800b001b8c5543bd1so13475460pjb.9
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 23:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=wbtKndzAWvCkk7WyRwv4b5BaCedyCpezxbPT2xu5RJI=;
 b=p6ujj/lKiFqYkdKFMxlHGT+Frbk0tdmmd9TniaJj8/tpMqYTDNEGFxATe8rnWIymL/
 ObEcGY34riW2pN4p5uuyMYUwl77InvEVNgVZ8rWwF5F+vdqBJ1eHv9feQIvrJ7pjHZjG
 DzKl1FMeYMXz3NHD8ReCUOx1/Cvdf1acbtkqsxVZUPMiUEEHxlK/AC8q3XONnkRwT0OV
 1xTHodCTqhi0ySWqpoO7EuFnqYEhzVgeQEewffTmFxNSfBIQXoP6J4a+vXCjxaCKs7UM
 Gg6QuYGNH4SfYvRZKxkAnCY24l1xno9QweTQnQigeQ63LR96xoCuAkm4e0RwN2/ybsgF
 E0Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wbtKndzAWvCkk7WyRwv4b5BaCedyCpezxbPT2xu5RJI=;
 b=aUTeOb02ojU/QFGPeezKfz33rIHmyrMhH+YZ3q/PPdyfxbcu9xwL25Z6UX5q80q+XM
 KtYeSD3u8IgbTCRdxGMMYRXuDXedE4pDHbLCi3VlQ1DnS3i2KLtGPc2JtuKE2vlj5uFj
 OAhkye5h799q7Bevb8O6YWDM++2Hl0a7yEfbu0RH+qxTStYATOwx09zfcfoxzHT+4LKO
 0yrTKYg6RSb3LBpEN6K6ZWwry6E8/adpvzKGvKgYLjsGYSqYKbcy7XoMtdVOyc4Lhn92
 IZ1llBREd/T/vOwsn0d1g9U9hs9mv9epJiuZwcG/iosX7Z6HruOsb8wHisjmF8vmmFsK
 z9ig==
X-Gm-Message-State: AOAM532VyaZUk2CDOdsHSBzf03z0JyA8/Ky69AiszfFxzEVXjJanCf0T
 Q+mSN3BxKzWrF59SkC1Y2h1wJJ6I7B0=
X-Google-Smtp-Source: ABdhPJwYu3eHHu7vONkLYq7yvs6BlGo8YwufFo6hGxBHerJCuXqQM+wJbzVOX7Pn89wbvQVd+ujOZB5s4qM=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:e40f:: with SMTP id
 hv15mr1640233pjb.1.1644822081267; Sun, 13 Feb 2022 23:01:21 -0800 (PST)
Date: Sun, 13 Feb 2022 22:57:40 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-22-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 21/27] KVM: arm64: Trap disabled features of ID_AA64PFR0_EL1
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

Add feature_config_ctrl for RAS and AMU, which are indicated in
ID_AA64PFR0_EL1, to program configuration registers to trap
guest's using those features when they are not exposed to the guest.

Introduce trap_ras_regs() to change a behavior of guest's access to
the registers, which is currently raz/wi, depending on the feature's
availability for the guest (and inject undefined instruction
exception when guest's RAS register access are trapped and RAS is
not exposed to the guest).  In order to keep the current visibility
of the RAS registers from userspace (always visible), a visibility
function for RAS registers is not added.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 90 +++++++++++++++++++++++++++++++++++----
 1 file changed, 82 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index faa28e7926b2..72b7cfaef41e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -304,6 +304,63 @@ struct feature_config_ctrl {
 	void	(*trap_activate)(struct kvm_vcpu *vcpu);
 };
 
+enum vcpu_config_reg {
+	VCPU_HCR_EL2 = 1,
+	VCPU_MDCR_EL2,
+	VCPU_CPTR_EL2,
+};
+
+static void feature_trap_activate(struct kvm_vcpu *vcpu,
+				  enum vcpu_config_reg cfg_reg,
+				  u64 cfg_set, u64 cfg_clear)
+{
+	u64 *reg_ptr, reg_val;
+
+	switch (cfg_reg) {
+	case VCPU_HCR_EL2:
+		reg_ptr = &vcpu->arch.hcr_el2;
+		break;
+	case VCPU_MDCR_EL2:
+		reg_ptr = &vcpu->arch.mdcr_el2;
+		break;
+	case VCPU_CPTR_EL2:
+		reg_ptr = &vcpu->arch.cptr_el2;
+		break;
+	}
+
+	/* Clear/Set fields that are indicated by cfg_clear/cfg_set. */
+	reg_val = (*reg_ptr & ~cfg_clear);
+	reg_val |= cfg_set;
+	*reg_ptr = reg_val;
+}
+
+static void feature_ras_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TERR | HCR_TEA, HCR_FIEN);
+}
+
+static void feature_amu_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_CPTR_EL2, CPTR_EL2_TAM, 0);
+}
+
+/* For ID_AA64PFR0_EL1 */
+static struct feature_config_ctrl ftr_ctrl_ras = {
+	.ftr_reg = SYS_ID_AA64PFR0_EL1,
+	.ftr_shift = ID_AA64PFR0_RAS_SHIFT,
+	.ftr_min = ID_AA64PFR0_RAS_V1,
+	.ftr_signed = FTR_UNSIGNED,
+	.trap_activate = feature_ras_trap_activate,
+};
+
+static struct feature_config_ctrl ftr_ctrl_amu = {
+	.ftr_reg = SYS_ID_AA64PFR0_EL1,
+	.ftr_shift = ID_AA64PFR0_AMU_SHIFT,
+	.ftr_min = ID_AA64PFR0_AMU,
+	.ftr_signed = FTR_UNSIGNED,
+	.trap_activate = feature_amu_trap_activate,
+};
+
 struct id_reg_info {
 	/* Register ID */
 	u32	sys_reg;
@@ -816,6 +873,11 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 	.init = init_id_aa64pfr0_el1_info,
 	.validate = validate_id_aa64pfr0_el1,
 	.vcpu_mask = vcpu_mask_id_aa64pfr0_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_ras,
+		&ftr_ctrl_amu,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_aa64pfr1_el1_info = {
@@ -945,6 +1007,18 @@ static inline bool vcpu_feature_is_available(struct kvm_vcpu *vcpu,
 	return feature_avail(ctrl, val);
 }
 
+static bool trap_ras_regs(struct kvm_vcpu *vcpu,
+			  struct sys_reg_params *p,
+			  const struct sys_reg_desc *r)
+{
+	if (!vcpu_feature_is_available(vcpu, &ftr_ctrl_ras)) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
+	return trap_raz_wi(vcpu, p, r);
+}
+
 /*
  * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
  * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
@@ -2316,14 +2390,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_AFSR1_EL1), access_vm_reg, reset_unknown, AFSR1_EL1 },
 	{ SYS_DESC(SYS_ESR_EL1), access_vm_reg, reset_unknown, ESR_EL1 },
 
-	{ SYS_DESC(SYS_ERRIDR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERRSELR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXFR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXCTLR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXSTATUS_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXADDR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXMISC0_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXMISC1_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_ERRIDR_EL1), trap_ras_regs },
+	{ SYS_DESC(SYS_ERRSELR_EL1), trap_ras_regs },
+	{ SYS_DESC(SYS_ERXFR_EL1), trap_ras_regs },
+	{ SYS_DESC(SYS_ERXCTLR_EL1), trap_ras_regs },
+	{ SYS_DESC(SYS_ERXSTATUS_EL1), trap_ras_regs },
+	{ SYS_DESC(SYS_ERXADDR_EL1), trap_ras_regs },
+	{ SYS_DESC(SYS_ERXMISC0_EL1), trap_ras_regs },
+	{ SYS_DESC(SYS_ERXMISC1_EL1), trap_ras_regs },
 
 	MTE_REG(TFSR_EL1),
 	MTE_REG(TFSRE0_EL1),
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

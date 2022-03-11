Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FAF4C43217
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 04:49:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2731F49F11;
	Thu, 10 Mar 2022 23:49:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IUBdrJsnhp+l; Thu, 10 Mar 2022 23:49:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 093B649EC1;
	Thu, 10 Mar 2022 23:49:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D587C49EB5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:49:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8AVmscGv91oz for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 23:49:04 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5EE4B41174
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:49:03 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 j10-20020a17090a7e8a00b001bbef243093so7191171pjl.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 20:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=zv2nragi6VCMhrP9RIAZluYZ3kaqdgQBPPUgqdiA67k=;
 b=k2wcaxfjBN7e1gGyczyvGVZ5SRaRU/0+Cfw8qqRRc3LBRLiBiCZ4K9wmtGmryGqlUT
 MJUDo6l42Sonpc3K9YzDGcB8YAZCCTWjQkgLJpx8HTuqRULTZaJlPB1DrG3gJNQlt4ec
 6eaU7Y6j4KlvVHHQZFMSea1vXO4Dmq7i2nALxJX9wqCItMdaz/E615qkKCfjIxNG7RDb
 004H2hCXVL6Jwn/mXpWt4SySzKVNlZfg/0/H0tU2c4n4QybMerW+QnDtQGJY3Qr8SETn
 hyLqPJvj2SrbSuFucjnfEg4/UKXFBBEtQZHl/rp5gj6ryg66qqAzCSvIqXzztynjM5Sr
 StiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=zv2nragi6VCMhrP9RIAZluYZ3kaqdgQBPPUgqdiA67k=;
 b=y80/QwgV/wb2TwfCUQZZsLb/Mzs4eNVUpi99xJ6jZGho27Mdq89+LrV92tqc9/a1ps
 rI3em5CD5Bit6iqwo7n/wt5wfjLjvd175+RZswGiQQwGjT8PG9Me85FRPwK3jNHsamCo
 Crz6pc09GfOOA/1VTXf9uVa5e8yubORvI8/MolKJYIHnO+DeVLCxzztqqgBrwOfumkUP
 njo0Q8eI5udX2juXv0CoTm8JJqyVU8tad9fimbPPYl8U55h9ka8832YGJBjC39DP5fWf
 mQPkL2gOgTITvkJLq/6nrepmzDPKSNjvVLssIif7ME9vMskcX64Fm9aXdELcxXAkPsrh
 ZNiw==
X-Gm-Message-State: AOAM531fQu8qWtSFYRvfvLtt+ps/w98negmcgmZ/mMDQw4smrh4qKBX2
 srPJ9TzJRWpCwjbs10Pnq65RolYBwc0=
X-Google-Smtp-Source: ABdhPJxgt3wVmNEP7Hp+XFmZZ6kh7g5UV/GpW30zYhq2KR8GWwKyrVydsF3qaN7mryevseZDC1NDCvbjms0=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:808:b0:4f7:765c:7606 with SMTP id
 m8-20020a056a00080800b004f7765c7606mr6390477pfk.57.1646974142570; Thu, 10 Mar
 2022 20:49:02 -0800 (PST)
Date: Thu, 10 Mar 2022 20:48:05 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-20-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 19/25] KVM: arm64: Trap disabled features of ID_AA64PFR0_EL1
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
index a754099d2a73..3f3f2800ff8b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -305,6 +305,63 @@ struct feature_config_ctrl {
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
 /* id_reg_desc flags field values */
 #define ID_DESC_REG_UNALLOC	(1UL << 0)
 #define ID_DESC_REG_HIDDEN	(1UL << 1)
@@ -853,6 +910,18 @@ static inline bool vcpu_feature_is_available(struct kvm_vcpu *vcpu,
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
@@ -2155,14 +2224,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
@@ -3598,6 +3667,11 @@ static struct id_reg_desc id_aa64pfr0_el1_desc = {
 	.init = init_id_aa64pfr0_el1_desc,
 	.validate = validate_id_aa64pfr0_el1,
 	.vcpu_mask = vcpu_mask_id_aa64pfr0_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_ras,
+		&ftr_ctrl_amu,
+		NULL,
+	},
 };
 
 static struct id_reg_desc id_aa64pfr1_el1_desc = {
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

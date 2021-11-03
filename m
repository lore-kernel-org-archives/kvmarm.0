Return-Path: <SRS0=1z46=PW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84AC3C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 150B261181
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 150B261181
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3E754B190;
	Wed,  3 Nov 2021 02:28:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YvVxTljq52yw; Wed,  3 Nov 2021 02:28:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BE144B1B2;
	Wed,  3 Nov 2021 02:28:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EAA54B188
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TqYkeNtaQYWL for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 02:28:32 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9DD94B1AA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:31 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 u10-20020a170902e80a00b001421d86afc4so267609plg.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 23:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=stxvqpS43GKPlFzuxNRd3Kw5X/pb/WSIMK3gN777H7I=;
 b=IHQDLDOYeY7XgsxKhEsFtXdkfK0mb0dBJWK6OuGaazo3Fodx/+jp4nrjFwRFVhyf8Q
 WR5kQW/dlUUPyoN4Csr/tkwoR4oeMQFo4PU+ByF5vABq5NYxNtsU9XzLKHlFVCxmX0dk
 yCleWxaFhOu04rzcLR+dHqVTHnSA0BjtHB8ePBqvn0h7+juHuxd50058AWol7qNsbdzA
 SLNYI4gL1xpNByWHOuyijeCltzuSHRy46GyVjmnAPwTjnAnxiY8+yForLk4w5vzN780E
 sR9Jqel9nyYzQyKNO36FT/oNO9q2IBIG5degiaLbnrU07lZn6gHFLZFihfGRbBufIsYe
 8rrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=stxvqpS43GKPlFzuxNRd3Kw5X/pb/WSIMK3gN777H7I=;
 b=8A6OB2UhK6dD/eQHO6AtH8Nvj/4mNzjqFAOg6dANZRS6q0vb6RI5BKhwOzK9UD8c99
 LxyZpWqkGUYfdBLzJMn6UvtwWlwJyYS2CEJgwjJrgBKpUpPVOJgjgGu/3EIdITmO4fnm
 lkPYHHeRIhPI5IV6eePrrHpjFcnPDl5CjhEI2OxAoqVw03nQalSDa/SKd10AVs3hW+cB
 cUXUJ8gCOFlvCunxUsm0ADX0seJ5YemYAPJlj0qdTWEy5XKYWrOJobR2r+GcaEQT/Hm+
 GO7hnBX95ex2iKIYSIdwu6GyRSMJsbDt/0T0d44C7D0ooOwNwZD4zwLj1nK0hQ7UieQk
 YCAg==
X-Gm-Message-State: AOAM533DDKxt5uTu2vXI4+Xfm9vSpr42zkPSSMxmcck8NT5w1ySdlSCy
 +QNKQYWojhYDes5FztMLcoGJcJCHWRk=
X-Google-Smtp-Source: ABdhPJwKC5UfgtW/4DN0Ud9DJaQEbXi5o3b0e5aheeOv71jnjTZGp0cYDLSH5/u/wOzSZOUSW+HvFY2qmz0=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:f24a:b0:141:c6fc:2e18 with SMTP id
 j10-20020a170902f24a00b00141c6fc2e18mr23852030plc.55.1635920911096; Tue, 02
 Nov 2021 23:28:31 -0700 (PDT)
Date: Tue,  2 Nov 2021 23:25:14 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-23-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 22/28] KVM: arm64: Trap disabled features of
 ID_AA64PFR0_EL1
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

No code is added for AMU's access/visibility handler because the
current code already injects the exception for Guest's AMU register
access unconditionally because AMU is never exposed to the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 54 +++++++++++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 504e1ff86848..99cbfa865864 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -403,6 +403,27 @@ struct feature_config_ctrl {
 	u64	cfg_val;	/* Value that are set for the field */
 };
 
+/* For ID_AA64PFR0_EL1 */
+static struct feature_config_ctrl ftr_ctrl_ras = {
+	.ftr_reg = SYS_ID_AA64PFR0_EL1,
+	.ftr_shift = ID_AA64PFR0_RAS_SHIFT,
+	.ftr_min = ID_AA64PFR0_RAS_V1,
+	.ftr_signed = FTR_UNSIGNED,
+	.cfg_reg = VCPU_HCR_EL2,
+	.cfg_mask = (HCR_TERR | HCR_TEA | HCR_FIEN),
+	.cfg_val = (HCR_TERR | HCR_TEA),
+};
+
+static struct feature_config_ctrl ftr_ctrl_amu = {
+	.ftr_reg = SYS_ID_AA64PFR0_EL1,
+	.ftr_shift = ID_AA64PFR0_AMU_SHIFT,
+	.ftr_min = ID_AA64PFR0_AMU,
+	.ftr_signed = FTR_UNSIGNED,
+	.cfg_reg = VCPU_CPTR_EL2,
+	.cfg_mask = CPTR_EL2_TAM,
+	.cfg_val = CPTR_EL2_TAM,
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -847,6 +868,11 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 	.init = init_id_aa64pfr0_el1_info,
 	.validate = validate_id_aa64pfr0_el1,
 	.get_reset_val = get_reset_id_aa64pfr0_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_ras,
+		&ftr_ctrl_amu,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_aa64pfr1_el1_info = {
@@ -1003,6 +1029,18 @@ static inline bool vcpu_feature_is_available(struct kvm_vcpu *vcpu,
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
@@ -2265,14 +2303,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

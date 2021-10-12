Return-Path: <SRS0=Zoam=PA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15AC3C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:37:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BDB7E6108F
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BDB7E6108F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 735534B16F;
	Tue, 12 Oct 2021 00:36:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nxcmnhyXt2wm; Tue, 12 Oct 2021 00:36:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B2414A49C;
	Tue, 12 Oct 2021 00:36:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E35904B15E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tP0Z5KG-kRIS for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Oct 2021 00:36:54 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE9744B11F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:53 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 u5-20020a63d3450000b029023a5f6e6f9bso8017698pgi.21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 21:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Q7BixuP9It6rmSZII5to1B682tn/DwfVjd2jGHGuE3Y=;
 b=VGyjwy0JLnxlj+5/nSK7fzF48FMF95j1whwYEMpop9FWTB0rqlyROF9oshJ3QC19Ah
 /nWVAeJYXtbJeeOlLH1Hc9uwEfAtyGk8MUxmFTq19H8/qadkNx6jrZEnOkwURLzC2fUl
 igxGrUonWVrPb8y1F0DrvziuACcatliv7ZDhATMzOtkVF4HHKQv1Hjb7OBYAni2IPR+/
 tShJ+JcFQPQigr0Xzq/uFDjxCZfpv+E8aCD0o5d5RL9BKthxy7V7aHUj533ZCFAyxkRO
 ZIRjwMvfOuP1CUsBO4HcQZ6sG+oThFCDbNRhtPeEP8AfPXKh5RA4n8TfknOirMYZ7Oqh
 e7Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Q7BixuP9It6rmSZII5to1B682tn/DwfVjd2jGHGuE3Y=;
 b=vO7gjrBN3iVlhhLhcDoLZ8RzX/IkgejF3kDgpylIF6Sjz+Bamm1icyI/QxeAXu3IKn
 Fd6fPVl/JM3gsxHa1PxCD/8EW73QSsCYMuS7CBEPxPvyU1+R2NaPHjL+VUKNuqKHug33
 7VLywRZxuoJ/mFqF69YklrlQi0p8cNkmnQtPn/M2thUNwVb2hJ3Vhj8dsoIR4fZHKz03
 AfGiVdhV3VvawIxn4B/9Vle/5j2AH/p7EEfU+WWqQbvDeHg8FRRcBmP1xLxwQN1F5dMI
 f/SL/KcU0br6HZt5i7RReBuCjIetTSlqVOdZwaEwuI8SudjjOV+Nl+yjF9ZHt+5eNe8P
 qm/Q==
X-Gm-Message-State: AOAM530o6F1TBo7zNnvKjowQhr36qvOBAD+Z26ggQ9FU861E/JFiESgk
 aXqUs5tM7KS0k+MmmtXFNjavQ32S0gg=
X-Google-Smtp-Source: ABdhPJw5rppfGPZ6lLyq9dLDd23bK7T/kn8o9AZfVh2XW/iGmZLrNXsPL87P/02l4KUEPKW2WmekxAQ68aU=
X-Received: from reiji-vws.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:2284:b0:43d:fc72:e565 with SMTP id
 f4-20020a056a00228400b0043dfc72e565mr29890632pfe.84.1634013413069; Mon, 11
 Oct 2021 21:36:53 -0700 (PDT)
Date: Mon, 11 Oct 2021 21:35:32 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-23-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 22/25] KVM: arm64: Trap disabled features of
 ID_AA64MMFR1_EL1
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

Add feature_config_ctrl for LORegions, which is indicated in
ID_AA64MMFR1_EL1, to program configuration register to trap
guest's using the feature when it is not exposed to the guest.

Change trap_loregion() to use vcpu_feature_is_available()
to simplify checking of the feature's availability.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 23a3bcac4986..68df4e4eba05 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -374,6 +374,17 @@ static struct feature_config_ctrl ftr_ctrl_tracefilt = {
 	.cfg_val = MDCR_EL2_TTRF,
 };
 
+/* For ID_AA64MMFR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_lor = {
+	.ftr_reg = SYS_ID_AA64MMFR1_EL1,
+	.ftr_shift = ID_AA64MMFR1_LOR_SHIFT,
+	.ftr_min = 1,
+	.ftr_signed = FTR_UNSIGNED,
+	.cfg_reg = VCPU_HCR_EL2,
+	.cfg_mask = HCR_TLOR,
+	.cfg_val = HCR_TLOR,
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -767,6 +778,14 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
 	},
 };
 
+static struct id_reg_info id_aa64mmfr1_el1_info = {
+	.sys_reg = SYS_ID_AA64MMFR1_EL1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_lor,
+		NULL,
+	},
+};
+
 static struct id_reg_info id_dfr0_el1_info = {
 	.sys_reg = SYS_ID_DFR0_EL1,
 	.init = init_id_dfr0_el1_info,
@@ -795,6 +814,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
+	[IDREG_IDX(SYS_ID_AA64MMFR1_EL1)] = &id_aa64mmfr1_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
@@ -891,10 +911,9 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64MMFR1_EL1));
 	u32 sr = reg_to_encoding(r);
 
-	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
+	if (!vcpu_feature_is_available(vcpu, &ftr_ctrl_lor)) {
 		kvm_inject_undefined(vcpu);
 		return false;
 	}
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

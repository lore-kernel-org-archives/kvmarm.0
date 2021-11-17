Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15276C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B9F26619F6
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B9F26619F6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E8274B0D7;
	Wed, 17 Nov 2021 01:53:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 76nFa0sHn-XI; Wed, 17 Nov 2021 01:53:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 638D64B1B2;
	Wed, 17 Nov 2021 01:53:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CA2E4B156
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9mJm-Gb96lr0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 01:53:50 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 07A314B199
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:49 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 mn13-20020a17090b188d00b001a64f277c1eso2632033pjb.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 22:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ap+PS7CD+HFBr7r8+vNbRPns4hwGZn9RZNY8Os9x/I8=;
 b=ME8TBN6HNLGOmfWdS07tu+6rYpz8jFnzNkaM3AZinIB5Y5rSPGGpQSiFoHOMsTPTgR
 KB+BXxWvxfUtevsqjCwhMzybSqT2HJRuVPaCCd/iP0EHRDDmNTDBaeXD6IeucnltyX5V
 8wnPTb44HXZ181eXmc6VngO8oBOrDFP/wOdDuIZ/b2iUw1nXOCxe/qQQDzlTxnRj9lWe
 PPrXTJyGtiFWiEThG9Z1i55BWOYWpWgTv911tEvlcAKzKXMTlxqzPfA2Mu/keixChqpF
 HDJwXVj3GrfQzaJ0SeyfC97K4M+g6d/bN1Vn2cnoPn7etEJqpn3cb/dJU0o0svqJNUax
 y3NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ap+PS7CD+HFBr7r8+vNbRPns4hwGZn9RZNY8Os9x/I8=;
 b=gXpTlxf42rGipwCHlhwuTBXH0oNs8WVPeQAivug2rlQUkqrvLuWua7mIv8mx8z1pRP
 irJ2LtVb7jJn2dC8Jw0qjWvbX3+wRsKGjZ9u+5hHHFHf3ILKgt/5lcfmKFGw2DzbIaHR
 Vg8OVRmvI+8lpSNP/ej8mVTQXd5Z0nD4BD3LiQsXlGR/aNn+A7DMbRjtEdxqpVXovera
 CfYulYhXhYtZsnypQebNag06d0vBrRe73GinhNuVEsMZHXJtpWNQXkto6MwtTyRiVMTa
 zL/IHXvVexdxut88+EEVkS6Q8LVB2D0jSPI/+yp0P2sqV3XIUMfRWhH4U4LdTwBWEJAN
 lvSA==
X-Gm-Message-State: AOAM530qZ2FSCupQTq5/HOsKz2v6uh/Xkt3lpODD35+jClLfTkbZA3f1
 IfjMr4vl34Wnrtmo78C/S1rX+4Z8GUs=
X-Google-Smtp-Source: ABdhPJx22jUgmf1vQhrGDnEI3IA2ofCSFdssKrHCARSsL9OdUAakMfgccLuH/dwXswlHbXm2xj+dGZ0IezE=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:3509:: with SMTP id
 ls9mr6754492pjb.99.1637132028334; Tue, 16 Nov 2021 22:53:48 -0800 (PST)
Date: Tue, 16 Nov 2021 22:43:55 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-26-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 25/29] KVM: arm64: Trap disabled features of
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
index cb18d1fe0658..3d3b29515b8b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -469,6 +469,17 @@ static struct feature_config_ctrl ftr_ctrl_tracefilt = {
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
@@ -992,6 +1003,14 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
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
@@ -1034,6 +1053,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64MMFR0_EL1)] = &id_aa64mmfr0_el1_info,
+	[IDREG_IDX(SYS_ID_AA64MMFR1_EL1)] = &id_aa64mmfr1_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
@@ -1128,10 +1148,9 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = __read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
-	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
+	if (!vcpu_feature_is_available(vcpu, &ftr_ctrl_lor)) {
 		kvm_inject_undefined(vcpu);
 		return false;
 	}
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

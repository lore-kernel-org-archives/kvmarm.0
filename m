Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83424C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 04:29:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FF6D4A10E;
	Wed,  5 Jan 2022 23:29:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dseMvnZfutHd; Wed,  5 Jan 2022 23:29:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C4524A417;
	Wed,  5 Jan 2022 23:29:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BF2449F44
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:29:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x1Yh3u9Zu4Ph for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 23:29:07 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E560440FAC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:29:03 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 y13-20020a17090a134d00b001b10368d9dcso1005305pjf.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 20:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=qPDa0VEsnhEJbcsFzMR0knGwcI8yYnbYngQzhurSzTI=;
 b=el0X9Zkgu29y78QxvRRd3e98uRJLbBfd8byXjqGxhRWbWZ5YLstsOUH3SFh+cW/6z/
 AVuB1b3VFvR84FyYVgCoeX3qyeSoxYIK9UU5iKlkt+sp13xtyJw7/vR4xGCQhIPlBtXs
 MlFRDk9JISkEweQpNA55vKistpn9TOflRmiQQHqXIG5WIJlgELrDF6YpN8bIcNyyqp9o
 F8Z4hvl/K/vZDGgrhVs9PXRe6QB09f/1aeu2jeZsgpsotEIpfkCZX+n9zCAVS0Onnnlq
 1vwCqEIl8gWTZ9xflG8USBgiBnrN/MhMk0hlU7CxCS6MR4Od2tIFu1cs91k+Y03JfjoF
 28kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=qPDa0VEsnhEJbcsFzMR0knGwcI8yYnbYngQzhurSzTI=;
 b=x6PGkywetAI2wXUfr52jx+5cy5A0ZEobulyzXsdSrFHXny+NmB1SJTHfkrEHMKpczG
 CptsB0+yQAMLphQ9peciQqiCrLm1uK3ZPbRwtcTVo/nm+7tyhSa7FgnQ6XcFWcEjAird
 ThvgfS3AAhwt8lP1aACDQ5VoCTZNEX7bVUAjIjnC+GtaAbfd1CysgM09D6nigMQMxhnF
 XRzCJCSS8q4nCTyUTjTFh/U3pj1zNFSDkRzRoN4Zu2l/t2/CA92xCLN8JokOQiIby/yp
 M4ZHv03y55fxc+prO/nQLPrclQOKLt5HNRIVjLump9Go3uYJlzXZfsrjsLc5xvTemMPY
 giHg==
X-Gm-Message-State: AOAM531bjOg2rLzkbX9vY/9CSXXNz1Mc1maMkk6z5L5/UOP0/g59boXB
 RsTrW+AHTNwS60TrgEZ6Gbe0lfbZDBU=
X-Google-Smtp-Source: ABdhPJw+xFogrAR3QZG8Cbh9A/rmDIhEkalnaXKaSZdJeTa/0vLqoOgvnJWOwy6unb5TL5lq547d52EGcuk=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:6a88:b0:149:848f:1e8b with SMTP id
 n8-20020a1709026a8800b00149848f1e8bmr44237005plk.124.1641443343115; Wed, 05
 Jan 2022 20:29:03 -0800 (PST)
Date: Wed,  5 Jan 2022 20:27:03 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-22-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 21/26] KVM: arm64: Trap disabled features of
 ID_AA64PFR1_EL1
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

Add feature_config_ctrl for MTE, which is indicated in
ID_AA64PFR1_EL1, to program configuration register to trap the
guest's using the feature when it is not exposed to the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 015d67092d5e..72e745c5a9c2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -344,6 +344,11 @@ static void feature_amu_trap_activate(struct kvm_vcpu *vcpu)
 	feature_trap_activate(vcpu, VCPU_CPTR_EL2, CPTR_EL2_TAM, 0);
 }
 
+static void feature_mte_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TID5, HCR_DCT | HCR_ATA);
+}
+
 /* For ID_AA64PFR0_EL1 */
 static struct feature_config_ctrl ftr_ctrl_ras = {
 	.ftr_reg = SYS_ID_AA64PFR0_EL1,
@@ -361,6 +366,15 @@ static struct feature_config_ctrl ftr_ctrl_amu = {
 	.trap_activate = feature_amu_trap_activate,
 };
 
+/* For ID_AA64PFR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_mte = {
+	.ftr_reg = SYS_ID_AA64PFR1_EL1,
+	.ftr_shift = ID_AA64PFR1_MTE_SHIFT,
+	.ftr_min = ID_AA64PFR1_MTE_EL0,
+	.ftr_signed = FTR_UNSIGNED,
+	.trap_activate = feature_mte_trap_activate,
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -847,6 +861,10 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
 	.init = init_id_aa64pfr1_el1_info,
 	.validate = validate_id_aa64pfr1_el1,
 	.vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_mte,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_aa64isar0_el1_info = {
-- 
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

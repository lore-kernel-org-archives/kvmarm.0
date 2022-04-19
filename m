Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD52C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:58:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7E044B1F5;
	Tue, 19 Apr 2022 02:58:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tVVvYjt4AV51; Tue, 19 Apr 2022 02:58:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E5E04B20A;
	Tue, 19 Apr 2022 02:58:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEABC4B1F1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:58:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U6BhreVO18eR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:57 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20BC34B25F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:55 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 f6-20020a170902ab8600b0015895212d23so9244443plr.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=FGn+d1/fzCMoysQ55Sv7panNzkYFCREIVH43wm5V/xU=;
 b=nbP6H9eLPB2KRUszqjTjx8oXBwErZ7lIfZHOLtdkJWYF4Y8A1N/NpiaKp37xuFx1Ud
 XFYUj8R3HIK/2yg2tTUzGPz29aiDAuuxLbJAZvX5j0DVwEfJ9DmZqNZuYwG854scSWEU
 KCgssLZ9jYfOjk0MY1SCFqfXsElf5DH70nSmWeFUNB3+TPODZGz0TwDe1XiI63R4XGqW
 dqIprL+Vy62aXPKqODFGp8794SpD9CXf3AgMD2as9uU2afjv9U086jbrTKkU7e+iSTca
 ZNe8BSjcDOQEwLGE2Riw8tDL09c0xKw6YVhUNpoL+BtOcOk72Wj/EgA9R6I8puV0x1Po
 kLNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=FGn+d1/fzCMoysQ55Sv7panNzkYFCREIVH43wm5V/xU=;
 b=VSfaX+ELA5AUlD2wn5lP/BlY5bukHwDEt2Wu0RbUFcKNLX+uX/fnJAeT5vrgd+gR4q
 P+1+iPk36epihw9yINTZF7Os3uitsz84nMa0gF2k6lKmt7Qt6qx/vxvxLK3c2XEI9ZIt
 2l4iGebMDDVxWNSFc77t9VV6Tcd93Oyfvl8mIQX0OAKl/88DW5+N9C+0an5iIm53pgzN
 3IYvvETJQ7SwTJZE4m60VuVBlGjjvbKYvonkJZ5yLorO+f5W0LTdI+N96hXx2ch2HhND
 BT7sZ/Jl8PuAsAeoiC4edBt36p/TY73jI18dNFDOpOuDFWZRzqUuxcaBq4H8P/Le1fS4
 fFcQ==
X-Gm-Message-State: AOAM530ZmdhD29EStvUjkztfWoJNz5mk2PRLWte1A4lBLhdVpRgqIFQK
 hfx/QcBuMAROZ3YSXVv1UljNzewAPU8=
X-Google-Smtp-Source: ABdhPJxpYOikvgNJvHHbbpFpSUMKs8Qh1bxceFJTHg4QBYMxz42FIi3eaMxP3/8CTDdPHB7uL9Sp54w8dR0=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:3b86:b0:1d2:66cf:569b with SMTP id
 pc6-20020a17090b3b8600b001d266cf569bmr14889978pjb.206.1650351474413; Mon, 18
 Apr 2022 23:57:54 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:36 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-31-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 30/38] KVM: arm64: Trap disabled features of
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
 arch/arm64/kvm/sys_regs.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a09c910198d6..6a8ed59d8d90 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -389,6 +389,11 @@ static void feature_tracefilt_trap_activate(struct kvm_vcpu *vcpu)
 	feature_trap_activate(vcpu, VCPU_MDCR_EL2, MDCR_EL2_TTRF, 0);
 }
 
+static void feature_lor_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TLOR, 0);
+}
+
 /* For ID_AA64PFR0_EL1 */
 static struct feature_config_ctrl ftr_ctrl_ras = {
 	.ftr_reg = SYS_ID_AA64PFR0_EL1,
@@ -448,6 +453,15 @@ static struct feature_config_ctrl ftr_ctrl_tracefilt = {
 	.trap_activate = feature_tracefilt_trap_activate,
 };
 
+/* For ID_AA64MMFR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_lor = {
+	.ftr_reg = SYS_ID_AA64MMFR1_EL1,
+	.ftr_shift = ID_AA64MMFR1_LOR_SHIFT,
+	.ftr_min = 1,
+	.ftr_signed = FTR_UNSIGNED,
+	.trap_activate = feature_lor_trap_activate,
+};
+
 #define __FTR_BITS(ftr_sign, ftr_type, bit_pos, safe) {		\
 	.sign = ftr_sign,					\
 	.type = ftr_type,					\
@@ -1104,10 +1118,9 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_id_reg_with_encoding(vcpu, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
-	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
+	if (!vcpu_feature_is_available(vcpu, &ftr_ctrl_lor)) {
 		kvm_inject_undefined(vcpu);
 		return false;
 	}
@@ -4433,6 +4446,14 @@ static struct id_reg_desc id_aa64mmfr0_el1_desc = {
 	},
 };
 
+static struct id_reg_desc id_aa64mmfr1_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_AA64MMFR1_EL1),
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_lor,
+		NULL,
+	},
+};
+
 static struct id_reg_desc id_aa64dfr0_el1_desc = {
 	.reg_desc = ID_SANITISED(ID_AA64DFR0_EL1),
 	/*
@@ -4577,7 +4598,7 @@ static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 
 	/* CRm=7 */
 	ID_DESC(ID_AA64MMFR0_EL1, &id_aa64mmfr0_el1_desc),
-	ID_DESC_DEFAULT(ID_AA64MMFR1_EL1),
+	ID_DESC(ID_AA64MMFR1_EL1, &id_aa64mmfr1_el1_desc),
 	ID_DESC_DEFAULT(ID_AA64MMFR2_EL1),
 	ID_DESC_UNALLOC(7, 3),
 	ID_DESC_UNALLOC(7, 4),
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

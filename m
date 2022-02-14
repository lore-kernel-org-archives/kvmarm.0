Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95465C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 07:01:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46D8D49EDE;
	Mon, 14 Feb 2022 02:01:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R1FOwxt2AY53; Mon, 14 Feb 2022 02:01:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02F9B49EB3;
	Mon, 14 Feb 2022 02:01:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53E6249EB3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:01:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pOeNjKSbrwGv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 02:01:41 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E0A1F49DED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:01:40 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 t16-20020a17090b019000b001b8af627800so13467088pjs.8
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 23:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ju7y0INwCkVlTLrGGMqN8WpA4pAC77LT4GJuAIzw0k4=;
 b=dW97xLS3Zq7BUp9OFgrYXx9OPZjlDniVb0QY3oGt2NWSrc9zm8dQdio2ZyVuL11KfO
 bGbdHEjXjbOQMA0MrV222jVAlYgL5ubTMCDAG0JdwDvryI4nu/xDi3CWKDX3tt4SQGnF
 XmQJtHEpXONICXTk3SQTNp8U4j+5LYhIEF4FnKvgzDTFpxhBfznHpdtoqfCpIIAGY9MS
 t8gjBeJiNsXwFR/MvrHpS+tZYzu5h+v6rPDGCfaLPpTv9PzzdVe5U0+/Jf8HltyKX3qB
 4oasagz52cbDQ9j9OgN4wRDWy3hvXkO/EXEzCPiy2RlF13N/gvr4te2XnQ765XXfteXV
 6waw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ju7y0INwCkVlTLrGGMqN8WpA4pAC77LT4GJuAIzw0k4=;
 b=vr3Ss1bxj0bV9Ipb4jZXijeAU5U+/HDl5T5YSJWLlGCUU7iSmr44w5wCMODwlKG8Ah
 iLoVeV9ynOSSFeFbPXR1frcVisiMpj9u0MatOtk0Li7mbJLKmdFxM/FmEfR7yvxVPvT0
 IcoApSnHyByLrtkmQuoUx64y9MdeHH6ia8ohlMDnnRD9jKtL/Uim0Kifs3DoEUVMOgTr
 y1GvSKZdX4I+jwcOUH4kj/UPczfg7AaH1FNcOChce0Hzd/i+pYB0fqxAF6naSG+CYhBt
 zDcpvAoqGRcIXdYCI44LXPtgKm7aF0/c9P26NCIkMVgIkvsg1b3gZgICp/ytc5RiqTM4
 MzRw==
X-Gm-Message-State: AOAM533eUy8eJD6fru8W7HGsvOFVQnliO8ejuORgNjHoFsgsJQfy+72g
 RGD12LZpD2y8+BoCY/QEuYU1ZmSdIHE=
X-Google-Smtp-Source: ABdhPJw38wrkf0DY+q9xEUe+4IZIcMsK0dHMLQQ5rU+27P+/eKD5VvrZIoA2rsFN/Y4lan8hmVuWz0OYkuM=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:dcca:: with SMTP id
 t10mr12648551pll.133.1644822100107; Sun, 13 Feb 2022 23:01:40 -0800 (PST)
Date: Sun, 13 Feb 2022 22:57:43 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-25-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 24/27] KVM: arm64: Trap disabled features of
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
 arch/arm64/kvm/sys_regs.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d91be297559d..205670a7d7c5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -373,6 +373,11 @@ static void feature_tracefilt_trap_activate(struct kvm_vcpu *vcpu)
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
@@ -432,6 +437,15 @@ static struct feature_config_ctrl ftr_ctrl_tracefilt = {
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
 struct id_reg_info {
 	/* Register ID */
 	u32	sys_reg;
@@ -991,6 +1005,10 @@ static struct id_reg_info id_aa64mmfr0_el1_info = {
 static struct id_reg_info id_aa64mmfr1_el1_info = {
 	.sys_reg = SYS_ID_AA64MMFR1_EL1,
 	.validate = validate_id_aa64mmfr1_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_lor,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_aa64dfr0_el1_info = {
@@ -1111,10 +1129,9 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
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
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

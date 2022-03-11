Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B5EBC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 04:49:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0360149EF1;
	Thu, 10 Mar 2022 23:49:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GYUWVNw6wku7; Thu, 10 Mar 2022 23:49:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 679FC49F1C;
	Thu, 10 Mar 2022 23:49:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B07E49EE3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:49:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M5QTMKVeiu1u for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 23:49:10 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C0A249EE9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:49:10 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 j9-20020a170903024900b0015195e68490so3904142plh.19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 20:49:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=7z5Uw2gRXSzvSWZCDvr7dARcE7XtDS3gb33aMNuIZp0=;
 b=LgvVZuqBFOS0jJKhiMC7n9409cSkdsgPrFen1ZDgAcy8XvbK5y7SuNyF2yj99Gs50X
 8ctQndJnSgLFIAP995LFH9A9CyErl47PF5oJfFOu37jmWeQMiZlViWMsQEMouVLx2FId
 uw+L8ae+yJG3jRPydLz99/TREejGMtYarMr2/rXAq8Tn5lS+SPhVzfCJotveG3TIQZiQ
 DNxTGJan0vG2MDqBnZuRXt5+Wgx/DkcsUZfeBOe9WM466Bhc6ShUyRX9yyMHE0vpZlP+
 hIit8D51RNTa1Bc+lf1P3YK4GXsm1D6MV0qYFKb+lJ2vdpvDXYmqaRka0xVr+4UriKpe
 d/7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=7z5Uw2gRXSzvSWZCDvr7dARcE7XtDS3gb33aMNuIZp0=;
 b=7jhBhri0EkeYKb1HlL2ogFHJnP+Df46Qe8DQ9yJ0aZAAasNqpV3VhvBmaWUfiurA/l
 603lreARWAba64Yy4wjuCbeEcAJ4BRA6YvV2IiyK6iWzofj8DNzPITRDP+JmKwUEfbmT
 WBWBPwguiI0VtfgZMA9ZP2ygqHBjHkmFSje/4fTCnCa5ZVnjTu+0wixBsNVyBkjDfwPO
 UE52KLusKOY/7AcaS4Mh9EjgN33kCVIVGbhxvPxDoxI4jOcANPO5ardkxz1g7sBAV6xL
 hV6Dprbw8MHXz7yM5M2pOFpGPKo0mDyvKvCSY9tmHqr3JvzDL8cKvNchX+8t4SdQ8iuc
 /9zQ==
X-Gm-Message-State: AOAM5338curvoGjFXmS5N4VkE7CbAk9JbzHGGVuUJepxgSf6hCFde9A0
 uflHpu8a1iDuZoMMSFNyvHgEOvCraJw=
X-Google-Smtp-Source: ABdhPJw61zM8eXq9A5LGOH7Lc1dcnB3i8F9/nsnO0WTPLudzhQ0Ew+bphYaAwCUfdiwvwCU4sgAbzOAPE+w=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:228b:b0:4f7:9155:b685 with SMTP id
 f11-20020a056a00228b00b004f79155b685mr208604pfe.61.1646974149257; Thu, 10 Mar
 2022 20:49:09 -0800 (PST)
Date: Thu, 10 Mar 2022 20:48:09 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-24-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 23/25] KVM: arm64: Trap disabled features of
 ID_AA64ISAR1_EL1
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

Add feature_config_ctrl for PTRAUTH, which is indicated in
ID_AA64ISAR1_EL1, to program configuration register to trap
guest's using the feature when it is not exposed to the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f3661881cbed..881e8879a48b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -284,6 +284,30 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPI_SHIFT) >= \
 	 ID_AA64ISAR1_GPI_IMP_DEF)
 
+/*
+ * Return true if ptrauth needs to be trapped.
+ * (i.e. if ptrauth is supported on the host but not exposed to the guest)
+ */
+static bool vcpu_need_trap_ptrauth(struct kvm_vcpu *vcpu)
+{
+	u64 val;
+	bool generic, address;
+
+	if (!system_has_full_ptr_auth())
+		/* The feature is not supported. */
+		return false;
+
+	val = read_id_reg_with_encoding(vcpu, SYS_ID_AA64ISAR1_EL1);
+	generic = aa64isar1_has_gpi(val) || aa64isar1_has_gpa(val);
+	address = aa64isar1_has_api(val) || aa64isar1_has_apa(val);
+	if (generic && address)
+		/* The feature is available. */
+		return false;
+
+	/* The feature is supported but hidden. */
+	return true;
+}
+
 /*
  * Feature information to program configuration register to trap or disable
  * guest's using a feature when the feature is not exposed to the guest.
@@ -379,6 +403,11 @@ static void feature_lor_trap_activate(struct kvm_vcpu *vcpu)
 	feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TLOR, 0);
 }
 
+static void feature_ptrauth_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_HCR_EL2, 0, HCR_API | HCR_APK);
+}
+
 /* For ID_AA64PFR0_EL1 */
 static struct feature_config_ctrl ftr_ctrl_ras = {
 	.ftr_reg = SYS_ID_AA64PFR0_EL1,
@@ -447,6 +476,12 @@ static struct feature_config_ctrl ftr_ctrl_lor = {
 	.trap_activate = feature_lor_trap_activate,
 };
 
+/* For SYS_ID_AA64ISAR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_ptrauth = {
+	.ftr_need_trap = vcpu_need_trap_ptrauth,
+	.trap_activate = feature_ptrauth_trap_activate,
+};
+
 /* id_reg_desc flags field values */
 #define ID_DESC_REG_UNALLOC	(1UL << 0)
 #define ID_DESC_REG_HIDDEN	(1UL << 1)
@@ -3782,6 +3817,10 @@ static struct id_reg_desc id_aa64isar1_el1_desc = {
 	.init = init_id_aa64isar1_el1_desc,
 	.validate = validate_id_aa64isar1_el1,
 	.vcpu_mask = vcpu_mask_id_aa64isar1_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_ptrauth,
+		NULL,
+	},
 };
 
 static struct id_reg_desc id_aa64mmfr0_el1_desc = {
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

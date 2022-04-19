Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E412C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:58:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05E984B236;
	Tue, 19 Apr 2022 02:58:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QRkAAvHm9+Xv; Tue, 19 Apr 2022 02:58:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DC744B284;
	Tue, 19 Apr 2022 02:58:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD8A54B218
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wycdj5OXTztr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:57 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 77D024B23F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:56 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 l7-20020a17090b078700b001d090271f1dso1192572pjz.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=YLQ/jtBXlP9biEBlw29VzMlxGtkHK85JhXdSg1Dey2k=;
 b=eAw4dTke4ES4lJseM7OQ6Z/1m7Omzg+78Rf0GXMt1GNKwDyp38SZ6TmEaeL41gIF3V
 O3W2n9UMmq+6M2Dlqx7kPsxjW9QwgcacCCvhksep5fJ2ps5tbZ4U6zJw0q2UO/Zml3ym
 9BCmmDCprmbgGdLCXrZdHzt/XmNLdUXEBH4TBQs6gcdzLkC7ybe3KRk952sC/b6zHZSA
 iAvYXo/EGdqGvbO71ux5zx0vlb30A3xe8dM0BJSX6BxG1QZD+7b6D7VD8d30WtVdba9j
 P00CX0knXDaWtBD1id8WQ6fLIy/E99z+vOOTA5nnERYy6RpDQtJR1OgHZ37/lfhfTb+s
 RrxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=YLQ/jtBXlP9biEBlw29VzMlxGtkHK85JhXdSg1Dey2k=;
 b=pI6AhrYy/AMoohSFrVZZCPwDI5alpQzWPFZmBSM8EbB5+j0ZkhV5NUzPjvsi7eHKB3
 qK9VkJifx6h6h0kHGZ3OSasL6qq3sUYwc23Ztg516C0ywsHABaRy69VpOJtW5uMtB6k3
 0WIQgB+czHEev4feEIoj6ZzpskNgWjTtXtXWhdGjiUXePv5mInFEk6D3th3x88jXYTyY
 pnLQLc2SkAXWf5xpoDXk2Dtsu/rT2a5KiPaMa2Yme7zRh8Ktk96dH+zqWKjUBTDVWDfR
 3wLXyHd4WCYGduIFyCF10OvlC12f5RTN2Kr0kS7o+wAojwdgudBS19nNWeuYE8y7/J3J
 /cig==
X-Gm-Message-State: AOAM5325+epUR3W37fxtU/8ZfZeTR8Rp1j7JdolHVslOTgX70w7RRQ46
 06fdu8i4UsgwPQHLP5CjN1ZtHmOdITI=
X-Google-Smtp-Source: ABdhPJwTql5uKFd/srdQQoG38aaRxnbuF6PS3EHwIAVgiky4Itg3RMnrRk+AFOPWQpN2BRiBLUohcU6eXZw=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:4b07:b0:1d1:8a08:5096 with SMTP id
 lx7-20020a17090b4b0700b001d18a085096mr16807088pjb.91.1650351475734; Mon, 18
 Apr 2022 23:57:55 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:37 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-32-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 31/38] KVM: arm64: Trap disabled features of
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
 arch/arm64/kvm/sys_regs.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6a8ed59d8d90..0e3cff91f41d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -299,6 +299,15 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR2_GPA3_SHIFT) >= \
 	 ID_AA64ISAR2_GPA3_ARCHITECTED)
 
+/*
+ * Return true if ptrauth needs to be trapped.
+ * (i.e. if ptrauth is supported on the host but not exposed to the guest)
+ */
+static bool vcpu_need_trap_ptrauth(struct kvm_vcpu *vcpu)
+{
+	return (system_has_full_ptr_auth() && !vcpu_has_ptrauth(vcpu));
+}
+
 /*
  * Feature information to program configuration register to trap or disable
  * guest's using a feature when the feature is not exposed to the guest.
@@ -394,6 +403,11 @@ static void feature_lor_trap_activate(struct kvm_vcpu *vcpu)
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
@@ -462,6 +476,12 @@ static struct feature_config_ctrl ftr_ctrl_lor = {
 	.trap_activate = feature_lor_trap_activate,
 };
 
+/* For SYS_ID_AA64ISAR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_ptrauth = {
+	.ftr_need_trap = vcpu_need_trap_ptrauth,
+	.trap_activate = feature_ptrauth_trap_activate,
+};
+
 #define __FTR_BITS(ftr_sign, ftr_type, bit_pos, safe) {		\
 	.sign = ftr_sign,					\
 	.type = ftr_type,					\
@@ -4416,6 +4436,10 @@ static struct id_reg_desc id_aa64isar1_el1_desc = {
 		U_FTR_BITS(FTR_EXACT, ID_AA64ISAR1_APA_SHIFT, 0),
 		U_FTR_BITS(FTR_EXACT, ID_AA64ISAR1_API_SHIFT, 0),
 	},
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_ptrauth,
+		NULL,
+	},
 };
 
 static struct id_reg_desc id_aa64isar2_el1_desc = {
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

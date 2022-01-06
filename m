Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0DCC43217
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 04:29:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 977D740D2E;
	Wed,  5 Jan 2022 23:29:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JmyC7hq7B0u2; Wed,  5 Jan 2022 23:29:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A45C4A10F;
	Wed,  5 Jan 2022 23:29:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2DC34A4BE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:29:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xh3pZD1Ll8er for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 23:29:09 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7831B40FAC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:29:08 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 t1-20020a6564c1000000b002e7f31cf59fso865458pgv.14
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 20:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=iwXsEGXlRtnuTPyM/ryhBa4F3YbG0RREAYmK8S1ALak=;
 b=DY7bN9c02WCcBIqylRNzAa/UKrlEqTdIPajSGSeXyRQpP4wggxu1ISZyO1v/ZGCngz
 0+SHEjeqZI0uX9Pn9pJNUV/x2ZrbEsfDttbMPqFG8ERSn7RGb5ii2aWKxB3U8XO75UBv
 tvRqTOb4xqxIsB3EQYD9ljD0jWpW9K06TOuMoRa8oQDAF82bHN99MvgfdsXb0QfvWOYq
 OPi9gKx+MXSGxbTsuWmqPuzZs4raKY1OXhB+1KA0SIy2U5CtMqK0JDsdDRVzU+30vBl5
 /VAuQTw0SVFGp4LMQyKyeupT1SQyNAXo0IK0uLxm6N1mtzWuttt3UQlfmknM8c67y9p3
 Ts9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=iwXsEGXlRtnuTPyM/ryhBa4F3YbG0RREAYmK8S1ALak=;
 b=ylmycld+MTg+rGY2uw1YN0yvqXx6N4xVEvOqBC82J+2yt+hvt7aaZyT72JY2ml4Xn1
 8QCWF/3DApPnMWE6XSsEynF7q816cpBlk5DKkAfpeLBVdYRu4r+89zXf10UBrPn4fff0
 O2k+oy0aTzKpxh9Tn4zEGr4IHkOtFOUuwcslh2lOHyMPzpvpDEOnfg4lb22B4BvEGHak
 2zwwUCECThu9hO0Tk1XiRePwymV79tQQDxryW9ztI11FdgVFuGVslM/LTEp8W4s8WWrE
 QJssDNtgzvs9U44FRgjQ1l3ZQYie8HZoR3zHfCFT9v+yAkLwVp/UmccMIZndj1CQHsDg
 OzCg==
X-Gm-Message-State: AOAM533Wnv+o9zIxC0ZdGwZmzu6e5Cq9Iyy9xSisI7AmvcvwoernTEr7
 w1QmGOgAMr0u91bilTvyD0N6l5s9ulE=
X-Google-Smtp-Source: ABdhPJz9xkqu05Zv3mJ6ciKxZhfGOKGvAVLc21cuH1LPUGn8hbmqRWcz+0GsoulJ4ERK1227XDG5qggDLy8=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:2311:: with SMTP id
 mt17mr4608281pjb.203.1641443347686; Wed, 05 Jan 2022 20:29:07 -0800 (PST)
Date: Wed,  5 Jan 2022 20:27:06 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-25-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 24/26] KVM: arm64: Trap disabled features of
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
index f8a5ee927ecf..e6ef76f9b563 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -283,6 +283,30 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
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
+	val = __read_id_reg(vcpu, SYS_ID_AA64ISAR1_EL1);
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
@@ -370,6 +394,11 @@ static void feature_lor_trap_activate(struct kvm_vcpu *vcpu)
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
@@ -430,6 +459,12 @@ static struct feature_config_ctrl ftr_ctrl_lor = {
 	.trap_activate = feature_lor_trap_activate,
 };
 
+/* For SYS_ID_AA64ISAR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_ptrauth = {
+	.ftr_need_trap = vcpu_need_trap_ptrauth,
+	.trap_activate = feature_ptrauth_trap_activate,
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -932,6 +967,10 @@ static struct id_reg_info id_aa64isar1_el1_info = {
 	.init = init_id_aa64isar1_el1_info,
 	.validate = validate_id_aa64isar1_el1,
 	.vcpu_mask = vcpu_mask_id_aa64isar1_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_ptrauth,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_aa64mmfr0_el1_info = {
-- 
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

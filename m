Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4CCDC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 07:01:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EDA549EE1;
	Mon, 14 Feb 2022 02:01:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2EbxcfVkKhGT; Mon, 14 Feb 2022 02:01:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 251D049E22;
	Mon, 14 Feb 2022 02:01:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6018949EBA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:01:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vu-4qtPTk6vY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 02:01:48 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D7A0749EB3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:01:47 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 s10-20020a17090a948a00b001b96be201f6so6208415pjo.4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 23:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=l5XORbNWq/eRBF/KP+e0aDCNzGukLV10hjBR4KXniUs=;
 b=MJufiVJHKSyIus/sFhnoRwe2+keKwVB9kk5MzqrsJ7id6EZNMC30IKykXiNLgdTTsU
 VEMC26J4nsTGlzC1/XFzD+0AENUijjmcQSoMhoylRxg1CvenHLuPuZlRr7OLrHqWJzRa
 fvVE6sPk2yZWUhkJNd4jo5SZdek+ZjFGE8Lezs/exgfghLy7DZ1lKrblwCawnKK1oyoI
 RW3JtZZ9/0HQy9zbN4q1n5dcbiV0g1q9cKMrVesvzox6k0BUfqXyK/8U+zMu2pCEr/Bl
 pEQtrdCftz8Tl1R2z1vD79cXtgZk6KA2BcyV4qkFNaaOwqu97A8KasmUHI1X4QULMsbd
 7Jog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=l5XORbNWq/eRBF/KP+e0aDCNzGukLV10hjBR4KXniUs=;
 b=wPtOb41N3b11ddWwzgvVvo77TgOs+pA5hTMGLCxe5wErUsBO070Y+/FAT6Cj1avIHx
 +G8VTEryGaC7rYAyN1au4+x6NeZtMy6aNyc8iD9Gnk0qE1fcjxTLEH3OZH1vSCO0HQgH
 KtkZLbArqDaKsZ+eIqdN/wblQ72DbBaei4c0Csj9dtzwECGdyDnJ+sTt2C12B6zzkZn4
 eSXCBTw186v8LJoH6RY/iVtbwjTnCrrGFkWJMsMleRfuXotjhwHmVXuT2iv2ddrYwGCj
 iSOmhRWOMt8U9umYOMbnS2nT954GvFMcF3TMMxDDyIWLeOlGR4BtQReoGVy333hbLCuJ
 n4aA==
X-Gm-Message-State: AOAM5339DlMuVFsBfNupPrFcFwLoIg1nEI9mc9pW53lnSCXVsHo0KQuE
 UgVVGa/GZWDSAscxSDmGlQOJVgCU9Ts=
X-Google-Smtp-Source: ABdhPJwJkw68YJr5to3yBrgNhXZsf8uxRX0mR+fW+ct2ISB7LByn8kkySbfysY2JTpFORc7JKGvY52yitHY=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:4c8e:: with SMTP id
 my14mr1640945pjb.0.1644822106646; Sun, 13 Feb 2022 23:01:46 -0800 (PST)
Date: Sun, 13 Feb 2022 22:57:44 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-26-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 25/27] KVM: arm64: Trap disabled features of
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
index 205670a7d7c5..562f9b28767a 100644
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
@@ -378,6 +402,11 @@ static void feature_lor_trap_activate(struct kvm_vcpu *vcpu)
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
@@ -446,6 +475,12 @@ static struct feature_config_ctrl ftr_ctrl_lor = {
 	.trap_activate = feature_lor_trap_activate,
 };
 
+/* For SYS_ID_AA64ISAR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_ptrauth = {
+	.ftr_need_trap = vcpu_need_trap_ptrauth,
+	.trap_activate = feature_ptrauth_trap_activate,
+};
+
 struct id_reg_info {
 	/* Register ID */
 	u32	sys_reg;
@@ -986,6 +1021,10 @@ static struct id_reg_info id_aa64isar1_el1_info = {
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
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

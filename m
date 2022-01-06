Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2043C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 04:29:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B37C4AC78;
	Wed,  5 Jan 2022 23:29:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OcpiXGqHG0Nc; Wed,  5 Jan 2022 23:29:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5077149F4C;
	Wed,  5 Jan 2022 23:29:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9BAF4B0DD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:29:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1Rs7-p9FizfG for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 23:29:08 -0500 (EST)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5DF44A10E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:29:06 -0500 (EST)
Received: by mail-pf1-f202.google.com with SMTP id
 e10-20020a62ee0a000000b004bbfb89d2ffso945999pfi.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 20:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=b5C+ulXk8DtiFV4JWD7KK9B/636Yn3BYdNq9V7se8IQ=;
 b=PjwCpBHP/IlWcYBXpvIsuDywh36YeiZC/7CnqpU98fCKw1F5N2wvJRLtoHAP9QkS5C
 n5/eEfsy3Xv8rOxDpQY6S4WGbteBxe4aB36WpHnCQKWmg3S88vB1pOgk2k3ur57OwRAE
 P0jHYQrmrp5PVY775P9xRzw6t2r4MXLM0WrV5YWHbOC6Y/BLxqnwTdVQ0Qs18SH6r18G
 frBoODBE/xAJ0M6PMSR64DM+nyddamS3h03/mO/72kIxeL0cCF5h/qMHitTkz5H6Sddp
 KifN4e1+JOQ0O0sDfHdrhYHUOTJFMmvO3Z6vPUMnGHwARDDCwzll55HGvBS1KhtAu4y9
 18Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=b5C+ulXk8DtiFV4JWD7KK9B/636Yn3BYdNq9V7se8IQ=;
 b=jjTF7c65qnFg9bICtd+BtsuvanmzlnNwMolPCHQZWvCUWpi2Si+T20fU3yNDrBUOTQ
 it3K9inK5AanSalSjir9IpkFrctdIEwm3EwKGLp/zooqYc4V/uOedhCb4d+9zgGeJRw0
 AhVCxaQvIkTgeui5340LRlWUrhIUsN74hJTjt8ucmaBXXp/6xa6WfjKjTG5GiBeI0D4B
 uQO5bsUqM+5QaOBDoubR86mDqoRNQ5m/TRDhZ/l8GaTVpW42me1q0L1puIMXIrkUfLO5
 Ydy+bkZjaiJdwRQoSroRYv4IL1BqggGmwEOysi1lyNxqw3WCsmg4uuZLrcNk1HGjsvxK
 KS3A==
X-Gm-Message-State: AOAM533mvkuP8IDx0LL4JnqbQDVLX3ig6JFC8a+yJ/vVtwhMSDinJIP1
 5Pw0UegwOuYfuwh/4zVRXytog5Z2rUE=
X-Google-Smtp-Source: ABdhPJywQHVMdwWzXRNzQnbUj7l0gau6d2J6BL/vkouVUlOhhdSI1dpQp4sJkOWx/rCODBxotVyGj6bV4c4=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:ced2:b0:148:a3e6:b48d with SMTP id
 d18-20020a170902ced200b00148a3e6b48dmr56863089plg.103.1641443346010; Wed, 05
 Jan 2022 20:29:06 -0800 (PST)
Date: Wed,  5 Jan 2022 20:27:05 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-24-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 23/26] KVM: arm64: Trap disabled features of
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
 arch/arm64/kvm/sys_regs.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 229671ec3abd..f8a5ee927ecf 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -365,6 +365,11 @@ static void feature_tracefilt_trap_activate(struct kvm_vcpu *vcpu)
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
@@ -416,6 +421,15 @@ static struct feature_config_ctrl ftr_ctrl_tracefilt = {
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
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -947,6 +961,14 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
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
@@ -976,6 +998,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64MMFR0_EL1)] = &id_aa64mmfr0_el1_info,
+	[IDREG_IDX(SYS_ID_AA64MMFR1_EL1)] = &id_aa64mmfr1_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
@@ -1050,10 +1073,9 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
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
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

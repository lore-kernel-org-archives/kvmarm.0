Return-Path: <SRS0=1z46=PW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D56C4332F
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 176BA61181
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 176BA61181
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7B014B163;
	Wed,  3 Nov 2021 02:28:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oUY9ZhEPa9Lj; Wed,  3 Nov 2021 02:28:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4274A4B1BF;
	Wed,  3 Nov 2021 02:28:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B7AD4B17B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PDMe-JEVwWVQ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 02:28:33 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 96EE14B153
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:33 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 134-20020a62198c000000b0047bf0981003so848117pfz.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 23:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=W1vWCSi6sD57/ju+MVWHrUzS8zlg3LpW8mzLjXGDeDs=;
 b=rEWlkDyGEepBbZ57FgoY7ltu6LDMAMHAOOx0P/jG/yyYU9fE274fG1o7BMK5p8Jp2e
 fKv91hIezGvLwOizMBpz+AGj+d7MNMWHzgrQEysT3B7rt4Cp7Hu+m7xk6d2ehFoxHzVf
 8ZsFFC+z/yC6oU3DBJCC5pHkNs3qfHXH5hX1KYvrxNfMTfQb5XAKyb1fQNOyJnOzxS0E
 Ow9wk2a0+f4tCA215T3nAoEa4t5ki9eX3BzTu4su6xHI1ULMqLRc6leSTSVCTDmAW13x
 zJ7Aej7Nw9Y5mBEo2nNT/L3287ObrbtpP7EDuyzAm/WpYJnwmG2D4adVYA9LvZJp8Dne
 fUaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=W1vWCSi6sD57/ju+MVWHrUzS8zlg3LpW8mzLjXGDeDs=;
 b=zbFvacqfilPMyrdnxN8QzNIZHId/9DRJQuDoGctErbBlbAFankJJYPb9p87/CjuPnp
 h8F7E1cY3Bg7jgjIKJ3/YmZGbDA6QwkwtXYLszOMOvgtwQlHY0NFq4dYiXVLmnhEBCD5
 Qa+5kLWj7PhHsBe/DZnVsISc3vv6W2Ab+KG4gD5UqpnIB/dRjwCsqOJ2DBhH7LnQ1pOL
 PRk3YOkyvH7xeoSMrKL/c4oj9lJXmCXAkMq3o1h/OAKgNhry54lJZst8HIeNXIGZDSOQ
 HENi9tu/K9scZuSJIFHwfP453KiaLLRfmz44Cz+cATg0whlehgWPmiHYdvm0nrBTYjX4
 hX2A==
X-Gm-Message-State: AOAM532LSDcc1EuNifLibiui8GwJvmq7VZ/pklBvtNBwM4Ut6cRwUdR+
 P2rIxDl2R/vqY8YtUiQ/V8XtnvdwQtc=
X-Google-Smtp-Source: ABdhPJxpQrRh12VLHNp/Qx/9xMnEFQ2hpQUSo9QzZqIcUPAIyKeeunNcRbGPMB0s9Ps8/EYxlzsFOQYqYNw=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:6bc8:b0:13f:8a54:1188 with SMTP id
 m8-20020a1709026bc800b0013f8a541188mr35966678plt.49.1635920912830; Tue, 02
 Nov 2021 23:28:32 -0700 (PDT)
Date: Tue,  2 Nov 2021 23:25:15 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-24-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 23/28] KVM: arm64: Trap disabled features of
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
 arch/arm64/kvm/sys_regs.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 99cbfa865864..da6bc87d2d38 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -424,6 +424,17 @@ static struct feature_config_ctrl ftr_ctrl_amu = {
 	.cfg_val = CPTR_EL2_TAM,
 };
 
+/* For ID_AA64PFR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_mte = {
+	.ftr_reg = SYS_ID_AA64PFR1_EL1,
+	.ftr_shift = ID_AA64PFR1_MTE_SHIFT,
+	.ftr_min = ID_AA64PFR1_MTE_EL0,
+	.ftr_signed = FTR_UNSIGNED,
+	.cfg_reg = VCPU_HCR_EL2,
+	.cfg_mask = (HCR_TID5 | HCR_DCT | HCR_ATA),
+	.cfg_val = HCR_TID5,
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -880,6 +891,10 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
 	.init = init_id_aa64pfr1_el1_info,
 	.validate = validate_id_aa64pfr1_el1,
 	.get_reset_val = get_reset_id_aa64pfr1_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_mte,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_aa64isar0_el1_info = {
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3813EC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E182861875
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E182861875
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95A1C4B1C7;
	Wed, 17 Nov 2021 01:53:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iZFy1HTig5m3; Wed, 17 Nov 2021 01:53:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44C454B175;
	Wed, 17 Nov 2021 01:53:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36C544B175
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CocPA-HxyzW7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 01:53:49 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93A9C4B176
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:47 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 o4-20020a17090a3d4400b001a66f10df6cso797170pjf.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 22:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=QbNVmbb/Oy+N5CWYEueDFqMF+6Qv00nkT2lV81yBcus=;
 b=rnThbfam0MmqlS4xxWCfnkTZjTwIIjz7OGsfNg2Dc5FUjrEYsTcLphvdf3QszQ1P8e
 rleC6mNmjL8rGSgDuDk2mhzP8SGwMahAxy9nA+h7AOlzQWfbxzFRrjxv2FpezKRby+K9
 fGK+TV7K+cQLxRmufyI3KpJaQs4G8Al8wkjEc76UDtUE0wmLjgvVTLRRUw0vBbR23g47
 Gc+6lOK7z3VCYWjyggk8J16KtV+E0A+hk2pessVtreB8IHxMwVAMvH0e1Pg3/TZQwPqE
 0+E/K47JxwTWtWGAaiYt1301CwXUMp3SmYnLBzJSPbiOoIxu3b/hJroihzXhExZHOHf4
 Euog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=QbNVmbb/Oy+N5CWYEueDFqMF+6Qv00nkT2lV81yBcus=;
 b=qgDQdNa/KjAW9GRiL42lQa9+aKywbORqv+59hYQpgtKcfviXkmWNedlEDNqhvb9uQp
 rv/ud8u8okdozSOv0s6SjyeVIV8i73gZBAnECS/ZnDkuxSCYYhRwvY2HA2SurXTpkEt4
 7Veukb/beF/jqZv6Gcm7hQk1qf7wUBt8orAAnLgwIekTgUovn0qIzaPZWPuKKeg/rIx0
 lQRZY7vRjuf9DLJ3LT5tj2xr4XD2Ah9jUuxgBUQNKAj3tm3r6dl7DvJqDj5n26j1ts3+
 TrR1bkVsKF6S0+b9rUIhomdqzPm/3jW3ip2cZt7lmnh2X5qqNU2Q6i4Dc2LvBgFPGF1G
 5TPQ==
X-Gm-Message-State: AOAM530OeUyEQeZxg6Jq/fxIv1L08NgbNIVGgR1z1q3qdlKLL3oymurA
 RNBqN9PA7ch/CEODay+liPyP7SfzvPY=
X-Google-Smtp-Source: ABdhPJzFf9BbNWHGQuNu1097yoIpbbooIyAzQs9+tUoFo73zzIQ3EgtK+MTbaFiYTpdEg+tmDr0Qvl+1lsY=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr314268pjf.1.1637132026636; Tue, 16 Nov 2021 22:53:46 -0800 (PST)
Date: Tue, 16 Nov 2021 22:43:54 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-25-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 24/29] KVM: arm64: Trap disabled features of
 ID_AA64DFR0_EL1
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

Add feature_config_ctrl for PMUv3, PMS and TraceFilt, which are
indicated in ID_AA64DFR0_EL1, to program configuration registers
to trap guest's using those features when they are not exposed to
the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 73d992ba6e90..cb18d1fe0658 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -437,6 +437,38 @@ static struct feature_config_ctrl ftr_ctrl_mte = {
 	.cfg_val = HCR_TID5,
 };
 
+/* For ID_AA64DFR0_EL1 */
+static struct feature_config_ctrl ftr_ctrl_pmuv3 = {
+	.ftr_reg = SYS_ID_AA64DFR0_EL1,
+	.ftr_shift = ID_AA64DFR0_PMUVER_SHIFT,
+	.ftr_min = ID_AA64DFR0_PMUVER_8_0,
+	.ftr_signed = FTR_UNSIGNED,
+	.cfg_reg = VCPU_MDCR_EL2,
+	.cfg_mask = MDCR_EL2_TPM,
+	.cfg_val = MDCR_EL2_TPM,
+};
+
+static struct feature_config_ctrl ftr_ctrl_pms = {
+	.ftr_reg = SYS_ID_AA64DFR0_EL1,
+	.ftr_shift = ID_AA64DFR0_PMSVER_SHIFT,
+	.ftr_min = ID_AA64DFR0_PMSVER_8_2,
+	.ftr_signed = FTR_UNSIGNED,
+	.cfg_reg = VCPU_MDCR_EL2,
+	.cfg_mask = (MDCR_EL2_TPMS |
+			(MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT)),
+	.cfg_val = MDCR_EL2_TPMS,
+};
+
+static struct feature_config_ctrl ftr_ctrl_tracefilt = {
+	.ftr_reg = SYS_ID_AA64DFR0_EL1,
+	.ftr_shift = ID_AA64DFR0_TRACE_FILT_SHIFT,
+	.ftr_min = 1,
+	.ftr_signed = FTR_UNSIGNED,
+	.cfg_reg = VCPU_MDCR_EL2,
+	.cfg_mask = MDCR_EL2_TTRF,
+	.cfg_val = MDCR_EL2_TTRF,
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -952,6 +984,12 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
 	.init = init_id_aa64dfr0_el1_info,
 	.validate = validate_id_aa64dfr0_el1,
 	.get_reset_val = get_reset_id_aa64dfr0_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_pmuv3,
+		&ftr_ctrl_pms,
+		&ftr_ctrl_tracefilt,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_dfr0_el1_info = {
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

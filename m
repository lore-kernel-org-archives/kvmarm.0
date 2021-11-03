Return-Path: <SRS0=1z46=PW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7200BC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 201EA6115B
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 201EA6115B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C314E4B1E2;
	Wed,  3 Nov 2021 02:28:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0LHggVj9xDqw; Wed,  3 Nov 2021 02:28:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D0484B1BC;
	Wed,  3 Nov 2021 02:28:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C41684B1AA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EgQev1dwQRWB for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 02:28:38 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5F19E4B1E4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:35 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 v62-20020a627a41000000b00492638b8ebfso628652pfc.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 23:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Hg/kro78g0TD8dT23Op8aR6UZ26HEbXSuTGyujN0oMQ=;
 b=NWpHbvILfrGgHLj3IALBhGeMx0dFw9T/x+CEZkaF6/ls/KeWRL8OEjI6ueSJgrk37e
 0EpvU7aOphG/YeOsfMrsAYRbk2DKnJkafSm+ba7/IF8sUUVB9OYDIpxXyA2m1hfqcALt
 MixSxIfe2UxmJ5NzHW50IZw/4g8OTtvR7pZOCXmObmcVObu4WU9+i1x5qnqs9lT7aIiH
 /OzbT/sL03brKXDQKwxxGY5LwYJo5c+hdNqnBaEcX+Yx7DDHrMzKWBI0UyDR9KfCO4BK
 mTUDrQWhccBy/jRpf08B3lM6ELMcFMGtlikPwk2hv67YChVhUXhXqdzyW8ies0C424eX
 HWyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Hg/kro78g0TD8dT23Op8aR6UZ26HEbXSuTGyujN0oMQ=;
 b=mNln4Jj/PWmBXbvtCAYZYTHu10rx55cqVWb9tgJJpWMVDDddbPc7/9Ku7400Ru3W/y
 uWFLSiXWGKr5Js64wEMJM/eKX8L8PSG8JTLfjGPRRTRaEBQRRT84KydEW3e8NmM2NVUu
 AW9ag9PF9xMmd6au073OjF6aRdY/i+NPljCQ5JyhgmQDyYQeSXF8cMrHFzZ5BpNQ9FA/
 Fzj4fRVR1SbBnn+qKAQkQRS904yeniq909/9ZFu1sNxvVD5jyZ26tqHMiJjjxQDnlu/E
 L6ESpB9Bv54v0jKaATpV9tbmywEMoE4NCl3hZD3+D20kAD3WX2HwMUOcaoeDvp9R3eL2
 In5Q==
X-Gm-Message-State: AOAM531wEl+f3ra8Dng05mu6fWV3q350pYpTFXRglaMCxL6JgaF3Uv77
 7V126mFluusMRBDi6ydVlnnLJihIgQo=
X-Google-Smtp-Source: ABdhPJykbvGDPOO+pKErSwcFqQxn6Duu2EjZ6XP9dA7WAuHgFBYsENxD6RKzhtb+qlAkqPnymOleI2x7vXE=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:8b8b:b0:13d:e91c:a1b9 with SMTP id
 ay11-20020a1709028b8b00b0013de91ca1b9mr36970820plb.60.1635920914546; Tue, 02
 Nov 2021 23:28:34 -0700 (PDT)
Date: Tue,  2 Nov 2021 23:25:16 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-25-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 24/28] KVM: arm64: Trap disabled features of
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
index da6bc87d2d38..67f56ff08e41 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -435,6 +435,38 @@ static struct feature_config_ctrl ftr_ctrl_mte = {
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
@@ -928,6 +960,12 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
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
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

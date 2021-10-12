Return-Path: <SRS0=Zoam=PA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D8CC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 88F726108F
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 88F726108F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F0574B128;
	Tue, 12 Oct 2021 00:36:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4gEWBSmaadN3; Tue, 12 Oct 2021 00:36:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40A624031F;
	Tue, 12 Oct 2021 00:36:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 809BE4B152
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YxZi-l52aliQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Oct 2021 00:36:53 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 730884B15B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:52 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 ot13-20020a17090b3b4d00b001a04f094a68so890088pjb.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 21:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=X2MC5tS4urnyh50skPCY/9xIv7Rg4adWM6caa08DYXc=;
 b=inNCt9FpIq76B+VhKdpWkwhHuSBX1gL+4xixhQW+svRbgV2n+ibgsdFUCNmdtoMru2
 /it/NY6mdNUiEezsHyd52DTIcssGR44sV17vmvs3biSKEQaMcDmePmVdCsE7EOOmmICQ
 g3K5iFvnZOU1DXcSFi3420WslBqkRO1yBTilD2CQLSFmjVj/FnILkKaZBBVq8qOJOqwI
 w07qZGVrqOdO8jQH5FI+AHLzxUDDqdXxSOg6Ln7nkNxoSl1AUhvikgKBoaHiZKe2hZ0S
 cVlQJHpaMstreT9JmVbLDZ2PiW3p0ajTViN3Kr0rA8/MLsVEqSUGf+/i2fAnNshMHjyF
 hXmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=X2MC5tS4urnyh50skPCY/9xIv7Rg4adWM6caa08DYXc=;
 b=xdNTK7qfzTcPLVMWxSSyga3agE+z6kmsFFiQnJEPhcNz0F0etI4i4wBzs6FPDvl95s
 f9eDhj+/07/N6C2mlZ9BOPEb0JUMRenSsVdVATO6l+jkLOmHUN3brUsBWShoE+Iy5iVX
 65xreg04XnsOpY18XTP24TYetkViVfffkkUJSBk7MJ6ZzwDS6EMjmU4hGaHxyt8ewPBT
 qTw37it+RJPCE8ALKZYakBSovbqDhmKGa97/On9LbZ3cuZ3ZAkDSxHppDSxZ1t4FNiD1
 6L2ONWQ269qUWkgZkdTcHvWdlxAU79pZuKwqz3YsgSkVDJySCEr251fjLfWg1/7Uf2m4
 qH0Q==
X-Gm-Message-State: AOAM532PbuHgSpSp7KtkRkaBCXzOOPjKuGeBk4LJtDEjeOvKdNB0CqDS
 7tTI/6sClzwVvL/r6ORt1TNqCCAHhmg=
X-Google-Smtp-Source: ABdhPJyXRkRDYHX+V64uORGsvksZYYcAzeDYpRvgXni5jgbKqEJlLN+vJO2JfCbxPWmEGCNi7HHH8xh+o+g=
X-Received: from reiji-vws.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:aa7:81c7:0:b0:44c:517f:a759 with SMTP id
 c7-20020aa781c7000000b0044c517fa759mr29319641pfn.3.1634013411673; Mon, 11 Oct
 2021 21:36:51 -0700 (PDT)
Date: Mon, 11 Oct 2021 21:35:31 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-22-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 21/25] KVM: arm64: Trap disabled features of
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
index 595ab1c79bae..23a3bcac4986 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -342,6 +342,38 @@ static struct feature_config_ctrl ftr_ctrl_mte = {
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
@@ -727,6 +759,12 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
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
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

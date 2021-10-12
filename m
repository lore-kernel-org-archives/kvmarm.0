Return-Path: <SRS0=Zoam=PA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8591C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9FB8761056
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9FB8761056
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 541814B0F1;
	Tue, 12 Oct 2021 00:36:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vBEeCmChZs+e; Tue, 12 Oct 2021 00:36:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B49D4B12E;
	Tue, 12 Oct 2021 00:36:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F3824B0D0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TF66XNQq8pc4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Oct 2021 00:36:39 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D00814B0BF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:37 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 v70-20020a256149000000b005ba4d61ea0fso22041302ybb.22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 21:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=FDFGhMdlG5o/vMsnwPNFr7Rd2snS1UKSEvF8GgeeBk0=;
 b=bFgp4asOyTe5ohqjZrdTrsCRaXrQKZImQiXs0iv6ieHHCXWjcZ4+e/dCT7hgcdYpAY
 mJE0cltfIC6m0zQpTRr07A4H7BDFqur03nuvRSNTON1uQT+SwxsBf5+AbbbCmULIZWQZ
 KyifZ2mptugqxzta6k+xpDUxVoiM8/hCsH6nGtttUNM+3YUcCxIcTbmhKdG4/2uGy9lE
 TzJy4XfdtsrFDat2QKaUjSnomRyAfmnfZLG0nh/PY5Bco9jYqR1fjRE9lvNIKHzqsHpi
 ezKsGvVQK+Ae7dyB0wtV4rmnXsUYPFiGpFEZpDkaNlgen+ezu2eUbx86PQ4frv7cUAFx
 AZMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=FDFGhMdlG5o/vMsnwPNFr7Rd2snS1UKSEvF8GgeeBk0=;
 b=Sm7lbB4f3wYlMfi2URoORhNIdwf9MRhAYTsoJWotz0PcfmpxT9p60yqdiut2lrS5hy
 QwcUfqgZdH9p2u/PwKrYIeEG0nVdbYMEzuXbqVPPjkPbIN01w3C7gcT8rURf8yK4cn0h
 PxDlDX+YRcc0OfsbDwMla6cpFI7C6umdGMb1pAqS4WHlJwFJ5MelI2IAxMFrzS7w19LW
 AnS0fVKSmtxAQr0cGEYdL71pPDF2KZfXwUNqkIzkt7aFBtI/oytCDFu6bOWeLNL6Cj/T
 1LKV2au7niHbr35nYe2/kVv9v0aLNGiakT8km3ZMLRDYYR4VVenqMdart5ro8s5sBMIr
 dA+w==
X-Gm-Message-State: AOAM531kURRS12ndECFCtHBykGOE1cQ12sv+Kx1D3+wLvSF680nCSRyg
 Q6fcC4N/Zh+wshFDtbqjEKUPuxWHgxQ=
X-Google-Smtp-Source: ABdhPJy/Am31eNzPPFxM2MuSeuH8s6JV4pcMog7TA73zjPoDJL1Y4brQNrPfvNSY+xWqEWvRHGSmE/XmAVI=
X-Received: from reiji-vws.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a25:54c5:: with SMTP id
 i188mr26034197ybb.43.1634013397423; 
 Mon, 11 Oct 2021 21:36:37 -0700 (PDT)
Date: Mon, 11 Oct 2021 21:35:22 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-13-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 12/25] KVM: arm64: Make MVFR1_EL1 writable
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

This patch adds id_reg_info for MVFR1_EL1 to make it writable
by userspace.

There are only a few valid combinations of values that can be set
for FPHP and SIMDHP fields according to Arm ARM.  Return an error
when userspace tries to set those fields to values that don't match
any of the valid combinations.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 84c064dfc63a..71cfd62f9c85 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -461,6 +461,35 @@ static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu, u64 val)
 	return 0;
 }
 
+static int validate_mvfr1_el1(struct kvm_vcpu *vcpu, u64 val)
+{
+	unsigned int fphp, simdhp;
+	struct fphp_simdhp {
+		unsigned int fphp;
+		unsigned int simdhp;
+	};
+	/* Permitted fphp/simdhp value combinations according to Arm ARM */
+	struct fphp_simdhp valid_fphp_simdhp[3] = {{0, 0}, {2, 1}, {3, 2}};
+	int i;
+	bool is_valid_fphp_simdhp = false;
+
+	fphp = cpuid_feature_extract_unsigned_field(val, MVFR1_FPHP_SHIFT);
+	simdhp = cpuid_feature_extract_unsigned_field(val, MVFR1_SIMDHP_SHIFT);
+
+	for (i = 0; i < ARRAY_SIZE(valid_fphp_simdhp); i++) {
+		if (valid_fphp_simdhp[i].fphp == fphp &&
+		    valid_fphp_simdhp[i].simdhp == simdhp) {
+			is_valid_fphp_simdhp = true;
+			break;
+		}
+	}
+
+	if (!is_valid_fphp_simdhp)
+		return -EINVAL;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit;
@@ -637,6 +666,11 @@ static struct id_reg_info id_dfr0_el1_info = {
 	.get_reset_val = get_reset_id_dfr0_el1,
 };
 
+static struct id_reg_info mvfr1_el1_info = {
+	.sys_reg = SYS_MVFR1_EL1,
+	.validate = validate_mvfr1_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -647,6 +681,7 @@ static struct id_reg_info id_dfr0_el1_info = {
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
+	[IDREG_IDX(SYS_MVFR1_EL1)] = &mvfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

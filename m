Return-Path: <SRS0=Zoam=PA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D3CC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9825A610A3
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9825A610A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48F644B125;
	Tue, 12 Oct 2021 00:36:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8fU7AgBaBJU9; Tue, 12 Oct 2021 00:36:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22DBD4B135;
	Tue, 12 Oct 2021 00:36:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84BB94B13D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aEZOj4XHqTPX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Oct 2021 00:36:50 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A50EB4B0BF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:50 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 c65-20020a251c44000000b005ba81fe4944so15732084ybc.14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 21:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=coUrbvM5Lflty8spiztbsAsv+oJSc+F2TzdUPHTvF9k=;
 b=Ej/iKb8rhpuAFcFhtUeJxd6vSSdkQ2BxL4TjlXKczR/6dr5X6ci0KopMAWsHDKOqjv
 okJL8Sppbfs3inGm9cGEmEYOuaQpNVgtJFpM7j8m66AwkUwYxOU1sjQ443h6XFSBJmMK
 v5b7RbvmeJRv4kOx4BcVMQ3hiBWnsJ7CuryfbV04C0oCi80aONDVPBeImSrVKgXQCb0d
 FB9No1u+1RpUHV6C7uwVmJPr1oYspLsYn6DzWVKGUDNNQ2badK3vWNggpGelXEpMFnF+
 IH06c42XNyHc9Mbeg+uit5VZ7HA0CiQyecbm7ta0nasgP0t0rBUVAX5EePI+t7TMCE+t
 QqnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=coUrbvM5Lflty8spiztbsAsv+oJSc+F2TzdUPHTvF9k=;
 b=1pWiERL3GHbgR9R4EK4sM/G9y+qprfWWV6l94O3qLaDb+YbtJwOcZQmznBxXi0cObn
 XL/3fSwT73GLrQZGtXOTLEqXL+il3/JHy1WHDOqvTmaIHyD5m3dJwP5FGYc/YyULl5EL
 HaJ3pWFsow+4QFdMqtoPvqH0Em2cOqw+0a9uEQCrz/bIRJ8KhIypyQ/a26hikaQFzqDk
 UvyZNnR159fib6I53mh/EtTCkeuSGIUGweavh+3idgfucWKbF3qw/l5J0E4SuCh33knQ
 /md6WUYdP/YrFvT5xSYYGRRYvOD1DqhGvd6rdBapNMMWkd7s6hsLU7kxQcgk/Jvm3ZYL
 H25w==
X-Gm-Message-State: AOAM532MYTMvpPmPUYmzWMq2VLM7tvALjzQsZ3mVqEZHIeF02Ga/wWIt
 XM/+tjTURFAHMM73PhaK5ifzQErTm0I=
X-Google-Smtp-Source: ABdhPJwPvi/lmgC+gTZ21/Wz66CiGZojJBK5kwnJiiX4LQSzHxbRpLQV3my0CP726mGMYzFbz6D93vOC+Rk=
X-Received: from reiji-vws.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a25:1c45:: with SMTP id
 c66mr27703481ybc.133.1634013410276; 
 Mon, 11 Oct 2021 21:36:50 -0700 (PDT)
Date: Mon, 11 Oct 2021 21:35:30 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-21-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 20/25] KVM: arm64: Trap disabled features of
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
index 2b45db310151..595ab1c79bae 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -331,6 +331,17 @@ static struct feature_config_ctrl ftr_ctrl_amu = {
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
@@ -693,6 +704,10 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
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
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

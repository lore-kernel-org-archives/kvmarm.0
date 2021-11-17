Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD84CC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6F32461BD3
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6F32461BD3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 239DB4B1AD;
	Wed, 17 Nov 2021 01:53:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9BU5dfaRMo1l; Wed, 17 Nov 2021 01:53:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2382D4B1C8;
	Wed, 17 Nov 2021 01:53:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75B214B0D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b2c9-OwyOjAy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 01:53:47 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CCCD24B1A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:45 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 mn13-20020a17090b188d00b001a64f277c1eso2631978pjb.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 22:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=RcpZ70HWqU0SXh1JgWU046j8p1JVlfrsxLvOnh+ny5w=;
 b=LbXvb9O/MjigBpj3Q1x1la7lfju5hUWJ9TCDDM/Td5aHN+uf0MArRvDL6IXDAGsAYO
 1qkC7lXJQbWXm6LWhlCZdiuD7RJJBvl8caI2psMUC1eT7mAMEjHA2BHA8Canef5mwt+s
 AHPDTPURjEgHiRebfgGqDADsiynKYh/zcoZ8u2PAU+3i4Cyo9u7uBIvvkDK8+wV7KfOg
 AOjPWj7Iru5eyBljExW4+88J3f/eMpEMCsWsTXdRmMTBeSdj9C2rZkCK2INb3GMbqBjB
 UOJvRCAGgqj3yTfI0jOwqB/5K58OA7pNhcqCuiwr4meSLJsuXv1vC+HzzVW8cXmmJGgD
 +AQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=RcpZ70HWqU0SXh1JgWU046j8p1JVlfrsxLvOnh+ny5w=;
 b=Qae2YK38HNWu3Ede1L+NgxIwrYKNZbkQu52TPvJVw/n3Y4QBFax7JFv91wZQQeIXk3
 URNxZeRjsQyB30RsZdp6MuQDSt5jDWiaBXmsQ1ourHe105/alAyjR3v2l/VU8ooN5u8s
 5Cj9Dtw8E9oK5lPBPQ1W0n3CiBBzBG9tdKfo1k0AXTYR5QSa4PwZ5zlgq9FT6I7Z3HAk
 O3S+USAsVBIw9AvgnY03G4YTBwBMD1x7yi+9sFDYUV9UOYjspmbwrmebR3sw2nAIZB+z
 gq+CUu+V0eyleiLu+z39VkzhHM83v855uWcN/kj24WTDSyEMrAD2JlTGs6WNTiuShyqf
 a76A==
X-Gm-Message-State: AOAM530caU9d/xaMeVHfcx5MzDgD+xB0DlL1a2ibKvZbfR74cKS9nb6k
 0zZF63qLFzKCbehfXiw4c6sPAcUQ5Q0=
X-Google-Smtp-Source: ABdhPJw5QD14fDi96csV3HLcCihYEQmTicWAkaNNtkp4LgwsRxcvxf5w6HB4o8EsJXz+BBU2q7qWUTFRJGg=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr314255pjf.1.1637132024716; Tue, 16 Nov 2021 22:53:44 -0800 (PST)
Date: Tue, 16 Nov 2021 22:43:53 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-24-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 23/29] KVM: arm64: Trap disabled features of
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
index 42db8cf18fbb..73d992ba6e90 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -426,6 +426,17 @@ static struct feature_config_ctrl ftr_ctrl_amu = {
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
@@ -904,6 +915,10 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
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
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

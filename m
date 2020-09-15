Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76483C43461
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 10C7621D80
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="If96wXl6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10C7621D80
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B855A4B233;
	Tue, 15 Sep 2020 06:47:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ncl+9y5ft2FX; Tue, 15 Sep 2020 06:47:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A492B4B2D7;
	Tue, 15 Sep 2020 06:47:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F2C24B328
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:46:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rh2VpeHmOPu1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 06:46:58 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE7B44B36C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:46:57 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id a16so2405904qtj.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 03:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=M4t7/aE6p0+zSqWpJ/GkDS2dH4/bNt3D09RKrZvVsWE=;
 b=If96wXl6ODP+VW2e9WWYWL0Wz6sxW3Dxd3nIqXfEY9Be3sqIzMbsV8Ypf6p1aZ3193
 s8zNVmbu9xDUXm5fSlKcu5its1VWPw10ydcgjTxMoLs+w/2phj59zMk7yJXAaC4HMhVw
 SxsK9E8o+E0fO/SVkhRSrzDa5MFybmghlB75QcHQt2KtygcNq6NQPsK6iY6h79tBepKy
 Zzdgk/D9Z4i8XGxaf7ASIfUDNAJkJdYfksS6BE80wt1JUhYuPDu8OFsCfCRGkINpZfwY
 jX9VLCD83d+/kh6dhW5SM866WFwNkbgmb6eGxrUIABh7Irz1wKqYZ4nWf7HU1hMVyplS
 ZQVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=M4t7/aE6p0+zSqWpJ/GkDS2dH4/bNt3D09RKrZvVsWE=;
 b=GWGLfJmHWE+CAW12dV/22oYHPWPH8NVr5jDsJSxd5N4gPpVkL4EwDa7RS9/MtRNQKH
 7Zc+HvOnau4J7A1TZla5njbPW/CYHbPl+8kWcfGsXfNByE3/63jnV1aczve8ON5IGYDQ
 nzCGHRZ17zYuPziyw7vTPIjNHbeupPGgsP/nmykaQlL4sdFQI/TT1xHKTYtDssglDRkq
 IrbZ7BdXj1UtmTIJ5SvjkFpGweT82e0RnJau9v+yyOdq71U2ypCHysn2ZLmO8ciA2ZxK
 5ucZAAVrUm/uvQoS4UyJoJi0/2h5p751utUe/So9IuN3emOc6xiqQWXRxIpTTrgl77+k
 Jlbg==
X-Gm-Message-State: AOAM531r6mu5kzYZ2b6ND7GVcPZ0tl83wc2nyHsdbqejbJqAJkSHqmXV
 sX2pKXavopYUprATpPM0/vkGjNRN0V0E01ZMAHl2IUaPg03hrCbl04tU9qCn+fc74Hp3HzfK30/
 gtjkgmVDKZmSA2CrFYOW6tyEqjMweIqOeYuvvx9fgBiXPK+iXOxdC1LRan12j3qMNyAfoFw==
X-Google-Smtp-Source: ABdhPJzgtS4JfTokLsKtVQIUtfePIakOjzCus0ug3hsYcWKoTAhRuGa7cEgC6Cum/zOLTX0+1HMafuIipB0=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:ad4:458f:: with SMTP id
 x15mr1149968qvu.33.1600166817315; 
 Tue, 15 Sep 2020 03:46:57 -0700 (PDT)
Date: Tue, 15 Sep 2020 11:46:28 +0100
In-Reply-To: <20200915104643.2543892-1-ascull@google.com>
Message-Id: <20200915104643.2543892-5-ascull@google.com>
Mime-Version: 1.0
References: <20200915104643.2543892-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH v4 04/19] KVM: arm64: Choose hyp symbol based on context
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 maz@kernel.org, Sudeep Holla <sudeep.holla@arm.com>, catalin.marinas@arm.com,
 will@kernel.org
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

Make CHOOSE_HYP_SYM select the symbol of the active hypervisor for the
host, the nVHE symbol for nVHE and the VHE symbol for VHE. The nVHE and
VHE hypervisors see their own symbols without prefixes and trigger a
link error when trying to use a symbol of the other hypervisor.

Cc: David Brazdil <dbrazdil@google.com>
Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_asm.h | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 6f98fbd0ac81..a952859117b2 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -60,10 +60,24 @@
 	DECLARE_KVM_VHE_SYM(sym);		\
 	DECLARE_KVM_NVHE_SYM(sym)
 
+#if defined(__KVM_NVHE_HYPERVISOR__)
+
+#define CHOOSE_HYP_SYM(sym)	CHOOSE_NVHE_SYM(sym)
+#define CHOOSE_NVHE_SYM(sym)	sym
+/* The nVHE hypervisor shouldn't even try to access VHE symbols */
+extern void *__nvhe_undefined_symbol;
+#define CHOOSE_VHE_SYM(sym)	__nvhe_undefined_symbol
+
+#elif defined(__KVM_VHE_HYPERVISOR)
+
+#define CHOOSE_HYP_SYM(sym)	CHOOSE_VHE_SYM(sym)
 #define CHOOSE_VHE_SYM(sym)	sym
-#define CHOOSE_NVHE_SYM(sym)	kvm_nvhe_sym(sym)
+/* The VHE hypervisor shouldn't even try to access nVHE symbols */
+extern void *__vhe_undefined_symbol;
+#define CHOOSE_NVHE_SYM(sym)	__vhe_undefined_symbol
+
+#else
 
-#ifndef __KVM_NVHE_HYPERVISOR__
 /*
  * BIG FAT WARNINGS:
  *
@@ -77,10 +91,9 @@
  */
 #define CHOOSE_HYP_SYM(sym)	(is_kernel_in_hyp_mode() ? CHOOSE_VHE_SYM(sym) \
 					   : CHOOSE_NVHE_SYM(sym))
-#else
-/* The nVHE hypervisor shouldn't even try to access anything */
-extern void *__nvhe_undefined_symbol;
-#define CHOOSE_HYP_SYM(sym)	__nvhe_undefined_symbol
+#define CHOOSE_VHE_SYM(sym)	sym
+#define CHOOSE_NVHE_SYM(sym)	kvm_nvhe_sym(sym)
+
 #endif
 
 /* Translate a kernel address @ptr into its equivalent linear mapping */
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

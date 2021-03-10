Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E643CC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 88A2864FB2
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88A2864FB2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38A434B402;
	Wed, 10 Mar 2021 12:58:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jkk1UyDPK9ee; Wed, 10 Mar 2021 12:58:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2834E4B52B;
	Wed, 10 Mar 2021 12:58:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0702F4B616
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J3yh-+uXigCr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 12:58:15 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8711A4B3E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:14 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id s192so2975427wme.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=T621CrLzDVvHMT7g1JI2svAdR9qKxB9zRXJEq9CxOEU=;
 b=Hbvsvxu6NLISPbrvhiFxE7FXEqAU0Mv8t9SPVam60nUlEefn0BFRgckh6OphPN/n34
 mMAxbCfp63tyHccY0qa/f3Jpc86iiuTI1qKtqv9p3GgGY0jIRmo2YehbRMB+bwHX+rkd
 FciY30zEjHtG42uGSiQAnecMzyOeKipqkx91RsUlvsIu/qkCtj/fVmS6EDgNmYhAdE64
 CHNIzVWY6jaAli+IqjdG8DYNqiV3kcGDigjdAxVcu9mjVlx/FgYwRvHQ/HN8W8Ksp+tD
 UGCShyNHhI0MSaxMWGIBO2OuJLu9etYsd6zmBCTOBQlY6AXhHDojB8xnAR2EeHwTlARr
 WvoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=T621CrLzDVvHMT7g1JI2svAdR9qKxB9zRXJEq9CxOEU=;
 b=LSbbulHzpeStCQPauGSi4wp75PMYOjgtALFIdF86sZxhO3jUbASTwXNTbEL+htNg3/
 7vCqsix9TrqcHOhkM3VfEoKi4wceoQZ/fJ9rdtZKqZQMKjuhS2VXpm4RLnqEAeF3wVBx
 +uxNtXyc6tYDdd/RPPkIx2ExSaKcp5tlvjLm72pj/hmMCrIdj3GDqYxoQcamyCeByLhK
 rvFnbbP2GRiLX8VhC9QpbvggNP45qDtPnPqebiTIaXDFZAD4f+6t3u7OMmHXzAXZO2O8
 8DqYvybxclonq46AagS4OztxGlZyhGClb82f4tmPZkIqMqWACx+6KSgBL3Js9LgJ5/0V
 6RPA==
X-Gm-Message-State: AOAM530ctlX/GpwthHhB6U0NSwkV230C2Iqw/3lO1lEtj3RR7Q0D3t3V
 NIG6wnNd8RDWaYSJA26Mt1cUCJpxmoKr
X-Google-Smtp-Source: ABdhPJxqfINpp6EENtOEj1k9D5Kyx0lGUnntW+YAdT5CBabTaE0ejM3PwJv5r9lDZwF+U+rCzWRzTGC22KfH
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:ed13:: with SMTP id
 l19mr4406714wmh.83.1615399093776; Wed, 10 Mar 2021 09:58:13 -0800 (PST)
Date: Wed, 10 Mar 2021 17:57:26 +0000
In-Reply-To: <20210310175751.3320106-1-qperret@google.com>
Message-Id: <20210310175751.3320106-10-qperret@google.com>
Mime-Version: 1.0
References: <20210310175751.3320106-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 09/34] KVM: arm64: Allow using kvm_nvhe_sym() in hyp code
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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

In order to allow the usage of code shared by the host and the hyp in
static inline library functions, allow the usage of kvm_nvhe_sym() at
EL2 by defaulting to the raw symbol name.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/hyp_image.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/hyp_image.h b/arch/arm64/include/asm/hyp_image.h
index 78cd77990c9c..b4b3076a76fb 100644
--- a/arch/arm64/include/asm/hyp_image.h
+++ b/arch/arm64/include/asm/hyp_image.h
@@ -10,11 +10,15 @@
 #define __HYP_CONCAT(a, b)	a ## b
 #define HYP_CONCAT(a, b)	__HYP_CONCAT(a, b)
 
+#ifndef __KVM_NVHE_HYPERVISOR__
 /*
  * KVM nVHE code has its own symbol namespace prefixed with __kvm_nvhe_,
  * to separate it from the kernel proper.
  */
 #define kvm_nvhe_sym(sym)	__kvm_nvhe_##sym
+#else
+#define kvm_nvhe_sym(sym)	sym
+#endif
 
 #ifdef LINKER_SCRIPT
 
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

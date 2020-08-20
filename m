Return-Path: <SRS0=c5RA=B6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A2ADC433E5
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 084EB2078D
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="LrB0Zugw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 084EB2078D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B39B34B86C;
	Thu, 20 Aug 2020 06:35:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ioikxuwligGe; Thu, 20 Aug 2020 06:35:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B25B64B898;
	Thu, 20 Aug 2020 06:35:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 632DC4B852
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id No4w+2HKXHZj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Aug 2020 06:35:30 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 029464B364
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:30 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id 5so502284wrc.17
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 03:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=zg5ZCTDpTnAIwbW0OhMsxSkivd5OxG/LbJPtzF+miBk=;
 b=LrB0ZugwdF5h7TPZl8CkNKrCjsf5pd/akzCsAoBT1qEZ+nbPTSoavGcomf8W94MslZ
 gXsgWbVtP9jbbHWIlMMkyiIbT80M/DI6ZmrLyBhVupLPbtbCjVqyfxMEmxw7yDUsCNv1
 YTJFz0qfRC/G/+79GMx2+s/RkqEcgMBJRmKAHG1XMnA9mKDKSkYTYYx3re3gy2b0BkqQ
 F3lz4P6n2UG7DdJ8OWmYWpIx52GCiIslvFqrF2GdkNhTvm76pP4veH+FKMSIlPVc9saQ
 VhFsP3Is2XsjzIqBur0yYpea66HrQ/6nOP5398M+7BXx0Pf8F1s6iL4fsrxKdWNYGK6O
 3Zeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=zg5ZCTDpTnAIwbW0OhMsxSkivd5OxG/LbJPtzF+miBk=;
 b=Wf/t+wT9Ghglv8Wjtscf5Y0qpYe5s1cfU5YQGs8x/S3L0t/rjno964AjeN1wkBFeZm
 NBDNZRNUo4TRd5OKCqzR9hlDilBAFBZJBrU8m+ivDWCPZ8ypgIHsH5ti3IVq2HBiScLJ
 inGjmioe7oDc4+tFGCqLVTuAmZVukV7tZc/28aqP4rsIe/MCoEM+Jg8WpBHHbx0eRdUq
 jwcFIeHHGOO+kMyonoYkAt8U4HCfZ1Bp08Xs7eVnQJjgG507XNJJomxXXnv/D9RJKnX/
 OKy8phQ0Uhpp6I70+1GWNF2hzPHqiCgz1EAjHd5LGdtnMF57yxXBw6XxPCJ3TP0yx+uX
 DXTg==
X-Gm-Message-State: AOAM53177YpxZLL1FHGG2BChtQC3p5IooMkeTJOHo/JNNEvl+tzehr37
 qtU8Z4LV/g/M0LCgRS/H056c7V7LBwnTqtAjKoNfklpaADDgy+jQA2fFJwc89TMYA2Cxs+ZCcnY
 2Rg0GMbFcy5+wLc4JA+b0Lhk1Ifw998bw+xJaZV2rcF/tnovs4rX6Aukfmm/QRdLBdYJ8EQ==
X-Google-Smtp-Source: ABdhPJzfOA5qp7a1O1IL7iOCrtlzm8NkS7Hs81tc02Xjy1IkmUObXohL2sbMg098SNSOjlVsrOnzi/sjaDU=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a1c:66c5:: with SMTP id
 a188mr2782833wmc.173.1597919729137; 
 Thu, 20 Aug 2020 03:35:29 -0700 (PDT)
Date: Thu, 20 Aug 2020 11:34:30 +0100
In-Reply-To: <20200820103446.959000-1-ascull@google.com>
Message-Id: <20200820103446.959000-5-ascull@google.com>
Mime-Version: 1.0
References: <20200820103446.959000-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v2 04/20] KVM: arm64: Restrict symbol aliasing to outside nVHE
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

nVHE symbols are prefixed but this is sometimes hidden from the host by
aliasing the non-prefixed symbol to the prefixed version with a macro.
This runs into problems if nVHE tries to use the symbol as it becomes
doubly prefixed. Avoid this by omitting the aliasing macro for nVHE.

Cc: David Brazdil <dbrazdil@google.com>
Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_asm.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index fb1a922b31ba..413911d6446a 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -99,8 +99,11 @@ struct kvm_s2_mmu;
 
 DECLARE_KVM_NVHE_SYM(__kvm_hyp_init);
 DECLARE_KVM_HYP_SYM(__kvm_hyp_vector);
+
+#ifndef __KVM_NVHE_HYPERVISOR__
 #define __kvm_hyp_init		CHOOSE_NVHE_SYM(__kvm_hyp_init)
 #define __kvm_hyp_vector	CHOOSE_HYP_SYM(__kvm_hyp_vector)
+#endif
 
 #ifdef CONFIG_KVM_INDIRECT_VECTORS
 extern atomic_t arm64_el2_vector_last_slot;
-- 
2.28.0.220.ged08abb693-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

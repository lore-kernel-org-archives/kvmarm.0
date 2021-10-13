Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FEBC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:59:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9D262611B0
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:59:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9D262611B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53BD34B13E;
	Wed, 13 Oct 2021 11:59:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xAKFwIKJuZPO; Wed, 13 Oct 2021 11:59:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C7324B160;
	Wed, 13 Oct 2021 11:59:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A40B54B12F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:59:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JmH+W585zZCV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 11:59:02 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A196B4B0D9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:59:02 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 l8-20020a5d6d88000000b001611b5de796so2357682wrs.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=jY5Bguf6FHbyrvp9n+fOCeNfdUoUza19VDS/XHTNadE=;
 b=a2bOxgesO4qShM9iZUtwxpNLNxvAtISKgoXG58VYG79ZxfXEvlG4txY+QkZoEO33fr
 k8oSCXYH8GFser7sVBGps8Vjd1hFlXGn5Ts0CCcl2YJqxk3xdJFxAIsh+rBQxP2SkpQQ
 q347qvkPHogVXKP8Z/gA0OMQ6RXw4b7Pj69mipXSocgiJn7uu/wVPB7Ljf7jnX5yMZdN
 5FKtQ19TMmETiAtK1UX8oROSHR0BqOCK12jCUhWEAqJJ9V5EaIC1BevZLvOQtIxRv/we
 3alhXG4rLviir9mjCOgr2Z2d38wDI2PSOWjG2Wb6omWVPHFuxiTwi3WQoexeHeTBEv+V
 rfPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=jY5Bguf6FHbyrvp9n+fOCeNfdUoUza19VDS/XHTNadE=;
 b=4Ea/IKlb9eyBeIB3xlF/mwrLDkEiRYsD89a7Au7jSPSxeencvK5Zgzev/hRpTIu9FU
 7fuFbGbABMsFDCz4e7L25jVhWBL9boApzdSA4ouBng9MzA/7ufTDPyCKtHXI8PTAp87F
 dpMmdvi2pGqsm5/DvEdJ+izQHeQP4t/WOaOaTRhE/rXrEIexRSsxrZcC+lgh1SpA2olN
 KXsG90XKGfMm3U4QwuwImHfbplQvfmS47oQ+iGm6Wvh3aBwhl3ljCd4/xc491I4qR1ey
 VCxz/Fh5SQ2A7ODZ/e9NyA4XephrNiM8Ojiy1ku4CksNxjjFDUGb00FKcQunlSDI9xNp
 DT9Q==
X-Gm-Message-State: AOAM532Dp1BIx/1VEmULH+cNK2hjg5p9gJEJ5vwscO71oCmi6OdBPJBm
 64OCfGpnLgRJ9afvHVJ7XTvLxjutKIXU
X-Google-Smtp-Source: ABdhPJxV4HY2vWNYpk4jg87UJ31CTmQTVWpbTKB1UxegDt8PV1t1yvNzHY7X12YOZjtv1MWET7xESBbrbphK
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:65b5:73d3:1558:b9ae])
 (user=qperret job=sendgmr) by 2002:adf:a31d:: with SMTP id
 c29mr40005842wrb.381.1634140741873; Wed, 13 Oct 2021 08:59:01 -0700 (PDT)
Date: Wed, 13 Oct 2021 16:58:27 +0100
In-Reply-To: <20211013155831.943476-1-qperret@google.com>
Message-Id: <20211013155831.943476-13-qperret@google.com>
Mime-Version: 1.0
References: <20211013155831.943476-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 12/16] KVM: arm64: Move hyp refcount helpers to header files
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, David Brazdil <dbrazdil@google.com>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

We will soon need to touch the hyp_page refcount from outside
page_alloc.c in nVHE protected mode, so move the relevant helpers into a
header file.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/memory.h | 18 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/page_alloc.c     | 18 ------------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index 592b7edb3edb..e77783be0f3f 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -12,6 +12,24 @@ struct hyp_page {
 	unsigned short order;
 };
 
+static inline void hyp_page_ref_inc(struct hyp_page *p)
+{
+	BUG_ON(p->refcount == USHRT_MAX);
+	p->refcount++;
+}
+
+static inline int hyp_page_ref_dec_and_test(struct hyp_page *p)
+{
+	p->refcount--;
+	return (p->refcount == 0);
+}
+
+static inline void hyp_set_page_refcounted(struct hyp_page *p)
+{
+	BUG_ON(p->refcount);
+	p->refcount = 1;
+}
+
 extern u64 __hyp_vmemmap;
 #define hyp_vmemmap ((struct hyp_page *)__hyp_vmemmap)
 
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index 38accc2e23e3..0d977169ed08 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -144,24 +144,6 @@ static struct hyp_page *__hyp_extract_page(struct hyp_pool *pool,
 	return p;
 }
 
-static inline void hyp_page_ref_inc(struct hyp_page *p)
-{
-	BUG_ON(p->refcount == USHRT_MAX);
-	p->refcount++;
-}
-
-static inline int hyp_page_ref_dec_and_test(struct hyp_page *p)
-{
-	p->refcount--;
-	return (p->refcount == 0);
-}
-
-static inline void hyp_set_page_refcounted(struct hyp_page *p)
-{
-	BUG_ON(p->refcount);
-	p->refcount = 1;
-}
-
 static void __hyp_put_page(struct hyp_pool *pool, struct hyp_page *p)
 {
 	if (hyp_page_ref_dec_and_test(p))
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

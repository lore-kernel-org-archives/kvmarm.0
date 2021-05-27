Return-Path: <SRS0=LQ+R=KW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E66C4708B
	for <kvmarm@archiver.kernel.org>; Thu, 27 May 2021 12:51:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A604C610A8
	for <kvmarm@archiver.kernel.org>; Thu, 27 May 2021 12:51:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A604C610A8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5858E4079D;
	Thu, 27 May 2021 08:51:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EM8-d9vn0Dj4; Thu, 27 May 2021 08:51:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E8B24A588;
	Thu, 27 May 2021 08:51:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1213E4079D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 08:51:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ovjuu4Jvt13c for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 May 2021 08:51:55 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3DB844A4E1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 08:51:53 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 l185-20020a1c25c20000b029014b0624775eso1455044wml.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 05:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Byq3teaLV2n+YzpfRy9Lkrwtyz9tACaM8wDIjUMnhpc=;
 b=lh3itUSKrY99HR4eVX5Kbop9zhHjelSV5Tk0fWZiJ9sUfR4ERy+T5lGBjCz/duYdnl
 kGkbRalNQtA2P8Y0x9AuQts+PtFMMV4Twn9z5LBtYsCtzuOsQwApQ9msA6YyUSd0L9kr
 9uo4im5pV2Vfxkb39c1oXswe8RHMs28B40q7MqOi3d5tWR8vdUH1kSgUwquRqY9ZHNYh
 DPiymqTjegRTcs/yRjGTDtnhWm70YHVyMrJdLewGX2zGwBjl7lV8+fHtPLOB5VBtFc23
 shccUlzY2zH/UCB6UeC1Jr/WQJf3uNRFlQ+E8cRqzchohQRyWGeILnf9albgfmXsYbY4
 29Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Byq3teaLV2n+YzpfRy9Lkrwtyz9tACaM8wDIjUMnhpc=;
 b=ISm7xIyszDVwOBVJ+/GuvQHX7teB70UKB8pUE6nCSqmoeUCAgL7UtE1vnpkqCwSJ8O
 8zSfZR0eHDN9Rm8Cwl06gfN07qEQv5CrzIqXvZuQ32ta5szseoffLh4aTaPcyPWK6i9W
 /+Rfr+P0M2i7VF6z7MODFz1dIGBIx75lRwUm9NYnv1gRUsDjPr4WHF5SS/ecntTw0xUI
 L3kO7hHYaGvbqY0tSn3qgMkI02RPNQjz/fb0sbN2AsNdK7Ag43eq4+uOL4SZQhjZrEVk
 02/bv1ib/8Gtd5MuHpWECaCnO/1YMmPv4tkchzfl5G8bGCpaxujMcoDHq44m0FZzlFC/
 4RIA==
X-Gm-Message-State: AOAM532CS5K8xYGeu4UEZ2qejCdZH0gScKjRQ/xGUe/0huomF0yvL+Ad
 mY6zOBiKbOgLayeccmpbSxzmt4uQoz10
X-Google-Smtp-Source: ABdhPJx/lfTo0VRFwUG+jBpYqhQ9SqHdKxuCeQn/auIpBlo6JTHBRUm8dOoTIg4a0j6u0pDOtb1DO+Pb2vgH
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:600c:3515:: with SMTP id
 h21mr8321374wmq.148.1622119912227; Thu, 27 May 2021 05:51:52 -0700 (PDT)
Date: Thu, 27 May 2021 12:51:34 +0000
In-Reply-To: <20210527125134.2116404-1-qperret@google.com>
Message-Id: <20210527125134.2116404-8-qperret@google.com>
Mime-Version: 1.0
References: <20210527125134.2116404-1-qperret@google.com>
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH 7/7] KVM: arm64: Use less bits for hyp_page refcount
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, will@kernel.org, james.morse@arm.com, 
 alexandru.elisei@arm.com, catalin.marinas@arm.com, suzuki.poulose@arm.com
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

The hyp_page refcount is currently encoded on 4 bytes even though we
never need to count that many objects in a page. Make it 2 bytes to save
some space in the vmemmap.

As overflows are more likely to happen as well, make sure to catch those
with a BUG in the increment function.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/gfp.h    | 2 ++
 arch/arm64/kvm/hyp/include/nvhe/memory.h | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
index d420e5c0845f..a82f73faf41e 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
@@ -24,6 +24,8 @@ struct hyp_pool {
 
 static inline void hyp_page_ref_inc(struct hyp_page *p)
 {
+	if (p->refcount == USHRT_MAX)
+		BUG();
 	p->refcount++;
 }
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index 3fe34fa30ea4..592b7edb3edb 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -8,7 +8,7 @@
 #include <linux/types.h>
 
 struct hyp_page {
-	unsigned int refcount;
+	unsigned short refcount;
 	unsigned short order;
 };
 
-- 
2.31.1.818.g46aad6cb9e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD77CC433FE
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 09:03:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 464EF613D5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 09:03:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 464EF613D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF4034B297;
	Tue,  5 Oct 2021 05:03:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fGUaHJaM8yNm; Tue,  5 Oct 2021 05:03:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F27A64B2AF;
	Tue,  5 Oct 2021 05:03:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85AFA4B297
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 05:03:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wg++lTPZM8IM for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 05:03:22 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5EE104B284
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 05:03:22 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 k5-20020a7bc3050000b02901e081f69d80so8865237wmj.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 02:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=IJ5d9LFfxfsfjOyzMb9wAWVGNaAsBq4D1S2tLUmROQw=;
 b=k+C6KttgJIhWI0N6my6Gmd+ifempL0NxliApNM7bNFc4Zypp/266/edmPpEdSuDO6k
 BE90f8QW/H93+LTSCmLBuGx6sAqz7pvyDbd+uGNlrq2s33VlMhGlGZHNhEJGQskmS7Sq
 H3A4s6gUk4VgPHHkYEMLWraNS5mgRAPw+PZ4EBgI3WL0zgszOi1M00F1dadnofYdFWon
 FgyIwwZ5d7m1fgmZMM8TOnwJdR2xercMi9sTasNLWYOOCQ9DIzXjssEiSBg7PlQOcvX5
 L2sCgUPBIptqZ2kWHkne6YuTtKba/WcDG0cGnwu/hL7rHcLbGW7NnTteqVrtdarf8XNk
 zYmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=IJ5d9LFfxfsfjOyzMb9wAWVGNaAsBq4D1S2tLUmROQw=;
 b=qYQ3rWR0No9njcxMJXbg4d8Pyyup0E4kdUB+3yO6uSbR9X+jJE6YnNjYxxbTLsW+Uk
 jPEmtQ7Hy/UKd+thPa73eUjNc3c/iaAvWc71llcLN9xYrvdqdJuFl+PoAwv0jCc3JjP/
 NOZGBtr6x965vkXe2fbOkq3b+41rmlO2Kq78U6QE5F6Q+p1qTsxgQf5pS+o3Cv2nmoqF
 y6CPBNtE4ZpBBCs8Z+y6lIDK6zzSC7XaJh+f6Mwfjj84L0j7pk2h/IJLA1sVqpvgvxZ4
 cJYzp1Pwc81gkctJY6qEf4XNtFjbz0kEu7qyu7a+jx0QxvHqq9FumNcEpbWtQwJBn5Rw
 OsJw==
X-Gm-Message-State: AOAM531F2MyFQFS7nVk4wSWulZac7BHbtjgVoGw9WOrGEPXSnmY/DohP
 SIH13wzJ73+wWiTwKtHUhJOKejkh3BAj
X-Google-Smtp-Source: ABdhPJyWTqPJLcSZAfXhuyYllToltNQE4ex6rZPSYifRYSyemm303hl/IP70LZOn0VKNHsWefxffl1TuuHTX
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:5700:9128:3106:b389])
 (user=qperret job=sendgmr) by 2002:a05:600c:3b26:: with SMTP id
 m38mr484791wms.0.1633424600779; Tue, 05 Oct 2021 02:03:20 -0700 (PDT)
Date: Tue,  5 Oct 2021 10:01:42 +0100
In-Reply-To: <20211005090155.734578-1-qperret@google.com>
Message-Id: <20211005090155.734578-6-qperret@google.com>
Mime-Version: 1.0
References: <20211005090155.734578-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v2 2/2] KVM: arm64: Report corrupted refcount at EL2
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>, 
 David Brazdil <dbrazdil@google.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Cc: kernel-team@android.com
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

Some of the refcount manipulation helpers used at EL2 are instrumented
to catch a corrupted state, but not all of them are treated equally. Let's
make things more consistent by instrumenting hyp_page_ref_dec_and_test()
as well.

Acked-by: Will Deacon <will@kernel.org>
Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/page_alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index a6e874e61a40..0bd7701ad1df 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -152,6 +152,7 @@ static inline void hyp_page_ref_inc(struct hyp_page *p)
 
 static inline int hyp_page_ref_dec_and_test(struct hyp_page *p)
 {
+	BUG_ON(!p->refcount);
 	p->refcount--;
 	return (p->refcount == 0);
 }
-- 
2.33.0.800.g4c38ced690-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

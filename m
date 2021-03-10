Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D5CC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 021ED64FB9
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 021ED64FB9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8CB34B60D;
	Wed, 10 Mar 2021 12:58:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rVcm--qHepPC; Wed, 10 Mar 2021 12:58:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A6844B617;
	Wed, 10 Mar 2021 12:58:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6A8B4B643
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cANQPhoGh7Gz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 12:58:05 -0500 (EST)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9CDF94B3E8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:05 -0500 (EST)
Received: by mail-qv1-f74.google.com with SMTP id h10so13261018qvf.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=lIPthT51J+nIs48nl/QvpI3Ln3AY2S6u6ppS3XkUMwM=;
 b=fHBfJM8xzLAclGXEjFaYJ5Rhln578wLzMWoSnqk9psHRaDBuLXBcARc1NhvK6zE3B1
 cI2osMD4eClmpEaY1HG2sFX5g274O4sHptREG3EHY7jDQs+EYJD+eX0AZ/hpzN3YLGmp
 Y8QjFoJ1rGBijnkcrGc5QF/tGIGHoU258V1+/DMXbn9XDFr8KvWBiqDs4JlKA1EZ5Teb
 9WPr3djabjTTnmuikYjQMgMjSzAxUvjpbqNOPWa0DZKjuxX5BUxiVqEBXB2KVvBeDAsg
 ffEpVSe+BFI6nvd6tRs+1g4UntXEnAu0/1UiOLszmNy6hb6AU8I4J4elFWEdhdROrc2Y
 3yTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=lIPthT51J+nIs48nl/QvpI3Ln3AY2S6u6ppS3XkUMwM=;
 b=Houmi5mBbIb+IfVAGiljcpGJhUwbNpeik/P5EP4Az7JqdDDdI/KhZI202SCnVEhV8U
 PDoS3WXYAaMadTKsiGsXKzkW+qLZTkx9eeYVuUPFgioBF3SDG0Miks4Bald8A0vlfNKU
 ev+JXupB7zOH6w41S0Y27pSRXTD5obuP0vcMUGKxakAyfL1IxyU2mfOj85XwG0sbT9N4
 bX7QAYDGe3SAwp7K6hNA+JM9MzIEdneLUfSg0hp4p24MtsclNCSLwU8PT5ukEYUd2+Rq
 SbqOF3rowdz1qsGkxLfnJaEUjbSWnedodS/NAC6wU55ZF1S39/MurUr+ZeQPZDfZsH3R
 ZC1g==
X-Gm-Message-State: AOAM533qXpLEKnArxqGppcXrxqzF/5lY1hv4u6d35Ja3fUaFYLFGUhWG
 pcOQEUGDnZMxDW5UcK+z1587UnvqeoL+
X-Google-Smtp-Source: ABdhPJz0tdSYBeivnJPeagi2ze/9rhhZHyfPUL0XortI6Q0zqZ15QP96f7jyHF9BhRekOYOtkNSCxsIk+TrK
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:c60b:: with SMTP id
 v11mr4064868qvi.44.1615399085165; Wed, 10 Mar 2021 09:58:05 -0800 (PST)
Date: Wed, 10 Mar 2021 17:57:22 +0000
In-Reply-To: <20210310175751.3320106-1-qperret@google.com>
Message-Id: <20210310175751.3320106-6-qperret@google.com>
Mime-Version: 1.0
References: <20210310175751.3320106-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 05/34] KVM: arm64: Avoid free_page() in page-table allocator
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

Currently, the KVM page-table allocator uses a mix of put_page() and
free_page() calls depending on the context even though page-allocation
is always achieved using variants of __get_free_page().

Make the code consistent by using put_page() throughout, and reduce the
memory management API surface used by the page-table code. This will
ease factoring out page-allocation from pgtable.c, which is a
pre-requisite to creating page-tables at EL2.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 4d177ce1d536..81fe032f34d1 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -413,7 +413,7 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits)
 static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			   enum kvm_pgtable_walk_flags flag, void * const arg)
 {
-	free_page((unsigned long)kvm_pte_follow(*ptep));
+	put_page(virt_to_page(kvm_pte_follow(*ptep)));
 	return 0;
 }
 
@@ -425,7 +425,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 	};
 
 	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
-	free_page((unsigned long)pgt->pgd);
+	put_page(virt_to_page(pgt->pgd));
 	pgt->pgd = NULL;
 }
 
@@ -577,7 +577,7 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
 	if (!data->anchor)
 		return 0;
 
-	free_page((unsigned long)kvm_pte_follow(*ptep));
+	put_page(virt_to_page(kvm_pte_follow(*ptep)));
 	put_page(virt_to_page(ptep));
 
 	if (data->anchor == ptep) {
@@ -700,7 +700,7 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	}
 
 	if (childp)
-		free_page((unsigned long)childp);
+		put_page(virt_to_page(childp));
 
 	return 0;
 }
@@ -897,7 +897,7 @@ static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	put_page(virt_to_page(ptep));
 
 	if (kvm_pte_table(pte, level))
-		free_page((unsigned long)kvm_pte_follow(pte));
+		put_page(virt_to_page(kvm_pte_follow(pte)));
 
 	return 0;
 }
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21CFC07E9D
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:48:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7671A61026
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:48:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7671A61026
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C0DF4B09E;
	Mon, 19 Jul 2021 06:48:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0cP0XP6ySYMr; Mon, 19 Jul 2021 06:48:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EA674B0BC;
	Mon, 19 Jul 2021 06:48:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D297E40808
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:48:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t5d-PPuv-4M5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 06:48:06 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5E214A193
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:48:06 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 l4-20020a0ce8440000b02902d89f797d08so14786767qvo.17
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 03:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=+nFhosBzSZV7qNAcnaziksYJNq5Oy+qXrjjFGFJtf38=;
 b=NVj8E5o746nTD4LMKyEjLfcN0+iNKd4Q3+ARDYWcQq2Bc1tygxtGoghORVPHuz55fr
 6XRVVKrCybVPnQoQ1dqIiRNFFsZO8Z9BJgYIHQDMxMPYPfrqI4GGFGxB1LTirahtqKgF
 xAKvcu5plneJQWJFaJ2c5xabR1g5t5l+kwW/aZ2D/8oPbSsqYoKBcR7AgbnOKB7FMw3S
 X7XC0MCHbF0+T/+/kcIrOaIFYgnutjaITulomfUfEJjKZS9PqaUiCF++55pWMzZV9q2E
 BJsPLP9JbGxG1U4PRz6OPrAsYUQlxu7PGOUlltDvQ/zsstSFZALQC40mm9bEPB4ctH8U
 aEWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=+nFhosBzSZV7qNAcnaziksYJNq5Oy+qXrjjFGFJtf38=;
 b=sz5oZwCzPIgJBmcjkiieN4E3yXqO1ujsCaS1BEGJaWufeZA9rxolAuGauzFJ+Q51nY
 6YaKUgsXYrUzOBcfJ+5NQU2SID9rAMAzpyHDgKk7zGKrdK68yUd0Sc2kxiIT2esblVa+
 WmJmRU+Kygph9W4KRWrR6Ct9afB5nsaG9gSQ9A3/GlTpoZ0JVgJ/m3UuQ8QzOtraOHZZ
 tOt3VlFK65WQgsyP/uD7H9GIIZQNLgA9svr7AVvQegVMBtKUJMtqJ691ixanCecN2az2
 U+7DzpT1cSriPyUNe7nTXu3C1ZtQf8OoMPTJ5v+Y/tCki4/nTB+nH1LO9NNjLvfyaOcb
 bq0g==
X-Gm-Message-State: AOAM533H/Ye4ZBv6l07sEfbW5JoGlIVfwy6qE/iruR0bLeWGVhLZjk0a
 tqYxIR0xc/D4J9swm8fT4VpEENlJPhYS
X-Google-Smtp-Source: ABdhPJwNiWUH69H9j/rg7cEvViy/uJINohR7ix2A2F0PALIs2gR1NMlLOsKLwVie0SGTwrZNmWFRI0oB0D9I
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1a96:a43f:6c2e:bb5a])
 (user=qperret job=sendgmr) by 2002:a0c:e313:: with SMTP id
 s19mr23719350qvl.26.1626691686389; Mon, 19 Jul 2021 03:48:06 -0700 (PDT)
Date: Mon, 19 Jul 2021 11:47:32 +0100
In-Reply-To: <20210719104735.3681732-1-qperret@google.com>
Message-Id: <20210719104735.3681732-12-qperret@google.com>
Mime-Version: 1.0
References: <20210719104735.3681732-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH 11/14] KVM: arm64: Expose kvm_pte_valid() helper
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
Cc: qwandor@google.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
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

The KVM pgtable API exposes the kvm_pgtable_walk() function to allow
the definition of walkers outside of pgtable.c. However, it is not easy
to implement any of those walkers without some of the low-level helpers,
such as kvm_pte_valid(). Make it static inline, and move it to the
header file to allow its re-use in other places.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 7 +++++++
 arch/arm64/kvm/hyp/pgtable.c         | 6 ------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 1aa49d6aabb7..8240c881ae1e 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -25,6 +25,13 @@ static inline u64 kvm_get_parange(u64 mmfr0)
 
 typedef u64 kvm_pte_t;
 
+#define KVM_PTE_VALID			BIT(0)
+
+static inline bool kvm_pte_valid(kvm_pte_t pte)
+{
+	return pte & KVM_PTE_VALID;
+}
+
 /**
  * struct kvm_pgtable_mm_ops - Memory management callbacks.
  * @zalloc_page:		Allocate a single zeroed memory page.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c7120797404a..e0ae57dca827 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -11,7 +11,6 @@
 #include <asm/kvm_pgtable.h>
 #include <asm/stage2_pgtable.h>
 
-#define KVM_PTE_VALID			BIT(0)
 
 #define KVM_PTE_TYPE			BIT(1)
 #define KVM_PTE_TYPE_BLOCK		0
@@ -135,11 +134,6 @@ static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
 	return __kvm_pgd_page_idx(&pgt, -1ULL) + 1;
 }
 
-static bool kvm_pte_valid(kvm_pte_t pte)
-{
-	return pte & KVM_PTE_VALID;
-}
-
 static bool kvm_pte_table(kvm_pte_t pte, u32 level)
 {
 	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

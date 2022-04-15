Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE930C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Apr 2022 21:59:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80FF14B133;
	Fri, 15 Apr 2022 17:59:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZZKrYGoF7mYW; Fri, 15 Apr 2022 17:59:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14F7249F40;
	Fri, 15 Apr 2022 17:59:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E51E84B102
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fE+1S55zjqpy for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2022 17:59:18 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61B824B0E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:16 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 i36-20020a25b224000000b006420453d37aso3274294ybj.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 14:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=B6406tYui+5lJgRvZIHJ2dZYS6AUdUd0eyrsU1t7VRI=;
 b=RzttCkqDWkMAl2afGr2S9DJJm5Ry89zm9fK8vSWXxjh+Br5xy5GQOart2FDuwkrzu8
 +3Iq4y2goOAEc/FMm6DlVztE2ytFr3oiz9PTrVTxIm5m3Agm5OTfDy0Zs4ZMjS6SjcTP
 Zb1tTD9KujpWLSKkx4Mqs5RJ6LI4Z/u/gq513Flk/dllCKb2U4eZ8URwcntAGL1GuOmq
 ufWltbnns/Dj/9u47iW81VO53GtXf0bBfExXn11hVKS6QGf6GMMShHapP0dxeuiycC4J
 XphrZoAoqeoctTsXEHQSr5ZLlJzNIHeMt45VK8ODHWJivQe27pVAh1K+W85kwYhJyLS2
 rKpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=B6406tYui+5lJgRvZIHJ2dZYS6AUdUd0eyrsU1t7VRI=;
 b=5PaOB+6WFdvbZwjiX4j/xUrO9FIUp0N4fuUGwr2XtDKVoMkXYCTnSLlSkKTApveeMQ
 ryXCtHhxotENfVDpz3pevGp3/3w5p4DC6gLyCyWOe25ZVcaorr+kJknA7XyuE3CSxvAB
 b4DZHJonkfoSZIAY+aElSnpoP0eAcJVmJBVal28qDlxPTrSnFZ7TiOUtVFXbKJsafNMj
 2Z2hETTBovaFh2gYVyz4ypxBPJF5aoo5ipeVxC7UTPxn8oUKQ99lxkQIwEhWDjAFo3jz
 DVbkgOaxBbdCW+Af3Q4QyEfTLCm2taJBe0fsj3iARxv4lNwq0KBXHpv2yrRD/POppkpz
 vKPg==
X-Gm-Message-State: AOAM5331zRZgIovB1NlVJASgPcOutGflrsesGNz5mW/PTO8fh8VsgSOL
 ECuVxkUkiKJIz+5XowmV29xGjau8gf4hwiwyUkqXzpujgGUGZci1qSnsRgORkIojTPnIG8sHcQO
 EgCdR1bY+sqBl8rs8FmlyYeqC1z4OtNhzqjMGjkSKBLBHl96Og+EJxBLexTIg7ZtQPYAKZg==
X-Google-Smtp-Source: ABdhPJyC6al0eeORHQcVaP84DLwWwiUHL9eCDBoXdDwFa7r/iAh2U4p6UOyrCV4QCls9mT6W0yMv3xIYId8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a81:4989:0:b0:2f1:47b9:8ac2 with
 SMTP id
 w131-20020a814989000000b002f147b98ac2mr935486ywa.346.1650059955713; Fri, 15
 Apr 2022 14:59:15 -0700 (PDT)
Date: Fri, 15 Apr 2022 21:58:52 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-9-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 08/17] KVM: arm64: Spin off helper for initializing table
 pte
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Ben Gardon <bgardon@google.com>, Peter Shier <pshier@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

With parallel table walks there is no guarantee that KVM reads back the
same pte that was written. Spin off a helper that creates a pte value,
thereby allowing the visitor callback to return the next table without
reading the ptep again.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index ff6f14755d0c..ffdfd5ee9642 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -167,14 +167,23 @@ static void kvm_clear_pte(kvm_pte_t *ptep)
 	WRITE_ONCE(*ptep, 0);
 }
 
-static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
-			      struct kvm_pgtable_mm_ops *mm_ops)
+static kvm_pte_t kvm_init_table_pte(kvm_pte_t *childp, struct kvm_pgtable_mm_ops *mm_ops)
 {
-	kvm_pte_t old = *ptep, pte = kvm_phys_to_pte(mm_ops->virt_to_phys(childp));
+	kvm_pte_t pte = kvm_phys_to_pte(mm_ops->virt_to_phys(childp));
 
 	pte |= FIELD_PREP(KVM_PTE_TYPE, KVM_PTE_TYPE_TABLE);
 	pte |= KVM_PTE_VALID;
 
+	return pte;
+}
+
+static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
+			      struct kvm_pgtable_mm_ops *mm_ops)
+{
+	kvm_pte_t pte, old = *ptep;
+
+	pte = kvm_init_table_pte(childp, mm_ops);
+
 	WARN_ON(kvm_pte_valid(old));
 	smp_store_release(ptep, pte);
 }
@@ -931,7 +940,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 				kvm_pte_t *old, struct stage2_map_data *data, bool shared)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
-	kvm_pte_t *childp;
+	kvm_pte_t *childp, pte;
 	int ret;
 
 	if (data->anchor) {
@@ -969,9 +978,9 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	 * a table. Accesses beyond 'end' that fall within the new table
 	 * will be mapped lazily.
 	 */
-	kvm_set_table_pte(ptep, childp, mm_ops);
-	mm_ops->get_page(ptep);
-	*old = *ptep;
+	pte = kvm_init_table_pte(childp, mm_ops);
+	stage2_make_pte(ptep, pte, data->mm_ops);
+	*old = pte;
 	return 0;
 }
 
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

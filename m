Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F12DDC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  1 Dec 2021 17:04:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BA694B21E;
	Wed,  1 Dec 2021 12:04:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id faV1I0UKM2Ek; Wed,  1 Dec 2021 12:04:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EDDE4B242;
	Wed,  1 Dec 2021 12:04:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E24584B242
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:04:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vv6RA1HihnBF for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 12:04:26 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 653464B25A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:04:26 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id
 g80-20020a1c2053000000b003331a764709so148847wmg.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Dec 2021 09:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=A7hr35xG6SzEHwDet74XtvHzJsI/X+Zg/yL5/WYnOz0=;
 b=ah12j+uUrkgUrk9b1HPkNYJu1wVkvH0SX1GjxWlFdsGE3bEQ46fAXvn0aJfcBwEo+8
 6LrYpwJQVU32AtFiqZZFehFhMRCpiksII11x5No7K2l4MzTVhOGCcKSwW4VsaKYB/KwZ
 STISVRv3cmicA+IFYacwY4r+EdcvE6uDIJ6X9F/HMudy2oqDeRgFfx9EYMTh5ZhcNkDE
 y+NXXLWJwOH5boJw7lqmcJwIiiAh7SITqADYhwT/9haBjdb8CHxhJXGD/TIgVldyEoGn
 uw+wuq1gmGXOB6VUh00f2IDCloa5CVB3P1CMZ5640YlWHcMYBtJVsIffUl4qaumK2x0t
 XUbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=A7hr35xG6SzEHwDet74XtvHzJsI/X+Zg/yL5/WYnOz0=;
 b=pktmU5qQVGEVjuKMuPwfgKv0HkjwkOoG6QcAln8/ZA7a6qnRQ6tgDsKrCL4szyV4N5
 Yu2UGtI9V9XNDsQ1tVvxoT1jbWP+SOMaTMCyi1yaYu3dI/pfh+lrKZp+/7cdvCj7awaT
 Ma5NIMtTgvRTECBj1uojMZBJMgiASwks4yy5XGfdeAVB8bj1joWnQGXzb68AUeQJyLHO
 /lxfMiql5rxQSxoaX/IVf6W4W0+rH6Q+OI4zjMRN8bG6oBHyxmnv/mJug7tUnzzc3COF
 F7t4rbxuz8/kV/4fi86Q8y/jb/kb7gcrt1FPUdYHW7xPlTwJVL2s9YyHD1PncH2xLR/t
 Akeg==
X-Gm-Message-State: AOAM531mbG98qMhYC0c6ESR4tdRcE11yBa5dhlqdz2fFAAm7OV/cfbqQ
 gb3aO3ogXOTzWqeiiQWQjMOYawErVoI9
X-Google-Smtp-Source: ABdhPJxp5L6PtF860OZ96JvJzz+R53mWZq1H92zAhum23/hQpBFE1gQt/KAt2QyLRQi8U4J5dXjZ/F1KEhLb
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1cab:1a20:2ef1:ddde])
 (user=qperret job=sendgmr) by 2002:a5d:40cf:: with SMTP id
 b15mr8314262wrq.161.1638378265569; Wed, 01 Dec 2021 09:04:25 -0800 (PST)
Date: Wed,  1 Dec 2021 17:03:57 +0000
In-Reply-To: <20211201170411.1561936-1-qperret@google.com>
Message-Id: <20211201170411.1561936-4-qperret@google.com>
Mime-Version: 1.0
References: <20211201170411.1561936-1-qperret@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 03/15] KVM: arm64: Refcount hyp stage-1 pgtable pages
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

To prepare the ground for allowing hyp stage-1 mappings to be removed at
run-time, update the KVM page-table code to maintain a correct refcount
using the ->{get,put}_page() function callbacks.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index f8ceebe4982e..768a58835153 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -408,8 +408,10 @@ static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 		return false;
 
 	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
-	if (hyp_pte_needs_update(old, new))
+	if (hyp_pte_needs_update(old, new)) {
 		smp_store_release(ptep, new);
+		data->mm_ops->get_page(ptep);
+	}
 
 	data->phys += granule;
 	return true;
@@ -433,6 +435,7 @@ static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 		return -ENOMEM;
 
 	kvm_set_table_pte(ptep, childp, mm_ops);
+	mm_ops->get_page(ptep);
 	return 0;
 }
 
@@ -482,8 +485,16 @@ static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			   enum kvm_pgtable_walk_flags flag, void * const arg)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = arg;
+	kvm_pte_t pte = *ptep;
+
+	if (!kvm_pte_valid(pte))
+		return 0;
+
+	mm_ops->put_page(ptep);
+
+	if (kvm_pte_table(pte, level))
+		mm_ops->put_page(kvm_pte_follow(pte, mm_ops));
 
-	mm_ops->put_page((void *)kvm_pte_follow(*ptep, mm_ops));
 	return 0;
 }
 
@@ -491,7 +502,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 {
 	struct kvm_pgtable_walker walker = {
 		.cb	= hyp_free_walker,
-		.flags	= KVM_PGTABLE_WALK_TABLE_POST,
+		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
 		.arg	= pgt->mm_ops,
 	};
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

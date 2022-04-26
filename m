Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 486A4C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 26 Apr 2022 15:23:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 001F04B1AB;
	Tue, 26 Apr 2022 11:23:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0XPkLqgyPpVC; Tue, 26 Apr 2022 11:23:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDA494B1E7;
	Tue, 26 Apr 2022 11:23:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB7DE4B1C4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 01:39:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VLni1jTmYAmA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Apr 2022 01:39:26 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 89EF54B1BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 01:39:26 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 i10-20020a1709026aca00b00158f14b4f2fso10723371plt.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 22:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=a9VzBJlMLigws4pRoWaDUwEnDDiqJQ0nJjM8cxStkWo=;
 b=p8mJqCwHacTbFhvYHu8ybGXK2P+PghFMqaxHHJuqdpta07t/m8JQTkdFg82eEvuWYd
 OdSYMSKPBvO7ptjR046sAX/bHvFVjhg/pzuwVzXmGfoIsID/2GXXQHWYzh25sp8Zhqzf
 htWeN1iMzxl7/9Pdv1zinxHd6q+dx76sncvVGGjZOTWwwfxxB2qSbB8gn6IY5+O3yc7/
 BeF9G0WjghrY1fZ5jCmiJkVNg5fp3DJ1BPeCzpmLCtKqzsEWqGLssoJmyaPfwKCC+CiD
 5TQ/VweVfCM1sVLfYaViWaZEyQtlCxE0YpkORn8opIIBD11EyDSBFcvRbtm+lxTTiRjt
 7Vwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=a9VzBJlMLigws4pRoWaDUwEnDDiqJQ0nJjM8cxStkWo=;
 b=0AsO+6TusDxrf8tEJRYSa00G6cuz5pd55cXNhx7S2x59pYvmMb0kyi9cJc6rBRpGC9
 zVVxDtrwMkGUp9eARVXgM5d5ZJ1XxhYBvEu4vWtVX7Ux56l/GgcJqGBHUkZGggKhSn+R
 pYeL72Rw/H2LWnO+yNSpOf5W9RpsZLrOMfWnoqBzFtPPbxfLBQTFwqcyQIM4l1YYbtst
 wJX9ziGn74qJ5iqsNYM7bQbwcSjx+45c7DaM4wmk0aXyqQ/oWS2nq6RfF0NqbP8/6R0p
 2BM/Ma3JK3192+NkUba1DOHZR5IKCJId0zmGk2D0MjQzR6BcGCHMon0+CZt3Zwx9RMxB
 J3og==
X-Gm-Message-State: AOAM532wRRR7vcvWFRfpKcE+LAJrwBL9es/s0wuaXdjYVHiAHSo/M/rr
 bIGIGND8KJhtPRLb2XFTu6yHNogJnrEwnu+A
X-Google-Smtp-Source: ABdhPJxYCaRW6ujjy+jD12c3CK0Xph6XJaTEbXPAfsnpbu06l91YAgqtjLNqwlREDx07xf+SlrnmNlHPGW+NrZOR
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a63:de12:0:b0:3ab:7c33:2894
 with SMTP
 id f18-20020a63de12000000b003ab7c332894mr3565024pgg.187.1650951565540; Mon,
 25 Apr 2022 22:39:25 -0700 (PDT)
Date: Tue, 26 Apr 2022 05:39:03 +0000
In-Reply-To: <20220426053904.3684293-1-yosryahmed@google.com>
Message-Id: <20220426053904.3684293-6-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220426053904.3684293-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v3 5/6] KVM: riscv/mmu: count KVM page table pages in
 pagetable stats
From: Yosry Ahmed <yosryahmed@google.com>
To: Sean Christopherson <seanjc@google.com>,
 Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, 
 Atish Patra <atishp@atishpatra.org>, Paolo Bonzini <pbonzini@redhat.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
 Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeelb@google.com>, James Morse <james.morse@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Marc Zyngier <maz@kernel.org>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
X-Mailman-Approved-At: Tue, 26 Apr 2022 11:23:27 -0400
Cc: kvm@vger.kernel.org, linux-mips@vger.kernel.org,
 linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>,
 linux-mm@kvack.org, kvm-riscv@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Count the pages used by KVM in riscv for page tables in pagetable stats.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 arch/riscv/kvm/mmu.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index f80a34fbf102..fcfb75713750 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -152,6 +152,7 @@ static int stage2_set_pte(struct kvm *kvm, u32 level,
 			next_ptep = kvm_mmu_memory_cache_alloc(pcache);
 			if (!next_ptep)
 				return -ENOMEM;
+			kvm_account_pgtable_pages((void *)next_ptep, +1);
 			*ptep = pfn_pte(PFN_DOWN(__pa(next_ptep)),
 					__pgprot(_PAGE_TABLE));
 		} else {
@@ -229,6 +230,7 @@ static void stage2_op_pte(struct kvm *kvm, gpa_t addr,
 	pte_t *next_ptep;
 	u32 next_ptep_level;
 	unsigned long next_page_size, page_size;
+	struct page *p;
 
 	ret = stage2_level_to_page_size(ptep_level, &page_size);
 	if (ret)
@@ -252,8 +254,13 @@ static void stage2_op_pte(struct kvm *kvm, gpa_t addr,
 		for (i = 0; i < PTRS_PER_PTE; i++)
 			stage2_op_pte(kvm, addr + i * next_page_size,
 					&next_ptep[i], next_ptep_level, op);
-		if (op == STAGE2_OP_CLEAR)
-			put_page(virt_to_page(next_ptep));
+		if (op == STAGE2_OP_CLEAR) {
+			p = virt_to_page(next_ptep);
+			if (page_count(p) == 1)
+				kvm_account_pgtable_pages((void *)next_ptep,
+							  -1);
+			put_page(p);
+		}
 	} else {
 		if (op == STAGE2_OP_CLEAR)
 			set_pte(ptep, __pte(0));
@@ -700,25 +707,27 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm)
 {
 	struct page *pgd_page;
+	int order;
 
 	if (kvm->arch.pgd != NULL) {
 		kvm_err("kvm_arch already initialized?\n");
 		return -EINVAL;
 	}
 
-	pgd_page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
-				get_order(stage2_pgd_size));
+	order = get_order(stage2_pgd_size);
+	pgd_page = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
 	if (!pgd_page)
 		return -ENOMEM;
 	kvm->arch.pgd = page_to_virt(pgd_page);
 	kvm->arch.pgd_phys = page_to_phys(pgd_page);
-
+	kvm_account_pgtable_pages((void *)kvm->arch.pgd, +(1UL << order));
 	return 0;
 }
 
 void kvm_riscv_stage2_free_pgd(struct kvm *kvm)
 {
 	void *pgd = NULL;
+	int order;
 
 	spin_lock(&kvm->mmu_lock);
 	if (kvm->arch.pgd) {
@@ -729,8 +738,11 @@ void kvm_riscv_stage2_free_pgd(struct kvm *kvm)
 	}
 	spin_unlock(&kvm->mmu_lock);
 
-	if (pgd)
-		free_pages((unsigned long)pgd, get_order(stage2_pgd_size));
+	if (pgd) {
+		order = get_order(stage2_pgd_size);
+		kvm_account_pgtable_pages((void *)pgd, -(1UL << order));
+		free_pages((unsigned long)pgd, order);
+	}
 }
 
 void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu)
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

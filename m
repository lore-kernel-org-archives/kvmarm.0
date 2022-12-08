Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D120EC4332F
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:39:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9020A4BA68;
	Thu,  8 Dec 2022 14:39:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JPj5qWHu-YVV; Thu,  8 Dec 2022 14:39:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA8464BA6C;
	Thu,  8 Dec 2022 14:39:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEA8B4BA2F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id THNQPL6TlPgM for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:39:40 -0500 (EST)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 466E94BA2B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:37 -0500 (EST)
Received: by mail-yb1-f202.google.com with SMTP id
 f11-20020a5b01cb000000b0070374b66537so2541320ybp.14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=IqmyM2QEYva7JW7axwbl4xIkL86pAwW/H4sjSNNkIgM=;
 b=dlUm8IzbDvKb7N133pMZbM/DFF2KBU+Uj9aLv9J4HYtcIkmIb26+E+NQc6WW5lGWbL
 gRjhF2Xtb1+eYvjvVNPz1fbza7FzGrlR1Lu4PkwObVflvo1HWtD/PdV/GtwH/OYCGqmW
 unzqYTbSQw2kEfHvH067uKfBCEte20dfejQENL3zjpmLPkBmJgJlntv4NgZXLQazrFdX
 xuOUsmX6ghWNWZUkpgBa0nNKdgiEWdVdSAmfBWBxgOuca3Crx0ITb6PP4ZfWYj0CDybH
 3DDCzi9SmVtrCH3Ln+bCV9cJJ5HGVNrG9C8r5e5Ny4xwAEq3sPHh7YTtyJKFJzf22O7k
 p2Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=IqmyM2QEYva7JW7axwbl4xIkL86pAwW/H4sjSNNkIgM=;
 b=RaZCS0MX3jE9PdyT9+UipxjgzweAB9O1GLYwxtKIskdTqRrgLtm+F8WH7gF960Ump2
 uqTuJ50NBM0hVO1jDAxtKwUlnbuykafjhacGmiXgVlw76u4KgH6gXWfrhamPwownhdmt
 WxSYGB9b0PiG8tihJUhndTKkcHB3kxg7PAyp56AnCRgZ1IcEGY2Nmmexn0q/0FORhGRe
 NndT6gQ1VzpUSKxKTd9iZBZpTCWtZJ9bB/DGDrVPspJydWfD04yW4uBV6psvypxArspq
 6ML1q1NnVksfdmMhuJ5wiSv/eRidI4/B2OfvCDAr5XRQ0qZgGJ4aNQ703FlP88sQVQWJ
 ur9Q==
X-Gm-Message-State: ANoB5pnOLyfhmT/pL/fFn5qQ9ybHW5lubyaokmjVqRtc0F7NIPh31GGh
 neUNgWCzzHYIoU7BCJ0fIqUgTr/vWkVnlA==
X-Google-Smtp-Source: AA0mqf7z1vyD3rdlMeoQGriM43dtIzP7Gztt83Sfud7zIuPh1YZpIi0HN2kxDCnBaSlw5o2SzSSWGj7vYJ4cig==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:7851:0:b0:3b6:e1ed:4185 with SMTP id
 t78-20020a817851000000b003b6e1ed4185mr57305022ywc.330.1670528376810; Thu, 08
 Dec 2022 11:39:36 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:38 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-19-dmatlack@google.com>
Subject: [RFC PATCH 18/37] KVM: x86/mmu: Add common API for creating TDP PTEs
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 kvmarm@lists.linux.dev, Nadav Amit <namit@vmware.com>,
 Colin Cross <ccross@google.com>, Ben Gardon <bgardon@google.com>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
 kvm@vger.kernel.org, Atish Patra <atishp@atishpatra.org>,
 David Matlack <dmatlack@google.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Morton <akpm@linux-foundation.org>
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

Introduce an API for construction of TDP PTEs.

- tdp_mmu_make_leaf_pte()
- tdp_mmu_make_nonleaf_pte()
- tdp_mmu_make_huge_page_split_pte()
- tdp_mmu_make_changed_pte_notifier_pte()

This will be used in a future commit to move the TDP MMU to common code,
while PTE construction will stay in the architecture-specific code.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm/tdp_pgtable.h | 10 +++++++
 arch/x86/kvm/mmu/tdp_mmu.c             | 18 +++++--------
 arch/x86/kvm/mmu/tdp_pgtable.c         | 36 ++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm/tdp_pgtable.h b/arch/x86/include/asm/kvm/tdp_pgtable.h
index c5c4e4cab24a..ff2691ced38b 100644
--- a/arch/x86/include/asm/kvm/tdp_pgtable.h
+++ b/arch/x86/include/asm/kvm/tdp_pgtable.h
@@ -4,6 +4,7 @@
 
 #include <linux/types.h>
 #include <linux/kvm_types.h>
+#include <kvm/mmu_types.h>
 
 struct kvm_mmu_page *tdp_mmu_root(struct kvm_vcpu *vcpu);
 
@@ -57,4 +58,13 @@ kvm_pfn_t tdp_pte_to_pfn(u64 pte);
 
 void tdp_pte_check_leaf_invariants(u64 pte);
 
+struct tdp_iter;
+
+u64 tdp_mmu_make_leaf_pte(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
+			  struct tdp_iter *iter, bool *wrprot);
+u64 tdp_mmu_make_nonleaf_pte(struct kvm_mmu_page *sp);
+u64 tdp_mmu_make_changed_pte_notifier_pte(struct tdp_iter *iter,
+					  struct kvm_gfn_range *range);
+u64 tdp_mmu_make_huge_page_split_pte(struct kvm *kvm, u64 huge_spte,
+				     struct kvm_mmu_page *sp, int index);
 #endif /* !__ASM_KVM_TDP_PGTABLE_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 8155a9e79203..0172b0e44817 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1057,17 +1057,13 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 					  struct tdp_iter *iter)
 {
 	struct kvm_mmu_page *sp = sptep_to_sp(rcu_dereference(iter->sptep));
-	u64 new_spte;
 	int ret = RET_PF_FIXED;
 	bool wrprot = false;
+	u64 new_spte;
 
 	WARN_ON(sp->role.level != fault->goal_level);
-	if (unlikely(!fault->slot))
-		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
-	else
-		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
-					 fault->pfn, iter->old_spte, fault->prefetch, true,
-					 fault->map_writable, &new_spte);
+
+	new_spte = tdp_mmu_make_leaf_pte(vcpu, fault, iter, &wrprot);
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
@@ -1117,7 +1113,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 			   struct kvm_mmu_page *sp, bool shared)
 {
-	u64 spte = make_nonleaf_spte(sp->spt, !kvm_ad_enabled());
+	u64 spte = tdp_mmu_make_nonleaf_pte(sp);
 	int ret = 0;
 
 	if (shared) {
@@ -1312,9 +1308,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
 	tdp_mmu_set_spte(kvm, iter, 0);
 
 	if (!pte_write(range->pte)) {
-		new_spte = kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,
-								  pte_pfn(range->pte));
-
+		new_spte = tdp_mmu_make_changed_pte_notifier_pte(iter, range);
 		tdp_mmu_set_spte(kvm, iter, new_spte);
 	}
 
@@ -1466,7 +1460,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * not been linked in yet and thus is not reachable from any other CPU.
 	 */
 	for (i = 0; i < TDP_PTES_PER_PAGE; i++)
-		sp->spt[i] = make_huge_page_split_spte(kvm, huge_spte, sp->role, i);
+		sp->spt[i] = tdp_mmu_make_huge_page_split_pte(kvm, huge_spte, sp, i);
 
 	/*
 	 * Replace the huge spte with a pointer to the populated lower level
diff --git a/arch/x86/kvm/mmu/tdp_pgtable.c b/arch/x86/kvm/mmu/tdp_pgtable.c
index 97cc900e8818..e036ba0c6bee 100644
--- a/arch/x86/kvm/mmu/tdp_pgtable.c
+++ b/arch/x86/kvm/mmu/tdp_pgtable.c
@@ -5,6 +5,7 @@
 
 #include "mmu.h"
 #include "spte.h"
+#include "tdp_iter.h"
 
 /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
 static_assert(!(REMOVED_TDP_PTE & SPTE_MMU_PRESENT_MASK));
@@ -75,3 +76,38 @@ void tdp_pte_check_leaf_invariants(u64 pte)
 	check_spte_writable_invariants(pte);
 }
 
+u64 tdp_mmu_make_leaf_pte(struct kvm_vcpu *vcpu,
+			  struct kvm_page_fault *fault,
+			  struct tdp_iter *iter,
+			  bool *wrprot)
+{
+	struct kvm_mmu_page *sp = sptep_to_sp(rcu_dereference(iter->sptep));
+	u64 new_spte;
+
+	if (unlikely(!fault->slot))
+		return make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
+
+	*wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
+			    fault->pfn, iter->old_spte, fault->prefetch, true,
+			    fault->map_writable, &new_spte);
+
+	return new_spte;
+}
+
+u64 tdp_mmu_make_nonleaf_pte(struct kvm_mmu_page *sp)
+{
+	return make_nonleaf_spte(sp->spt, !kvm_ad_enabled());
+}
+
+u64 tdp_mmu_make_changed_pte_notifier_pte(struct tdp_iter *iter,
+					  struct kvm_gfn_range *range)
+{
+	return kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,
+						      pte_pfn(range->pte));
+}
+
+u64 tdp_mmu_make_huge_page_split_pte(struct kvm *kvm, u64 huge_spte,
+				     struct kvm_mmu_page *sp, int index)
+{
+	return make_huge_page_split_spte(kvm, huge_spte, sp->role, index);
+}
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

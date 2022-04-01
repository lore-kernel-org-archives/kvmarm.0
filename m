Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 439D0C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 18:21:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F09FC4B2D2;
	Fri,  1 Apr 2022 14:21:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z8cijqi7H6YP; Fri,  1 Apr 2022 14:21:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0158A4B2BA;
	Fri,  1 Apr 2022 14:20:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CEDF4B216
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A93XZ042b2Tz for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 13:56:29 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB9FF4B27C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:28 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 o15-20020a17090aac0f00b001c6595a43dbso1931995pjq.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2022 10:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=N+Yt2vLgKrZHcuNVUsOj9eJGBLy1X2SsKXkQhye+WRI=;
 b=Qr6kriferOcm7AIY4k/KBQ72DaTvRRltjRQh/5ECnhmB7SaEkrHaUEXakckg6PNkRI
 UqnATSklWc+8zALzY6JKcjXGFe1SfBq6T8EoKDzLpY6jLE2QLs0t53yQ/skVLxXtxGPc
 SbCNotOgDY1raopFMdahKZ5R9WaFB1/m5rObgP9wTILsP2yEOkos0mtBOC4YzivxawyR
 A6HVPHEPfUothLkegc9HrO+kBmoz4HMGCFgxA1bBAmyGBat3PADxzlV+wjdNE3FggTSW
 FImW+j6GQKwF5ZJexZpan7VjGim/N71Uhn5jXmS5VsRXU7NBV1T63G8bmnjgkl+Uvk8D
 elaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=N+Yt2vLgKrZHcuNVUsOj9eJGBLy1X2SsKXkQhye+WRI=;
 b=GmSjZo5rsgE1XHJZ+bk9OFs0M7sOldAqAnJFapjB9vnTLg+LdM0EMtmLPGEeUC5k0S
 qk5/rQgqDRi5I1sUEty7SdiUzuMWu52TyQLuGMcm5RnlQsNB9m9yBhbGyy5Dx9Jxq+pp
 lyccm1ZwQ0IWdU5LqqnZpZNtyGVXbywZVXYRFluM0SiEfNH5gRdeF1lgxaZ3Nk+Do4FP
 QTJLGG1SV1YxuoN63OAgHE2uRGUdUUCbsxHmtu4yXL/n74RixzI2XBSO80B84go2D+hi
 cX+oDdMBLmpBv/jmCBHu4dXXQ89askvjvsD7j1UeAn5bZcF3zE4tzoZR0jfNN25Cmssj
 ex+Q==
X-Gm-Message-State: AOAM531p/Ud+QIo3JabTPTg6su4ApW6L1Qay41BtBE7WBCZLNvxoJ/w6
 umbtIYp84R+RPcm2DeY2DzkyOt2UBUe7ng==
X-Google-Smtp-Source: ABdhPJwplQwfsWEVcDA4UHiGwuSL/A4oELiqXDjC0LjFD0RE2g1bBGBlZDUBl9Lc3mLD3IwFfsHZo9b9soqNMw==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:3e44:b0:1c9:8365:5753 with SMTP
 id t4-20020a17090a3e4400b001c983655753mr13236316pjm.60.1648835788080; Fri, 01
 Apr 2022 10:56:28 -0700 (PDT)
Date: Fri,  1 Apr 2022 17:55:48 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-18-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 17/23] KVM: x86/mmu: Extend make_huge_page_split_spte() for
 the shadow MMU
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 01 Apr 2022 14:20:42 -0400
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>, David Matlack <dmatlack@google.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

Currently make_huge_page_split_spte() assumes execute permissions can be
granted to any 4K SPTE when splitting huge pages. This is true for the
TDP MMU but is not necessarily true for the shadow MMU, since we may be
splitting a huge page that shadows a non-executable guest huge page.

To fix this, pass in the child shadow page where the huge page will be
split and derive the execution permission from the shadow page's role.
This is correct because huge pages are always split with direct shadow
page and thus the shadow page role contains the correct access
permissions.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/spte.c    | 13 +++++++------
 arch/x86/kvm/mmu/spte.h    |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index d10189d9c877..ef6537c6f5ef 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -216,10 +216,11 @@ static u64 make_spte_executable(u64 spte)
  * This is used during huge page splitting to build the SPTEs that make up the
  * new page table.
  */
-u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
+u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index)
 {
+	bool exec_allowed = sp->role.access & ACC_EXEC_MASK;
+	int child_level = sp->role.level;
 	u64 child_spte;
-	int child_level;
 
 	if (WARN_ON_ONCE(!is_shadow_present_pte(huge_spte)))
 		return 0;
@@ -228,7 +229,6 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
 		return 0;
 
 	child_spte = huge_spte;
-	child_level = huge_level - 1;
 
 	/*
 	 * The child_spte already has the base address of the huge page being
@@ -241,10 +241,11 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
 		child_spte &= ~PT_PAGE_SIZE_MASK;
 
 		/*
-		 * When splitting to a 4K page, mark the page executable as the
-		 * NX hugepage mitigation no longer applies.
+		 * When splitting to a 4K page where execution is allowed, mark
+		 * the page executable as the NX hugepage mitigation no longer
+		 * applies.
 		 */
-		if (is_nx_huge_page_enabled())
+		if (exec_allowed && is_nx_huge_page_enabled())
 			child_spte = make_spte_executable(child_spte);
 	}
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 73f12615416f..921ea77f1b5e 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -415,7 +415,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
-u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index);
+u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a04262bc34e2..36d241405ecc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1455,7 +1455,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * not been linked in yet and thus is not reachable from any other CPU.
 	 */
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++)
-		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i);
+		sp->spt[i] = make_huge_page_split_spte(huge_spte, sp, i);
 
 	/*
 	 * Replace the huge spte with a pointer to the populated lower level
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

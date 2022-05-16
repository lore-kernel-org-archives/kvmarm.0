Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5515C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 17 May 2022 07:02:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 929BB4B2CA;
	Tue, 17 May 2022 03:02:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H2phdQWIrVeA; Tue, 17 May 2022 03:02:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03E564B2A4;
	Tue, 17 May 2022 03:02:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 799964B1F7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:22:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mrAvSPpN0FFT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 19:22:11 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3EBFD4B1ED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:22:11 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 x4-20020a1709028ec400b0015e84d42eaaso8707340plo.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 16:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=q0LsgOUH6fh/EMGEgMPSdRPwXrsuMMeqwhsgKGGJKHM=;
 b=sYxBRUC4xCN0gxlNhyXh4ufIMQqfDpQw9fg0VVL0zI2FMLrgq4nlCYyXlslYTTGplN
 VQrupVuKsqXc2SNFb2+VhZQRxQOvM2YnH3q3YSFqPcm692rXWSh+NUl7k+d70kZa9eBB
 wxXdK/rsf+VNmJTQrWXEeM16bukVzOiurMq+cIDEC3jlVkM7E7l/hPAPO4kMJltEVJ2+
 EQc+TESlu4v97mzryGnMTnAze7LS9b7TvaoA/H18t856AtOc1lpnM5DyaPUiUz3DwjzB
 LNs3hvGx1VHDzpqotysdCyaQw0PxsX3Spv268K6bsyFhPR8sgZ8yP/+B5u+LOfsPTGIJ
 mzfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=q0LsgOUH6fh/EMGEgMPSdRPwXrsuMMeqwhsgKGGJKHM=;
 b=II9olXTt/a5H1kBeDFhBQF1THADHthVh09hWAOBJ21O3TOMQ3kuL+knBxs7uqp7lUX
 6pq3/NnjV5Iede0p2UJgC4RoRFkX3OWF7QjG7RXGpYFKH1IGmjjp2ntFgaM7hEkj13rY
 vgvsXabeH5RhUbMXVYXi71f0Hx3wcUqJkfO//vKfFYKQhavLpKub0U1ySmccVXj2n3b7
 HxEF9BTjV3kyK6i6iyDG2lCKZcx5MaaheDLCK68x+UpGXRBIXjapDyCrjTQkkrYIV6kX
 fcGvSm7TT2swXCZTx7xWrz9oIY8FhkWRLGYL98it6ApUM+3cTxe7h4TrZBzBnjQlwdGw
 IlqQ==
X-Gm-Message-State: AOAM53077/QH8+Jl0Ak1IzdXG0skvxJsTpHGyJCH+Dba2rZLmOwpHKvq
 CJLGLA+Q8lWnaOHzX7LVs66jsUcszqw7RQ==
X-Google-Smtp-Source: ABdhPJxxVc2X+E/BqhlrQUzowWpF74AF8VV0DkGvXIAS9U+w0AyQGB7MWZQd1uKFsOcBrtNhibS7p0Bf0PvO6g==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:903:22d2:b0:15e:a3a4:918c with SMTP
 id y18-20020a17090322d200b0015ea3a4918cmr19126527plg.36.1652743330438; Mon,
 16 May 2022 16:22:10 -0700 (PDT)
Date: Mon, 16 May 2022 23:21:34 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-19-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 18/22] KVM: x86/mmu: Extend make_huge_page_split_spte() for
 the shadow MMU
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Tue, 17 May 2022 03:02:25 -0400
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
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
TDP MMU but is not necessarily true for the shadow MMU, since KVM may be
shadowing a non-executable huge page.

To fix this, pass in the role of the child shadow page where the huge
page will be split and derive the execution permission from that.  This
is correct because huge pages are always split with direct shadow page
and thus the shadow page role contains the correct access permissions.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/spte.c    | 16 ++++++++--------
 arch/x86/kvm/mmu/spte.h    |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index b5960bbde7f7..237e8dc12993 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -244,10 +244,10 @@ static u64 make_spte_executable(u64 spte)
  * This is used during huge page splitting to build the SPTEs that make up the
  * new page table.
  */
-u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
+u64 make_huge_page_split_spte(u64 huge_spte, union kvm_mmu_page_role role,
+			      int index)
 {
 	u64 child_spte;
-	int child_level;
 
 	if (WARN_ON_ONCE(!is_shadow_present_pte(huge_spte)))
 		return 0;
@@ -256,23 +256,23 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
 		return 0;
 
 	child_spte = huge_spte;
-	child_level = huge_level - 1;
 
 	/*
 	 * The child_spte already has the base address of the huge page being
 	 * split. So we just have to OR in the offset to the page at the next
 	 * lower level for the given index.
 	 */
-	child_spte |= (index * KVM_PAGES_PER_HPAGE(child_level)) << PAGE_SHIFT;
+	child_spte |= (index * KVM_PAGES_PER_HPAGE(role.level)) << PAGE_SHIFT;
 
-	if (child_level == PG_LEVEL_4K) {
+	if (role.level == PG_LEVEL_4K) {
 		child_spte &= ~PT_PAGE_SIZE_MASK;
 
 		/*
-		 * When splitting to a 4K page, mark the page executable as the
-		 * NX hugepage mitigation no longer applies.
+		 * When splitting to a 4K page where execution is allowed, mark
+		 * the page executable as the NX hugepage mitigation no longer
+		 * applies.
 		 */
-		if (is_nx_huge_page_enabled())
+		if ((role.access & ACC_EXEC_MASK) && is_nx_huge_page_enabled())
 			child_spte = make_spte_executable(child_spte);
 	}
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 0127bb6e3c7d..3dada44cc066 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -425,7 +425,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
-u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index);
+u64 make_huge_page_split_spte(u64 huge_spte, union kvm_mmu_page_role role, int index);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 841feaa48be5..a5472ee56080 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1488,7 +1488,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * not been linked in yet and thus is not reachable from any other CPU.
 	 */
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++)
-		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i);
+		sp->spt[i] = make_huge_page_split_spte(huge_spte, sp->role, i);
 
 	/*
 	 * Replace the huge spte with a pointer to the populated lower level
-- 
2.36.0.550.gb090851708-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

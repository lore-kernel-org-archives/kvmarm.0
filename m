Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24089C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 08:49:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2E554A0FE;
	Fri, 11 Mar 2022 03:49:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MYA5fSZMq+bi; Fri, 11 Mar 2022 03:49:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55ADC4B091;
	Fri, 11 Mar 2022 03:48:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B1E440BD6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:26:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uxvxguTxuptg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 19:26:13 -0500 (EST)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F8AB408C1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:26:13 -0500 (EST)
Received: by mail-pf1-f202.google.com with SMTP id
 t184-20020a6281c1000000b004e103c5f726so4180837pfd.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 16:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=+N8CyLDUI8dOs6IazZEgayEpuN+Pk+7Zaf+44sPVu9M=;
 b=fkEfUCit5tqWvdDlI8v5ZSGJVY9seUe6cbf2whXXIZ5bwxCgzP0IqvRSWDUoHnUm0C
 W3XxUPolVkh0JOGVkZrBPLTgYMhmCmL3KGSLazm6lEXEdrUp9eA1e+Zxh3obazelnzBh
 dZq3DeFT1PL7lfJmBODoMSeUte5Fn4XfcSn9I3jPcoaKyZaVho/0yEOenJX9x6bY1C/o
 FG6pjk4smgKYWPjXUN1uX4ZD02cguLFEYY/MSYP3fEl3xF5comBq5sUT/YInXbYrQJMv
 JiMc8dEQa7jZfyLvcEOZDz+Kp9eA+3xn4embgt7o+mxQ1YtN7sOkwpiLsRTj0LtlLVPv
 dRCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=+N8CyLDUI8dOs6IazZEgayEpuN+Pk+7Zaf+44sPVu9M=;
 b=H3eJnpSZuUf7BYCQ2kl9pSJa1WED4dKzfI84cBvi+9jPLV66BKXAQvMWoSzy7IfED7
 RhffdiFCtRfSxRavw1YLZpkyeH9dF41GFv18jmFsE5D02WdhxAWp3dF2TOIUNIYMlvNT
 K2W3mgu0/rRQNsB2tntFucFVR3QAnBxt5/MqvXcgjJ2o5igpP4ZjeuFWBiK8sTDMos1W
 uInFPHSY5AhJlTUrnQRTb08c9uVY7Kc37u4+Q4sxLgIekxOmlJpcprwhMLpGCYugeoXG
 fDgTaqWn7R3D3AAMq+VXZjYLNAtl90SrHqej3IbgNxtY31aJa+xp026jiPPcOfOnCx3m
 ZhzQ==
X-Gm-Message-State: AOAM533liKM6uD4fXpCdTO5y2574VQXEt5gqrMfHBVhpViPINHG9c/xt
 t4zX2agUEgTw2w+gqishhO0grKztFzzRhg==
X-Google-Smtp-Source: ABdhPJzEurWCjkJGrlFQG7dN5CM2sI5brKP2s1Ygv17frKolnNrY7kNpKXDlaqlxOBpcKkeByFPsKnJeUISXWA==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:4d81:b0:1bf:8ce4:4f51 with SMTP
 id oj1-20020a17090b4d8100b001bf8ce44f51mr322717pjb.0.1646958371853; Thu, 10
 Mar 2022 16:26:11 -0800 (PST)
Date: Fri, 11 Mar 2022 00:25:26 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-25-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 24/26] KVM: x86/mmu: Split huge pages aliased by multiple
 SPTEs
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 11 Mar 2022 03:48:42 -0500
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

The existing huge page splitting code bails if it encounters a huge page
that is aliased by another SPTE that has already been split (either due
to NX huge pages or eager page splitting). Extend the huge page
splitting code to also handle such aliases.

The thing we have to be careful about is dealing with what's already in
the lower level page table. If eager page splitting was the only
operation that split huge pages, this would be fine. However huge pages
can also be split by NX huge pages. This means the lower level page
table may only be partially filled in and may point to even lower level
page tables that are partially filled in. We can fill in the rest of the
page table but dealing with the lower level page tables would be too
complex.

To handle this we flush TLBs after dropping the huge SPTE whenever we
are about to install a lower level page table that was partially filled
in (*). We can skip the TLB flush if the lower level page table was
empty (no aliasing) or identical to what we were already going to
populate it with (aliased huge page that was just eagerly split).

(*) This TLB flush could probably be delayed until we're about to drop
the MMU lock, which would also let us batch flushes for multiple splits.
However such scenarios should be rare in practice (a huge page must be
aliased in multiple SPTEs and have been split for NX Huge Pages in only
some of them). Flushing immediately is simpler to plumb and also reduces
the chances of tripping over a CPU bug (e.g. see iTLB multi-hit).

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h |  5 ++-
 arch/x86/kvm/mmu/mmu.c          | 73 +++++++++++++++------------------
 2 files changed, 36 insertions(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 00a5c0bcc2eb..275d00528805 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1245,9 +1245,10 @@ struct kvm_arch {
 	 * Memory cache used to allocate pte_list_desc structs while splitting
 	 * huge pages. In the worst case, to split one huge page we need 512
 	 * pte_list_desc structs to add each new lower level leaf sptep to the
-	 * memslot rmap.
+	 * memslot rmap plus 1 to extend the parent_ptes rmap of the new lower
+	 * level page table.
 	 */
-#define HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY 512
+#define HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY 513
 	__DEFINE_KVM_MMU_MEMORY_CACHE(huge_page_split_desc_cache,
 				      HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY);
 };
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 95b8e2ef562f..68785b422a08 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6208,6 +6208,7 @@ static struct kvm_mmu_page *kvm_mmu_get_sp_for_split(struct kvm *kvm,
 {
 	struct kvm_mmu_page *split_sp;
 	union kvm_mmu_page_role role;
+	bool created = false;
 	unsigned int access;
 	gfn_t gfn;
 
@@ -6220,25 +6221,21 @@ static struct kvm_mmu_page *kvm_mmu_get_sp_for_split(struct kvm *kvm,
 	 */
 	role = kvm_mmu_child_role(huge_sptep, true, access);
 	split_sp = kvm_mmu_find_direct_sp(kvm, gfn, role);
-
-	/*
-	 * Opt not to split if the lower-level SP already exists. This requires
-	 * more complex handling as the SP may be already partially filled in
-	 * and may need extra pte_list_desc structs to update parent_ptes.
-	 */
 	if (split_sp)
-		return NULL;
+		goto out;
 
+	created = true;
 	swap(split_sp, *spp);
 	init_shadow_page(kvm, split_sp, slot, gfn, role);
-	trace_kvm_mmu_get_page(split_sp, true);
 
+out:
+	trace_kvm_mmu_get_page(split_sp, created);
 	return split_sp;
 }
 
-static int kvm_mmu_split_huge_page(struct kvm *kvm,
-				   const struct kvm_memory_slot *slot,
-				   u64 *huge_sptep, struct kvm_mmu_page **spp)
+static void kvm_mmu_split_huge_page(struct kvm *kvm,
+				    const struct kvm_memory_slot *slot,
+				    u64 *huge_sptep, struct kvm_mmu_page **spp)
 
 {
 	struct kvm_mmu_memory_cache *cache;
@@ -6246,22 +6243,11 @@ static int kvm_mmu_split_huge_page(struct kvm *kvm,
 	u64 huge_spte, split_spte;
 	int split_level, index;
 	unsigned int access;
+	bool flush = false;
 	u64 *split_sptep;
 	gfn_t split_gfn;
 
 	split_sp = kvm_mmu_get_sp_for_split(kvm, slot, huge_sptep, spp);
-	if (!split_sp)
-		return -EOPNOTSUPP;
-
-	/*
-	 * We did not allocate an extra pte_list_desc struct to add huge_sptep
-	 * to split_sp->parent_ptes. An extra pte_list_desc struct should never
-	 * be necessary in practice though since split_sp is brand new.
-	 *
-	 * Note, this makes it safe to pass NULL to __link_shadow_page() below.
-	 */
-	if (WARN_ON_ONCE(split_sp->parent_ptes.val))
-		return -EINVAL;
 
 	huge_spte = READ_ONCE(*huge_sptep);
 
@@ -6273,7 +6259,20 @@ static int kvm_mmu_split_huge_page(struct kvm *kvm,
 		split_sptep = &split_sp->spt[index];
 		split_gfn = kvm_mmu_page_get_gfn(split_sp, index);
 
-		BUG_ON(is_shadow_present_pte(*split_sptep));
+		/*
+		 * split_sp may have populated page table entries if this huge
+		 * page is aliased in multiple shadow page table entries. We
+		 * know the existing SP will be mapping the same GFN->PFN
+		 * translation since this is a direct SP. However, the SPTE may
+		 * point to an even lower level page table that may only be
+		 * partially filled in (e.g. for NX huge pages). In other words,
+		 * we may be unmapping a portion of the huge page, which
+		 * requires a TLB flush.
+		 */
+		if (is_shadow_present_pte(*split_sptep)) {
+			flush |= !is_last_spte(*split_sptep, split_level);
+			continue;
+		}
 
 		split_spte = make_huge_page_split_spte(
 				huge_spte, split_level + 1, index, access);
@@ -6284,15 +6283,12 @@ static int kvm_mmu_split_huge_page(struct kvm *kvm,
 
 	/*
 	 * Replace the huge spte with a pointer to the populated lower level
-	 * page table. Since we are making this change without a TLB flush vCPUs
-	 * will see a mix of the split mappings and the original huge mapping,
-	 * depending on what's currently in their TLB. This is fine from a
-	 * correctness standpoint since the translation will be identical.
+	 * page table. If the lower-level page table indentically maps the huge
+	 * page, there's no need for a TLB flush. Otherwise, flush TLBs after
+	 * dropping the huge page and before installing the shadow page table.
 	 */
-	__drop_large_spte(kvm, huge_sptep, false);
-	__link_shadow_page(NULL, huge_sptep, split_sp);
-
-	return 0;
+	__drop_large_spte(kvm, huge_sptep, flush);
+	__link_shadow_page(cache, huge_sptep, split_sp);
 }
 
 static bool should_split_huge_page(u64 *huge_sptep)
@@ -6347,16 +6343,13 @@ static bool rmap_try_split_huge_pages(struct kvm *kvm,
 		if (dropped_lock)
 			goto restart;
 
-		r = kvm_mmu_split_huge_page(kvm, slot, huge_sptep, &sp);
-
-		trace_kvm_mmu_split_huge_page(gfn, spte, level, r);
-
 		/*
-		 * If splitting is successful we must restart the iterator
-		 * because huge_sptep has just been removed from it.
+		 * After splitting we must restart the iterator because
+		 * huge_sptep has just been removed from it.
 		 */
-		if (!r)
-			goto restart;
+		kvm_mmu_split_huge_page(kvm, slot, huge_sptep, &sp);
+		trace_kvm_mmu_split_huge_page(gfn, spte, level, 0);
+		goto restart;
 	}
 
 	if (sp)
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

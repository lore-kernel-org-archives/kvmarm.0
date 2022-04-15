Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD96C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 15 Apr 2022 21:59:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77A624A10E;
	Fri, 15 Apr 2022 17:59:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Vm32ne9Zl-OI; Fri, 15 Apr 2022 17:59:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6C0C4B128;
	Fri, 15 Apr 2022 17:59:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 618044B0E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tAq0k+p4Lqd8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2022 17:59:27 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 36DB64B089
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:23 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2eb58f605aeso75930527b3.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 14:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=+g21tjl52haZEGL9PeLa8ZsXfugpwy0IPvVVK6CWGsg=;
 b=ZLsICKC3SmkNR+5tKzOjUbnQi/MrOWshrvj8ba9gD9ErKmF7bM9Ls3/73nj7AN223f
 2SqgDq0mAv2Q+0NseF2Q6yJ9vAST2pHisfGt1aJ03ZR+yeXY4WCtFCLFnkoU0PMNx7bv
 GtmK0jCaxnoFBzIF482k+LXDT3QNYJ5NswQc3tSxLDzrxHjhk7kCcz/EML91XtB0TNBK
 Xm9rTMKrDR8cvHZo0rs4YCcBNImFSd/Zp6dYdWGcwa6fTHERGWIJByQqZFmWaHjjCdY8
 3CDcSDTVe1yeF5TkHlWZQLhTDhaOUlu2ycQ37ChtdjS0d0bGJEyFflrGc5HuZQxrxKqT
 /V6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=+g21tjl52haZEGL9PeLa8ZsXfugpwy0IPvVVK6CWGsg=;
 b=HNfkQpWTKauux4E+i8ekvoLT3XCaeM+yYyWHXhSIyqo5uzK8uM58mOezD+kn/HD+UZ
 7EfCux7QtlAsEMvaZ5MDtLZWt2FjNp9T5rhbXSFiyjdC0GLXs9B0/j/Q2Kt2HyCZFvuP
 hDIfHAoMNazIs9+2OOU/c45ZLHcrzdvu3/BBvR7ULKlPVnNOFIt80+23IiXR4tTTDURs
 iiJ0G8Dl7LzJGwtVQB5FuYsg6yEY2jYVHgm3jfEchCaQDOnJqXEwG1osaJXEALNIcooR
 mypTv1Z6ycHm6Eqmm83GbWbNk6/OBaOrEL/4cUcKqHvNJPO84cNdSuTizdDMD/6H0a0O
 OpRA==
X-Gm-Message-State: AOAM533ahReLa/KHKkUGZ8ceRp7zqBZ9eoJqzPcmbuszBSl+IKWIWqRB
 XiQV5txD96qZIHhiqtaUwxh3/HuvvAjOoiw2O+gXEQFDczAncXbh8I4BqopfihYJbE/WGJX9nwJ
 btOoKwLuc87i2DeO7JS4pB0FbFg/kbaXmzr8eVJdwaIJ5rZzcOIVGtr0FPMJ+hewOTztikw==
X-Google-Smtp-Source: ABdhPJxd3FM6U0CPN7En0pTvibRCFHGaVeXWp61fOLSmlPBx3PvTF9e7RZlcLR5fnOduP4TGiTN80GlSguU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a0d:e743:0:b0:2eb:3106:9b32 with
 SMTP id
 q64-20020a0de743000000b002eb31069b32mr940693ywe.512.1650059962733; Fri, 15
 Apr 2022 14:59:22 -0700 (PDT)
Date: Fri, 15 Apr 2022 21:58:59 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-16-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 15/17] KVM: arm64: Allow parallel calls to
 kvm_pgtable_stage2_map()
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

The map walker is now appraised of how to walk the tables in parallel
with another table walker. Take a parameter indicating whether or not a
walk is done in parallel so as to relax the atomicity/locking
requirements on ptes.

Defer actually using parallel walks to a later change.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h  | 4 +++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
 arch/arm64/kvm/hyp/pgtable.c          | 4 ++--
 arch/arm64/kvm/mmu.c                  | 6 +++---
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 52e55e00f0ca..9830eea19de4 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -328,6 +328,8 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
  * @prot:	Permissions and attributes for the mapping.
  * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
  *		page-table pages.
+ * @shared:	true if multiple software walkers could be traversing the tables
+ *		in parallel
  *
  * The offset of @addr within a page is ignored, @size is rounded-up to
  * the next page boundary and @phys is rounded-down to the previous page
@@ -349,7 +351,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
  */
 int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			   u64 phys, enum kvm_pgtable_prot prot,
-			   void *mc);
+			   void *mc, bool shared);
 
 /**
  * kvm_pgtable_stage2_set_owner() - Unmap and annotate pages in the IPA space to
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 42a5f35cd819..53b172036c2a 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -251,7 +251,7 @@ static inline int __host_stage2_idmap(u64 start, u64 end,
 				      enum kvm_pgtable_prot prot)
 {
 	return kvm_pgtable_stage2_map(&host_kvm.pgt, start, end - start, start,
-				      prot, &host_s2_pool);
+				      prot, &host_s2_pool, false);
 }
 
 /*
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index a9a48edba63b..20ff198ebef7 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1119,7 +1119,7 @@ static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_
 
 int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			   u64 phys, enum kvm_pgtable_prot prot,
-			   void *mc)
+			   void *mc, bool shared)
 {
 	int ret;
 	struct stage2_map_data map_data = {
@@ -1144,7 +1144,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	if (ret)
 		return ret;
 
-	ret = kvm_pgtable_walk(pgt, addr, size, &walker, false);
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker, shared);
 	dsb(ishst);
 	return ret;
 }
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6ecf37009c21..63cf18cdb978 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -832,7 +832,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 
 		write_lock(&kvm->mmu_lock);
 		ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
-					     &cache);
+					     &cache, false);
 		write_unlock(&kvm->mmu_lock);
 		if (ret)
 			break;
@@ -1326,7 +1326,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
-					     mmu_caches);
+					     mmu_caches, true);
 	}
 
 	/* Mark the page dirty only if the fault is handled successfully */
@@ -1526,7 +1526,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	 */
 	kvm_pgtable_stage2_map(kvm->arch.mmu.pgt, range->start << PAGE_SHIFT,
 			       PAGE_SIZE, __pfn_to_phys(pfn),
-			       KVM_PGTABLE_PROT_R, NULL);
+			       KVM_PGTABLE_PROT_R, NULL, false);
 
 	return false;
 }
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

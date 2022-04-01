Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA36CC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 18:21:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 670D84B296;
	Fri,  1 Apr 2022 14:21:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id df8F1q8mWdWp; Fri,  1 Apr 2022 14:20:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 452F74B2D7;
	Fri,  1 Apr 2022 14:20:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F599410DA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xlUZ00WK0pIk for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 13:56:17 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF1BD4B216
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:16 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 i5-20020a639d05000000b003822fae3e50so2011665pgd.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2022 10:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=nTmuYtTREbDuE8X5WKQrckgnKI3yoAyUOjS6IPz+d8s=;
 b=r1irV2cXU5balcgpJ+77g5pazDurBLKGlZ2Dfmc5U8VLb3YkAgu0DV8Hm8rTD/uVNR
 4BFbWqVJzVzfgcSg/Qy3n1yW1bItPLIGG6Y2QN/OffvUeg0i997msfBloThaBEeVaIdW
 ivSbp9ZOUCJQdZ7sfRmYuChNnZ/RoMCSqHoW+ZboctWTFgAJ6mMmwDVoWQQjekBtaC6s
 /TbZn/Gm9YkE2eUSDw5p4bluh48WV3voiXn/aHalocyfRAsJ1Rc9LArz6w0hkjdKMpj1
 smEHv0Tc0QDl3l0mZQTpGNMG4BoOnlIVQ1nSOcnOV8uHNA3V4tyFMQFIBqgqnIHvnqzG
 TU8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=nTmuYtTREbDuE8X5WKQrckgnKI3yoAyUOjS6IPz+d8s=;
 b=Xe/OSU2s0G2o8zDkw+HHIWY8f3V9V9EhF+1nYuQHKazpGu9bChi8GIwJPZMil74/fk
 2f8KMwY1IcSnHV3Unc1Kp/pHSKLe76vwrI7bNV4MClX22RQTHWrUlJEqf0dDkPAKGLth
 bM3EDpFygqKLl3jbNqfPjD78h3uJmziLIZQohQvfrYXCzS6Of9tD9LF6U00Cvehi2qeI
 z2etB/7aub1h+5KadkSzYkSedAWoR5l9Rh3FKFKsRBe0e6jhetbv02Si7x7z59ZK9tPs
 gjcLqw8e6U14Vf/mFOmHhj6LwwVw/koBZG+3lJfh4e2CBXxJ3S1d/uB1sbsiWlh8QJQ/
 0dGg==
X-Gm-Message-State: AOAM5312G58pK4PsNgsVUU4LhnVlHIodFwVxFStsXTo/9N8G2o+6zQBL
 e+ypCfA1WkJ1rPnbcKMnqM2kIf4j/Tn8SA==
X-Google-Smtp-Source: ABdhPJwn8ro+5iboEj4iBbUxK1MDSaRBAe0CkNK+ZysloOmbIZqhBQ1y1ArIceThcmiHYQpxZuwA5eCXoSY58Q==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:1acb:b0:4fa:de8e:da9d with SMTP
 id f11-20020a056a001acb00b004fade8eda9dmr12200024pfv.42.1648835776102; Fri,
 01 Apr 2022 10:56:16 -0700 (PDT)
Date: Fri,  1 Apr 2022 17:55:40 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-10-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 09/23] KVM: x86/mmu: Move huge page split sp allocation
 code to mmu.c
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

Move the code that allocates a new shadow page for splitting huge pages
into mmu.c. Currently this code is only used by the TDP MMU but it will
be reused in subsequent commits to also split huge pages mapped by the
shadow MMU. Move the GFP flags calculation down into the allocation code
so that it does not have to be duplicated when the shadow MMU needs to
start allocating SPs for splitting.

Preemptively split out the gfp flags calculation to a separate helpers
for use in a subsequent commit that adds support for eager page
splitting to the shadow MMU.

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 37 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/mmu_internal.h |  2 ++
 arch/x86/kvm/mmu/tdp_mmu.c      | 34 ++----------------------------
 3 files changed, 41 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 421fcbc97f9e..657c2a906c12 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1722,6 +1722,43 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
+static inline gfp_t gfp_flags_for_split(bool locked)
+{
+	/*
+	 * If under the MMU lock, use GFP_NOWAIT to avoid direct reclaim (which
+	 * is slow) and to avoid making any filesystem callbacks (which can end
+	 * up invoking KVM MMU notifiers, resulting in a deadlock).
+	 */
+	return (locked ? GFP_NOWAIT : GFP_KERNEL) | __GFP_ACCOUNT;
+}
+
+/*
+ * Allocate a new shadow page, potentially while holding the MMU lock.
+ *
+ * Huge page splitting always uses direct shadow pages since the huge page is
+ * being mapped directly with a lower level page table. Thus there's no need to
+ * allocate the gfns array.
+ */
+struct kvm_mmu_page *kvm_mmu_alloc_direct_sp_for_split(bool locked)
+{
+	gfp_t gfp = gfp_flags_for_split(locked) | __GFP_ZERO;
+	struct kvm_mmu_page *sp;
+
+	sp = kmem_cache_alloc(mmu_page_header_cache, gfp);
+	if (!sp)
+		return NULL;
+
+	sp->spt = (void *)__get_free_page(gfp);
+	if (!sp->spt) {
+		kmem_cache_free(mmu_page_header_cache, sp);
+		return NULL;
+	}
+
+	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+
+	return sp;
+}
+
 static void mark_unsync(u64 *spte);
 static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
 {
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1bff453f7cbe..a0648e7ddd33 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -171,4 +171,6 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+struct kvm_mmu_page *kvm_mmu_alloc_direct_sp_for_split(bool locked);
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 17354e55735f..34e581bcaaf6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1418,43 +1418,13 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 	return spte_set;
 }
 
-static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
-{
-	struct kvm_mmu_page *sp;
-
-	gfp |= __GFP_ZERO;
-
-	sp = kmem_cache_alloc(mmu_page_header_cache, gfp);
-	if (!sp)
-		return NULL;
-
-	sp->spt = (void *)__get_free_page(gfp);
-	if (!sp->spt) {
-		kmem_cache_free(mmu_page_header_cache, sp);
-		return NULL;
-	}
-
-	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
-
-	return sp;
-}
-
 static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 						       struct tdp_iter *iter,
 						       bool shared)
 {
 	struct kvm_mmu_page *sp;
 
-	/*
-	 * Since we are allocating while under the MMU lock we have to be
-	 * careful about GFP flags. Use GFP_NOWAIT to avoid blocking on direct
-	 * reclaim and to avoid making any filesystem callbacks (which can end
-	 * up invoking KVM MMU notifiers, resulting in a deadlock).
-	 *
-	 * If this allocation fails we drop the lock and retry with reclaim
-	 * allowed.
-	 */
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
+	sp = kvm_mmu_alloc_direct_sp_for_split(true);
 	if (sp)
 		return sp;
 
@@ -1466,7 +1436,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 
 	iter->yielded = true;
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
+	sp = kvm_mmu_alloc_direct_sp_for_split(false);
 
 	if (shared)
 		read_lock(&kvm->mmu_lock);
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC4D16C853
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 11:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712318309; cv=none; b=OJJCQH7W0H1sLsfz47tLTBvKju95ct2PWyn+JvthHJ2lMIRCmLLJIkYt41doljlz9CAyJZGJH+T03d3e4KiImuC/qUW0Lbhx+u8/4VmR0NbQbkvg3nnYqdCLpT75fvoIxzHUpgTMh9KIZlmfJFq2VRSstSrnMw+KSBT9JiMsmT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712318309; c=relaxed/simple;
	bh=hH3qcfIlDFNFXcnOAXz5nQZISUR02/h+wK8MXGjdmhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mpo1lzgIoG2GNZKU9o1s7Tc25uDCTdc9j8EjVtF1jbDNDXTLWNoYjvJXoTbsLw1RY59SPVOtoDHf6ye6CwGdxJVdkoenV7kQmzAI687sFkbUSzefRPsSRQhrYcqCw5tXvMUIj+JP/d1AWS0e5fQyYdVAXtQ8tEQv8rOf/iCyZOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AsJpHicl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AsJpHicl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712318306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=54r2v6x4hCqSU9lpxJJX8F9xMdFOFqhWRrFs4bS58g8=;
	b=AsJpHiclCmODkg+yAo7mRrahUfHz5OSCehZPuuWBf+G5z4aOImGHjd7SuuUJ/mQjMgNloT
	zKiF1aTM8FsC0uM/vsXpS3Eoqklrm43XY0MuMNVX84JHv4LZXpethDa/BGaKXUWg0LpVB0
	myhStDuOI6yKI/lJQ0uA1m3Tkz8x67Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-1T7hKq5gPw2fRM982K2a_w-1; Fri, 05 Apr 2024 07:58:22 -0400
X-MC-Unique: 1T7hKq5gPw2fRM982K2a_w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4A2888D0C8;
	Fri,  5 Apr 2024 11:58:20 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 13F6640C6CB3;
	Fri,  5 Apr 2024 11:58:20 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Nicholas Piggin <npiggin@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Sean Christopherson <seanjc@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: [PATCH 3/4] mmu_notifier: remove the .change_pte() callback
Date: Fri,  5 Apr 2024 07:58:14 -0400
Message-ID: <20240405115815.3226315-4-pbonzini@redhat.com>
In-Reply-To: <20240405115815.3226315-1-pbonzini@redhat.com>
References: <20240405115815.3226315-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

The scope of set_pte_at_notify() has reduced more and more through the
years.  Initially, it was meant for when the change to the PTE was
not bracketed by mmu_notifier_invalidate_range_{start,end}().  However,
that has not been so for over ten years.  During all this period
the only implementation of .change_pte() was KVM and it
had no actual functionality, because it was called after
mmu_notifier_invalidate_range_start() zapped the secondary PTE.

Now that this (nonfunctional) user of the .change_pte() callback is
gone, the whole callback can be removed.  For now, leave in place
set_pte_at_notify() even though it is just a synonym for set_pte_at().

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/mmu_notifier.h | 46 ++----------------------------------
 mm/mmu_notifier.c            | 17 -------------
 2 files changed, 2 insertions(+), 61 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index f349e08a9dfe..8c72bf651606 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -122,15 +122,6 @@ struct mmu_notifier_ops {
 			  struct mm_struct *mm,
 			  unsigned long address);
 
-	/*
-	 * change_pte is called in cases that pte mapping to page is changed:
-	 * for example, when ksm remaps pte to point to a new shared page.
-	 */
-	void (*change_pte)(struct mmu_notifier *subscription,
-			   struct mm_struct *mm,
-			   unsigned long address,
-			   pte_t pte);
-
 	/*
 	 * invalidate_range_start() and invalidate_range_end() must be
 	 * paired and are called only when the mmap_lock and/or the
@@ -392,8 +383,6 @@ extern int __mmu_notifier_clear_young(struct mm_struct *mm,
 				      unsigned long end);
 extern int __mmu_notifier_test_young(struct mm_struct *mm,
 				     unsigned long address);
-extern void __mmu_notifier_change_pte(struct mm_struct *mm,
-				      unsigned long address, pte_t pte);
 extern int __mmu_notifier_invalidate_range_start(struct mmu_notifier_range *r);
 extern void __mmu_notifier_invalidate_range_end(struct mmu_notifier_range *r);
 extern void __mmu_notifier_arch_invalidate_secondary_tlbs(struct mm_struct *mm,
@@ -439,13 +428,6 @@ static inline int mmu_notifier_test_young(struct mm_struct *mm,
 	return 0;
 }
 
-static inline void mmu_notifier_change_pte(struct mm_struct *mm,
-					   unsigned long address, pte_t pte)
-{
-	if (mm_has_notifiers(mm))
-		__mmu_notifier_change_pte(mm, address, pte);
-}
-
 static inline void
 mmu_notifier_invalidate_range_start(struct mmu_notifier_range *range)
 {
@@ -581,26 +563,6 @@ static inline void mmu_notifier_range_init_owner(
 	__young;							\
 })
 
-/*
- * set_pte_at_notify() sets the pte _after_ running the notifier.
- * This is safe to start by updating the secondary MMUs, because the primary MMU
- * pte invalidate must have already happened with a ptep_clear_flush() before
- * set_pte_at_notify() has been invoked.  Updating the secondary MMUs first is
- * required when we change both the protection of the mapping from read-only to
- * read-write and the pfn (like during copy on write page faults). Otherwise the
- * old page would remain mapped readonly in the secondary MMUs after the new
- * page is already writable by some CPU through the primary MMU.
- */
-#define set_pte_at_notify(__mm, __address, __ptep, __pte)		\
-({									\
-	struct mm_struct *___mm = __mm;					\
-	unsigned long ___address = __address;				\
-	pte_t ___pte = __pte;						\
-									\
-	mmu_notifier_change_pte(___mm, ___address, ___pte);		\
-	set_pte_at(___mm, ___address, __ptep, ___pte);			\
-})
-
 #else /* CONFIG_MMU_NOTIFIER */
 
 struct mmu_notifier_range {
@@ -650,11 +612,6 @@ static inline int mmu_notifier_test_young(struct mm_struct *mm,
 	return 0;
 }
 
-static inline void mmu_notifier_change_pte(struct mm_struct *mm,
-					   unsigned long address, pte_t pte)
-{
-}
-
 static inline void
 mmu_notifier_invalidate_range_start(struct mmu_notifier_range *range)
 {
@@ -693,7 +650,6 @@ static inline void mmu_notifier_subscriptions_destroy(struct mm_struct *mm)
 #define	ptep_clear_flush_notify ptep_clear_flush
 #define pmdp_huge_clear_flush_notify pmdp_huge_clear_flush
 #define pudp_huge_clear_flush_notify pudp_huge_clear_flush
-#define set_pte_at_notify set_pte_at
 
 static inline void mmu_notifier_synchronize(void)
 {
@@ -701,4 +657,6 @@ static inline void mmu_notifier_synchronize(void)
 
 #endif /* CONFIG_MMU_NOTIFIER */
 
+#define set_pte_at_notify set_pte_at
+
 #endif /* _LINUX_MMU_NOTIFIER_H */
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index ec3b068cbbe6..8982e6139d07 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -424,23 +424,6 @@ int __mmu_notifier_test_young(struct mm_struct *mm,
 	return young;
 }
 
-void __mmu_notifier_change_pte(struct mm_struct *mm, unsigned long address,
-			       pte_t pte)
-{
-	struct mmu_notifier *subscription;
-	int id;
-
-	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription,
-				 &mm->notifier_subscriptions->list, hlist,
-				 srcu_read_lock_held(&srcu)) {
-		if (subscription->ops->change_pte)
-			subscription->ops->change_pte(subscription, mm, address,
-						      pte);
-	}
-	srcu_read_unlock(&srcu, id);
-}
-
 static int mn_itree_invalidate(struct mmu_notifier_subscriptions *subscriptions,
 			       const struct mmu_notifier_range *range)
 {
-- 
2.43.0



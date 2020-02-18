Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C621C3404F
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 21:08:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 488AA2176D
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 21:08:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 488AA2176D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 008ED4AF33;
	Tue, 18 Feb 2020 16:08:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Yf3WQbq2cXjw; Tue, 18 Feb 2020 16:08:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 585F24AFD5;
	Tue, 18 Feb 2020 16:07:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27D9B4AF48
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 16:07:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DHxMUyKfb3gV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 16:07:55 -0500 (EST)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A8134AF6F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 16:07:50 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 18 Feb 2020 13:07:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,457,1574150400"; d="scan'208";a="253856472"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by orsmga002.jf.intel.com with ESMTP; 18 Feb 2020 13:07:47 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v6 22/22] KVM: x86/mmu: Consolidate open coded variants of
 memslot TLB flushes
Date: Tue, 18 Feb 2020 13:07:36 -0800
Message-Id: <20200218210736.16432-23-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218210736.16432-1-sean.j.christopherson@intel.com>
References: <20200218210736.16432-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
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

Replace open coded instances of kvm_arch_flush_remote_tlbs_memslot()'s
functionality with calls to the aforementioned function.  Update the
comment in kvm_arch_flush_remote_tlbs_memslot() to elaborate on how it
is used and why it asserts that slots_lock is held.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 34 +++++++++-------------------------
 1 file changed, 9 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8a6516ce2983..1eb8654cc9d0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5870,13 +5870,6 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 				      false);
 	spin_unlock(&kvm->mmu_lock);
 
-	/*
-	 * kvm_mmu_slot_remove_write_access() and kvm_vm_ioctl_get_dirty_log()
-	 * which do tlb flush out of mmu-lock should be serialized by
-	 * kvm->slots_lock otherwise tlb flush would be missed.
-	 */
-	lockdep_assert_held(&kvm->slots_lock);
-
 	/*
 	 * We can flush all the TLBs out of the mmu lock without TLB
 	 * corruption since we just change the spte from writable to
@@ -5889,8 +5882,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 	 * on PT_WRITABLE_MASK anymore.
 	 */
 	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
-			memslot->npages);
+		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
 static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
@@ -5946,8 +5938,11 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
 					struct kvm_memory_slot *memslot)
 {
 	/*
-	 * All the TLBs can be flushed out of mmu lock, see the comments in
-	 * kvm_mmu_slot_remove_write_access().
+	 * All current use cases for flushing the TLBs for a specific memslot
+	 * are related to dirty logging, and do the TLB flush out of mmu_lock.
+	 * The interaction between the various operations on memslot must be
+	 * serialized by slots_locks to ensure the TLB flush from one operation
+	 * is observed by any other operation on the same memslot.
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
 	kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
@@ -5963,8 +5958,6 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 	flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty, false);
 	spin_unlock(&kvm->mmu_lock);
 
-	lockdep_assert_held(&kvm->slots_lock);
-
 	/*
 	 * It's also safe to flush TLBs out of mmu lock here as currently this
 	 * function is only used for dirty logging, in which case flushing TLB
@@ -5972,8 +5965,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 	 * dirty_bitmap.
 	 */
 	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
-				memslot->npages);
+		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_slot_leaf_clear_dirty);
 
@@ -5987,12 +5979,8 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 					false);
 	spin_unlock(&kvm->mmu_lock);
 
-	/* see kvm_mmu_slot_remove_write_access */
-	lockdep_assert_held(&kvm->slots_lock);
-
 	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
-				memslot->npages);
+		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_slot_largepage_remove_write_access);
 
@@ -6005,12 +5993,8 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 	flush = slot_handle_all_level(kvm, memslot, __rmap_set_dirty, false);
 	spin_unlock(&kvm->mmu_lock);
 
-	lockdep_assert_held(&kvm->slots_lock);
-
-	/* see kvm_mmu_slot_leaf_clear_dirty */
 	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
-				memslot->npages);
+		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
 
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

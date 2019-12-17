Return-Path: <SRS0=Hq6c=2H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C0F1C2D0BF
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 20:41:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2BF0421582
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 20:41:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2BF0421582
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB7D34A5A3;
	Tue, 17 Dec 2019 15:41:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id renTb2-P2J6Q; Tue, 17 Dec 2019 15:41:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53D7F4AEEE;
	Tue, 17 Dec 2019 15:40:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64FCB4A94D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 15:40:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K-JOirpEzGyp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Dec 2019 15:40:46 -0500 (EST)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B0104A5A0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 15:40:45 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
 by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 17 Dec 2019 12:40:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,326,1571727600"; d="scan'208";a="389952620"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by orsmga005.jf.intel.com with ESMTP; 17 Dec 2019 12:40:43 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: James Hogan <jhogan@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH v4 15/19] KVM: Provide common implementation for generic dirty
 log functions
Date: Tue, 17 Dec 2019 12:40:37 -0800
Message-Id: <20191217204041.10815-16-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217204041.10815-1-sean.j.christopherson@intel.com>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: linux-arm-kernel@lists.infradead.org, Wanpeng Li <wanpengli@tencent.com>,
 =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Joerg Roedel <joro@8bytes.org>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

Move the implementations of KVM_GET_DIRTY_LOG and KVM_CLEAR_DIRTY_LOG
for CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT into common KVM code.
The arch specific implemenations are extremely similar, differing
only in whether the dirty log needs to be sync'd from hardware (x86)
and how the TLBs are flushed.  Add new arch hooks to handle sync
and TLB flush; the sync will also be used for non-generic dirty log
support in a future patch (s390).

The ulterior motive for providing a common implementation is to
eliminate the dependency between arch and common code with respect to
the memslot referenced by the dirty log, i.e. to make it obvious in the
code that the validity of the memslot is guaranteed, as a future patch
will rework memslot handling such that id_to_memslot() can return NULL.

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Tested-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/mips/kvm/mips.c      | 63 +++--------------------------
 arch/powerpc/kvm/book3s.c |  5 +++
 arch/powerpc/kvm/booke.c  |  5 +++
 arch/s390/kvm/kvm-s390.c  |  5 +--
 arch/x86/kvm/x86.c        | 61 ++--------------------------
 include/linux/kvm_host.h  | 21 +++++-----
 virt/kvm/arm/arm.c        | 48 ++--------------------
 virt/kvm/kvm_main.c       | 84 ++++++++++++++++++++++++++++++++-------
 8 files changed, 103 insertions(+), 189 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 108ed14cbcac..879b1e29f106 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -965,69 +965,16 @@ long kvm_arch_vcpu_ioctl(struct file *filp, unsigned int ioctl,
 	return r;
 }
 
-/**
- * kvm_vm_ioctl_get_dirty_log - get and clear the log of dirty pages in a slot
- * @kvm: kvm instance
- * @log: slot id and address to which we copy the log
- *
- * Steps 1-4 below provide general overview of dirty page logging. See
- * kvm_get_dirty_log_protect() function description for additional details.
- *
- * We call kvm_get_dirty_log_protect() to handle steps 1-3, upon return we
- * always flush the TLB (step 4) even if previous step failed  and the dirty
- * bitmap may be corrupt. Regardless of previous outcome the KVM logging API
- * does not preclude user space subsequent dirty log read. Flushing TLB ensures
- * writes will be marked dirty for next log read.
- *
- *   1. Take a snapshot of the bit and clear it if needed.
- *   2. Write protect the corresponding page.
- *   3. Copy the snapshot to the userspace.
- *   4. Flush TLB's if needed.
- */
-int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
+void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *memslot;
-	bool flush = false;
-	int r;
 
-	mutex_lock(&kvm->slots_lock);
-
-	r = kvm_get_dirty_log_protect(kvm, log, &flush);
-
-	if (flush) {
-		slots = kvm_memslots(kvm);
-		memslot = id_to_memslot(slots, log->slot);
-
-		/* Let implementation handle TLB/GVA invalidation */
-		kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);
-	}
-
-	mutex_unlock(&kvm->slots_lock);
-	return r;
 }
 
-int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm, struct kvm_clear_dirty_log *log)
+void kvm_arch_dirty_log_tlb_flush(struct kvm *kvm,
+				  struct kvm_memory_slot *memslot)
 {
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *memslot;
-	bool flush = false;
-	int r;
-
-	mutex_lock(&kvm->slots_lock);
-
-	r = kvm_clear_dirty_log_protect(kvm, log, &flush);
-
-	if (flush) {
-		slots = kvm_memslots(kvm);
-		memslot = id_to_memslot(slots, log->slot);
-
-		/* Let implementation handle TLB/GVA invalidation */
-		kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);
-	}
-
-	mutex_unlock(&kvm->slots_lock);
-	return r;
+	/* Let implementation handle TLB/GVA invalidation */
+	kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);
 }
 
 long kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index b1c9b4d11b2a..b117ca317c0d 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -804,6 +804,11 @@ int kvmppc_core_check_requests(struct kvm_vcpu *vcpu)
 	return vcpu->kvm->arch.kvm_ops->check_requests(vcpu);
 }
 
+void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
+{
+
+}
+
 int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 {
 	return kvm->arch.kvm_ops->get_dirty_log(kvm, log);
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index a22ff567724a..35a4ef89a1db 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -1796,6 +1796,11 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 	return r;
 }
 
+void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
+{
+
+}
+
 int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 {
 	return -ENOTSUPP;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index a5b917b72ca0..9e38973fd2cc 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -569,8 +569,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
-static void kvm_s390_sync_dirty_log(struct kvm *kvm,
-				    struct kvm_memory_slot *memslot)
+void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 	int i;
 	gfn_t cur_gfn, last_gfn;
@@ -630,7 +629,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	if (!memslot->dirty_bitmap)
 		goto out;
 
-	kvm_s390_sync_dirty_log(kvm, memslot);
+	kvm_arch_sync_dirty_log(kvm, memslot);
 	r = kvm_get_dirty_log(kvm, log, &is_dirty);
 	if (r)
 		goto out;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 50bef3195533..87fca25d5217 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4673,77 +4673,24 @@ static int kvm_vm_ioctl_reinject(struct kvm *kvm,
 	return 0;
 }
 
-/**
- * kvm_vm_ioctl_get_dirty_log - get and clear the log of dirty pages in a slot
- * @kvm: kvm instance
- * @log: slot id and address to which we copy the log
- *
- * Steps 1-4 below provide general overview of dirty page logging. See
- * kvm_get_dirty_log_protect() function description for additional details.
- *
- * We call kvm_get_dirty_log_protect() to handle steps 1-3, upon return we
- * always flush the TLB (step 4) even if previous step failed  and the dirty
- * bitmap may be corrupt. Regardless of previous outcome the KVM logging API
- * does not preclude user space subsequent dirty log read. Flushing TLB ensures
- * writes will be marked dirty for next log read.
- *
- *   1. Take a snapshot of the bit and clear it if needed.
- *   2. Write protect the corresponding page.
- *   3. Copy the snapshot to the userspace.
- *   4. Flush TLB's if needed.
- */
-int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
+void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
-	bool flush = false;
-	int r;
-
-	mutex_lock(&kvm->slots_lock);
-
 	/*
 	 * Flush potentially hardware-cached dirty pages to dirty_bitmap.
 	 */
 	if (kvm_x86_ops->flush_log_dirty)
 		kvm_x86_ops->flush_log_dirty(kvm);
-
-	r = kvm_get_dirty_log_protect(kvm, log, &flush);
-
-	/*
-	 * All the TLBs can be flushed out of mmu lock, see the comments in
-	 * kvm_mmu_slot_remove_write_access().
-	 */
-	lockdep_assert_held(&kvm->slots_lock);
-	if (flush)
-		kvm_flush_remote_tlbs(kvm);
-
-	mutex_unlock(&kvm->slots_lock);
-	return r;
 }
 
-int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm, struct kvm_clear_dirty_log *log)
+void kvm_arch_dirty_log_tlb_flush(struct kvm *kvm,
+				  struct kvm_memory_slot *memslot)
 {
-	bool flush = false;
-	int r;
-
-	mutex_lock(&kvm->slots_lock);
-
-	/*
-	 * Flush potentially hardware-cached dirty pages to dirty_bitmap.
-	 */
-	if (kvm_x86_ops->flush_log_dirty)
-		kvm_x86_ops->flush_log_dirty(kvm);
-
-	r = kvm_clear_dirty_log_protect(kvm, log, &flush);
-
 	/*
 	 * All the TLBs can be flushed out of mmu lock, see the comments in
 	 * kvm_mmu_slot_remove_write_access().
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
-	if (flush)
-		kvm_flush_remote_tlbs(kvm);
-
-	mutex_unlock(&kvm->slots_lock);
-	return r;
+	kvm_flush_remote_tlbs(kvm);
 }
 
 int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_event,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8343ac5ee7a8..eb54d196c0cb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -816,23 +816,20 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf);
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext);
 
-int kvm_get_dirty_log(struct kvm *kvm,
-			struct kvm_dirty_log *log, int *is_dirty);
-
-int kvm_get_dirty_log_protect(struct kvm *kvm,
-			      struct kvm_dirty_log *log, bool *flush);
-int kvm_clear_dirty_log_protect(struct kvm *kvm,
-				struct kvm_clear_dirty_log *log, bool *flush);
-
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 					struct kvm_memory_slot *slot,
 					gfn_t gfn_offset,
 					unsigned long mask);
+void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot);
 
-int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
-				struct kvm_dirty_log *log);
-int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
-				  struct kvm_clear_dirty_log *log);
+#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
+void kvm_arch_dirty_log_tlb_flush(struct kvm *kvm,
+				  struct kvm_memory_slot *memslot);
+#else /* !CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
+int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log);
+int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
+		      int *is_dirty);
+#endif
 
 int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 			bool line_status);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 12e0280291ce..19f78a6c18bc 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1240,55 +1240,15 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	return r;
 }
 
-/**
- * kvm_vm_ioctl_get_dirty_log - get and clear the log of dirty pages in a slot
- * @kvm: kvm instance
- * @log: slot id and address to which we copy the log
- *
- * Steps 1-4 below provide general overview of dirty page logging. See
- * kvm_get_dirty_log_protect() function description for additional details.
- *
- * We call kvm_get_dirty_log_protect() to handle steps 1-3, upon return we
- * always flush the TLB (step 4) even if previous step failed  and the dirty
- * bitmap may be corrupt. Regardless of previous outcome the KVM logging API
- * does not preclude user space subsequent dirty log read. Flushing TLB ensures
- * writes will be marked dirty for next log read.
- *
- *   1. Take a snapshot of the bit and clear it if needed.
- *   2. Write protect the corresponding page.
- *   3. Copy the snapshot to the userspace.
- *   4. Flush TLB's if needed.
- */
-int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
+void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
-	bool flush = false;
-	int r;
 
-	mutex_lock(&kvm->slots_lock);
-
-	r = kvm_get_dirty_log_protect(kvm, log, &flush);
-
-	if (flush)
-		kvm_flush_remote_tlbs(kvm);
-
-	mutex_unlock(&kvm->slots_lock);
-	return r;
 }
 
-int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm, struct kvm_clear_dirty_log *log)
+void kvm_arch_dirty_log_tlb_flush(struct kvm *kvm,
+				  struct kvm_memory_slot *memslot)
 {
-	bool flush = false;
-	int r;
-
-	mutex_lock(&kvm->slots_lock);
-
-	r = kvm_clear_dirty_log_protect(kvm, log, &flush);
-
-	if (flush)
-		kvm_flush_remote_tlbs(kvm);
-
-	mutex_unlock(&kvm->slots_lock);
-	return r;
+	kvm_flush_remote_tlbs(kvm);
 }
 
 static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b3e732078ab2..4a4b5339f229 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -859,7 +859,7 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
 
 /*
  * Allocation size is twice as large as the actual dirty bitmap size.
- * See x86's kvm_vm_ioctl_get_dirty_log() why this is needed.
+ * See kvm_vm_ioctl_get_dirty_log() why this is needed.
  */
 static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
 {
@@ -1201,6 +1201,7 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 	return kvm_set_memory_region(kvm, mem);
 }
 
+#ifndef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
 int kvm_get_dirty_log(struct kvm *kvm,
 			struct kvm_dirty_log *log, int *is_dirty)
 {
@@ -1234,13 +1235,12 @@ int kvm_get_dirty_log(struct kvm *kvm,
 }
 EXPORT_SYMBOL_GPL(kvm_get_dirty_log);
 
-#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
+#else /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 /**
  * kvm_get_dirty_log_protect - get a snapshot of dirty pages
  *	and reenable dirty page tracking for the corresponding pages.
  * @kvm:	pointer to kvm instance
  * @log:	slot id and address to which we copy the log
- * @flush:	true if TLB flush is needed by caller
  *
  * We need to keep it in mind that VCPU threads can write to the bitmap
  * concurrently. So, to avoid losing track of dirty pages we keep the
@@ -1257,8 +1257,7 @@ EXPORT_SYMBOL_GPL(kvm_get_dirty_log);
  * exiting to userspace will be logged for the next call.
  *
  */
-int kvm_get_dirty_log_protect(struct kvm *kvm,
-			struct kvm_dirty_log *log, bool *flush)
+static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 {
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
@@ -1266,6 +1265,7 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
 	unsigned long n;
 	unsigned long *dirty_bitmap;
 	unsigned long *dirty_bitmap_buffer;
+	bool flush;
 
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
@@ -1279,8 +1279,10 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
 	if (!dirty_bitmap)
 		return -ENOENT;
 
+	kvm_arch_sync_dirty_log(kvm, memslot);
+
 	n = kvm_dirty_bitmap_bytes(memslot);
-	*flush = false;
+	flush = false;
 	if (kvm->manual_dirty_log_protect) {
 		/*
 		 * Unlike kvm_get_dirty_log, we always return false in *flush,
@@ -1303,7 +1305,7 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
 			if (!dirty_bitmap[i])
 				continue;
 
-			*flush = true;
+			flush = true;
 			mask = xchg(&dirty_bitmap[i], 0);
 			dirty_bitmap_buffer[i] = mask;
 
@@ -1314,21 +1316,55 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
 		spin_unlock(&kvm->mmu_lock);
 	}
 
+	if (flush)
+		kvm_arch_dirty_log_tlb_flush(kvm, memslot);
+
 	if (copy_to_user(log->dirty_bitmap, dirty_bitmap_buffer, n))
 		return -EFAULT;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_get_dirty_log_protect);
+
+
+/**
+ * kvm_vm_ioctl_get_dirty_log - get and clear the log of dirty pages in a slot
+ * @kvm: kvm instance
+ * @log: slot id and address to which we copy the log
+ *
+ * Steps 1-4 below provide general overview of dirty page logging. See
+ * kvm_get_dirty_log_protect() function description for additional details.
+ *
+ * We call kvm_get_dirty_log_protect() to handle steps 1-3, upon return we
+ * always flush the TLB (step 4) even if previous step failed  and the dirty
+ * bitmap may be corrupt. Regardless of previous outcome the KVM logging API
+ * does not preclude user space subsequent dirty log read. Flushing TLB ensures
+ * writes will be marked dirty for next log read.
+ *
+ *   1. Take a snapshot of the bit and clear it if needed.
+ *   2. Write protect the corresponding page.
+ *   3. Copy the snapshot to the userspace.
+ *   4. Flush TLB's if needed.
+ */
+static int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
+				      struct kvm_dirty_log *log)
+{
+	int r;
+
+	mutex_lock(&kvm->slots_lock);
+
+	r = kvm_get_dirty_log_protect(kvm, log);
+
+	mutex_unlock(&kvm->slots_lock);
+	return r;
+}
 
 /**
  * kvm_clear_dirty_log_protect - clear dirty bits in the bitmap
  *	and reenable dirty page tracking for the corresponding pages.
  * @kvm:	pointer to kvm instance
  * @log:	slot id and address from which to fetch the bitmap of dirty pages
- * @flush:	true if TLB flush is needed by caller
  */
-int kvm_clear_dirty_log_protect(struct kvm *kvm,
-				struct kvm_clear_dirty_log *log, bool *flush)
+static int kvm_clear_dirty_log_protect(struct kvm *kvm,
+				       struct kvm_clear_dirty_log *log)
 {
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
@@ -1337,6 +1373,7 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	unsigned long i, n;
 	unsigned long *dirty_bitmap;
 	unsigned long *dirty_bitmap_buffer;
+	bool flush;
 
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
@@ -1360,7 +1397,9 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	    (log->num_pages < memslot->npages - log->first_page && (log->num_pages & 63)))
 	    return -EINVAL;
 
-	*flush = false;
+	kvm_arch_sync_dirty_log(kvm, memslot);
+
+	flush = false;
 	dirty_bitmap_buffer = kvm_second_dirty_bitmap(memslot);
 	if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
 		return -EFAULT;
@@ -1383,17 +1422,32 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
 		 * a problem if userspace sets them in log->dirty_bitmap.
 		*/
 		if (mask) {
-			*flush = true;
+			flush = true;
 			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
 								offset, mask);
 		}
 	}
 	spin_unlock(&kvm->mmu_lock);
 
+	if (flush)
+		kvm_arch_dirty_log_tlb_flush(kvm, memslot);
+
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_clear_dirty_log_protect);
-#endif
+
+static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
+					struct kvm_clear_dirty_log *log)
+{
+	int r;
+
+	mutex_lock(&kvm->slots_lock);
+
+	r = kvm_clear_dirty_log_protect(kvm, log);
+
+	mutex_unlock(&kvm->slots_lock);
+	return r;
+}
+#endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 
 bool kvm_largepages_enabled(void)
 {
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

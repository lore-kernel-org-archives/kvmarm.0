From: Andrew Jones <drjones@redhat.com>
Subject: [RFC PATCH 5/6] KVM: ARM: implement kvm_*_incoherent_memory_regions
Date: Fri,  6 Mar 2015 13:52:32 -0500
Message-ID: <1425667953-3566-6-git-send-email-drjones@redhat.com>
References: <1425667780-3449-1-git-send-email-drjones@redhat.com>
 <1425667953-3566-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8FDC47FC9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:46:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mh4P6VRQuElf for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Mar 2015 13:46:39 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DAEB247FEB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:46:38 -0500 (EST)
In-Reply-To: <1425667953-3566-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org
Cc: pbonzini@redhat.com, lersek@redhat.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Add the kvm_*_incoherent_memory_regions calls to arm's
kvm_arch_vcpu_ioctl_run and implement the corresponding
arch flush/invalidate functions.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/include/uapi/asm/kvm.h   |  1 +
 arch/arm/kvm/arm.c                |  4 +++
 arch/arm/kvm/mmu.c                | 54 +++++++++++++++++++++++++++++++++++++++
 arch/arm64/include/uapi/asm/kvm.h |  1 +
 4 files changed, 60 insertions(+)

diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 09ee408c1a676..cb0898a995c4f 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -26,6 +26,7 @@
 #define __KVM_HAVE_GUEST_DEBUG
 #define __KVM_HAVE_IRQ_LINE
 #define __KVM_HAVE_READONLY_MEM
+#define __KVM_HAVE_INCOHERENT_MEM
 
 #define KVM_REG_SIZE(id)						\
 	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index c9e6ef1f7403a..789c03c84e7c0 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -486,6 +486,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			return ret;
 	}
 
+	kvm_flush_incoherent_memory_regions(vcpu->kvm);
+
 	if (vcpu->sigset_active)
 		sigprocmask(SIG_SETMASK, &vcpu->sigset, &sigsaved);
 
@@ -556,6 +558,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		ret = handle_exit(vcpu, run, ret);
 	}
 
+	kvm_invalidate_incoherent_memory_regions(vcpu->kvm);
+
 	if (vcpu->sigset_active)
 		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
 	return ret;
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 2f3a6581b9200..2f45db9cd436a 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1161,6 +1161,24 @@ static void coherent_cache_guest_page(struct kvm_vcpu *vcpu, pfn_t pfn,
 	__coherent_cache_guest_page(pfn, size, need_flush, false);
 }
 
+static void coherent_cache_memslot(struct kvm_memory_slot *slot, bool flush)
+{
+	gfn_t gfn, end = slot->base_gfn + slot->npages;
+	pfn_t pfn;
+
+	for (gfn = slot->base_gfn; gfn < end; ++gfn) {
+		pfn = gfn_to_pfn_memslot(slot, gfn);
+		if (is_error_pfn(pfn)) {
+			pr_err("%s: Bad pfn: gfn=%llx, pfn=%llx, "
+				"userspace_addr=%lx\n", __func__,
+				gfn, pfn, slot->userspace_addr);
+			continue;
+		}
+		__coherent_cache_guest_page(pfn, PAGE_SIZE, flush, !flush);
+		kvm_release_pfn_clean(pfn);
+	}
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  unsigned long fault_status)
@@ -1802,6 +1820,42 @@ int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return 0;
 }
 
+void kvm_arch_flush_incoherent(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	if (slot->flags & KVM_MEM_READONLY) {
+		/*
+		 * Readonly memory shouldn't be changing, and we do a
+		 * clean+invalidate for KVM_MEM_INCOHERENT memory when
+		 * faulting it in. So, there's nothing to do now.
+		 */
+		return;
+	}
+
+	/*
+	 * Ideally, we would further filter out all pages not touched by
+	 * userspace on the last exit. No way to know those though, unless
+	 * we force userspace to fault on all pages in the incoherent
+	 * memory regions, but even then, I don't see any sane way for
+	 * do_wp_page to handle the faults without modification. So, sigh...
+	 */
+
+	coherent_cache_memslot(slot, true);
+}
+
+void kvm_arch_invalidate_incoherent(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	if (slot->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+		/*
+		 * We fault each write when logging is enabled, and do a
+		 * clean+invalidate on KVM_MEM_INCOHERENT memory while
+		 * handling the fault. So, there's nothing to do now.
+		 */
+		return;
+	}
+
+	coherent_cache_memslot(slot, false);
+}
+
 void kvm_arch_memslots_updated(struct kvm *kvm)
 {
 }
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 8e38878c87c61..29ddf77958c2a 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -38,6 +38,7 @@
 #define __KVM_HAVE_GUEST_DEBUG
 #define __KVM_HAVE_IRQ_LINE
 #define __KVM_HAVE_READONLY_MEM
+#define __KVM_HAVE_INCOHERENT_MEM
 
 #define KVM_REG_SIZE(id)						\
 	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
-- 
1.8.3.1

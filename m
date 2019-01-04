From: lantianyu1986@gmail.com
Subject: [PATCH 8/11] KVM: Make kvm_arch_mmu_enable_log_dirty_pt_masked()
 return value
Date: Fri,  4 Jan 2019 16:54:02 +0800
Message-ID: <20190104085405.40356-9-Tianyu.Lan@microsoft.com>
References: <20190104085405.40356-1-Tianyu.Lan@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4D044A3AE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jan 2019 03:55:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8fTnVBQIoRwd for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Jan 2019 03:55:20 -0500 (EST)
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com
 [209.85.214.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA44C4A382
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jan 2019 03:55:20 -0500 (EST)
Received: by mail-pl1-f194.google.com with SMTP id u6so17153462plm.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Jan 2019 00:55:20 -0800 (PST)
In-Reply-To: <20190104085405.40356-1-Tianyu.Lan@microsoft.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, paulus@ozlabs.org, hpa@zytor.com, kys@microsoft.com, kvmarm@lists.cs.columbia.edu, mpe@ellerman.id.au, x86@kernel.org, linux@armlinux.org.uk, michael.h.kelley@microsoft.com, mingo@redhat.com, benh@kernel.crashing.org, jhogan@kernel.org, linux-mips@vger.kernel.org, Lan Tianyu <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, kvm-ppc@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, ralf@linux-mips.org, paul.burton@mips.com, pbonzini@redhat.com, vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Lan Tianyu <Tianyu.Lan@microsoft.com>

This patch is to make kvm_arch_mmu_enable_log_dirty_pt_masked() return value
and caller can use it to determine whether tlb flush is necessary.
kvm_get_dirty_log_protect() and kvm_clear_dirty_log_protect() use the return
value of kvm_arch_mmu_enable_log_dirty_pt_masked() to populate flush
parameter.

Signed-off-by: Lan Tianyu <Tianyu.Lan@microsoft.com>
---
 arch/mips/kvm/mmu.c      |  5 ++++-
 arch/x86/kvm/mmu.c       |  6 +++++-
 include/linux/kvm_host.h |  2 +-
 virt/kvm/arm/mmu.c       |  5 ++++-
 virt/kvm/kvm_main.c      | 10 ++++------
 5 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 97e538a8c1be..f36ccb2d43ec 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -437,8 +437,10 @@ int kvm_mips_mkclean_gpa_pt(struct kvm *kvm, gfn_t start_gfn, gfn_t end_gfn)
  *
  * Walks bits set in mask write protects the associated pte's. Caller must
  * acquire @kvm->mmu_lock.
+ *
+ * Returns: Whether caller needs to flush tlb.
  */
-void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
+bool kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
 		gfn_t gfn_offset, unsigned long mask)
 {
@@ -447,6 +449,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	gfn_t end = base_gfn + __fls(mask);
 
 	kvm_mips_mkclean_gpa_pt(kvm, start, end);
+	return true;
 }
 
 /*
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 6d4f7dfeaa57..9d8ee6ea02db 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1676,8 +1676,10 @@ EXPORT_SYMBOL_GPL(kvm_mmu_clear_dirty_pt_masked);
  *
  * Used when we do not need to care about huge page mappings: e.g. during dirty
  * logging we do not have any such mappings.
+ *
+ * Return value means whether caller needs to flush tlb.
  */
-void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
+bool kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 				struct kvm_memory_slot *slot,
 				gfn_t gfn_offset, unsigned long mask)
 {
@@ -1686,6 +1688,8 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 				mask);
 	else
 		kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
+
+	return true;
 }
 
 /**
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c38cc5eb7e73..e86b8c38342b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -759,7 +759,7 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
 int kvm_clear_dirty_log_protect(struct kvm *kvm,
 				struct kvm_clear_dirty_log *log, bool *flush);
 
-void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
+bool kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 					struct kvm_memory_slot *slot,
 					gfn_t gfn_offset,
 					unsigned long mask);
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 3053bf2584f8..232007ff3208 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1564,12 +1564,15 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
  *
  * It calls kvm_mmu_write_protect_pt_masked to write protect selected pages to
  * enable dirty logging for them.
+ *
+ * Return value means whether caller needs to flush tlb.
  */
-void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
+bool kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
 		gfn_t gfn_offset, unsigned long mask)
 {
 	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
+	return true;
 }
 
 static void clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e75dbb15fd09..bcbe059d98be 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1202,13 +1202,12 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
 			if (!dirty_bitmap[i])
 				continue;
 
-			*flush = true;
 			mask = xchg(&dirty_bitmap[i], 0);
 			dirty_bitmap_buffer[i] = mask;
 
 			offset = i * BITS_PER_LONG;
-			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
-								offset, mask);
+			*flush = kvm_arch_mmu_enable_log_dirty_pt_masked(kvm,
+							memslot, offset, mask);
 		}
 		spin_unlock(&kvm->mmu_lock);
 	}
@@ -1275,9 +1274,8 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
 		 * a problem if userspace sets them in log->dirty_bitmap.
 		*/
 		if (mask) {
-			*flush = true;
-			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
-								offset, mask);
+			*flush = kvm_arch_mmu_enable_log_dirty_pt_masked(kvm,
+					memslot, offset, mask);
 		}
 	}
 	spin_unlock(&kvm->mmu_lock);
-- 
2.14.4

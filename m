From: lantianyu1986@gmail.com
Subject: [PATCH V3 7/10] KVM: Use tlb range flush in the
 kvm_vm_ioctl_get/clear_dirty_log()
Date: Fri, 22 Feb 2019 23:06:34 +0800
Message-ID: <20190222150637.2337-8-Tianyu.Lan@microsoft.com>
References: <20190222150637.2337-1-Tianyu.Lan@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75BA14A3C1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 10:07:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eSzBcyxJogl2 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 10:07:51 -0500 (EST)
Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com
 [209.85.215.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 283644A32E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 10:07:51 -0500 (EST)
Received: by mail-pg1-f195.google.com with SMTP id 196so1233387pgf.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 07:07:51 -0800 (PST)
In-Reply-To: <20190222150637.2337-1-Tianyu.Lan@microsoft.com>
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

This patch is to use tlb range flush to flush memslot's in the
kvm_vm_ioctl_get/clear_dirty_log() instead of flushing tlbs
of entire ept page table when range flush is available.

Signed-off-by: Lan Tianyu <Tianyu.Lan@microsoft.com>
---
 arch/x86/kvm/mmu.c |  8 +-------
 arch/x86/kvm/mmu.h |  7 +++++++
 arch/x86/kvm/x86.c | 16 ++++++++++++----
 3 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 60b1771e400e..e9a727aad603 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -266,12 +266,6 @@ static void mmu_spte_set(u64 *sptep, u64 spte);
 static union kvm_mmu_page_role
 kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu);
 
-
-static inline bool kvm_available_flush_tlb_with_range(void)
-{
-	return kvm_x86_ops->tlb_remote_flush_with_range;
-}
-
 static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
 		struct kvm_tlb_range *range)
 {
@@ -284,7 +278,7 @@ static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
 		kvm_flush_remote_tlbs(kvm);
 }
 
-static void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
+void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 		u64 start_gfn, u64 pages)
 {
 	struct kvm_tlb_range range;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index bbdc60f2fae8..5e0d9418b912 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -63,6 +63,13 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 				u64 fault_address, char *insn, int insn_len);
+void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
+				u64 start_gfn, u64 pages);
+
+static inline bool kvm_available_flush_tlb_with_range(void)
+{
+	return kvm_x86_ops->tlb_remote_flush_with_range;
+}
 
 static inline unsigned int kvm_mmu_available_pages(struct kvm *kvm)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 40d8272bee96..35738a7256f4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4448,9 +4448,13 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 	 * kvm_mmu_slot_remove_write_access().
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
-	if (flush)
-		kvm_flush_remote_tlbs(kvm);
+	if (flush) {
+		struct kvm_memory_slot *memslot = kvm_get_memslot(kvm,
+				log->slot);
 
+		kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
+				memslot->npages);
+	}
 	mutex_unlock(&kvm->slots_lock);
 	return r;
 }
@@ -4475,9 +4479,13 @@ int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm, struct kvm_clear_dirty_log *lo
 	 * kvm_mmu_slot_remove_write_access().
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
-	if (flush)
-		kvm_flush_remote_tlbs(kvm);
+	if (flush) {
+		struct kvm_memory_slot *memslot = kvm_get_memslot(kvm,
+				log->slot);
 
+		kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
+				memslot->npages);
+	}
 	mutex_unlock(&kvm->slots_lock);
 	return r;
 }
-- 
2.14.4

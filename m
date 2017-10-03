From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 10/31] KVM: arm/arm64: Unmap/flush shadow stage 2 page
 tables
Date: Mon,  2 Oct 2017 22:10:52 -0500
Message-ID: <1507000273-3735-8-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B11249D13
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HA7tJaKiKpBL for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:31 -0400 (EDT)
Received: from mail-it0-f53.google.com (mail-it0-f53.google.com
 [209.85.214.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 69F2D49D17
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:29 -0400 (EDT)
Received: by mail-it0-f53.google.com with SMTP id 85so9735406ith.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:11:49 -0700 (PDT)
In-Reply-To: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Unmap/flush shadow stage 2 page tables for the nested VMs as well as the
stage 2 page table for the guest hypervisor.

Note: A bunch of the code in mmu.c relating to MMU notifiers is
currently dealt with in an extremely abrupt way, for example by clearing
out an entire shadow stage-2 table. This will be handled in a more
efficient way using the reverse mapping feature in a later version of
the patch series.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---

Notes:
    v1-->v2:
    - Removed an unnecessary iteration for each vcpu in kvm_nested_s2_all_vcpus_*()
      functions and remove all_vcpus in the function names; a list of nested mmu
      is per VM, not per vcpu.
    - Renamed kvm_nested_s2_unmap() to kvm_nested_s2_clear()
    - Renamed kvm_nested_s2_teardown() to kvm_nested_s2_free()
    - Removed the unused kvm_nested_s2_init() function.

 arch/arm/include/asm/kvm_mmu.h   |  6 ++++++
 arch/arm64/include/asm/kvm_mmu.h |  5 +++++
 arch/arm64/kvm/mmu-nested.c      | 40 ++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/arm.c               |  6 +++++-
 virt/kvm/arm/mmu.c               | 17 +++++++++++++++++
 5 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 86fdc70..d3eafc5 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -221,6 +221,12 @@ static inline unsigned int kvm_get_vmid_bits(void)
 	return 8;
 }
 
+static inline void kvm_nested_s2_unmap(struct kvm_vcpu *vcpu) { }
+static inline void kvm_nested_s2_free(struct kvm *kvm) { }
+static inline void kvm_nested_s2_wp(struct kvm *kvm) { }
+static inline void kvm_nested_s2_clear(struct kvm *kvm) { }
+static inline void kvm_nested_s2_flush(struct kvm *kvm) { }
+
 static inline u64 kvm_get_vttbr(struct kvm_s2_vmid *vmid,
 				struct kvm_s2_mmu *mmu)
 {
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 452912f..7fc7a83 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -325,6 +325,11 @@ static inline unsigned int kvm_get_vmid_bits(void)
 struct kvm_nested_s2_mmu *get_nested_mmu(struct kvm_vcpu *vcpu, u64 vttbr);
 struct kvm_s2_mmu *vcpu_get_active_s2_mmu(struct kvm_vcpu *vcpu);
 void update_nested_s2_mmu(struct kvm_vcpu *vcpu);
+void kvm_nested_s2_unmap(struct kvm_vcpu *vcpu);
+void kvm_nested_s2_free(struct kvm *kvm);
+void kvm_nested_s2_wp(struct kvm *kvm);
+void kvm_nested_s2_clear(struct kvm *kvm);
+void kvm_nested_s2_flush(struct kvm *kvm);
 
 static inline u64 kvm_get_vttbr(struct kvm_s2_vmid *vmid,
 				struct kvm_s2_mmu *mmu)
diff --git a/arch/arm64/kvm/mmu-nested.c b/arch/arm64/kvm/mmu-nested.c
index c436daf..3ee20f2 100644
--- a/arch/arm64/kvm/mmu-nested.c
+++ b/arch/arm64/kvm/mmu-nested.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (C) 2017 - Columbia University and Linaro Ltd.
  * Author: Jintack Lim <jintack.lim@linaro.org>
+ * Author: Christoffer Dall <cdall@cs.columbia.edu>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -21,6 +22,45 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 
+/* expects kvm->mmu_lock to be held */
+void kvm_nested_s2_wp(struct kvm *kvm)
+{
+	struct kvm_nested_s2_mmu *nested_mmu;
+	struct list_head *nested_mmu_list = &kvm->arch.nested_mmu_list;
+
+	list_for_each_entry_rcu(nested_mmu, nested_mmu_list, list)
+		kvm_stage2_wp_range(kvm, &nested_mmu->mmu, 0, KVM_PHYS_SIZE);
+}
+
+/* expects kvm->mmu_lock to be held */
+void kvm_nested_s2_clear(struct kvm *kvm)
+{
+	struct kvm_nested_s2_mmu *nested_mmu;
+	struct list_head *nested_mmu_list = &kvm->arch.nested_mmu_list;
+
+	list_for_each_entry_rcu(nested_mmu, nested_mmu_list, list)
+		kvm_unmap_stage2_range(kvm, &nested_mmu->mmu, 0, KVM_PHYS_SIZE);
+}
+
+/* expects kvm->mmu_lock to be held */
+void kvm_nested_s2_flush(struct kvm *kvm)
+{
+	struct kvm_nested_s2_mmu *nested_mmu;
+	struct list_head *nested_mmu_list = &kvm->arch.nested_mmu_list;
+
+	list_for_each_entry_rcu(nested_mmu, nested_mmu_list, list)
+		kvm_stage2_flush_range(&nested_mmu->mmu, 0, KVM_PHYS_SIZE);
+}
+
+void kvm_nested_s2_free(struct kvm *kvm)
+{
+	struct kvm_nested_s2_mmu *nested_mmu;
+	struct list_head *nested_mmu_list = &kvm->arch.nested_mmu_list;
+
+	list_for_each_entry_rcu(nested_mmu, nested_mmu_list, list)
+		__kvm_free_stage2_pgd(kvm, &nested_mmu->mmu);
+}
+
 static struct kvm_nested_s2_mmu *lookup_nested_mmu(struct kvm_vcpu *vcpu,
 						   u64 vttbr)
 {
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 4548d77..08706f8 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -187,6 +187,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	free_percpu(kvm->arch.last_vcpu_ran);
 	kvm->arch.last_vcpu_ran = NULL;
 
+	kvm_nested_s2_free(kvm);
+
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		if (kvm->vcpus[i]) {
 			kvm_arch_vcpu_free(kvm->vcpus[i]);
@@ -926,8 +928,10 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	 * Ensure a rebooted VM will fault in RAM pages and detect if the
 	 * guest MMU is turned off and flush the caches as needed.
 	 */
-	if (vcpu->arch.has_run_once)
+	if (vcpu->arch.has_run_once) {
 		stage2_unmap_vm(vcpu->kvm);
+		kvm_nested_s2_clear(vcpu->kvm);
+	}
 
 	vcpu_reset_hcr(vcpu);
 
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index ca10799..3143f81 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -434,6 +434,8 @@ static void stage2_flush_vm(struct kvm *kvm)
 	kvm_for_each_memslot(memslot, slots)
 		stage2_flush_memslot(&kvm->arch.mmu, memslot);
 
+	kvm_nested_s2_flush(kvm);
+
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
@@ -1268,6 +1270,7 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 
 	spin_lock(&kvm->mmu_lock);
 	kvm_stage2_wp_range(kvm, &kvm->arch.mmu, start, end);
+	kvm_nested_s2_wp(kvm);
 	spin_unlock(&kvm->mmu_lock);
 	kvm_flush_remote_tlbs(kvm);
 }
@@ -1306,6 +1309,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		gfn_t gfn_offset, unsigned long mask)
 {
 	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
+	kvm_nested_s2_wp(kvm);
 }
 
 static void coherent_cache_guest_page(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
@@ -1643,6 +1647,7 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 {
 	kvm_unmap_stage2_range(kvm, &kvm->arch.mmu, gpa, size);
+	kvm_nested_s2_clear(kvm);
 	return 0;
 }
 
@@ -1682,6 +1687,7 @@ static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data
 	 * through this calling path.
 	 */
 	stage2_set_pte(&kvm->arch.mmu, NULL, gpa, pte, 0);
+	kvm_nested_s2_clear(kvm);
 	return 0;
 }
 
@@ -1716,6 +1722,11 @@ static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 	if (pte_none(*pte))
 		return 0;
 
+	/*
+	 * TODO: Handle nested_mmu structures here using the reverse mapping in
+	 * a later version of patch series.
+	 */
+
 	return stage2_ptep_test_and_clear_young(pte);
 }
 
@@ -1736,6 +1747,11 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *
 	if (!pte_none(*pte))		/* Just a page... */
 		return pte_young(*pte);
 
+	/*
+	 * TODO: Handle nested_mmu structures here using the reverse mapping in
+	 * a later version of patch series.
+	 */
+
 	return 0;
 }
 
@@ -1992,6 +2008,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	kvm_unmap_stage2_range(kvm, &kvm->arch.mmu, gpa, size);
+	kvm_nested_s2_clear(kvm);
 	spin_unlock(&kvm->mmu_lock);
 }
 
-- 
1.9.1

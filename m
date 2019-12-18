Return-Path: <SRS0=uTqP=2I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A2E3C43603
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 21:56:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 497472146E
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 21:56:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 497472146E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03BBA4A576;
	Wed, 18 Dec 2019 16:56:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5HMxlMlPK42o; Wed, 18 Dec 2019 16:56:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF3014AF6B;
	Wed, 18 Dec 2019 16:56:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FD134ACBA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 16:56:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h+RMT3aHSzUd for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Dec 2019 16:56:03 -0500 (EST)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C6AF4AEDD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 16:55:50 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
 by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 18 Dec 2019 13:55:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; d="scan'208";a="222108168"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2019 13:55:49 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 38/45] KVM: x86: Move all vcpu init code into
 kvm_arch_vcpu_create()
Date: Wed, 18 Dec 2019 13:55:23 -0800
Message-Id: <20191218215530.2280-39-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218215530.2280-1-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: kvm-ppc@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Joerg Roedel <joro@8bytes.org>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, Greg Kurz <groug@kaod.org>,
 linux-arm-kernel@lists.infradead.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

Fold init() into create() now that the two are called back-to-back by
common KVM code (kvm_vcpu_init() calls kvm_arch_vcpu_init() as its last
action, and kvm_vm_ioctl_create_vcpu() calls kvm_arch_vcpu_create()
immediately thereafter).  This paves the way for removing
kvm_arch_vcpu_init() entirely.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 198 +++++++++++++++++++++++----------------------
 1 file changed, 100 insertions(+), 98 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 20f8ac086824..24671f487645 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9100,11 +9100,78 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
-	int ret;
+	struct page *page;
+	int r;
 
-	ret = kvm_x86_ops->vcpu_create(vcpu);
-	if (ret)
-		return ret;
+	vcpu->arch.emulate_ctxt.ops = &emulate_ops;
+	if (!irqchip_in_kernel(vcpu->kvm) || kvm_vcpu_is_reset_bsp(vcpu))
+		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+	else
+		vcpu->arch.mp_state = KVM_MP_STATE_UNINITIALIZED;
+
+	kvm_set_tsc_khz(vcpu, max_tsc_khz);
+
+	r = kvm_mmu_create(vcpu);
+	if (r < 0)
+		return r;
+
+	if (irqchip_in_kernel(vcpu->kvm)) {
+		vcpu->arch.apicv_active = kvm_x86_ops->get_enable_apicv(vcpu->kvm);
+		r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
+		if (r < 0)
+			goto fail_mmu_destroy;
+	} else
+		static_key_slow_inc(&kvm_no_apic_vcpu);
+
+	r = -ENOMEM;
+
+	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!page)
+		goto fail_free_lapic;
+	vcpu->arch.pio_data = page_address(page);
+
+	vcpu->arch.mce_banks = kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) * 4,
+				       GFP_KERNEL_ACCOUNT);
+	if (!vcpu->arch.mce_banks)
+		goto fail_free_pio_data;
+	vcpu->arch.mcg_cap = KVM_MAX_MCE_BANKS;
+
+	if (!zalloc_cpumask_var(&vcpu->arch.wbinvd_dirty_mask,
+				GFP_KERNEL_ACCOUNT))
+		goto fail_free_mce_banks;
+
+	vcpu->arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
+						GFP_KERNEL_ACCOUNT);
+	if (!vcpu->arch.user_fpu) {
+		pr_err("kvm: failed to allocate userspace's fpu\n");
+		goto free_wbinvd_dirty_mask;
+	}
+
+	vcpu->arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
+						 GFP_KERNEL_ACCOUNT);
+	if (!vcpu->arch.guest_fpu) {
+		pr_err("kvm: failed to allocate vcpu's fpu\n");
+		goto free_user_fpu;
+	}
+	fx_init(vcpu);
+
+	vcpu->arch.guest_xstate_size = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
+
+	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
+
+	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
+
+	kvm_async_pf_hash_reset(vcpu);
+	kvm_pmu_init(vcpu);
+
+	vcpu->arch.pending_external_vector = -1;
+	vcpu->arch.preempted_in_kernel = false;
+
+	kvm_hv_vcpu_init(vcpu);
+
+	r = kvm_x86_ops->vcpu_create(vcpu);
+	if (r)
+		goto free_guest_fpu;
 
 	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
 	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
@@ -9114,6 +9181,22 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kvm_init_mmu(vcpu, false);
 	vcpu_put(vcpu);
 	return 0;
+
+free_guest_fpu:
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
+free_user_fpu:
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
+free_wbinvd_dirty_mask:
+	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
+fail_free_mce_banks:
+	kfree(vcpu->arch.mce_banks);
+fail_free_pio_data:
+	free_page((unsigned long)vcpu->arch.pio_data);
+fail_free_lapic:
+	kvm_free_lapic(vcpu);
+fail_mmu_destroy:
+	kvm_mmu_destroy(vcpu);
+	return r;
 }
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
@@ -9146,6 +9229,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	int idx;
+
 	kvmclock_reset(vcpu);
 
 	kvm_x86_ops->vcpu_free(vcpu);
@@ -9153,6 +9238,17 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
+
+	kvm_hv_vcpu_uninit(vcpu);
+	kvm_pmu_destroy(vcpu);
+	kfree(vcpu->arch.mce_banks);
+	kvm_free_lapic(vcpu);
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+	kvm_mmu_destroy(vcpu);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	free_page((unsigned long)vcpu->arch.pio_data);
+	if (!lapic_in_kernel(vcpu))
+		static_key_slow_dec(&kvm_no_apic_vcpu);
 }
 
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -9391,106 +9487,12 @@ EXPORT_SYMBOL_GPL(kvm_no_apic_vcpu);
 
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 {
-	struct page *page;
-	int r;
-
-	vcpu->arch.emulate_ctxt.ops = &emulate_ops;
-	if (!irqchip_in_kernel(vcpu->kvm) || kvm_vcpu_is_reset_bsp(vcpu))
-		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
-	else
-		vcpu->arch.mp_state = KVM_MP_STATE_UNINITIALIZED;
-
-	kvm_set_tsc_khz(vcpu, max_tsc_khz);
-
-	r = kvm_mmu_create(vcpu);
-	if (r < 0)
-		return r;
-
-	if (irqchip_in_kernel(vcpu->kvm)) {
-		vcpu->arch.apicv_active = kvm_x86_ops->get_enable_apicv(vcpu->kvm);
-		r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
-		if (r < 0)
-			goto fail_mmu_destroy;
-	} else
-		static_key_slow_inc(&kvm_no_apic_vcpu);
-
-	r = -ENOMEM;
-
-	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-	if (!page)
-		goto fail_free_lapic;
-	vcpu->arch.pio_data = page_address(page);
-
-	vcpu->arch.mce_banks = kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) * 4,
-				       GFP_KERNEL_ACCOUNT);
-	if (!vcpu->arch.mce_banks)
-		goto fail_free_pio_data;
-	vcpu->arch.mcg_cap = KVM_MAX_MCE_BANKS;
-
-	if (!zalloc_cpumask_var(&vcpu->arch.wbinvd_dirty_mask,
-				GFP_KERNEL_ACCOUNT))
-		goto fail_free_mce_banks;
-
-	vcpu->arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
-						GFP_KERNEL_ACCOUNT);
-	if (!vcpu->arch.user_fpu) {
-		pr_err("kvm: failed to allocate userspace's fpu\n");
-		goto free_wbinvd_dirty_mask;
-	}
-
-	vcpu->arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
-						 GFP_KERNEL_ACCOUNT);
-	if (!vcpu->arch.guest_fpu) {
-		pr_err("kvm: failed to allocate vcpu's fpu\n");
-		goto free_user_fpu;
-	}
-	fx_init(vcpu);
-
-	vcpu->arch.guest_xstate_size = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
-
-	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
-
-	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
-
-	kvm_async_pf_hash_reset(vcpu);
-	kvm_pmu_init(vcpu);
-
-	vcpu->arch.pending_external_vector = -1;
-	vcpu->arch.preempted_in_kernel = false;
-
-	kvm_hv_vcpu_init(vcpu);
-
 	return 0;
-
-free_user_fpu:
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
-free_wbinvd_dirty_mask:
-	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
-fail_free_mce_banks:
-	kfree(vcpu->arch.mce_banks);
-fail_free_pio_data:
-	free_page((unsigned long)vcpu->arch.pio_data);
-fail_free_lapic:
-	kvm_free_lapic(vcpu);
-fail_mmu_destroy:
-	kvm_mmu_destroy(vcpu);
-	return r;
 }
 
 void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
-	int idx;
 
-	kvm_hv_vcpu_uninit(vcpu);
-	kvm_pmu_destroy(vcpu);
-	kfree(vcpu->arch.mce_banks);
-	kvm_free_lapic(vcpu);
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	kvm_mmu_destroy(vcpu);
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
-	free_page((unsigned long)vcpu->arch.pio_data);
-	if (!lapic_in_kernel(vcpu))
-		static_key_slow_dec(&kvm_no_apic_vcpu);
 }
 
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

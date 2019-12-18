Return-Path: <SRS0=uTqP=2I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B770C3F68F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 21:56:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D67C5227BF
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 21:56:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D67C5227BF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9165E4ACD6;
	Wed, 18 Dec 2019 16:56:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f9tSQCqks-4I; Wed, 18 Dec 2019 16:56:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C74394AF3D;
	Wed, 18 Dec 2019 16:56:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44BEA4AF2B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 16:56:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tK92a0DMMPNL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Dec 2019 16:56:00 -0500 (EST)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 912BE4AF0F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 16:55:46 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
 by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 18 Dec 2019 13:55:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; d="scan'208";a="222108138"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2019 13:55:45 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 30/45] KVM: Move vcpu alloc and init invocation to common
 code
Date: Wed, 18 Dec 2019 13:55:15 -0800
Message-Id: <20191218215530.2280-31-sean.j.christopherson@intel.com>
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

Now that all architectures tightly couple vcpu allocation/free with the
mandatory calls to kvm_{un}init_vcpu(), move the sequences verbatim to
common KVM code.

Move both allocation and initialization in a single patch to eliminate
thrash in arch specific code.  The bisection benefits of moving the two
pieces in separate patches is marginal at best, whereas the odds of
introducing a transient arch specific bug are non-zero.

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/mips/kvm/mips.c       | 33 ++++++---------------------------
 arch/powerpc/kvm/powerpc.c | 27 ++++-----------------------
 arch/s390/kvm/kvm-s390.c   | 31 +++++--------------------------
 arch/x86/kvm/x86.c         | 28 ++--------------------------
 include/linux/kvm_host.h   |  2 +-
 virt/kvm/arm/arm.c         | 29 ++---------------------------
 virt/kvm/kvm_main.c        | 21 ++++++++++++++++++---
 7 files changed, 38 insertions(+), 133 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 8546bc6e09e7..92c9321b3f95 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -285,25 +285,14 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return 0;
 }
 
-struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	int err, size;
 	void *gebase, *p, *handler, *refill_start, *refill_end;
 	int i;
 
-	struct kvm_vcpu *vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
-
-	if (!vcpu) {
-		err = -ENOMEM;
-		goto out;
-	}
-
-	err = kvm_vcpu_init(vcpu, kvm, id);
-
-	if (err)
-		goto out_free_cpu;
-
-	kvm_debug("kvm @ %p: create cpu %d at %p\n", kvm, id, vcpu);
+	kvm_debug("kvm @ %p: create cpu %d at %p\n",
+		  vcpu->kvm, vcpu->vcpu_id, vcpu);
 
 	/*
 	 * Allocate space for host mode exception handlers that handle
@@ -318,7 +307,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 
 	if (!gebase) {
 		err = -ENOMEM;
-		goto out_uninit_cpu;
+		goto out;
 	}
 	kvm_debug("Allocated %d bytes for KVM Exception Handlers @ %p\n",
 		  ALIGN(size, PAGE_SIZE), gebase);
@@ -397,19 +386,12 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 	vcpu->arch.last_sched_cpu = -1;
 	vcpu->arch.last_exec_cpu = -1;
 
-	return vcpu;
+	return 0;
 
 out_free_gebase:
 	kfree(gebase);
-
-out_uninit_cpu:
-	kvm_vcpu_uninit(vcpu);
-
-out_free_cpu:
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
-
 out:
-	return ERR_PTR(err);
+	return err;
 }
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
@@ -421,9 +403,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_caches(vcpu);
 	kfree(vcpu->arch.guest_ebase);
 	kfree(vcpu->arch.kseg0_commpage);
-
-	kvm_vcpu_uninit(vcpu);
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index e3e2b88d3d8b..fce1b4776e55 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -725,32 +725,17 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return 0;
 }
 
-struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu;
 	int err;
 
-	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
-	if (!vcpu)
-		return ERR_PTR(-ENOMEM);
-
-	err = kvm_vcpu_init(vcpu, kvm, id);
-	if (err)
-		goto free_vcpu;
-
 	err = kvmppc_core_vcpu_create(vcpu);
 	if (err)
-		goto uninit_vcpu;
+		return err;
 
 	vcpu->arch.wqp = &vcpu->wq;
-	kvmppc_create_vcpu_debugfs(vcpu, id);
-	return vcpu;
-
-uninit_vcpu:
-	kvm_vcpu_uninit(vcpu);
-free_vcpu:
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
-	return ERR_PTR(err);
+	kvmppc_create_vcpu_debugfs(vcpu, vcpu->vcpu_id);
+	return 0;
 }
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
@@ -780,10 +765,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	}
 
 	kvmppc_core_vcpu_free(vcpu);
-
-	kvm_vcpu_uninit(vcpu);
-
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8543d338a06a..2ed76584ebd9 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2530,9 +2530,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	if (vcpu->kvm->arch.use_cmma)
 		kvm_s390_vcpu_unsetup_cmma(vcpu);
 	free_page((unsigned long)(vcpu->arch.sie_block));
-
-	kvm_vcpu_uninit(vcpu);
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
 static void kvm_free_vcpus(struct kvm *kvm)
@@ -3014,29 +3011,15 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return 0;
 }
 
-struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
-				      unsigned int id)
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu;
 	struct sie_page *sie_page;
 	int rc;
 
-	rc = -ENOMEM;
-
-	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
-	if (!vcpu)
-		goto out;
-
-	rc = kvm_vcpu_init(vcpu, kvm, id);
-	if (rc)
-		goto out_free_cpu;
-
-	rc = -ENOMEM;
-
 	BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
 	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
 	if (!sie_page)
-		goto out_uninit_vcpu;
+		return -ENOMEM;
 
 	vcpu->arch.sie_block = &sie_page->sie_block;
 	vcpu->arch.sie_block->itdba = (unsigned long) &sie_page->itdb;
@@ -3087,15 +3070,11 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 		 vcpu->arch.sie_block);
 	trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);
 
-	return vcpu;
+	return 0;
+
 out_free_sie_block:
 	free_page((unsigned long)(vcpu->arch.sie_block));
-out_uninit_vcpu:
-	kvm_vcpu_uninit(vcpu);
-out_free_cpu:
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
-out:
-	return ERR_PTR(rc);
+	return rc;
 }
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c808329290e1..c04b24719b28 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9098,30 +9098,9 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return 0;
 }
 
-struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
-						unsigned int id)
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu;
-	int r;
-
-	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
-	if (!vcpu)
-		return ERR_PTR(-ENOMEM);
-
-	r = kvm_vcpu_init(vcpu, kvm, id);
-	if (r)
-		goto free_vcpu;
-
-	r = kvm_x86_ops->vcpu_create(vcpu);
-	if (r)
-		goto uninit_vcpu;
-	return vcpu;
-
-uninit_vcpu:
-	kvm_vcpu_uninit(vcpu);
-free_vcpu:
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
-	return ERR_PTR(r);
+	return kvm_x86_ops->vcpu_create(vcpu);
 }
 
 int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
@@ -9173,9 +9152,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
-
-	kvm_vcpu_uninit(vcpu);
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9e3371f9a4cd..a9abd9e9f621 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -876,7 +876,7 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu);
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id);
-struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id);
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index f569cbb2f123..35eab584fb57 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -290,32 +290,9 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return 0;
 }
 
-struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
-	int err;
-	struct kvm_vcpu *vcpu;
-
-	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
-	if (!vcpu) {
-		err = -ENOMEM;
-		goto out;
-	}
-
-	err = kvm_vcpu_init(vcpu, kvm, id);
-	if (err)
-		goto free_vcpu;
-
-	err = create_hyp_mappings(vcpu, vcpu + 1, PAGE_HYP);
-	if (err)
-		goto vcpu_uninit;
-
-	return vcpu;
-vcpu_uninit:
-	kvm_vcpu_uninit(vcpu);
-free_vcpu:
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
-out:
-	return ERR_PTR(err);
+	return create_hyp_mappings(vcpu, vcpu + 1, PAGE_HYP);
 }
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
@@ -330,8 +307,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_caches(vcpu);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
-	kvm_vcpu_uninit(vcpu);
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c2766a1108b9..1afffb0da7cc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -378,6 +378,9 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_uninit);
 void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_arch_vcpu_destroy(vcpu);
+
+	kvm_vcpu_uninit(vcpu);
+	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_destroy);
 
@@ -2738,12 +2741,20 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	if (r)
 		goto vcpu_decrement;
 
-	vcpu = kvm_arch_vcpu_create(kvm, id);
-	if (IS_ERR(vcpu)) {
-		r = PTR_ERR(vcpu);
+	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
+	if (!vcpu) {
+		r = -ENOMEM;
 		goto vcpu_decrement;
 	}
 
+	r = kvm_vcpu_init(vcpu, kvm, id);
+	if (r)
+		goto vcpu_free;
+
+	r = kvm_arch_vcpu_create(vcpu);
+	if (r)
+		goto vcpu_uninit;
+
 	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
 
 	r = kvm_arch_vcpu_setup(vcpu);
@@ -2787,6 +2798,10 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	debugfs_remove_recursive(vcpu->debugfs_dentry);
 vcpu_destroy:
 	kvm_arch_vcpu_destroy(vcpu);
+vcpu_uninit:
+	kvm_vcpu_uninit(vcpu);
+vcpu_free:
+	kmem_cache_free(kvm_vcpu_cache, vcpu);
 vcpu_decrement:
 	mutex_lock(&kvm->lock);
 	kvm->created_vcpus--;
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

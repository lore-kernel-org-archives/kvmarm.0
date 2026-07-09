Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D36841166B
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 10:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783593640; cv=none; b=BHiQMXGqU5VR1bunzIECIwDF005eszx9dAsYrlyvHhVv4m3Rtjf1b7xXh8oocYqyI5zlLA6qa8VgaBOFkXxI4gj00hgzNL0nn954Nkw5QxtPMVayJje7JDiHkElEaU5S5OyQ0ocHW/YsEu3wIy1vKVFa1EsSHx/3S3Tu0qDEs8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783593640; c=relaxed/simple;
	bh=TNeyXQrWb4ktidro+XtNsapHakJH3l3+QbyQjqCZCyM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BElOUm9hhJJdQOs0aQ67UnYlTMrGxXxxPooFRxZJeaIKpZDg0fdSod9GrJ0j0qPA+denHdzzQyep3NrncQ82nQn8icO7oTMkjWnoT3boXloWrodnxLew9ZjuuSiQdEzzOwNcKcyEJlO9xkhb1V2PAs1LlXN0yJJWYBinywzgexA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=iU0ITqX4; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="iU0ITqX4"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=jHl1Xys4x/oN/Jol8O/4l6bfCsnvsVRKGoScL4MjRMc=;
	b=iU0ITqX4gt2tt0iKWX8G71zXIz1qDsxijhjb43d9Tsx2FgBc129YcMduxodj1onRK79ZBn4yp
	y9dwhG6/zer8c9uMLxt2GoCN6F0TrjbZL19fjThM68LnnGOmpJMa6scWvmNU5ClzfbRjl+fOMWT
	kJvMm7TVgffBCXhVB7YYEaY=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gwrqb5k9KznTWQ;
	Thu,  9 Jul 2026 18:31:55 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 3B0A64048B;
	Thu,  9 Jul 2026 18:40:31 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 9 Jul
 2026 18:40:30 +0800
From: Tian Zheng <zhengtian10@huawei.com>
To: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <zhengtian10@huawei.com>
CC: <yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>,
	<yangjinqian1@huawei.com>, <caijian11@h-partners.com>,
	<liuyonglong@huawei.com>, <yezhenyu2@huawei.com>, <yubihong@huawei.com>,
	<linuxarm@huawei.com>, <joey.gouly@arm.com>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <seiden@linux.ibm.com>,
	<suzuki.poulose@arm.com>, <leo.bras@arm.com>
Subject: [PATCH v4 6/6] KVM: arm64: Add auto HDBSS enable/disable on dirty logging change
Date: Thu, 9 Jul 2026 18:40:26 +0800
Message-ID: <20260709104026.2612599-7-zhengtian10@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260709104026.2612599-1-zhengtian10@huawei.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)

From: eillon <yezhenyu2@huawei.com>

HDBSS buffers store per-page dirty state after the stage-2 page tables
have been split down to page granularity (chunk_size == PAGE_SIZE).
When chunk_size == 0 the kernel may lazily skip splitting block mappings,
leaving the page table coarser than what HDBSS expects. Therefore,
enabling HDBSS requires disabling lazy split so that all block mappings
are eagerly broken down before the buffer starts recording.

Add VM-level HDBSS enable/disable support. When dirty logging is
enabled on any memslot, HDBSS is automatically enabled. When dirty
logging is disabled on all memslots, HDBSS is automatically disabled.

This includes:
- kvm_arm_enable_hdbss_global() to enable HDBSS for all vCPUs
- kvm_arm_disable_hdbss_global() to disable and free HDBSS buffers
- kvm_arm_hdbss_on_dirty_logging_change() for auto enable/disable
- kvm_arch_destroy_vm() cleanup path
- kvm_arch_commit_memory_region() integration

Signed-off-by: Eillon <yezhenyu2@huawei.com>
Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
---
 arch/arm64/include/asm/kvm_dirty_bit.h |   2 +
 arch/arm64/kvm/arm.c                   |   8 ++
 arch/arm64/kvm/dirty_bit.c             | 105 +++++++++++++++++++++++++
 arch/arm64/kvm/mmu.c                   |   3 +
 4 files changed, 118 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
index 4b28000e972f..a4cda8cdab24 100644
--- a/arch/arm64/include/asm/kvm_dirty_bit.h
+++ b/arch/arm64/include/asm/kvm_dirty_bit.h
@@ -23,5 +23,7 @@ int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu, unsigned int order);
 void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
 void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu);
 int kvm_handle_hdbss_fault(struct kvm_vcpu *vcpu);
+void kvm_arm_hdbss_on_dirty_logging_change(struct kvm *kvm, int nr_memslots_logging);
+void kvm_arm_disable_hdbss_global(struct kvm *kvm);

 #endif /* __ARM64_KVM_DIRTY_BIT_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 566953a4e23a..536d94799ba8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -317,6 +317,14 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	if (is_protected_kvm_enabled())
 		pkvm_destroy_hyp_vm(kvm);

+	/*
+	 * Userspace may destroy the VM without disabling dirty logging,
+	 * so the auto-disable path is never reached. Force disable HDBSS
+	 * here to ensure vCPU buffers are freed and prevent memory leaks.
+	 */
+	if (kvm->arch.enable_hdbss)
+		kvm_arm_disable_hdbss_global(kvm);
+
 	kvm_uninit_stage2_mmu(kvm);
 	kvm_destroy_mpidr_data(kvm);

diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
index 002366337637..c5bf866c23ef 100644
--- a/arch/arm64/kvm/dirty_bit.c
+++ b/arch/arm64/kvm/dirty_bit.c
@@ -112,3 +112,108 @@ int kvm_handle_hdbss_fault(struct kvm_vcpu *vcpu)
 		return -EFAULT;
 	}
 }
+
+static unsigned int hdbss_auto_select_order(struct kvm *kvm)
+{
+	unsigned long npages = 0;
+	struct kvm_memory_slot *memslot;
+	int bkt;
+
+	kvm_for_each_memslot(memslot, bkt, kvm_memslots(kvm))
+		npages += memslot->npages;
+
+	if (npages <= 16384)
+		return 0;
+	else if (npages <= 262144)
+		return 3;
+	else if (npages <= 4194304)
+		return 6;
+	else
+		return 9;
+}
+
+/*
+ * Enable HDBSS for all vCPUs in the VM.
+ *
+ * Called from kvm_arm_hdbss_on_dirty_logging_change() which is invoked
+ * by kvm_arch_commit_memory_region() under kvm->slots_lock.
+ *
+ * If buffer allocation fails, HDBSS remains disabled and dirty tracking
+ * falls back to the traditional software-based approach (PTE write-protect
+ * + software dirty marking). This does not affect correctness; dirty
+ * logging remains functional without HDBSS.
+ */
+static int kvm_arm_enable_hdbss_global(struct kvm *kvm)
+{
+	int err;
+	unsigned long i;
+	unsigned int order;
+	struct kvm_vcpu *vcpu;
+
+	if (!system_supports_hdbss())
+		return 0;
+
+	if (kvm->dirty_ring_size) /* Don't support HDBSS in dirty ring mode */
+		return 0;
+
+	if (kvm->arch.enable_hdbss) /* Already On */
+		return 0;
+
+	/* Turn it on */
+	order = hdbss_auto_select_order(kvm);
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		err = kvm_arm_vcpu_alloc_hdbss(vcpu, order);
+		if (err)
+			goto error_alloc;
+	}
+
+	kvm->arch.enable_hdbss = true;
+	kvm->arch.mmu.vtcr |= VTCR_EL2_HD | VTCR_EL2_HDBSS | VTCR_EL2_HA;
+
+	/*
+	 * We should kick vcpus out of guest mode here to load new
+	 * vtcr value to vtcr_el2 register when re-enter guest mode.
+	 */
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_vcpu_kick(vcpu);
+
+	return 0;
+
+error_alloc:
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		if (vcpu->arch.hdbss.base_phys)
+			kvm_arm_vcpu_free_hdbss(vcpu);
+
+	pr_warn_once("kvm: failed to allocate HDBSS buffers (order=%u), "
+		     "falling back to software dirty tracking\n", order);
+	return -ENOMEM;
+}
+
+void kvm_arm_disable_hdbss_global(struct kvm *kvm)
+{
+	unsigned long i;
+	struct kvm_vcpu *vcpu;
+
+	if (!kvm->arch.enable_hdbss) /* Already Off */
+		return;
+
+	/* Turn it off */
+	kvm->arch.mmu.vtcr &= ~(VTCR_EL2_HD | VTCR_EL2_HDBSS | VTCR_EL2_HA);
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_arm_vcpu_free_hdbss(vcpu);
+
+	kvm->arch.enable_hdbss = false;
+}
+
+void kvm_arm_hdbss_on_dirty_logging_change(struct kvm *kvm, int nr_memslots_logging)
+{
+	/*
+	 * Called from kvm_arch_commit_memory_region() under kvm->slots_lock.
+	 * All state transitions are serialized by slots_lock.
+	 */
+	if (nr_memslots_logging > 0 && !kvm->arch.enable_hdbss)
+		kvm_arm_enable_hdbss_global(kvm);
+	else if (nr_memslots_logging == 0 && kvm->arch.enable_hdbss)
+		kvm_arm_disable_hdbss_global(kvm);
+}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 949fb895add6..484f48dae000 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2588,6 +2588,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 {
 	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;

+	kvm_arm_hdbss_on_dirty_logging_change(kvm,
+		atomic_read(&kvm->nr_memslots_dirty_logging));
+
 	/*
 	 * At this point memslot has been committed and there is an
 	 * allocated dirty_bitmap[], dirty pages will be tracked while the
--
2.33.0


Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93C11E0B67;
	Wed, 19 Mar 2025 17:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742405568; cv=none; b=A3fhzQf2WQ8L99KZSpQicrRrkdHzJ/MVU/SCLljLWZWuzmkf2ko54PJYkG9DC5NoMM8pLP7AB5pPJvch+ZBSNUTABBoc8D/MpN64MNGvcMdOcUZpAViLIIahL6BBTbv3DDbCrS91TsntTPERN8upNq6TWX94YE/5MgU68UlQQzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742405568; c=relaxed/simple;
	bh=lruBUs8TargZk8ji7uWcRPMidDjMpuRewdFLyywkDxY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NY4Wth9ZjlHke4jP3GwIx4bFV3XWYc4SL6dQili69wSusF3CxTaPZpXlQ7++Ud8ca/sl7N56LWa3dWLXr0AWcuHRnx3RTb4W+ELSpHf+u49FDkzwB8NMznk/aiwPwBihLkgfm+H9r3XMF4waaIN3B9b0PXR3mKNVmA2L+zFBUMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZHwgt5K67z6K9Fb;
	Thu, 20 Mar 2025 01:29:46 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 5DEEB1409C9;
	Thu, 20 Mar 2025 01:32:42 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 19 Mar 2025 18:32:35 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>
CC: <linuxarm@huawei.com>, <kevin.tian@intel.com>, <jgg@ziepe.ca>,
	<alex.williamson@redhat.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<will@kernel.org>, <robin.murphy@arm.com>, <nicolinc@nvidia.com>,
	<jean-philippe@linaro.org>, <jonathan.cameron@huawei.com>
Subject: [RFC PATCH v3 1/5] KVM: arm64: Introduce support to pin VMIDs
Date: Wed, 19 Mar 2025 17:31:58 +0000
Message-ID: <20250319173202.78988-2-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20250319173202.78988-1-shameerali.kolothum.thodi@huawei.com>
References: <20250319173202.78988-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 frapeml500008.china.huawei.com (7.182.85.71)

Introduce kvm_arm_pinned_vmid_get() and kvm_arm_pinned_vmid_put(), to pin
a VMID associated with a KVM instance. This will guarantee that VMID
remains the same after a rollover.

This is in preparation of introducing support in the SMMUv3 driver to use
the KVM VMID for S2 stage configuration in nested mode.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kvm/vmid.c             | 76 ++++++++++++++++++++++++++++++-
 2 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d919557af5e5..b6682f5d1b86 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -142,6 +142,7 @@ int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages);
 
 struct kvm_vmid {
 	atomic64_t id;
+	refcount_t pinned;
 };
 
 struct kvm_s2_mmu {
@@ -1261,6 +1262,8 @@ int __init kvm_arm_vmid_alloc_init(void);
 void __init kvm_arm_vmid_alloc_free(void);
 void kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid);
 void kvm_arm_vmid_clear_active(void);
+int kvm_arm_pinned_vmid_get(struct kvm *kvm);
+void kvm_arm_pinned_vmid_put(struct kvm *kvm);
 
 static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_arch)
 {
diff --git a/arch/arm64/kvm/vmid.c b/arch/arm64/kvm/vmid.c
index 7fe8ba1a2851..7bda189e927c 100644
--- a/arch/arm64/kvm/vmid.c
+++ b/arch/arm64/kvm/vmid.c
@@ -25,6 +25,10 @@ static unsigned long *vmid_map;
 static DEFINE_PER_CPU(atomic64_t, active_vmids);
 static DEFINE_PER_CPU(u64, reserved_vmids);
 
+static unsigned long max_pinned_vmids;
+static unsigned long nr_pinned_vmids;
+static unsigned long *pinned_vmid_map;
+
 #define VMID_MASK		(~GENMASK(kvm_arm_vmid_bits - 1, 0))
 #define VMID_FIRST_VERSION	(1UL << kvm_arm_vmid_bits)
 
@@ -47,7 +51,10 @@ static void flush_context(void)
 	int cpu;
 	u64 vmid;
 
-	bitmap_zero(vmid_map, NUM_USER_VMIDS);
+	if (pinned_vmid_map)
+		bitmap_copy(vmid_map, pinned_vmid_map, NUM_USER_VMIDS);
+	else
+		bitmap_zero(vmid_map, NUM_USER_VMIDS);
 
 	for_each_possible_cpu(cpu) {
 		vmid = atomic64_xchg_relaxed(&per_cpu(active_vmids, cpu), 0);
@@ -103,6 +110,14 @@ static u64 new_vmid(struct kvm_vmid *kvm_vmid)
 			return newvmid;
 		}
 
+		/*
+		 * If it is pinned, we can keep using it. Note that reserved
+		 * takes priority, because even if it is also pinned, we need to
+		 * update the generation into the reserved_vmids.
+		 */
+		if (refcount_read(&kvm_vmid->pinned))
+			return newvmid;
+
 		if (!__test_and_set_bit(vmid2idx(vmid), vmid_map)) {
 			atomic64_set(&kvm_vmid->id, newvmid);
 			return newvmid;
@@ -169,6 +184,55 @@ void kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid)
 	raw_spin_unlock_irqrestore(&cpu_vmid_lock, flags);
 }
 
+int kvm_arm_pinned_vmid_get(struct kvm *kvm)
+{
+	struct kvm_vmid *kvm_vmid;
+	u64 vmid;
+
+	if (!pinned_vmid_map || !kvm)
+		return -EINVAL;
+
+	kvm_vmid = &kvm->arch.mmu.vmid;
+
+	guard(raw_spinlock_irqsave)(&cpu_vmid_lock);
+	vmid = atomic64_read(&kvm_vmid->id);
+
+	if (refcount_inc_not_zero(&kvm_vmid->pinned))
+		return (vmid & ~VMID_MASK);
+
+	if (nr_pinned_vmids >= max_pinned_vmids)
+		return -EINVAL;
+
+	/*
+	 * If we went through one or more rollover since that VMID was
+	 * used, make sure it is still valid, or generate a new one.
+	 */
+	if (!vmid_gen_match(vmid))
+		vmid = new_vmid(kvm_vmid);
+
+	nr_pinned_vmids++;
+	__set_bit(vmid2idx(vmid), pinned_vmid_map);
+	refcount_set(&kvm_vmid->pinned, 1);
+	return (vmid & ~VMID_MASK);
+}
+
+void kvm_arm_pinned_vmid_put(struct kvm *kvm)
+{
+	struct kvm_vmid *kvm_vmid;
+	u64 vmid;
+
+	if (!pinned_vmid_map || !kvm)
+		return;
+
+	kvm_vmid = &kvm->arch.mmu.vmid;
+	vmid = atomic64_read(&kvm_vmid->id);
+	guard(raw_spinlock_irqsave)(&cpu_vmid_lock);
+	if (refcount_dec_and_test(&kvm_vmid->pinned)) {
+		__clear_bit(vmid2idx(vmid), pinned_vmid_map);
+		nr_pinned_vmids--;
+	}
+}
+
 /*
  * Initialize the VMID allocator
  */
@@ -186,10 +250,20 @@ int __init kvm_arm_vmid_alloc_init(void)
 	if (!vmid_map)
 		return -ENOMEM;
 
+	pinned_vmid_map = bitmap_zalloc(NUM_USER_VMIDS, GFP_KERNEL);
+	nr_pinned_vmids = 0;
+
+	/*
+	 * Ensure we have at least one emty slot available after rollover
+	 * and maximum number of VMIDs are pinned. VMID#0 is reserved.
+	 */
+	max_pinned_vmids = NUM_USER_VMIDS - num_possible_cpus() - 2;
+
 	return 0;
 }
 
 void __init kvm_arm_vmid_alloc_free(void)
 {
+	bitmap_free(pinned_vmid_map);
 	bitmap_free(vmid_map);
 }
-- 
2.47.0


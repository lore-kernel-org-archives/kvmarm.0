Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9557B3C8;
	Thu,  8 Feb 2024 15:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707405663; cv=none; b=sRnE17HiD3qfRTCUFn+0zrqCAS5ihR1FcV6qfJUnYCk1HRruk3CSQNV8o3hcCTeguVyDAvCs2YuR348NrdzmcY2k2peODaN/V8kmOdCgpnX1pLkHTZUw6RDCTeQWIdjpCqGdwG28vPXSmkAe9beajj5gKu6iQTQsQUgS59EHYQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707405663; c=relaxed/simple;
	bh=6xkXti2ecmsrDBLoyleCSRKE2432LIjJYSjard4pOi4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ch2ZvOaJba1/E/q7TEmOgKqMAoCdFY8VIn/OgYxddmNVjH40Oobx+lBny+L9EiuiHtRMLDFycGaCIuwU3dIays+mwZzvjMOKsKmiXnkEy7LTD8EIzdPj1ZNz64Fc+hFX9TTlt5qMPz4KdgZv9zNgkDr8UveSRuECnUbNrxCKLH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TW0vw1p6Xz6JB4K;
	Thu,  8 Feb 2024 23:17:16 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 1676C140CF4;
	Thu,  8 Feb 2024 23:20:59 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.202.227.28) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 8 Feb 2024 15:20:52 +0000
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
CC: <kevin.tian@intel.com>, <jgg@ziepe.ca>, <alex.williamson@redhat.com>,
	<maz@kernel.org>, <oliver.upton@linux.dev>, <will@kernel.org>,
	<robin.murphy@arm.com>, <jean-philippe@linaro.org>,
	<jonathan.cameron@huawei.com>
Subject: [RFC PATCH v2 2/7] KVM: arm64: Introduce support to pin VMIDs
Date: Thu, 8 Feb 2024 15:18:32 +0000
Message-ID: <20240208151837.35068-3-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

Introduce kvm_arm_pinned_vmid_get() and kvm_arm_pinned_vmid_put(), to pin
a VMID associated with a KVM instance. This will guarantee that VMID
remains the same after a rollover.

This is in preparation of introducing support in the SMMUv3 driver to use
the KVM VMID for S2 stage configuration in nested mode.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kvm/vmid.c             | 84 ++++++++++++++++++++++++++++++-
 2 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 21c57b812569..20fb00d29f48 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -141,6 +141,7 @@ int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages);
 
 struct kvm_vmid {
 	atomic64_t id;
+	refcount_t pinned;
 };
 
 struct kvm_s2_mmu {
@@ -1097,6 +1098,8 @@ int __init kvm_arm_vmid_alloc_init(void);
 void __init kvm_arm_vmid_alloc_free(void);
 bool kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid);
 void kvm_arm_vmid_clear_active(void);
+unsigned long kvm_arm_pinned_vmid_get(struct kvm_vmid *kvm_vmid);
+void kvm_arm_pinned_vmid_put(struct kvm_vmid *kvm_vmid);
 
 static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_arch)
 {
diff --git a/arch/arm64/kvm/vmid.c b/arch/arm64/kvm/vmid.c
index 806223b7022a..0ffe24683071 100644
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
@@ -174,6 +189,63 @@ bool kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid)
 	return updated;
 }
 
+unsigned long kvm_arm_pinned_vmid_get(struct kvm_vmid *kvm_vmid)
+{
+	unsigned long flags;
+	u64 vmid;
+
+	if (!pinned_vmid_map)
+		return 0;
+
+	raw_spin_lock_irqsave(&cpu_vmid_lock, flags);
+
+	vmid = atomic64_read(&kvm_vmid->id);
+
+	if (refcount_inc_not_zero(&kvm_vmid->pinned))
+		goto out_unlock;
+
+	if (nr_pinned_vmids >= max_pinned_vmids) {
+		vmid = 0;
+		goto out_unlock;
+	}
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
+
+out_unlock:
+	raw_spin_unlock_irqrestore(&cpu_vmid_lock, flags);
+
+	vmid &= ~VMID_MASK;
+
+	return vmid;
+}
+
+void kvm_arm_pinned_vmid_put(struct kvm_vmid *kvm_vmid)
+{
+	unsigned long flags;
+	u64 vmid = atomic64_read(&kvm_vmid->id);
+
+	if (!pinned_vmid_map)
+		return;
+
+	raw_spin_lock_irqsave(&cpu_vmid_lock, flags);
+
+	if (refcount_dec_and_test(&kvm_vmid->pinned)) {
+		__clear_bit(vmid2idx(vmid), pinned_vmid_map);
+		nr_pinned_vmids--;
+	}
+
+	raw_spin_unlock_irqrestore(&cpu_vmid_lock, flags);
+}
+
 /*
  * Initialize the VMID allocator
  */
@@ -191,10 +263,20 @@ int __init kvm_arm_vmid_alloc_init(void)
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
2.34.1


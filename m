Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45088488
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:49 +0000 (UTC)
Received: by mail-wr1-f52.google.com with SMTP id t7so8870609wrp.5
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/mQgjjPfntTEYktl5YrbY8Zrdu7ool4i44pQG74D6kk=;
        b=uqT0FSjB+l/XDMkVXFvBdgrL2J1Pb16FQPBIibne3w+RA4w7ZHPEnJd22+zxU8HfKd
         uiqDg2LvM9mRSy4apdViIghUV5RiGpJ9xBgsXYd6cKHBt/TpwnC8GMrC5ko0Iaweq0z/
         CmUdRKtmq7JFkN77fcuz8OnmfGchAp3YYrnMcIiHnhVzF9vSnEeydQzkuMixbhCMfjEz
         vUrnAhJySZtl5+SiR5kS/OhbSljiIekXWL9ZacrQilp0vifaVxWXWanc9DLxC94l3IoI
         MYetvwJmX0Zxy5mpnmnLi/ktsZyCSUnBrEMc+P2kFBHo928MJkgF0p9IzZDGEvEHMqtX
         s3Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/mQgjjPfntTEYktl5YrbY8Zrdu7ool4i44pQG74D6kk=;
        b=A+h/P+lDrsSvuKIGqvkR6VNgEJG3W9tnXVeyVstX6rU/nXt7IvKOsbvaCZjPisFd64
         VMmFsUtm3+J93Y7fqqZsqXa1fva5zH2P3Lb+USp17UWPPHf7wLsyK+Ai4YA1FYjLaMPu
         dFwIpuECTB+PBi76veZnJd8t1PLbFuU6KBtVSS8hMoowpd0dgaPcOIOla2uhwkg7PA/j
         IBA/vqruZ4YnJMCOXSJ4qJoQaMh0yWBXQWiPG+fn8dOmaXed07cQGZN+JVQ2vQ5Tua5U
         CBbSxkBINq5kQcequX7m5o8SNo8rGzc9GzGhI8OJyiFYpJb1Q9D1bnTTfKBhIVCeSgfA
         MSBA==
X-Gm-Message-State: AO0yUKVTMaqsGsqNgb8qg5dvgVkvuff2iZTYYhCggmanjjfZmKlVN5ZI
	MhDd/PiqK4lTNjOfUek4VKy5iQ==
X-Google-Smtp-Source: AK7set//4GU7QGGJ9JCNwt9lq+EdDL/CqmMxgfwo0Z2qvjFGyJ3BYHcNzGcdlCitnKLcy3y+gHrMfQ==
X-Received: by 2002:a05:6000:186a:b0:298:4baf:ac8a with SMTP id d10-20020a056000186a00b002984bafac8amr2908303wri.44.1675256389370;
        Wed, 01 Feb 2023 04:59:49 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:48 -0800 (PST)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	joro@8bytes.org
Cc: robin.murphy@arm.com,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	smostafa@google.com,
	dbrazdil@google.com,
	ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [RFC PATCH 38/45] iommu/arm-smmu-v3-kvm: Add per-cpu page queue
Date: Wed,  1 Feb 2023 12:53:22 +0000
Message-Id: <20230201125328.2186498-39-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230201125328.2186498-1-jean-philippe@linaro.org>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allocate page queues shared with the hypervisor for page donation and
reclaim. A local_lock ensures that only one thread fills the queue
during a hypercall.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 93 ++++++++++++++++++-
 1 file changed, 92 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index 8808890f4dc0..755c77bc0417 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2022 Linaro Ltd.
  */
 #include <asm/kvm_mmu.h>
+#include <linux/local_lock.h>
 #include <linux/of_platform.h>
 
 #include <kvm/arm_smmu_v3.h>
@@ -23,6 +24,81 @@ struct host_arm_smmu_device {
 static size_t				kvm_arm_smmu_cur;
 static size_t				kvm_arm_smmu_count;
 static struct hyp_arm_smmu_v3_device	*kvm_arm_smmu_array;
+static struct kvm_hyp_iommu_memcache	*kvm_arm_smmu_memcache;
+
+static DEFINE_PER_CPU(local_lock_t, memcache_lock) =
+				INIT_LOCAL_LOCK(memcache_lock);
+
+static void *kvm_arm_smmu_alloc_page(void *opaque)
+{
+	struct arm_smmu_device *smmu = opaque;
+	struct page *p;
+
+	p = alloc_pages_node(dev_to_node(smmu->dev), GFP_ATOMIC, 0);
+	if (!p)
+		return NULL;
+
+	return page_address(p);
+}
+
+static void kvm_arm_smmu_free_page(void *va, void *opaque)
+{
+	free_page((unsigned long)va);
+}
+
+static phys_addr_t kvm_arm_smmu_host_pa(void *va)
+{
+	return __pa(va);
+}
+
+static void *kvm_arm_smmu_host_va(phys_addr_t pa)
+{
+	return __va(pa);
+}
+
+__maybe_unused
+static int kvm_arm_smmu_topup_memcache(struct arm_smmu_device *smmu)
+{
+	struct kvm_hyp_memcache *mc;
+	int cpu = raw_smp_processor_id();
+
+	lockdep_assert_held(this_cpu_ptr(&memcache_lock));
+	mc = &kvm_arm_smmu_memcache[cpu].pages;
+
+	if (!kvm_arm_smmu_memcache[cpu].needs_page)
+		return -EBADE;
+
+	kvm_arm_smmu_memcache[cpu].needs_page = false;
+	return  __topup_hyp_memcache(mc, 1, kvm_arm_smmu_alloc_page,
+				     kvm_arm_smmu_host_pa, smmu);
+}
+
+__maybe_unused
+static void kvm_arm_smmu_reclaim_memcache(void)
+{
+	struct kvm_hyp_memcache *mc;
+	int cpu = raw_smp_processor_id();
+
+	lockdep_assert_held(this_cpu_ptr(&memcache_lock));
+	mc = &kvm_arm_smmu_memcache[cpu].pages;
+
+	__free_hyp_memcache(mc, kvm_arm_smmu_free_page,
+			    kvm_arm_smmu_host_va, NULL);
+}
+
+/*
+ * Issue hypercall, and retry after filling the memcache if necessary.
+ * After the call, reclaim pages pushed in the memcache by the hypervisor.
+ */
+#define kvm_call_hyp_nvhe_mc(smmu, ...)				\
+({								\
+	int __ret;						\
+	do {							\
+		__ret = kvm_call_hyp_nvhe(__VA_ARGS__);		\
+	} while (__ret && !kvm_arm_smmu_topup_memcache(smmu));	\
+	kvm_arm_smmu_reclaim_memcache();			\
+	__ret;							\
+})
 
 static bool kvm_arm_smmu_validate_features(struct arm_smmu_device *smmu)
 {
@@ -211,7 +287,7 @@ static struct platform_driver kvm_arm_smmu_driver = {
 
 static int kvm_arm_smmu_array_alloc(void)
 {
-	int smmu_order;
+	int smmu_order, mc_order;
 	struct device_node *np;
 
 	kvm_arm_smmu_count = 0;
@@ -228,7 +304,17 @@ static int kvm_arm_smmu_array_alloc(void)
 	if (!kvm_arm_smmu_array)
 		return -ENOMEM;
 
+	mc_order = get_order(NR_CPUS * sizeof(*kvm_arm_smmu_memcache));
+	kvm_arm_smmu_memcache = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+							 mc_order);
+	if (!kvm_arm_smmu_memcache)
+		goto err_free_array;
+
 	return 0;
+
+err_free_array:
+	free_pages((unsigned long)kvm_arm_smmu_array, smmu_order);
+	return -ENOMEM;
 }
 
 static void kvm_arm_smmu_array_free(void)
@@ -237,6 +323,8 @@ static void kvm_arm_smmu_array_free(void)
 
 	order = get_order(kvm_arm_smmu_count * sizeof(*kvm_arm_smmu_array));
 	free_pages((unsigned long)kvm_arm_smmu_array, order);
+	order = get_order(NR_CPUS * sizeof(*kvm_arm_smmu_memcache));
+	free_pages((unsigned long)kvm_arm_smmu_memcache, order);
 }
 
 /**
@@ -272,9 +360,12 @@ int kvm_arm_smmu_v3_init(unsigned int *count)
 	 * These variables are stored in the nVHE image, and won't be accessible
 	 * after KVM initialization. Ownership of kvm_arm_smmu_array will be
 	 * transferred to the hypervisor as well.
+	 *
+	 * kvm_arm_smmu_memcache is shared between hypervisor and host.
 	 */
 	kvm_hyp_arm_smmu_v3_smmus = kern_hyp_va(kvm_arm_smmu_array);
 	kvm_hyp_arm_smmu_v3_count = kvm_arm_smmu_count;
+	kvm_hyp_iommu_memcaches = kern_hyp_va(kvm_arm_smmu_memcache);
 	return 0;
 
 err_free:
-- 
2.39.0


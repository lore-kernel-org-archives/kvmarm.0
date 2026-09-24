Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5EB73749E2;
	Thu, 24 Sep 2026 13:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790257963; cv=none; b=i494YhEyfdvSgDDcTufrDApFrzIoFR5R+stV+7d5wB+d6FBJ2cvhQOwEpKmfnmNY8s0mue0tqHKcnEsIj5GP3jUTkGW2y2+e7P7wEQbi9cSEZLo4tB82tjCYdppegcMbmQTkQjU0AYkTHtBdJB0zQFquH9qWiNGIwqNfNvDAQsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790257963; c=relaxed/simple;
	bh=lV5yv3cWcp4YpJYiISJ2z8s3Fb776mQ7IQF9eHK36Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCSlcIy65IuyAYZaNKBm02dOGravsnvHBOOsnpFX77Uit3Lsj71RW8z5bMQlbPjHH+ZqgcfRKgHtLBDibII9h4N2rWkl1Eb3TqErnmy6UlRT0sk1Ly3fT7bkH62TaLpeXYnn0y4xEg2U4yQ3MdkO2DxJGRFL1rEgNjny30AhifA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=j52vHFxC; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="j52vHFxC"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D51531476;
	Thu, 24 Sep 2026 06:52:36 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 076803F86F;
	Thu, 24 Sep 2026 06:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790257960; bh=lV5yv3cWcp4YpJYiISJ2z8s3Fb776mQ7IQF9eHK36Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j52vHFxCf4XK1h6JbAXCIcWXiKyRpCcE6D1cQJyDzcmmvGGouJYcs8Pr5qWSDfnY6
	 Hcgvodc9+FzvdgiUkiZZQIRTupzE7mFiUZZGaY5HNYTqx8wcQ6Wk0akI8hyM+t8D47
	 xqfkenBpx+zL+ot3L8ObTj1dunBptU5YYtEtSMRs=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	sudeep.holla@arm.com,
	jonathan.cameron@oss.qualcomm.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v19 6/7] firmware: arm_rmm: Ensure the RMM has GPT entries for memory
Date: Thu, 24 Sep 2026 14:52:00 +0100
Message-ID: <20260924135201.850038-7-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924135201.850038-1-suzuki.poulose@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Steven Price <steven.price@arm.com>

The RMM maintains the state of all the granules in the system to make
sure that the host is abiding by the rules. This state can be maintained
at different granularity, per page (TRACKING_FINE) or per region
(TRACKING_COARSE or TRACKING_INTERMEDIATE). The region size depends on the
underlying "RMI_GRANULE_SIZE". For a "coarse"/"intermediate" region,
all pages in the region must be of the same state, this implies we need to
have "fine" tracking for DRAM, so that we can delegate individual pages.

For now we only support a statically carved out memory for tracking
granules for the "fine" regions. This can be extended in the future to
allow modifying the tracking granularity and remove the need for a
static allocation by the firmware.

Similarly, the firmware may create L0 GPT entries describing the total
address space. But if we change the "PAS" (Physical Address Space) of a
granule, then the firmware may need to create L1 tables to track the PAS
at a finer granularity. Linux therefore checks if the platform firmware
manages the PAR region. i.e., the firmware is in charge of managing the
L1 GPTs (creation and the required memory for the GPT tables - via static
carveouts) without host intervention. Support for dynamic GPT creation by
the host will be added later.

If the firmware requires us to manage the tracking or GPT memory,
deactivate the RMM and reclaim any memory donated at RMM activation.

Apply the same checks when hotplugged memory is brought online.

Signed-off-by: Steven Price <steven.price@arm.com>
[ Switch to RMI_GPT_L1_INFO for checking GPTs and deactivate RMM ]
Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 Changes since v19:
     * Avoid mixing gotos with __free cleanups for arm64_init_rmi()
 Changes since v18:
     * Handle buggy RMM to make forward progress for RMI_GPT_INFO and
       RMI_GRANULE_TRACKING_GET
     * Make sure the memory ranges are not inverted and reject such ranges.
     * Move granule_tracking_get/gpt_info wrappers closer to the callers
       Drop "inline", let the compiler do its job
 Changes since v17:
     * Move wrappers that may not be used elsewhere, out of arm-rmi-cmds.h
 Changes since v16:
     * Check fine tracking and create L1 GPTs for hotplug-added memory.
     * Clarify the L1 GPT setup and move the explanatory comment.
     * Switch to using RMI_GPT_INFO command for checking the GPTs.
     * Deactivate the RMM and reclaim the memory if we can't proceed.
 Changes since v15:
     * Skip firmware-reserved NOMAP memory in rmi_init_metadata()
     * Handle negative error codes from wrappers.
 Changes since v14:
     * Move the implementation into drivers/firmware/arm_rmm.
 Changes since v13:
     * Moved out of KVM
---
 drivers/firmware/arm_rmm/rmi.c | 218 ++++++++++++++++++++++++++++++++-
 include/linux/arm-rmi-cmds.h   |   2 +
 2 files changed, 219 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index 0859f256e192b..1a8f3debd844a 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -5,6 +5,7 @@
 
 #include <linux/cpufeature.h>
 #include <linux/memblock.h>
+#include <linux/memory.h>
 #include <linux/arm-rmi-cmds.h>
 #include <linux/slab.h>
 
@@ -13,6 +14,7 @@
 
 /* RMM defines RmiFeatureRegister0 to RmiFeatureRegister5. */
 static unsigned long rmi_feat_reg_cache[5] __ro_after_init;
+static bool arm64_rmi_is_available;
 
 /**
  * rmi_granule_range_undelegate() - Undelegate a range of granules
@@ -817,6 +819,210 @@ static int rmi_configure(void)
 	return ret;
 }
 
+/**
+ * rmi_granule_tracking_get() - Get configuration of a Granule tracking region
+ * @start: Base PA of the tracking region
+ * @end: End of the PA region
+ * @out_category: Memory category
+ * @out_state: Tracking region state
+ * @out_top: Top of the memory region
+ *
+ * Return: RMI return code
+ */
+static int rmi_granule_tracking_get(unsigned long start,
+				    unsigned long end,
+				    unsigned long *out_category,
+				    unsigned long *out_state,
+				    unsigned long *out_top)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_GRANULE_TRACKING_GET, start, end,
+	};
+
+	rmi_smccc_invoke(&regs);
+
+	if (regs.a0 != RMI_SUCCESS)
+		return regs.a0;
+
+	if (out_category)
+		*out_category = regs.a1;
+	if (out_state)
+		*out_state = regs.a2;
+	if (out_top)
+		*out_top = regs.a3;
+
+	return RMI_SUCCESS;
+}
+
+/*
+ * Make sure the area is tracked by RMM at FINE granularity.
+ * We do not support changing the tracking yet.
+ */
+static int rmi_verify_memory_tracking(phys_addr_t start, phys_addr_t end)
+{
+	while (start < end) {
+		unsigned long ret, category, state, next;
+
+		ret = rmi_granule_tracking_get(start, end, &category, &state, &next);
+		if (ret != RMI_SUCCESS)
+			return -ENOMEM;
+
+		if (WARN_ON(next <= start))
+			return -ENXIO;
+
+		if (state != RMI_TRACKING_FINE ||
+		    category != RMI_MEM_CATEGORY_CONVENTIONAL) {
+			/* TODO: Set granule tracking in this case */
+			pr_err("Granule tracking for region isn't fine/conventional: %llx-%lx\n",
+			       start, next);
+			return -ENODEV;
+		}
+		start = next;
+	}
+
+	return 0;
+}
+
+/*
+ * rmi_gpt_info - Query the GPT info for the given PAR.
+ * @start: Base of the physical address region
+ * @end: Top of the physical address region
+ * @out_top: Top of the physical address region for which
+ *		the GPT @out_gpt_par_state is valid
+ * @out_gpt_par_state: State of the GPT covered by [start, out_top)
+ */
+static long rmi_gpt_info(unsigned long start, unsigned long end,
+			 unsigned long *out_top,
+			 unsigned long *out_gpt_par_state)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_GPT_INFO, start, end,
+	};
+
+	rmi_smccc_invoke(&regs);
+	if (regs.a0 != RMI_SUCCESS)
+		return regs.a0;
+
+	if (out_top)
+		*out_top = regs.a1;
+	if (out_gpt_par_state)
+		*out_gpt_par_state = regs.a2;
+
+	return RMI_SUCCESS;
+}
+
+/*
+ * We do not support creating L1 GPTs yet. So, make sure that
+ * all the regions are managed by the firmware.
+ */
+static int rmi_verify_gpt_firmware_managed(phys_addr_t start, phys_addr_t end)
+{
+	unsigned long l0gpt_sz;
+	unsigned long next, par_state;
+
+	l0gpt_sz = 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
+					  rmi_feat_reg(1)));
+	start = ALIGN_DOWN(start, l0gpt_sz);
+	end = ALIGN(end, l0gpt_sz);
+
+	while (start < end) {
+		long ret = rmi_gpt_info(start, end, &next, &par_state);
+
+		if (ret != RMI_SUCCESS)
+			return -ENOMEM;
+
+		if (WARN_ON(next <= start))
+			return -ENXIO;
+
+		if (par_state != RMI_GPT_PAR_PLAT) {
+			pr_err("GPT for the region is not managed by firmware %llx-%lx\n",
+				start, next);
+			return -ENOMEM;
+		}
+		start = next;
+	}
+
+	return 0;
+}
+
+static int rmi_prepare_memory(phys_addr_t start, phys_addr_t end)
+{
+	int ret;
+
+	if (start >= end)
+		return -EINVAL;
+
+	ret = rmi_verify_memory_tracking(start, end);
+	if (ret)
+		return ret;
+
+	return rmi_verify_gpt_firmware_managed(start, end);
+}
+
+static int rmi_init_metadata(void)
+{
+	phys_addr_t start, end;
+	struct memblock_region *r;
+
+	for_each_mem_region(r) {
+		int ret;
+
+		/* Firmware-reserved NOMAP regions are not usable system RAM */
+		if (memblock_is_nomap(r))
+			continue;
+
+		start = PAGE_ALIGN(r->base);
+		end = PAGE_ALIGN_DOWN(r->base + r->size);
+		/* Too small ? */
+		if (start >= end)
+			continue;
+
+		ret = rmi_prepare_memory(start, end);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int rmi_memory_notifier(struct notifier_block *nb,
+			       unsigned long action, void *data)
+{
+	struct memory_notify *arg = data;
+	phys_addr_t start, end;
+	int ret;
+
+	if (action != MEM_GOING_ONLINE)
+		return NOTIFY_DONE;
+
+	start = PFN_PHYS(arg->start_pfn);
+	end = PFN_PHYS(arg->start_pfn + arg->nr_pages);
+	ret = rmi_prepare_memory(start, end);
+
+	return notifier_from_errno(ret);
+}
+
+static struct notifier_block rmi_memory_nb = {
+	.notifier_call = rmi_memory_notifier,
+};
+
+bool is_rmi_available(void)
+{
+	return arm64_rmi_is_available;
+}
+EXPORT_SYMBOL_GPL(is_rmi_available);
+
+static int rmi_init_memory(void)
+{
+	int ret;
+
+	ret = rmi_init_metadata();
+	if (ret)
+		return ret;
+
+	return register_memory_notifier(&rmi_memory_nb);
+}
+
 static int __init arm64_init_rmi(void)
 {
 	int ret;
@@ -843,9 +1049,19 @@ static int __init arm64_init_rmi(void)
 	if (ret) {
 		pr_err("RMM activate failed (%d)\n", ret);
 		ret = ret < 0 ? ret : -ENXIO;
+		return ret;
 	}
 
-	return ret;
+	ret = rmi_init_memory();
+	if (ret) {
+		/* Deactivate the RMM */
+		WARN_ON(rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_RMM_DEACTIVATE));
+		return ret;
+	}
+
+	arm64_rmi_is_available = true;
+	pr_info("RMI configured\n");
+	return 0;
 }
 
 /*
diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
index b03974fd8168c..5b177bb176326 100644
--- a/include/linux/arm-rmi-cmds.h
+++ b/include/linux/arm-rmi-cmds.h
@@ -70,6 +70,8 @@ static inline int rmi_undelegate_page(phys_addr_t phys)
 	return rmi_undelegate_range(phys, PAGE_SIZE);
 }
 
+bool is_rmi_available(void);
+
 long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp);
 void rmi_sro_free(struct rmi_sro_state *sro);
 long rmi_sro_execute(struct arm_smccc_1_2_regs *regs);
-- 
2.43.0


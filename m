Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4625B3E6DF4;
	Fri,  2 Oct 2026 06:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790921771; cv=none; b=nixrlgFOMyjYBpiRYek2Kc8AFxdeRHYPAKqHxFVMpa0mIVhvdXfZxz64ubFHbEE1U6FYpnCJ+Rg8REb5jj/nrgS1ZMDzyieMxoC9yjRyBvookPfofNXVSFMMGcXOGnDnSm0VCTFMXZuW1pOjuLwTRQULuAPraTTDS1RtxCMjhm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790921771; c=relaxed/simple;
	bh=Cbkf9ZGb0Sk+YcLnqcc0ZuPxnRPAH0sD33ghL4Fkyn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t48TetShFoMzMoR1HpcDJA7tQPkjEX0NgIzLLv73FgIlrIeogSgFR+9d1aZaO1TcFZUfHyxDR7ZBF41RBXQnyRgToArc6dlR+tSU/dN7+nFmS8doQH4C0YlMeCEYRYcpj5ckZceoAfRn6NKqszMvd/q32+M9KT9xPcZrWTYk96Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=J0WP7vP3; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="J0WP7vP3"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09E351476;
	Thu,  1 Oct 2026 23:15:53 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EEC133F763;
	Thu,  1 Oct 2026 23:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790921756; bh=Cbkf9ZGb0Sk+YcLnqcc0ZuPxnRPAH0sD33ghL4Fkyn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0WP7vP3vvAswI0dSzwlMzEXfSuAtWzFOXwIm1r6rNQ+VxsSWaqf6nUhKptVMWXB/
	 h06c6uMql5X0cJPHZJZyCty6mmibeE3dl3atUPcZ6PyBjAJVm4anAw8/EDaYLzFaV9
	 Xvs4cgKcX9Q5o38xs31tcLS+xu04ZHj8Llb69AgQ=
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
Subject: [PATCH v22 06/10] firmware: arm_rmm: Ensure the RMM has GPT entries for memory
Date: Fri,  2 Oct 2026 07:15:02 +0100
Message-ID: <20261002061507.1600269-7-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261002061507.1600269-1-suzuki.poulose@arm.com>
References: <20261002061507.1600269-1-suzuki.poulose@arm.com>
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

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 Changes since v19:
   * Wrap comments to 80spaces.
   * Add a comment on ALIGN_DOWN the end of memory range.
   * Add is_rmm_active() to indicate if the RMM is active
   * Switch errors to -ENODEV from -ENOMEM when RMM doesn't manage the region
   * Print error messages when RMI_GPT_INFO/RMI_GRANULE_TRACKIN_GET fails
 Changes since v18:
   * Avoid mixing gotos with __free cleanups for arm64_init_rmi()
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
 drivers/firmware/arm_rmm/rmi.c | 247 ++++++++++++++++++++++++++++++++-
 include/linux/arm-rmi-cmds.h   |  18 +++
 2 files changed, 264 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index f093cb39fa0d2..c064072690d46 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -6,6 +6,7 @@
 #include <linux/arm-rmi-cmds.h>
 #include <linux/cpufeature.h>
 #include <linux/memblock.h>
+#include <linux/memory.h>
 #include <linux/mmzone.h>
 #include <linux/slab.h>
 
@@ -14,6 +15,25 @@
 
 /* RMM v2.0 defines RmiFeatureRegister0 to RmiFeatureRegister4. */
 static unsigned long rmi_feat_reg_cache[5] __ro_after_init;
+static bool arm64_rmm_active;
+static bool arm64_rmi_is_available;
+
+/* is_rmm_active: Returns if the RMM is ACTIVE */
+bool is_rmm_active(void)
+{
+	return READ_ONCE(arm64_rmm_active);
+}
+EXPORT_SYMBOL_GPL(is_rmm_active);
+
+/*
+ * is_rmi_available: Returns if the RMM is ACTIVE and is configured with static
+ * carveout for metadata nad L1GPTs.
+ */
+bool is_rmi_available(void)
+{
+	return READ_ONCE(arm64_rmi_is_available);
+}
+EXPORT_SYMBOL_GPL(is_rmi_available);
 
 /*
  * rmi_granule_range_delegate() - Delegate granules
@@ -840,6 +860,216 @@ static int rmi_configure(void)
 	return 0;
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
+		if (ret != RMI_SUCCESS) {
+			pr_err("RMI_GRANULE_TRACKING_GET failed for %llx-%llx: (%lu)\n",
+				start, end, ret);
+			return -ENXIO;
+		}
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
+ * @out_top: Top of the physical address region for which the GPT @out_gpt_par_state
+ *		is valid
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
+ * We do not support creating L1 GPTs yet. So, make sure that all the regions
+ * are managed by the firmware.
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
+		if (ret != RMI_SUCCESS) {
+			pr_err("RMI_GPT_INFO failed for %llx-%llx: (%ld)\n",
+				start, end, ret);
+			return -ENXIO;
+		}
+
+		if (WARN_ON(next <= start))
+			return -ENXIO;
+
+		if (par_state != RMI_GPT_PAR_PLAT) {
+			pr_err("GPT for the region is not managed by firmware %llx-%lx\n",
+				start, next);
+			return -ENODEV;
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
+		/*
+		 * We always deal with PAGE_SIZE and if in the odd case this
+		 * region boundary is not PAGE aligned, we stick to the page
+		 * that we can use from the region.
+		 */
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
+
+	ret = rmi_prepare_memory(start, end);
+
+	return notifier_from_errno(ret);
+}
+
+static struct notifier_block rmi_memory_nb = {
+	.notifier_call = rmi_memory_notifier,
+};
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
@@ -866,9 +1096,24 @@ static int __init arm64_init_rmi(void)
 	if (ret) {
 		pr_err("RMM activate failed (%d)\n", ret);
 		ret = ret < 0 ? ret : -ENXIO;
+		return ret;
 	}
 
-	return ret;
+	WRITE_ONCE(arm64_rmm_active, true);
+
+	ret = rmi_init_memory();
+	if (ret) {
+		/* Deactivate the RMM */
+		if (!WARN_ON(rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_RMM_DEACTIVATE)))
+			WRITE_ONCE(arm64_rmm_active, false);
+		return ret;
+	}
+
+	/* Mark the RMM is usable */
+	WRITE_ONCE(arm64_rmi_is_available, true);
+	pr_info("RMI configured\n");
+
+	return 0;
 }
 
 /*
diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
index 70426a042afac..982e30fdf4dec 100644
--- a/include/linux/arm-rmi-cmds.h
+++ b/include/linux/arm-rmi-cmds.h
@@ -86,4 +86,22 @@ long rmi_sro_execute(struct arm_smccc_1_2_regs *regs);
 	__ret;								\
 })
 
+#ifdef CONFIG_ARM_RMM_RMI
+
+bool is_rmm_active(void);
+bool is_rmi_available(void);
+
+#else
+
+static inline bool is_rmm_active(void)
+{
+	return false;
+}
+
+static inline bool is_rmi_available(void)
+{
+	return false;
+}
+#endif	/* CONFIG_ARM_RMM_RMI */
+
 #endif	/* __LINUX_ARM_RMI_CMDS_H_ */
-- 
2.43.0


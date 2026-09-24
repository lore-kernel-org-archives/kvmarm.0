Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81A643655D1;
	Thu, 24 Sep 2026 13:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790257956; cv=none; b=lwjiNrIwphEbXzMOSKHkqMSayh/oEGckKiiHSdUxOEm+7SPrQnn+5WLsZ3G2y3BT7vHka5kCOpGB0iBwg9F7O5iTOg1aRRmHpC3u3xhhSe4B1ABguTJXsCXt9t1LaT2YEZVkYvZ1UrMSCeNwcAcXi1cLOKmeh2E9qXacwkz0o4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790257956; c=relaxed/simple;
	bh=easAYh+GbZ1GcueHeBkNeGqW6z5Vr9jX2a9px47dvGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IF+kuz7tMoDwavrqYR+LK2BVpdK+eiSzBvPNt1cMBkIqzDrwbWT5PlyXQ4Wtbeo8zpvZhN9hxRZGAd1dbs0RpuzRNwb0r0kPFMmGMr4oiHLjOqlc7o1vEMV6vfWSe1rETFloWGJpuMxB6ej3HZEIu8MogIYr5ETGlREpah4A934=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jLdx+U8E; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jLdx+U8E"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E2D41476;
	Thu, 24 Sep 2026 06:52:29 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8720B3F86F;
	Thu, 24 Sep 2026 06:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790257953; bh=easAYh+GbZ1GcueHeBkNeGqW6z5Vr9jX2a9px47dvGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLdx+U8EKSvn5lmHBbaRjIRzSe2aI2snUuFACKqo3dNEKygpzRzGP5je772LqfGGW
	 PAQ4lo4aPMpETEBoLLQglzeNFszaCfsiXH7u3YnGxWpHptO+tmQ7aSggUb4EBOHOxi
	 ZrZjMgzMDjjqzM0x8PTOazPqEpn69xBgcz5ZhVAo=
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
Subject: [PATCH v19 4/7] firmware: arm_rmm: Add support for SRO
Date: Thu, 24 Sep 2026 14:51:58 +0100
Message-ID: <20260924135201.850038-5-suzuki.poulose@arm.com>
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

RMM v2.0 introduces the concept of "Stateful RMI Operations" (SRO). This
means that an SMC can return with an operation still in progress. The
host is expected to continue the operation until it reaches a conclusion
(either success or failure). During this process the RMM can request
additional memory ('donate') or hand memory back to the host
('reclaim'). The host can request an in progress operation is cancelled,
but still continue the operation until it has completed (otherwise the
incomplete operation may cause future RMM operations to fail).

The SRO is tracked using a struct rmi_sro_state object which keeps track
of any memory which has been allocated but not yet consumed by the RMM
or reclaimed from the RMM. This allows the memory to be reused in a
future request within the same operation. It will also permit an
operation to be done in a context where memory allocation may be
difficult (e.g. atomic context) with the option to abort the operation
and retry the memory allocation outside of the atomic context. The
memory stored in the struct rmi_sro_state object can then be reused on
the subsequent attempt.

Wrappers for SRO RMI commands are also provided here because they depend
on the rmi_sro_execute() implementation added by this patch.
Delegate/undelegate handles are also added here because they now use the
SRO/stateful command infrastructure and are also used for the memory
DONATE/RECLAIM flows.

Signed-off-by: Steven Price <steven.price@arm.com>
Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 v19:
  * Clamp the mem donate request count to RMI_MAX_ADDR_LIST to prevent overflow
    for non_contig requests
  * Donate gathered memory when sro list runs out of space for non_contig case
  * Add comments for rmi_delegate_range(), rmi_free_delegated_page()
  * Fix handling of buggy RMM for rmi_delegate_range()
  * Move rmi_granule_*delegate_range() closer to their callers.
  * Clarify the requirements for rmi_granule_delegate_range()
  * Fix return result to -ENXIO if the MEM_OP is unknown
  * Handle unsupported RMI_OP_MEM_CONDITIONAL
  * Rename "out" label to "mem_donate"
  * Switch to use while loop for rmi_sro_donate_noncontig(), add comments
    where we gather the cached entries
  * If we don't have capacity in the SRO object, try with what we managed to
    collect for non-contiguous requests
  * Switch to for() loop for allocation of granules
  * Add comment, make code reader friendly for the caching the remaining
    entries after the memory donate
  * Add documentation for rmi_sro_execute()

 v18:
  * Prevent overflow for donated_granules output from buggy RMM
  * Handle corrupted addr_count in the sro
  * Avoid spilling literal pools on stack with sro initialisation
  * Handle buggy RMM when the out_top is not changed with RMI_SUCCESS
    for delegat/undelegate range calls
  * Rename free_delegated_page => rmi_free_delegated_page
  * Rename donate_req_to_unit_size => donate_req_to_block_size
  * Introduce rmi_addr_block_size_to_bytes() helper to convert a RmiAddrBlockSize
    encoding used in RMI_DONATE_REQ and RMI_ADDR_RANGE Descriptors, replaces
    donate_req_to_unit_size()
  * Rename unit_size => block_size_fld, unit_size_bytes => block_size etc.
  * Explicitly check for MEM_CONTIG/CAN_CANCEL fields to match the RMM spec values.
  * Rename free_delegated_page => rmi_free_delegated_page()
  * Drop RMI_BUSY, RMI_BLOCKED checks from rmi_*delegate_range as they are already
    handled by the rmi_smccc_invoke() used by the SRO.
  * Add a helper to free an address range entry, which may be partially consumed.
  * Ensure RMI_OP_RECLAIM output is valid before consumption
 v17:
  * Handle buggy RMM firmware to avoid looping forever for non-cancellable SROs.
  * Add comment (for the AI agents) to clarify that all memory donating SROs are
    cancellable.
 v16:
  * Wrappers for realm guests split into a separate patch.
  * Better support for cancellation - previously a cancelled operation
    could be treated as successful.
  * Consistently use a signed type for wrapper return values so that
    Linux error codes can be returned as well as RMI return values.
 v15:
  * Wrappers for SRO RMI functions are provided in this patch due to
    their dependency on the SRO infrastructure.
  * Fold the range delegate/undelegate wrappers into this patch because
    they depend on the stateful command infrastructure.
  * Add cpu_relax() calls when RMI_BUSY/RMI_BLOCKED is returned.
  * Various fixes.
 v14:
  * SRO support has improved although is still not fully complete. The
    infrastructure has been moved out of KVM.
---
 drivers/firmware/arm_rmm/rmi.c | 666 +++++++++++++++++++++++++++++++++
 include/linux/arm-rmi-cmds.h   |  41 ++
 2 files changed, 707 insertions(+)

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index c9ea964fd9081..035f21d3f26b6 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -14,6 +14,672 @@
 /* RMM defines RmiFeatureRegister0 to RmiFeatureRegister5. */
 static unsigned long rmi_feat_reg_cache[5] __ro_after_init;
 
+/**
+ * rmi_granule_range_undelegate() - Undelegate a range of granules
+ * @base: Base PA of the target range
+ * @top: Top PA of the target range
+ * @out_top: Returns the top PA of range whose state is undelegated
+ *
+ * Undelegate a range of granules to allow use by the normal world. Will fail
+ * if the granules are in use by RMM. RMM can ignore granules that are already
+ * undelegated and thus is safe to be called on a range with a mix of delegated
+ * and undelegated granules.
+ *
+ * Return: 0 on success, positive RMI result code or negative Linux error code
+ */
+static inline long rmi_granule_range_undelegate(unsigned long base,
+						unsigned long top,
+						unsigned long *out_top)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_GRANULE_RANGE_UNDELEGATE, base, top
+	};
+	long ret = rmi_sro_execute(&regs);
+
+	if (ret == RMI_SUCCESS && out_top)
+		*out_top = regs.a1;
+
+	return ret;
+}
+
+int rmi_undelegate_range(phys_addr_t phys,
+			 unsigned long size)
+{
+	long ret = 0;
+	unsigned long top = phys + size;
+	unsigned long out_top;
+
+	while (phys < top) {
+		ret = rmi_granule_range_undelegate(phys, top, &out_top);
+
+		if (ret == RMI_SUCCESS) {
+			/* Buggy RMM ? Let the caller leak the pages */
+			if (WARN_ON(out_top <= phys))
+				return -ENXIO;
+			phys = out_top;
+		} else {
+			break;
+		}
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(rmi_undelegate_range);
+
+/**
+ * rmi_granule_range_delegate() - Delegate granules
+ * @base: PA of the first granule of the range
+ * @top: PA of the first granule after the range
+ * @out_top: PA of the first granule not delegated
+ *
+ * Delegate a range of granule for use by the realm world. If the entire range
+ * was delegated then @out_top == @top, otherwise the function should be called
+ * again with @base == @out_top.
+ *
+ * Return: 0 on success, positive RMI result code or negative Linux error code
+ */
+static long rmi_granule_range_delegate(unsigned long base,
+				       unsigned long top,
+				       unsigned long *out_top)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_GRANULE_RANGE_DELEGATE, base, top
+	};
+	long ret = rmi_sro_execute(&regs);
+
+	if (ret == RMI_SUCCESS && out_top)
+		*out_top = regs.a1;
+
+	return ret;
+}
+
+/*
+ * rmi_delegate_range: Delegate a physically contiguous range.
+ * We iterate over the range until we hit an error. So we may
+ * return an error, but with a partially delegated range. The
+ * caller must always look at the @out_phys to figure out, how
+ * much progress was made.
+ *
+ * @phys:	Base of the physical address range
+ * @size:	Size of the physical address range
+ * @out_phys:	Top of the range that was completed. This is always
+ *		valid, irrespective of the result.
+ *
+ * Returns RMI_SUCCESS on successful completion. Otherwise, returns
+ * the Linux error number or the RMI status code as described
+ * by the RMM spec for RMI_GRANULE_DELEGATE_RANGE or RMI_BLOCKED.
+ */
+int rmi_delegate_range(phys_addr_t phys,
+		       unsigned long size,
+		       phys_addr_t *out_phys)
+{
+	long ret = 0;
+	unsigned long top = phys + size;
+	unsigned long out_top;
+
+	while (phys < top) {
+		ret = rmi_granule_range_delegate(phys, top, &out_top);
+
+		if (ret == RMI_SUCCESS) {
+			/*
+			 * Buggy RMM ? Let the caller handle the failure.
+			 * We can't know how far the RMM delegated in this
+			 * iteration, so we return the best known good limit.
+			 * RMM can deal with granules already in "undelegated"
+			 * in a given range. So, it is fine for the caller to
+			 * try the range we return.
+			 */
+			if (WARN_ON(out_top <= phys)) {
+				ret = -ENXIO;
+				break;
+			}
+			phys = out_top;
+		} else {
+			break;
+		}
+	}
+
+	if (out_phys)
+		*out_phys = phys;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(rmi_delegate_range);
+
+/*
+ * Convert the RmiAddrBlockSize to actual size. This is used in RmiDonateReq
+ * and RmiAddrRangeDesc*.
+ */
+static unsigned long rmi_addr_block_size_to_bytes(unsigned long block_size_fld)
+{
+	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(3 - block_size_fld));
+}
+
+/*
+ * free_addr_range: Free memory described by the address range entry, which may
+ *		    be partially consumed by RMM.
+ *
+ * @entry: RMI_ADDR_RANGE descriptor
+ * @consumed_size: Page aligned size consumed by the RMM from the address range.
+ *
+ * If the state of the address is DELEGATED, undelegate it back, before freeing.
+ * Leaks the memory if we cannot undelegate the range.
+ */
+static void free_addr_range(unsigned long entry, unsigned long consumed_size)
+{
+	unsigned long phys = RMI_ADDR_RANGE_ADDR(entry);
+	unsigned long block_size_fld = RMI_ADDR_RANGE_BLOCK_SIZE(entry);
+	unsigned long count = RMI_ADDR_RANGE_COUNT(entry);
+	unsigned long state = RMI_ADDR_RANGE_STATE(entry);
+	unsigned long size = rmi_addr_block_size_to_bytes(block_size_fld) * count;
+
+	WARN_ON(!PAGE_ALIGNED(phys) || !PAGE_ALIGNED(consumed_size));
+
+	/* We shouldn't see this in reclaim path, leak it for now  */
+	if (WARN_ON(state == RMI_OP_MEM_CONDITIONAL))
+		return;
+
+	/* Adjust the address and size for partially consumed entry */
+	phys += consumed_size;
+	size -= consumed_size;
+	/*
+	 * Undelegate the pages back if required. If we can't
+	 * change them back, leak the pages.
+	 */
+	if (state == RMI_OP_MEM_DELEGATED &&
+	    WARN_ON(rmi_undelegate_range(phys, size)))
+		return;
+	free_pages_exact(phys_to_virt(phys), size);
+}
+
+static void rmi_op_continue(unsigned long sro_handle, unsigned long flags,
+			    struct arm_smccc_1_2_regs *out_regs)
+{
+	*out_regs = (struct arm_smccc_1_2_regs) {
+		SMC_RMI_OP_CONTINUE, sro_handle, flags
+	};
+
+	rmi_smccc_invoke(out_regs);
+}
+
+static void rmi_op_cancel(unsigned long sro_handle,
+			  struct arm_smccc_1_2_regs *out_regs)
+{
+	*out_regs = (struct arm_smccc_1_2_regs) {
+		SMC_RMI_OP_CANCEL, sro_handle
+	};
+
+	rmi_smccc_invoke(out_regs);
+}
+
+static void rmi_op_mem_donate(unsigned long sro_handle, unsigned long list_addr,
+			      unsigned long list_count, unsigned long flags,
+			      struct arm_smccc_1_2_regs *out_regs)
+{
+	*out_regs = (struct arm_smccc_1_2_regs) {
+		SMC_RMI_OP_MEM_DONATE, sro_handle, list_addr, list_count, flags
+	};
+
+	/*
+	 * The output donated count (a1) is always valid, irrespective
+	 * of the return result. i.e., 0 if there was an error
+	 */
+	rmi_smccc_invoke(out_regs);
+}
+
+static void rmi_op_mem_reclaim(unsigned long sro_handle,
+			       unsigned long list_addr,
+			       unsigned long list_count,
+			       struct arm_smccc_1_2_regs *out_regs)
+{
+	*out_regs = (struct arm_smccc_1_2_regs) {
+		SMC_RMI_OP_MEM_RECLAIM, sro_handle, list_addr, list_count
+	};
+
+	rmi_smccc_invoke(out_regs);
+}
+
+/*
+ * rmi_free_delegated_page: Undelegate and free a page that has been previously
+ * delegated to the Realm world. If we are unable to undelegate it, the page is
+ * leaked.
+ * NOTE: Do not use this helper if the page could be concurrently operated by
+ * another thread, as it may get leaked if the undelegation fails due to RMI_BLOCKED
+ */
+int rmi_free_delegated_page(phys_addr_t phys)
+{
+	if (WARN_ON_ONCE(rmi_undelegate_page(phys))) {
+		/* Undelegate failed: leak the page */
+		return -EBUSY;
+	}
+
+	free_page((unsigned long)phys_to_virt(phys));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rmi_free_delegated_page);
+
+static int rmi_sro_ensure_capacity(struct rmi_sro_state *sro,
+				   unsigned long count)
+{
+	if (WARN_ON_ONCE(sro->addr_count > RMI_MAX_ADDR_LIST))
+		return -EOVERFLOW;
+
+	if (count > RMI_MAX_ADDR_LIST - sro->addr_count)
+		return -ENOSPC;
+
+	return 0;
+}
+
+static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
+				 unsigned long sro_handle,
+				 unsigned long donatereq,
+				 struct arm_smccc_1_2_regs *out_regs,
+				 gfp_t gfp)
+{
+	unsigned long block_size_fld = RMI_DONATE_BLOCK_SIZE(donatereq);
+	unsigned long block_size = rmi_addr_block_size_to_bytes(block_size_fld);
+	unsigned long count = RMI_DONATE_COUNT(donatereq);
+	unsigned long state = RMI_DONATE_STATE(donatereq);
+	unsigned long size = block_size * count;
+	unsigned long addr_range;
+	unsigned long donated_granules;
+	unsigned long donated_size;
+	int ret;
+	void *virt;
+	phys_addr_t phys;
+
+	/*
+	 * The RMM specification requires contiguous allocations are always a
+	 * power of 2
+	 */
+	if (WARN_ON_ONCE(!is_power_of_2(size)))
+		return -EINVAL;
+
+	/* Reuse the cached address range if we have one */
+	for (int i = 0; i < sro->addr_count; i++) {
+		unsigned long entry = sro->addr_list[i];
+
+		if (RMI_ADDR_RANGE_BLOCK_SIZE(entry) == block_size_fld &&
+		    RMI_ADDR_RANGE_COUNT(entry) == count &&
+		    RMI_ADDR_RANGE_STATE(entry) == state &&
+		    IS_ALIGNED(RMI_ADDR_RANGE_ADDR(entry), size)) {
+			sro->addr_count--;
+			swap(sro->addr_list[sro->addr_count],
+			     sro->addr_list[i]);
+
+			goto mem_donate;
+		}
+	}
+
+	ret = rmi_sro_ensure_capacity(sro, 1);
+	if (ret)
+		return ret;
+
+	virt = alloc_pages_exact(size, gfp);
+	if (!virt)
+		return -ENOMEM;
+	phys = virt_to_phys(virt);
+
+	if (state == RMI_OP_MEM_DELEGATED) {
+		phys_addr_t delegated_phys;
+
+		if (rmi_delegate_range(phys, size, &delegated_phys)) {
+			if (!rmi_undelegate_range(phys, delegated_phys - phys))
+				free_pages_exact(virt, size);
+			return -ENXIO;
+		}
+	}
+
+	addr_range = phys & RMI_ADDR_RANGE_ADDR_MASK;
+	FIELD_MODIFY(RMI_ADDR_RANGE_BLOCK_SIZE_MASK, &addr_range, block_size_fld);
+	FIELD_MODIFY(RMI_ADDR_RANGE_COUNT_MASK, &addr_range, count);
+	FIELD_MODIFY(RMI_ADDR_RANGE_STATE_MASK, &addr_range, state);
+
+	sro->addr_list[sro->addr_count] = addr_range;
+
+mem_donate:
+	rmi_op_mem_donate(sro_handle,
+			  virt_to_phys(&sro->addr_list[sro->addr_count]), 1,
+			  0, out_regs);
+	donated_granules = out_regs->a1;
+
+	if (WARN_ON(donated_granules > (size >> PAGE_SHIFT)))
+		donated_granules = (size >> PAGE_SHIFT);
+
+	donated_size = donated_granules << PAGE_SHIFT;
+
+	/* All granules consumed by the RMM */
+	if (donated_size == size)
+		return 0;
+	/* No granules were consumed by the RMM, cache them */
+	if (donated_granules == 0) {
+		sro->addr_count++;
+		return 0;
+	}
+
+	/* The granules were partially consumed, reclaim the unused ones. */
+	free_addr_range(sro->addr_list[sro->addr_count], donated_size);
+
+	return 0;
+}
+
+static int rmi_sro_donate_noncontig(struct rmi_sro_state *sro,
+				    unsigned long sro_handle,
+				    unsigned long donatereq,
+				    struct arm_smccc_1_2_regs *out_regs,
+				    gfp_t gfp)
+{
+	unsigned long block_size_fld = RMI_DONATE_BLOCK_SIZE(donatereq);
+	unsigned long block_size = rmi_addr_block_size_to_bytes(block_size_fld);
+	unsigned long count = RMI_DONATE_COUNT(donatereq);
+	unsigned long state = RMI_DONATE_STATE(donatereq);
+	unsigned long found = 0;
+	unsigned long donated_granules;
+	unsigned long granules_per_block = block_size >> PAGE_SHIFT;
+	unsigned long consumed_blocks;
+	int addr_list_start = sro->addr_count;
+	int ret, i;
+
+	/*
+	 * Clamp the number of entries to the maximum we can do in one go.
+	 * The RMM can request  the remaining in the next iteration.
+	 */
+	if (count > RMI_MAX_ADDR_LIST)
+		count = RMI_MAX_ADDR_LIST;
+
+	/* Gather the suitable entries to the end of the list */
+	i = 0;
+	while (i <  addr_list_start && found < count) {
+		unsigned long entry = sro->addr_list[i];
+
+		if (RMI_ADDR_RANGE_BLOCK_SIZE(entry) == block_size_fld &&
+		    RMI_ADDR_RANGE_COUNT(entry) == 1 &&
+		    RMI_ADDR_RANGE_STATE(entry) == state) {
+			addr_list_start--;
+			swap(sro->addr_list[addr_list_start],
+			     sro->addr_list[i]);
+			found++;
+			/* Continue from the swapped in entry */
+			continue;
+		}
+		/* skip past the entry */
+		i++;
+	}
+
+	ret = rmi_sro_ensure_capacity(sro, count - found);
+	if (ret) {
+		/* If we have found some entries, donate them and try again */
+		if (found)
+			goto mem_donate;
+		/* Otherwise free up the list and start again */
+		rmi_sro_free(sro);
+		/* Reset the addr_list_start to match sro->addr_count */
+		addr_list_start = 0;
+	}
+
+	for (; found < count; found++) {
+		unsigned long addr_range;
+		void *virt = alloc_pages_exact(block_size, gfp);
+		phys_addr_t phys;
+
+		if (!virt)
+			return -ENOMEM;
+
+		phys = virt_to_phys(virt);
+
+		if (state == RMI_OP_MEM_DELEGATED) {
+			phys_addr_t delegated_phys;
+
+			if (rmi_delegate_range(phys, block_size, &delegated_phys)) {
+				if (!rmi_undelegate_range(phys, delegated_phys - phys))
+					free_pages_exact(virt, block_size);
+				return -ENXIO;
+			}
+		}
+
+		addr_range = phys & RMI_ADDR_RANGE_ADDR_MASK;
+		FIELD_MODIFY(RMI_ADDR_RANGE_BLOCK_SIZE_MASK, &addr_range, block_size_fld);
+		FIELD_MODIFY(RMI_ADDR_RANGE_COUNT_MASK, &addr_range, 1);
+		FIELD_MODIFY(RMI_ADDR_RANGE_STATE_MASK, &addr_range, state);
+
+		sro->addr_list[sro->addr_count++] = addr_range;
+	}
+
+mem_donate:
+	rmi_op_mem_donate(sro_handle,
+			  virt_to_phys(&sro->addr_list[addr_list_start]),
+			  found, 0, out_regs);
+
+	donated_granules = out_regs->a1;
+	/*
+	 * The RMM shouldn't report more granules than we provided, but clamp
+	 * just in case.
+	 */
+	if (WARN_ON_ONCE(donated_granules > found * granules_per_block))
+		donated_granules = found * granules_per_block;
+
+	/*
+	 * The RMM reports the consumed memory in terms of granules, but we
+	 * track in the address lists in block-sized ranges. So divide to get
+	 * the number of (complete) consumed blocks.
+	 */
+	consumed_blocks = donated_granules / granules_per_block;
+	if (donated_granules % granules_per_block) {
+		/*
+		 * A block has been partially consumed, the start is owned by
+		 * the RMM, the tail is owned by the host
+		 */
+		unsigned long entry =
+			sro->addr_list[addr_list_start + consumed_blocks];
+		unsigned long donated_size =
+			(donated_granules % granules_per_block) << PAGE_SHIFT;
+
+		free_addr_range(entry, donated_size);
+		/*
+		 * This block is now fully 'consumed' (either held by the RMM or
+		 * freed)
+		 */
+		consumed_blocks++;
+	}
+
+	/*
+	 * Keep just the blocks the RMM didn't use in addr_list
+	 * RMM claimed consumed_blocks entries from addr_list_start.
+	 * Move the entries left out at the end i.e.,
+	 * [ addr_list_start + consumed_blocks, addr_list_start + found)
+	 * to the rest of the valid entries and adjust the addr_count to
+	 * reflect the available entries.
+	 */
+	for (int i = 0, src = addr_list_start + consumed_blocks;
+		i < found - consumed_blocks; i++)
+		sro->addr_list[addr_list_start + i] = sro->addr_list[src + i];
+
+	sro->addr_count -= consumed_blocks;
+
+	return 0;
+}
+
+static int rmi_sro_donate(struct rmi_sro_state *sro,
+			  unsigned long sro_handle,
+			  unsigned long donatereq,
+			  struct arm_smccc_1_2_regs *regs,
+			  gfp_t gfp)
+{
+	if (WARN_ON_ONCE(!RMI_DONATE_COUNT(donatereq)))
+		return -EINVAL;
+
+	/*
+	 * We do not support RMI_OP_MEM_CONDITIONAL yet. This is only required
+	 * for use in RMI_GRANULE_TRACKING_SET, which we don't support yet.
+	 */
+	if (WARN_ON_ONCE(RMI_DONATE_STATE(donatereq) == RMI_OP_MEM_CONDITIONAL))
+		return -EINVAL;
+
+	if (RMI_DONATE_CONTIG(donatereq) == RMI_OP_MEM_CONTIG)
+		return rmi_sro_donate_contig(sro, sro_handle, donatereq, regs, gfp);
+	else
+		return rmi_sro_donate_noncontig(sro, sro_handle, donatereq, regs, gfp);
+}
+
+static int rmi_sro_reclaim(struct rmi_sro_state *sro,
+			   unsigned long sro_handle,
+			   struct arm_smccc_1_2_regs *out_regs)
+{
+	unsigned long capacity;
+
+	/*
+	 * We don't do a partial free of the entries. So for
+	 * now free the entire address list as we prepare
+	 * to reclaim more from the RMM.
+	 */
+	if (rmi_sro_ensure_capacity(sro, 1))
+		rmi_sro_free(sro);
+
+	capacity = RMI_MAX_ADDR_LIST - sro->addr_count;
+
+	rmi_op_mem_reclaim(sro_handle,
+			   virt_to_phys(&sro->addr_list[sro->addr_count]),
+			   capacity, out_regs);
+
+	/*
+	 * RMI_OP_MEM_RECLAIM always return RMI_INCOMPLETE, except when the
+	 * input parameters were invalid.
+	 */
+	if (WARN_ON_ONCE(RMI_RESULT_STATUS(out_regs->a0) != RMI_INCOMPLETE))
+		return -EINVAL;
+	if (WARN_ON_ONCE(out_regs->a1 > capacity))
+		out_regs->a1 = capacity;
+
+	sro->addr_count += out_regs->a1;
+
+	return 0;
+}
+
+void rmi_sro_free(struct rmi_sro_state *sro)
+{
+	/* Handle the worse */
+	if (WARN_ON(sro->addr_count < 0))
+		return;
+
+	if (WARN_ON(sro->addr_count > RMI_MAX_ADDR_LIST))
+		sro->addr_count = RMI_MAX_ADDR_LIST;
+
+	for (int i = 0; i < sro->addr_count; i++)
+		free_addr_range(sro->addr_list[i], 0);
+
+	sro->addr_count = 0;
+}
+EXPORT_SYMBOL_GPL(rmi_sro_free);
+
+long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp)
+{
+	struct arm_smccc_1_2_regs *regs = &sro->regs;
+	bool cancelled = false;
+	unsigned long sro_handle;
+
+	rmi_smccc_invoke(regs);
+
+	sro_handle = regs->a1;
+	while (RMI_RESULT_STATUS(regs->a0) == RMI_INCOMPLETE) {
+		bool can_cancel = RMI_RESULT_CAN_CANCEL(regs->a0) == RMI_OP_CAN_CANCEL;
+		int ret = 0;
+
+		switch (RMI_RESULT_MEMREQ(regs->a0)) {
+		case RMI_OP_MEM_REQ_NONE:
+			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
+					regs);
+			break;
+		case RMI_OP_MEM_REQ_DONATE:
+			ret = rmi_sro_donate(sro, sro_handle, regs->a2, regs,
+					     gfp);
+			break;
+		case RMI_OP_MEM_REQ_RECLAIM:
+			ret = rmi_sro_reclaim(sro, sro_handle, regs);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			ret = -ENXIO;
+			break;
+		}
+
+		if (ret) {
+			/*
+			 * All memory donating SROs must be cancellable. So a
+			 * failure in memory allocation shouldn't be an issue.
+			 * However, if we encounter a random failure (e.g.,
+			 * buggy RMM), don't loop forever, just give up.
+			 */
+			if (WARN_ON_ONCE(!can_cancel))
+				return ret;
+			/*
+			 * If we have already cancelled, and came back here due
+			 * to an error in MEMREQ, then there is no point
+			 * in going in loops.
+			 */
+			if (WARN_ON_ONCE(cancelled))
+				break;
+			rmi_op_cancel(sro_handle, regs);
+			cancelled = true;
+
+			if (WARN_ON_ONCE(RMI_RESULT_STATUS(regs->a0) != RMI_INCOMPLETE))
+				return ret;
+		}
+	}
+
+	if (cancelled)
+		return -ECANCELED;
+
+	return regs->a0;
+}
+EXPORT_SYMBOL_GPL(rmi_sro_memxfer_execute);
+
+/*
+ * rmi_sro_execute: Execute an RMI command that is Stateful but not memory
+ * tranfserring. Takes regs, filled with the FIDs and the arguments in place.
+ *
+ * Returns :
+ *  -ECANCELLED - If the operation had to be aborted and SRO was cancellable.
+ *  Otherwise, returns the result of the RMI command.
+ */
+long rmi_sro_execute(struct arm_smccc_1_2_regs *regs)
+{
+	bool cancelled = false;
+	unsigned long sro_handle = regs->a1;
+
+	rmi_smccc_invoke(regs);
+
+	sro_handle = regs->a1;
+	while (RMI_RESULT_STATUS(regs->a0) == RMI_INCOMPLETE) {
+		bool can_cancel = RMI_RESULT_CAN_CANCEL(regs->a0) == RMI_OP_CAN_CANCEL;
+
+		switch (RMI_RESULT_MEMREQ(regs->a0)) {
+		case RMI_OP_MEM_REQ_NONE:
+			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
+					regs);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			if (!can_cancel)
+				return regs->a0;
+			/*
+			 * We can't get here normally, but handle this anyway
+			 * for a buggy RMM implementation.
+			 */
+			if (cancelled)
+				return -ECANCELED;
+			rmi_op_cancel(sro_handle, regs);
+			cancelled = true;
+		}
+	}
+
+	if (cancelled)
+		return -ECANCELED;
+
+	return regs->a0;
+}
+EXPORT_SYMBOL_GPL(rmi_sro_execute);
+
 static int rmi_check_version(void)
 {
 	unsigned short version_major, version_minor;
diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
index 5c6c563c81555..b03974fd8168c 100644
--- a/include/linux/arm-rmi-cmds.h
+++ b/include/linux/arm-rmi-cmds.h
@@ -8,9 +8,19 @@
 
 #include <linux/arm-smccc-rmi.h>
 #include <linux/bug.h>
+#include <linux/gfp.h>
 #include <linux/processor.h>
+#include <linux/string.h>
 #include <linux/types.h>
 
+#define RMI_MAX_ADDR_LIST	256
+
+struct rmi_sro_state {
+	struct arm_smccc_1_2_regs regs;
+	int addr_count;
+	unsigned long addr_list[RMI_MAX_ADDR_LIST];
+};
+
 #define RMM_BLOCKED_RETRY_COUNT		2
 /*
  * rmi_smccc_invoke: Invoke the RMI call and return the results, retrying the
@@ -45,4 +55,35 @@ static inline void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs)
 
 unsigned long rmi_feat_reg(unsigned long index);
 
+int rmi_delegate_range(phys_addr_t phys, unsigned long size,
+		       phys_addr_t *out_phys);
+int rmi_undelegate_range(phys_addr_t phys, unsigned long size);
+int rmi_free_delegated_page(phys_addr_t phys);
+
+static inline int rmi_delegate_page(phys_addr_t phys)
+{
+	return rmi_delegate_range(phys, PAGE_SIZE, NULL);
+}
+
+static inline int rmi_undelegate_page(phys_addr_t phys)
+{
+	return rmi_undelegate_range(phys, PAGE_SIZE);
+}
+
+long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp);
+void rmi_sro_free(struct rmi_sro_state *sro);
+long rmi_sro_execute(struct arm_smccc_1_2_regs *regs);
+
+/*
+ * Resetting the addr_count is sufficient to ignore the addr_list contents.
+ */
+#define rmi_sro_memxfer_cmd(sro, gfp, ...) ({				\
+	struct rmi_sro_state *__sro = (sro);				\
+	__sro->addr_count = 0;						\
+	__sro->regs = (struct arm_smccc_1_2_regs){ __VA_ARGS__ };	\
+	long __ret = rmi_sro_memxfer_execute(__sro, gfp);		\
+	rmi_sro_free(__sro);						\
+	__ret;								\
+})
+
 #endif
-- 
2.43.0


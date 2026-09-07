Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05965468C3E;
	Mon,  7 Sep 2026 10:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788775214; cv=none; b=grZC8jTROnCg0D7jk2Vj5eE2vSyaCPIRMutwjK9CktP660XKPUD8s6l6j7zCn1xnL2o0zJKCbWNzQRDgtw+m/JcYsXK4f7lh2P88I9OD6L/8615GyiWeuH6Z4r1KhouywPTAGKjXuQ9xvXN8Z7DE1O9S5ADgmSmFb9C01p0T29c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788775214; c=relaxed/simple;
	bh=3BjSs7IhO3CkbsnIt5UUNVXIqKtZ0i/eG3y9UTd6ACY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPr+tsJRxoxEIA1Ncl89vQLyYR9xjs+gXS1QYezn2pPnCwhdvN5Aj3+cKUycpVEP7W6ilPNJKx/Dq+ToqL59poeyFxtwJDuqGX5/tEWRypFVtnwJz2DXIiLOCiGrcmKjjUvCuEdSbxTukQPRv2dKsJ0+oWFHwK8O5f2MqDZyRHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Jszne0ZL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Jszne0ZL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 819791477;
	Mon,  7 Sep 2026 03:00:07 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 537823F7B4;
	Mon,  7 Sep 2026 03:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788775211; bh=3BjSs7IhO3CkbsnIt5UUNVXIqKtZ0i/eG3y9UTd6ACY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jszne0ZLWBbsAPt7J1tyEC/JAURqnHnu0ZtQj31sWzARPrh4f+kdP7XFv2sb50zrf
	 ckiO9TOsQdsZs92IiKhxaIh7JkrAVi7E7nxTW2cCGrA+6YRYOTexH3MsFM7CWk7wru
	 siuZu2K8ZyOkxUKIIRJmtesWZvO5JsWuoj9SYh10=
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
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v17 4/7] firmware: arm_rmm: Add support for SRO
Date: Mon,  7 Sep 2026 10:59:38 +0100
Message-ID: <20260907095942.1140734-5-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907095942.1140734-1-suzuki.poulose@arm.com>
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
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
SRO/stateful command infrastructure.

Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
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
 drivers/firmware/arm_rmm/rmi.c | 508 +++++++++++++++++++++++++++++++++
 include/linux/arm-rmi-cmds.h   |  88 ++++++
 2 files changed, 596 insertions(+)

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index 76f91c145e1fd..42c973c3a98bb 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -6,6 +6,7 @@
 #include <linux/cpufeature.h>
 #include <linux/memblock.h>
 #include <linux/arm-rmi-cmds.h>
+#include <linux/processor.h>
 #include <linux/slab.h>
 
 #include <asm/memory.h>
@@ -24,6 +25,513 @@ unsigned long rmi_feat_reg(unsigned long id)
 }
 EXPORT_SYMBOL_GPL(rmi_feat_reg);
 
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
+		if (ret == RMI_SUCCESS)
+			phys = out_top;
+		else if (ret == RMI_BUSY || ret == RMI_BLOCKED)
+			cpu_relax();
+		else
+			break;
+	}
+
+	if (out_phys)
+		*out_phys = phys;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(rmi_delegate_range);
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
+		if (ret == RMI_SUCCESS)
+			phys = out_top;
+		else if (ret == RMI_BUSY || ret == RMI_BLOCKED)
+			cpu_relax();
+		else
+			break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(rmi_undelegate_range);
+
+static unsigned long donate_req_to_size(unsigned long donatereq)
+{
+	unsigned long unit_size = RMI_DONATE_SIZE(donatereq);
+
+	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(3 - unit_size));
+}
+
+static void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs_in,
+			     struct arm_smccc_1_2_regs *regs_out)
+{
+	struct arm_smccc_1_2_regs regs = *regs_in;
+	unsigned long status;
+
+	while (1) {
+		arm_smccc_1_2_invoke(&regs, regs_out);
+		status = RMI_RETURN_STATUS(regs_out->a0);
+		if (status != RMI_BUSY && status != RMI_BLOCKED)
+			break;
+		cpu_relax();
+	}
+}
+
+static void rmi_op_continue(unsigned long sro_handle, unsigned long flags,
+			    struct arm_smccc_1_2_regs *out_regs)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_OP_CONTINUE, sro_handle, flags
+	};
+
+	rmi_smccc_invoke(&regs, out_regs);
+}
+
+static void rmi_op_cancel(unsigned long sro_handle,
+			  struct arm_smccc_1_2_regs *out_regs)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_OP_CANCEL, sro_handle
+	};
+
+	rmi_smccc_invoke(&regs, out_regs);
+}
+
+static void rmi_op_mem_donate(unsigned long sro_handle, unsigned long list_addr,
+			      unsigned long list_count, unsigned long flags,
+			      struct arm_smccc_1_2_regs *out_regs)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_OP_MEM_DONATE, sro_handle, list_addr, list_count, flags
+	};
+
+	/*
+	 * The output donated count (a1) is always valid, irrespective
+	 * of the return result. i.e., 0 if there was an error
+	 */
+	rmi_smccc_invoke(&regs, out_regs);
+}
+
+static void rmi_op_mem_reclaim(unsigned long sro_handle,
+			       unsigned long list_addr,
+			       unsigned long list_count,
+			       struct arm_smccc_1_2_regs *out_regs)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_OP_MEM_RECLAIM, sro_handle, list_addr, list_count
+	};
+
+	rmi_smccc_invoke(&regs, out_regs);
+}
+
+int free_delegated_page(phys_addr_t phys)
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
+EXPORT_SYMBOL_GPL(free_delegated_page);
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
+	unsigned long unit_size = RMI_DONATE_SIZE(donatereq);
+	unsigned long unit_size_bytes = donate_req_to_size(donatereq);
+	unsigned long count = RMI_DONATE_COUNT(donatereq);
+	unsigned long state = RMI_DONATE_STATE(donatereq);
+	unsigned long size = unit_size_bytes * count;
+	unsigned long addr_range;
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
+	for (int i = 0; i < sro->addr_count; i++) {
+		unsigned long entry = sro->addr_list[i];
+
+		if (RMI_ADDR_RANGE_SIZE(entry) == unit_size &&
+		    RMI_ADDR_RANGE_COUNT(entry) == count &&
+		    RMI_ADDR_RANGE_STATE(entry) == state &&
+		    IS_ALIGNED(RMI_ADDR_RANGE_ADDR(entry), size)) {
+			sro->addr_count--;
+			swap(sro->addr_list[sro->addr_count],
+			     sro->addr_list[i]);
+
+			goto out;
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
+	FIELD_MODIFY(RMI_ADDR_RANGE_SIZE_MASK, &addr_range, unit_size);
+	FIELD_MODIFY(RMI_ADDR_RANGE_COUNT_MASK, &addr_range, count);
+	FIELD_MODIFY(RMI_ADDR_RANGE_STATE_MASK, &addr_range, state);
+
+	sro->addr_list[sro->addr_count] = addr_range;
+
+out:
+	rmi_op_mem_donate(sro_handle,
+			  virt_to_phys(&sro->addr_list[sro->addr_count]), 1,
+			  0, out_regs);
+
+	unsigned long donated_granules = out_regs->a1;
+	unsigned long donated_size = donated_granules << PAGE_SHIFT;
+
+	if (donated_granules == 0) {
+		/* No pages used by the RMM */
+		sro->addr_count++;
+	} else if (donated_size < size) {
+		phys = sro->addr_list[sro->addr_count] & RMI_ADDR_RANGE_ADDR_MASK;
+
+		/* Not all granules used by the RMM, free the remaining pages */
+		for (long i = donated_size; i < size; i += PAGE_SIZE) {
+			if (state == RMI_OP_MEM_DELEGATED)
+				free_delegated_page(phys + i);
+			else
+				__free_page(phys_to_page(phys + i));
+		}
+	}
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
+	unsigned long unit_size = RMI_DONATE_SIZE(donatereq);
+	unsigned long unit_size_bytes = donate_req_to_size(donatereq);
+	unsigned long count = RMI_DONATE_COUNT(donatereq);
+	unsigned long state = RMI_DONATE_STATE(donatereq);
+	unsigned long found = 0;
+	unsigned long addr_list_start = sro->addr_count;
+	int ret;
+
+	for (int i = 0; i < addr_list_start && found < count; i++) {
+		unsigned long entry = sro->addr_list[i];
+
+		if (RMI_ADDR_RANGE_SIZE(entry) == unit_size &&
+		    RMI_ADDR_RANGE_COUNT(entry) == 1 &&
+		    RMI_ADDR_RANGE_STATE(entry) == state) {
+			addr_list_start--;
+			swap(sro->addr_list[addr_list_start],
+			     sro->addr_list[i]);
+			found++;
+			i--;
+		}
+	}
+
+	ret = rmi_sro_ensure_capacity(sro, count - found);
+	if (ret)
+		return ret;
+
+	while (found < count) {
+		unsigned long addr_range;
+		void *virt = alloc_pages_exact(unit_size_bytes, gfp);
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
+			if (rmi_delegate_range(phys, unit_size_bytes,
+					       &delegated_phys)) {
+				if (!rmi_undelegate_range(phys, delegated_phys - phys))
+					free_pages_exact(virt, unit_size_bytes);
+				return -ENXIO;
+			}
+		}
+
+		addr_range = phys & RMI_ADDR_RANGE_ADDR_MASK;
+		FIELD_MODIFY(RMI_ADDR_RANGE_SIZE_MASK, &addr_range, unit_size);
+		FIELD_MODIFY(RMI_ADDR_RANGE_COUNT_MASK, &addr_range, 1);
+		FIELD_MODIFY(RMI_ADDR_RANGE_STATE_MASK, &addr_range, state);
+
+		sro->addr_list[sro->addr_count++] = addr_range;
+		found++;
+	}
+
+	rmi_op_mem_donate(sro_handle,
+			  virt_to_phys(&sro->addr_list[addr_list_start]),
+			  found, 0, out_regs);
+
+	unsigned long donated_granules = out_regs->a1;
+	unsigned long granules_per_unit = unit_size_bytes >> PAGE_SHIFT;
+	unsigned long consumed_units;
+
+	/*
+	 * The RMM shouldn't report more granules than we provided, but clamp
+	 * just in case.
+	 */
+	if (WARN_ON_ONCE(donated_granules > found * granules_per_unit))
+		donated_granules = found * granules_per_unit;
+
+	/*
+	 * The RMM reports the consumed memory in terms of granules, but we
+	 * track in the address lists in unit-sized ranges. So divide to get
+	 * the number of (complete) consumed units.
+	 */
+	consumed_units = donated_granules / granules_per_unit;
+	if (donated_granules % granules_per_unit) {
+		/*
+		 * A unit has been partially consumed, the start is owned by
+		 * the RMM, the tail is owned by the host
+		 */
+		unsigned long entry =
+			sro->addr_list[addr_list_start + consumed_units];
+		phys_addr_t phys = RMI_ADDR_RANGE_ADDR(entry);
+		unsigned long donated_size =
+			(donated_granules % granules_per_unit) << PAGE_SHIFT;
+
+		/* Free the tail back */
+		for (unsigned long i = donated_size; i < unit_size_bytes;
+		     i += PAGE_SIZE) {
+			if (state == RMI_OP_MEM_DELEGATED)
+				free_delegated_page(phys + i);
+			else
+				__free_page(phys_to_page(phys + i));
+		}
+
+		/*
+		 * This unit is now fully 'consumed' (either held by the RMM or
+		 * freed)
+		 */
+		consumed_units++;
+	}
+
+	/* Keep just the units the RMM didn't use in addr_list */
+	for (unsigned long i = consumed_units; i < found; i++)
+		sro->addr_list[addr_list_start + i - consumed_units] =
+			sro->addr_list[addr_list_start + i];
+
+	sro->addr_count -= consumed_units;
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
+	if (RMI_DONATE_CONTIG(donatereq)) {
+		return rmi_sro_donate_contig(sro, sro_handle, donatereq,
+					     regs, gfp);
+	} else {
+		return rmi_sro_donate_noncontig(sro, sro_handle, donatereq,
+						regs, gfp);
+	}
+}
+
+static int rmi_sro_reclaim(struct rmi_sro_state *sro,
+			   unsigned long sro_handle,
+			   struct arm_smccc_1_2_regs *out_regs)
+{
+	unsigned long capacity;
+	int ret;
+
+	ret = rmi_sro_ensure_capacity(sro, 1);
+	if (ret)
+		rmi_sro_free(sro);
+
+	capacity = RMI_MAX_ADDR_LIST - sro->addr_count;
+
+	rmi_op_mem_reclaim(sro_handle,
+			   virt_to_phys(&sro->addr_list[sro->addr_count]),
+			   capacity, out_regs);
+
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
+	for (int i = 0; i < sro->addr_count; i++) {
+		unsigned long entry = sro->addr_list[i];
+		unsigned long addr = RMI_ADDR_RANGE_ADDR(entry);
+		unsigned long unit_size = RMI_ADDR_RANGE_SIZE(entry);
+		unsigned long count = RMI_ADDR_RANGE_COUNT(entry);
+		unsigned long state = RMI_ADDR_RANGE_STATE(entry);
+		unsigned long size = donate_req_to_size(unit_size) * count;
+
+		if (state == RMI_OP_MEM_DELEGATED) {
+			if (WARN_ON_ONCE(rmi_undelegate_range(addr, size))) {
+				/* Leak the pages */
+				continue;
+			}
+		}
+		free_pages_exact(phys_to_virt(addr), size);
+	}
+
+	sro->addr_count = 0;
+}
+EXPORT_SYMBOL_GPL(rmi_sro_free);
+
+long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp)
+{
+	unsigned long sro_handle;
+	struct arm_smccc_1_2_regs *regs = &sro->regs;
+	bool cancelled = false;
+
+	rmi_smccc_invoke(regs, regs);
+
+	sro_handle = regs->a1;
+
+	while (RMI_RETURN_STATUS(regs->a0) == RMI_INCOMPLETE) {
+		bool can_cancel = RMI_RETURN_CAN_CANCEL(regs->a0);
+		int ret = 0;
+
+		switch (RMI_RETURN_MEMREQ(regs->a0)) {
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
+			ret = WARN_ON_ONCE(1);
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
+
+			rmi_op_cancel(sro_handle, regs);
+			cancelled = true;
+
+			if (WARN_ON_ONCE(RMI_RETURN_STATUS(regs->a0) != RMI_INCOMPLETE))
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
+/* For RMI commands that are stateful but not memory-transferring */
+long rmi_sro_execute(struct arm_smccc_1_2_regs *regs)
+{
+	unsigned long sro_handle;
+	bool cancelled = false;
+
+	rmi_smccc_invoke(regs, regs);
+
+	sro_handle = regs->a1;
+
+	while (RMI_RETURN_STATUS(regs->a0) == RMI_INCOMPLETE) {
+		bool can_cancel = RMI_RETURN_CAN_CANCEL(regs->a0);
+
+		switch (RMI_RETURN_MEMREQ(regs->a0)) {
+		case RMI_OP_MEM_REQ_NONE:
+			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
+					regs);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			if (!can_cancel)
+				return regs->a0;
+
+			cancelled = true;
+			rmi_op_cancel(sro_handle, regs);
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
 	struct arm_smccc_res res;
diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
index 9aa27697e2377..fed0f3421895d 100644
--- a/include/linux/arm-rmi-cmds.h
+++ b/include/linux/arm-rmi-cmds.h
@@ -10,8 +10,43 @@
 #include <linux/bug.h>
 #include <linux/types.h>
 
+#define RMI_MAX_ADDR_LIST	256
+
+struct rmi_sro_state {
+	struct arm_smccc_1_2_regs regs;
+	unsigned long addr_count;
+	unsigned long addr_list[RMI_MAX_ADDR_LIST];
+};
+
 unsigned long rmi_feat_reg(unsigned long id);
 
+int rmi_delegate_range(phys_addr_t phys, unsigned long size,
+		       phys_addr_t *out_phys);
+int rmi_undelegate_range(phys_addr_t phys, unsigned long size);
+int free_delegated_page(phys_addr_t phys);
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
+#define rmi_sro_memxfer_cmd(sro, gfp, ...) ({				\
+	struct rmi_sro_state *__sro = (sro);				\
+	*__sro = (struct rmi_sro_state){ .regs = {__VA_ARGS__} };	\
+	long __ret = rmi_sro_memxfer_execute(__sro, gfp);		\
+	rmi_sro_free(__sro);						\
+	__ret;								\
+})
+
 /**
  * rmi_rmm_config_set() - Configure the RMM
  * @cfg_ptr: PA of a struct rmm_config
@@ -48,4 +83,57 @@ static inline int rmi_features(unsigned long index, unsigned long *out)
 	return res.a0;
 }
 
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
+static inline long rmi_granule_range_delegate(unsigned long base,
+					      unsigned long top,
+					      unsigned long *out_top)
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
+/**
+ * rmi_granule_range_undelegate() - Undelegate a range of granules
+ * @base: Base PA of the target range
+ * @top: Top PA of the target range
+ * @out_top: Returns the top PA of range whose state is undelegated
+ *
+ * Undelegate a range of granules to allow use by the normal world. Will fail if
+ * the granules are in use.
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
 #endif
-- 
2.43.0


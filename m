Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9C33369D54;
	Fri, 31 Jul 2026 18:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785522343; cv=none; b=l0c05gime/AbA+gLVtytw6OQl+KciefO7aB+/MIY//gpvqbh8kqo4FMN6bq1Y7XN5xbXZkDSlIoU00X2N+dL6vwFCYv7uAjJPY6e7jcZ9t3i7tLPZr7CdwYia5N/VMAMohjb5tY7tO9E7VJ3RpAFRL4pm0JMYH8X7P5DiXoQZJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785522343; c=relaxed/simple;
	bh=Fk8B+Pduq/Umd1AuJQEpBBkJ75M82MRArJWNWlQQ3hk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F3O/eDS1OBkQKi8W788DNj3qpxfGk3JJPw3lSBXlpvF/2XBhIPSdUozSmhfx5QqVCQEExzkyBsNwK+CFneMkye8EBe2G/ecwc/GBZpPeBXReRZSRb+uCn/dU5HyZ0qu4ZrRKKqSCKx7kehRCNLbc/Kfx4JoLISf1XBWN1keoIXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EpTo3SPv; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EpTo3SPv"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B971C204C;
	Fri, 31 Jul 2026 11:25:33 -0700 (PDT)
Received: from [10.57.41.95] (unknown [10.57.41.95])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CD98D3F86F;
	Fri, 31 Jul 2026 11:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785522337; bh=Fk8B+Pduq/Umd1AuJQEpBBkJ75M82MRArJWNWlQQ3hk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EpTo3SPvJRCnit/TJ6V5YputDuyD9upCEIsmkvNFREaZamgMRk2y2jpE9rgpBF4zx
	 tixRrx51DpUaRlPxPcdvQwfCD3Bpb4NFoxfpjKnQkw2uGsVIjqVffVdozmr7oiFIUL
	 3rTGn8JziFaAuCOxzBBsdZ9drjCBAE3FeUCdKlHQ=
Message-ID: <a694a1d3-d8d8-4167-9f77-6d9d1e86254f@arm.com>
Date: Fri, 31 Jul 2026 19:25:33 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] firmware: arm_rmm: Add support for SRO
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260715142739.80398-1-steven.price@arm.com>
 <20260715142739.80398-6-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260715142739.80398-6-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven


I have left some minor comments below. Otherwise looks good to me.

On 15/07/2026 15:27, Steven Price wrote:
> RMM v2.0 introduces the concept of "Stateful RMI Operations" (SRO). This
> means that an SMC can return with an operation still in progress. The
> host is expected to continue the operation until it reaches a conclusion
> (either success or failure). During this process the RMM can request
> additional memory ('donate') or hand memory back to the host
> ('reclaim'). The host can request an in progress operation is cancelled,
> but still continue the operation until it has completed (otherwise the
> incomplete operation may cause future RMM operations to fail).
> 
> The SRO is tracked using a struct rmi_sro_state object which keeps track
> of any memory which has been allocated but not yet consumed by the RMM
> or reclaimed from the RMM. This allows the memory to be reused in a
> future request within the same operation. It will also permit an
> operation to be done in a context where memory allocation may be
> difficult (e.g. atomic context) with the option to abort the operation
> and retry the memory allocation outside of the atomic context. The
> memory stored in the struct rmi_sro_state object can then be reused on
> the subsequent attempt.
> 
> Wrappers for SRO RMI commands are also provided here because they depend
> on the rmi_sro_execute() implementation added by this patch.
> Delegate/undelegate handles are also added here because they now use the
> SRO/stateful command infrastructure.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> v15:
>   * Wrappers for SRO RMI functions are provided in this patch due to
>     their dependency on the SRO infrastructure.
>   * Fold the range delegate/undelegate wrappers into this patch because
>     they depend on the stateful command infrastructure.
>   * Add cpu_relax() calls when RMI_BUSY/RMI_BLOCKED is returned.
>   * Various fixes.
> v14:
>   * SRO support has improved although is still not fully complete. The
>     infrastructure has been moved out of KVM.
> ---
>   arch/arm64/include/asm/rmi_cmds.h | 392 ++++++++++++++++++++++++
>   drivers/firmware/arm_rmm/rmi.c    | 491 +++++++++++++++++++++++++++++-
>   include/linux/arm-rmi-cmds.h      | 114 +++++++
>   3 files changed, 996 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
> index 7eb2c8d7f7fa..f13ecdb40ded 100644
> --- a/arch/arm64/include/asm/rmi_cmds.h
> +++ b/arch/arm64/include/asm/rmi_cmds.h
> @@ -9,6 +9,102 @@
>   #include <linux/arm-rmi-cmds.h>
>   #include <linux/arm-smccc-rmi.h>


--8>--


> + * rmi_rtt_data_map_init() - Create a protected mapping with data contents

> + * rmi_rtt_data_map() - Create mappings in protected IPA with unknown contents

> + * rmi_rtt_data_unmap() - Remove mappings to conventional memory

>    * rmi_psci_complete() - Complete pending PSCI command


> + * rmi_realm_create() - Create a realm

> + * rmi_realm_terminate() - Terminate a realm

> + * rmi_realm_destroy() - Destroy a realm

> + * rmi_rec_create() - Create a REC

> + * rmi_rec_destroy() - Destroy a REC

> + * rmi_rtt_create() - Creates an RTT

> + * rmi_rtt_destroy() - Destroy an RTT

> + * rmi_rtt_fold() - Fold an RTT

> + * rmi_rtt_init_ripas() - Set RIPAS for new realm

> + * rmi_rtt_unprot_map() - Map unprotected granules into a realm

> + * rmi_rtt_set_ripas() - Set RIPAS for an running realm

> + * rmi_rtt_unprot_unmap() - Remove mappings within an unprotected IPA range
...

--<8--


All of the above wrappers seems to be the Realm VM related ones. Could
we move them to the KVM support patches ? They kind of look out of place
here ?  That way we can maintain the logical separation of the series's
from that of the KVM support ?


> +
>   #endif /* __ASM_RMI_CMDS_H */
> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
> index e7ab4a7df3ca..6a9f61760fd7 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c
> @@ -6,6 +6,7 @@
>   #include <linux/cpufeature.h>
>   #include <linux/memblock.h>
>   #include <linux/arm-rmi-cmds.h>
> +#include <linux/processor.h>
>   #include <linux/slab.h>
>   
>   #include <asm/memory.h>
> @@ -22,6 +23,487 @@ unsigned long rmi_feat_reg(unsigned long id)
>   
>   	return rmi_feat_reg_cache[id];
>   }
> +EXPORT_SYMBOL_GPL(rmi_feat_reg);
> +

This looks like should be part of the patch which introduced rmi_feat_reg?

> +int rmi_delegate_range(phys_addr_t phys,
> +		       unsigned long size,
> +		       phys_addr_t *out_phys)
> +{
> +	unsigned long ret = 0;
> +	unsigned long top = phys + size;
> +	unsigned long out_top;
> +
> +	while (phys < top) {
> +		ret = rmi_granule_range_delegate(phys, top, &out_top);
> +		if (ret == RMI_SUCCESS)
> +			phys = out_top;
> +		else if (ret == RMI_BUSY || ret == RMI_BLOCKED)
> +			cpu_relax();
> +		else
> +			break;
> +	}
> +
> +	if (out_phys)
> +		*out_phys = phys;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(rmi_delegate_range);
> +
> +int rmi_undelegate_range(phys_addr_t phys,
> +			 unsigned long size)
> +{
> +	unsigned long ret = 0;
> +	unsigned long top = phys + size;
> +	unsigned long out_top;
> +
> +	while (phys < top) {
> +		ret = rmi_granule_range_undelegate(phys, top, &out_top);
> +		if (ret == RMI_SUCCESS)
> +			phys = out_top;
> +		else if (ret == RMI_BUSY || ret == RMI_BLOCKED)
> +			cpu_relax();
> +		else
> +			break;
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(rmi_undelegate_range);
> +
> +static unsigned long donate_req_to_size(unsigned long donatereq)
> +{
> +	unsigned long unit_size = RMI_DONATE_SIZE(donatereq);
> +
> +	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(3 - unit_size));
> +}
> +
> +static void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs_in,
> +			     struct arm_smccc_1_2_regs *regs_out)
> +{
> +	struct arm_smccc_1_2_regs regs = *regs_in;
> +	unsigned long status;
> +
> +	while (1) {
> +		arm_smccc_1_2_invoke(&regs, regs_out);
> +		status = RMI_RETURN_STATUS(regs_out->a0);
> +		if (status != RMI_BUSY && status != RMI_BLOCKED)
> +			break;
> +		cpu_relax();
> +	}
> +}
> +
> +static void rmi_op_continue(unsigned long sro_handle, unsigned long flags,
> +			    struct arm_smccc_1_2_regs *out_regs)
> +{
> +	struct arm_smccc_1_2_regs regs = {
> +		SMC_RMI_OP_CONTINUE, sro_handle, flags
> +	};
> +
> +	rmi_smccc_invoke(&regs, out_regs);
> +}
> +
> +static void rmi_op_cancel(unsigned long sro_handle,
> +			  struct arm_smccc_1_2_regs *out_regs)
> +{
> +	struct arm_smccc_1_2_regs regs = {
> +		SMC_RMI_OP_CANCEL, sro_handle
> +	};
> +
> +	rmi_smccc_invoke(&regs, out_regs);
> +}
> +
> +static void rmi_op_mem_donate(unsigned long sro_handle, unsigned long list_addr,
> +			      unsigned long list_count, unsigned long flags,
> +			      struct arm_smccc_1_2_regs *out_regs)
> +{
> +	struct arm_smccc_1_2_regs regs = {
> +		SMC_RMI_OP_MEM_DONATE, sro_handle, list_addr, list_count, flags
> +	};
> +
> +	rmi_smccc_invoke(&regs, out_regs);
> +}
> +
> +static void rmi_op_mem_reclaim(unsigned long sro_handle,
> +			       unsigned long list_addr,
> +			       unsigned long list_count,
> +			       struct arm_smccc_1_2_regs *out_regs)
> +{
> +	struct arm_smccc_1_2_regs regs = {
> +		SMC_RMI_OP_MEM_RECLAIM, sro_handle, list_addr, list_count
> +	};
> +
> +	rmi_smccc_invoke(&regs, out_regs);
> +}
> +
> +int free_delegated_page(phys_addr_t phys)
> +{
> +	if (WARN_ON_ONCE(rmi_undelegate_page(phys))) {
> +		/* Undelegate failed: leak the page */
> +		return -EBUSY;
> +	}
> +
> +	free_page((unsigned long)phys_to_virt(phys));
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(free_delegated_page);
> +
> +static int rmi_sro_ensure_capacity(struct rmi_sro_state *sro,
> +				   unsigned long count)
> +{
> +	if (WARN_ON_ONCE(sro->addr_count > RMI_MAX_ADDR_LIST))
> +		return -EOVERFLOW;
> +
> +	if (count > RMI_MAX_ADDR_LIST - sro->addr_count)
> +		return -ENOSPC;
> +
> +	return 0;
> +}
> +
> +static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
> +				 unsigned long sro_handle,
> +				 unsigned long donatereq,
> +				 struct arm_smccc_1_2_regs *out_regs,
> +				 gfp_t gfp)
> +{
> +	unsigned long unit_size = RMI_DONATE_SIZE(donatereq);
> +	unsigned long unit_size_bytes = donate_req_to_size(donatereq);
> +	unsigned long count = RMI_DONATE_COUNT(donatereq);
> +	unsigned long state = RMI_DONATE_STATE(donatereq);
> +	unsigned long size = unit_size_bytes * count;
> +	unsigned long addr_range;
> +	int ret;
> +	void *virt;
> +	phys_addr_t phys;
> +
> +	for (int i = 0; i < sro->addr_count; i++) {
> +		unsigned long entry = sro->addr_list[i];
> +
> +		if (RMI_ADDR_RANGE_SIZE(entry) == unit_size &&
> +		    RMI_ADDR_RANGE_COUNT(entry) == count &&
> +		    RMI_ADDR_RANGE_STATE(entry) == state &&
> +		    IS_ALIGNED(RMI_ADDR_RANGE_ADDR(entry), size)) {
> +			sro->addr_count--;
> +			swap(sro->addr_list[sro->addr_count],
> +			     sro->addr_list[i]);
> +
> +			goto out;
> +		}
> +	}
> +
> +	ret = rmi_sro_ensure_capacity(sro, 1);
> +	if (ret)
> +		return ret;
> +
> +	virt = alloc_pages_exact(size, gfp);
> +	if (!virt)
> +		return -ENOMEM;
> +	phys = virt_to_phys(virt);
> +
> +	if (state == RMI_OP_MEM_DELEGATED) {
> +		phys_addr_t delegated_phys;
> +
> +		if (rmi_delegate_range(phys, size, &delegated_phys)) {
> +			if (!rmi_undelegate_range(phys, delegated_phys - phys))
> +				free_pages_exact(virt, size);
> +			return -ENXIO;
> +		}
> +	}
> +
> +	addr_range = phys & RMI_ADDR_RANGE_ADDR_MASK;
> +	FIELD_MODIFY(RMI_ADDR_RANGE_SIZE_MASK, &addr_range, unit_size);
> +	FIELD_MODIFY(RMI_ADDR_RANGE_COUNT_MASK, &addr_range, count);
> +	FIELD_MODIFY(RMI_ADDR_RANGE_STATE_MASK, &addr_range, state);
> +
> +	sro->addr_list[sro->addr_count] = addr_range;
> +
> +out:
> +	rmi_op_mem_donate(sro_handle,
> +			  virt_to_phys(&sro->addr_list[sro->addr_count]), 1,
> +			  0, out_regs);
> +
> +	unsigned long donated_granules = out_regs->a1;
> +	unsigned long donated_size = donated_granules << PAGE_SHIFT;

super minor nit: Some slightly older toolchains can't tolerate these
variable declarations. May be a good idea to move them to the top.


> +
> +	if (donated_granules == 0) {
> +		/* No pages used by the RMM */
> +		sro->addr_count++;
> +	} else if (donated_size < size) {
> +		phys = sro->addr_list[sro->addr_count] & RMI_ADDR_RANGE_ADDR_MASK;
> +
> +		/* Not all granules used by the RMM, free the remaining pages */
> +		for (long i = donated_size; i < size; i += PAGE_SIZE) {
> +			if (state == RMI_OP_MEM_DELEGATED)
> +				free_delegated_page(phys + i);
> +			else
> +				__free_page(phys_to_page(phys + i));
> +		}

super minor nit: This pattern is repeated below and may be wrapped into
a helper ?

> +	}
> +
> +	return 0;
> +}
> +
> +static int rmi_sro_donate_noncontig(struct rmi_sro_state *sro,
> +				    unsigned long sro_handle,
> +				    unsigned long donatereq,
> +				    struct arm_smccc_1_2_regs *out_regs,
> +				    gfp_t gfp)
> +{
> +	unsigned long unit_size = RMI_DONATE_SIZE(donatereq);
> +	unsigned long unit_size_bytes = donate_req_to_size(donatereq);
> +	unsigned long count = RMI_DONATE_COUNT(donatereq);
> +	unsigned long state = RMI_DONATE_STATE(donatereq);
> +	unsigned long found = 0;
> +	unsigned long addr_list_start = sro->addr_count;
> +	int ret;
> +
> +	for (int i = 0; i < addr_list_start && found < count; i++) {
> +		unsigned long entry = sro->addr_list[i];
> +
> +		if (RMI_ADDR_RANGE_SIZE(entry) == unit_size &&
> +		    RMI_ADDR_RANGE_COUNT(entry) == 1 &&
> +		    RMI_ADDR_RANGE_STATE(entry) == state) {
> +			addr_list_start--;
> +			swap(sro->addr_list[addr_list_start],
> +			     sro->addr_list[i]);
> +			found++;
> +			i--;
> +		}
> +	}
> +
> +	ret = rmi_sro_ensure_capacity(sro, count - found);
> +	if (ret)
> +		return ret;
> +
> +	while (found < count) {
> +		unsigned long addr_range;
> +		void *virt = alloc_pages_exact(unit_size_bytes, gfp);
> +		phys_addr_t phys;
> +
> +		if (!virt)
> +			return -ENOMEM;
> +
> +		phys = virt_to_phys(virt);
> +
> +		if (state == RMI_OP_MEM_DELEGATED) {
> +			phys_addr_t delegated_phys;
> +
> +			if (rmi_delegate_range(phys, unit_size_bytes,
> +					       &delegated_phys)) {
> +				if (!rmi_undelegate_range(phys, delegated_phys - phys))
> +					free_pages_exact(virt, unit_size_bytes);
> +				return -ENXIO;
> +			}
> +		}
> +
> +		addr_range = phys & RMI_ADDR_RANGE_ADDR_MASK;
> +		FIELD_MODIFY(RMI_ADDR_RANGE_SIZE_MASK, &addr_range, unit_size);
> +		FIELD_MODIFY(RMI_ADDR_RANGE_COUNT_MASK, &addr_range, 1);
> +		FIELD_MODIFY(RMI_ADDR_RANGE_STATE_MASK, &addr_range, state);
> +
> +		sro->addr_list[sro->addr_count++] = addr_range;
> +		found++;
> +	}
> +
> +	rmi_op_mem_donate(sro_handle,
> +			  virt_to_phys(&sro->addr_list[addr_list_start]),
> +			  found, 0, out_regs);
> +
> +	unsigned long donated_granules = out_regs->a1;
> +	unsigned long granules_per_unit = unit_size_bytes >> PAGE_SHIFT;
> +	unsigned long consumed_units;
> +
> +	/*
> +	 * The RMM shouldn't report more granules than we provided, but clamp
> +	 * just in case.
> +	 */
> +	if (WARN_ON_ONCE(donated_granules > found * granules_per_unit))
> +		donated_granules = found * granules_per_unit;
> +
> +	/*
> +	 * The RMM reports the consumed memory in terms of granules, but we
> +	 * track in the address lists in unit-sized ranges. So divide to get
> +	 * the number of (complete) consumed units.
> +	 */
> +	consumed_units = donated_granules / granules_per_unit;
> +	if (donated_granules % granules_per_unit) {
> +		/*
> +		 * A unit has been partially consumed, the start is owned by
> +		 * the RMM, the tail is owned by the host
> +		 */
> +		unsigned long entry =
> +			sro->addr_list[addr_list_start + consumed_units];
> +		phys_addr_t phys = RMI_ADDR_RANGE_ADDR(entry);
> +		unsigned long donated_size =
> +			(donated_granules % granules_per_unit) << PAGE_SHIFT;
> +
> +		/* Free the tail back */
> +		for (unsigned long i = donated_size; i < unit_size_bytes;
> +		     i += PAGE_SIZE) {
> +			if (state == RMI_OP_MEM_DELEGATED)
> +				free_delegated_page(phys + i);
> +			else
> +				__free_page(phys_to_page(phys + i));
> +		}
> +
> +		/*
> +		 * This unit is now fully 'consumed' (either held by the RMM or
> +		 * freed)
> +		 */
> +		consumed_units++;
> +	}
> +
> +	/* Keep just the units the RMM didn't use in addr_list */
> +	for (unsigned long i = consumed_units; i < found; i++)
> +		sro->addr_list[addr_list_start + i - consumed_units] =
> +			sro->addr_list[addr_list_start + i];
> +
> +	sro->addr_count -= consumed_units;
> +
> +	return 0;
> +}
> +
> +static int rmi_sro_donate(struct rmi_sro_state *sro,
> +			  unsigned long sro_handle,
> +			  unsigned long donatereq,
> +			  struct arm_smccc_1_2_regs *regs,
> +			  gfp_t gfp)
> +{
> +	unsigned long count = RMI_DONATE_COUNT(donatereq);
> +
> +	if (WARN_ON_ONCE(!count))
> +		return 0;

minor nit :
	if (WARN_ON_ONCE(!RMI_DONATE_COUNT(donatereq)))
		return 0;

and drop count ?

Suzuki

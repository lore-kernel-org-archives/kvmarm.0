Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D5A43D0BE4;
	Tue, 29 Sep 2026 12:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790686375; cv=none; b=XhvyXpQRCjKNlYYHY2bRYp9rMqng5g/9ITnna2J8evcYy2ia6AX7iMn0ZSw7UGkh0NSS7n5h/h7FNxHd6P8JcyL5XKA2et6PJRS6NSNx3VDEVIA3w9PwyiMtdnsS8M/8oIaOB/N0HF8wNcGiQT14qWOQsJkhJDx1XGFLLBWV53g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790686375; c=relaxed/simple;
	bh=f14FwFCPbKK3S35BKEnqQvZG/QOnL1SZdbFqwlLKR78=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hUjwdy+rWh48fqTxUlgxCeOm76P0BGHaHT/c5QKPdKGtgkQ5lqoSrwEBtVkHLU8HmjZeQq87qiKxfC0bpoBzfZSNY5CRoOeR3Ggp1cVyLo8B96O48dzIqi0UimNreDo6h2S8hZZYjKk9Y9vAvGbD7NsPK0cz6L262vihsRe+cyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=O1zil63e; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="O1zil63e"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 588EE1516;
	Tue, 29 Sep 2026 05:52:48 -0700 (PDT)
Received: from [10.57.12.116] (unknown [10.57.12.116])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0FEAF3FA1F;
	Tue, 29 Sep 2026 05:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790686371; bh=f14FwFCPbKK3S35BKEnqQvZG/QOnL1SZdbFqwlLKR78=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O1zil63e90lerYO4lVtEZzWYbHqj5s9wtkQw7E0YSF6B7pUVJnxOeCpoNVZLbTQIB
	 ExK6uP3rLjxrhvwWB50spviDuuYOwU3ug7Wqw2aaKi2sKPdtNSIs0cd0wk3PZ16x4Z
	 PEInoia2seSXa6mmYw58XYz0OuZr9maZO/wF3qqs=
Message-ID: <b1ed9abe-73f2-4100-9d27-c26bdafd6a31@arm.com>
Date: Tue, 29 Sep 2026 13:52:46 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 4/7] firmware: arm_rmm: Add support for SRO
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-5-suzuki.poulose@arm.com>
 <90f4d412-1499-4cc9-93b7-b735289fbe98@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <90f4d412-1499-4cc9-93b7-b735289fbe98@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Gavin

On 25/09/2026 06:24, Gavin Shan wrote:
> On 9/24/26 11:51 PM, Suzuki K Poulose wrote:
>> From: Steven Price <steven.price@arm.com>
>>
>> RMM v2.0 introduces the concept of "Stateful RMI Operations" (SRO). This
>> means that an SMC can return with an operation still in progress. The
>> host is expected to continue the operation until it reaches a conclusion
>> (either success or failure). During this process the RMM can request
>> additional memory ('donate') or hand memory back to the host
>> ('reclaim'). The host can request an in progress operation is cancelled,
>> but still continue the operation until it has completed (otherwise the
>> incomplete operation may cause future RMM operations to fail).
>>
>> The SRO is tracked using a struct rmi_sro_state object which keeps track
>> of any memory which has been allocated but not yet consumed by the RMM
>> or reclaimed from the RMM. This allows the memory to be reused in a
>> future request within the same operation. It will also permit an
>> operation to be done in a context where memory allocation may be
>> difficult (e.g. atomic context) with the option to abort the operation
>> and retry the memory allocation outside of the atomic context. The
>> memory stored in the struct rmi_sro_state object can then be reused on
>> the subsequent attempt.
>>
>> Wrappers for SRO RMI commands are also provided here because they depend
>> on the rmi_sro_execute() implementation added by this patch.
>> Delegate/undelegate handles are also added here because they now use the
>> SRO/stateful command infrastructure and are also used for the memory
>> DONATE/RECLAIM flows.

...

>>
> 
> Some nitpicks below. With them addressed:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>

Thank you, responses inline.

> 
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/ 
>> arm_rmm/rmi.c
>> index c9ea964fd9081..035f21d3f26b6 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
>> @@ -14,6 +14,672 @@
>>   /* RMM defines RmiFeatureRegister0 to RmiFeatureRegister5. */
>>   static unsigned long rmi_feat_reg_cache[5] __ro_after_init;
>> +/**

Dropped ** => *, to be consistent with the rest of the file.

>> + * rmi_granule_range_undelegate() - Undelegate a range of granules
>> + * @base: Base PA of the target range
>> + * @top: Top PA of the target range
>> + * @out_top: Returns the top PA of range whose state is undelegated
>> + *


>> +
>> +int rmi_undelegate_range(phys_addr_t phys,
>> +             unsigned long size)
>> +{
>> +    long ret = 0;
>> +    unsigned long top = phys + size;
>> +    unsigned long out_top;
>> +
>> +    while (phys < top) {
>> +        ret = rmi_granule_range_undelegate(phys, top, &out_top);
>> +
>> +        if (ret == RMI_SUCCESS) {
>> +            /* Buggy RMM ? Let the caller leak the pages */
>> +            if (WARN_ON(out_top <= phys))
>> +                return -ENXIO;
>> +            phys = out_top;
>> +        } else {
>> +            break;
>> +        }
>> +    }
> 
> Jonathan already suggested to avoid the unnecessary nested if statements:
> 
>          while (phys < top) {
>                  ret = rmi_granule_range_undelegate(phys, top, &out_top);
>                  if (ret != RMI_SUCCESS)
>                          break;
> 
>                  /* Buggy RMM ? Let the caller leak the pages */
>                  if (WARN_ON(out_top <= phys)) {
>                          ret = -ENXIO;
>                          break;
>                  }
> 
>                  phys = out_top;
>          }
> 

Yep, I have got this.

>> +
>> +    return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(rmi_undelegate_range);
>> +
>> +/**
> 
> "/**" -> "/*", to be consistent to what we have for rmi_delegate_range().
> 

Same here

>> + * rmi_granule_range_delegate() - Delegate granules
>> + * @base: PA of the first granule of the range
>> + * @top: PA of the first granule after the range
>> + * @out_top: PA of the first granule not delegated
>> + *
>> + * Delegate a range of granule for use by the realm world. If the 
>> entire range
>> + * was delegated then @out_top == @top, otherwise the function should 
>> be called
>> + * again with @base == @out_top.
>> + *
>> + * Return: 0 on success, positive RMI result code or negative Linux 
>> error code
>> + */
>> +static long rmi_granule_range_delegate(unsigned long base,
>> +                       unsigned long top,
>> +                       unsigned long *out_top)
>> +{
>> +    struct arm_smccc_1_2_regs regs = {
>> +        SMC_RMI_GRANULE_RANGE_DELEGATE, base, top
>> +    };
>> +    long ret = rmi_sro_execute(&regs);
>> +
>> +    if (ret == RMI_SUCCESS && out_top)
>> +        *out_top = regs.a1;
>> +
>> +    return ret;
>> +}
> 
> 'inline' is missed for rmi_granule_range_delegate() since its counterpart
> rmi_granule_range_undelegate() has 'inline' property.
> 
> static inline rmi_granule_range_delegate(unsigned long base,
>                       unsigned long top,
>                       unsigned long *out_top)

I have dropped "inline" for all, to let the compiler do its job.

> 
>> +
>> +/*
>> + * rmi_delegate_range: Delegate a physically contiguous range.
>> + * We iterate over the range until we hit an error. So we may
>> + * return an error, but with a partially delegated range. The
>> + * caller must always look at the @out_phys to figure out, how
>> + * much progress was made.
>> + *
>> + * @phys:    Base of the physical address range
>> + * @size:    Size of the physical address range
>> + * @out_phys:    Top of the range that was completed. This is always
>> + *        valid, irrespective of the result.
>> + *
>> + * Returns RMI_SUCCESS on successful completion. Otherwise, returns
>> + * the Linux error number or the RMI status code as described
>> + * by the RMM spec for RMI_GRANULE_DELEGATE_RANGE or RMI_BLOCKED.
>> + */
>> +int rmi_delegate_range(phys_addr_t phys,
>> +               unsigned long size,
>> +               phys_addr_t *out_phys)
>> +{
>> +    long ret = 0;
>> +    unsigned long top = phys + size;
>> +    unsigned long out_top;
>> +
>> +    while (phys < top) {
>> +        ret = rmi_granule_range_delegate(phys, top, &out_top);
>> +
>> +        if (ret == RMI_SUCCESS) {
>> +            /*
>> +             * Buggy RMM ? Let the caller handle the failure.
>> +             * We can't know how far the RMM delegated in this
>> +             * iteration, so we return the best known good limit.
>> +             * RMM can deal with granules already in "undelegated"
>> +             * in a given range. So, it is fine for the caller to
>> +             * try the range we return.
>> +             */
>> +            if (WARN_ON(out_top <= phys)) {
>> +                ret = -ENXIO;
>> +                break;
>> +            }
>> +            phys = out_top;
>> +        } else {
>> +            break;
>> +        }
>> +    }
> 
> The unecessary nested if statements can be avoided:
> 
>          while (phys < top) {
>                  ret = rmi_granule_range_delegate(phys, top, &out_top);
>                  if (ret != RMI_SUCCESS)
>                          break;
> 
>                  /*
>                   * Buggy RMM? Let the caller handle the failure. We can't
>                   * know how far the RMM delegated in this iteration, so we
>                   * return the best known good limit. RMM can deal with 
> granules
>                   * already in "undelegated" in a given range. So it is 
> fine
>                   * for the caller to try the range we return.
>                   */
>                  if (WARN_ON(out_top <= phys)) {
>                          ret = -ENXIO;
>                          break;
>                  }
> 
>                  phys = out_top;
>          }
> 

Ack, I have got it.

>> +
>> +    if (out_phys)
>> +        *out_phys = phys;
>> +
>> +    return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(rmi_delegate_range);
>> +
> 
> Those 4 functions would come in order: the granules is delegated before 
> they
> can be undelegated. So I would suggest to move those function to have the
> following order: rmi_granule_range_delegate(), rmi_delegate_range(),
> rmi_granule_range_undelegate(), rmi_undelegate_range().
> 

Ack. I kept the other order, because one of the earlier versions,
we tried to undelegate things back if delegate failed in between.
But we dropped it in favor of leaving it to the caller.

> 
>> +/*
>> + * Convert the RmiAddrBlockSize to actual size. This is used in 
>> RmiDonateReq
>> + * and RmiAddrRangeDesc*.
>> + */
>> +static unsigned long rmi_addr_block_size_to_bytes(unsigned long 
>> block_size_fld)
>> +{
>> +    return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(3 - block_size_fld));
>> +}
>> +
> 
> Would be nice to have 'inline'.
> 
> static inline unsigned long rmi_addr_block_size_to_bytes(unsigned long 
> block_size_fld)
> 


>> +/*
>> + * free_addr_range: Free memory described by the address range entry, 
>> which may
>> + *            be partially consumed by RMM.
>> + *
>> + * @entry: RMI_ADDR_RANGE descriptor
>> + * @consumed_size: Page aligned size consumed by the RMM from the 
>> address range.
>> + *
>> + * If the state of the address is DELEGATED, undelegate it back, 
>> before freeing.
>> + * Leaks the memory if we cannot undelegate the range.
>> + */
>> +static void free_addr_range(unsigned long entry, unsigned long 
>> consumed_size)
>> +{
>> +    unsigned long phys = RMI_ADDR_RANGE_ADDR(entry);
>> +    unsigned long block_size_fld = RMI_ADDR_RANGE_BLOCK_SIZE(entry);
>> +    unsigned long count = RMI_ADDR_RANGE_COUNT(entry);
>> +    unsigned long state = RMI_ADDR_RANGE_STATE(entry);
>> +    unsigned long size = rmi_addr_block_size_to_bytes(block_size_fld) 
>> * count;
>> +
>> +    WARN_ON(!PAGE_ALIGNED(phys) || !PAGE_ALIGNED(consumed_size));
>> +
>> +    /* We shouldn't see this in reclaim path, leak it for now  */
>> +    if (WARN_ON(state == RMI_OP_MEM_CONDITIONAL))
>> +        return;
>> +
>> +    /* Adjust the address and size for partially consumed entry */
>> +    phys += consumed_size;
>> +    size -= consumed_size;
>> +    /*
>> +     * Undelegate the pages back if required. If we can't
>> +     * change them back, leak the pages.
>> +     */
>> +    if (state == RMI_OP_MEM_DELEGATED &&
>> +        WARN_ON(rmi_undelegate_range(phys, size)))
>> +        return;
>> +    free_pages_exact(phys_to_virt(phys), size);
>> +}
>> +
>> +static void rmi_op_continue(unsigned long sro_handle, unsigned long 
>> flags,
>> +                struct arm_smccc_1_2_regs *out_regs)
>> +{
>> +    *out_regs = (struct arm_smccc_1_2_regs) {
>> +        SMC_RMI_OP_CONTINUE, sro_handle, flags
>> +    };
>> +
>> +    rmi_smccc_invoke(out_regs);
>> +}
>> +
>> +static void rmi_op_cancel(unsigned long sro_handle,
>> +              struct arm_smccc_1_2_regs *out_regs)
>> +{
>> +    *out_regs = (struct arm_smccc_1_2_regs) {
>> +        SMC_RMI_OP_CANCEL, sro_handle
>> +    };
>> +
>> +    rmi_smccc_invoke(out_regs);
>> +}
>> +
>> +static void rmi_op_mem_donate(unsigned long sro_handle, unsigned long 
>> list_addr,
>> +                  unsigned long list_count, unsigned long flags,
>> +                  struct arm_smccc_1_2_regs *out_regs)
>> +{
>> +    *out_regs = (struct arm_smccc_1_2_regs) {
>> +        SMC_RMI_OP_MEM_DONATE, sro_handle, list_addr, list_count, flags
>> +    };
>> +
>> +    /*
>> +     * The output donated count (a1) is always valid, irrespective
>> +     * of the return result. i.e., 0 if there was an error
>> +     */
>> +    rmi_smccc_invoke(out_regs);
>> +}
>> +
>> +static void rmi_op_mem_reclaim(unsigned long sro_handle,
>> +                   unsigned long list_addr,
>> +                   unsigned long list_count,
>> +                   struct arm_smccc_1_2_regs *out_regs)
>> +{
>> +    *out_regs = (struct arm_smccc_1_2_regs) {
>> +        SMC_RMI_OP_MEM_RECLAIM, sro_handle, list_addr, list_count
>> +    };
>> +
>> +    rmi_smccc_invoke(out_regs);
>> +}
>> +
> 
> Would be nice to have 'inline' for above 4 helpers: rmi_op_{continue, 
> cancel, mem_donate, mem_reclaim}().
> 

Like I said above, given this is inside .c file, I would leave them as
plain static to let the compiler do what is best.


>> +/*
>> + * rmi_free_delegated_page: Undelegate and free a page that has been 
>> previously
>> + * delegated to the Realm world. If we are unable to undelegate it, 
>> the page is
>> + * leaked.
>> + * NOTE: Do not use this helper if the page could be concurrently 
>> operated by
>> + * another thread, as it may get leaked if the undelegation fails due 
>> to RMI_BLOCKED
>> + */
>> +int rmi_free_delegated_page(phys_addr_t phys)
>> +{
>> +    if (WARN_ON_ONCE(rmi_undelegate_page(phys))) {
>> +        /* Undelegate failed: leak the page */
>> +        return -EBUSY;
>> +    }
>> +
>> +    free_page((unsigned long)phys_to_virt(phys));
>> +
>> +    return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(rmi_free_delegated_page);
>> +
> 
> I would move this function right after rmi_undelegate_range() since 
> their syntaxes are
> relevant: rmi_undelegate_range() undelegates a range of graunles, and 
> rmi_free_delegated_page()
> undelegatge one granule (page) and then free it.

Ack
> 
>> +static int rmi_sro_ensure_capacity(struct rmi_sro_state *sro,
>> +                   unsigned long count)
>> +{
>> +    if (WARN_ON_ONCE(sro->addr_count > RMI_MAX_ADDR_LIST))
>> +        return -EOVERFLOW;
> 
> I guess this would be:
> 
>      if (WARN_ON_ONCE(sro->addr_count >= RMI_MAX_ADDR_LIST))

addr_count can reach RMI_MAX_ADDR_LIST, as we use it as an array
size, i.e., 0..addr_count-1. That check is fine as it is.


> 
>> +
>> +    if (count > RMI_MAX_ADDR_LIST - sro->addr_count)
>> +        return -ENOSPC;
>> +
>> +    return 0;
>> +}
>> +
>> +static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
>> +                 unsigned long sro_handle,
>> +                 unsigned long donatereq,
>> +                 struct arm_smccc_1_2_regs *out_regs,
>> +                 gfp_t gfp)
>> +{
>> +    unsigned long block_size_fld = RMI_DONATE_BLOCK_SIZE(donatereq);
>> +    unsigned long block_size = 
>> rmi_addr_block_size_to_bytes(block_size_fld);
>> +    unsigned long count = RMI_DONATE_COUNT(donatereq);
>> +    unsigned long state = RMI_DONATE_STATE(donatereq);
>> +    unsigned long size = block_size * count;
>> +    unsigned long addr_range;
>> +    unsigned long donated_granules;
>> +    unsigned long donated_size;
>> +    int ret;
>> +    void *virt;
>> +    phys_addr_t phys;
>> +
>> +    /*
>> +     * The RMM specification requires contiguous allocations are 
>> always a
>> +     * power of 2
>> +     */
>> +    if (WARN_ON_ONCE(!is_power_of_2(size)))
>> +        return -EINVAL;
>> +
>> +    /* Reuse the cached address range if we have one */
>> +    for (int i = 0; i < sro->addr_count; i++) {
>> +        unsigned long entry = sro->addr_list[i];
>> +
>> +        if (RMI_ADDR_RANGE_BLOCK_SIZE(entry) == block_size_fld &&
>> +            RMI_ADDR_RANGE_COUNT(entry) == count &&
>> +            RMI_ADDR_RANGE_STATE(entry) == state &&
>> +            IS_ALIGNED(RMI_ADDR_RANGE_ADDR(entry), size)) {
>> +            sro->addr_count--;
>> +            swap(sro->addr_list[sro->addr_count],
>> +                 sro->addr_list[i]);
>> +
>> +            goto mem_donate;
>> +        }
>> +    }
>> +
>> +    ret = rmi_sro_ensure_capacity(sro, 1);
>> +    if (ret)
>> +        return ret;
>> +
>> +    virt = alloc_pages_exact(size, gfp);
>> +    if (!virt)
>> +        return -ENOMEM;
>> +    phys = virt_to_phys(virt);
>> +
>> +    if (state == RMI_OP_MEM_DELEGATED) {
>> +        phys_addr_t delegated_phys;
>> +
>> +        if (rmi_delegate_range(phys, size, &delegated_phys)) {
>> +            if (!rmi_undelegate_range(phys, delegated_phys - phys))
>> +                free_pages_exact(virt, size);
>> +            return -ENXIO;
>> +        }
>> +    }
>> +
>> +    addr_range = phys & RMI_ADDR_RANGE_ADDR_MASK;
>> +    FIELD_MODIFY(RMI_ADDR_RANGE_BLOCK_SIZE_MASK, &addr_range, 
>> block_size_fld);
>> +    FIELD_MODIFY(RMI_ADDR_RANGE_COUNT_MASK, &addr_range, count);
>> +    FIELD_MODIFY(RMI_ADDR_RANGE_STATE_MASK, &addr_range, state);
>> +
>> +    sro->addr_list[sro->addr_count] = addr_range;
>> +
>> +mem_donate:
>> +    rmi_op_mem_donate(sro_handle,
>> +              virt_to_phys(&sro->addr_list[sro->addr_count]), 1,
>> +              0, out_regs);
>> +    donated_granules = out_regs->a1;
>> +
>> +    if (WARN_ON(donated_granules > (size >> PAGE_SHIFT)))
>> +        donated_granules = (size >> PAGE_SHIFT);
>> +
>> +    donated_size = donated_granules << PAGE_SHIFT;
>> +
>> +    /* All granules consumed by the RMM */
>> +    if (donated_size == size)
>> +        return 0;
>> +    /* No granules were consumed by the RMM, cache them */
>> +    if (donated_granules == 0) {
>> +        sro->addr_count++;
>> +        return 0;
>> +    }
>> +
> 
> The first check is done against 'donated_size' and second one is done
> against 'donated_granules'. Besides, the local variable 'donated_granules'
> can be dropped as explained below.

Ack, I see, it is a bit redundant.

> 
>> +    /* The granules were partially consumed, reclaim the unused ones. */
>> +    free_addr_range(sro->addr_list[sro->addr_count], donated_size);
>> +
>> +    return 0;
>> +}
>> +
> 
> The local variable 'donated_granules' is redundant since we already have 
> 'donated_size'.
> 'donated_granules' can be dropped if 'donated_size' is updated with 
> 'out_regs->a1 << PAGE_SHIFT'
> in the first place, as below:
> 
>          donated_size = out_regs->a1 << PAGE_SHIFT;
>          if (WARN_ON(donated_size > size))
>                  donated_size = size;
> 
>          /* All granules consumed by the RMM */
>          if (donated_size == size)
>                  return 0;
> 
>          /* No granules were consumed by the RMM, cache them */
>          if (donated_size == 0) {
>                  sro->addr_count++;
>                  return 0;
>          }
> 
>          /* The granules were partially consumed, reclaim the unused 
> ones. */
>          free_addr_range(sro->addr_list[sro->addr_count], donated_size);
> 
>      return 0;
> 
>

Ack. I have dropped donated_granules variable.

>> +
>> +long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp)
>> +{
>> +    struct arm_smccc_1_2_regs *regs = &sro->regs;
>> +    bool cancelled = false;
>> +    unsigned long sro_handle;
>> +
>> +    rmi_smccc_invoke(regs);
>> +
>> +    sro_handle = regs->a1;
>> +    while (RMI_RESULT_STATUS(regs->a0) == RMI_INCOMPLETE) {

...

>> +            break;
>> +        default:
>> +            WARN_ON_ONCE(1);
>> +            ret = -ENXIO;
>> +            break;
>                          ^^^^^
> 
> The 'break' can be dropped.
> 

Ack



Suzuki

Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E953E40F6;
	Thu, 10 Sep 2026 09:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033882; cv=none; b=Mt8jfcyGgON7RMFKN93vvc/+08KZ2QKzunfU8a2QMJE/pyIBcW4w2Dc921zcHqYYvr9jjiC/8vY3cjN0IT4cvhsduvS0KpvpwzkSbWhKEP9SNo2p43cOyhiMPFA0anzIRzfk+QnB/dNEQcUAftP0N9cqF28JPXXMG3bZhNoVfCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033882; c=relaxed/simple;
	bh=c4q4Qxz53kDyCD8nkWquhVETa0+IW2m7pzvakhpPb5c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RgkrSuQpk4f5eRxGDQWwIBqy4eMYkY3Y79PedlvE/DEectpm3WSgbClIV1EgLZKXeZkICmPXPJYBfUk2UkzL9We9yWg1ow3jKNta8pHP6TM8LqUN+1kr0vV7VagltZBi6BSP6smYDncKI+IyEbzSMNNvfe8HnMwLTpyO+WGXgOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tUmKJUmA; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tUmKJUmA"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DA5C1570;
	Thu, 10 Sep 2026 02:51:14 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B6E463F528;
	Thu, 10 Sep 2026 02:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789033878; bh=c4q4Qxz53kDyCD8nkWquhVETa0+IW2m7pzvakhpPb5c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tUmKJUmAq569o7YFEX8evjCbdfkO6/NNBebLqLpCnZQz8XDmGXNyKn1NEnGkcd+Pw
	 X8GoKI77jmf3wKDrBSMQzj/2SfLL1ki+EmSEA7dW/cDZl0OMvfu4tY79CbTjpFEZKR
	 oQ3qFbzr5uNmTLOtlwUVqs0SZYwCW9o0L9NX5VYE=
Message-ID: <603b2de8-7636-4eb8-a378-21be986f4e44@arm.com>
Date: Thu, 10 Sep 2026 10:51:13 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 4/7] firmware: arm_rmm: Add support for SRO
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
 <20260907095942.1140734-5-suzuki.poulose@arm.com>
 <50d19bb3-6a08-462a-9c01-2eac8a8e286e@redhat.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <50d19bb3-6a08-462a-9c01-2eac8a8e286e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Gavin

Thank you for the the review, much appreciated. Responses inline.


On 09/09/2026 05:10, Gavin Shan wrote:
> Hi Suzuki,
> 
> On 9/7/26 7:59 PM, Suzuki K Poulose wrote:
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
>> SRO/stateful command infrastructure.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---

...

>>
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/ 
>> arm_rmm/rmi.c
>> index 76f91c145e1fd..42c973c3a98bb 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c

...
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
>> +        if (ret == RMI_SUCCESS)
>> +            phys = out_top;
>> +        else if (ret == RMI_BUSY || ret == RMI_BLOCKED)
>> +            cpu_relax();
>> +        else
>> +            break;
>> +    }
>> +
>> +    if (out_phys)
>> +        *out_phys = phys;
>> +
>> +    return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(rmi_delegate_range);
>> +
> 
> rmi_granule_range_delegate() can't return RMI_BUSY or RMI_BLOCKED as 
> those two
> error statuses are filtered out by inner call rmi_smccc_invoke(). So 
> it's not
> needed to have "else if (ret == RMI_BUSY || ret == RMI_BLOCKED)  
> cpu_relax()"
> here.

Ack
> 
> Besides, 'long ret' is truncated to 'int' by 'return ret'. I think we 
> need a
> helper to convert RMI error status to the linux error code, something like
> below. The newly added helper rmi_to_linux_errno() is used by 
> rmi_sro_memxfer_execute()
> and rmi_sro_execute() where the return values are 'int' (not 'long' any 
> more).

SRO operations return the full set of results from the execution in the 
out_regs/sro->regs. So they can make the full use of the results, if
required.

As for the truncation, we don't return the partial results to the
callers of the rmi_*delegate_range helpers, but they are consumed
internally (e.g., by the SRO execution). The callers care about the
return "status" which is still an 8bit field. We could extend this
if we need it in the future.


> 
> static int rmi_errno_map[] = {
>      [RMI_SUCCESS]            = 0,
>      [RMI_ERROR_INPUT]        = -EINVAL,
>      [RMI_ERROR_REALM]        = -EBADF,
>      [RMI_ERROR_REC]            = -EBADF,
>      [RMI_ERROR_RTT]            = -EBADF,
>      [RMI_ERROR_NOT_SUPPORTED]    = -EOPNOTSUPP,
>      [RMI_ERROR_DEVICE]        = -EBADF,
>      [RMI_ERROR_RTT_AUX]        = -EBADF,
>      [RMI_ERROR_PSMMU_ST]        = -EBADF,
>      [RMI_ERROR_DPT]            = -EBADF,
>      [RMI_BUSY]            = -EBUSY,
>      [RMI_ERROR_GLOBAL]        = -ENOSYS,
>      [RMI_ERROR_TRACKING]        = -EBADF,
>      [RMI_INCOMPLETE]        = -EINPROGRESS,
>      [RMI_BLOCKED]            = -EAGAIN,
>      [RMI_ERROR_GPT]            = -EBADF,
>      [RMI_ERROR_GRANULE]        = -EBADF,
> };
> 

This may be useful, but don't see the need for that now.

> int rmi_to_linux_errno(unsigned long status)
> {
>      status = RMI_RETURN_STATUS(status);
> 
>      return (status < ARRAY_SIZE(rmi_errno_maps)) ? 
> rmi_errno_map[status] : -EINVAL;
> }
> EXPORT_SYMBOL_GPL(rmi_to_linux_errno);
> 

>> +EXPORT_SYMBOL_GPL(rmi_undelegate_range);
>> +
>> +static unsigned long donate_req_to_size(unsigned long donatereq)
>> +{
>> +    unsigned long unit_size = RMI_DONATE_SIZE(donatereq);
>> +
>> +    return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(3 - unit_size));
>> +}
>> +
> 
> I would rename this helper to explicitly indicate it's going to get
> the block size.
> 
> static unsigned long donate_req_to_block_size(unsigned long req)
> {
>      unsigned long block_size_encode = RMI_DONATE_BLOCK_SIZE(req);
> 
>      return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(3 - block_size_encode));
> }
> 

Ack:

I have cleaned this up a little bit by explicitly calling out the 
conversion of RmiAddresBlockSize in a wrapper. i.e.,

/* 

  * Convert the RmiAddrBlockSize to actual size. This is used in 
RmiDonateReq
  * and RmiAddrRangeDesc*. 

  */ 

static unsigned long rmi_addr_block_size_to_bytes(unsigned long 
block_size_fld)
{ 

         return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(3 - block_size_fld)); 

} 

  

static unsigned long donate_req_to_block_size(unsigned long donatereq) 

{ 

         return 
rmi_addr_block_size_to_bytes(RMI_DONATE_BLOCK_SIZE(donatereq));
}

So that it doesn't look awkward to do something like :

 >> +        unsigned long size = donate_req_to_size(unit_size) * count;

instead:

unsigned long size = rmi_addr_block_size_to_bytes(unit_size) * count;


>> +static void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs_in,
...

>> +}
>> +
> 
> The local variable @regs in rmi_op_{continue, cancel}() and 
> rmi_op_mem_{donate, recliam}() can
> be avoided since rmi_smccc_invoke() has two variables for input and 
> output separately. So
> rmi_op_continue() can be improved as below. Other 3 functions can be 
> improved in similar ways.
> 
> static void rmi_op_continue(unsigned long sro_handle, unsigned long flags,
>                  struct arm_smccc_1_2_regs *out_regs)
> {
>      out_regs->a0 = SMC_RMI_OP_CONTINUE;
>      out_regs->a1 = sro_handle;
>      out_regs->a2 = flags;

This may not be sufficient, as we need to zero out the entire arguments
for RES0 requirement. But could do something like :

	*out_regs = (struct arm_smccc_1_2_regs) { SMC_RMI_OP_CONTINUE, 
sro_handle, flags };

> 
>      rmi_smccc_invoke(out_regs, out_regs);
> }
> 
>> +int free_delegated_page(phys_addr_t phys)
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
>> +EXPORT_SYMBOL_GPL(free_delegated_page);
>> +
> 
> How about renaming this to rmi_free_delegated_page()? It seems all 
> functions exposed by
> rmi.c have prefix 'rmi'.

This is in my internal tree for the next version already, thanks for 
pointing that out.

> 
>> +static int rmi_sro_ensure_capacity(struct rmi_sro_state *sro,
>> +                   unsigned long count)
>> +{
>> +    if (WARN_ON_ONCE(sro->addr_count > RMI_MAX_ADDR_LIST))
>> +        return -EOVERFLOW;
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
>> +    unsigned long unit_size = RMI_DONATE_SIZE(donatereq);
>> +    unsigned long unit_size_bytes = donate_req_to_size(donatereq);
>> +    unsigned long count = RMI_DONATE_COUNT(donatereq);
>> +    unsigned long state = RMI_DONATE_STATE(donatereq);
>> +    unsigned long size = unit_size_bytes * count;
>> +    unsigned long addr_range;
>> +    int ret;
>> +    void *virt;
>> +    phys_addr_t phys;
>> +
> 
> s/unit_size/block_size_encode

chose, block_size_fld
> s/unit_size_bytes/block_size

> Please move 'donated_size' to the begining of this function.
> 
>      unsigned long addr_range, donated_size;

Ack

> 
>> +    /*
>> +     * The RMM specification requires contiguous allocations are 
>> always a
>> +     * power of 2
>> +     */
>> +    if (WARN_ON_ONCE(!is_power_of_2(size)))
>> +        return -EINVAL;
>> +
>> +    for (int i = 0; i < sro->addr_count; i++) {
>> +        unsigned long entry = sro->addr_list[i];
>> +
>> +        if (RMI_ADDR_RANGE_SIZE(entry) == unit_size &&
>> +            RMI_ADDR_RANGE_COUNT(entry) == count &&
>> +            RMI_ADDR_RANGE_STATE(entry) == state &&
>> +            IS_ALIGNED(RMI_ADDR_RANGE_ADDR(entry), size)) {
>> +            sro->addr_count--;
>> +            swap(sro->addr_list[sro->addr_count],
>> +                 sro->addr_list[i]);
>> +
>> +            goto out;
>> +        }
>> +    }
>> +
> 
> The search in the address range array may deserve a comment, but I doubt 
> how much
> benefits (hit ratio) the array can give to us :-)
> 
>      /* Reuse the cached address range if we have one */

Ack

> 
> Besides, 'int i' needs to be 'unsigned long i' because 'struct 
> mi_sro_state::addr_count'
> is 'unsigned long'. Alternative, we may change 'struct 
> mi_sro_state::addr_count' to
> 'int'.

I have changed the addr_count to "int". That gives us a better way to
handle corruptions in the sro->addr_count. i.e, addr_count < 0 vs 
addr_count > RMI_MAX_ADDR_LIST

> 
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
>> +    FIELD_MODIFY(RMI_ADDR_RANGE_SIZE_MASK, &addr_range, unit_size);
>> +    FIELD_MODIFY(RMI_ADDR_RANGE_COUNT_MASK, &addr_range, count);
>> +    FIELD_MODIFY(RMI_ADDR_RANGE_STATE_MASK, &addr_range, state);
>> +
>> +    sro->addr_list[sro->addr_count] = addr_range;
>> +
> 
> We actually requires that 'phys' in the range specified by 
> RMI_ADDR_RANGE_ADDR_MASK, so:
> 
>      WARN_ON_ONCE(phys & ~RMI_ADDR_RANGE_ADDR_MASK);
>      addr_range = phys;

Do we support more than 52bit ? Also this comes from virt_to_phys(),
which means the kernel has to first support the phys > 52bit. And the
ADDR_MASK is based on PAGE_SHIFT. So, if that breaks, we have bigger
problems.


> 
>> +out:
>> +    rmi_op_mem_donate(sro_handle,
>> +              virt_to_phys(&sro->addr_list[sro->addr_count]), 1,
>> +              0, out_regs);
>> +
>> +    unsigned long donated_granules = out_regs->a1;
>> +    unsigned long donated_size = donated_granules << PAGE_SHIFT;
>> +
>> +    if (donated_granules == 0) {
>> +        /* No pages used by the RMM */
>> +        sro->addr_count++;
>> +    } else if (donated_size < size) {
>> +        phys = sro->addr_list[sro->addr_count] & 
>> RMI_ADDR_RANGE_ADDR_MASK;
>> +
>> +        /* Not all granules used by the RMM, free the remaining pages */
>> +        for (long i = donated_size; i < size; i += PAGE_SIZE) {
>> +            if (state == RMI_OP_MEM_DELEGATED)
>> +                free_delegated_page(phys + i);
>> +            else
>> +                __free_page(phys_to_page(phys + i));
>> +        }
>> +    }
>> +
> 
> 'i' was used previouly and I would avoid using it again. I would suggest 
> to simplify
> this chunk of code, as below. 

I have dropped that hunk and replaced them with a new helper :

free_addr_range_entry(), that can free an address range, bit more
efficiently (batching granule_undelegate) and even handle a partially
consumed entry. This will be reused for contig/non-contig and the
rmi_sro_free().


Another question is if we need to check if
> RMI_SUCCESS
> is returned from rmi_op_mem_donate()?
> 
>      donated_size = PFN_PHYS(out_regs->a1);
> 
>      /* All granules are consumed by RMM */
>      if (donated_size == size)
>          return 0;
> 
>      /* No granules are consumed by RMM, cache all granules */
>      if (donated_size == 0) {
>          sro->addr_count++;
>          return 0;
>      }
> 

Ack, that is much clearer.


>      /*
>       * The granules are partially consumed by RMM, delegate and release
>       * the unused granules.
>       */
>      phys = sro->addr_list[sro->addr_count] & RMI_ADDR_RANGE_ADDR_MASK;
>      while (donated_size < size) {
>          if (state == RMI_OP_MEM_DELEGATED)
>              rmi_free_delegated_page(phys + donated_size);
>          else
>              __free_page(phys_to_page(phys + donated_size));
> 
>          donated_size += PAGE_SIZE;
>      }
> 
>      return 0;
> 
>> +    return 0;
>> +}
>> +
>> +static int rmi_sro_donate_noncontig(struct rmi_sro_state *sro,
>> +                    unsigned long sro_handle,
>> +                    unsigned long donatereq,
>> +                    struct arm_smccc_1_2_regs *out_regs,
>> +                    gfp_t gfp)
>> +{
>> +    unsigned long unit_size = RMI_DONATE_SIZE(donatereq);
>> +    unsigned long unit_size_bytes = donate_req_to_size(donatereq);
>> +    unsigned long count = RMI_DONATE_COUNT(donatereq);
>> +    unsigned long state = RMI_DONATE_STATE(donatereq);
>> +    unsigned long found = 0;
>> +    unsigned long addr_list_start = sro->addr_count;
>> +    int ret;
>> +
> 
> s/unit_size/block_size_encode
> s/unit_size/block_size

Ack, same as above.

> 
>> +    for (int i = 0; i < addr_list_start && found < count; i++) {
>> +        unsigned long entry = sro->addr_list[i];
>> +
>> +        if (RMI_ADDR_RANGE_SIZE(entry) == unit_size &&
>> +            RMI_ADDR_RANGE_COUNT(entry) == 1 &&
>> +            RMI_ADDR_RANGE_STATE(entry) == state) {
>> +            addr_list_start--;
>> +            swap(sro->addr_list[addr_list_start],
>> +                 sro->addr_list[i]);
>> +            found++;
>> +            i--;
>> +        }
>> +    }
>> +
> 
> The type of 'i' is different to 'addr_list_start' and 'sro->addr_count'.

As above, switched to i, and I will move addr_list_start to int.

> 
>> +    ret = rmi_sro_ensure_capacity(sro, count - found);
>> +    if (ret)
>> +        return ret;
>> +
>> +    while (found < count) {
>> +        unsigned long addr_range;
>> +        void *virt = alloc_pages_exact(unit_size_bytes, gfp);
>> +        phys_addr_t phys;
>> +
>> +        if (!virt)
>> +            return -ENOMEM;
>> +
>> +        phys = virt_to_phys(virt);
>> +
>> +        if (state == RMI_OP_MEM_DELEGATED) {
>> +            phys_addr_t delegated_phys;
>> +
>> +            if (rmi_delegate_range(phys, unit_size_bytes,
>> +                           &delegated_phys)) {
>> +                if (!rmi_undelegate_range(phys, delegated_phys - phys))
>> +                    free_pages_exact(virt, unit_size_bytes);
>> +                return -ENXIO;
>> +            }
>> +        }
>> +
>> +        addr_range = phys & RMI_ADDR_RANGE_ADDR_MASK;
>> +        FIELD_MODIFY(RMI_ADDR_RANGE_SIZE_MASK, &addr_range, unit_size);
>> +        FIELD_MODIFY(RMI_ADDR_RANGE_COUNT_MASK, &addr_range, 1);
>> +        FIELD_MODIFY(RMI_ADDR_RANGE_STATE_MASK, &addr_range, state);
>> +
>> +        sro->addr_list[sro->addr_count++] = addr_range;
>> +        found++;
>> +    }
>> +
>> +    rmi_op_mem_donate(sro_handle,
>> +              virt_to_phys(&sro->addr_list[addr_list_start]),
>> +              found, 0, out_regs);
>> +
> 
> The local variable 'found' looks redundant and can be dropped. With 
> 'found' dropped,
> we need:

May be, but it is easier to reason with that variable. So I prefer to
keep it for the loop.

> 
>      while (sro->addr_count - addr_list_start < count) {
>          :
>      }
> 

>      rmi_op_mem_donate(sro_handle,
>                virt_to_phys(&sro->addr_list[addr_list_start]),
>                count, 0, out_regs);

Ack for the switch to count here.

> 
>> +    unsigned long donated_granules = out_regs->a1;
>> +    unsigned long granules_per_unit = unit_size_bytes >> PAGE_SHIFT;
>> +    unsigned long consumed_units;
>> +
> 
> s/granules_per_unit/granules_per_block
> s/consumed_units/consumed_blocks

Ack


>> +void rmi_sro_free(struct rmi_sro_state *sro)
>> +{
>> +    for (int i = 0; i < sro->addr_count; i++) {
>> +        unsigned long entry = sro->addr_list[i];
>> +        unsigned long addr = RMI_ADDR_RANGE_ADDR(entry);
>> +        unsigned long unit_size = RMI_ADDR_RANGE_SIZE(entry);
>> +        unsigned long count = RMI_ADDR_RANGE_COUNT(entry);
>> +        unsigned long state = RMI_ADDR_RANGE_STATE(entry);
>> +        unsigned long size = donate_req_to_size(unit_size) * count;
>> +
>> +        if (state == RMI_OP_MEM_DELEGATED) {
>> +            if (WARN_ON_ONCE(rmi_undelegate_range(addr, size))) {
>> +                /* Leak the pages */
>> +                continue;
>> +            }
>> +        }
>> +        free_pages_exact(phys_to_virt(addr), size);
>> +    }
> 
> The nested if statements can be avoided by:
> 
>          if (state == RMI_OP_MEM_DELEGATED &&
>              WARN_ON_ONCE(rmi_undelegate_range(addr, size)) {
>              /* Leak the granules */
>              continue;
>          }
> 
>          free_pages_exact(phys_to_virt(addr), size);

As mentioned above, this is now in a common helper.

> 
>> +
>> +    sro->addr_count = 0;
>> +}
>> +EXPORT_SYMBOL_GPL(rmi_sro_free);
>> +
>> +long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp)
>> +{
>> +    unsigned long sro_handle;
>> +    struct arm_smccc_1_2_regs *regs = &sro->regs;
>> +    bool cancelled = false;
>> +
>> +    rmi_smccc_invoke(regs, regs);
>> +
>> +    sro_handle = regs->a1;
>> +
>> +    while (RMI_RETURN_STATUS(regs->a0) == RMI_INCOMPLETE) {
>> +        bool can_cancel = RMI_RETURN_CAN_CANCEL(regs->a0);
>> +        int ret = 0;
>> +
> 
> Strictly speaking, we need to refresh the SRO handle after every RMI call.
> 
>          bool can_cancel = RMI_RETURN_CAN_CANCEL(regs->a0);
>          unsigned long sro_handle = regs->a1;
>          int ret = 0;
> 

Ack for both instances

>> +
>> +    rmi_smccc_invoke(regs, regs);
>> +
>> +    sro_handle = regs->a1;
>> +
>> +    while (RMI_RETURN_STATUS(regs->a0) == RMI_INCOMPLETE) {
>> +        bool can_cancel = RMI_RETURN_CAN_CANCEL(regs->a0);
>> +
> 
> Strictly speaking, we need to refresh the SRO handle after every RMI call.
> 
>          bool can_cancel = RMI_RETURN_CAN_CANCEL(regs->a0);
>          unsigned long sro_handle = regs->a1;
> 
> 

as above.


/types.h>
>> +#define RMI_MAX_ADDR_LIST    256
>> +

ng rmi_sro_execute(struct arm_smccc_1_2_regs *regs);
>> +
>> +#define rmi_sro_memxfer_cmd(sro, gfp, ...) ({                \
>> +    struct rmi_sro_state *__sro = (sro);                \
>> +    *__sro = (struct rmi_sro_state){ .regs = {__VA_ARGS__} };    \
>> +    long __ret = rmi_sro_memxfer_execute(__sro, gfp);        \
>> +    rmi_sro_free(__sro);                        \
>> +    __ret;                                \
>> +})
>> +
> 
> The temporary storage space for 'struct rmi_sro_state' in the stack due to
> '*__sro = (struct rmi_sro_state){ .regs = {__VA_ARGS__} };' can be avoided
> by:
> 
>      __sro->regs = {__VA_ARGS__};

Have got this already in, based on Sashiko review.


>> +static inline long rmi_granule_range_delegate(unsigned long base,
>> +                          unsigned long top,
>> +                          unsigned long *out_top)
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
>> +
> 
> It seems rmi_granule_range_delegate() is used for once by 
> rmi.c::rmi_delegate_range().
> If so, we needn't to expose the function. The logic here can be combined to
> rmi.c::rmi_delegate_range().
> 
>> +/**
>> + * rmi_granule_range_undelegate() - Undelegate a range of granules

...

>> +
> 
> It seems rmi_granule_range_undelegate() is used for once by 
> rmi.c::rmi_undelegate_range().
> If so, we needn't expose the function. The logic here can be combined to 
> rmi_undelegate_range().

Ack

Thanks
Suzuki

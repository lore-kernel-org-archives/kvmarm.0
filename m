Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07354371CE3;
	Thu, 16 Jul 2026 16:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784217899; cv=none; b=qqa8WCT4x3YYEM7g0loB++ZqkjFY8mQ3zrfov4GIf85+bifK5VItlC9DXtmjWd2/XJ3bDxB5F7ezPz13VxjEWXv7hR7EOYFAsUQ2lmo0mxjDwOKObaDjeb/Jyzl+KFW23O9dIjOp1i0p1EQdfnHaQKSr7TVZYbQ2bsVZ6APXkKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784217899; c=relaxed/simple;
	bh=e+knd2aySDpztrDcilmsVa3LPUBYbigaUm4PhJZZo+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S67dV8Wmil0pvpDyQHuSxuKC5nAMA3sEq1L3uewj0ezFur2/hNMcIqhCiWWeX9hAAXheAXVunQ/ZXYHqveBQphlCAzkBXecbM5WyZF3bzdO0l+/wKdNO2o1s4n4/agguLm0PlP3wcLGbXdmJr0MogmTECTxQ2hdgKdTLdfvD4B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HDdsPvgo; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HDdsPvgo"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B5992B;
	Thu, 16 Jul 2026 09:04:51 -0700 (PDT)
Received: from [10.1.25.27] (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3439B3F7B4;
	Thu, 16 Jul 2026 09:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784217895; bh=e+knd2aySDpztrDcilmsVa3LPUBYbigaUm4PhJZZo+M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HDdsPvgo59wTS2pWZEFgH3Ffhl5VVm5i72D/PjJ1GhJ8lrAIS+jYY+I75uf94btUC
	 O9bfBs9NlrcKHqWEuGJfuIyTOEZIjbfD/5B+NvpnPTOgOT20s9+uAdLoA2vWarKZp2
	 7RpBN6/HjdRMzeSKIfMmgXVPDBPYBE0UD+CYRdrE=
Message-ID: <69af1617-bd20-4cb3-bdb8-725b8f22b072@arm.com>
Date: Thu, 16 Jul 2026 17:04:52 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] firmware: arm_rmm: Add support for SRO
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
 Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org
References: <20260715142739.80398-1-steven.price@arm.com>
 <20260715142739.80398-6-steven.price@arm.com>
 <20260715152954.ECAEA1F000E9@smtp.kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20260715152954.ECAEA1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/07/2026 16:29, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 8 potential issue(s) to consider:
> - [High] Kernel infinite loop when SRO memory allocation fails and the operation cannot be cancelled.
> - [High] SRO wrappers wipe and free the `rmi_sro_state` struct unconditionally, leaking cached memory and breaking cross-call reuse.
> - [High] `rmi_op_cancel` overwrites the `regs` structure with the cancellation request result, destroying the SRO loop state and leaving the RMM operation incomplete.
> - [High] Out-of-bounds array read and arbitrary memory free when handling an overflow condition in SRO reclaim.
> - [High] Missing clamp on `donated_granules` in `rmi_sro_donate_contig` allows a malicious or buggy RMM to trigger arbitrary out-of-bounds page frees.
> - [Medium] Incorrect alignment check using `IS_ALIGNED` with potentially non-power-of-two sizes.
> - [Medium] SRO wrappers hardcode `GFP_KERNEL`, directly contradicting the stated goal of supporting atomic execution contexts.
> - [Low] Usage of non-standard macro `kmalloc_obj()` causes compilation failure.
> --
> 
> --- Patch [5]: [PATCH 5/6] firmware: arm_rmm: Add support for SRO ---
> commit 105823e0511b9065ecd4f5281f43bd808384b24c
> Author: Steven Price <steven.price@arm.com>
> 
> firmware: arm_rmm: Add support for SRO
> 
> This commit introduces Stateful RMI Operations (SRO) for RMM v2.0, allowing
> SMC operations to return while still in progress and be continued later. It
> adds infrastructure to track and reuse allocated memory during these
> operations to support execution in contexts where memory allocation is
> difficult. The patch also provides wrappers for SRO commands and modifies
> delegate/undelegate handlers to use the stateful infrastructure.
> 
>> diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
>> index 7eb2c8d7f7fa8..f13ecdb40ded4 100644
>> --- a/arch/arm64/include/asm/rmi_cmds.h
>> +++ b/arch/arm64/include/asm/rmi_cmds.h
> 
> [ ... ]
> 
>> @@ -46,6 +142,98 @@ static inline int rmi_realm_activate(unsigned long rd)
>>  	return res.a0;
>>  }
>>  
>> +/**
>> + * rmi_realm_create() - Create a realm
>> + * @rd: PA of the RD
>> + * @params: PA of realm parameters
>> + * @sro: Preallocated SRO context to be used
>> + *
>> + * Create a new realm using the given parameters.
>> + *
>> + * Return: RMI return code
>> + */
>> +static inline int rmi_realm_create(unsigned long rd, unsigned long params,
>> +				   struct rmi_sro_state *sro)
>> +{
>> +	return rmi_sro_memxfer_cmd(sro, GFP_KERNEL,
>> +				   SMC_RMI_REALM_CREATE, rd, params);
>> +}
> 
> [Severity: Medium]
> The commit message states the SRO framework permits operations to be done in a
> context where memory allocation may be difficult, such as an atomic context.
> However, does passing GFP_KERNEL here directly contradict that goal? If
> rmi_sro_ensure_capacity() requires memory, it will call alloc_pages_exact()
> with GFP_KERNEL, which will sleep.

But this particular RMI function is called from a context where sleeping
is fine.

>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
>> index e7ab4a7df3ca8..6a9f61760fd77 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
> 
> [ ... ]
> 
>> @@ -22,6 +23,487 @@ unsigned long rmi_feat_reg(unsigned long id)
> 
> [ ... ]
> 
>> +static void rmi_op_cancel(unsigned long sro_handle,
>> +			  struct arm_smccc_1_2_regs *out_regs)
>> +{
>> +	struct arm_smccc_1_2_regs regs = {
>> +		SMC_RMI_OP_CANCEL, sro_handle
>> +	};
>> +
>> +	rmi_smccc_invoke(&regs, out_regs);
>> +}
> 
> [Severity: High]
> Does rmi_op_cancel() overwrite the caller's out_regs with the cancellation
> result?

Yes

> When called from rmi_sro_memxfer_execute(), a successful cancel
> returns RMI_SUCCESS in out_regs->a0.

A 'successful' cancel returns RMI_INCOMPLETE. Or as the spec puts it:

 | The RMI_OP_CANCEL command does not have any success conditions

> This would cause the loop condition
> (RMI_RETURN_STATUS(regs->a0) == RMI_INCOMPLETE) to fail early and abandon
> the operation before it completes, potentially causing future RMM operations
> to fail.

There's a WARN_ON_ONCE if regs->a0 is anything but RMI_INCOMPLETE in
rmi_sro_memxfer_execute(). This should never happen.

> [ ... ]
> 
>> +static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
>> +				 unsigned long sro_handle,
>> +				 unsigned long donatereq,
>> +				 struct arm_smccc_1_2_regs *out_regs,
>> +				 gfp_t gfp)
>> +{
>> +	unsigned long unit_size = RMI_DONATE_SIZE(donatereq);
>> +	unsigned long unit_size_bytes = donate_req_to_size(donatereq);
>> +	unsigned long count = RMI_DONATE_COUNT(donatereq);
>> +	unsigned long state = RMI_DONATE_STATE(donatereq);
>> +	unsigned long size = unit_size_bytes * count;
>> +	unsigned long addr_range;
>> +	int ret;
>> +	void *virt;
>> +	phys_addr_t phys;
>> +
>> +	for (int i = 0; i < sro->addr_count; i++) {
>> +		unsigned long entry = sro->addr_list[i];
>> +
>> +		if (RMI_ADDR_RANGE_SIZE(entry) == unit_size &&
>> +		    RMI_ADDR_RANGE_COUNT(entry) == count &&
>> +		    RMI_ADDR_RANGE_STATE(entry) == state &&
>> +		    IS_ALIGNED(RMI_ADDR_RANGE_ADDR(entry), size)) {
> 
> [Severity: Medium]
> Can size be a non-power-of-two here?

According to the spec: no.

> The IS_ALIGNED() macro evaluates a> bitwise AND with (size - 1) and
strictly requires the alignment to be a
> power of two. If the RMM requests a contiguous donation where count is not a
> power of two, this check uses an invalid bitmask.

I'll add a check (with a WARN_ON_ONCE) for buggy RMM behaviour which
errors out early.

>> +			sro->addr_count--;
>> +			swap(sro->addr_list[sro->addr_count],
>> +			     sro->addr_list[i]);
>> +
>> +			goto out;
>> +		}
>> +	}
> 
> [ ... ]
> 
>> +out:
>> +	rmi_op_mem_donate(sro_handle,
>> +			  virt_to_phys(&sro->addr_list[sro->addr_count]), 1,
>> +			  0, out_regs);
>> +
>> +	unsigned long donated_granules = out_regs->a1;
>> +	unsigned long donated_size = donated_granules << PAGE_SHIFT;
>> +
>> +	if (donated_granules == 0) {
>> +		/* No pages used by the RMM */
>> +		sro->addr_count++;
>> +	} else if (donated_size < size) {
> 
> [Severity: High]
> Is it possible for the RMM to return a maliciously large value for
> donated_granules here?

Yes, but the RMM is considered trusted.

> Unlike rmi_sro_donate_noncontig() which clamps
> this value, this function does not. If the value overflows the bitwise shift,
> donated_size could appear small, causing the kernel to erroneously enter the
> free loop below and release pages that the RMM may actively be using.

There are plenty of other ways of the RMM breaking the normal world. In
particular APIs like RMI_RTT_DATA_UNMAP return physical addresses which
Linux trusts are correct.

>> +		phys = sro->addr_list[sro->addr_count] & RMI_ADDR_RANGE_ADDR_MASK;
>> +
>> +		/* Not all granules used by the RMM, free the remaining pages */
>> +		for (long i = donated_size; i < size; i += PAGE_SIZE) {
>> +			if (state == RMI_OP_MEM_DELEGATED)
>> +				free_delegated_page(phys + i);
>> +			else
>> +				__free_page(phys_to_page(phys + i));
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
> 
> [ ... ]
> 
>> +static int rmi_sro_reclaim(struct rmi_sro_state *sro,
>> +			   unsigned long sro_handle,
>> +			   struct arm_smccc_1_2_regs *out_regs)
>> +{
>> +	unsigned long capacity;
>> +	int ret;
>> +
>> +	ret = rmi_sro_ensure_capacity(sro, 1);
>> +	if (ret)
>> +		rmi_sro_free(sro);
> 
> [Severity: High]
> If rmi_sro_ensure_capacity() fails because sro->addr_count is greater than
> RMI_MAX_ADDR_LIST, it returns -EOVERFLOW.

This is a "should never happen" condition (which has a WARN_ON_ONCE).

> Passing sro to rmi_sro_free() in> this state will cause the loop in
rmi_sro_free() to iterate out-of-bounds
> past the end of the addr_list array, reading garbage data and attempting to
> free it.

True - a corrupted list length causes further things to break. It seems
a bit much to try to handle such corruption.

>> +
>> +	capacity = RMI_MAX_ADDR_LIST - sro->addr_count;
> 
> [ ... ]
> 
>> +unsigned long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp)
>> +{
>> +	unsigned long sro_handle;
>> +	struct arm_smccc_1_2_regs *regs = &sro->regs;
>> +
>> +	rmi_smccc_invoke(regs, regs);
>> +
>> +	sro_handle = regs->a1;
>> +
>> +	while (RMI_RETURN_STATUS(regs->a0) == RMI_INCOMPLETE) {
>> +		bool can_cancel = RMI_RETURN_CAN_CANCEL(regs->a0);
>> +		int ret = 0;
>> +
>> +		switch (RMI_RETURN_MEMREQ(regs->a0)) {
>> +		case RMI_OP_MEM_REQ_NONE:
>> +			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
>> +					regs);
>> +			break;
>> +		case RMI_OP_MEM_REQ_DONATE:
>> +			ret = rmi_sro_donate(sro, sro_handle, regs->a2, regs,
>> +					     gfp);
>> +			break;
>> +		case RMI_OP_MEM_REQ_RECLAIM:
>> +			ret = rmi_sro_reclaim(sro, sro_handle, regs);
>> +			break;
>> +		default:
>> +			ret = WARN_ON_ONCE(1);
>> +			break;
>> +		}
>> +
>> +		if (ret) {
>> +			if (can_cancel)
>> +				rmi_op_cancel(sro_handle, regs);
>> +
>> +			if (WARN_ON_ONCE(RMI_RETURN_STATUS(regs->a0) != RMI_INCOMPLETE))
>> +				return ret;
>> +		}
>> +	}
> 
> [Severity: High]
> Does this code loop infinitely if a memory allocation fails and can_cancel is
> false?

The specification requires that can_cancel is true when a memory
allocation is requested.

It's also not really clear what the alternative is here - if the RMM
requests memory and doesn't allow cancellation then the only way of
finishing the operation is to provide it with the memory.

> If ret is set to an error code and can_cancel is false,
> rmi_op_cancel()> is skipped. The regs state is not modified, so
RMI_RETURN_STATUS(regs->a0)
> remains RMI_INCOMPLETE, the WARN_ON_ONCE check fails, and the loop repeats
> indefinitely without returning the error.

Indeed, if the operation is incomplete the code attempts to complete the
operation. The only other option would be to give up on using the RMM,
but how do we choose the maximum number of loops before giving up?

Ultimately we do have to trust the RMM to some extent to obey the spec.

> [ ... ]
> 
>> @@ -80,8 +562,9 @@ static int rmi_configure(void)
>>  {
>>  	unsigned long ret;
>>  	struct rmm_config *config __free(free_page) = (struct rmm_config *)get_zeroed_page(GFP_KERNEL);
>> +	struct rmi_sro_state *sro __free(kfree) = (struct rmi_sro_state *)kmalloc_obj(*sro);
> 
> [Severity: Low]
> Is kmalloc_obj() a standard kernel macro?

Yes

> It does not appear to exist in the> standard kernel headers, which
will result in an implicit function declaration
> error and build failure.

I'm not sure what braindead version of Sashiko was used on this patch.
For some reason it seems to have completely forgotten standard Linux and
somewhat missed the context of how the RMM fits into the system.

>> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
>> index c038c1d685fad..138983ab4e3c2 100644
>> --- a/include/linux/arm-rmi-cmds.h
>> +++ b/include/linux/arm-rmi-cmds.h
> 
> [ ... ]
> 
>> @@ -19,10 +19,45 @@ struct rtt_entry {
> 
> [ ... ]
> 
>> +#define rmi_sro_memxfer_cmd(sro, gfp, ...) ({				\
>> +	struct rmi_sro_state *__sro = (sro);				\
>> +	*__sro = (struct rmi_sro_state){ .regs = {__VA_ARGS__} };	\
>> +	int __ret = rmi_sro_memxfer_execute(__sro, gfp);		\
>> +	rmi_sro_free(__sro);						\
>> +	__ret;								\
>> +})
> 
> [Severity: High]
> Does this macro unconditionally wipe and free the rmi_sro_state struct? The
> compound literal assignment *__sro = (struct rmi_sro_state){ ... } will
> zero-initialize addr_count and addr_list, wiping any cached addresses from a
> previous attempt. Furthermore, calling rmi_sro_free() unconditionally before
> returning frees any allocated memory, defeating the stated design goal of
> reusing memory across calls.
> 

Yes it unconditionally wipes the context of the struct - the struct is
provided purely to avoid having to do an extra memory allocation. This
is a helper maco for the cases where we don't provide a way of dropping
into a less restrictive state to retry the allocation.

This is admittedly a missing piece - currently there are no call sites
that do the stated dance of dropping locks to retry a memory allocation.

Steve


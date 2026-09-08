Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10A1447FAEA;
	Tue,  8 Sep 2026 22:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788905454; cv=none; b=IRfX7HZQqWsOIiLZuS2vA/zzqg2cVfjrHuntnYXLUUr8DAakyS5BajO9VDhMN2VOPXzOOnOXmzR97iWvZ8VAmaPDd3djhz8zHdyW/8HFnEVyLJMxpcojPoGYO2KPT8HU7LIUat1XysKZW73NXhlSChSHRZAekcTClVlicG37Y8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788905454; c=relaxed/simple;
	bh=sZdQBZlI7cQwL3SPAH5xAuzbkiDkOaTNGMwUbyZ2Pak=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GRup8/rcsVPT0GpMJ9LoSHeoJFvOpoZPbZgRSrjkFXSLhQc1KvksNBtAT+q82b0ekE+up+tYIjNy0OY/rI3GnfYcl0vKutSCh/guqJpZmqNjN+Zsouck0bxQiAFT3ERiWh9M13EcA8DJMW3BW5iae9RZ8u1TXd+pwLl/z5yj3TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TqTME0tE; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TqTME0tE"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63CE81476;
	Tue,  8 Sep 2026 15:10:46 -0700 (PDT)
Received: from [10.57.49.201] (unknown [10.57.49.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 470BB3F7D8;
	Tue,  8 Sep 2026 15:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788905450; bh=sZdQBZlI7cQwL3SPAH5xAuzbkiDkOaTNGMwUbyZ2Pak=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TqTME0tECfV4ThLPgVUqmDyqGtKCUOFUmN2VDzrCZbQl3mrDqvYslSrKH5rpZfx+P
	 6lBRZqBz84vgso27QaPcYiSoVGorxirrWiLfhWNU3MdjDZoPeEsNxwadLARYvqdomQ
	 KjNIYOxZQlEI8b7TK//yiFzYKrHccQcubb3Es9rA=
Message-ID: <2228a451-bc45-4210-841e-15eb447982b4@arm.com>
Date: Tue, 8 Sep 2026 23:10:47 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 4/7] firmware: arm_rmm: Add support for SRO
Content-Language: en-GB
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
 <20260907095942.1140734-5-suzuki.poulose@arm.com>
 <20260907101405.517191F00A3A@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260907101405.517191F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/09/2026 11:14, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [High] Infinite loop during SRO cancellation if the RMM continues to return an unexpected MEMREQ.
> - [High] Missing bounds check on `out_regs->a1` in `rmi_sro_donate_contig` allows an integer overflow that can erroneously free actively consumed memory.
> - [High] The error handler for `sro->addr_count` corruption in `rmi_sro_ensure_capacity` triggers an out-of-bounds read and arbitrary free.
> - [High] Potential infinite loop in `rmi_delegate_range` and `rmi_undelegate_range` on buggy RMM.
> --
> 
> commit c980046a949a7ff8e2698f0f01373297576d9896
> Author: Steven Price <steven.price@arm.com>
> Subject: firmware: arm_rmm: Add support for SRO
> 
> This commit introduces support for RMM v2.0 Stateful RMI Operations (SRO), allowing SMCs to return with operations still in progress. It adds struct rmi_sro_state to track memory allocated but not yet consumed or reclaimed, and provides wrappers for SRO RMI commands.
> 
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
>> index 76f91c145e1fd..42c973c3a98bb 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
>> @@ -24,6 +25,513 @@ unsigned long rmi_feat_reg(unsigned long id)
>>   }
>>   EXPORT_SYMBOL_GPL(rmi_feat_reg);
>>   
>> +int rmi_delegate_range(phys_addr_t phys,
>> +		       unsigned long size,
>> +		       phys_addr_t *out_phys)
>> +{
>> +	long ret = 0;
>> +	unsigned long top = phys + size;
>> +	unsigned long out_top;
>> +
>> +	while (phys < top) {
>> +		ret = rmi_granule_range_delegate(phys, top, &out_top);
>> +		if (ret == RMI_SUCCESS)
>> +			phys = out_top;
> 
> [Severity: High]
> Could this loop indefinitely if a buggy RMM firmware returns RMI_SUCCESS but
> does not advance out_top beyond phys?
> 

...

>> +int rmi_undelegate_range(phys_addr_t phys,
>> +			 unsigned long size)
>> +{
>> +	long ret = 0;
>> +	unsigned long top = phys + size;
>> +	unsigned long out_top;
>> +
>> +	while (phys < top) {
>> +		ret = rmi_granule_range_undelegate(phys, top, &out_top);
>> +		if (ret == RMI_SUCCESS)
>> +			phys = out_top;
> 
> [Severity: High]
> Does this undelegate loop carry the same infinite loop risk as the delegate path
> if the hypervisor fails to advance out_top?

I have added a WARN_ON() in case these are not advanced and break out
from the code.

> 
>> +		else if (ret == RMI_BUSY || ret == RMI_BLOCKED)
>> +			cpu_relax();
>> +		else
>> +			break;
>> +	}
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(rmi_undelegate_range);
> 
> [ ... ]
> 
>> +static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
>> +				 unsigned long sro_handle,
>> +				 unsigned long donatereq,
>> +				 struct arm_smccc_1_2_regs *out_regs,
>> +				 gfp_t gfp)
>> +{
> 
> [ ... ]
> 
>> +	rmi_op_mem_donate(sro_handle,
>> +			  virt_to_phys(&sro->addr_list[sro->addr_count]), 1,
>> +			  0, out_regs);
>> +
>> +	unsigned long donated_granules = out_regs->a1;
>> +	unsigned long donated_size = donated_granules << PAGE_SHIFT;
> 
> [Severity: High]
> Can donated_granules (out_regs->a1) be an untrusted large value from a
> compromised or buggy RMM?
> 
> If out_regs->a1 is excessively large, donated_granules << PAGE_SHIFT could
> overflow into a small integer value.

I have added a check to make sure that the donated_granules <= the
granules we passed and clamp it to the size.
> 
>> +
>> +	if (donated_granules == 0) {
>> +		/* No pages used by the RMM */
>> +		sro->addr_count++;
>> +	} else if (donated_size < size) {
>> +		phys = sro->addr_list[sro->addr_count] & RMI_ADDR_RANGE_ADDR_MASK;
>> +
>> +		/* Not all granules used by the RMM, free the remaining pages */
>> +		for (long i = donated_size; i < size; i += PAGE_SIZE) {
> 
> [Severity: High]
> If the integer overflow described above occurs, this check
> (donated_size < size) will incorrectly pass. Would this lead to the host
> allocator erroneously freeing memory that the RMM might still be actively
> using?
> ]

Addressed as above.

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
> Is it safe to pass sro to rmi_sro_free() here when rmi_sro_ensure_capacity()
> failed?
> 
> If rmi_sro_ensure_capacity() detects corruption and returns -EOVERFLOW because
> sro->addr_count > RMI_MAX_ADDR_LIST, calling rmi_sro_free() passes that same
> corrupted addr_count to the cleanup loop.

Added a WARN_ON() and clamped it down to the RMI_MAX_ADDR_LIST in
overflow cases.

> 
>> +
>> +	capacity = RMI_MAX_ADDR_LIST - sro->addr_count;
>> +

...

>> +void rmi_sro_free(struct rmi_sro_state *sro)
>> +{
>> +	for (int i = 0; i < sro->addr_count; i++) {
> 
> [Severity: High]
> If sro->addr_count is corrupted and greater than RMI_MAX_ADDR_LIST, as caught
> in the error path above, won't this loop use it as an upper bound, leading to
> out-of-bounds array reads and arbitrary memory frees?

As above.


> 
> [ ... ]
> 
>> +long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp)
>> +{
>> +	unsigned long sro_handle;
>> +	struct arm_smccc_1_2_regs *regs = &sro->regs;
>> +	bool cancelled = false;
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
> 
> [ ... ]
> 
>> +		}
>> +
>> +		if (ret) {
>> +			/*
>> +			 * All memory donating SROs must be cancellable. So a
>> +			 * failure in memory allocation shouldn't be an issue.
>> +			 * However, if we encounter a random failure (e.g.,
>> +			 * buggy RMM), don't loop forever, just give up.
>> +			 */
>> +			if (WARN_ON_ONCE(!can_cancel))
>> +				return ret;
>> +
>> +			rmi_op_cancel(sro_handle, regs);
>> +			cancelled = true;
>> +
>> +			if (WARN_ON_ONCE(RMI_RETURN_STATUS(regs->a0) != RMI_INCOMPLETE))
>> +				return ret;
> 
> [Severity: High]
> Does this sequence create an infinite loop on a buggy RMM?
> 
> If the RMM returns an unexpected MEMREQ and does not clear the can_cancel bit in
> its return status after a cancellation is requested, the loop unconditionally
> re-issues the cancel command because it does not check the local cancelled state.


I have added the following hunk to handle this case.


-
+                       /*
+                        * If we have already cancelled, and came back 
here due
+                        * to an error in RECLAIM, then there is no point
+                        * in going in loops.
+                        */
+                       if (WARN_ON_ONCE(cancelled))
+                               break;
                         rmi_op_cancel(sro_handle, regs);
                         cancelled = true;


>> +		}
>> +	}
>> +
>> +	if (cancelled)
>> +		return -ECANCELED;
>> +
>> +	return regs->a0;
>> +}
>> +EXPORT_SYMBOL_GPL(rmi_sro_memxfer_execute);
>> +
>> +/* For RMI commands that are stateful but not memory-transferring */
>> +long rmi_sro_execute(struct arm_smccc_1_2_regs *regs)
>> +{
>> +	unsigned long sro_handle;
>> +	bool cancelled = false;
>> +
>> +	rmi_smccc_invoke(regs, regs);
>> +
>> +	sro_handle = regs->a1;
>> +
>> +	while (RMI_RETURN_STATUS(regs->a0) == RMI_INCOMPLETE) {
>> +		bool can_cancel = RMI_RETURN_CAN_CANCEL(regs->a0);
>> +
>> +		switch (RMI_RETURN_MEMREQ(regs->a0)) {
>> +		case RMI_OP_MEM_REQ_NONE:
>> +			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
>> +					regs);
>> +			break;
>> +		default:
>> +			WARN_ON_ONCE(1);
>> +			if (!can_cancel)
>> +				return regs->a0;
>> +
>> +			cancelled = true;
>> +			rmi_op_cancel(sro_handle, regs);
> 
> [Severity: High]
> Could the same infinite loop vulnerability occur here for non-memory-transferring
> operations if the RMM continuously returns RMI_INCOMPLETE and an unexpected MEMREQ
> without clearing can_cancel?

No, a NON memory transferring SRO will always be that category. So a 
MEMREQ cannot come. I have added a similar check as above here too.

Suzuki


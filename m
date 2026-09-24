Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A392641F37F;
	Thu, 24 Sep 2026 23:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790291417; cv=none; b=QS3ZmAyzPM9uNSvwviUXrg82u1eiX04QTgAZjaDccDTEG+GsaXz3Wgo2SB4kNItcjaF6GWN5I5U9YAZqxRDcl2nVpkIj/OxZybSEzYVpQ+cWJwxmL2nu7w1UdyvN9oUMzrQOoFWB28gUbeK70HcJowIrKL4FyNGXBDmArl2fn8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790291417; c=relaxed/simple;
	bh=MAsw4rMdyYBh2hoAHkbiHo4qsLNPNTY9Yrm9SkveIo0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BNPua+5FUsHjE8tQRQPfoWqtvFMweDOChJbuNm4N8x1XMp/Ix3Xlld0IgoqH9VipYONOUXK5/RH5fm71SCPEJlMwA+mGqNMRg+x2NQ8f87E36usYWpJpkzyr7oA1WEJKBOtGyK0Vi3N0Tjpa3X4OCO7r3HRn/PBDRJ8EFtqUgik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fgbfYMYV; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fgbfYMYV"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35D731E5E;
	Thu, 24 Sep 2026 16:10:11 -0700 (PDT)
Received: from [10.57.10.88] (unknown [10.57.10.88])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E4E2F3F632;
	Thu, 24 Sep 2026 16:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790291414; bh=MAsw4rMdyYBh2hoAHkbiHo4qsLNPNTY9Yrm9SkveIo0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fgbfYMYVN+EzRtWlTRoyJsjOW3S1ltkysTXgJlmHnrPtzXUd95RZvly4/GiCRXQPh
	 uZGhWVspu3R2o5Y9gXjO97PXv4/HL2C9nPGX86r8gAk2fH7krIEgXsKATqnHIbdd+N
	 YmxN6b+8BtC9/6uSAZnTVtDzdl7Dxgekziwm3BZ8=
Message-ID: <78236751-8614-470f-9af5-78f160c5e486@arm.com>
Date: Fri, 25 Sep 2026 00:10:09 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 4/7] firmware: arm_rmm: Add support for SRO
Content-Language: en-GB
To: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-5-suzuki.poulose@arm.com>
 <20260924121356.00000d4d@oss.qualcomm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260924121356.00000d4d@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/09/2026 20:13, Jonathan Cameron wrote:
> On Thu, 24 Sep 2026 14:51:58 +0100
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> 
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
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Nice.  Everything I spotted this time around is pretty trivial.
> So assuming you'll clean up and bits that make sense to you for v20
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> 

Thanks, respones inline.

...


>> +
>> +int rmi_undelegate_range(phys_addr_t phys,
>> +			 unsigned long size)
>> +{
>> +	long ret = 0;
>> +	unsigned long top = phys + size;
>> +	unsigned long out_top;
>> +
>> +	while (phys < top) {
>> +		ret = rmi_granule_range_undelegate(phys, top, &out_top);
>> +
>> +		if (ret == RMI_SUCCESS) {
>> +			/* Buggy RMM ? Let the caller leak the pages */
>> +			if (WARN_ON(out_top <= phys))
>> +				return -ENXIO;
>> +			phys = out_top;
>> +		} else {
> 
> Similar to below, why not deal with error case first and reduce indent of
> the good path.
> 

...

>> + */
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
>> +
>> +		if (ret == RMI_SUCCESS) {
> 
> My instinct here would be to flip this and have the error out of line given
> it breaks anyway and that gives you smaller indent for that ocmment block.
> 
> 		if (ret != RMI_SUCCESS)
> 			break;
> 
> 		/*
> 		 * Buggy RMM ? Let the caller handle the failure. We can't know
> 		 * how far the RMM delegated in this iteration, so we return
>   		 * the best known good limit. RMM can deal with granules
> 		 * already in "undelegated" in a given range. So, it is fine
> 		 * for the caller to try the range we return.
> 		 */
> 		if (WARN_ON...
> 

Agree, it looks much cleaner. I have done that.
>> +
>> +static int rmi_sro_donate_noncontig(struct rmi_sro_state *sro,
>> +				    unsigned long sro_handle,
>> +				    unsigned long donatereq,
>> +				    struct arm_smccc_1_2_regs *out_regs,
>> +				    gfp_t gfp)

...

>> +
>> +	/* Gather the suitable entries to the end of the list */
>> +	i = 0;
>> +	while (i <  addr_list_start && found < count) {
>> +		unsigned long entry = sro->addr_list[i];
>> +
>> +		if (RMI_ADDR_RANGE_BLOCK_SIZE(entry) == block_size_fld &&
>> +		    RMI_ADDR_RANGE_COUNT(entry) == 1 &&
>> +		    RMI_ADDR_RANGE_STATE(entry) == state) {
>> +			addr_list_start--;
>> +			swap(sro->addr_list[addr_list_start],
>> +			     sro->addr_list[i]);
>> +			found++;
>> +			/* Continue from the swapped in entry */
>> +			continue;
>> +		}
>> +		/* skip past the entry */
> 
> Bit random on comment capitalization.  Have a quick final look through.
> For instance I think this one is Skip to match Continue above.
> 

Ack

>> +		i++;
>> +	}
> 
> ...
> 
> 
>> +
>> +static int rmi_sro_reclaim(struct rmi_sro_state *sro,
>> +			   unsigned long sro_handle,
>> +			   struct arm_smccc_1_2_regs *out_regs)
>> +{
>> +	unsigned long capacity;
>> +
>> +	/*
>> +	 * We don't do a partial free of the entries. So for
>> +	 * now free the entire address list as we prepare
>> +	 * to reclaim more from the RMM.
> 
> Rewrap to use all that nice space up to 80 chars!  I guess a refactoring
> side effect.
> 

Ack

>> +}
> 
>> +
>> +long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp)
>> +{
>> +	struct arm_smccc_1_2_regs *regs = &sro->regs;
>> +	bool cancelled = false;
>> +	unsigned long sro_handle;
>> +
>> +	rmi_smccc_invoke(regs);
>> +
>> +	sro_handle = regs->a1;
>> +	while (RMI_RESULT_STATUS(regs->a0) == RMI_INCOMPLETE) {
>> +		bool can_cancel = RMI_RESULT_CAN_CANCEL(regs->a0) == RMI_OP_CAN_CANCEL;
> 
> For a flag that is "can" or "cannot", do we need the RMI_OP_CAN_CANCEL (1) / RMI_OP_CANNOT_CANCEL (0)
> defines?  Doesn't feel like we'll ever get RMI_OP_UNKNOWN_IF_IT_CAN_CANCEL and I can't think
> of any other more reasonable options that would justify needing the explicit field value
> match.
> 
> To me
> 
> 		bool can_cancel = RMI_RESULT_CAN_CANCEL(regs->a0);
> 
> is obvious enough.  I don't care that much though so up to you.
> 

Yep, this was the original form and I changed it based on Gavin's
feedback. I would leave it as it is, to avoid another churn.



>> +	if (cancelled)
>> +		return -ECANCELED;
>> +
>> +	return regs->a0;
>> +}
>> +EXPORT_SYMBOL_GPL(rmi_sro_memxfer_execute);
>> +
>> +/*
>> + * rmi_sro_execute: Execute an RMI command that is Stateful but not memory
>> + * tranfserring. Takes regs, filled with the FIDs and the arguments in place.
> 
> Spell check. Transferring.  Also why does Stateful get a capital letter and
> Memory Transferring does not.  They seem to both be properties of the comman
> so I'd expect some consistency.

Ack

Thank you for the review !

Suzuki

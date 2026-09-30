Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F39063939A5;
	Wed, 30 Sep 2026 08:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790757915; cv=none; b=DjvcHuKJNJ8DxXgytuc97anYWSEgEuQTa6EeEx9BuRBQL5h11qPvMdY+btgR/sIj3dw+NeCb7qGqU0jWUwUhfw7vplLbBD3CnYgIJFkJELLytkXCxpTKefDD7B7+pqGZ+qLOY+UsyisS/4ImHIU5YfZlP94fV9418kcOnpVEGp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790757915; c=relaxed/simple;
	bh=LlMfh49OrB202DnvA3FcBRcY8l4AnsgG8bcahu0coJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JSRwFCDu21h9QHahK7ZyTpCFF4U5W2R//k9lVr96ICtQHDIZIVfXEljRmtIRmidxe5p7sb4nGXpAvdRfpzkgDy+1KwR2PiZbtgu+PydD2HtXx93zDQxeA3TSaQgJwQEUka5ckDW1jl2+lbac/Fy0vD5bbRwUxcMdtmbTBGLtmIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WQXyV1lK; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WQXyV1lK"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BC55143D;
	Wed, 30 Sep 2026 01:45:02 -0700 (PDT)
Received: from [10.57.9.178] (unknown [10.57.9.178])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7877D3F85F;
	Wed, 30 Sep 2026 01:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790757905; bh=LlMfh49OrB202DnvA3FcBRcY8l4AnsgG8bcahu0coJM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WQXyV1lKlTfAuVQ/7PtouFRJbl6QFhh4roDvpHBFTRl3fY0l91NduM3AJa5rng0Hj
	 S09u5UgbkNijosE/+5DmPbt6Ybdc5JLXmVj0sQEGRJNOZW71JSJDQJXkNUPs5AZPL4
	 +fV4DEgrv8LL8lkRfynpk7n5h174mniSCXLbAXa8=
Message-ID: <e12fb220-505a-44cc-bc43-4bd4ec0e9f7a@arm.com>
Date: Wed, 30 Sep 2026 09:45:03 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 4/9] firmware: arm_rmm: Add support for SRO
Content-Language: en-GB
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, Gavin Shan <gshan@redhat.com>,
 Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
 Steven Price <steven.price@arm.com>
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
 <20260929221623.1342076-5-suzuki.poulose@arm.com>
 <20260929223042.681D61F000FF@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260929223042.681D61F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Responses inline.

On 29/09/2026 23:30, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Medium] arm_rmm: SRO cancellation discards partial progress limit leading to memory corruption
> - [Medium] arm_rmm: integer overflow in granule clamp bypasses RMM protection
> - [Medium] arm_rmm: missing validation of block_size_fld leads to division by zero
> --
> 
> commit 44837285c82689401d14180cb932077aa7982b67
> Author: Steven Price <steven.price@arm.com>
> 
> firmware: arm_rmm: Add support for SRO
> 
> This commit introduces support for Stateful RMI Operations (SRO), allowing RMI
> commands to return incomplete and be resumed. It adds SRO state tracking,
> memory donation and reclaim handling, and wrappers for SRO commands.
> 
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
>> @@ -14,6 +15,687 @@
>> +static long rmi_granule_range_delegate(unsigned long base,
>> +				       unsigned long top,
>> +				       unsigned long *out_top)
>> +{
>> +	struct arm_smccc_1_2_regs regs = {
>> +		SMC_RMI_GRANULE_RANGE_DELEGATE, base, top
>> +	};
>> +	long ret = rmi_sro_execute(&regs);
>> +
>> +	if (ret == RMI_SUCCESS && out_top)
>> +		*out_top = regs.a1;
>> +
>> +	return ret;
>> +}
> [ ... ]
>> +static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
>> +				 unsigned long sro_handle,
>> +				 unsigned long donatereq,
>> +				 struct arm_smccc_1_2_regs *out_regs,
>> +				 gfp_t gfp)
>> +{
> [ ... ]
>> +mem_donate:
>> +	rmi_op_mem_donate(sro_handle,
>> +			  virt_to_phys(&sro->addr_list[sro->addr_count]), 1,
>> +			  0, out_regs);
>> +	donated_size = out_regs->a1 << PAGE_SHIFT;
>> +
>> +	if (WARN_ON(donated_size > size))
>> +		donated_size = size;
> 
> [Severity: Medium]
> Is there a risk of an integer overflow here before the bounds check?
> 
> If a buggy or compromised RMM returns a maliciously large value for
> out_regs->a1, the left shift by PAGE_SHIFT could overflow the 64-bit
> donated_size variable. This would result in a small value that bypasses
> the WARN_ON() check.

Fair point, this was due to the removal of donated_granules. I will
rectify this.

> 
> The host kernel might then erroneously believe the RMM consumed fewer
> granules than it actually did, freeing the remaining memory back to the
> allocator while the RMM is actively using it. This could result in memory
> corruption.
> 
> [ ... ]
>> +static int rmi_sro_donate_noncontig(struct rmi_sro_state *sro,
>> +				    unsigned long sro_handle,
>> +				    unsigned long donatereq,
>> +				    struct arm_smccc_1_2_regs *out_regs,
>> +				    gfp_t gfp)
>> +{
>> +	unsigned long block_size_fld = RMI_DONATE_BLOCK_SIZE(donatereq);
>> +	unsigned long block_size = rmi_addr_block_size_to_bytes(block_size_fld);
>> +	unsigned long count = RMI_DONATE_COUNT(donatereq);
>> +	unsigned long state = RMI_DONATE_STATE(donatereq);
>> +	unsigned long found = 0;
>> +	unsigned long donated_granules;
>> +	unsigned long granules_per_block = block_size >> PAGE_SHIFT;
>> +	unsigned long consumed_blocks;
> [ ... ]
>> +	donated_granules = out_regs->a1;
> [ ... ]
>> +	consumed_blocks = donated_granules / granules_per_block;
> 
> [Severity: Medium]
> Could an unvalidated block_size_fld lead to a division by zero panic here?
> 
> While count and state are explicitly validated against anomalies,
> block_size_fld from the firmware appears to be blindly trusted. If the
> firmware returns an out-of-bounds value (e.g., 6), the shift amount in
> rmi_addr_block_size_to_bytes() can evaluate modulo 64, yielding a block_size
> smaller than PAGE_SIZE.

This is not possible. The field is a 2bit field and cannot be greater
than 3. See the RMI_DONATE_BLOCK_SIZE()


> 
> This would cause granules_per_block to evaluate to 0, triggering a kernel
> panic when donated_granules is divided by granules_per_block.
> 
> [ ... ]
>> +long rmi_sro_execute(struct arm_smccc_1_2_regs *regs)
>> +{
>> +	bool cancelled = false;
>> +	unsigned long sro_handle;
> [ ... ]
>> +	if (cancelled)
>> +		return -ECANCELED;
>> +
>> +	return regs->a0;
>> +}
> 
> [Severity: Medium]
> When an operation is cancelled, does this unconditionally discard the
> output registers containing the partial progress limit?
> 
> If a buggy or compromised RMM returns an unexpected MEMREQ during a non-memory
> SRO like SMC_RMI_GRANULE_RANGE_DELEGATE, rmi_sro_execute() issues an
> RMI_OP_CANCEL and unconditionally returns -ECANCELED. This drops the final
> state in the a1 register.

We already WARN_ON_ONCE(1), when we get a memreq in a non-memory 
transferring SRO operation. There is nothing we could do in this case
from the generic helper, than to inform the caller that we had to
cancel it.

This is a fundamental misbehavior from an RMM implementation. There are
other ways the RMM could crash the host. e.g., Don't really undelegate
while reporting success. So, I wouldn't care about such pathological
cases.

Cheers
Suzuki


> 
> As a result, callers like rmi_granule_range_delegate() fail to capture
> the progress limit. The kernel would then undelegate fewer granules
> than the RMM successfully processed before returning them to the normal
> allocator, which can lead to fatal Granule Protection Faults when the host
> later accesses them.
> 


Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ABB04C14FC;
	Fri, 25 Sep 2026 15:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349110; cv=none; b=jTewiJkXnAaXcVpR9GVbeanVOmOxdaMxZNzKiSjhf/X1v6x8pf+Fjw8c51RQBZoD0uF/AL/0dylYDOur/53FzgXp4xPiocK35heIhKdWBzhj2aOTqhp+YOZEF5b8rhdOJLPEm3fAtgMCQHMskBxXNeSBK1MH6OZ5q8QnhK8XHO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349110; c=relaxed/simple;
	bh=wPC5lNilhf3g0ykmlhDe9z3lcOVejBMEEngMil4nDQo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C0jXSpvhTjSIE+7cG/vJB7kf6xNBnhv/yg8NTwrFvTD+/Zy6hm1I0gTOviyBUr5uES67lAzYf67cLOe5sMCGbrf417YYmBZK+HGMS85cc5+Phje6oQKKpGhuud8pd/p4feYSPMOljZe47qWrIuTirzx9K2jdHskQiiGePJ22if4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jQXFy/Z+; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jQXFy/Z+"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 108581688;
	Fri, 25 Sep 2026 08:11:31 -0700 (PDT)
Received: from [10.57.10.17] (unknown [10.57.10.17])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5DAFF3F86F;
	Fri, 25 Sep 2026 08:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790349094; bh=wPC5lNilhf3g0ykmlhDe9z3lcOVejBMEEngMil4nDQo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jQXFy/Z+hOKQzu4smPueogxcbPLKqe0jGtvG3FjpRmixbGar4J4NYMXhPcPqog6MN
	 HqUWHnxdA4c+Za2T8HTRoyf8J3kkA2wTdECa34oWJL1t6xpZsznO0zJkB+9tFCcylg
	 YDluTrvH3SJmD+BpUvnInL/ivQfaLlpO2Q65Iqtg=
Message-ID: <0c959443-6d4f-4dba-957c-420cb128b7cc@arm.com>
Date: Fri, 25 Sep 2026 16:11:29 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 4/7] firmware: arm_rmm: Add support for SRO
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-5-suzuki.poulose@arm.com> <arZgDmHV8uK1kv8R@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <arZgDmHV8uK1kv8R@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25/09/2026 12:50, Catalin Marinas wrote:
> On Thu, Sep 24, 2026 at 02:51:58PM +0100, Suzuki K Poulose wrote:
>> +static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
>> +				 unsigned long sro_handle,
>> +				 unsigned long donatereq,
>> +				 struct arm_smccc_1_2_regs *out_regs,
>> +				 gfp_t gfp)
>> +{
>> +	unsigned long block_size_fld = RMI_DONATE_BLOCK_SIZE(donatereq);
>> +	unsigned long block_size = rmi_addr_block_size_to_bytes(block_size_fld);
>> +	unsigned long count = RMI_DONATE_COUNT(donatereq);
>> +	unsigned long state = RMI_DONATE_STATE(donatereq);
>> +	unsigned long size = block_size * count;
>> +	unsigned long addr_range;
>> +	unsigned long donated_granules;
>> +	unsigned long donated_size;
>> +	int ret;
>> +	void *virt;
>> +	phys_addr_t phys;
>> +
>> +	/*
>> +	 * The RMM specification requires contiguous allocations are always a
>> +	 * power of 2
>> +	 */
>> +	if (WARN_ON_ONCE(!is_power_of_2(size)))
>> +		return -EINVAL;
>> +
>> +	/* Reuse the cached address range if we have one */
>> +	for (int i = 0; i < sro->addr_count; i++) {
>> +		unsigned long entry = sro->addr_list[i];
>> +
>> +		if (RMI_ADDR_RANGE_BLOCK_SIZE(entry) == block_size_fld &&
>> +		    RMI_ADDR_RANGE_COUNT(entry) == count &&
>> +		    RMI_ADDR_RANGE_STATE(entry) == state &&
>> +		    IS_ALIGNED(RMI_ADDR_RANGE_ADDR(entry), size)) {
>> +			sro->addr_count--;
>> +			swap(sro->addr_list[sro->addr_count],
>> +			     sro->addr_list[i]);
>> +
>> +			goto mem_donate;
>> +		}
>> +	}
>> +
>> +	ret = rmi_sro_ensure_capacity(sro, 1);
>> +	if (ret)
>> +		return ret;
>> +
>> +	virt = alloc_pages_exact(size, gfp);
>> +	if (!virt)
>> +		return -ENOMEM;
>> +	phys = virt_to_phys(virt);
>> +
>> +	if (state == RMI_OP_MEM_DELEGATED) {
>> +		phys_addr_t delegated_phys;
>> +
>> +		if (rmi_delegate_range(phys, size, &delegated_phys)) {
>> +			if (!rmi_undelegate_range(phys, delegated_phys - phys))
>> +				free_pages_exact(virt, size);
>> +			return -ENXIO;
>> +		}
>> +	}
>> +
>> +	addr_range = phys & RMI_ADDR_RANGE_ADDR_MASK;
>> +	FIELD_MODIFY(RMI_ADDR_RANGE_BLOCK_SIZE_MASK, &addr_range, block_size_fld);
>> +	FIELD_MODIFY(RMI_ADDR_RANGE_COUNT_MASK, &addr_range, count);
> 
> Courtesy of an LLM - if we get a contiguous/4K pages request for 4MB
> (1024 pages), the above 10-bit field becomes 0. Should we reject the
> request or the updated spec will guarantee this won't happen?

The spec is being updated to clamp the "maximum" count to match the
granule size. (Also called out in the Cover letter as "Known Issues")
This will be available with beta4 version of the spec.

> 
> Somewhat related, with RMI_BLOCK_L2 or higher and appropriate count we
> can easily go over the MAX_PAGE_ORDER allocation and fail alloc_pages()
> (the contig case). IIUC, the kernel can reject the donation but current
> TF-RMM does not report RMI_OP_CAN_CANCEL (R_SZVNK says it can be
> cancelled). It gets complicated if we want to support large contiguous

Ack, I will get this fixed in the TF-RMM.

> allocations here (e.g. alloc_contig_pages() can sleep). I'd rather just
> cancel the request, not support such large sizes.
> 
> [...]
> 
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
>> +	int addr_list_start = sro->addr_count;
>> +	int ret, i;
> 
> [...]
> 
>> +	for (int i = 0, src = addr_list_start + consumed_blocks;
> 
> Nit: we have 'int ret, i' earlier already, so you can drop the 'int'
> here.
> 
> [...]
> 
>> +/*
>> + * rmi_sro_execute: Execute an RMI command that is Stateful but not memory
>> + * tranfserring. Takes regs, filled with the FIDs and the arguments in place.
>> + *
>> + * Returns :
>> + *  -ECANCELLED - If the operation had to be aborted and SRO was cancellable.
> 
> Nit: -ECANCELED.
> 

Ack

>> + *  Otherwise, returns the result of the RMI command.
>> + */
>> +long rmi_sro_execute(struct arm_smccc_1_2_regs *regs)
>> +{
>> +	bool cancelled = false;
>> +	unsigned long sro_handle = regs->a1;
>> +
>> +	rmi_smccc_invoke(regs);
>> +
>> +	sro_handle = regs->a1;
> 
> Nit: drop the first initialisation maybe?

Of course, I will do that. Thanks for spotting.

Suzuki

> 


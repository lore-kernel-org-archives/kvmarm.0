Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 321C42FF675;
	Mon, 14 Sep 2026 14:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789394559; cv=none; b=fD+SWYx/I7wDem19nSHdtoIe8ugiP/JRUtYzaeVzVIzUL9VYhzAxe19xkj1rBlzN6vCB1BhBI71M/OzYgCRFmsmoB0B1limweMMuIp3c8asxaSIgYaMzo/+LEBIpjwJ5odzol3F/8QMIJUrQsj0WoCIOOT8ChE4OpdQbWrfQnpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789394559; c=relaxed/simple;
	bh=DFYtcB/Oi+25lkKqGHoqBfdSqnw6tByCRDZwTC/jjuI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MudTkFx9rufgmon/UmKGuSlUhzUB4fPjdrjIsOqZ+/8B2VwUxnO3WVZok/gBw61ZmTttPJELzOqQ4rOkQJC00b1OrP2qPGsP5JY4kqqxsxMhmIh4TtpFebUI1do2cpEPPhKuo3vcK7UDliL9j/R+Yus+xlfAoxuk8pGCb9iArW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=J2DNkFqm; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="J2DNkFqm"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DE99B1570;
	Mon, 14 Sep 2026 07:02:31 -0700 (PDT)
Received: from [10.0.128.139] (unknown [10.0.128.139])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 46F533F882;
	Mon, 14 Sep 2026 07:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789394555; bh=DFYtcB/Oi+25lkKqGHoqBfdSqnw6tByCRDZwTC/jjuI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J2DNkFqmdAiXns7yDGCaFHwY8+MPmxxjgt9Snm1UwvQlYakyn6BB2oxIq1rBTjCIH
	 FdEDRRxKwxS1Jcc6S1Sxuh21VJWfmDFFXBO9vsG8aT15x4/yCn7US+Qkxxo0jiZqy4
	 Y2hcEdw0cSqvDxWgRPcZlKLynkxxaLcdLy5rGLfY=
Message-ID: <657e69c2-d0e9-433a-b0d2-4f16bc94ee2c@arm.com>
Date: Mon, 14 Sep 2026 15:02:30 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 4/7] firmware: arm_rmm: Add support for SRO
Content-Language: en-GB
To: Sudeep Holla <sudeep.holla@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-5-suzuki.poulose@arm.com>
 <20260914-talkative-healthy-pogona-334c03@sudeepholla>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260914-talkative-healthy-pogona-334c03@sudeepholla>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/09/2026 13:50, Sudeep Holla wrote:
> On Sat, Sep 12, 2026 at 09:36:07AM +0100, Suzuki K Poulose wrote:
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
>> Co-Developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
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
>> +
>> +	int ret;
>> +
>> +	for (int i = 0; i < addr_list_start && found < count; i++) {
>> +		unsigned long entry = sro->addr_list[i];
>> +
>> +		if (RMI_ADDR_RANGE_BLOCK_SIZE(entry) == block_size_fld &&
>> +		    RMI_ADDR_RANGE_COUNT(entry) == 1 &&
>> +		    RMI_ADDR_RANGE_STATE(entry) == state) {
>> +			addr_list_start--;
>> +			swap(sro->addr_list[addr_list_start],
>> +			     sro->addr_list[i]);
>> +			found++;
>> +			i--;
>> +		}
>> +	}
>> +
>> +	ret = rmi_sro_ensure_capacity(sro, count - found);
>> +	if (ret)
>> +		return ret;
>> +
>> +	while (found < count) {
>> +		unsigned long addr_range;
>> +		void *virt = alloc_pages_exact(block_size, gfp);
>> +		phys_addr_t phys;
>> +
>> +		if (!virt)
>> +			return -ENOMEM;
>> +
>> +		phys = virt_to_phys(virt);
>> +
>> +		if (state == RMI_OP_MEM_DELEGATED) {
> 
> Based on my understanding, rmi_sro_memxfer_execute() is an exported function
> and can be invoked by any module. The donatereq argument appears to accept one
> of three operations:
> 
> RMI_OP_MEM_DELEGATED
> RMI_OP_MEM_UNDELEGATED
> RMI_OP_MEM_CONDITIONAL

Ack

> 
> Currently, the check confirming the state is RMI_OP_MEM_DELEGATED occurs
> relatively late in the function execution. It seems this function is
> explicitly designed to handle only RMI_OP_MEM_DELEGATED.

No, that is not correct. The function handles both OP_MEM_DELEGATED and
OP_MEM_UNDELEGATED. In the former case, we explicitly "delegate" the
pages before donating. The "UNDELEGATED" case doesn't need to do that
extra step.

> 
> Given that this is an exported interface, would it make sense to
> fail-fast by moving this validation to the very beginning of the function?
> Even if RMI_OP_MEM_CONDITIONAL is intended for future use, it should

Yep, agree. We can rejec the CONDITIONAL ones.

> probably be rejected as invalid for now. Also, it is not clear why the
> current check is inside the loop while the state itself doesn't get
> modified.

As above, that check is additionally preparing the memory for RMM
consumption.


> 
> If this is a valid concern, the same architectural pattern should likely be
> applied to rmi_sro_donate_contig().
> 

Ack, we can reject the CONDITIONAL ones.

Suzuki


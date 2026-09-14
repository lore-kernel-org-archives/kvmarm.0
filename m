Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 246783D6475;
	Mon, 14 Sep 2026 14:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789397290; cv=none; b=MD3W3Ojw3OzcqKTIwEnSdEhGQdxPomgvd7BsQay6vLV4KWNtoYUN3e0p6GxWXBYI7hcko6RRqtQPw2Prs/71a+eRwGYO4gKD78Q2OmMXQKOmiuacRLzjz53dOlYtDu1GaJyJq0C2cMl0Mo+lOSeGuLvcXyme31WAfB5Qa2A8gP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789397290; c=relaxed/simple;
	bh=sSuxvUZK/IInSTh3DMry4fm7u0hI8Ny9M1h4ityWlBI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=MGkd+eLe3nm0rEyYYKOVQpWqI7sPl3vMQIZO2TD4G2qxocUjdDTWrttcwZFktT3bjQB3fF+9bHhUBluX0JnMA11/aBrKnk4KAVdt5ShWF9JUQfP7KyIRLgS8E17NrdyfP4ZDi5UtnK7NAypcH+lBjpA335wKLRNFl8HhoJ5Plj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RDKoacyi; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RDKoacyi"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 18646153B;
	Mon, 14 Sep 2026 07:47:58 -0700 (PDT)
Received: from [10.0.128.139] (unknown [10.0.128.139])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F20BB3F86F;
	Mon, 14 Sep 2026 07:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789397281; bh=sSuxvUZK/IInSTh3DMry4fm7u0hI8Ny9M1h4ityWlBI=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=RDKoacyiTEJcsnBood+kw6BJnBDDLH+xWOGOm6H1cuAOovgJDoklW3GMfhm4kiyXw
	 bt5sMro68jYrRvGKIW7SRj5qwGXjpsFt150Xc8J274C1qzAGTpQWJs/IzKGVgX4AoL
	 1B3JAd6cJRUW0jr84JP8ygSYFjCHkQ5JHh7cYJYM=
Message-ID: <d5541663-3b64-4aaa-9ac6-b07ac0bc2c8a@arm.com>
Date: Mon, 14 Sep 2026 15:47:57 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 4/7] firmware: arm_rmm: Add support for SRO
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
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
 <657e69c2-d0e9-433a-b0d2-4f16bc94ee2c@arm.com>
In-Reply-To: <657e69c2-d0e9-433a-b0d2-4f16bc94ee2c@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14/09/2026 15:02, Suzuki K Poulose wrote:
> On 14/09/2026 13:50, Sudeep Holla wrote:
>> On Sat, Sep 12, 2026 at 09:36:07AM +0100, Suzuki K Poulose wrote:
>>> RMM v2.0 introduces the concept of "Stateful RMI Operations" (SRO). This
>>> means that an SMC can return with an operation still in progress. The
>>> host is expected to continue the operation until it reaches a conclusion
>>> (either success or failure). During this process the RMM can request
>>> additional memory ('donate') or hand memory back to the host
>>> ('reclaim'). The host can request an in progress operation is cancelled,
>>> but still continue the operation until it has completed (otherwise the
>>> incomplete operation may cause future RMM operations to fail).
>>>
>>> The SRO is tracked using a struct rmi_sro_state object which keeps track
>>> of any memory which has been allocated but not yet consumed by the RMM
>>> or reclaimed from the RMM. This allows the memory to be reused in a
>>> future request within the same operation. It will also permit an
>>> operation to be done in a context where memory allocation may be
>>> difficult (e.g. atomic context) with the option to abort the operation
>>> and retry the memory allocation outside of the atomic context. The
>>> memory stored in the struct rmi_sro_state object can then be reused on
>>> the subsequent attempt.
>>>
>>> Wrappers for SRO RMI commands are also provided here because they depend
>>> on the rmi_sro_execute() implementation added by this patch.
>>> Delegate/undelegate handles are also added here because they now use the
>>> SRO/stateful command infrastructure and are also used for the memory
>>> DONATE/RECLAIM flows.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> Co-Developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> [...]
>>
>>> +static int rmi_sro_donate_noncontig(struct rmi_sro_state *sro,
>>> +                    unsigned long sro_handle,
>>> +                    unsigned long donatereq,
>>> +                    struct arm_smccc_1_2_regs *out_regs,
>>> +                    gfp_t gfp)
>>> +{
>>> +    unsigned long block_size_fld = RMI_DONATE_BLOCK_SIZE(donatereq);
>>> +    unsigned long block_size = 
>>> rmi_addr_block_size_to_bytes(block_size_fld);
>>> +    unsigned long count = RMI_DONATE_COUNT(donatereq);
>>> +    unsigned long state = RMI_DONATE_STATE(donatereq);
>>> +    unsigned long found = 0;
>>> +    unsigned long donated_granules;
>>> +    unsigned long granules_per_block = block_size >> PAGE_SHIFT;
>>> +    unsigned long consumed_blocks;
>>> +    int addr_list_start = sro->addr_count;
>>> +
>>> +    int ret;
>>> +
>>> +    for (int i = 0; i < addr_list_start && found < count; i++) {
>>> +        unsigned long entry = sro->addr_list[i];
>>> +
>>> +        if (RMI_ADDR_RANGE_BLOCK_SIZE(entry) == block_size_fld &&
>>> +            RMI_ADDR_RANGE_COUNT(entry) == 1 &&
>>> +            RMI_ADDR_RANGE_STATE(entry) == state) {
>>> +            addr_list_start--;
>>> +            swap(sro->addr_list[addr_list_start],
>>> +                 sro->addr_list[i]);
>>> +            found++;
>>> +            i--;
>>> +        }
>>> +    }
>>> +
>>> +    ret = rmi_sro_ensure_capacity(sro, count - found);
>>> +    if (ret)
>>> +        return ret;
>>> +
>>> +    while (found < count) {
>>> +        unsigned long addr_range;
>>> +        void *virt = alloc_pages_exact(block_size, gfp);
>>> +        phys_addr_t phys;
>>> +
>>> +        if (!virt)
>>> +            return -ENOMEM;
>>> +
>>> +        phys = virt_to_phys(virt);
>>> +
>>> +        if (state == RMI_OP_MEM_DELEGATED) {
>>
>> Based on my understanding, rmi_sro_memxfer_execute() is an exported 
>> function
>> and can be invoked by any module. The donatereq argument appears to 
>> accept one
>> of three operations:
>>
>> RMI_OP_MEM_DELEGATED
>> RMI_OP_MEM_UNDELEGATED
>> RMI_OP_MEM_CONDITIONAL
> 
> Ack
> 
>>
>> Currently, the check confirming the state is RMI_OP_MEM_DELEGATED occurs
>> relatively late in the function execution. It seems this function is
>> explicitly designed to handle only RMI_OP_MEM_DELEGATED.
> 
> No, that is not correct. The function handles both OP_MEM_DELEGATED and
> OP_MEM_UNDELEGATED. In the former case, we explicitly "delegate" the
> pages before donating. The "UNDELEGATED" case doesn't need to do that
> extra step.
> 
>>
>> Given that this is an exported interface, would it make sense to
>> fail-fast by moving this validation to the very beginning of the 
>> function?
>> Even if RMI_OP_MEM_CONDITIONAL is intended for future use, it should
> 
> Yep, agree. We can rejec the CONDITIONAL ones.

For the record, the CONDITIONAL ones are required for self-describing
cases for L1_GPT_CREATE and TRACKING_GRANULE_SET, where the RMM could
accept DELEGATED granules for the objects (if not self describing) or
UNDELEGATED granules  (if they are self-describing).

For now, we don't support such RMMs, so will reject the type for now.

Cheers
Suzuki

> 
>> probably be rejected as invalid for now. Also, it is not clear why the
>> current check is inside the loop while the state itself doesn't get
>> modified.
> 
> As above, that check is additionally preparing the memory for RMM
> consumption.
> 
> 
>>
>> If this is a valid concern, the same architectural pattern should 
>> likely be
>> applied to rmi_sro_donate_contig().
>>
> 
> Ack, we can reject the CONDITIONAL ones.
> 
> Suzuki
> 


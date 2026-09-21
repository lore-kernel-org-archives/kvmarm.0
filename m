Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BFF7496D39;
	Mon, 21 Sep 2026 12:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994539; cv=none; b=lw7AMy1g8m7J5hOqTyiQf0mS1jkAOW1s+zMErwJ7JYccDw6+LLfo8lll2QbgY6grTo2iLVM0jr35w2ksj1nERuBnL7lJXIyEiRpU6L0k0AnUTl9gbmiztD5RtBBA7J9SjkETpsw2Nlcl4DESNddLH6qYKgYP/bIm2iRgItNKTRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994539; c=relaxed/simple;
	bh=IRpX+ZEp/zVlKdL3h+SzNZQpQmKb6Y0IMlPZO81/S6c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GBFMdvrYOPR6oc5hU601apxt8IdGupeaVrYXQvUjyhuXVMAvQX+pbQOYtE5eQG3SHCc41VOe20ppddTsYFTLJFsjQ12gVPeDAppWi6h8y7KiMkeiqnsBScD/05MsuTbdZW6gkxwBQOdNWeV+ki3QmE7LSwbdyMOGVkcDGa1qzEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eQGWfG0T; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eQGWfG0T"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 36E811D13;
	Mon, 21 Sep 2026 05:42:13 -0700 (PDT)
Received: from [10.0.128.141] (unknown [10.0.128.141])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5ADB83F86C;
	Mon, 21 Sep 2026 05:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789994536; bh=IRpX+ZEp/zVlKdL3h+SzNZQpQmKb6Y0IMlPZO81/S6c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eQGWfG0TNldwMTREH8bTh8H+1w65s5SsyxtYASsAlYAaZhM8/Zie7v82Mz2jl0q9d
	 zxAeSIJPe+dB5+sJ8mob10j+F/7snho7KhyQ+JbciEj5KvoFXiLNlzC3lNDR/4jHEl
	 3xtE0k19WjVMcp+/ILdArlTZ7OInKPcsQie2e8do=
Message-ID: <bbb2f1db-5d42-495f-b34e-184a6cd894ce@arm.com>
Date: Mon, 21 Sep 2026 13:42:11 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 4/7] firmware: arm_rmm: Add support for SRO
Content-Language: en-GB
To: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
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
 <178978126542.2352296.15676256806777454164.b4-review@b4>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <178978126542.2352296.15676256806777454164.b4-review@b4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19/09/2026 02:27, Jonathan Cameron wrote:
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
> Hi Suzuki.
> 
> A few comments and questions on the array for the cache of
> allocations.
> 
> Jonathan
> 
>> ---
>>   drivers/firmware/arm_rmm/rmi.c | 586 +++++++++++++++++++++++++++++++++
>>   include/linux/arm-rmi-cmds.h   |  41 +++
>>   2 files changed, 627 insertions(+)
>>
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
>> index 5b0e342ce3d5..4f9898ece754 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
>> @@ -15,6 +15,59 @@
>>   #define RMI_FEAT_REG_COUNT	2
>>   static unsigned long rmi_feat_reg_cache[RMI_FEAT_REG_COUNT] __ro_after_init;
> 

Was there a question here you missed ? FWIW:

I have expanded this to cover all 5 RmiFeatureRegisters exposed by RMM, 
and it looks something like this now, with the use of ARRAY_SIZE() to
limit accesses.


/* RMM defines RmiFeatureRegister0 to RmiFeatureRegister5. */
static unsigned long rmi_feat_reg_cache[5] __ro_after_init;

> 
> 
>> +static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
>> +				 unsigned long sro_handle,
>> +				 unsigned long donatereq,
>> +				 struct arm_smccc_1_2_regs *out_regs,
>> +				 gfp_t gfp)

...

>> +	addr_range = phys & RMI_ADDR_RANGE_ADDR_MASK;
>> +	FIELD_MODIFY(RMI_ADDR_RANGE_BLOCK_SIZE_MASK, &addr_range, block_size_fld);
>> +	FIELD_MODIFY(RMI_ADDR_RANGE_COUNT_MASK, &addr_range, count);
>> +	FIELD_MODIFY(RMI_ADDR_RANGE_STATE_MASK, &addr_range, state);
>> +
>> +	sro->addr_list[sro->addr_count] = addr_range;
>> +
>> +out:
> 
> This doesn't smell like an 'out' - as the real works is done down
> here.

Ack, I have renamed it to "donate:"

>> +
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
> 
> I guess putting that as a predecrement in the swap is a little
> too obscure.
> 
> Maybe a comment for this whole loop that it is gathering up
> useable entries by moving them to the end of the bit of the
> array that is already in use.  Neat little bit of code but takes a little
> more thinking about than might be ideal when we look at this
> 10 years down the line.  Maybe it's just that it is Friday...
> 
>> +			swap(sro->addr_list[addr_list_start],
>> +			     sro->addr_list[i]);
>> +			found++;
>> +			i--;
> 
> Rather than decrement the loop variable, maybe a goto and a label
> for try_new_entry or something like that?  Even a comment might
> be useful.

Ack. I think a while loop makes it look a bit better with
comments. e.g.:

@@ -356,9 +356,11 @@ static int rmi_sro_donate_noncontig(struct 
rmi_sro_state *sro,
         unsigned long granules_per_block = block_size >> PAGE_SHIFT;
         unsigned long consumed_blocks;
         int addr_list_start = sro->addr_count;
-       int ret;
+       int ret, i;

-       for (int i = 0; i < addr_list_start && found < count; i++) {
+       /* Gather the suitable entries to the end of the list */
+       i = 0;
+       while (i <  addr_list_start && found < count) {
                 unsigned long entry = sro->addr_list[i];

                 if (RMI_ADDR_RANGE_BLOCK_SIZE(entry) == block_size_fld &&
@@ -368,8 +370,11 @@ static int rmi_sro_donate_noncontig(struct 
rmi_sro_state *sro,
                         swap(sro->addr_list[addr_list_start],
                              sro->addr_list[i]);
                         found++;
-                       i--;
+                       /* Continue from the swapped in entry */
+                       continue;
                 }
+               /* skip past the entry */
+               i++;
         }

> 
>> +		}
>> +	}
>> +
>> +	ret = rmi_sro_ensure_capacity(sro, count - found);
>> +	if (ret)
>> +		return ret;
> 
> Will this normally succeed? Feels like we could have a lot
> of useless entrees at the start of the storage, so no room to
> enough extra ones.

That is true. In this case, we should be able to proceed to
donate as much as we have been able to gather and retry
the donation in the next iteration, by freeing up the
cached ones.
         ret = rmi_sro_ensure_capacity(sro, count - found);
-       if (ret)
-               return ret;
+       if (ret) {
+               /* If we have found some entries, donate them and try 
again */
+               if (found)
+                       goto mem_donate;
+               /* Otherwise, free up the list and start again */
+               rmi_sro_free(sro);
+       }

-       while (found < count) {
+       for (; found < count; found++) {
                 unsigned long addr_range;
                 void *virt = alloc_pages_exact(block_size, gfp);
                 phys_addr_t phys;
@@ -403,12 +413,12 @@ static int rmi_sro_donate_noncontig(struct 
rmi_sro_state *sro,
                 FIELD_MODIFY(RMI_ADDR_RANGE_STATE_MASK, &addr_range, 
state);

                 sro->addr_list[sro->addr_count++] = addr_range;
-               found++;
         }

+mem_donate:
         rmi_op_mem_donate(sro_handle,
                           virt_to_phys(&sro->addr_list[addr_list_start]),
-                         count, 0, out_regs);
+                         found, 0, out_regs);

>> +
>> +	while (found < count) {
> 
> For loop seems more natural to me given the bounds are known
> and found is only incremented at the end.

Ack

> 
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
>> +			phys_addr_t delegated_phys;
>> +
>> +			if (rmi_delegate_range(phys, block_size,
>> +					       &delegated_phys)) {
> 
> Go long. It is shorter than the line that follows anyway!

Ack

>> +
>> +	/* Keep just the blocks the RMM didn't use in addr_list */
>> +	for (int i = consumed_blocks; i < count; i++)
>> +		sro->addr_list[addr_list_start + i - consumed_blocks] =
>> +			sro->addr_list[addr_list_start + i];
> 
> Maybe memmove to make it clear you are shifting a chunk of the array
> down.  This might be worth some asci art showing each step in brief.
> Anyhow, something along these lines:
> 
>        memmove(&sro->addr_list[addr_list_start],
> 	      &sro->addr_list[addr_list_start + consumed_blocks],
> 	      (count - consumed_blocks) * sizeof(*sro->addr_list));
> 
> Obviously doesn't save code, but maybe simpler to understand than
> the loop.
> 		

Does the following hunk look better with the comment ?

         /*
          * Keep just the blocks the RMM didn't use in addr_list.
          * RMM claimed consumed_blocks entries from addr_list_start.
          * Move the entries left out at the end i.e.
          * [ addr_list_start + consumed_blocks, addr_list_start + found)
          * to the rest of the valid entries and adjust the addr_count to
          * reflect the available entries.
          */
         for (int i = 0, src = addr_list_start + consumed_blocks;
                 i < found - consumed_blocks; i++)
                 sro->addr_list[addr_list_start + i] = 
sro->addr_list[src + i];

         sro->addr_count -= consumed_blocks;

> 
>> +}
>> +
>> +static int rmi_sro_reclaim(struct rmi_sro_state *sro,
>> +			   unsigned long sro_handle,
>> +			   struct arm_smccc_1_2_regs *out_regs)
>> +{
>> +	unsigned long capacity;
>> +
>> +	if (rmi_sro_ensure_capacity(sro, 1))
>> +		rmi_sro_free(sro);
> 
> Maybe a comment on why you free the whole lot rather than a smaller
> amount to make some room.

We don't do partial free of the list today, and having that is
unnecssarily complicating the logic/code. We are going to do a reclaim 
anyways. Sure, I could add a comment.


> 
>> +
>> +	capacity = RMI_MAX_ADDR_LIST - sro->addr_count;
>> +
>> +	rmi_op_mem_reclaim(sro_handle,
>> +			   virt_to_phys(&sro->addr_list[sro->addr_count]),
>> +			   capacity, out_regs);
>> +
>> +	/*
>> +	  * RMI_OP_MEM_RECLAIM always return RMI_INCOMPLETE, except when the
>> +	  * input parameters were invalid.
>> +	  */
>> +	if (WARN_ON_ONCE(RMI_RETURN_STATUS(out_regs->a0) != RMI_INCOMPLETE))
>> +		return -EINVAL;
>> +	if (WARN_ON_ONCE(out_regs->a1 > capacity))
>> +		out_regs->a1 = capacity;
> I guess this should never happen, but bit ugly to fixup the register
> return rather than perhaps using a local variable instead.

We pass/get the out_regs, so local variable doesn't work, unless
I missed what you were hinting at..

> Obviously doesn't matter in practice.

> 
>> +	sro->addr_count += out_regs->a1;
>> +
>> +	return 0;
>> +}
> 
>> +
>> +/* For RMI commands that are stateful but not memory-transferring */
> 
> Given this is exported, maybe some docs on return values etc?
> Similar for the other exported funcitons.

Ack

> 
>> +long rmi_sro_execute(struct arm_smccc_1_2_regs *regs)
>> +{
>> +	bool cancelled = false;
>> +	unsigned long sro_handle = regs->a1;
>> +
>> +	rmi_smccc_invoke(regs);
>> +
>> +	sro_handle = regs->a1;
>> +	while (RMI_RETURN_STATUS(regs->a0) == RMI_INCOMPLETE) {
>> +		bool can_cancel = RMI_RETURN_CAN_CANCEL(regs->a0) == RMI_OP_CAN_CANCEL;
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
>> +			/* If we have already cancelled, don't retry this */
> 
> Maybe expand that comment a little to say if we can get here under a
> valid sequence and if so are we guaranteed that cancel is complete
> given that is what caller will probably expect if it gets -ECANCELED.
> 
> My reading of spec would suggest we can't hit this path for the
> calls that are not memory tranferring. Then again we can't hit the
> first cancel either so all bets are off.  So maybe this is the
> bet we can do.  Also can_cancel shouldn't be true after
> rmi_op_cancel() as I assume you can't cancel a cancel.

Ack.  This was to handle a buggy RMM (and soothing an LLM bot)

Thank you for the review.

Cheers
Suzuki


> 


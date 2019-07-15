Return-Path: <SRS0=W8aC=VM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF6EC7618F
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jul 2019 17:06:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5E2D42080A
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jul 2019 17:06:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E2D42080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEE574A525;
	Mon, 15 Jul 2019 13:06:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9a636E62oeBg; Mon, 15 Jul 2019 13:06:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 735464A4E8;
	Mon, 15 Jul 2019 13:06:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 434D54A4A9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jul 2019 13:06:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0QSKBrE7MggY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jul 2019 13:06:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AFC14A418
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jul 2019 13:06:31 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D06328;
 Mon, 15 Jul 2019 10:06:31 -0700 (PDT)
Received: from [10.1.196.50] (e108454-lin.cambridge.arm.com [10.1.196.50])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A41773F59C;
 Mon, 15 Jul 2019 10:06:29 -0700 (PDT)
Subject: Re: [RFC v2 14/14] kvm/arm: Align the VMID allocation with the arm64
 ASID one
To: James Morse <james.morse@arm.com>
References: <20190620130608.17230-1-julien.grall@arm.com>
 <20190620130608.17230-15-julien.grall@arm.com>
 <39d47f54-459f-ce07-91c0-0158896a6783@arm.com>
From: Julien Grall <julien.grall@arm.com>
Message-ID: <4d926abe-9cdb-536d-43ee-7f14a84b0246@arm.com>
Date: Mon, 15 Jul 2019 18:06:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <39d47f54-459f-ce07-91c0-0158896a6783@arm.com>
Content-Language: en-US
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 03/07/2019 18:36, James Morse wrote:
> Hi Julien,

Hi James,

> On 20/06/2019 14:06, Julien Grall wrote:
>> At the moment, the VMID algorithm will send an SGI to all the CPUs to
>> force an exit and then broadcast a full TLB flush and I-Cache
>> invalidation.
>>
>> This patch re-use the new ASID allocator. The
>> benefits are:
>>      - CPUs are not forced to exit at roll-over. Instead the VMID will be
>>      marked reserved and the context will be flushed at next exit. This
>>      will reduce the IPIs traffic.
>>      - Context invalidation is now per-CPU rather than broadcasted.
> 
> + Catalin has a model of the asid-allocator.

That's a good point :).

> 
> 
>> With the new algo, the code is now adapted:
>>      - The function __kvm_flush_vm_context() has been renamed to
>>      __kvm_flush_cpu_vmid_context and now only flushing the current CPU context.
>>      - The call to update_vttbr() will be done with preemption disabled
>>      as the new algo requires to store information per-CPU.
>>      - The TLBs associated to EL1 will be flushed when booting a CPU to
>>      deal with stale information. This was previously done on the
>>      allocation of the first VMID of a new generation.
>>
>> The measurement was made on a Seattle based SoC (8 CPUs), with the
>> number of VMID limited to 4-bit. The test involves running concurrently 40
>> guests with 2 vCPUs. Each guest will then execute hackbench 5 times
>> before exiting.
> 
>> diff --git a/arch/arm64/include/asm/kvm_asid.h b/arch/arm64/include/asm/kvm_asid.h
>> new file mode 100644
>> index 000000000000..8b586e43c094
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/kvm_asid.h
>> @@ -0,0 +1,8 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef __ARM64_KVM_ASID_H__
>> +#define __ARM64_KVM_ASID_H__
>> +
>> +#include <asm/asid.h>
>> +
>> +#endif /* __ARM64_KVM_ASID_H__ */
>> +
>> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
>> index ff73f5462aca..06821f548c0f 100644
>> --- a/arch/arm64/include/asm/kvm_asm.h
>> +++ b/arch/arm64/include/asm/kvm_asm.h
>> @@ -62,7 +62,7 @@ extern char __kvm_hyp_init_end[];
>>   
>>   extern char __kvm_hyp_vector[];
>>   
>> -extern void __kvm_flush_vm_context(void);
>> +extern void __kvm_flush_cpu_vmid_context(void);
>>   extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
> 
> As we've got a __kvm_tlb_flush_local_vmid(), would __kvm_tlb_flush_local_all() fit in
> better? (This mirrors local_flush_tlb_all() too)

I am happy with the renaming here.

> 
> 
>>   extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
>>   extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 4bcd9c1291d5..7ef45b7da4eb 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -68,8 +68,8 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext);
>>   void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
>>   
>>   struct kvm_vmid {
>> -	/* The VMID generation used for the virt. memory system */
>> -	u64    vmid_gen;
>> +	/* The ASID used for the ASID allocator */
>> +	atomic64_t asid;
> 
> Can we call this 'id' as happens in mm_context_t? (calling it asid is confusing)

I am fine with this suggestion.

> 
>>   	u32    vmid;
> 
> Can we filter out the generation bits in kvm_get_vttbr() in the same way the arch code
> does in cpu_do_switch_mm().
> 
> I think this saves writing back a cached pre-filtered version every time, or needing
> special hooks to know when the value changed. (so we can remove this variable)

[...]

>> +static void vmid_update_ctxt(void *ctxt)
>>   {
>> +	struct kvm_vmid *vmid = ctxt;
>> +	u64 asid = atomic64_read(&vmid->asid);
> 
>> +	vmid->vmid = asid & ((1ULL << kvm_get_vmid_bits()) - 1);
> 
> I don't like having to poke this through the asid-allocator as a kvm-specific hack. Can we
> do it in kvm_get_vttbr()?

I will have a look.

> 
> 
>>   }
> 
>> @@ -487,48 +467,11 @@ static bool need_new_vmid_gen(struct kvm_vmid *vmid)
> 
> (git made a mess of the diff here... squashed to just the new code:)
> 
>>   static void update_vmid(struct kvm_vmid *vmid)
>>   {
> 
>> +	int cpu = get_cpu();
>>   
>> +	asid_check_context(&vmid_info, &vmid->asid, cpu, vmid);
>>   
>> +	put_cpu();
> 
> If we're calling update_vmid() in a pre-emptible context, aren't we already doomed?

Yes we are. This made me realize that Linux-RT replaced the preempt_disable() in 
the caller by migrate_disable(). The latter will prevent the task to move to 
another CPU but allow preemption.

This patch will likely makes things awfully broken for Linux-RT. I will have a 
look to see if we can call this from preempt notifier.

> 
> Could we use smp_processor_id() instead.
> 
> 
>>   }
> 
> 
>> @@ -1322,6 +1271,8 @@ static void cpu_init_hyp_mode(void *dummy)
>>   
>>   	__cpu_init_hyp_mode(pgd_ptr, hyp_stack_ptr, vector_ptr);
>>   	__cpu_init_stage2();
> 
> 
>> +	kvm_call_hyp(__kvm_flush_cpu_vmid_context);
> 
> I think we only need to do this for VHE systems too. cpu_hyp_reinit() only does the call
> to cpu_init_hyp_mode() if !is_kernel_in_hyp_mode().

I guess you mean we need to do this for VHE system. If so, I agree that 
cpu_init_hyp_mode() is not the best place. I will move it to cpu_hyp_reinit().

> 
> 
>>   }
>>   
>>   static void cpu_hyp_reset(void)
>> @@ -1429,6 +1380,17 @@ static inline void hyp_cpu_pm_exit(void)
>>   
>>   static int init_common_resources(void)
>>   {
>> +	/*
>> +	 * Initialize the ASID allocator telling it to allocate a single
>> +	 * VMID per VM.
>> +	 */
>> +	if (asid_allocator_init(&vmid_info, kvm_get_vmid_bits(), 1,
>> +				vmid_flush_cpu_ctxt, vmid_update_ctxt))
>> +		panic("Failed to initialize VMID allocator\n");
> 
> Couldn't we return an error instead? The asid allocator is needed for user-space, its
> pointless to keep running if it fails. The same isn't true here. (and it would make it
> easier to debug what went wrong!)

Fair point. I will update the next version.

Cheers,

-- 
Julien Grall
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

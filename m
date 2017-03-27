From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Signal SIGBUS when stage2 discovers
 hwpoison memory
Date: Mon, 27 Mar 2017 14:38:13 +0100
Message-ID: <3ef9c87d-bbf5-110e-cfb4-cb88410e45bb@arm.com>
References: <20170315160727.16465-1-james.morse@arm.com>
 <20170324183044.GK25903@cbox> <87y3vrezjb.fsf@e105922-lin.cambridge.arm.com>
 <58D8FEF8.9000205@arm.com> <20170327124459.GA21871@cbox>
 <87mvc6g81r.fsf@e105922-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 260E040BE3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 09:36:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V153zlZw2Ffa for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 09:36:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9EB7405DA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 09:36:18 -0400 (EDT)
In-Reply-To: <87mvc6g81r.fsf@e105922-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Punit Agrawal <punit.agrawal@arm.com>, Christoffer Dall <cdall@linaro.org>
Cc: Tyler Baicar <tbaicar@codeaurora.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, gengdongjiu <gengdj.1984@gmail.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 27/03/17 14:31, Punit Agrawal wrote:
> Christoffer Dall <cdall@linaro.org> writes:
> 
>> On Mon, Mar 27, 2017 at 01:00:56PM +0100, James Morse wrote:
>>> Hi guys,
>>>
>>> On 27/03/17 12:20, Punit Agrawal wrote:
>>>> Christoffer Dall <cdall@linaro.org> writes:
>>>>> On Wed, Mar 15, 2017 at 04:07:27PM +0000, James Morse wrote:
>>>>>> Once we enable ARCH_SUPPORTS_MEMORY_FAILURE on arm64[0], notifications for
>>>>>> broken memory can call memory_failure() in mm/memory-failure.c to deliver
>>>>>> SIGBUS to any user space process using the page, and notify all the
>>>>>> in-kernel users.
>>>>>>
>>>>>> If the page corresponded with guest memory, KVM will unmap this page
>>>>>> from its stage2 page tables. The user space process that allocated
>>>>>> this memory may have never touched this page in which case it may not
>>>>>> be mapped meaning SIGBUS won't be delivered.
>>>>>>
>>>>>> When this happens KVM discovers pfn == KVM_PFN_ERR_HWPOISON when it
>>>>>> comes to process the stage2 fault.
>>>>>>
>>>>>> Do as x86 does, and deliver the SIGBUS when we discover
>>>>>> KVM_PFN_ERR_HWPOISON. Use the stage2 mapping size as the si_addr_lsb
>>>>>> as this matches the user space mapping size.
>>>
>>>>>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>>>>>> index 962616fd4ddd..9d1aa294e88f 100644
>>>>>> --- a/arch/arm/kvm/mmu.c
>>>>>> +++ b/arch/arm/kvm/mmu.c
>>>>>> @@ -20,8 +20,10 @@
>>>>>>  #include <linux/kvm_host.h>
>>>>>>  #include <linux/io.h>
>>>>>>  #include <linux/hugetlb.h>
>>>>>> +#include <linux/sched/signal.h>
>>>>>>  #include <trace/events/kvm.h>
>>>>>>  #include <asm/pgalloc.h>
>>>>>> +#include <asm/siginfo.h>
>>>>>>  #include <asm/cacheflush.h>
>>>>>>  #include <asm/kvm_arm.h>
>>>>>>  #include <asm/kvm_mmu.h>
>>>>>> @@ -1237,6 +1239,23 @@ static void coherent_cache_guest_page(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
>>>>>>  	__coherent_cache_guest_page(vcpu, pfn, size);
>>>>>>  }
>>>>>>  
>>>>>> +static void kvm_send_hwpoison_signal(unsigned long address, bool hugetlb)
>>>>>> +{
>>>>>> +	siginfo_t info;
>>>>>> +
>>>>>> +	info.si_signo   = SIGBUS;
>>>>>> +	info.si_errno   = 0;
>>>>>> +	info.si_code    = BUS_MCEERR_AR;
>>>>>> +	info.si_addr    = (void __user *)address;
>>>>>> +
>>>>>> +	if (hugetlb)
>>>>>> +		info.si_addr_lsb = PMD_SHIFT;
>>>>>> +	else
>>>>>> +		info.si_addr_lsb = PAGE_SHIFT;
>>>>>> +
>>>>>> +	send_sig_info(SIGBUS, &info, current);
>>>>>> +}
>>>>>> +
>>>>>>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>>>>  			  struct kvm_memory_slot *memslot, unsigned long hva,
>>>>>>  			  unsigned long fault_status)
>>>>>> @@ -1306,6 +1325,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>>>>  	smp_rmb();
>>>>>>  
>>>>>>  	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
>>>>>> +	if (pfn == KVM_PFN_ERR_HWPOISON) {
>>>>>> +		kvm_send_hwpoison_signal(hva, hugetlb);
>>>>>
>>>>> The way this is called means that we'll only notify userspace of a huge
>>>>> mapping if userspace is mapping hugetlbfs, and not because the stage2
>>>>> mapping may or may not have used transparent huge pages when the error
>>>>> was discovered.  Is this the desired semantics?
>>>
>>> No,
>>>
>>>
>>>> I think so.
>>>>
>>>> AFAIUI, transparent hugepages are split before being poisoned while all
>>>> the underlying pages of a hugepage are poisoned together, i.e., no
>>>> splitting.
>>>
>>> In which case I need to look into this some more!
>>>
>>> My thinking was we should report the size that was knocked out of the stage2 to
>>> avoid the guest repeatedly faulting until it has touched every guest-page-size
>>> in the stage2 hole.
>>
>> By signaling something at the fault path, I think it's going to be very
>> hard to backtrack how the stage 2 page tables looked like when faults
>> started happening, because I think these are completely decoupled events
>> (the mmu notifier and the later fault).
>>
>>>
>>> Reading the code in that kvm/mmu.c it looked like the mapping sizes would always
>>> be the same as those used by userspace.
>>
>> I think the mapping sizes should be the same between userspace and KVM,
>> but the mapping size of a particular page (and associated pages) may
>> vary over time.
> 
> Stage 1 and Stage 2 support different hugepage sizes. A larger size
> stage 1 page maps to multiple stage 2 page table entries. For stage 1,
> we support PUD_SIZE, CONT_PMD_SIZE, PMD_SIZE and CONT_PTE_SIZE while
> only PMD_SIZE is supported for Stage 2.

What is stage-1 doing here? We have no idea about what stage-1 is doing
(not under KVM's control). Or do you mean userspace instead?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: Signal SIGBUS when stage2 discovers
 hwpoison memory
Date: Wed, 21 Jun 2017 10:53:09 +0100
Message-ID: <594A4205.70201@arm.com>
References: <20170524163250.29281-1-james.morse@arm.com>
 <3dbafd74-57f2-e724-ace2-0f84abb57e59@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FD0840969
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jun 2017 05:49:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S5Ia3rAPF96D for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jun 2017 05:49:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A382C40296
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jun 2017 05:49:28 -0400 (EDT)
In-Reply-To: <3dbafd74-57f2-e724-ace2-0f84abb57e59@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: wuquanming <wuquanming@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>, Achin Gupta <Achin.Gupta@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Huangshaoyu <huangshaoyu@huawei.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

(+CC: Achin)

On 21/06/17 08:42, gengdongjiu wrote:
> On 2017/5/25 0:32, James Morse wrote:
>> +static void kvm_send_hwpoison_signal(unsigned long address,
>> +				     struct vm_area_struct *vma)
>> +{
>> +	siginfo_t info;
>> +
>> +	info.si_signo   = SIGBUS;
>> +	info.si_errno   = 0;
>> +	info.si_code    = BUS_MCEERR_AR;
>> +	info.si_addr    = (void __user *)address;
>> +
>> +	if (is_vm_hugetlb_page(vma))
>> +		info.si_addr_lsb = huge_page_shift(hstate_vma(vma));
>> +	else
>> +		info.si_addr_lsb = PAGE_SHIFT;
>> +
>> +	send_sig_info(SIGBUS, &info, current);
>> +}
>> +
>>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  			  struct kvm_memory_slot *memslot, unsigned long hva,
>>  			  unsigned long fault_status)
>> @@ -1318,6 +1337,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	smp_rmb();
>>  
>>  	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
>> +	if (pfn == KVM_PFN_ERR_HWPOISON) {
>> +		kvm_send_hwpoison_signal(hva, vma);
>> +		return 0;
>> +	}

> I heard from our CPU hardware team, when happen HWpoison, CPU hardware does not record the IPA address in the HPFAR_EL2.

I think we discussed this before[0], your CPU has a feature called 'hwpoison'
that is uses to support RAS. Linux also has a feature called 'hwpoison' [1][2],
which handles the offline-ing of memory pages when it receives a notification
through APEI. I've tried to call this memory_failure() to avoid this confusion.

This patch is to handle stage2 faults when the page was removed from the stage2
mapping by the memory_failure() code. v3 of this patch[3] does a much better job
of describing this.

(... I don't think your question is related to this patch ...)


> Only when the SEA error is related to the page table walk, the HPFAR_EL2 register is updated.
> here we got the pfn/gfn from the register HPFAR_EL2, if CPU does not update the HPFAR_EL2 register,
> we may can not use this method to get the pfn/gfn.

This patch is only concerned with ordinary stage2 faults. Linux doesn't want to
give the page to the guest as it has been marked with the PG_HWpoison flag.
Instead we trigger memory_failure()'s 'late' notification.

To the CPU this will look like a normal stage2 fault.


> could you confirm arm's armv8.0/armv8.2 standard CPU also use such design?
> if so, we may need to use other method to get the gfn/pfn/hva address.

Your question is what happens when a guest accesses a location your CPU has
marked with its 'hwpoison'. From the RAS spec[4] I would expect this to be
reported as a Synchronous External Abort. For firmware-first error handling this
should be taken to EL3.

>From here firmware should generate CPER records and then notify the OS via one
of the APEI mechanisms. Because a guest was running this notification must reach
EL2. KVM can then switch back to the host and invoke the APEI GHES handler,
which for this kind of error will probably call memory_failure().

What happens if HPFAR_EL2 isn't set when this kind of error occurs?
Provided EL3 can learn the physical address that triggered the exception then
for firmware-first this isn't a problem. These errors should be taken to EL3 and
then described by CPER records to the OS. The OS should process the CPER records
in preference to attempting 'kernel first error handling'.

memory_failure() will unmap the affected pages from user space (and KVMs stage2)
and deliver signals (if Qemu/kvmtool registered for them via prctl()). KVM won't
re-enter the guest if there is a signal pending, from here Qemu/kvmtool get the
affected VA which they can use to notify the guest.


I hope this helps,

James

[0] https://lkml.org/lkml/2017/5/12/492
[1] https://lwn.net/Articles/348886/
[2]
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/vm/hwpoison.txt
[3] https://www.spinics.net/lists/arm-kernel/msg589515.html
[4]
https://static.docs.arm.com/ddi0587/a/RAS%20Extension-release%20candidate_march_29.pdf

From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: ARM: updtae the VMID generation logic
Date: Wed, 4 Apr 2018 09:43:51 +0100
Message-ID: <b4a708ea-96d4-d3ff-74b2-ae7ba668bcb9@arm.com>
References: <1522335624-24332-1-git-send-email-zhaoshenglong@huawei.com>
 <20180329152758.za6ppojjiw6ea52u@lakrids.cambridge.arm.com>
 <20180403164947.n3h5vgtrtd2d3tok@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D20F4028A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Apr 2018 04:35:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dDVlhvI9mrQX for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Apr 2018 04:35:25 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90E0540192
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Apr 2018 04:35:25 -0400 (EDT)
In-Reply-To: <20180403164947.n3h5vgtrtd2d3tok@lakrids.cambridge.arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>, Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mark,

On 03/04/18 17:49, Mark Rutland wrote:
> On Thu, Mar 29, 2018 at 04:27:58PM +0100, Mark Rutland wrote:
>> On Thu, Mar 29, 2018 at 11:00:24PM +0800, Shannon Zhao wrote:
>>> From: zhaoshenglong <zhaoshenglong@huawei.com>
>>>
>>> Currently the VMID for some VM is allocated during VCPU entry/exit
>>> context and will be updated when kvm_next_vmid inversion. So this will
>>> cause the existing VMs exiting from guest and flush the tlb and icache.
>>>
>>> Also, while a platform with 8 bit VMID supports 255 VMs, it can create
>>> more than 255 VMs and if we create e.g. 256 VMs, some VMs will occur
>>> page fault since at some moment two VMs have same VMID.
>>
>> Have you seen this happen?
>>
>> I beleive that update_vttbr() should prevent this. We intialize
>> kvm_vmid_gen to 1, and when we init a VM, we set its vmid_gen to 0. So
>> the first time a VM is scheduled, update_vttbr() will allocate a VMID,
>> and by construction we shouldn't be able to allocate the same VMID to
>> multiple active VMs, regardless of whether we overflow several times.
> 
> Having delved a bit deeper, I think there is a case where a vcpu could
> end up using a stale VMID.
> 
> Say we have two physical CPUs, and we're running a VM with two VCPUs. 
> 
> We start one vCPU, and in update_vttbr() we find the VM's vmid_gen is
> stale. So we:
> 
> 1) Take the vmid lock
> 2) Increment kvm_vmid_gen
> 3) force_vm_exit(cpu_all_mask)
> 4) kvm_call_hyp(__kvm_flush_vm_context)
> 5) Update kvm->arch.vmid_gen
> 6) Update kvm->arch.vmid
> 7) Update kvm->arch.vttbr
> 
> ... but between steps 5 and 6/7, another CPU can enter update_vttbr(), see that
> kvm->arch.vmid_gen == kvm_vmid_gen, and carry on into hyp. In hyp, it reads the
> stale kvm->arch.vmid or kvm->arch.vttbr, and programs a stale VMID into the
> hardware.

Yes, I can see that now, thanks for pointing it out.

I can think of two ways to deal with it without rewriting the whole thing:

1) we drop the vmid_gen check outside of the lock, ensuring that only
one CPU checks the generation at a time.

2) we turn the IPI into a stop_machine and only release the other CPUs
when everything has been updated.

(1) is trivial to implement, but creates quite a bottleneck. (2) is more
invasive, but only triggers on roll-over (which will make Shannon's case
even worse in terms of performance).

> 
> There's a very small window for that to happen, but we might be able to
> exacerbate it with something like the below (untested) hack.
> 
> This is a classing TOCTTOU bug, and the best way I'm aware of to sovle this is
> something like the arm64 ASID allocator, where we reserve the active ASID on
> each CPU.
That's definitely the way to go in the longer term, if only to only have
one single way of dealing with address spaces. It also has other
benefits in terms of TLB invalidation.

I doubt we can directly reuse the code though (we need to share it with
32bit as well), but I'll give it a go at it once we have a fix for this
bug (assuming that's the only one).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

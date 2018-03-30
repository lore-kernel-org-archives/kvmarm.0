From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH] KVM: ARM: updtae the VMID generation logic
Date: Fri, 30 Mar 2018 09:56:10 +0800
Message-ID: <5ABD993A.8030100@huawei.com>
References: <1522335624-24332-1-git-send-email-zhaoshenglong@huawei.com>	<20180329152758.za6ppojjiw6ea52u@lakrids.cambridge.arm.com>
 <861sg2su98.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBDFE402C7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Mar 2018 21:50:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tb8MdcUJfDRS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Mar 2018 21:49:42 -0400 (EDT)
Received: from huawei.com (unknown [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 67821401AB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Mar 2018 21:49:42 -0400 (EDT)
In-Reply-To: <861sg2su98.wl-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 2018/3/30 0:48, Marc Zyngier wrote:
> On Thu, 29 Mar 2018 16:27:58 +0100,
> Mark Rutland wrote:
>>
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
Yes, we've started 256 VMs on D05. We saw kernel page fault in some guests.

>> I beleive that update_vttbr() should prevent this. We intialize
>> kvm_vmid_gen to 1, and when we init a VM, we set its vmid_gen to 0. So
>> the first time a VM is scheduled, update_vttbr() will allocate a VMID,
>> and by construction we shouldn't be able to allocate the same VMID to
>> multiple active VMs, regardless of whether we overflow several
>> times.
> 
> I remember testing that exact scenario when we implemented the VMID
> rollover a (long) while back. Maybe we've introduced a regression, but
> we're supposed to support 255 VMs running at the same time (which is
> not the same as having 255 VMs in total).
> 
> Shannon: if you have observed such regression, please let us know.
> 
Current approach could allow more than 255 VMs running at the same time.
It doesn't prevent the extra VMs creating. So at some moment, this will
be a race that two VMs have same VMID when there are more than 255 VMs.
>>
>>> This patch uses the bitmap to record which VMID used and available.
>>> Initialize the VMID and vttbr during creating the VM instead of VCPU
>>> entry/exit context. Also it will return error to user space if it wants
>>> to create VMs more than the supporting number.
>>
>> This creates a functional regression for anyone creating a large number
>> of VMs.
> 
> Indeed, and I'm not buys that approach at all. As I said above, the
> intent is that we can have up to 2^VMID_SIZE-1 VMs running at the same
> time, and *any* number of VMs in the system.
> 
I think it should not allow more than 255 VMs to create since if there
are 256 VMs, the VMs will not running properly and will fall in the loop
to update VMID.

>> If VMID overflow is a real bottleneck, it would be vastly better to
>> improve the VMID allocator along the lines of the arm64 ASID allocator,
>> so that upon overflow we reserve the set of active VMIDs (and therefore
>> avoid expensive TLB + icache maintenance). That does not require a
>> global limit on the number of VMs.
> 
> +1.
> 
I'll look at the ASID allocator approach.

Thanks,
-- 
Shannon

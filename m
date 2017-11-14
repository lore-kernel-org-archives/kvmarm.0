From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v4 00/21] SError rework + RAS&IESB for firmware first
 support
Date: Tue, 14 Nov 2017 16:03:01 +0000
Message-ID: <5A0B13B5.3000205@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <5A049B20.6000501@arm.com> <20171113112946.GK14144@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBB2149D6D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Nov 2017 11:02:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xku8zRxxSox4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Nov 2017 11:02:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 306DD49D52
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Nov 2017 11:02:41 -0500 (EST)
In-Reply-To: <20171113112946.GK14144@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, linux-arm-kernel@lists.infradead.org, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 13/11/17 11:29, Christoffer Dall wrote:
> On Thu, Nov 09, 2017 at 06:14:56PM +0000, James Morse wrote:
>> On 19/10/17 15:57, James Morse wrote:
>>> Known issues:
>> [...]
>>>  * KVM-Migration: VDISR_EL2 is exposed to userspace as DISR_EL1, but how should
>>>    HCR_EL2.VSE or VSESR_EL2 be migrated when the guest has an SError pending but
>>>    hasn't taken it yet...?
>>
>> I've been trying to work out how this pending-SError-migration could work.
>>
>> If HCR_EL2.VSE is set then the guest will take a virtual SError when it next
>> unmasks SError. Today this doesn't get migrated, but only KVM sets this bit as
>> an attempt to kill the guest.
>>
>> This will be more of a problem with GengDongjiu's SError CAP for triggering
>> guest SError from user-space, which will also allow the VSESR_EL2 to be
>> specified. (this register becomes the guest ESR_EL1 when the virtual SError is
>> taken and is used to emulate firmware-first's NOTIFY_SEI and eventually
>> kernel-first RAS). These errors are likely to be handled by the guest.
>>
>>
>> We don't want to expose VSESR_EL2 to user-space, and for migration it isn't
>> enough as a value of '0' doesn't tell us if HCR_EL2.VSE is set.
>>
>> To get out of this corner: why not declare pending-SError-migration an invalid
>> thing to do?

> To answer that question we'd have to know if that is generally a valid
> thing to require.  How will higher level tools in the stack deal with
> this (e.g. libvirt, and OpenStack).  Is it really valid to tell them
> "nope, can't migrate right now".  I'm thinking if you have a failing
> host and want to signal some error to the guest, that's probably a
> really good time to migrate your mission-critical VM away to a different
> host, and being told, "sorry, cannot do this" would be painful.  I'm
> cc'ing Drew for his insight into libvirt and how this is done on x86,

Thanks,


> but I'm not really crazy about this idea.

Excellent, so at the other extreme we could have an API to query all of this
state, and another to set it. On systems without the RAS extensions this just
moves the HCR_EL2.VSE bit. On systems with the RAS extensions it moves VSESR_EL2
too.

I was hoping to avoid exposing different information. I need to look into how
that works. (and this is all while avoiding adding an EL2 register to
vcpu_sysreg [0])


>> We can give Qemu a way to query if a virtual SError is (still) pending. Qemu
>> would need to check this on each vcpu after migration, just before it throws the
>> switch and the guest runs on the new host. This way the VSESR_EL2 value doesn't
>> need migrating at all.
>>
>> In the ideal world, Qemu could re-inject the last SError it triggered if there
>> is still one pending when it migrates... but because KVM injects errors too, it
>> would need to block migration until this flag is cleared.

> I don't understand your conclusion here.

I was trying to reduce it to exposing just HCR_EL2.VSE as 'bool
serror_still_pending()', then let Qemu re-inject whatever SError it injected
last. This then behaves the same regardless of the RAS support.
But KVM's kvm_inject_vabt() breaks this, Qemu can't know whether this pending
SError was from Qemu, or from KVM.

... So we need VSESR_EL2 on systems which have that register ...

(or, get rid of kvm_inject_vabt(), but that would involve a new exit type, and
some trickery for existing user-space)

> If QEMU can query the virtual SError pending state, it can also inject
> that before running the VM after a restore, and we should have preserved
> the same state.

[..]

>> Can anyone suggest a better way?

> I'm thinking this is analogous to migrating a VM that uses an irqchip in
> userspace and has set the IRQ or FIQ lines using KVM_IRQ_LINE.  My
> feeling is that this is also not supported today.

Does KVM change/update these values behind Qemu's back? It's kvm_inject_vabt()
that is making this tricky. (or at least confusing me)


> My suggestion would be to add some set of VCPU exception state,
> potentially as flags, which can be migrated along with the VM, or at
> least used by userspace to query the state of the VM, if there exists a
> reliable mechanism to restore the state again without any side effects.
> 
> I think we have to comb through Documentation/virtual/kvm/api.txt to see
> if we can reuse anything, and if not, add something.  We could also
> consider adding something to Documentation/virtual/kvm/devices/vcpu.txt,
> where I think we have a large number space to use from.
> 
> Hope this helps?

Yes, I'll go looking for a way to expose VSESR_EL2 to user-space.


Thanks!

James


[0] https://patchwork.kernel.org/patch/9886019/

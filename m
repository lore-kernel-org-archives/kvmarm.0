From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 00/21] SError rework + RAS&IESB for firmware first
 support
Date: Mon, 13 Nov 2017 17:14:45 +0100
Message-ID: <20171113161445.xfqyuntza76ckdmq@hawk.localdomain>
References: <20171019145807.23251-1-james.morse@arm.com>
 <5A049B20.6000501@arm.com> <20171113112946.GK14144@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C39D49D61
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 11:12:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v65E8m2ybwpU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Nov 2017 11:12:42 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F3FA849D58
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 11:12:41 -0500 (EST)
Content-Disposition: inline
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
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 13, 2017 at 12:29:46PM +0100, Christoffer Dall wrote:
> On Thu, Nov 09, 2017 at 06:14:56PM +0000, James Morse wrote:
> > Hi guys,
> > 
> > On 19/10/17 15:57, James Morse wrote:
> > > Known issues:
> > [...]
> > >  * KVM-Migration: VDISR_EL2 is exposed to userspace as DISR_EL1, but how should
> > >    HCR_EL2.VSE or VSESR_EL2 be migrated when the guest has an SError pending but
> > >    hasn't taken it yet...?
> > 
> > I've been trying to work out how this pending-SError-migration could work.
> > 
> > If HCR_EL2.VSE is set then the guest will take a virtual SError when it next
> > unmasks SError. Today this doesn't get migrated, but only KVM sets this bit as
> > an attempt to kill the guest.
> > 
> > This will be more of a problem with GengDongjiu's SError CAP for triggering
> > guest SError from user-space, which will also allow the VSESR_EL2 to be
> > specified. (this register becomes the guest ESR_EL1 when the virtual SError is
> > taken and is used to emulate firmware-first's NOTIFY_SEI and eventually
> > kernel-first RAS). These errors are likely to be handled by the guest.
> > 
> > 
> > We don't want to expose VSESR_EL2 to user-space, and for migration it isn't
> > enough as a value of '0' doesn't tell us if HCR_EL2.VSE is set.
> > 
> > To get out of this corner: why not declare pending-SError-migration an invalid
> > thing to do?
> 
> To answer that question we'd have to know if that is generally a valid
> thing to require.  How will higher level tools in the stack deal with
> this (e.g. libvirt, and OpenStack).  Is it really valid to tell them
> "nope, can't migrate right now".  I'm thinking if you have a failing
> host and want to signal some error to the guest, that's probably a
> really good time to migrate your mission-critical VM away to a different
> host, and being told, "sorry, cannot do this" would be painful.  I'm
> cc'ing Drew for his insight into libvirt and how this is done on x86,
> but I'm not really crazy about this idea.

Without actually confirming, I'm pretty sure it's handled with a best
effort to cancel the migration, continuing/restoring execution on the
source host (or there may be other policies that could be set as well).
Naturally, if the source host is going down and the migration is
cancelled, then the VM goes down too...

Anyway, I don't think we would generally want to introduce guest
controlled migration blockers. IIUC, this migration blocker would remain
until the guest handled the SError, which it may never unmask.

> 
> > 
> > We can give Qemu a way to query if a virtual SError is (still) pending. Qemu
> > would need to check this on each vcpu after migration, just before it throws the
> > switch and the guest runs on the new host. This way the VSESR_EL2 value doesn't
> > need migrating at all.
> > 
> > In the ideal world, Qemu could re-inject the last SError it triggered if there
> > is still one pending when it migrates... but because KVM injects errors too, it
> > would need to block migration until this flag is cleared.
> 
> I don't understand your conclusion here.
> 
> If QEMU can query the virtual SError pending state, it can also inject
> that before running the VM after a restore, and we should have preserved
> the same state.
> 
> > KVM can promise this doesn't change unless you run the vcpu, so provided the
> > vcpu actually takes the SError at some point this thing can still be migrated.
> > 
> > This does make the VSE machinery hidden unmigratable state in KVM, which is nasty.
> 
> Yes, nasty.
> 
> > 
> > Can anyone suggest a better way?
> > 
> 
> I'm thinking this is analogous to migrating a VM that uses an irqchip in
> userspace and has set the IRQ or FIQ lines using KVM_IRQ_LINE.  My
> feeling is that this is also not supported today.

Luckily userspace irqchip is mostly a debug feature, or just to support
oddball hardware. Or at least that's the way I see its usecases...

> 
> My suggestion would be to add some set of VCPU exception state,
> potentially as flags, which can be migrated along with the VM, or at
> least used by userspace to query the state of the VM, if there exists a
> reliable mechanism to restore the state again without any side effects.
> 
> I think we have to comb through Documentation/virtual/kvm/api.txt to see
> if we can reuse anything, and if not, add something.  We could also

Maybe KVM_GET/SET_VCPU_EVENTS? Looks like the doc mistakenly states it's
a VM ioctl, but it's a VCPU ioctl.

> consider adding something to Documentation/virtual/kvm/devices/vcpu.txt,
> where I think we have a large number space to use from.
> 
> Hope this helps?
> 
> -Christoffer

Thanks,
drew

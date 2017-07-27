From: Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 11/11] KVM: arm64: Delegate support for SDEI to userspace
Date: Thu, 27 Jul 2017 00:49:30 -0700
Message-ID: <20170727074930.GB1432@lvm>
References: <20170515174400.29735-1-james.morse@arm.com>
 <20170515174400.29735-12-james.morse@arm.com>
 <20170606195835.GL9464@cbox>
 <5978CA93.5090600@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5978CA93.5090600-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: Christoffer Dall <cdall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On Wed, Jul 26, 2017 at 06:00:03PM +0100, James Morse wrote:
> Hi Christoffer,
> 
> (looks like I forgot to send this ...)
> 
> On 06/06/17 20:58, Christoffer Dall wrote:
> > On Mon, May 15, 2017 at 06:43:59PM +0100, James Morse wrote:
> >> The Software Delegated Exception Interface allows firmware to notify
> >> the OS of system events by returning into registered handlers, even
> >> if the OS has interrupts masked.
> >>
> >> While we could support this in KVM, we would need to expose an API for
> >> the user space hypervisor to inject events, (and decide what to do it
> > 
> > 'the user space hypervisor' ?
> 
> Qemu or kvmtool. I never know what generic term to use for these.
> virtual-machine-monitor?
> 

Ah, I also struggle with that aspect.  Here I was confused if you meant
QEMU TCG or something like that, and didn't quite understand the
connection.

I usually get away with saying simply user space, or the user space
driver (because user space drives KVM VMs), but I'm not aware of a fixed
unambiguous term.

VMM is probably not a good choice as most virt people think of
hypervisor==VMM.

> 
> > s/it/if/
> > 
> >> the event isn't registered or all the CPUs have SDE events masked). We
> >> already have an API for guest 'hypercalls', so use this to push the
> >> problem onto userspace.
> >>
> >> Advertise a new capability 'KVM_CAP_ARM_SDEI_1_0' and when any SDEI
> >> call comes in, exit to userspace with exit_reason = KVM_EXIT_HYPERCALL.
> 
> > Documentation/virtual/kvm/api.txt says this is unused.
> > 
> > We should add something there to say that this is now used for arm64,
> > and the api doc also suggests that the hypercall struct in kvm_run has
> > some meaningful data for this exit.
> 
> Yes, good point.
> 
> I was expecting this patch to provoke some wider discussion on how to delegate
> SMCCC/HVC calls to user space. Do we want per-API KVM_CAP's, or one that dumps
> the whole range on user-space when enabled. It came up (as a tangent) on another
> thread:
> 
> Marc Zyngier wrote[0]:
> > Eventually, we want to be able to handle the full spectrum of the SMCCC
> > and forward things to an actual TEE if available. There is no real
> > reason why PSCI shouldn't be handled in userspace the same way (and we
> > already offload reset and halt to QEMU).
> 

If implementing PSCI in userspace is not a big deal, then I lean towards
having a CAP and a feature, which simply moves all SMC/HVC calls to QEMU
and lets QEMU handle things.  On the other hand, if we ever want to
support known hypercalls that KVM must service directly, then we'd have
to split things up into different APIs for different types of calls.

If you need something short-term, I suspect only forwarding a limited
set of APIs to user space is the safest way to go, and we can always
include that with PSCI if moving everything to user space.


> 
> > Have we checked that the guest can't provoke QEMU to do something weird
> > by causing this exit on arm64 currently (given that we always enable
> > this handling of SDEI calls)?
> 
> Qemu 2.2.0 in ubuntu 15.04 ignores the 'sdei_version' hvc/hypercall-exit and
> re-enters the guest with the registers unmodified. I think this is 'weird', I
> assumed it would exit.
> 

IIRC, the arch-specific part of the QEMU run loop that calls into KVM,
specifically checks for the things it cares about on exit, and if it
doesn't see anything alarming, it just carries on.

It's a bit borderline to depend on this behavior, given that other
people could have modified QEMU versions or other user space drivers for
KVM deployed, but from a practical point of view, we'll probably be
ok...

> 
> >> N.B. There is no enable/feature bit for SDEI exits as telling the guest
> >> the interface exists via DT/ACPI should be sufficient.
> 
> I'm probably being too trusting here. Today an unknown HVC will cause KVM to
> inject an undef, whereas with this change it might get handled by user-space if
> the kernel recognises the range, and user-space might just skip the HVC and
> carry on...
> 
> I will change this to support KVM_CAP_ENABLE_CAP_VM to enable the SDEI CAP and
> pass that HVC range through to user-space using KVM_EXIT_HYPERCALL and
> populating as much of that structure as makes sense...
> 

I think the key is that the feature is only allowed if user space tells
KVM to notify it, because then we can assume user space also knows how
to deal with the exit code, so sounds good.

> 
> >> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> >> index 3a776ec99181..0bf2d923483c 100644
> >> --- a/virt/kvm/arm/arm.c
> >> +++ b/virt/kvm/arm/arm.c
> >> @@ -206,8 +206,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >>  	case KVM_CAP_READONLY_MEM:
> >>  	case KVM_CAP_MP_STATE:
> >>  	case KVM_CAP_IMMEDIATE_EXIT:
> >> -		r = 1;
> >> -		break;
> >> +#ifdef CONFIG_ARM_SDE_INTERFACE
> >> +	case KVM_CAP_ARM_SDEI_1_0:
> >> +#endif
> > 
> > What's the point of conditionally supporting this based on the config
> > option when the rest of the KVM functionality does not depend on the
> > CONFIG_ARM_SDE_INTERFACE functionality?
> 
> You're right it doesn't depend on anything in KVM, but adding it unconditionally
> here will enable it on 32bit too, and the spec says this is aarch64 only. So
> #ifdef ARM64 would have been better.

Ah, I missed that.  Makes sense.

> 
> 
> > Could a user want to play with SDEI calls in a VM without the host
> > having the proper support, or is that never relevant?
> 
> That works fine (its how it was developed!).
> 
> 'Virtual machine monitors' should be able to pick a RAS notification method for
> guests independently of what the host is using (if anything). If this doesn't
> work it means we've accidentally created some ABI.
> 

Right, my point was if we wanted to support this in KVM even if the host
kernel didn't have CONFIG_ARM_SDE_INTERFACE, but it looks like we've
already addressed this.

Thanks,
-Christoffer
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

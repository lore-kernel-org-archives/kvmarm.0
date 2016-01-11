From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v8 20/20] KVM: ARM64: Add a new kvm ARM PMU device
Date: Mon, 11 Jan 2016 17:09:27 +0100
Message-ID: <20160111160927.GF3924@hawk.localdomain>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
 <1450771695-11948-21-git-send-email-zhaoshenglong@huawei.com>
 <CAFEAcA_MDiOphseZ7RGNE3G=4ZDF5SFV5krOjanPbVuhgg9gnQ@mail.gmail.com>
 <568E7AF1.9040103@huawei.com>
 <CAFEAcA-Qcda7TSFLSeykLHqZYdP6tYdEjPe2uHN6f_+omqWFZg@mail.gmail.com>
 <20160107203647.GJ6199@hawk.localdomain>
 <20160109122956.GA30867@cbox>
 <20160109150339.10576e81@arm.com>
 <20160111140717.GD3924@hawk.localdomain>
 <20160111150929.GB15554@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160111150929.GB15554@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Shannon Zhao <zhaoshenglong@huawei.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 11, 2016 at 04:09:29PM +0100, Christoffer Dall wrote:
> On Mon, Jan 11, 2016 at 03:07:17PM +0100, Andrew Jones wrote:
> > On Sat, Jan 09, 2016 at 03:03:39PM +0000, Marc Zyngier wrote:
> > > On Sat, 9 Jan 2016 13:29:56 +0100
> > > Christoffer Dall <christoffer.dall@linaro.org> wrote:
> > > 
> > > > On Thu, Jan 07, 2016 at 09:36:47PM +0100, Andrew Jones wrote:
> > > > > On Thu, Jan 07, 2016 at 02:56:15PM +0000, Peter Maydell wrote:
> > > > > > On 7 January 2016 at 14:49, Shannon Zhao <zhaoshenglong@huawei.com> wrote:
> > > > > > >>> +
> > > > > > >>> +Groups:
> > > > > > >>> +  KVM_DEV_ARM_PMU_GRP_IRQ
> > > > > > >>> +  Attributes:
> > > > > > >>> +    The attr field of kvm_device_attr encodes one value:
> > > > > > >>> +    bits:     | 63 .... 32 | 31 ....  0 |
> > > > > > >>> +    values:   |  reserved  | vcpu_index |
> > > > > > >>> +    A value describing the PMU overflow interrupt number for the specified
> > > > > > >>> +    vcpu_index vcpu. This interrupt could be a PPI or SPI, but for one VM the
> > > > > > >>> +    interrupt type must be same for each vcpu. As a PPI, the interrupt number is
> > > > > > >>> +    same for all vcpus, while as a SPI it must be different for each vcpu.
> > > > > > >>
> > > > > > >> I see we're using vcpu_index rather than MPIDR affinity value
> > > > > > >> for specifying which CPU we're configuring. Is this in line with
> > > > > > >> our planned API for GICv3 configuration?
> > > > > > >>
> > > > > > > Here vcpu_index is used to indexing the vCPU, no special use.
> > > > > > 
> > > > > > Yes, but you can identify the CPU by index, or by its MPIDR.
> > > > > > We had a discussion about which was the best way for doing
> > > > > > the VGIC API, and I can't remember which way round we ended up
> > > > > > going for. Whichever we chose, we should do the same thing here.
> > > > > 
> > > > > I think we should start up a new discussion on this. My understanding,
> > > > > after a chat with Igor, who was involved in the untangling of vcpu-id and
> > > > > apic-id for x86, is that using vcpu-id is preferred, unless of course
> > > > > the device expects an apic-id/mpidr, in which case there's no reason to
> > > > > translate it on both sides.
> > > > > 
> > > > 
> > > > I'm fairly strongly convinced that we should use the full 32-bit
> > > > compressed MPIDR for everything ARM related going forward, as this will
> > > > cover any case required and leverages and architecturally defined way of
> > > > uniquely identifying a (v)CPU.
> > > 
> > > +1.
> > > 
> > > vcpu_ids, indexes or any other constructs are just a bunch
> > > of KVM-specific definitions that do not describe the VM from an
> > > architecture PoV. In contrast, the MPIDR is guaranteed to be unique
> > > stable, and identifies a given (v)CPU.
> > >
> > 
> > cpu-cpu and cpu-device interfaces should certainly use MPIDR, if they do
> > in real hardware, to allow us to match emulation code to specs and keep
> > sanity. But I assume those are the only places of "everything" you guys
> > are referring to, as everywhere else we should stick to using the concept
> > of vcpu-ids/indices. Since vcpu-indices are just counters they keep us
> > from needing all the data structures to be large, complex, sparse things.
> > Identifiers separate from MPIDR also allow hotunplug/plug to more easily
> > reuse resources, i.e. remap indices to other vcpus as necessary.
> 
> Are vcpu ids already exposed to userspace (beyond the stupid
> KVM_IRQ_LINE) ioctl and as such we're bound to whatever upper limit and
> format they have?

The only other place I found is KVM_CREATE_VCPU. I suppose we could move
to MPIDR for that, and it would be a nice way to handle the "userspace
determines MPIDR" work that I plan to do. Both KVM and its userspaces
would still use some counter-based vcpu identifiers internally, to avoid
large, sparse structures, but I guess the advantage is that they don't
have to agree on how they do that. The 'vcpu id' used by KVM_CREATE_VCPU
is already 32-bits, and is supposed to be an arbitrary identifier. That
all looks good for converting to MPIDR.

> 
> If not, I think decoupling an internal ID and uniquely identifying a CPU
> is a good idea.
> 
> > 
> > In the PMU case above it seems better to use a vcpu-index. KVM and KVM's
> > userspace both have unique vcpu-indices and unique MPIDRs per vcpu. The
> > use here isn't based on a hardware spec, so there's nowhere to look for
> > how MPIDR should/shouldn't be used. This is just a KVM spec. Here we might
> > as well use the easiest to use unique identifier.
> 
> I think the only things that should matter here are (in no particular
> order):
>  - Userspace convenience
>  - Clarity
>  - Avoiding ambiguity

Agreed. I believe the counter-based vcpu-id brings the most convenience
for any non-MPIDR based APIs, i.e. no spec saying MPIDR should be used.
However, picking which counter-based vcpu-id (if more than one exist)
costs both convenience and clarity. I guess that's another argument for
switching to MPIDR...

> 
> > 
> > That said, I like the vcpu ioctl method much better. With that we avoid
> > the need for vcpu identifiers all together. I'm even having third
> > thoughts about the gic per vcpu registers. If we go with extending
> > GET/SET_DEVICE_ATTR here, then I think we should do the same there as
> > well. That would then leave only KVM_IRQ_LINE using a vcpu-index, which,
> > with its 8-bit vcpu-index, we've outgrown for gicv3 machine types already
> > anyway.
> > 
> For the GIC, I think we've discussed this in the past.  It really
> depends whether you think about the GIC as one device (the distributor)
> separate from the CPUs, with a bunch of separate devices attached to
> each CPU and wired together somehow, or if you think of this as one big
> coherent thing where parts of the device are specific to each CPU.

I keep flip-flopping my view, which is why I keep flip-flopping my
opinion on how to deal with its register API :-)

> 
> I tend to interpret the GIC as the latter and I think the kernel and
> userspace implementations are also done that way, suggesting we should
> stick with the device API for all GIC-related state (as was also the
> suggestion for the GICv3 save/restore API).

I think the save/restore case is where I always flip to seeing it as a
bunch of separate per cpu devices. It would feel better to me to
save/restore the cpu-gic registers the same way we do all other cpu
registers.

I think we can get the best of both worlds by extending the
SET/GET_DEVICE_ATTR to vcpus, and then using both the device ioctl
and the vcpu ioctls.

> 
> Similarly, because the GIC architecture refers to CPUs using the MPIDR,
> we should do the same in this interface.  Otherwise, I think you have to
> define stricly how the exposed VCPU ID maps to an MPIDR somehow.

Well, we're creating our own interface to a gic model, so there's
nothing in the spec that says MPIDR is needed here, but if there's
no good reason not to change the KVM_CREATE_VCPU vcpu-id to MPIDR,
then we certainly wouldn't want to invent a new vcpu-id for this use.


My current feelings are:
  1) avoid needing vcpu identifiers (use vcpu ioctl whenever possible)
  2) if we need them, they should match the same one used by
     KVM_CREATE_VCPU (whenever possible)
  3) any device api that doesn't provide a 32-bit identifier field
     should just be special-cased, and have plenty of documentation
     explaining how to handle it - explaining what other limitations
     it puts on the guest, etc.

None of those feelings exclude using MPIDR as _the_ vcpu-id (I don't
think). It appears the main benefit of switching to MPIDR would be to
decouple KVM from its userspaces wrt to choosing the non-MPIDR vcpu
identification used for managing data structures and looping over
vcpus internally. We also gain a clean way for userspace to choose
the MPIDR for each vcpu, which we need to do anyway.

Thanks,
drew

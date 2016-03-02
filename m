From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v7 1/6] KVM: arm/arm64: Add VGICv3 save/restore API
 documentation
Date: Wed, 2 Mar 2016 13:48:25 +0100
Message-ID: <20160302124825.GA4169@cbox>
References: <cover.1449491035.git.p.fedin@samsung.com>
 <204d6b178e611ee0b5aede2b945516e0a6048c3c.1449491035.git.p.fedin@samsung.com>
 <CAFEAcA-VVKawQkup2ymiujvQnint1bEmm65XeSU9TL+LH5XoqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA-VVKawQkup2ymiujvQnint1bEmm65XeSU9TL+LH5XoqQ@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Pavel Fedin <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 26, 2016 at 03:01:56PM +0000, Peter Maydell wrote:
> On 7 December 2015 at 12:29, Pavel Fedin <p.fedin@samsung.com> wrote:
> > From: Christoffer Dall <christoffer.dall@linaro.org>
> >
> > Factor out the GICv3-specific documentation into a separate
> > documentation file.  Add description for how to access distributor,
> > redistributor, and CPU interface registers for GICv3 in this new file.
> >
> > Acked-by: Peter Maydell <peter.maydell@linaro.org>
> > Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> 
> I was rereading this API doc this week, and I realised we missed
> something when we wrote it:
> 
> > +  KVM_DEV_ARM_VGIC_GRP_DIST_REGS
> > +  KVM_DEV_ARM_VGIC_GRP_REDIST_REGS
> > +  Attributes:
> > +    The attr field of kvm_device_attr encodes two values:
> > +    bits:     | 63   ....  32  |  31   ....    0 |
> > +    values:   |      mpidr     |      offset     |
> > +
> > +    All distributor regs are (rw, 64-bit).
> 
> It's a bit odd to claim that distributor (or redistributor)
> registers are all 64-bit, because in the hardware most of them
> are really 32-bit, and at 32-bit offsets from each other.
> We didn't mean to imply that you could do a 64-bit access
> at offset 0 of the distributor and get both of GICD_CTLR and
> GICD_TYPER at once, for instance.

no we didn't, and I think this was just an oversight on my side.

Perhaps what I meant was the userspace should just provide a pointer to
a 64-bit value.

> 
> I'm not quite sure what we want to say in the documentation,
> though I think our general intent was clear:
> 
>  * you access a particular register at its relevant offset,
>    and you only get that register
>  * no support for reading half a register
>  * if the register (as documented in the GICv3 architecture
>    specification) is less than 64 bits wide then the returned
>    result is zero-extended to 64 bits on read, and high bits
>    are ignored on write
>    (Only a couple of registers are really 64-bits, notably
>    GICD_IROUTER<n>. The rest are 32-bits. We could probably explicitly
>    list all the 64-bit regs in this doc if we didn't want to defer
>    to the arch spec.)
> 
> Do we want to forbid accesses to registers which the architecture
> says can be byte-accessed, like GICD_IPRIORITYR<n>? I think we have
> to, because the kernel API we have here doesn't have any way to
> specify access width, and it would be weird for addresses X+1,
> X+2, X+3 to give you 8 bits of data when X+0 gave you 32.

yes, for the gicv2 API we only allow accesses on 32-bit aligned
boundaries and always assume a 32-bit access.

> 
> What do we mean by the "rw" part? Some registers really are
> architecturally RO, so does this mean "writes to architecturally
> RO registers will succeed but be ignored rather than returning an
> errno" ?

I think my intention was that this would work like the invariant
sysregs, where if you write anything else than what the kernel has
defined, then you get an error.  Not sure if this is something we'd want
to do here though.  Seems like the GICv2 implementation just ignores
writes in line with the architecture.

> 
> > +
> > +    KVM_DEV_ARM_VGIC_GRP_DIST_REGS accesses the main distributor registers.
> > +    KVM_DEV_ARM_VGIC_GRP_REDIST_REGS accesses the redistributor of the CPU
> > +    specified by the mpidr.
> > +
> > +    The offset is relative to the "[Re]Distributor base address" as defined
> > +    in the GICv3/4 specs.  Getting or setting such a register has the same
> > +    effect as reading or writing the register on real hardware, and the mpidr
> > +    field is used to specify which redistributor is accessed.  The mpidr is
> > +    ignored for the distributor.
> > +
> > +    The mpidr encoding is based on the affinity information in the
> > +    architecture defined MPIDR, and the field is encoded as follows:
> > +      | 63 .... 56 | 55 .... 48 | 47 .... 40 | 39 .... 32 |
> > +      |    Aff3    |    Aff2    |    Aff1    |    Aff0    |
> > +
> > +    Note that distributor fields are not banked, but return the same value
> > +    regardless of the mpidr used to access the register.
> > +  Limitations:
> > +    - Priorities are not implemented, and registers are RAZ/WI
> > +  Errors:
> > +    -ENXIO: Getting or setting this register is not yet supported
> > +    -EBUSY: One or more VCPUs are running
> > +
> > +
> > +  KVM_DEV_ARM_VGIC_CPU_SYSREGS
> 
> In contrast it's fine for sysregs to be all 64-bit, because they correspond
> to CPU system registers which are architecturally 64-bits.
> 

Right, perhaps this was my confusion.

Thanks,
-Christoffer

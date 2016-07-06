From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RESEND PATCH v4] KVM: arm/arm64: Add VGICv3 save/restore API documentation
Date: Wed, 6 Jul 2016 13:03:18 +0100
Message-ID: <CAFEAcA_OJh+sS-adVP9Z7TDZmPQfsNwfmS1Gxm5EzdVi2FjAwQ@mail.gmail.com>
References: <20160706113725.32437-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160706113725.32437-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 6 July 2016 at 12:37, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> Factor out the GICv3-specific documentation into a separate
> documentation file.  Add description for how to access distributor,
> redistributor, and CPU interface registers for GICv3 in this new file,
> and add a group for accessing level triggered IRQ information for GICv3
> as well.
>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

> +    Accesses (reads and writes) to the GICD_ISPENDR register region and
> +    GICR_ISPENDR0 registers get/set the value of the latched pending state for
> +    the interrupts.
> +
> +    This is identical to the value read from ISPENDR for an edge triggered
> +    interrupt, but may differ for level triggered interrupts. For edge triggered
> +    interrupts, once an interrupt becomes pending (whether because of an edge
> +    detected on the input line or because of a guest write to ISPENDR) this
> +    state is "latched", and only cleared when either the interrupt is activated
> +    or when the guest writes to ICPENDR. A level triggered interrupt may be
> +    pending either because the level input is held high by a device, or because
> +    of a guest write to the ISPENDR register. Only ISPENDR writes are latched;
> +    if the device lowers the line level then the interrupt is no longer pending
> +    unless the guest also wrote to ISPENDR, and conversely writes to ICPENDR or
> +    activations of the interrupt do not clear the pending status if the line
> +    level is still being held high.  (These rules are documented in the GICv3
> +    specification descriptions of the ICPENDR and ISPENDR registers.)
> +    For a level triggered interrupt the value accessed here
> +    is that of the latch which is set by ISPENDR and cleared by ICPENDR or
> +    interrupt activation, whereas the value read from ISPENDR is the logical OR
> +    of the latch value and the input line level.

Rereading these paragraphs I think
 "This is identical to the value returned by a guest read from ISPENDR..."
(in the first line) and
 "the value returned by a guest read from the ISPENDR register is the
logical OR..."
(at the end) would be clearer, just to make sure we're clear between
when we're describing the behaviour of the hardware register as seen
by the guest, and when we're describing the behaviour of a read/write
through this API. I misread the intention the first time around
even though  I wrote this text :-)

> +  KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO
> +  Attributes:
> +    The attr field of kvm_device_attr encodes the following values:
> +    bits:     | 63      ....       32 | 31   ....    10 | 9  ....  0 |
> +    values:   |         mpidr         |      info       |   vINTID   |
> +
> +    The vINTID specifies which set of IRQs is reported on.
> +
> +    The info field specifies which information userspace wants to get or set
> +    using this interface.  Currently we support two different pieces of
> +    information:
> +
> +      VGIC_LEVEL_INFO_LINE_LEVEL:
> +       Get/Set the input level of the IRQ line for a set of 32 contiguously
> +       numbered interrupts.
> +       vINTID must be a multiple of 32.
> +
> +        kvm_device_attr.addr points to a __u32 value which will contain a

stray extra space at start of line?

> +       bitmap where a set bit means the interrupt level is asserted.
> +
> +       Bit[n] indicates the status for interrupt vINTID + n.
> +
> +    SGIs and any interrupt with a higher ID than the number of interrupts
> +    supported, will be RAZ/WI.  LPIs are always edge-triggered and are
> +    therefore not supported by this interface.
> +
> +    PPIs are reported per VCPU as specified in the mpidr field, and SPIs are
> +    reported with the same value regardless of the mpidr specified.
> +
> +    The mpidr field encodes the CPU ID based on the affinity information in the
> +    architecture defined MPIDR, and the field is encoded as follows:
> +      | 63 .... 56 | 55 .... 48 | 47 .... 40 | 39 .... 32 |
> +      |    Aff3    |    Aff2    |    Aff1    |    Aff0   |

Missing space -- ASCII art doesn't quite line up.

Otherwise
Reviewed-by: Peter Maydell <peter.maydell@linaro.org>


thanks
-- PMM

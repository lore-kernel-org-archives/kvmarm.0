From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v3] KVM: arm/arm64: Add VGICv3 save/restore API
 documentation
Date: Fri, 13 May 2016 16:28:44 +0100
Message-ID: <CAFEAcA8fcxo18HhfboE5j=SC8TyrPXqmpsPNymM8zw4PhMTRDw@mail.gmail.com>
References: <1463150637-6896-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2DA049B50
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2016 11:26:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dBXkErdSn9ER for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 May 2016 11:26:00 -0400 (EDT)
Received: from mail-vk0-f50.google.com (mail-vk0-f50.google.com
 [209.85.213.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9BDEF49B3F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2016 11:26:00 -0400 (EDT)
Received: by mail-vk0-f50.google.com with SMTP id o133so141534688vka.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2016 08:29:03 -0700 (PDT)
In-Reply-To: <1463150637-6896-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: arm-mail-list <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 13 May 2016 at 15:43, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> Factor out the GICv3-specific documentation into a separate
> documentation file.  Add description for how to access distributor,
> redistributor, and CPU interface registers for GICv3 in this new file,
> and add a group for accesing level triggered IRQ information for GICv3
> as well.
>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> Changes since v2:
>  - Changed distributor access to be 32-bits in size
>  - Clearly specified data type pointed to by addr field
>  - Specified exception behavior for STATUSR registers
>  - Added group for level-triggered IRQ status info
>  - Removed acks from Marc/Peter as content has changed

Hi; I have one substantial point and a few typos to point out.

>  Documentation/virtual/kvm/devices/arm-vgic-v3.txt | 176 ++++++++++++++++++++++
>  Documentation/virtual/kvm/devices/arm-vgic.txt    |  21 +--
>  2 files changed, 180 insertions(+), 17 deletions(-)
>  create mode 100644 Documentation/virtual/kvm/devices/arm-vgic-v3.txt
>
> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> new file mode 100644
> index 0000000..69201e8
> --- /dev/null
> +++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> @@ -0,0 +1,176 @@
> +ARM Virtual Generic Interrupt Controller v3 and later (VGICv3)
> +==============================================================
> +
> +
> +Device types supported:
> +  KVM_DEV_TYPE_ARM_VGIC_V3     ARM Generic Interrupt Controller v3.0
> +
> +Only one VGIC instance may be instantiated through this API.  The created VGIC
> +will act as the VM interrupt controller, requiring emulated user-space devices
> +to inject interrupts to the VGIC instead of directly to CPUs.  It is not
> +possible to create both a GICv3 and GICv2 on the same VM.
> +
> +Creating a guest GICv3 device requires a host GICv3 as well.
> +
> +Groups:
> +  KVM_DEV_ARM_VGIC_GRP_ADDR
> +  Attributes:
> +    KVM_VGIC_V3_ADDR_TYPE_DIST (rw, 64-bit)
> +      Base address in the guest physical address space of the GICv3 distributor
> +      register mappings. Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
> +      This address needs to be 64K aligned and the region covers 64 KByte.
> +
> +    KVM_VGIC_V3_ADDR_TYPE_REDIST (rw, 64-bit)
> +      Base address in the guest physical address space of the GICv3
> +      redistributor register mappings. There are two 64K pages for each
> +      VCPU and all of the redistributor pages are contiguous.
> +      Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
> +      This address needs to be 64K aligned.
> +
> +
> +  KVM_DEV_ARM_VGIC_GRP_DIST_REGS
> +  KVM_DEV_ARM_VGIC_GRP_REDIST_REGS
> +  Attributes:
> +    The attr field of kvm_device_attr encodes two values:
> +    bits:     | 63   ....  32  |  31   ....    0 |
> +    values:   |      mpidr     |      offset     |
> +
> +    All distributor regs are (rw, 32-bit) and kvm_device_attr.addr points to a
> +    __u32 value.  64-bit registers must be accessed by separately accessing the
> +    lower and higher word.
> +
> +    Writes to read-only registers can be ignored by the kernel.

Presumably "are ignored".

> +
> +    KVM_DEV_ARM_VGIC_GRP_DIST_REGS accesses the main distributor registers.
> +    KVM_DEV_ARM_VGIC_GRP_REDIST_REGS accesses the redistributor of the CPU
> +    specified by the mpidr.
> +
> +    The offset is relative to the "[Re]Distributor base address" as defined
> +    in the GICv3/4 specs.  Getting or setting such a register has the same
> +    effect as reading or writing the register on real hardware (except for
> +    GICD_STATUS and GICR_STATUSR, see blow), and the mpidr field is used to

"GICD_STATUSR". "below".

> +    specify which redistributor is accessed.  The mpidr is ignored for the
> +    distributor.
> +
> +    The mpidr encoding is based on the affinity information in the
> +    architecture defined MPIDR, and the field is encoded as follows:
> +      | 63 .... 56 | 55 .... 48 | 47 .... 40 | 39 .... 32 |
> +      |    Aff3    |    Aff2    |    Aff1    |    Aff0    |
> +
> +    Note that distributor fields are not banked, but return the same value
> +    regardless of the mpidr used to access the register.
> +
> +    The GICD_STATUSR and GICR_STATUSR registers are architecturally defined such
> +    that a write of a clear bit has no effect, whereas a write with a set bit
> +    clears that value.  To allow userspace to freely set the values of these two
> +    registers, setting the attributes with the register offsets for these two
> +    registers simply sets the non-reserved bits to the value written.
> +  Limitations:
> +    - Priorities are not implemented, and registers are RAZ/WI
> +  Errors:
> +    -ENXIO: Getting or setting this register is not yet supported
> +    -EBUSY: One or more VCPUs are running
> +
> +
> +  KVM_DEV_ARM_VGIC_CPU_SYSREGS
> +  Attributes:
> +    The attr field of kvm_device_attr encodes two values:
> +    bits:     | 63      ....       32 | 31  ....  16 | 15  ....  0 |
> +    values:   |         mpidr         |      RES     |    instr    |
> +
> +    The mpidr field encodes the CPU ID based on the affinity information in the
> +    architecture defined MPIDR, and the field is encoded as follows:
> +      | 63 .... 56 | 55 .... 48 | 47 .... 40 | 39 .... 32 |
> +      |    Aff3    |    Aff2    |    Aff1    |    Aff0   |

ASCII art diagram missing a space after "Aff0" ?

> +
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
> +        Get/Set the intput level of the IRQ line for a given IRQ.

"input"

> +       vINTID must be a multiple of 32.
> +
> +        kvm_device_attr.addr points to a __u32 value which will contain a
> +       bitmap where a set bit means the interrupt level is asserted.
> +
> +       Bit[n] indicates the status for interrupt vINTID + n.
> +
> +
> +      VGIC_LEVEL_INFO_SOFT_PENDING
> +        Get/Set the latch state of a GIVEN level-triggered IRQ as manipulated by

Why is "given" capitalised?

I would like this to simply get/set the latch state regardless of whether
the interrupt is edge triggered or level triggered. (Obviously if the
interrupt is edge triggered this is equivalent to accessing the
ISPENDR/ICPENDR registers, but I don't want in userspace to have to
manually look at whether each interrupt is edge or level in order to
identify whether to use ISPENDR or this API, when in fact the state
in the kernel is exactly the same. I just want a straightforward
get/set accessor to the underlying state.)

thanks
-- PMM

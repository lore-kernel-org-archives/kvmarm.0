From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v7 1/6] KVM: arm/arm64: Add VGICv3 save/restore API documentation
Date: Fri, 15 Apr 2016 14:20:14 +0100
Message-ID: <CAFEAcA8g8r5M0KtYbjLchJAn_EZbZEBu0PdoREX9Eof+KvM=2g@mail.gmail.com>
References: <cover.1449491035.git.p.fedin@samsung.com> <204d6b178e611ee0b5aede2b945516e0a6048c3c.1449491035.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <204d6b178e611ee0b5aede2b945516e0a6048c3c.1449491035.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 7 December 2015 at 12:29, Pavel Fedin <p.fedin@samsung.com> wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
>
> Factor out the GICv3-specific documentation into a separate
> documentation file.  Add description for how to access distributor,
> redistributor, and CPU interface registers for GICv3 in this new file.

> +  KVM_DEV_ARM_VGIC_GRP_DIST_REGS
> +  KVM_DEV_ARM_VGIC_GRP_REDIST_REGS
> +  Attributes:
> +    The attr field of kvm_device_attr encodes two values:
> +    bits:     | 63   ....  32  |  31   ....    0 |
> +    values:   |      mpidr     |      offset     |
> +
> +    All distributor regs are (rw, 64-bit).
> +
> +    KVM_DEV_ARM_VGIC_GRP_DIST_REGS accesses the main distributor registers.
> +    KVM_DEV_ARM_VGIC_GRP_REDIST_REGS accesses the redistributor of the CPU
> +    specified by the mpidr.
> +
> +    The offset is relative to the "[Re]Distributor base address" as defined
> +    in the GICv3/4 specs.  Getting or setting such a register has the same
> +    effect as reading or writing the register on real hardware, and the mpidr
> +    field is used to specify which redistributor is accessed.  The mpidr is
> +    ignored for the distributor.

I've just noticed an awkward wrinkle here. The (optional) registers
GICR_STATUSR and GICD_STATUSR are both architecturally "write-1-to-clear",
with no mechanism in the hardware to write 1 bits back into them.
So if we want to support migrating these state fields, the behaviour
of the userspace accessor has to be something different from the effect
of writing the register on real hardware (eg "writes actually write the
specified value")...

thanks
-- PMM

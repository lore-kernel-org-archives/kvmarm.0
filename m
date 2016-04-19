From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 24/45] KVM: arm/arm64: vgic-new: Add GICv3 CTLR, IIDR,
 TYPER handlers
Date: Tue, 19 Apr 2016 13:26:39 +0100
Message-ID: <CAFEAcA9Cc2+OPYSeRf_XzksnfrAyaUSrPmTTdZPu8C78aweDBg@mail.gmail.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com> <1460740316-8755-25-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1460740316-8755-25-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 15 April 2016 at 18:11, Andre Przywara <andre.przywara@arm.com> wrote:
> As in the GICv2 emulation we handle those three registers in one
> function.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>
> Changelog RFC..v1:
> - kick VCPUs if distributor gets enabled
> ---
>  virt/kvm/arm/vgic/vgic.h      |  2 ++
>  virt/kvm/arm/vgic/vgic_mmio.c | 56 ++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 57 insertions(+), 1 deletion(-)
>
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index ccae13e..83b342c 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -19,6 +19,8 @@
>  #define PRODUCT_ID_KVM         0x4b    /* ASCII code K */
>  #define IMPLEMENTER_ARM                0x43b
>
> +#define INTERRUPT_ID_BITS_SPIS 10
> +
>  #define vgic_irq_is_sgi(intid) ((intid) < VGIC_NR_SGIS)
>
>  struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
> diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
> index 4a31d60..a87bbca 100644
> --- a/virt/kvm/arm/vgic/vgic_mmio.c
> +++ b/virt/kvm/arm/vgic/vgic_mmio.c
> @@ -686,6 +686,60 @@ static int vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
>         return 0;
>  }
>
> +/*****************************/
> +/* GICv3 emulation functions */
> +/*****************************/
> +#ifdef CONFIG_KVM_ARM_VGIC_V3
> +
> +static int vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
> +                                 struct kvm_io_device *dev,
> +                                 gpa_t addr, int len, void *val)
> +{
> +       u32 value = 0;
> +
> +       switch (addr & 0x0c) {
> +       case GICD_CTLR:
> +               if (vcpu->kvm->arch.vgic.enabled)
> +                      value |= GICD_CTLR_ENABLE_SS_G1;

...what about the EnableGrp0 bit ? You're a single-security-State
GIC (since you advertise DS==1), so you should have two enable bits here.

> +               value |= GICD_CTLR_ARE_NS | GICD_CTLR_DS;
> +               break;
> +       case GICD_TYPER:
> +               value = vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
> +               value = (value >> 5) - 1;
> +               value |= (INTERRUPT_ID_BITS_SPIS - 1) << 19;

Are you deliberately claiming support for 1-of-N SPI interrupts (No1N == 0) ?
Is A3V==0 (no support for non-zero Aff3) correct? Is it a restriction we
might lift in future?

> +               break;
> +       case GICD_IIDR:
> +               value = (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
> +               break;
> +       default:
> +               return 0;
> +       }
> +
> +       write_mask32(value, addr & 3, len, val);
> +       return 0;
> +}
> +
> +static int vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
> +                                  struct kvm_io_device *dev,
> +                                  gpa_t addr, int len, const void *val)
> +{
> +       struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +       bool was_enabled = dist->enabled;
> +
> +       /* Of the whole region only the first byte is actually writeable. */
> +       if ((addr & 0x0f) > 0)
> +               return 0;
> +
> +       /* We only care about the enable bit, all other bits are WI. */
> +       dist->enabled = *(u8*)val & GICD_CTLR_ENABLE_SS_G1;

Again, there are two enable bits here.

Also, this is a 32-bit register, so how does the *(u8*) work?

> +
> +       if (!was_enabled && dist->enabled)
> +               vgic_kick_vcpus(vcpu->kvm);
> +
> +       return 0;
> +}
> +
> +
>  /*
>   * The GICv3 per-IRQ registers are split to control PPIs and SGIs in the
>   * redistributors, while SPIs are covered by registers in the distributor
> @@ -734,7 +788,7 @@ struct vgic_register_region vgic_v2_dist_registers[] = {
>  #ifdef CONFIG_KVM_ARM_VGIC_V3
>  struct vgic_register_region vgic_v3_dist_registers[] = {
>         REGISTER_DESC_WITH_LENGTH(GICD_CTLR,
> -               vgic_mmio_read_nyi, vgic_mmio_write_nyi, 16),
> +               vgic_mmio_read_v3_misc, vgic_mmio_write_v3_misc, 16),

...and here it says 16, which is neither 8 nor 32...

>         REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGROUPR,
>                 vgic_mmio_read_rao, vgic_mmio_write_wi, 1),
>         REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISENABLER,
> --
> 2.7.3

thanks
-- PMM

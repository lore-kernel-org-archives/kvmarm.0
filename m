From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH 32/37] KVM: arm/arm64: Handle VGICv2 save/restore from
 the main VGIC code
Date: Sun, 26 Nov 2017 13:29:30 +0300
Message-ID: <20171126102930.73pnzrnd3l47u5ql@yury-thinkpad>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-33-christoffer.dall@linaro.org>
 <2f7e5d1f-4d60-cd53-f6ff-f4af127bc0b6@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3156F49D70
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Nov 2017 05:27:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LhDtteZb0bff for <kvmarm@lists.cs.columbia.edu>;
 Sun, 26 Nov 2017 05:27:02 -0500 (EST)
Received: from NAM02-BL2-obe.outbound.protection.outlook.com
 (mail-bl2nam02on0055.outbound.protection.outlook.com [104.47.38.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 293BA49D6F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Nov 2017 05:27:02 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <2f7e5d1f-4d60-cd53-f6ff-f4af127bc0b6@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 15, 2017 at 05:50:07PM +0000, Andre Przywara wrote:
> Hi,
> 
> those last few patches are actually helpful for the Xen port ...

[...] 

> > +static void save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
> > +{
> > +	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
> > +	int nr_lr = kvm_vgic_global_state.nr_lr;
> > +	u32 elrsr0, elrsr1;
> > +
> > +	elrsr0 = readl_relaxed(base + GICH_ELRSR0);
> > +	if (unlikely(nr_lr > 32))
> > +		elrsr1 = readl_relaxed(base + GICH_ELRSR1);
> > +	else
> > +		elrsr1 = 0;
> > +
> > +#ifdef CONFIG_CPU_BIG_ENDIAN
> > +	cpu_if->vgic_elrsr = ((u64)elrsr0 << 32) | elrsr1;
> > +#else
> > +	cpu_if->vgic_elrsr = ((u64)elrsr1 << 32) | elrsr0;
> > +#endif
> 
> I have some gut feeling that this is really broken, since we mix up
> endian *byte* ordering with *bit* ordering here, don't we?

Good feeling indeed. :)

We have bitmap_{from,to)_u32array for things like this. But it was
considered bad-designed, and I proposed new bitmap_{from,to)_arr32().

https://lkml.org/lkml/2017/11/15/592

What else I have in mind, to introduce something like bitmap_{from,to}_pair_32()
as most of current users of bitmap_{from,to)_u32array(), (and those who should
use it but don't, like this one) have only 2 32-bit halfwords to be copied
from/to bitmap.

Also, it will be complementary to bitmap_from_u64().

More reading about bitmap/array conversion is in comment to BITMAP_FROM_U64
macro.

> I understand it's just copied and gets removed later on, so I was
> wondering if you could actually move patch 35/37 ("Get rid of
> vgic_elrsr") before this patch here, to avoid copying bogus code around?
> Or does 35/37 depend on 34/37 to be correct?
> 
> > +}
> > +
> > +static void save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
> > +{
> > +	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
> > +	int i;
> > +	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
> > +
> > +	for (i = 0; i < used_lrs; i++) {
> > +		if (cpu_if->vgic_elrsr & (1UL << i))

So, the vgic_elrsr is naturally bitmap, and bitmap API is preferred if no
other considerations:
                if (test_bit(i, cpu_if->vgic_elrsr))

> > +			cpu_if->vgic_lr[i] &= ~GICH_LR_STATE;
> > +		else
> > +			cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));
> > +
> > +		writel_relaxed(0, base + GICH_LR0 + (i * 4));
> > +	}
> > +}

I'd also headscratch about using for_each_clear_bit() here: 

        /*
         * Setup default vgic_lr values somewhere earlier.
         * Not needed at all if you take my suggestion for
         * vgic_v2_restore_state() below
         */
        for (i = 0; i < used_lrs; i++)
                cpu_if->vgic_lr[i] &= ~GICH_LR_STATE;

static void save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
{
	[...]

	for_each_clear_bit (i, cpu_if->vgic_elrsr, used_lrs)
		cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));

        for (i = 0; i < used_lrs; i++)
		writel_relaxed(0, base + GICH_LR0 + (i * 4));
}

Not sure how performance-critical this path is, but sometimes things
get really faster with bitmaps. 

[...]

> > +void vgic_v2_restore_state(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm *kvm = vcpu->kvm;
> > +	struct vgic_dist *vgic = &kvm->arch.vgic;
> > +	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
> > +	void __iomem *base = vgic->vctrl_base;
> > +	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
> > +	int i;
> > +
> > +	if (!base)
> > +		return;
> > +
> > +	if (used_lrs) {
> > +		writel_relaxed(cpu_if->vgic_hcr, base + GICH_HCR);
> > +		writel_relaxed(cpu_if->vgic_apr, base + GICH_APR);
> > +		for (i = 0; i < used_lrs; i++) {
> > +			writel_relaxed(cpu_if->vgic_lr[i],
> > +				       base + GICH_LR0 + (i * 4));
> > +		}
> > +	}
> > +}

The alternative approach would be:
	for (i = 0; i < used_lrs; i++) {
                if (test_bit(i, cpu_if->vgic_elrsr))
                        writel_relaxed(~GICH_LR_STATE, base + GICH_LR0 + (i * 4));
                else
                        writel_relaxed(cpu_if->vgic_lr[i], base + GICH_LR0 + (i * 4));
	}

If cpu_if->vgic_elrsr is untouched in-between of course. It will make
save_lrs() simpler and this function more verbose.

Thanks,
Yury

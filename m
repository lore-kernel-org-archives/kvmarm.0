From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 14/31] KVM: arm64: vgic-v3: Add ICV_EOIR1_EL1 handler
Date: Wed, 31 May 2017 07:46:34 +0100
Message-ID: <20170531074634.588aa76e@why.wild-wind.fr.eu.org>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
        <20170503104606.19342-15-marc.zyngier@arm.com>
        <c3baec82-20c6-c948-9cb8-8247802cbff5@redhat.com>
        <2eb7f08f-bb47-cd7b-e631-3d42c35336ee@arm.com>
        <0dabccc1-ffa2-0ee1-71a4-71390791f056@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <0dabccc1-ffa2-0ee1-71a4-71390791f056@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 31 May 2017 08:33:05 +0200
Auger Eric <eric.auger@redhat.com> wrote:

> Hi Marc,
> 
> On 30/05/2017 16:24, Marc Zyngier wrote:
> > On 30/05/17 08:48, Auger Eric wrote:  
> >> Hi Marc
> >>
> >> On 03/05/2017 12:45, Marc Zyngier wrote:  
> >>> Add a handler for writing the guest's view of the ICC_EOIR1_EL1
> >>> register. This involves dropping the priority of the interrupt,
> >>> and deactivating it if required (EOImode == 0).
> >>>
> >>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >>> ---
> >>>  include/linux/irqchip/arm-gic-v3.h |   2 +
> >>>  virt/kvm/arm/hyp/vgic-v3-sr.c      | 119 +++++++++++++++++++++++++++++++++++++
> >>>  2 files changed, 121 insertions(+)
> >>>
> >>> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> >>> index 7610ea4e8337..c56d9bc2c904 100644
> >>> --- a/include/linux/irqchip/arm-gic-v3.h
> >>> +++ b/include/linux/irqchip/arm-gic-v3.h
> >>> @@ -403,6 +403,8 @@
> >>>  
> >>>  #define ICH_HCR_EN			(1 << 0)
> >>>  #define ICH_HCR_UIE			(1 << 1)
> >>> +#define ICH_HCR_EOIcount_SHIFT		27
> >>> +#define ICH_HCR_EOIcount_MASK		(0x1f << ICH_HCR_EOIcount_SHIFT)
> >>>  
> >>>  #define ICH_VMCR_CBPR_SHIFT		4
> >>>  #define ICH_VMCR_CBPR_MASK		(1 << ICH_VMCR_CBPR_SHIFT)
> >>> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> >>> index 49aad1de3ac8..a76351b3ad66 100644
> >>> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> >>> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> >>> @@ -425,6 +425,26 @@ static int __hyp_text __vgic_v3_highest_priority_lr(struct kvm_vcpu *vcpu,
> >>>  	return lr;
> >>>  }
> >>>  
> >>> +static int __hyp_text __vgic_v3_find_active_lr(struct kvm_vcpu *vcpu,
> >>> +					       int intid, u64 *lr_val)
> >>> +{
> >>> +	unsigned int used_lrs = vcpu->arch.vgic_cpu.used_lrs;
> >>> +	int i;
> >>> +
> >>> +	for (i = 0; i < used_lrs; i++) {
> >>> +		u64 val = __gic_v3_get_lr(i);
> >>> +
> >>> +		if ((val & ICH_LR_VIRTUAL_ID_MASK) == intid &&
> >>> +		    (val & ICH_LR_ACTIVE_BIT)) {  
> >> I guess it is safe because we don't have yet virtual interrupts directly
> >> mapped to phys IRQs, besides timer one?  
> > 
> > What would that change? I don't see how having a HW interrupt here would
> > be unsafe... Am I missing something?  
> I was thinking about the case of an HW mapped interrupt whose active
> state must be observed at distributor level - as I understood the spec -
> and not at LR level.

What part of the spec are you referring to?

A virtual interrupt, even backed by a HW interrupt, does have an active
state (unless it is an LPI). The only state we cannot observe in the LR
when the HW bit is set is the Active+Pending state because the pending
bit is then at the physical distributor level.

For all intent and purposes, the active state in the LR behaves the
same, irrespective of the HW state, until the guest issues a
deactivation (either using EOI or DIR, depending on EOImode).

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.

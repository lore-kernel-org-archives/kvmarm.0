From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 2/2] KVM: arm/arm64: vgic-v3: Format PMR to mimic the
 GICv2 behaviour
Date: Mon, 20 Mar 2017 15:24:35 +0100
Message-ID: <20170320142435.GC20711@cbox>
References: <20170316114535.25233-1-marc.zyngier@arm.com>
 <20170316114535.25233-3-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4239740C58
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Mar 2017 10:22:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1jWPN4CYeLCY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Mar 2017 10:22:53 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DB1AA40C4C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Mar 2017 10:22:52 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id u132so64951780wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Mar 2017 07:24:37 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170316114535.25233-3-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 16, 2017 at 11:45:35AM +0000, Marc Zyngier wrote:
> Similarily to the GICv2 case, we need to expose a PMR value that
> is either the 8bit value (KVM_DEV_ARM_VGIC_CTRL_CANONICAL_PMR
> being set) or the 5bit, truncated value otherwise.

I'm a bit puzzled by this patch as well.  The struct vmcr is an internal
representation of the VMCR register fields without well-defined
semantics of how the fields should be laid out.

I think I would prefer it if we document on the vmcr struct which format
the pmr field is in, and choose the actual ICC_PMR_EL1 or GICC_PMR
format for this field, and then we leave the get/set_vmcr functions
untouched.

> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-v3.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index be0f4c3e0142..d260214a5bdb 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -184,6 +184,17 @@ void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
>  	vmcr |= (vmcrp->ctlr << ICH_VMCR_CBPR_SHIFT) & ICH_VMCR_CBPR_MASK;
>  	vmcr |= (vmcrp->abpr << ICH_VMCR_BPR1_SHIFT) & ICH_VMCR_BPR1_MASK;
>  	vmcr |= (vmcrp->bpr << ICH_VMCR_BPR0_SHIFT) & ICH_VMCR_BPR0_MASK;
> +
> +	/*
> +	 * If we're emulating GICv2 and that userspace can't deal with

My comments above notwithstanding:

s/that//

> +	 * the normal PMR range (8 bits), we need to make it GICv3
> +	 * compatible by shifting the value by 3 bits in order to deal
> +	 * with the full 8bit range.
> +	 */
> +	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2 &&
> +	    !test_bit(VGIC_QUIRK_CANONICAL_PMR, &vcpu->kvm->arch.vgic.quirks))
> +		vmcrp->pmr <<= 3;
> +
>  	vmcr |= (vmcrp->pmr << ICH_VMCR_PMR_SHIFT) & ICH_VMCR_PMR_MASK;
>  	vmcr |= (vmcrp->grpen0 << ICH_VMCR_ENG0_SHIFT) & ICH_VMCR_ENG0_MASK;
>  	vmcr |= (vmcrp->grpen1 << ICH_VMCR_ENG1_SHIFT) & ICH_VMCR_ENG1_MASK;
> @@ -205,6 +216,16 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
>  	vmcrp->abpr = (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
>  	vmcrp->bpr  = (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
>  	vmcrp->pmr  = (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
> +
> +	/*
> +	 * If we're emulating GICv2 and that userspace DOES NOT deal

s/that//

nit: why do we write DOES NOT here i upper case (feels a bit aggressive)?

> +	 * with the normal PMR range (8 bits), we need to reduce it to
> +	 * the GICv2 range (5 bits).
> +	 */
> +	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2 &&
> +	    !test_bit(VGIC_QUIRK_CANONICAL_PMR, &vcpu->kvm->arch.vgic.quirks))
> +		vmcrp->pmr >>= 3;
> +
>  	vmcrp->grpen0 = (vmcr & ICH_VMCR_ENG0_MASK) >> ICH_VMCR_ENG0_SHIFT;
>  	vmcrp->grpen1 = (vmcr & ICH_VMCR_ENG1_MASK) >> ICH_VMCR_ENG1_SHIFT;
>  }
> -- 
> 2.11.0
> 

Thanks,
-Christoffer

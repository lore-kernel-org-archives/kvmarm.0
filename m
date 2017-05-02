From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 4/5] KVM: arm/arm64: vgic-v3: Do not use Active+Pending
 state for a HW interrupt
Date: Tue, 2 May 2017 22:56:45 +0200
Message-ID: <20170502205645.GB4421@cbox>
References: <20170502133041.10980-1-marc.zyngier@arm.com>
 <20170502133041.10980-5-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D3C540B40
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 May 2017 16:53:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I9Xn1--MqI1A for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 May 2017 16:53:43 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A76640969
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 May 2017 16:53:43 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id n198so17200832wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 May 2017 13:56:46 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170502133041.10980-5-marc.zyngier@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 02, 2017 at 02:30:40PM +0100, Marc Zyngier wrote:
> When an interrupt is injected with the HW bit set (indicating that
> deactivation should be propagated to the physical distributor),
> special care must be taken so that we never mark the corresponding
> LR with the Active+Pending state (as the pending state is kept in
> the physycal distributor).
> 
> Cc: stable@vger.kernel.org
> Fixes: 59529f69f504 ("KVM: arm/arm64: vgic-new: Add GICv3 world switch backend")
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <cdall@linaro.org>

> ---
>  virt/kvm/arm/vgic/vgic-v3.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index df1503650300..393779ebe87c 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -127,6 +127,13 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
>  	if (irq->hw) {
>  		val |= ICH_LR_HW;
>  		val |= ((u64)irq->hwintid) << ICH_LR_PHYS_ID_SHIFT;
> +		/*
> +		 * Never set pending+active on a HW interrupt, as the
> +		 * pending state is kept at the physical distributor
> +		 * level.
> +		 */
> +		if (irq->active && irq_is_pending(irq))
> +			val &= ~ICH_LR_PENDING_BIT;
>  	} else {
>  		if (irq->config == VGIC_CONFIG_LEVEL)
>  			val |= ICH_LR_EOI;
> -- 
> 2.11.0
> 

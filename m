Return-Path: <SRS0=3L6A=KT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2CABC2B9F7
	for <kvmarm@archiver.kernel.org>; Mon, 24 May 2021 16:52:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6FA216140A
	for <kvmarm@archiver.kernel.org>; Mon, 24 May 2021 16:52:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FA216140A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B86404B15C;
	Mon, 24 May 2021 12:52:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uoORRBO6YOOE; Mon, 24 May 2021 12:52:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FB264B14F;
	Mon, 24 May 2021 12:52:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14E7E4B124
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 May 2021 12:52:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VdcaCB86zX9x for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 May 2021 12:52:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A487F4B11E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 May 2021 12:52:20 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C1D5ED1;
 Mon, 24 May 2021 09:52:20 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C9E4D3F73B;
 Mon, 24 May 2021 09:52:18 -0700 (PDT)
Subject: Re: [PATCH v3 6/9] KVM: arm64: vgic: Implement SW-driven deactivation
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210510134824.1910399-1-maz@kernel.org>
 <20210510134824.1910399-7-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <fbd86687-b0cb-9979-b0a1-7e67efdd6b0a@arm.com>
Date: Mon, 24 May 2021 17:53:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210510134824.1910399-7-maz@kernel.org>
Content-Language: en-US
Cc: Hector Martin <marcan@marcan.st>, kernel-team@android.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

Some questions regarding how this is supposed to work.

On 5/10/21 2:48 PM, Marc Zyngier wrote:
> In order to deal with these systems that do not offer HW-based
> deactivation of interrupts, let implement a SW-based approach:
>
> - When the irq is queued into a LR, treat it as a pure virtual
>   interrupt and set the EOI flag in the LR.
>
> - When the interrupt state is read back from the LR, force a
>   deactivation when the state is invalid (neither active nor
>   pending)
>
> Interrupts requiring such treatment get the VGIC_SW_RESAMPLE flag.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-v2.c | 19 +++++++++++++++----
>  arch/arm64/kvm/vgic/vgic-v3.c | 19 +++++++++++++++----
>  include/kvm/arm_vgic.h        | 10 ++++++++++
>  3 files changed, 40 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
> index 11934c2af2f4..2c580204f1dc 100644
> --- a/arch/arm64/kvm/vgic/vgic-v2.c
> +++ b/arch/arm64/kvm/vgic/vgic-v2.c
> @@ -108,11 +108,22 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>  		 * If this causes us to lower the level, we have to also clear
>  		 * the physical active state, since we will otherwise never be
>  		 * told when the interrupt becomes asserted again.
> +		 *
> +		 * Another case is when the interrupt requires a helping hand
> +		 * on deactivation (no HW deactivation, for example).
>  		 */
> -		if (vgic_irq_is_mapped_level(irq) && (val & GICH_LR_PENDING_BIT)) {
> -			irq->line_level = vgic_get_phys_line_level(irq);
> +		if (vgic_irq_is_mapped_level(irq)) {
> +			bool resample = false;
> +
> +			if (val & GICH_LR_PENDING_BIT) {
> +				irq->line_level = vgic_get_phys_line_level(irq);
> +				resample = !irq->line_level;
> +			} else if (vgic_irq_needs_resampling(irq) &&
> +				   !(irq->active || irq->pending_latch)) {

So this means that if the IRQ has the special flag, if it's not pending in the LR
or at the software level, and it's not active either, then perform interrupt
deactivation. I don't see where the state of the interrupt is checked again, am I
correct in assuming that we rely on the CPU interface to assert the interrupt to
the host while we run with interrupts enabled in the run loop, and the handler for
the interrupt will mark it pending for kvm_vgic_sync_hw_state->vgic_vx_fold_lr_state?

> +				resample = true;
> +			}
>  
> -			if (!irq->line_level)
> +			if (resample)

This name, "resample", is confusing to me, quite possibly because I'm not familiar
with the irqchip subsystem. It was my impression that "resample" means that at
some point, the physical interrupt state will be checked again, yet I don't see
that happening anywhere when VGIC_IRQ_SW_RESAMPLE is set. Am I mistaken in my
assumptions?

Thanks,

Alex

>  				vgic_irq_set_phys_active(irq, false);
>  		}
>  
> @@ -152,7 +163,7 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
>  	if (irq->group)
>  		val |= GICH_LR_GROUP1;
>  
> -	if (irq->hw) {
> +	if (irq->hw && !vgic_irq_needs_resampling(irq)) {
>  		val |= GICH_LR_HW;
>  		val |= irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
>  		/*
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 41ecf219c333..66004f61cd83 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -101,11 +101,22 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>  		 * If this causes us to lower the level, we have to also clear
>  		 * the physical active state, since we will otherwise never be
>  		 * told when the interrupt becomes asserted again.
> +		 *
> +		 * Another case is when the interrupt requires a helping hand
> +		 * on deactivation (no HW deactivation, for example).
>  		 */
> -		if (vgic_irq_is_mapped_level(irq) && (val & ICH_LR_PENDING_BIT)) {
> -			irq->line_level = vgic_get_phys_line_level(irq);
> +		if (vgic_irq_is_mapped_level(irq)) {
> +			bool resample = false;
> +
> +			if (val & ICH_LR_PENDING_BIT) {
> +				irq->line_level = vgic_get_phys_line_level(irq);
> +				resample = !irq->line_level;
> +			} else if (vgic_irq_needs_resampling(irq) &&
> +				   !(irq->active || irq->pending_latch)) {
> +				resample = true;
> +			}
>  
> -			if (!irq->line_level)
> +			if (resample)
>  				vgic_irq_set_phys_active(irq, false);
>  		}
>  
> @@ -136,7 +147,7 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
>  		}
>  	}
>  
> -	if (irq->hw) {
> +	if (irq->hw && !vgic_irq_needs_resampling(irq)) {
>  		val |= ICH_LR_HW;
>  		val |= ((u64)irq->hwintid) << ICH_LR_PHYS_ID_SHIFT;
>  		/*
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index e5f06df000f2..e602d848fc1a 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -99,6 +99,11 @@ enum vgic_irq_config {
>   * kvm_arm_get_running_vcpu() to get the vcpu pointer for private IRQs.
>   */
>  struct irq_ops {
> +	/* Per interrupt flags for special-cased interrupts */
> +	unsigned long flags;
> +
> +#define VGIC_IRQ_SW_RESAMPLE	BIT(0)	/* Clear the active state for resampling */
> +
>  	/*
>  	 * Callback function pointer to in-kernel devices that can tell us the
>  	 * state of the input level of mapped level-triggered IRQ faster than
> @@ -150,6 +155,11 @@ struct vgic_irq {
>  					   for in-kernel devices. */
>  };
>  
> +static inline bool vgic_irq_needs_resampling(struct vgic_irq *irq)
> +{
> +	return irq->ops && (irq->ops->flags & VGIC_IRQ_SW_RESAMPLE);
> +}
> +
>  struct vgic_register_region;
>  struct vgic_its;
>  
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

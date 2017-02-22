From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH] KVM: arm/arm64: vgic-v3: Don't pretend to support IRQ/FIQ
 bypass
Date: Wed, 22 Feb 2017 17:52:03 +0100
Message-ID: <0aaafedb-2f0c-c99c-3c7d-8c6e540df93d@redhat.com>
References: <20170222121348.3138-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7113840C2F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Feb 2017 11:51:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qpWvAAOjjaoK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Feb 2017 11:51:10 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6517540C2E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Feb 2017 11:51:09 -0500 (EST)
In-Reply-To: <20170222121348.3138-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 22/02/2017 13:13, Marc Zyngier wrote:
> Our GICv3 emulation always presents ICC_SRE_EL1 with DIB/DFB set to
> zero, which implies that there is a way to bypass the GIC and
> inject raw IRQ/FIQ by driving the CPU pins.
> 
> Of course, we don't allow that when the GIC is configured, but
> we fail to indicate that to the guest. The obvious fix is to
> set these bits (and never let them being changed again).
> 
> Reported-by: Peter Maydell <peter.maydell@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  include/linux/irqchip/arm-gic-v3.h | 2 ++
>  virt/kvm/arm/vgic/vgic-v3.c        | 5 ++++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index e808f8ae6f14..0a8bad331341 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -354,6 +354,8 @@
>   */
>  #define ICC_CTLR_EL1_EOImode_drop_dir	(0U << 1)
>  #define ICC_CTLR_EL1_EOImode_drop	(1U << 1)
> +#define ICC_SRE_EL1_DIB			(1U << 2)
> +#define ICC_SRE_EL1_DFB			(1U << 1)
>  #define ICC_SRE_EL1_SRE			(1U << 0)
>  
>  /*
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index e6b03fd8c374..d062256131fc 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -215,10 +215,13 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
>  	/*
>  	 * If we are emulating a GICv3, we do it in an non-GICv2-compatible
>  	 * way, so we force SRE to 1 to demonstrate this to the guest.
> +	 * Also, we don't support any form of IRQ/FIQ bypass.
>  	 * This goes with the spec allowing the value to be RAO/WI.
>  	 */
>  	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
> -		vgic_v3->vgic_sre = ICC_SRE_EL1_SRE;
> +		vgic_v3->vgic_sre = (ICC_SRE_EL1_DIB |
> +				     ICC_SRE_EL1_DFB |
> +				     ICC_SRE_EL1_SRE);
>  		vcpu->arch.vgic_cpu.pendbaser = INITIAL_PENDBASER_VALUE;
>  	} else {
>  		vgic_v3->vgic_sre = 0;
> 

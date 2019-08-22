Return-Path: <SRS0=16Xb=WS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5261FC3A5A1
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 19:30:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C576521848
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 19:30:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C576521848
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 041284A5DA;
	Thu, 22 Aug 2019 15:30:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id frrd+essTMBh; Thu, 22 Aug 2019 15:30:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FF504A5A0;
	Thu, 22 Aug 2019 15:30:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 520A84A589
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 15:30:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4-fwufeIOBD1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Aug 2019 15:29:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA5704A574
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 15:29:59 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 40773337;
 Thu, 22 Aug 2019 12:29:59 -0700 (PDT)
Received: from why (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 14A783F706;
 Thu, 22 Aug 2019 12:29:57 -0700 (PDT)
Date: Thu, 22 Aug 2019 20:29:54 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2] KVM: arm: VGIC: properly initialise private IRQ
 affinity
Message-ID: <20190822202954.48239e0e@why>
In-Reply-To: <20190822170510.167076-1-andre.przywara@arm.com>
References: <20190822170510.167076-1-andre.przywara@arm.com>
Organization: ARM Ltd
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Cc: Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Dave Martin <dave.martin@arm.com>
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

On Thu, 22 Aug 2019 18:05:10 +0100
Andre Przywara <andre.przywara@arm.com> wrote:

> At the moment we initialise the target *mask* of a virtual IRQ to the
> VCPU it belongs to, even though this mask is only defined for GICv2 and
> quickly runs out of bits for many GICv3 guests.
> This behaviour triggers an UBSAN complaint for more than 32 VCPUs:
> ------
> [ 5659.462377] UBSAN: Undefined behaviour in virt/kvm/arm/vgic/vgic-init.c:223:21
> [ 5659.471689] shift exponent 32 is too large for 32-bit type 'unsigned int'
> ------
> Also for GICv3 guests the reporting of TARGET in the "vgic-state" debugfs
> dump is wrong, due to this very same problem.
> 
> Because there is no requirement to create the VGIC device before the
> VCPUs (and QEMU actually does it the other way round), we can't safely
> initialise mpidr or targets in kvm_vgic_vcpu_init(). But since we touch
> every private IRQ for each VCPU anyway later (in vgic_init()), we can
> just move the initialisation of those fields into there, where we
> definitely know the VGIC type.
> 
> On the way make sure we really have either a VGICv2 or a VGICv3 device,
> since the former checks was just checking for "VGICv3 or not", silently
> ignoring the uninitialised case.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Reported-by: Dave Martin <dave.martin@arm.com>
> ---
> Hi,
> 
> tested with 4, 8 and 33 VCPUs with kvmtool and QEMU, on a GICv2 and a
> GICv3 machine.
> Also briefly tested localhost migration on the GICv3 machine w/ 33
> VCPUs, although I think all IRQs are group 1.
> 
> Cheers,
> Andre
> 
>  virt/kvm/arm/vgic/vgic-init.c | 28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 80127ca9269f..413fb6a5525c 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -8,6 +8,7 @@
>  #include <linux/cpu.h>
>  #include <linux/kvm_host.h>
>  #include <kvm/arm_vgic.h>
> +#include <asm/kvm_emulate.h>
>  #include <asm/kvm_mmu.h>
>  #include "vgic.h"
>  
> @@ -165,12 +166,17 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
>  		irq->vcpu = NULL;
>  		irq->target_vcpu = vcpu0;
>  		kref_init(&irq->refcount);
> -		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2) {
> +		switch (dist->vgic_model) {
> +		case KVM_DEV_TYPE_ARM_VGIC_V2:
>  			irq->targets = 0;
>  			irq->group = 0;
> -		} else {
> +			break;
> +		case KVM_DEV_TYPE_ARM_VGIC_V3:
>  			irq->mpidr = 0;
>  			irq->group = 1;
> +			break;
> +		default:
> +			BUG_ON(1);
>  		}
>  	}
>  	return 0;
> @@ -210,7 +216,6 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
>  		irq->intid = i;
>  		irq->vcpu = NULL;
>  		irq->target_vcpu = vcpu;
> -		irq->targets = 1U << vcpu->vcpu_id;
>  		kref_init(&irq->refcount);
>  		if (vgic_irq_is_sgi(i)) {
>  			/* SGIs */
> @@ -220,11 +225,6 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
>  			/* PPIs */
>  			irq->config = VGIC_CONFIG_LEVEL;
>  		}
> -
> -		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
> -			irq->group = 1;
> -		else
> -			irq->group = 0;
>  	}
>  
>  	if (!irqchip_in_kernel(vcpu->kvm))
> @@ -287,10 +287,18 @@ int vgic_init(struct kvm *kvm)
>  
>  		for (i = 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
>  			struct vgic_irq *irq = &vgic_cpu->private_irqs[i];
> -			if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
> +			switch (dist->vgic_model) {
> +			case KVM_DEV_TYPE_ARM_VGIC_V3:
>  				irq->group = 1;
> -			else
> +				irq->mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
> +				break;
> +			case KVM_DEV_TYPE_ARM_VGIC_V2:
>  				irq->group = 0;
> +				irq->targets = 1U << idx;
> +				break;
> +			default:
> +				BUG_ON(1);
> +			}
>  		}
>  	}
>  

Please drop the BUG_ON()s. If something is unexpected, just fail to
init the guest, but don't kill the box.

Thanks,

	M.

-- 
Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=ht6V=WR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3620FC3A59E
	for <kvmarm@archiver.kernel.org>; Wed, 21 Aug 2019 17:02:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E8EB92332A
	for <kvmarm@archiver.kernel.org>; Wed, 21 Aug 2019 17:02:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8EB92332A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91D174A552;
	Wed, 21 Aug 2019 13:02:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D6mEgmM0BJfT; Wed, 21 Aug 2019 13:02:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B8874A55E;
	Wed, 21 Aug 2019 13:02:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC78A4A552
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Aug 2019 13:02:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 89lWYfSpXoYR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Aug 2019 13:02:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 461E04A541
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Aug 2019 13:02:00 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F0345337;
 Wed, 21 Aug 2019 10:01:59 -0700 (PDT)
Received: from [10.1.196.50] (e108454-lin.cambridge.arm.com [10.1.196.50])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 49AE33F718;
 Wed, 21 Aug 2019 10:01:59 -0700 (PDT)
Subject: Re: [RESEND PATCH] KVM: arm: VGIC: properly initialise private IRQ
 affinity
To: Andre Przywara <andre.przywara@arm.com>,
 Marc Zyngier <marc.zyngier@arm.com>
References: <20190821170052.169065-1-andre.przywara@arm.com>
From: Julien Grall <julien.grall@arm.com>
Message-ID: <ebd572f8-0fa7-83dc-d074-891a77787b0d@arm.com>
Date: Wed, 21 Aug 2019 18:01:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190821170052.169065-1-andre.przywara@arm.com>
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Dave Martin <dave.martin@arm.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Andre,

On 21/08/2019 18:00, Andre Przywara wrote:
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
> Fix both issues by only initialising vgic_irq->targets for a vGICv2 guest,
> and by initialising vgic_irq->mpdir for vGICv3 guests instead. We can't
> use the actual MPIDR for that, as the VCPU's system register is not
> initialised at this point yet. This is not really an issue, as ->mpidr
> is just used for the debugfs output and the IROUTER MMIO register, which
> does not exist in redistributors (dealing with SGIs and PPIs).
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Reported-by: Dave Martin <dave.martin@arm.com>

Tested-by: Julien Grall <julien.grall@arm.com>

Cheers,

> ---
> Hi,
> 
> this came up here again, I think it fell through the cracks back in
> March:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2019-March/637209.html
> 
> Cheers,
> Andre.
> 
>   virt/kvm/arm/vgic/vgic-init.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 80127ca9269f..8bce2f75e0c1 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -210,7 +210,6 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
>   		irq->intid = i;
>   		irq->vcpu = NULL;
>   		irq->target_vcpu = vcpu;
> -		irq->targets = 1U << vcpu->vcpu_id;
>   		kref_init(&irq->refcount);
>   		if (vgic_irq_is_sgi(i)) {
>   			/* SGIs */
> @@ -221,10 +220,14 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
>   			irq->config = VGIC_CONFIG_LEVEL;
>   		}
>   
> -		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
> +		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
>   			irq->group = 1;
> -		else
> +			/* The actual MPIDR is not initialised at this point. */
> +			irq->mpidr = 0;
> +		} else {
>   			irq->group = 0;
> +			irq->targets = 1U << vcpu->vcpu_id;
> +		}
>   	}
>   
>   	if (!irqchip_in_kernel(vcpu->kvm))
> 

-- 
Julien Grall
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

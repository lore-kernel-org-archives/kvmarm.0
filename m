Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F0B9C34026
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 08:47:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DA63B20658
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 08:47:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA63B20658
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E4ED4AF6E;
	Tue, 18 Feb 2020 03:47:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tYzGjQUx6ZRY; Tue, 18 Feb 2020 03:47:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5B3B4AF2D;
	Tue, 18 Feb 2020 03:47:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F00F04AF26
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 03:47:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o8IlUwcKFS+q for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 03:47:12 -0500 (EST)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 58FFE4AF18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 03:47:09 -0500 (EST)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 91E34EA84E46E844F2CB;
 Tue, 18 Feb 2020 16:46:58 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Tue, 18 Feb 2020
 16:46:51 +0800
Subject: Re: [PATCH v4 15/20] KVM: arm64: GICv4.1: Add direct injection
 capability to SGI registers
To: Marc Zyngier <maz@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-16-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5e744173-5d7a-98b7-e44d-d1f8c47b3e3c@huawei.com>
Date: Tue, 18 Feb 2020 16:46:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200214145736.18550-16-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Robert Richter <rrichter@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>
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

Hi Marc,

On 2020/2/14 22:57, Marc Zyngier wrote:
> Most of the GICv3 emulation code that deals with SGIs now has to be
> aware of the v4.1 capabilities in order to benefit from it.
> 
> Add such support, keyed on the interrupt having the hw flag set and
> being a SGI.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   virt/kvm/arm/vgic/vgic-mmio-v3.c | 15 +++++-
>   virt/kvm/arm/vgic/vgic-mmio.c    | 88 ++++++++++++++++++++++++++++++--
>   2 files changed, 96 insertions(+), 7 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index ebc218840fc2..de89da76a379 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -6,6 +6,7 @@
>   #include <linux/irqchip/arm-gic-v3.h>
>   #include <linux/kvm.h>
>   #include <linux/kvm_host.h>
> +#include <linux/interrupt.h>
>   #include <kvm/iodev.h>
>   #include <kvm/arm_vgic.h>
>   
> @@ -942,8 +943,18 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group1)
>   		 * generate interrupts of either group.
>   		 */
>   		if (!irq->group || allow_group1) {
> -			irq->pending_latch = true;
> -			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
> +			if (!irq->hw) {
> +				irq->pending_latch = true;
> +				vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
> +			} else {
> +				/* HW SGI? Ask the GIC to inject it */
> +				int err;
> +				err = irq_set_irqchip_state(irq->host_irq,
> +							    IRQCHIP_STATE_PENDING,
> +							    true);
> +				WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
> +				raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> +			}
>   		} else {
>   			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
>   		}
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index d656ebd5f9d4..0a1fb61e5b89 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -5,6 +5,8 @@
>   
>   #include <linux/bitops.h>
>   #include <linux/bsearch.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
>   #include <linux/kvm.h>
>   #include <linux/kvm_host.h>
>   #include <kvm/iodev.h>
> @@ -59,6 +61,11 @@ unsigned long vgic_mmio_read_group(struct kvm_vcpu *vcpu,
>   	return value;
>   }
>   
> +static void vgic_update_vsgi(struct vgic_irq *irq)
> +{
> +	WARN_ON(its_prop_update_vsgi(irq->host_irq, irq->priority, irq->group));
> +}
> +
>   void vgic_mmio_write_group(struct kvm_vcpu *vcpu, gpa_t addr,
>   			   unsigned int len, unsigned long val)
>   {
> @@ -71,7 +78,12 @@ void vgic_mmio_write_group(struct kvm_vcpu *vcpu, gpa_t addr,
>   
>   		raw_spin_lock_irqsave(&irq->irq_lock, flags);
>   		irq->group = !!(val & BIT(i));
> -		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
> +		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
> +			vgic_update_vsgi(irq);
> +			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> +		} else {
> +			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
> +		}
>   
>   		vgic_put_irq(vcpu->kvm, irq);
>   	}
> @@ -113,7 +125,21 @@ void vgic_mmio_write_senable(struct kvm_vcpu *vcpu,
>   		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>   
>   		raw_spin_lock_irqsave(&irq->irq_lock, flags);
> -		if (vgic_irq_is_mapped_level(irq)) {
> +		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
> +			if (!irq->enabled) {
> +				struct irq_data *data;
> +
> +				irq->enabled = true;
> +				data = &irq_to_desc(irq->host_irq)->irq_data;
> +				while (irqd_irq_disabled(data))
> +					enable_irq(irq->host_irq);
> +			}
> +
> +			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> +			vgic_put_irq(vcpu->kvm, irq);
> +
> +			continue;
> +		} else if (vgic_irq_is_mapped_level(irq)) {
>   			bool was_high = irq->line_level;
>   
>   			/*
> @@ -148,6 +174,8 @@ void vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
>   		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>   
>   		raw_spin_lock_irqsave(&irq->irq_lock, flags);
> +		if (irq->hw && vgic_irq_is_sgi(irq->intid) && irq->enabled)
> +			disable_irq_nosync(irq->host_irq);
>   
>   		irq->enabled = false;
>   
> @@ -167,10 +195,22 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
>   	for (i = 0; i < len * 8; i++) {
>   		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>   		unsigned long flags;
> +		bool val;
>   
>   		raw_spin_lock_irqsave(&irq->irq_lock, flags);
> -		if (irq_is_pending(irq))
> -			value |= (1U << i);
> +		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
> +			int err;
> +
> +			val = false;
> +			err = irq_get_irqchip_state(irq->host_irq,
> +						    IRQCHIP_STATE_PENDING,
> +						    &val);
> +			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
> +		} else {
> +			val = irq_is_pending(irq);
> +		}
> +
> +		value |= ((u32)val << i);
>   		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
>   
>   		vgic_put_irq(vcpu->kvm, irq);
> @@ -227,6 +267,21 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
>   		}
>   
>   		raw_spin_lock_irqsave(&irq->irq_lock, flags);
> +
> +		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
> +			/* HW SGI? Ask the GIC to inject it */
> +			int err;
> +			err = irq_set_irqchip_state(irq->host_irq,
> +						    IRQCHIP_STATE_PENDING,
> +						    true);
> +			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
> +
> +			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> +			vgic_put_irq(vcpu->kvm, irq);
> +
> +			continue;
> +		}
> +
>   		if (irq->hw)
>   			vgic_hw_irq_spending(vcpu, irq, is_uaccess);
>   		else

Should we consider taking the GICv4.1 support into uaccess_{read/write}
callbacks for GICR_ISPENDR0 so that userspace can properly save/restore
the pending state of GICv4.1 vSGIs?

I *think* we can do it because on restoration, GICD_CTLR(.nASSGIreq) is
restored before GICR_ISPENDR0.  So we know whether we're restoring
pending for vSGIs, and we can restore it to the HW level if v4.1 is
supported by GIC. Otherwise restore it by the normal way.

And saving is easy with the get_irqchip_state callback, right?

> @@ -281,6 +336,20 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
>   
>   		raw_spin_lock_irqsave(&irq->irq_lock, flags);
>   
> +		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
> +			/* HW SGI? Ask the GIC to inject it */

"Ask the GIC to clear its pending state" :-)


Thanks,
Zenghui

> +			int err;
> +			err = irq_set_irqchip_state(irq->host_irq,
> +						    IRQCHIP_STATE_PENDING,
> +						    false);
> +			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
> +
> +			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> +			vgic_put_irq(vcpu->kvm, irq);
> +
> +			continue;
> +		}
> +
>   		if (irq->hw)
>   			vgic_hw_irq_cpending(vcpu, irq, is_uaccess);
>   		else
> @@ -330,8 +399,15 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>   
>   	raw_spin_lock_irqsave(&irq->irq_lock, flags);
>   
> -	if (irq->hw) {
> +	if (irq->hw && !vgic_irq_is_sgi(irq->intid)) {
>   		vgic_hw_irq_change_active(vcpu, irq, active, !requester_vcpu);
> +	} else if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
> +		/*
> +		 * GICv4.1 VSGI feature doesn't track an active state,
> +		 * so let's not kid ourselves, there is nothing we can
> +		 * do here.
> +		 */
> +		irq->active = false;
>   	} else {
>   		u32 model = vcpu->kvm->arch.vgic.vgic_model;
>   		u8 active_source;
> @@ -505,6 +581,8 @@ void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
>   		raw_spin_lock_irqsave(&irq->irq_lock, flags);
>   		/* Narrow the priority range to what we actually support */
>   		irq->priority = (val >> (i * 8)) & GENMASK(7, 8 - VGIC_PRI_BITS);
> +		if (irq->hw && vgic_irq_is_sgi(irq->intid))
> +			vgic_update_vsgi(irq);
>   		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
>   
>   		vgic_put_irq(vcpu->kvm, irq);
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

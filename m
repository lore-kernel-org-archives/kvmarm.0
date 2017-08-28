From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 42/59] KVM: arm/arm64: GICv4: Handle INT command
 applied to a VLPI
Date: Mon, 28 Aug 2017 20:18:04 +0200
Message-ID: <20170828181804.GB24649@cbox>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-43-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4FE549C2D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 14:15:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AcIsGC2FxA8O for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Aug 2017 14:15:58 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A96AA49C28
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 14:15:58 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id y71so8029316wmd.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 11:18:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170731172637.29355-43-marc.zyngier@arm.com>
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
Cc: Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 31, 2017 at 06:26:20PM +0100, Marc Zyngier wrote:
> If the guest issues an INT command targetting a VLPI, let's
> call into the irq_set_irqchip_state() helper to make it pending
> on the physical side.
> 
> This works just as well if userspace decides to inject an interrupt
> using the normal userspace API...
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <cdall@linaro.org>

> ---
>  virt/kvm/arm/vgic/vgic-its.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index a2217f53bbe5..40aeadef33fe 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -573,6 +573,10 @@ static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
>  	if (err)
>  		return err;
>  
> +	if (irq->hw)
> +		return irq_set_irqchip_state(irq->host_irq,
> +					     IRQCHIP_STATE_PENDING, true);
> +
>  	spin_lock(&irq->irq_lock);
>  	irq->pending_latch = true;
>  	vgic_queue_irq_unlock(kvm, irq);
> -- 
> 2.11.0
> 

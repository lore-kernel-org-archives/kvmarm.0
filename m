From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 11/26] KVM: arm/arm64: GICv4: Handle INT command
 applied to a VLPI
Date: Tue, 7 Nov 2017 21:15:29 +0100
Message-ID: <6e12eac9-7b75-2c2c-0c79-d17a3c0d65eb@redhat.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-12-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CCD849D4B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 15:13:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SmvesHT9ySgl for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Nov 2017 15:13:40 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50EFB49D14
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 15:13:40 -0500 (EST)
In-Reply-To: <20171027142855.21584-12-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoffer Dall <cdall@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 27/10/2017 16:28, Marc Zyngier wrote:
> If the guest issues an INT command targetting a VLPI, let's
> call into the irq_set_irqchip_state() helper to make it pending
> on the physical side.
> 
> This works just as well if userspace decides to inject an interrupt
> using the normal userspace API...
There is also another path:
KVM_SIGNAL_MSI ioctl / kvm_send_userspace_msi / kvm_set_msi /
vgic_its_inject_msi / vgic_its_trigger_msi

I wonder whether we shouldn't prevent the userspace from messing up with
the host irq pending state?

Thanks

Eric
> 
> Acked-by: Christoffer Dall <cdall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 89768d2b6a91..b2a678d131d0 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -578,6 +578,10 @@ static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
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
> 

From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 45/59] KVM: arm/arm64: GICv4: Handle CLEAR applied to
 a VLPI
Date: Mon, 28 Aug 2017 20:18:22 +0200
Message-ID: <20170828181822.GF24649@cbox>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-46-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF4A849C41
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 14:16:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X8dAZA5iPH7p for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Aug 2017 14:16:17 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D887E49C2D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 14:16:16 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id y71so8033240wmd.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 11:18:25 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170731172637.29355-46-marc.zyngier@arm.com>
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

On Mon, Jul 31, 2017 at 06:26:23PM +0100, Marc Zyngier wrote:
> Handling CLEAR is pretty easy. Just ask the ITS driver to clear
> the corresponding pending bit (which will turn into a CLEAR
> command on the physical side).
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <cdall@linaro.org>

> ---
>  virt/kvm/arm/vgic/vgic-its.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index aaad577ce328..2c065c970ba0 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1069,6 +1069,10 @@ static int vgic_its_cmd_handle_clear(struct kvm *kvm, struct vgic_its *its,
>  
>  	ite->irq->pending_latch = false;
>  
> +	if (ite->irq->hw)
> +		return irq_set_irqchip_state(ite->irq->host_irq,
> +					     IRQCHIP_STATE_PENDING, false);
> +
>  	return 0;
>  }
>  
> -- 
> 2.11.0
> 

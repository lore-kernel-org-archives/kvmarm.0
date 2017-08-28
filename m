From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 47/59] KVM: arm/arm64: GICv4: Propagate property
 updates to VLPIs
Date: Mon, 28 Aug 2017 20:18:32 +0200
Message-ID: <20170828181832.GH24649@cbox>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-48-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BF4140D8B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 14:16:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8f4eo2voXDpX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Aug 2017 14:16:27 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 341204104E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 14:16:27 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id f13so14740340wme.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 11:18:35 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170731172637.29355-48-marc.zyngier@arm.com>
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

On Mon, Jul 31, 2017 at 06:26:25PM +0100, Marc Zyngier wrote:
> Upon updating a property, we propagate it all the way to the physical
> ITS, and ask for an INV command to be executed there.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <cdall@linaro.org>

> ---
>  virt/kvm/arm/vgic/vgic-its.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 65cc77fde609..9e46081e5f15 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -297,6 +297,9 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
>  		spin_unlock(&irq->irq_lock);
>  	}
>  
> +	if (irq->hw)
> +		return its_prop_update_vlpi(irq->host_irq, prop, true);
> +
>  	return 0;
>  }
>  
> -- 
> 2.11.0
> 

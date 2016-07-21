From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [RFC v7 6/7] KVM: arm/arm64: enable MSI routing
Date: Thu, 21 Jul 2016 18:21:22 +0200
Message-ID: <20160721162121.GD32739@potion>
References: <1468848357-2331-1-git-send-email-eric.auger@redhat.com>
 <1468848357-2331-7-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1468848357-2331-7-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

2016-07-18 13:25+0000, Eric Auger:
> Up to now, only irqchip routing entries could be set. This patch
> adds the capability to insert MSI routing entries.
> 
> For ARM64, let's also increase KVM_MAX_IRQ_ROUTES to 4096: this
> include SPI irqchip routes plus MSI routes. In the future this
> might be extended.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> 
> ---
> v6 -> v7:
> - added Andre's R-b
> 
> v2 -> v3:
> - remove any reference to KVM_IRQ_ROUTING_EXTENDED_MSI type
> - unconditionnaly uapi flags and devid downto the kernel
>   routing entry struct
> - handle KVM_MSI_VALID_DEVID flag in kvm_set_irq_routing
> - note about KVM_CAP_MSI_DEVID moved in the first patch file
>   of the series
> 
> v1 -> v2:
> - adapt to new routing entry types
> 
> RFC -> PATCH:
> - move api MSI routing updates into that patch file
> - use new devid field of user api struct
> ---
> diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
> @@ -209,7 +209,7 @@ int kvm_set_irq_routing(struct kvm *kvm,
>  			goto out;
>  
>  		r = -EINVAL;
> -		if (ue->flags) {
> +		if (ue->flags & ~KVM_MSI_VALID_DEVID) {

This allows KVM_MSI_VALID_DEVID flag for all route types, which is not
what we want.
To avoid checking separately when setting MSI route in every arch,
I think we could have a switch (ue->type) here as well.

>  			kfree(e);
>  			goto out;
>  		}

From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v3 01/12] KVM: arm/arm64: Set dist->spis to NULL after
 kfree
Date: Tue, 24 Apr 2018 23:06:33 +0200
Message-ID: <20180424210633.GD4533@C02W217FHV2R.local>
References: <1523607658-9166-1-git-send-email-eric.auger@redhat.com>
 <1523607658-9166-2-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1523607658-9166-2-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org, andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 13, 2018 at 10:20:47AM +0200, Eric Auger wrote:
> in case kvm_vgic_map_resources() fails, typically if the vgic
> distributor is not defined, __kvm_vgic_destroy will be called
> several times. Indeed kvm_vgic_map_resources() is called on
> first vcpu run. As a result dist->spis is freeed more than once
> and on the second time it causes a "kernel BUG at mm/slub.c:3912!"
> 
> Set dist->spis to NULL to avoid the crash.
> 
> Fixes: ad275b8bb1e6 ("KVM: arm/arm64: vgic-new: vgic_init: implement
> vgic_init")
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>

> 
> ---
> 
> v2 -> v3:
> - added Marc's R-b and Fixed commit
> ---
>  virt/kvm/arm/vgic/vgic-init.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 68378fe..c52f03d 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -308,6 +308,7 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
>  	dist->initialized = false;
>  
>  	kfree(dist->spis);
> +	dist->spis = NULL;
>  	dist->nr_spis = 0;
>  
>  	if (vgic_supports_direct_msis(kvm))
> -- 
> 2.5.5
> 

From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC 01/12] KVM: arm/arm64: Avoid multiple dist->spis kfree
Date: Mon, 19 Mar 2018 13:46:15 +0000
Message-ID: <92f4b34e-f361-869a-7fca-c62a70e646b7@arm.com>
References: <1521451220-27754-1-git-send-email-eric.auger@redhat.com>
 <1521451220-27754-2-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521451220-27754-2-git-send-email-eric.auger@redhat.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, cdall@kernel.org, peter.maydell@linaro.org
Cc: andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 19/03/18 09:20, Eric Auger wrote:
> in case kvm_vgic_map_resources() fails, typically if the vgic
> distributor is not defined, __kvm_vgic_destroy will be called
> several times. Indeed kvm_vgic_map_resources() is called on
> first vcpu run. As a result dist->spis is freeed twice and on
> the second time it causes a "kernel BUG at mm/slub.c:3912!"
> 
> This patch avoids freeing dist->spis twice.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  virt/kvm/arm/vgic/vgic-init.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 743ca5c..38fd5f1 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -324,7 +324,10 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
>  	dist->ready = false;
>  	dist->initialized = false;
>  
> -	kfree(dist->spis);
> +	if (dist->spis) {
> +		kfree(dist->spis);
> +		dist->spis = NULL;
> +	}

Given that kfree(NULL) is always a valid thing to do, you could write
the same thing just as

	dist-> spis = NULL;

without any test.

>  	dist->nr_spis = 0;
>  
>  	if (vgic_supports_direct_msis(kvm))
> 

You also may want to add a Fixes tag to it.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

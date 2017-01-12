From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Fix deadlock on error handling
Date: Thu, 12 Jan 2017 20:07:09 +0100
Message-ID: <20170112190709.GA18045@cbox>
References: <1484237774-19047-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484237774-19047-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: andre.przywara@arm.com, eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 12, 2017 at 04:16:14PM +0000, Marc Zyngier wrote:
> Dmitry Vyukov reported that the syzkaller fuzzer triggered a
> deadlock in the vgic setup code when an error was detected, as
> the cleanup code tries to take a lock that is already held by
> the setup code.
> 
> The fix is to avoid retaking the lock when cleaning up, by
> telling the cleanup function that we already hold it.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
>  virt/kvm/arm/vgic/vgic-init.c | 18 +++++++++++++-----
>  virt/kvm/arm/vgic/vgic-v2.c   |  2 --
>  virt/kvm/arm/vgic/vgic-v3.c   |  2 --
>  3 files changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 5114391..c737ea0 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -268,15 +268,11 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
>  
> -	mutex_lock(&kvm->lock);
> -
>  	dist->ready = false;
>  	dist->initialized = false;
>  
>  	kfree(dist->spis);
>  	dist->nr_spis = 0;
> -
> -	mutex_unlock(&kvm->lock);
>  }
>  
>  void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
> @@ -286,7 +282,8 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
>  }
>  
> -void kvm_vgic_destroy(struct kvm *kvm)
> +/* To be called with kvm->lock held */
> +static void __kvm_vgic_destroy(struct kvm *kvm)
>  {
>  	struct kvm_vcpu *vcpu;
>  	int i;
> @@ -297,6 +294,13 @@ void kvm_vgic_destroy(struct kvm *kvm)
>  		kvm_vgic_vcpu_destroy(vcpu);
>  }
>  
> +void kvm_vgic_destroy(struct kvm *kvm)
> +{
> +	mutex_lock(&kvm->lock);
> +	__kvm_vgic_destroy(kvm);
> +	mutex_unlock(&kvm->lock);
> +}
> +
>  /**
>   * vgic_lazy_init: Lazy init is only allowed if the GIC exposed to the guest
>   * is a GICv2. A GICv3 must be explicitly initialized by the guest using the
> @@ -348,6 +352,10 @@ int kvm_vgic_map_resources(struct kvm *kvm)
>  		ret = vgic_v2_map_resources(kvm);
>  	else
>  		ret = vgic_v3_map_resources(kvm);
> +
> +	if (ret)
> +		__kvm_vgic_destroy(kvm);
> +
>  out:
>  	mutex_unlock(&kvm->lock);
>  	return ret;
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index 9bab867..834137e 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -293,8 +293,6 @@ int vgic_v2_map_resources(struct kvm *kvm)
>  	dist->ready = true;
>  
>  out:
> -	if (ret)
> -		kvm_vgic_destroy(kvm);
>  	return ret;
>  }
>  
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 7df1b90..a4c7fff 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -308,8 +308,6 @@ int vgic_v3_map_resources(struct kvm *kvm)
>  	dist->ready = true;
>  
>  out:
> -	if (ret)
> -		kvm_vgic_destroy(kvm);
>  	return ret;
>  }
>  
> -- 
> 2.1.4
> 

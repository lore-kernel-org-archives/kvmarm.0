From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Fix deadlock on error handling
Date: Fri, 13 Jan 2017 09:30:11 +0100
Message-ID: <716c59b7-efe2-a218-136f-c0b8bc66bd92@redhat.com>
References: <1484237774-19047-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1484237774-19047-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Dmitry Vyukov <dvyukov@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 12/01/2017 17:16, Marc Zyngier wrote:
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
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

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
> 

From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 07/26] KVM: arm/arm64: vITS: Add a helper to update the
 affinity of an LPI
Date: Tue, 7 Nov 2017 14:44:28 +0100
Message-ID: <e2d14bc3-dd30-955a-1afd-afbff479c64f@redhat.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-8-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171027142855.21584-8-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Andre Przywara <Andre.Przywara@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Christoffer Dall <christoffer.dall@linaro.org>, Shanker Donthineni <shankerd@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 27/10/2017 16:28, Marc Zyngier wrote:
> In order help integrating the vITS code with GICv4, let's add
in order to
> a new helper that deals with updating the affinity of an LPI,
> which will later be augmented with super duper extra GICv4
> goodness.
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 475dffd0a44c..8ee03f1e89fc 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -335,6 +335,15 @@ static int vgic_copy_lpi_list(struct kvm_vcpu *vcpu, u32 **intid_ptr)
>  	return i;
>  }
>  
> +static int update_affinity(struct vgic_irq *irq, struct kvm_vcpu *vcpu)
> +{
> +	spin_lock(&irq->irq_lock);
> +	irq->target_vcpu = vcpu;
> +	spin_unlock(&irq->irq_lock);
> +
> +	return 0;
> +}
> +
>  /*
>   * Promotes the ITS view of affinity of an ITTE (which redistributor this LPI
>   * is targeting) to the VGIC's view, which deals with target VCPUs.
> @@ -349,10 +358,7 @@ static void update_affinity_ite(struct kvm *kvm, struct its_ite *ite)
>  		return;
>  
>  	vcpu = kvm_get_vcpu(kvm, ite->collection->target_addr);
> -
> -	spin_lock(&ite->irq->irq_lock);
> -	ite->irq->target_vcpu = vcpu;
> -	spin_unlock(&ite->irq->irq_lock);
> +	update_affinity(ite->irq, vcpu);
>  }
>  
>  /*
> @@ -693,11 +699,7 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
>  	ite->collection = collection;
>  	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
>  
> -	spin_lock(&ite->irq->irq_lock);
> -	ite->irq->target_vcpu = vcpu;
> -	spin_unlock(&ite->irq->irq_lock);
> -
> -	return 0;
> +	return update_affinity(ite->irq, vcpu);
>  }
>  
>  /*
> 

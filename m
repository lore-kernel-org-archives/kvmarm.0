From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 06/26] KVM: arm/arm64: vITS: Add a helper to update
 the affinity of an LPI
Date: Wed, 25 Oct 2017 16:50:09 +0200
Message-ID: <20171025145009.GI91785@lvm>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
 <20171006153401.5481-7-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05FCA49D28
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Oct 2017 10:48:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FKC+iNKNto6P for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Oct 2017 10:48:53 -0400 (EDT)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E10C240651
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Oct 2017 10:48:52 -0400 (EDT)
Received: by mail-wm0-f67.google.com with SMTP id u138so2397402wmu.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Oct 2017 07:50:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20171006153401.5481-7-marc.zyngier@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <Andre.Przywara@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 06, 2017 at 04:33:41PM +0100, Marc Zyngier wrote:
> In order help integrating the vITS code with GICv4, let's add
> a new helper that deals with updating the affinity of an LPI,
> which will later be augmented with super duper extra GICv4
> goodness.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

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
> -- 
> 2.14.1
> 

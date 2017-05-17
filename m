From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH] KVM: arm/arm64: Hold slots_lock when unregisering kvm io
 bus devices
Date: Wed, 17 May 2017 21:46:17 +0200
Message-ID: <24449cfb-5e7d-fd9a-7457-5296b9cf9716@redhat.com>
References: <20170517191806.3978-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170517191806.3978-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 17/05/2017 21:18, Christoffer Dall wrote:
> We were not holding the kvm->slots_lock as required when calling
> kvm_io_bus_unregister_dev() as required.
> 
> This only affects the error path, but still, let's do our due
> dilligence.
> 
> Reported by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
Besides the typo in the commit title

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index 9b0f681..201d5e2 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -614,15 +614,16 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
>  	mutex_lock(&kvm->slots_lock);
>  	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, sgi_base,
>  				      SZ_64K, &sgi_dev->dev);
> -	mutex_unlock(&kvm->slots_lock);
>  	if (ret) {
>  		kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
>  					  &rd_dev->dev);
> -		return ret;
> +		goto out;
>  	}
>  
>  	vgic->vgic_redist_free_offset += 2 * SZ_64K;
> -	return 0;
> +out:
> +	mutex_unlock(&kvm->slots_lock);
> +	return ret;
>  }
>  
>  static void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
> @@ -647,10 +648,12 @@ static int vgic_register_all_redist_iodevs(struct kvm *kvm)
>  
>  	if (ret) {
>  		/* The current c failed, so we start with the previous one. */
> +		mutex_lock(&kvm->slots_lock);
>  		for (c--; c >= 0; c--) {
>  			vcpu = kvm_get_vcpu(kvm, c);
>  			vgic_unregister_redist_iodev(vcpu);
>  		}
> +		mutex_unlock(&kvm->slots_lock);
>  	}
>  
>  	return ret;
> 

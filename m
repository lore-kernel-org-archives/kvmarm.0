From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 9/8] KVM: arm/arm64: Don't call map_resources when
 restoring ITS tables
Date: Mon, 8 May 2017 19:22:34 +0200
Message-ID: <7e35e7b8-dbca-4e1e-57f1-020aa5dbc228@redhat.com>
References: <20170508115454.5075-1-cdall@linaro.org>
 <20170508124932.28399-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170508124932.28399-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,
On 08/05/2017 14:49, Christoffer Dall wrote:
> The only reason we called kvm_vgic_map_resources() when restoring the
> ITS tables was because we wanted to have the KVM iodevs registered in
> the KVM IO bus framework at the time when the ITS was restored such that
> a restored and active device can inject MSIs prior to otherwise calling
> kvm_vgic_map_resources() from the first run of a VCPU.
> 
> Since we now register the KVM iodevs for the redestributors and ITS as
> soon as possible (when setting the base addresses), we no longer need
> this call and kvm_vgic_map_resources() is again called only when first
> running a VCPU.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
> Forgot to include this when posting the series, which was the whole
> point of the iodev rework in the first place.  Apologies about the
> confusing 9/8 subject thing.
> 
>  virt/kvm/arm/vgic/vgic-its.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 00f2990..9b67621 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -2316,20 +2316,12 @@ static int vgic_its_restore_tables_v0(struct vgic_its *its)
>  		goto out;
>  
>  	ret = vgic_its_restore_device_tables(its);
> -
>  out:
>  	unlock_all_vcpus(kvm);
>  	mutex_unlock(&its->its_lock);
>  	mutex_unlock(&kvm->lock);
>  
> -	if (ret)
> -		return ret;
> -
> -	/*
> -	 * On restore path, MSI injections can happen before the
> -	 * first VCPU run so let's complete the GIC init here.
> -	 */
> -	return kvm_vgic_map_resources(its->dev->kvm);
> +	return ret;
>  }
>  
>  static int vgic_its_commit_v0(struct vgic_its *its)
> 

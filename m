From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [RFC v7 2/7] KVM: kvm_host: add devid in
 kvm_kernel_irq_routing_entry
Date: Thu, 21 Jul 2016 18:13:29 +0200
Message-ID: <20160721161328.GC32739@potion>
References: <1468848357-2331-1-git-send-email-eric.auger@redhat.com>
 <1468848357-2331-3-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1468848357-2331-3-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

2016-07-18 13:25+0000, Eric Auger:
> Extend kvm_kernel_irq_routing_entry to transport the device id
> field, devid. A new flags field makes possible to indicate the
> devid is valid. Those additions are used for ARM GICv3 ITS MSI
> injection.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> ---
> v6 -> v7:
> - added msi_ prefix to flags and dev_id fields
> 
> v4 -> v5:
> - add Christoffer's R-b
> 
> v2 -> v3:
> - add flags
> 
> v1 -> v2:
> - replace msi_msg field by a struct composed of msi_msg and devid
> 
> RFC -> PATCH:
> - reword the commit message after change in first patch (uapi)
> ---
>  include/linux/kvm_host.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index c87fe6f..3d2cbb4 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -317,7 +317,11 @@ struct kvm_kernel_irq_routing_entry {
>  			unsigned irqchip;
>  			unsigned pin;
>  		} irqchip;
> -		struct msi_msg msi;
> +		struct {
> +			struct msi_msg msi;
> +			u32 msi_flags;
> +			u32 msi_devid;

I'd much rather see them as msi.flags and msi.devid.
I didn't notice a code that passes struct msi_msg anywhere, so using an
ad-hoc struct like irqchip or defining a new one would work fine.

Thanks.

> +		};
>  		struct kvm_s390_adapter_int adapter;
>  		struct kvm_hv_sint hv_sint;
>  	};
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

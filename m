From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [RFC v6 2/6] KVM: kvm_host: add devid in
 kvm_kernel_irq_routing_entry
Date: Mon, 11 Jul 2016 17:24:35 +0100
Message-ID: <ec4005fb-1864-5165-7bec-364d3585f271@arm.com>
References: <1467794875-5237-1-git-send-email-eric.auger@redhat.com>
 <1467794875-5237-3-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1467794875-5237-3-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 06/07/16 09:47, Eric Auger wrote:
> Extend kvm_kernel_irq_routing_entry to transport the device id
> field, devid. A new flags field makes possible to indicate the
> devid is valid. Those additions are used for ARM GICv3 ITS MSI
> injection.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> ---
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
> index c87fe6f..fffa299 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -317,7 +317,11 @@ struct kvm_kernel_irq_routing_entry {
>  			unsigned irqchip;
>  			unsigned pin;
>  		} irqchip;
> -		struct msi_msg msi;
> +		struct {
> +			struct msi_msg msi;
> +			u32 flags;
> +			u32 devid;

I wonder if we should rename those two members to have an "msi_" prefix.
Otherwise they turn into generic "route.flags" and "route.devid" (as
seen in the next patch), which is a bit misleading.

Cheers,
Andre.

> +		};
>  		struct kvm_s390_adapter_int adapter;
>  		struct kvm_hv_sint hv_sint;
>  	};
> 

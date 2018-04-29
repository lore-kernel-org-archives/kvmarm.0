From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v4 12/12] KVM: arm/arm64: Bump VGIC_V3_MAX_CPUS to 512
Date: Sun, 29 Apr 2018 14:35:45 +0200
Message-ID: <20180429123545.GF7512@C02W217FHV2R.local>
References: <1524838505-3823-1-git-send-email-eric.auger@redhat.com>
 <1524838505-3823-13-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1524838505-3823-13-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 27, 2018 at 04:15:05PM +0200, Eric Auger wrote:
> Let's raise the number of supported vcpus along with
> vgic v3 now that HW is looming with more physical CPUs.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Acked-by: Christoffer Dall <christoffer.dall@arm.com>

> ---
>  include/kvm/arm_vgic.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index e5c16d1..a9a9f4a 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -28,7 +28,7 @@
>  
>  #include <linux/irqchip/arm-gic-v4.h>
>  
> -#define VGIC_V3_MAX_CPUS	255
> +#define VGIC_V3_MAX_CPUS	512
>  #define VGIC_V2_MAX_CPUS	8
>  #define VGIC_NR_IRQS_LEGACY     256
>  #define VGIC_NR_SGIS		16
> -- 
> 2.5.5
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

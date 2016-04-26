From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 23/45] KVM: arm/arm64: vgic-new: Add GICv3 MMIO handling
 framework
Date: Tue, 26 Apr 2016 11:14:27 +0100
Message-ID: <571F3F83.3040503@arm.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
 <1460740316-8755-24-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1460740316-8755-24-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 15/04/16 18:11, Andre Przywara wrote:
> Describe the GICv3 distributor and redistributor registers in our
> structure. This adds a special macro to deal with the split of
> SGI/PPI in the redistributor and SPIs in the distributor, which
> allows us to reuse the existing GICv2 handlers for those registers
> which are compatible.
> Also we register the separate MMIO page for the redistributor
> registers dealing with private interrupts.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> 
> Changelog RFC..v1:
> - adapt to new MMIO registration approach:
>   register one device for the distributor and two for each VCPU
> - implement special handling for private interrupts
> - remove empty stub functions
> - make IGROUPR return RAO
> ---
>  virt/kvm/arm/vgic/vgic.h      |  16 +++
>  virt/kvm/arm/vgic/vgic_mmio.c | 269 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 285 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 59fddbf..ccae13e 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -40,6 +40,10 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
>  void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
>  void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
>  void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
> +int vgic_v3_dist_access(struct kvm_vcpu *vcpu, bool is_write,
> +			int offset, int len, void *val);
> +int vgic_v3_redist_access(struct kvm_vcpu *vcpu, bool is_write,
> +			  int offset, int len, void *val);
>  #else
>  static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
>  {
> @@ -61,6 +65,18 @@ static inline void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr)
>  static inline void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
>  {
>  }
> +
> +static inline int vgic_v3_dist_access(struct kvm_vcpu *vcpu, bool is_write,
> +				      int offset, int len, void *val)
> +{
> +	return -ENXIO;
> +}
> +
> +static inline int vgic_v3_redist_access(struct kvm_vcpu *vcpu, bool is_write,
> +					int offset, int len, void *val)
> +{
> +	return -ENXIO;
> +}
>  #endif
>  
>  #endif
> diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
> index daa2e00..4a31d60 100644
> --- a/virt/kvm/arm/vgic/vgic_mmio.c
> +++ b/virt/kvm/arm/vgic/vgic_mmio.c
> @@ -17,6 +17,8 @@
>  #include <kvm/vgic/vgic.h>
>  #include <linux/bitops.h>
>  #include <linux/irqchip/arm-gic.h>
> +#include <linux/irqchip/arm-gic-v3.h>

This is going to cause no end of trouble in the long run. There two
include files were never designed to co-exist, and it is only a matter
of chance if they do not clash.

I'm afraid we'll eventually need to split that file in vgic-mmio.c,
vgic-mmio-v2.c and vgic-mmio-v3.c.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

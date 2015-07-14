From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Introduce default dummy save/restore
 functions
Date: Tue, 14 Jul 2015 13:28:42 +0100
Message-ID: <55A5007A.4040802@arm.com>
References: <cover.1436874248.git.p.fedin@samsung.com> <248fcfc798e243b618c5275eef8aa333253fd4da.1436874248.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <248fcfc798e243b618c5275eef8aa333253fd4da.1436874248.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 14/07/15 13:06, Pavel Fedin wrote:
> Necessary for KVM without irqchip to function on ARM64. Allows to use
> software GICv2 emulation where hardware acceleration is not available.
> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> ---
>  arch/arm/include/asm/kvm_host.h   | 5 +++++
>  arch/arm64/include/asm/kvm_asm.h  | 1 +
>  arch/arm64/include/asm/kvm_host.h | 8 ++++++++
>  arch/arm64/kvm/vgic-v2-switch.S   | 5 +++++
>  virt/kvm/arm/vgic.c               | 2 ++
>  5 files changed, 21 insertions(+)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index d71607c..c469c95 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -218,6 +218,11 @@ static inline int kvm_arch_dev_ioctl_check_extension(long ext)
>  	return 0;
>  }
>  
> +static inline void vgic_arch_pre_setup(void)
> +{
> +
> +}
> +
>  static inline void vgic_arch_setup(const struct vgic_params *vgic)
>  {
>  	BUG_ON(vgic->type != VGIC_V2);
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 4f7310f..933a442 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -132,6 +132,7 @@ extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
>  
>  extern u64 __vgic_v3_get_ich_vtr_el2(void);
>  
> +extern char __dummy_vgic_save_restore[];
>  extern char __save_vgic_v2_state[];
>  extern char __restore_vgic_v2_state[];
>  extern char __save_vgic_v3_state[];
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f0f58c9..b322895 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -221,6 +221,14 @@ struct vgic_sr_vectors {
>  	void	*restore_vgic;
>  };
>  
> +static inline void vgic_arch_pre_setup(void)
> +{
> +	extern struct vgic_sr_vectors __vgic_sr_vectors;
> +
> +	__vgic_sr_vectors.save_vgic	= __dummy_vgic_save_restore;
> +	__vgic_sr_vectors.restore_vgic	= __dummy_vgic_save_restore;
> +}
> +

You may want to check commit 8a14849, which makes this whole patch
irrelevant.

Also, we do check whether or not the GIC is enabled for a given VM, and
not touching the registers if they are not. What is wrong with that?

	M.
-- 
Jazz is not dead. It just smells funny...

From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH] KVM: arm/arm64: remove kvm_vgic_*early_init() functions
Date: Tue, 5 Jul 2016 16:02:21 +0200
Message-ID: <805f32fa-8080-a4d6-788a-b6085a70a5fb@redhat.com>
References: <20160705135043.13780-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160705135043.13780-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On 05/07/2016 15:50, Andre Przywara wrote:
> kvm_vgic_early_init() and kvm_vgic_vcpu_early_init() were only used
> with the old VGIC, on the new VGIC these functions do nothing.
> Follow the comment in vgic-init.c and remove those functions and
> their calls.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arch/arm/kvm/arm.c            |  2 --
>  include/kvm/arm_vgic.h        |  2 --
>  virt/kvm/arm/vgic/vgic-init.c | 30 +-----------------------------
>  3 files changed, 1 insertion(+), 33 deletions(-)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index c74483f..6aa0acd 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -126,7 +126,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	if (ret)
>  		goto out_free_stage2_pgd;
>  
> -	kvm_vgic_early_init(kvm);
>  	kvm_timer_init(kvm);
>  
>  	/* Mark the initial VMID generation invalid */
> @@ -254,7 +253,6 @@ out:
>  
>  void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>  {
> -	kvm_vgic_vcpu_early_init(vcpu);
>  }
>  
>  void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 1264037..2c641cc 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -196,10 +196,8 @@ struct vgic_cpu {
>  };
>  
>  int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
> -void kvm_vgic_early_init(struct kvm *kvm);
>  int kvm_vgic_create(struct kvm *kvm, u32 type);
>  void kvm_vgic_destroy(struct kvm *kvm);
> -void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu);
>  void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu);
>  int kvm_vgic_map_resources(struct kvm *kvm);
>  int kvm_vgic_hyp_init(void);
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index a1442f7..c94dc55 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -23,40 +23,12 @@
>  #include "vgic.h"
>  
>  /*
> - * Initialization rules: there are multiple stages to the vgic
> - * initialization, both for the distributor and the CPU interfaces.
> - *
> - * Distributor:
> - *
> - * - kvm_vgic_early_init(): initialization of static data that doesn't
> - *   depend on any sizing information or emulation type. No allocation
> - *   is allowed there.
> - *
> + * Initialization rules for the distributor:
>   * - vgic_init(): allocation and initialization of the generic data
>   *   structures that depend on sizing information (number of CPUs,
>   *   number of interrupts). Also initializes the vcpu specific data
>   *   structures. Can be executed lazily for GICv2.
> - *
> - * CPU Interface:
> - *
> - * - kvm_vgic_cpu_early_init(): initialization of static data that
> - *   doesn't depend on any sizing information or emulation type. No
> - *   allocation is allowed there.
> - */
> -
> -/* EARLY INIT */
> -
> -/*
> - * Those 2 functions should not be needed anymore but they
> - * still are called from arm.c
>   */
> -void kvm_vgic_early_init(struct kvm *kvm)
> -{
> -}
> -
> -void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu)
> -{
> -}
>  
>  /* CREATION */
>  
> 
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

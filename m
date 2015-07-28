From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: KVM: remove remaining reference to vgic_sr_vectors
Date: Tue, 28 Jul 2015 10:52:22 +0100
Message-ID: <55B750D6.30909@arm.com>
References: <1438076543-6768-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B647259700
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2015 05:40:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hwmCRYH8a2zF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jul 2015 05:39:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2F72595FA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2015 05:39:59 -0400 (EDT)
In-Reply-To: <1438076543-6768-1-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <Vladimir.Murzin@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 28/07/15 10:42, Vladimir Murzin wrote:
> Since commit 8a14849 (arm64: KVM: Switch vgic save/restore to
> alternative_insn) vgic_sr_vectors is not used anymore, so remove
> remaining leftovers and kill the structure.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>

Thanks Vladimir, I'll queue that up in -next.

Thanks,

	M.

> ---
>  arch/arm64/include/asm/kvm_host.h |    5 -----
>  arch/arm64/kernel/asm-offsets.c   |    2 --
>  2 files changed, 7 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 2709db2..19f1182 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -216,11 +216,6 @@ static inline void __cpu_init_hyp_mode(phys_addr_t boot_pgd_ptr,
>  		     hyp_stack_ptr, vector_ptr);
>  }
>  
> -struct vgic_sr_vectors {
> -	void	*save_vgic;
> -	void	*restore_vgic;
> -};
> -
>  static inline void kvm_arch_hardware_disable(void) {}
>  static inline void kvm_arch_hardware_unsetup(void) {}
>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> index c99701a..f0c960d 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -125,8 +125,6 @@ int main(void)
>    DEFINE(KVM_TIMER_ENABLED,	offsetof(struct kvm, arch.timer.enabled));
>    DEFINE(VCPU_KVM,		offsetof(struct kvm_vcpu, kvm));
>    DEFINE(VCPU_VGIC_CPU,		offsetof(struct kvm_vcpu, arch.vgic_cpu));
> -  DEFINE(VGIC_SAVE_FN,		offsetof(struct vgic_sr_vectors, save_vgic));
> -  DEFINE(VGIC_RESTORE_FN,	offsetof(struct vgic_sr_vectors, restore_vgic));
>    DEFINE(VGIC_V2_CPU_HCR,	offsetof(struct vgic_cpu, vgic_v2.vgic_hcr));
>    DEFINE(VGIC_V2_CPU_VMCR,	offsetof(struct vgic_cpu, vgic_v2.vgic_vmcr));
>    DEFINE(VGIC_V2_CPU_MISR,	offsetof(struct vgic_cpu, vgic_v2.vgic_misr));
> 


-- 
Jazz is not dead. It just smells funny...

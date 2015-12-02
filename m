From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] KVM: arm/arm64: Count guest exit due to various reasons
Date: Wed, 2 Dec 2015 19:12:28 +0100
Message-ID: <20151202181228.GS18376@cbox>
References: <1448532583-18715-1-git-send-email-amittomer25@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B63B3412A6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 13:10:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WynF7Um6OcUI for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2015 13:10:26 -0500 (EST)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8434240F90
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 13:10:26 -0500 (EST)
Received: by wmvv187 with SMTP id v187so267899332wmv.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2015 10:11:54 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1448532583-18715-1-git-send-email-amittomer25@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Amit Singh Tomar <amittomer25@gmail.com>
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 26, 2015 at 10:09:43AM +0000, Amit Singh Tomar wrote:
> From: Amit Tomar <amittomer25@gmail.com>
> 
> It would add guest exit statistics to debugfs, This can be helpful
> while measuring KVM performance.
> 
> Signed-off-by: Amit Singh Tomar <amittomer25@gmail.com>
> ---
> Changes since v1:
>         * Defined equal number of stats for ARM and ARM64
>         * Differentiated MMIO_EXIT handled between Userspace and Kernel
>         * Distinguished between wfi and wfe stat counters
> ---
>  arch/arm/include/asm/kvm_host.h   | 6 ++++++
>  arch/arm/kvm/arm.c                | 1 +
>  arch/arm/kvm/guest.c              | 6 ++++++
>  arch/arm/kvm/handle_exit.c        | 3 +++
>  arch/arm/kvm/mmio.c               | 3 +++
>  arch/arm64/include/asm/kvm_host.h | 6 ++++++
>  arch/arm64/kvm/guest.c            | 9 +++++++++
>  arch/arm64/kvm/handle_exit.c      | 3 +++
>  8 files changed, 37 insertions(+)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 6692982..872640e 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -150,6 +150,12 @@ struct kvm_vcpu_stat {
>  	u32 halt_successful_poll;
>  	u32 halt_attempted_poll;
>  	u32 halt_wakeup;
> +	u32 hvc_exit_stat;
> +	u64 wfe_exit_stat;
> +	u64 wfi_exit_stat;
> +	u64 mmio_exit_handled_in_userspace_stat;
> +	u64 mmio_exit_handled_in_kernel_stat;

eh, I think these should just be called mmio_exit_user and
mmio_exit_kernel

> +	u64 exits;
>  };
>  
>  int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index e06fd29..8a79a57 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -603,6 +603,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
>  
>  		vcpu->mode = OUTSIDE_GUEST_MODE;
> +		vcpu->stat.exits++;
>  		/*
>  		 * Back from guest
>  		 *************************************************************/
> diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
> index 96e935b..8323241 100644
> --- a/arch/arm/kvm/guest.c
> +++ b/arch/arm/kvm/guest.c
> @@ -33,6 +33,12 @@
>  #define VCPU_STAT(x) { #x, offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU }
>  
>  struct kvm_stats_debugfs_item debugfs_entries[] = {
> +	VCPU_STAT(hvc_exit_stat),
> +	VCPU_STAT(wfe_exit_stat),
> +	VCPU_STAT(wfi_exit_stat),
> +	VCPU_STAT(mmio_exit_handled_in_userspace_stat),
> +	VCPU_STAT(mmio_exit_handled_in_kernel_stat),
> +	VCPU_STAT(exits),
>  	{ NULL }
>  };
>  
> diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
> index 95f12b2..3ede90d 100644
> --- a/arch/arm/kvm/handle_exit.c
> +++ b/arch/arm/kvm/handle_exit.c
> @@ -42,6 +42,7 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  	trace_kvm_hvc(*vcpu_pc(vcpu), *vcpu_reg(vcpu, 0),
>  		      kvm_vcpu_hvc_get_imm(vcpu));
> +	vcpu->stat.hvc_exit_stat++;
>  
>  	ret = kvm_psci_call(vcpu);
>  	if (ret < 0) {
> @@ -89,9 +90,11 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
>  	if (kvm_vcpu_get_hsr(vcpu) & HSR_WFI_IS_WFE) {
>  		trace_kvm_wfx(*vcpu_pc(vcpu), true);
> +		vcpu->stat.wfe_exit_stat++;
>  		kvm_vcpu_on_spin(vcpu);
>  	} else {
>  		trace_kvm_wfx(*vcpu_pc(vcpu), false);
> +		vcpu->stat.wfi_exit_stat++;
>  		kvm_vcpu_block(vcpu);
>  	}
>  
> diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
> index 974b1c6..b66c3a3 100644
> --- a/arch/arm/kvm/mmio.c
> +++ b/arch/arm/kvm/mmio.c
> @@ -209,8 +209,11 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  
>  	if (!ret) {
>  		/* We handled the access successfully in the kernel. */
> +		vcpu->stat.mmio_exit_handled_in_kernel_stat++;
>  		kvm_handle_mmio_return(vcpu, run);
>  		return 1;
> +	} else {
> +		vcpu->stat.mmio_exit_handled_in_userspace_stat++;
>  	}
>  
>  	run->exit_reason	= KVM_EXIT_MMIO;
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index a35ce72..ad29508 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -197,6 +197,12 @@ struct kvm_vcpu_stat {
>  	u32 halt_successful_poll;
>  	u32 halt_attempted_poll;
>  	u32 halt_wakeup;
> +	u32 hvc_exit_stat;
> +	u64 wfe_exit_stat;
> +	u64 wfi_exit_stat;
> +	u64 mmio_exit_handled_in_userspace_stat;
> +	u64 mmio_exit_handled_in_kernel_stat;

same problem with naming

> +	u64 exits;
>  };
>  
>  int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index d250160..ad9ea95 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -34,7 +34,16 @@
>  
>  #include "trace.h"
>  
> +#define VM_STAT(x) { #x, offsetof(struct kvm, stat.x), KVM_STAT_VM }
> +#define VCPU_STAT(x) { #x, offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU }
> +
>  struct kvm_stats_debugfs_item debugfs_entries[] = {
> +	VCPU_STAT(hvc_exit_stat),
> +	VCPU_STAT(wfe_exit_stat),
> +	VCPU_STAT(wfi_exit_stat),
> +	VCPU_STAT(mmio_exit_handled_in_userspace_stat),
> +	VCPU_STAT(mmio_exit_handled_in_kernel_stat),
> +	VCPU_STAT(exits),
>  	{ NULL }
>  };
>  
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 68a0759..2894649 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -39,6 +39,7 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  	trace_kvm_hvc_arm64(*vcpu_pc(vcpu), *vcpu_reg(vcpu, 0),
>  			    kvm_vcpu_hvc_get_imm(vcpu));
> +	vcpu->stat.hvc_exit_stat++;
>  
>  	ret = kvm_psci_call(vcpu);
>  	if (ret < 0) {
> @@ -71,9 +72,11 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
>  	if (kvm_vcpu_get_hsr(vcpu) & ESR_ELx_WFx_ISS_WFE) {
>  		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
> +		vcpu->stat.wfe_exit_stat++;
>  		kvm_vcpu_on_spin(vcpu);
>  	} else {
>  		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
> +		vcpu->stat.wfi_exit_stat++;
>  		kvm_vcpu_block(vcpu);
>  	}
>  
> -- 
> 2.1.4
> 

I've applied this patch to queue with the naming changed.

Thanks,
-Christoffer

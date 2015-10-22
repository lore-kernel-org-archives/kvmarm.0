From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm64: Count guest exit due to various reasons
Date: Thu, 22 Oct 2015 23:16:01 +0200
Message-ID: <20151022211601.GA25602@cbox>
References: <1445155482-12482-1-git-send-email-amittomer25@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 750DD40F90
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 17:12:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6GC0erGU4ylo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Oct 2015 17:12:49 -0400 (EDT)
Received: from mail-lf0-f53.google.com (mail-lf0-f53.google.com
 [209.85.215.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 41B384053F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 17:12:48 -0400 (EDT)
Received: by lfbn126 with SMTP id n126so28585028lfb.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 14:15:26 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1445155482-12482-1-git-send-email-amittomer25@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Amit <amittomer25@gmail.com>
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Oct 18, 2015 at 01:34:42PM +0530, Amit wrote:
> From: Amit Singh Tomar <amittomer25@gmail.com>
> 
> This patch adds guest exit statistics to debugfs, This can be helpful
> while measuring KVM performance.
> 
> Signed-off-by: Amit Singh Tomar <amittomer25@gmail.com>
> ---
>  arch/arm/include/asm/kvm_host.h   | 2 ++
>  arch/arm/kvm/arm.c                | 1 +
>  arch/arm/kvm/guest.c              | 2 ++
>  arch/arm/kvm/mmio.c               | 1 +
>  arch/arm64/include/asm/kvm_host.h | 5 +++++
>  arch/arm64/kvm/guest.c            | 8 ++++++++
>  arch/arm64/kvm/handle_exit.c      | 3 +++
>  7 files changed, 22 insertions(+)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index c4072d9..d1f3159 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -147,6 +147,8 @@ struct kvm_vcpu_stat {
>  	u32 halt_successful_poll;
>  	u32 halt_attempted_poll;
>  	u32 halt_wakeup;
> +	u32 mmio_exit_stat;

I think it would be even more useful to distinguish between mmio exits
handled in the kernel vs. those going to userspace.

> +	u32 exits;
>  };
>  
>  int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 78b2869..5d0a2c5 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -569,6 +569,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
>  
>  		vcpu->mode = OUTSIDE_GUEST_MODE;
> +		vcpu->stat.exits++;
>  		/*
>  		 * Back from guest
>  		 *************************************************************/
> diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
> index 96e935b..0eea5fc 100644
> --- a/arch/arm/kvm/guest.c
> +++ b/arch/arm/kvm/guest.c
> @@ -33,6 +33,8 @@
>  #define VCPU_STAT(x) { #x, offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU }
>  
>  struct kvm_stats_debugfs_item debugfs_entries[] = {
> +	VCPU_STAT(mmio_exit_stat),
> +	VCPU_STAT(exits),
>  	{ NULL }
>  };
>  
> diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
> index 974b1c6..51d518e 100644
> --- a/arch/arm/kvm/mmio.c
> +++ b/arch/arm/kvm/mmio.c
> @@ -184,6 +184,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  	}
>  
>  	rt = vcpu->arch.mmio_decode.rt;
> +	vcpu->stat.mmio_exit_stat++;
>  
>  	if (is_write) {
>  		data = vcpu_data_guest_to_host(vcpu, *vcpu_reg(vcpu, rt), len);
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index ed03968..b32c938 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -194,6 +194,11 @@ struct kvm_vcpu_stat {
>  	u32 halt_successful_poll;
>  	u32 halt_attempted_poll;
>  	u32 halt_wakeup;
> +	u32 hvc_exit_stat;
> +	u32 wfx_exit_stat;
> +	u32 wfi_exit_stat;
> +	u32 mmio_exit_stat;
> +	u32 exits;

why more exit stats on arm64 than on arm?

why u32?  Would it not make sense to make these u64 or just unsigned
long?

>  };
>  
>  int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index d250160..b1943cd 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -34,7 +34,15 @@
>  
>  #include "trace.h"
>  
> +#define VM_STAT(x) { #x, offsetof(struct kvm, stat.x), KVM_STAT_VM }
> +#define VCPU_STAT(x) { #x, offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU }
> +
>  struct kvm_stats_debugfs_item debugfs_entries[] = {
> +	VCPU_STAT(hvc_exit_stat),
> +	VCPU_STAT(wfx_exit_stat),
> +	VCPU_STAT(wfi_exit_stat),
> +	VCPU_STAT(mmio_exit_stat),
> +	VCPU_STAT(exits),
>  	{ NULL }
>  };
>  
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 68a0759..6e38c50 100644
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
> +		vcpu->stat.wfx_exit_stat++;

either you should use one called wfx_exit_stat or you should distinguish
between wfi and wfe; this is just a weird way of doing it.

>  		kvm_vcpu_on_spin(vcpu);
>  	} else {
>  		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
> +		vcpu->stat.wfi_exit_stat++;
>  		kvm_vcpu_block(vcpu);
>  	}
>  
> -- 
> 1.9.1
> 

Thanks,
-Christoffer

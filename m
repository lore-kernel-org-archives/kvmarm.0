From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH 3/4] arm64/sve: KVM: Ensure user SVE use traps after
 vcpu execution
Date: Wed, 22 Nov 2017 20:23:44 +0100
Message-ID: <20171122192344.GS28855@cbox>
References: <1510936735-6762-1-git-send-email-Dave.Martin@arm.com>
 <1510936735-6762-4-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 600E9406BB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Nov 2017 14:20:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y7rDEKNrYFL5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Nov 2017 14:20:58 -0500 (EST)
Received: from mail-wr0-f194.google.com (mail-wr0-f194.google.com
 [209.85.128.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F2D149D7F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Nov 2017 14:20:58 -0500 (EST)
Received: by mail-wr0-f194.google.com with SMTP id w95so15573530wrc.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Nov 2017 11:23:34 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1510936735-6762-4-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 17, 2017 at 04:38:54PM +0000, Dave Martin wrote:
> Currently, SVE use can remain untrapped if a KVM vcpu thread is
> preempted inside the kernel and we then switch back to some user
> thread.
> 
> This patch ensures that SVE traps for userspace are enabled before
> switching away from the vcpu thread.

I don't really understand why KVM is any different then any other thread
which could be using SVE that gets preempted?

> 
> In an attempt to preserve some clarity about why and when this is
> needed, kvm_fpsimd_flush_cpu_state() is used as a hook for doing
> this.  This means that this function needs to be called after
> exiting the vcpu instead of before entry: 

I don't understand why the former means the latter?

> this patch moves the call
> as appropriate.  As a side-effect, this will avoid the call if vcpu
> entry is shortcircuited by a signal etc.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  arch/arm64/kernel/fpsimd.c | 2 ++
>  virt/kvm/arm/arm.c         | 6 +++---
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 3dc8058..3b135eb 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -1083,6 +1083,8 @@ void sve_flush_cpu_state(void)
>  
>  	if (last->st && last->sve_in_use)
>  		fpsimd_flush_cpu_state();
> +
> +	sve_user_disable();
>  }
>  #endif /* CONFIG_ARM64_SVE */
>  
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 772bf74..554b157 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -651,9 +651,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		 */
>  		preempt_disable();
>  
> -		/* Flush FP/SIMD state that can't survive guest entry/exit */
> -		kvm_fpsimd_flush_cpu_state();
> -
>  		kvm_pmu_flush_hwstate(vcpu);
>  
>  		local_irq_disable();
> @@ -754,6 +751,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		guest_exit();
>  		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
>  
> +		/* Flush FP/SIMD state that can't survive guest entry/exit */
> +		kvm_fpsimd_flush_cpu_state();
> +

Could this be done in kvm_arch_vcpu_put() instead?

>  		preempt_enable();
>  
>  		ret = handle_exit(vcpu, run, ret);
> -- 
> 2.1.4
> 

Thanks,
-Christoffer

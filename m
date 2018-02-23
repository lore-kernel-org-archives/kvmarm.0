From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 0.9/2] arm64: fpsimd: Expose CPU / FPSIMD state
 association helpers
Date: Fri, 23 Feb 2018 18:02:53 +0100
Message-ID: <20180223170253.GA7396@cbox>
References: <1518805771-15346-1-git-send-email-Dave.Martin@arm.com>
 <1518806370-15697-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 094024031C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Feb 2018 11:56:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bm9QlEjwwurW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Feb 2018 11:56:14 -0500 (EST)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E35D402E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Feb 2018 11:56:14 -0500 (EST)
Received: by mail-wm0-f67.google.com with SMTP id z81so5886809wmb.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Feb 2018 09:02:57 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1518806370-15697-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 16, 2018 at 06:39:30PM +0000, Dave Martin wrote:
> Oops, forgot to post this patch that goes before patch 1 in the series.
> 
> --8<--
> 
> Expose an interface for associating an FPSIMD context with a CPU and
> checking the association, for use by KVM.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  arch/arm64/include/asm/fpsimd.h |  5 +++++
>  arch/arm64/kernel/fpsimd.c      | 42 +++++++++++++++++++++++++++++------------
>  2 files changed, 35 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> index 8857a0f..f4ce4d6 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -23,6 +23,7 @@
>  
>  #include <linux/cache.h>
>  #include <linux/stddef.h>
> +#include <linux/types.h>
>  
>  /*
>   * FP/SIMD storage area has:
> @@ -62,6 +63,8 @@ struct fpsimd_state {
>  
>  struct task_struct;
>  
> +extern bool fpsimd_foreign_fpstate(struct fpsimd_state const *state);
> +
>  extern void fpsimd_save_state(struct fpsimd_state *state);
>  extern void fpsimd_load_state(struct fpsimd_state *state);
>  
> @@ -76,6 +79,8 @@ extern void fpsimd_update_current_state(struct user_fpsimd_state const *state);
>  extern void fpsimd_flush_task_state(struct task_struct *target);
>  extern void sve_flush_cpu_state(void);
>  
> +extern void fpsimd_bind_state_to_cpu(struct fpsimd_state *state);
> +
>  /* Maximum VL that SVE VL-agnostic software can transparently support */
>  #define SVE_VL_ARCH_MAX 0x100
>  
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index e7226c4..138efaf 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -38,6 +38,7 @@
>  #include <linux/signal.h>
>  #include <linux/slab.h>
>  #include <linux/sysctl.h>
> +#include <linux/types.h>
>  
>  #include <asm/fpsimd.h>
>  #include <asm/cputype.h>
> @@ -121,6 +122,14 @@ struct fpsimd_last_state_struct {
>  
>  static DEFINE_PER_CPU(struct fpsimd_last_state_struct, fpsimd_last_state);
>  
> +bool fpsimd_foreign_fpstate(struct fpsimd_state const *st)
> +{
> +	WARN_ON(!in_softirq() && !irqs_disabled());
> +
> +	return st->cpu != smp_processor_id() ||
> +		st != __this_cpu_read(fpsimd_last_state.st);
> +}
> +
>  /* Default VL for tasks that don't set it explicitly: */
>  static int sve_default_vl = -1;
>  
> @@ -908,13 +917,10 @@ void fpsimd_thread_switch(struct task_struct *next)
>  		 * the TIF_FOREIGN_FPSTATE flag so the state will be loaded
>  		 * upon the next return to userland.
>  		 */
> -		struct fpsimd_state *st = &next->thread.fpsimd_state;
> -
> -		if (__this_cpu_read(fpsimd_last_state.st) == st
> -		    && st->cpu == smp_processor_id())
> -			clear_tsk_thread_flag(next, TIF_FOREIGN_FPSTATE);
> -		else
> +		if (fpsimd_foreign_fpstate(&current->thread.fpsimd_state))
>  			set_tsk_thread_flag(next, TIF_FOREIGN_FPSTATE);
> +		else
> +			clear_tsk_thread_flag(next, TIF_FOREIGN_FPSTATE);
>  	}
>  }
>  
> @@ -996,19 +1002,31 @@ void fpsimd_signal_preserve_current_state(void)
>  		sve_to_fpsimd(current);
>  }
>  
> +static void __fpsimd_bind_to_cpu(struct fpsimd_last_state_struct *last,
> +				 struct fpsimd_state *st)
> +{
> +	WARN_ON(!in_softirq() || !irqs_disabled());

You meant && here, right?

Currently this makes my box explode.

Thanks,
-Christoffer

> +
> +	last->st = st;
> +	st->cpu = smp_processor_id();
> +}
> +
> +void fpsimd_bind_state_to_cpu(struct fpsimd_state *st)
> +{
> +	__fpsimd_bind_to_cpu(this_cpu_ptr(&fpsimd_last_state), st);
> +}
> +
>  /*
>   * Associate current's FPSIMD context with this cpu
>   * Preemption must be disabled when calling this function.
>   */
> -static void fpsimd_bind_to_cpu(void)
> +static void fpsimd_bind_task_to_cpu(void)
>  {
>  	struct fpsimd_last_state_struct *last =
>  		this_cpu_ptr(&fpsimd_last_state);
> -	struct fpsimd_state *st = &current->thread.fpsimd_state;
>  
> -	last->st = st;
> +	__fpsimd_bind_to_cpu(last, &current->thread.fpsimd_state);
>  	last->sve_in_use = test_thread_flag(TIF_SVE);
> -	st->cpu = smp_processor_id();
>  }
>  
>  /*
> @@ -1025,7 +1043,7 @@ void fpsimd_restore_current_state(void)
>  
>  	if (test_and_clear_thread_flag(TIF_FOREIGN_FPSTATE)) {
>  		task_fpsimd_load();
> -		fpsimd_bind_to_cpu();
> +		fpsimd_bind_task_to_cpu();
>  	}
>  
>  	local_bh_enable();
> @@ -1050,7 +1068,7 @@ void fpsimd_update_current_state(struct user_fpsimd_state const *state)
>  	task_fpsimd_load();
>  
>  	if (test_and_clear_thread_flag(TIF_FOREIGN_FPSTATE))
> -		fpsimd_bind_to_cpu();
> +		fpsimd_bind_task_to_cpu();
>  
>  	local_bh_enable();
>  }
> -- 
> 2.1.4
> 

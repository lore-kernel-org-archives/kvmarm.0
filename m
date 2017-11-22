From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH 2/4] arm64/sve: KVM: Avoid dereference of dead task
 during guest entry
Date: Wed, 22 Nov 2017 20:23:38 +0100
Message-ID: <20171122192338.GR28855@cbox>
References: <1510936735-6762-1-git-send-email-Dave.Martin@arm.com>
 <1510936735-6762-3-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1E4640D8B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Nov 2017 14:20:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9BUTa-AFQJtL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Nov 2017 14:20:52 -0500 (EST)
Received: from mail-wr0-f194.google.com (mail-wr0-f194.google.com
 [209.85.128.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B58DC406BB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Nov 2017 14:20:52 -0500 (EST)
Received: by mail-wr0-f194.google.com with SMTP id z75so14179214wrc.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Nov 2017 11:23:28 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1510936735-6762-3-git-send-email-Dave.Martin@arm.com>
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

Hi Dave,

On Fri, Nov 17, 2017 at 04:38:53PM +0000, Dave Martin wrote:
> When deciding whether to invalidate FPSIMD state cached in the cpu,
> the backend function sve_flush_cpu_state() attempts to dereference
> __this_cpu_read(fpsimd_last_state).  However, this is not safe:
> there is no guarantee that the pointer is still valid, because the
> task could have exited in the meantime.  For this reason, this
> percpu pointer should only be assigned or compared, never
> dereferenced.
> 
> This means that we need another means to get the appropriate value
> of TIF_SVE for the associated task.
> 
> This patch solves this issue by adding a cached copy of the TIF_SVE
> flag in fpsimd_last_state, which we can check without dereferencing
> the task pointer.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  arch/arm64/kernel/fpsimd.c | 28 ++++++++++++++++------------
>  1 file changed, 16 insertions(+), 12 deletions(-
> 
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 007140b..3dc8058 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -114,7 +114,12 @@
>   *   returned from the 2nd syscall yet, TIF_FOREIGN_FPSTATE is still set so
>   *   whatever is in the FPSIMD registers is not saved to memory, but discarded.
>   */
> -static DEFINE_PER_CPU(struct fpsimd_state *, fpsimd_last_state);
> +struct fpsimd_last_state_struct {
> +	struct fpsimd_state *st;
> +	bool sve_in_use;
> +};
> +
> +static DEFINE_PER_CPU(struct fpsimd_last_state_struct, fpsimd_last_state);
>  
>  /* Default VL for tasks that don't set it explicitly: */
>  static int sve_default_vl = -1;
> @@ -905,7 +910,7 @@ void fpsimd_thread_switch(struct task_struct *next)
>  		 */
>  		struct fpsimd_state *st = &next->thread.fpsimd_state;
>  
> -		if (__this_cpu_read(fpsimd_last_state) == st
> +		if (__this_cpu_read(fpsimd_last_state.st) == st
>  		    && st->cpu == smp_processor_id())
>  			clear_tsk_thread_flag(next, TIF_FOREIGN_FPSTATE);
>  		else
> @@ -997,9 +1002,12 @@ void fpsimd_signal_preserve_current_state(void)
>   */
>  static void fpsimd_bind_to_cpu(void)
>  {
> +	struct fpsimd_last_state_struct *last =
> +		this_cpu_ptr(&fpsimd_last_state);
>  	struct fpsimd_state *st = &current->thread.fpsimd_state;
>  
> -	__this_cpu_write(fpsimd_last_state, st);
> +	last->st = st;
> +	last->sve_in_use = test_thread_flag(TIF_SVE);
>  	st->cpu = smp_processor_id();
>  }
>  
> @@ -1057,7 +1065,7 @@ void fpsimd_flush_task_state(struct task_struct *t)
>  
>  static inline void fpsimd_flush_cpu_state(void)
>  {
> -	__this_cpu_write(fpsimd_last_state, NULL);
> +	__this_cpu_write(fpsimd_last_state.st, NULL);
>  }
>  
>  /*
> @@ -1070,14 +1078,10 @@ static inline void fpsimd_flush_cpu_state(void)
>  #ifdef CONFIG_ARM64_SVE
>  void sve_flush_cpu_state(void)
>  {
> -	struct fpsimd_state *const fpstate = __this_cpu_read(fpsimd_last_state);
> -	struct task_struct *tsk;
> -
> -	if (!fpstate)
> -		return;
> +	struct fpsimd_last_state_struct const *last =
> +		this_cpu_ptr(&fpsimd_last_state);
>  
> -	tsk = container_of(fpstate, struct task_struct, thread.fpsimd_state);
> -	if (test_tsk_thread_flag(tsk, TIF_SVE))
> +	if (last->st && last->sve_in_use)
>  		fpsimd_flush_cpu_state();

I'm confused though; why can't we simply flush the state
unconditionally?  What is the harm of setting the pointer to NULL if the
task whose state may be pointed to didn't actually use SVE?

>  }
>  #endif /* CONFIG_ARM64_SVE */
> @@ -1272,7 +1276,7 @@ static inline void fpsimd_pm_init(void) { }
>  #ifdef CONFIG_HOTPLUG_CPU
>  static int fpsimd_cpu_dead(unsigned int cpu)
>  {
> -	per_cpu(fpsimd_last_state, cpu) = NULL;
> +	per_cpu(fpsimd_last_state.st, cpu) = NULL;
>  	return 0;
>  }
>  
> -- 
> 2.1.4
> 

Thanks,
-Christoffer

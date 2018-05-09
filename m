From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v7 06/16] arm64/sve: Refactor user SVE trap maintenance
 for external use
Date: Wed, 9 May 2018 17:36:30 +0100
Message-ID: <dad74a47-26f4-d38f-a9c4-e60fc9d1a07a@arm.com>
References: <1525882385-29181-1-git-send-email-Dave.Martin@arm.com>
 <1525882385-29181-7-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1525882385-29181-7-git-send-email-Dave.Martin@arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@kernel.org>, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 09/05/18 17:12, Dave Martin wrote:
> In preparation for optimising the way KVM manages switching the
> guest and host FPSIMD state, it is necessary to provide a means for
> code outside arch/arm64/kernel/fpsimd.c to restore the user trap
> configuration for SVE correctly for the current task.
> 
> Rather than requiring external code to duplicate the maintenance
> explicitly, this patch wraps moves the trap maintenenace to
> fpsimd_bind_to_cpu(), since it is logically part of the work of
> associating the current task with the cpu.
> 
> Because fpsimd_bind_to_cpu() is rather a cryptic name to publish
> alongside fpsimd_bind_state_to_cpu(), the former function is
> renamed to fpsimd_bind_task_to_cpu() to make its purpose more
> explicit.
> 
> This patch makes appropriate changes to ensure that
> fpsimd_bind_task_to_cpu() is always called alongside
> task_fpsimd_load(), so that the trap maintenance continues to be
> done in every situation where it was done prior to this patch.
> 
> As a side-effect, the metadata updates done by
> fpsimd_bind_task_to_cpu() now change from conditional to
> unconditional in the "already bound" case of sigreturn.  This is
> harmless, and a couple of extra stores on this slow path will not
> impact performance.  I consider this a reasonable price to pay for
> a slightly cleaner interface.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  arch/arm64/kernel/fpsimd.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 5fc0595..60404eb 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -257,16 +257,6 @@ static void task_fpsimd_load(void)
>  			       sve_vq_from_vl(current->thread.sve_vl) - 1);
>  	else
>  		fpsimd_load_state(&current->thread.uw.fpsimd_state);
> -
> -	if (system_supports_sve()) {
> -		/* Toggle SVE trapping for userspace if needed */
> -		if (test_thread_flag(TIF_SVE))
> -			sve_user_enable();
> -		else
> -			sve_user_disable();
> -
> -		/* Serialised by exception return to user */
> -	}
>  }
>  
>  /*
> @@ -998,7 +988,7 @@ void fpsimd_signal_preserve_current_state(void)
>   * Associate current's FPSIMD context with this cpu
>   * Preemption must be disabled when calling this function.
>   */
> -static void fpsimd_bind_to_cpu(void)
> +static void fpsimd_bind_task_to_cpu(void)
>  {
>  	struct fpsimd_last_state_struct *last =
>  		this_cpu_ptr(&fpsimd_last_state);
> @@ -1006,6 +996,16 @@ static void fpsimd_bind_to_cpu(void)
>  	last->st = &current->thread.uw.fpsimd_state;
>  	last->sve_in_use = test_thread_flag(TIF_SVE);
>  	current->thread.fpsimd_cpu = smp_processor_id();
> +
> +	if (system_supports_sve()) {

Is it worth moving the last->sve_in_use assignment here? If the system
doesn't have SVE, the assignment is always 0, and we probably don't need
to do it at all. It could avoid the double call to test_thread_flag.

> +		/* Toggle SVE trapping for userspace if needed */
> +		if (test_thread_flag(TIF_SVE))
> +			sve_user_enable();
> +		else
> +			sve_user_disable();
> +
> +		/* Serialised by exception return to user */
> +	}
>  }
>  
>  /*
> @@ -1022,7 +1022,7 @@ void fpsimd_restore_current_state(void)
>  
>  	if (test_and_clear_thread_flag(TIF_FOREIGN_FPSTATE)) {
>  		task_fpsimd_load();
> -		fpsimd_bind_to_cpu();
> +		fpsimd_bind_task_to_cpu();
>  	}
>  
>  	local_bh_enable();
> @@ -1045,9 +1045,9 @@ void fpsimd_update_current_state(struct user_fpsimd_state const *state)
>  		fpsimd_to_sve(current);
>  
>  	task_fpsimd_load();
> +	fpsimd_bind_task_to_cpu();
>  
> -	if (test_and_clear_thread_flag(TIF_FOREIGN_FPSTATE))
> -		fpsimd_bind_to_cpu();
> +	clear_thread_flag(TIF_FOREIGN_FPSTATE);
>  
>  	local_bh_enable();
>  }
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

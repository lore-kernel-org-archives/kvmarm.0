From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH 12/27] arm64/sve: Support vector length resetting for new processes
Date: Tue, 22 Aug 2017 17:22:11 +0100
Message-ID: <871so3bmj0.fsf@linaro.org>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com> <1502280338-23002-13-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <libc-alpha-return-83654-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-reply-to: <1502280338-23002-13-git-send-email-Dave.Martin@arm.com>
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


Dave Martin <Dave.Martin@arm.com> writes:

> It's desirable to be able to reset the vector length to some sane
> default for new processes, since the new binary and its libraries
> processes may or may not be SVE-aware.
>
> This patch tracks the desired post-exec vector length (if any) in a
> new thread member sve_vl_onexec, and adds a new thread flag
> TIF_SVE_VL_INHERIT to control whether to inherit or reset the
> vector length.  Currently these are inactive.  Subsequent patches
> will provide the capability to configure them.
>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  arch/arm64/include/asm/processor.h   |  1 +
>  arch/arm64/include/asm/thread_info.h |  1 +
>  arch/arm64/kernel/fpsimd.c           | 13 +++++++++++++
>  3 files changed, 15 insertions(+)
>
> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> index 969feed..da8802a 100644
> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -87,6 +87,7 @@ struct thread_struct {
>  	struct fpsimd_state	fpsimd_state;
>  	void			*sve_state;	/* SVE registers, if any */
>  	u16			sve_vl;		/* SVE vector length */
> +	u16			sve_vl_onexec;	/* SVE vl after next
> exec */

Inconsistent size usage here as well...

>  	unsigned long		fault_address;	/* fault info */
>  	unsigned long		fault_code;	/* ESR_EL1 value */
>  	struct debug_info	debug;		/* debugging */
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index 1a4b30b..bf9c552 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -97,6 +97,7 @@ struct thread_info {
>  #define TIF_SINGLESTEP		21
>  #define TIF_32BIT		22	/* 32bit process */
>  #define TIF_SVE			23	/* Scalable Vector Extension in use */
> +#define TIF_SVE_VL_INHERIT	24	/* Inherit sve_vl_onexec across exec */
>
>  #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
>  #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 37dd1b2..80ecb2d 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -108,6 +108,9 @@ static void task_fpsimd_save(void);
>   */
>  static DEFINE_PER_CPU(struct fpsimd_state *, fpsimd_last_state);
>
> +/* Default VL for tasks that don't set it explicitly: */
> +static int sve_default_vl = -1;
> +
>  static void sve_free(struct task_struct *task)
>  {
>  	kfree(task->thread.sve_state);
> @@ -392,6 +395,9 @@ void fpsimd_flush_thread(void)
>  		clear_thread_flag(TIF_SVE);
>  		sve_free(current);
>
> +		current->thread.sve_vl = current->thread.sve_vl_onexec ?
> +			current->thread.sve_vl_onexec : sve_default_vl;
> +
>  		/*
>  		 * User tasks must have a valid vector length set, but tasks
>  		 * forked early (e.g., init) may not initially have one.
> @@ -401,6 +407,13 @@ void fpsimd_flush_thread(void)
>  		 * If not, something went badly wrong.
>  		 */
>  		BUG_ON(!sve_vl_valid(current->thread.sve_vl));
> +
> +		/*
> +		 * If the task is not set to inherit, ensure that the vector
> +		 * length will be reset by a subsequent exec:
> +		 */
> +		if (!test_thread_flag(TIF_SVE_VL_INHERIT))
> +			current->thread.sve_vl_onexec = 0;
>  	}
>
>  	set_thread_flag(TIF_FOREIGN_FPSTATE);


--
Alex Bennée

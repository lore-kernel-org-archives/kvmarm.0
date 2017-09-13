From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 11/28] arm64/sve: Core task context handling
Date: Wed, 13 Sep 2017 07:33:25 -0700
Message-ID: <20170913143325.hi4cfcajbts3bbao@localhost>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-12-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1504198860-12951-12-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Aug 31, 2017 at 06:00:43PM +0100, Dave P Martin wrote:
> +/*
> + * Handle SVE state across fork():
> + *
> + * dst and src must not end up with aliases of the same sve_state.
> + * Because a task cannot fork except in a syscall, we can discard SVE
> + * state for dst here, so long as we take care to retain the FPSIMD
> + * subset of the state if SVE is in use.  Reallocation of the SVE state
> + * will be deferred until dst tries to use SVE.
> + */
> +void fpsimd_dup_sve(struct task_struct *dst, struct task_struct const *src)
> +{
> +	if (test_and_clear_tsk_thread_flag(dst, TIF_SVE)) {
> +		WARN_ON(dst->mm && !in_syscall(task_pt_regs(dst)));
> +		sve_to_fpsimd(dst);
> +	}
> +
> +	dst->thread.sve_state = NULL;
> +}

I first thought the thread flags are not visible in dst yet since
dup_task_struct() calls arch_dup_task_struct() before
setup_thread_stack(). However, at the end of the last year we enabled
CONFIG_THREAD_INFO_IN_TASK_STRUCT. But I don't particularly like relying
on this.

Anyway, IIUC we don't need sve_to_fpsimd() here. The
arch_dup_task_struct() already called fpsimd_preserve_current_state()
for src, so the FPSIMD state (which we care about) is transferred during
the *dst = *src assignment. So you'd only need the last statement,
possibly with a different function name like fpsimd_erase_sve (and maybe
make the function static inline in the header).

[...]
>  int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
> @@ -246,6 +247,9 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
>  	if (current->mm)
>  		fpsimd_preserve_current_state();
>  	*dst = *src;
> +
> +	fpsimd_dup_sve(dst, src);
> +
>  	return 0;
>  }

-- 
Catalin

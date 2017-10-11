From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 13/28] arm64/sve: Signal handling support
Date: Wed, 11 Oct 2017 17:40:52 +0100
Message-ID: <20171011164052.exvy2w5p47mewrmg@armageddon.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-14-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507660725-7986-14-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 10, 2017 at 07:38:30PM +0100, Dave P Martin wrote:
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index aabeaee..fa4ed34 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -310,6 +310,32 @@ static void fpsimd_to_sve(struct task_struct *task)
>  		       sizeof(fst->vregs[i]));
>  }
>  
> +/*
> + * Transfer the SVE state in task->thread.sve_state to
> + * task->thread.fpsimd_state.
> + *
> + * Task can be a non-runnable task, or current.  In the latter case,
> + * softirqs (and preemption) must be disabled.
> + * task->thread.sve_state must point to at least sve_state_size(task)
> + * bytes of allocated kernel memory.
> + * task->thread.sve_state must be up to date before calling this function.
> + */
> +static void sve_to_fpsimd(struct task_struct *task)
> +{
> +	unsigned int vq;
> +	void const *sst = task->thread.sve_state;
> +	struct fpsimd_state *fst = &task->thread.fpsimd_state;
> +	unsigned int i;
> +
> +	if (!system_supports_sve())
> +		return;
> +
> +	vq = sve_vq_from_vl(task->thread.sve_vl);
> +	for (i = 0; i < 32; ++i)
> +		memcpy(&fst->vregs[i], ZREG(sst, vq, i),
> +		       sizeof(fst->vregs[i]));
> +}

Nit: could we actually just do an assignment with some pointer casting?
It looks like we invoke memcpy for every 16 bytes (same for
fpsimd_to_sve).

Otherwise:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 19/28] arm64/sve: ptrace and ELF coredump support
Date: Thu, 12 Oct 2017 18:06:32 +0100
Message-ID: <20171012170632.35zifttm55rzu745@armageddon.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-20-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507660725-7986-20-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Alan Hayward <alan.hayward@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 10, 2017 at 07:38:36PM +0100, Dave P Martin wrote:
> @@ -702,6 +737,211 @@ static int system_call_set(struct task_struct *target,
>  	return ret;
>  }
>  
> +#ifdef CONFIG_ARM64_SVE
> +
> +static void sve_init_header_from_task(struct user_sve_header *header,
> +				      struct task_struct *target)
> +{
> +	unsigned int vq;
> +
> +	memset(header, 0, sizeof(*header));
> +
> +	header->flags = test_tsk_thread_flag(target, TIF_SVE) ?
> +		SVE_PT_REGS_SVE : SVE_PT_REGS_FPSIMD;

For PTRACE_SYSCALL, we may or may not have TIF_SVE depending on what
happened with the target. Just a thought: shall we clear TIF_SVE (and
sync it to fpsimd) in syscall_trace_enter()?

> +	if (test_tsk_thread_flag(target, TIF_SVE_VL_INHERIT))
> +		header->flags |= SVE_PT_VL_INHERIT;
> +
> +	header->vl = target->thread.sve_vl;
> +	vq = sve_vq_from_vl(header->vl);
> +
> +	header->max_vl = sve_max_vl;
> +	if (WARN_ON(!sve_vl_valid(sve_max_vl)))
> +		header->max_vl = header->vl;
> +
> +	header->size = SVE_PT_SIZE(vq, header->flags);
> +	header->max_size = SVE_PT_SIZE(sve_vq_from_vl(header->max_vl),
> +				      SVE_PT_REGS_SVE);
> +}
[...]
> +static int sve_set(struct task_struct *target,
> +		   const struct user_regset *regset,
> +		   unsigned int pos, unsigned int count,
> +		   const void *kbuf, const void __user *ubuf)
> +{
> +	int ret;
> +	struct user_sve_header header;
> +	unsigned int vq;
> +	unsigned long start, end;
> +
> +	if (!system_supports_sve())
> +		return -EINVAL;
> +
> +	/* Header */
> +	if (count < sizeof(header))
> +		return -EINVAL;
> +	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &header,
> +				 0, sizeof(header));
> +	if (ret)
> +		goto out;
> +
> +	/*
> +	 * Apart from PT_SVE_REGS_MASK, all PT_SVE_* flags are consumed by
> +	 * sve_set_vector_length(), which will also validate them for us:
> +	 */
> +	ret = sve_set_vector_length(target, header.vl,
> +		((unsigned long)header.flags & ~SVE_PT_REGS_MASK) << 16);
> +	if (ret)
> +		goto out;
> +
> +	/* Actual VL set may be less than the user asked for: */
> +	vq = sve_vq_from_vl(target->thread.sve_vl);
> +
> +	/* Registers: FPSIMD-only case */
> +
> +	BUILD_BUG_ON(SVE_PT_FPSIMD_OFFSET != sizeof(header));
> +	if ((header.flags & SVE_PT_REGS_MASK) == SVE_PT_REGS_FPSIMD) {
> +		sve_sync_to_fpsimd(target);
> +
> +		ret = __fpr_set(target, regset, pos, count, kbuf, ubuf,
> +				SVE_PT_FPSIMD_OFFSET);
> +		clear_tsk_thread_flag(target, TIF_SVE);
> +		goto out;
> +	}

__fpr_set() already calls sve_sync_to_fpsimd(). Anyway, do you actually
need this since we are going to override the FPSIMD state anyway here.

> +
> +	/* Otherwise: full SVE case */
> +
> +	/*
> +	 * If setting a different VL from the requested VL and there is
> +	 * register data, the data layout will be wrong: don't even
> +	 * try to set the registers in this case.
> +	 */
> +	if (count && vq != sve_vq_from_vl(header.vl)) {
> +		ret = -EIO;
> +		goto out;
> +	}
> +
> +	sve_alloc(target);
> +	fpsimd_sync_to_sve(target);

Similarly here, it's a full SVE case, so we are going to override it
anyway.

> +	set_tsk_thread_flag(target, TIF_SVE);

This has the side-effect of enabling TIF_SVE even for PTRACE_SYSCALL
which may be cleared in some circumstances. It may not be an issue
though.

-- 
Catalin

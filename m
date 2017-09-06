From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 19/28] arm64/sve: ptrace and ELF coredump support
Date: Wed, 6 Sep 2017 19:16:35 +0100
Message-ID: <20170906181634.GF6321@e103592.cambridge.arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-20-git-send-email-Dave.Martin@arm.com>
 <5FA513F682BE7F4EAAB8EE035D5B08E44109DFE8@G01JPEXMBKW02>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5FA513F682BE7F4EAAB8EE035D5B08E44109DFE8@G01JPEXMBKW02>
Sender: linux-arch-owner@vger.kernel.org
To: "Okamoto, Takayuki" <tokamoto@jp.fujitsu.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>, "gdb@sourceware.org" <gdb@sourceware.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Yao Qi <Yao.Qi@arm.com>, Alan Hayward <alan.hayward@arm.com>, Will Deacon <will.deacon@arm.com>, Oleg Nesterov <oleg@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Richard Sandiford <richard.sandiford@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 06, 2017 at 04:21:50PM +0000, Okamoto, Takayuki wrote:
> Hi Dave,
> 
> I am an engineer of the postK computer from Fujitsu.
> 
> When I tried to read "max_vl" by ptrace with this patch on our local SVE 
> simulator, it was read as zero.
> I think the cause of this incident is that "max_vl" is set as "header->vl" 
> only on warning case in sve_init_header_from_task().
> "max_vl" should be set up also on normal case, like the following patch.
> 
> 
> --- a/arch/arm64/kernel/ptrace.c
> +++ b/arch/arm64/kernel/ptrace.c
> @@ -755,6 +755,8 @@ static void sve_init_header_from_task(struct user_sve_header *header,
> 
>         if (WARN_ON(!sve_vl_valid(sve_max_vl)))
>                 header->max_vl = header->vl;
> +       else
> +               header->max_vl = sve_max_vl;
> 
>         header->size = SVE_PT_SIZE(vq, header->flags);
>         header->max_size = SVE_PT_SIZE(sve_vq_from_vl(header->max_vl),

Hi, thanks for reporting this.

It looks like a refactoring mistake I made while removing BUG_ON()s,
which I missed in my testing.

Your fix looks correct and seems to work.  For stylistic reasons, I may
write it like this instead, but the effect should be the same:

	header->max_vl = sve_max_vl;
	if (WARN_ON(!sve_vl_valid(sve_max_vl))
		header->max_vl = header->vl;

Cheers
---Dave

> 
> 
> Best regards,
> Takayuki Okamoto
> 
> -----Original Message-----
> From: gdb-owner@sourceware.org [mailto:gdb-owner@sourceware.org] On Behalf Of Dave Martin
> Sent: Friday, September 1, 2017 2:01 AM
> To: linux-arm-kernel@lists.infradead.org
> Cc: Catalin Marinas <catalin.marinas@arm.com>; Will Deacon <will.deacon@arm.com>; Ard Biesheuvel <ard.biesheuvel@linaro.org>; Alex Bennée <alex.bennee@linaro.org>; Szabolcs Nagy <szabolcs.nagy@arm.com>; Richard Sandiford <richard.sandiford@arm.com>; kvmarm@lists.cs.columbia.edu; libc-alpha@sourceware.org; linux-arch@vger.kernel.org; gdb@sourceware.org; Alan Hayward <alan.hayward@arm.com>; Yao Qi <Yao.Qi@arm.com>; Oleg Nesterov <oleg@redhat.com>; Alexander Viro <viro@zeniv.linux.org.uk>
> Subject: [PATCH v2 19/28] arm64/sve: ptrace and ELF coredump support
> 

[...]

> @@ -702,6 +737,210 @@ static int system_call_set(struct task_struct *target,
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
> +	if (test_tsk_thread_flag(target, TIF_SVE_VL_INHERIT))
> +		header->flags |= SVE_PT_VL_INHERIT;
> +
> +	header->vl = target->thread.sve_vl;
> +	vq = sve_vq_from_vl(header->vl);
> +
> +	if (WARN_ON(!sve_vl_valid(sve_max_vl)))
> +		header->max_vl = header->vl;
> +
> +	header->size = SVE_PT_SIZE(vq, header->flags);
> +	header->max_size = SVE_PT_SIZE(sve_vq_from_vl(header->max_vl),
> +				      SVE_PT_REGS_SVE);
> +}

[...]

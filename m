From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH v2 10/16] arm64: kernel: Survive corrected RAS errors
 notified by SError
Date: Wed, 13 Sep 2017 14:52:21 -0600
Message-ID: <eba92679-bbb7-6cb7-843c-7cfdbc793b6b@codeaurora.org>
References: <20170728141019.9084-1-james.morse@arm.com>
 <20170728141019.9084-11-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97E0949C25
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Sep 2017 16:49:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gA-qaV5mh6wc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Sep 2017 16:49:47 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C91849C24
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Sep 2017 16:49:47 -0400 (EDT)
In-Reply-To: <20170728141019.9084-11-james.morse@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Wang Xiongfeng <wangxiongfeng2@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 7/28/2017 8:10 AM, James Morse wrote:
> On v8.0, SError is an uncontainable fatal exception. The v8.2 RAS
> extensions use SError to notify software about RAS errors, these can be
> contained by the ESB instruction.
>
> An ACPI system with firmware-first may use SError as its 'SEI'
> notification. Future patches may add code to 'claim' this SError as
> notification.
>
> Other systems can distinguish these RAS errors from the SError ESR and
> use the AET bits and additional data from RAS-Error registers to handle
> the error.  Future patches may add this kernel-first handling.
>
> In the meantime, on both kinds of system we can safely ignore corrected
> errors.
>
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>   arch/arm64/include/asm/esr.h | 10 ++++++++++
>   arch/arm64/kernel/traps.c    | 35 ++++++++++++++++++++++++++++++++---
>   2 files changed, 42 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index 8cabd57b6348..77d5b1baf1a4 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -83,6 +83,15 @@
>   /* ISS field definitions shared by different classes */
>   #define ESR_ELx_WNR		(UL(1) << 6)
>   
> +/* Asynchronous Error Type */
> +#define ESR_ELx_AET		(UL(0x7) << 10)
> +
> +#define ESR_ELx_AET_UC		(UL(0) << 10)	/* Uncontainable */
> +#define ESR_ELx_AET_UEU		(UL(1) << 10)	/* Uncorrected Unrecoverable */
> +#define ESR_ELx_AET_UEO		(UL(2) << 10)	/* Uncorrected Restartable */
> +#define ESR_ELx_AET_UER		(UL(3) << 10)	/* Uncorrected Recoverable */
> +#define ESR_ELx_AET_CE		(UL(6) << 10)	/* Corrected */
> +
>   /* Shared ISS field definitions for Data/Instruction aborts */
>   #define ESR_ELx_FnV		(UL(1) << 10)
>   #define ESR_ELx_EA		(UL(1) << 9)
> @@ -92,6 +101,7 @@
>   #define ESR_ELx_FSC		(0x3F)
>   #define ESR_ELx_FSC_TYPE	(0x3C)
>   #define ESR_ELx_FSC_EXTABT	(0x10)
> +#define ESR_ELx_FSC_SERROR	(0x11)
>   #define ESR_ELx_FSC_ACCESS	(0x08)
>   #define ESR_ELx_FSC_FAULT	(0x04)
>   #define ESR_ELx_FSC_PERM	(0x0C)
> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> index 943a0e242dbc..e1eaccc66548 100644
> --- a/arch/arm64/kernel/traps.c
> +++ b/arch/arm64/kernel/traps.c
> @@ -685,10 +685,8 @@ asmlinkage void bad_el0_sync(struct pt_regs *regs, int reason, unsigned int esr)
>   	force_sig_info(info.si_signo, &info, current);
>   }
>   
> -asmlinkage void do_serror(struct pt_regs *regs, unsigned int esr)
> +static void do_serror_panic(struct pt_regs *regs, unsigned int esr)
>   {
> -	nmi_enter();
> -
>   	console_verbose();
>   
>   	pr_crit("SError Interrupt on CPU%d, code 0x%08x -- %s\n",
> @@ -696,6 +694,37 @@ asmlinkage void do_serror(struct pt_regs *regs, unsigned int esr)
>   	__show_regs(regs);
>   
>   	nmi_panic(regs, "Asynchronous SError Interrupt");
> +}
> +
> +static void _do_serror(struct pt_regs *regs, unsigned int esr)
> +{
> +	bool impdef_syndrome = esr & ESR_ELx_ISV;	/* aka IDS */
> +	unsigned int aet = esr & ESR_ELx_AET;
> +
> +	if (!cpus_have_const_cap(ARM64_HAS_RAS_EXTN) || impdef_syndrome)
> +		return do_serror_panic(regs, esr);
> +
> +	/*
> +	 * AET is RES0 if 'the value returned in the DFSC field is not
> +	 * [ESR_ELx_FSC_SERROR]'
> +	 */
> +	if ((esr & ESR_ELx_FSC) != ESR_ELx_FSC_SERROR)
> +		return do_serror_panic(regs, esr);
> +
> +	switch (aet) {
Hello James,

Here you just have corrected and restartable errors being ignored and 
all other errors panic. For corrected and restartable errors, we should 
at least be logging that an error happened and provide the syndrome info 
(address, context, etc.). We also should be triggering a trace event to 
notify the user space that an error happened so that tools like RAS 
Daemon can report the error. This will involve a new trace event since 
the current ones are based of the CPER structures from the 
firmware-first case.

Recoverable UEs should not need to trigger the panic, we should be able 
to do the recovery similar to the memory fault handling in 
mm/memory-failure.c code. The recoverable UEs should also trigger a 
trace event to user space since they won't cause a panic as well.

Thanks,
Tyler
> +	case ESR_ELx_AET_CE:	/* corrected error */
> +	case ESR_ELx_AET_UEO:	/* restartable, not yet consumed */
> +		break;
> +	default:
> +		return do_serror_panic(regs, esr);
> +	}
> +}
> +
> +asmlinkage void do_serror(struct pt_regs *regs, unsigned int esr)
> +{
> +	nmi_enter();
> +
> +	_do_serror(regs, esr);
>   
>   	nmi_exit();
>   }

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.

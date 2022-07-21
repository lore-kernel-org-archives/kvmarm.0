Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 354A0C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 20:35:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90BD44C74B;
	Thu, 21 Jul 2022 16:35:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XraGEw043jVj; Thu, 21 Jul 2022 16:35:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C4AD4C76A;
	Thu, 21 Jul 2022 16:35:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B5904C73E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 16:35:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s5b1Fe9BH5bc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 16:35:30 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BEBCF4C709
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 16:35:30 -0400 (EDT)
Date: Thu, 21 Jul 2022 21:35:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1658435729;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=xf2R3DLEoWV9wiDF/EeEI67ekf5B8ETj3Ae3cglXYTQ=;
 b=LCKVjwVeX3h/LJlm5Q+ZVxAzI8OGSt1gtNMfTIM4zhBrh5K1BJZzOdYuc11fL+2sF8I9gW
 ugooAwV9bAtpkfjd76uA/0VU+Koxl64lmoPFPLAGjMAUCJI5gkk7aYlq12L+8GFShHbZOX
 KUWvcVNrv3UBsznTETFsyIURS6u06QQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH v5 17/17] KVM: arm64: Introduce hyp_dump_backtrace()
Message-ID: <Ytm4ji93wyjRI7Jw@google.com>
References: <20220721055728.718573-1-kaleshsingh@google.com>
 <20220721055728.718573-18-kaleshsingh@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220721055728.718573-18-kaleshsingh@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, elver@google.com,
 vincenzo.frascino@arm.com, will@kernel.org, android-mm@google.com,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, madvenka@linux.microsoft.com,
 kernel-team@android.com, drjones@redhat.com, ast@kernel.org,
 broonie@kernel.org, linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Kalesh,

Nifty series! Had the chance to take it for a spin :) Few comments
below:

On Wed, Jul 20, 2022 at 10:57:28PM -0700, Kalesh Singh wrote:
> In non-protected nVHE mode, unwinds and dumps the hypervisor backtrace
> from EL1. This is possible beacuase the host can directly access the
> hypervisor stack pages in non-proteced mode.
> 
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---
> 
> Changes in v5:
>   - Move code out from nvhe.h header to handle_exit.c, per Marc
>   - Fix stacktrace symoblization when CONFIG_RAMDOMIZE_BASE is enabled,
>     per Fuad
>   - Use regular comments instead of doc comments, per Fuad
> 
>  arch/arm64/kvm/handle_exit.c | 65 +++++++++++++++++++++++++++++++-----
>  1 file changed, 56 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index ad568da5c7d7..432b6b26f4ad 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c

[...]

> @@ -318,6 +319,56 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
>  		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
>  }
>  
> +/*
> + * kvm_nvhe_print_backtrace_entry - Symbolizes and prints the HYP stack address
> + */
> +static void kvm_nvhe_print_backtrace_entry(unsigned long addr,
> +						  unsigned long hyp_offset)
> +{
> +	unsigned long va_mask = GENMASK_ULL(vabits_actual - 1, 0);
> +
> +	/* Mask tags and convert to kern addr */
> +	addr = (addr & va_mask) + hyp_offset;
> +	kvm_err(" [<%016lx>] %pB\n", addr, (void *)(addr + kaslr_offset()));
> +}

It is a bit odd to see this get churned from the last patch. Is it
possible to introduce the helper earlier on? In fact, the non-protected
patch should come first to layer the series better.

Also, it seems to me that there isn't much need for the indirection if
the pKVM unwinder is made to work around the below function signature:

<snip>

> +/*
> + * hyp_dump_backtrace_entry - Dump an entry of the non-protected nVHE HYP stacktrace
> + *
> + * @arg    : the hypervisor offset, used for address translation
> + * @where  : the program counter corresponding to the stack frame
> + */
> +static bool hyp_dump_backtrace_entry(void *arg, unsigned long where)
> +{
> +	kvm_nvhe_print_backtrace_entry(where, (unsigned long)arg);
> +
> +	return true;
> +}

</snip>

> +/*
> + * hyp_dump_backtrace - Dump the non-proteced nVHE HYP backtrace.
> + *
> + * @hyp_offset: hypervisor offset, used for address translation.
> + *
> + * The host can directly access HYP stack pages in non-protected
> + * mode, so the unwinding is done directly from EL1. This removes
> + * the need for shared buffers between host and hypervisor for
> + * the stacktrace.
> + */
> +static void hyp_dump_backtrace(unsigned long hyp_offset)
> +{
> +	struct kvm_nvhe_stacktrace_info *stacktrace_info;
> +	struct unwind_state state;
> +
> +	stacktrace_info = this_cpu_ptr_nvhe_sym(kvm_stacktrace_info);
> +
> +	kvm_nvhe_unwind_init(&state, stacktrace_info->fp, stacktrace_info->pc);
> +
> +	kvm_err("Non-protected nVHE HYP call trace:\n");

I don't see the value in discerning non-protected vs. protected in the
preamble, as panic() will dump the kernel commandline which presumably
would have a `kvm-arm.mode=protected` in the case of pKVM.

<nit>

Not entirely your problem, but we should really use a consistent name
for that thing we have living at EL2. Hyp or nVHE (but not both) would
be appropriate.

</nit>

> +	unwind(&state, hyp_dump_backtrace_entry, (void *)hyp_offset);
> +	kvm_err("---- End of Non-protected nVHE HYP call trace ----\n");

Maybe:

kvm_err("---[ end ${NAME_FOR_EL2} trace ]---");

(more closely matches the pattern of the arm64 stacktrace)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

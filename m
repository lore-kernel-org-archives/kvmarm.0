Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A92C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 11 Oct 2022 18:48:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FBFD4B20D;
	Tue, 11 Oct 2022 14:48:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0CpRp6sNckSi; Tue, 11 Oct 2022 14:48:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBCCA4B1B4;
	Tue, 11 Oct 2022 14:48:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 272424B1B4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Oct 2022 14:48:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VCJHOTRCjGXn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Oct 2022 14:48:45 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2CCC40171
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Oct 2022 14:48:45 -0400 (EDT)
Date: Tue, 11 Oct 2022 11:48:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1665514124;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=jwUuFfKVT/IBhZS1xJd712tVZ2U42EWvKxBAY1OBy2U=;
 b=WoLRw3kDbRW+fd1QBnPOGS0PV3qDYDtz+HNnnM49JtYpz9z0NauyT7w8dI/u8mAN6dibh2
 9YWmQPSmt1jq2O+ny0GVym+UvNC2WvHXII7qkKl7YRVraFvjCqILW4NFYAfgIq3Y0v8Co5
 mzRtohfWXsNWlfosYCl1vGXLpTRuiys=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: pkvm: Fixup boot mode to reflect that the
 kernel resumes from EL1
Message-ID: <Y0W6hxc68wi4FO/o@google.com>
References: <20221011165400.1241729-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221011165400.1241729-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Tue, Oct 11, 2022 at 05:54:00PM +0100, Marc Zyngier wrote:
> The kernel has an awfully complicated boot sequence in order to cope
> with the various EL2 configurations, including those that "enhanced"
> the architecture. We go from EL2 to EL1, then back to EL2, staying
> at EL2 if VHE capable and otherwise go back to EL1.
> 
> Here's a paracetamol tablet for you.

Heh, still have a bit of a headache from this :)

I'm having a hard time following where we skip the EL2 promotion based
on __boot_cpu_mode.

On the cpu_resume() path it looks like we take the return of
init_kernel_el() and pass that along to finalise_el2(). As we are in EL1
at this point, it seems like we'd go init_kernel_el() -> init_el1().

What am I missing?

--
Thanks,
Oliver

> The cpu_resume path follows the same logic, because coming up with
> two versions of a square wheel is hard.
> 
> However, things aren't this straightforward with pKVM, as the host
> resume path is always proxied by the hypervisor, which means that
> the kernel is always entered at EL1. Which contradicts what the
> __boot_cpu_mode[] array contains (it obviously says EL2).
> 
> This thus triggers a HVC call from EL1 to EL2 in a vain attempt
> to upgrade from EL1 to EL2 VHE, which we are, funnily enough,
> reluctant to grant to the host kernel. This is also completely
> unexpected, and puzzles your average EL2 hacker.
> 
> Address it by fixing up the boot mode at the point the host gets
> deprivileged. is_hyp_mode_available() and co already have a static
> branch to deal with this, making it pretty safe.
> 
> Reported-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arm.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index b6c9bfa8492f..cf075c9b9ab1 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2107,6 +2107,17 @@ static int pkvm_drop_host_privileges(void)
>  	 * once the host stage 2 is installed.
>  	 */
>  	static_branch_enable(&kvm_protected_mode_initialized);
> +
> +	/*
> +	 * Fixup the boot mode so that we don't take spurious round
> +	 * trips via EL2 on cpu_resume. Flush to the PoC for a good
> +	 * measure, so that it can be observed by a CPU coming out of
> +	 * suspend with the MMU off.
> +	 */
> +	__boot_cpu_mode[0] = __boot_cpu_mode[1] = BOOT_CPU_MODE_EL1;
> +	dcache_clean_poc((unsigned long)__boot_cpu_mode,
> +			 (unsigned long)(__boot_cpu_mode + 2));
> +
>  	on_each_cpu(_kvm_host_prot_finalize, &ret, 1);
>  	return ret;
>  }
> -- 
> 2.34.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

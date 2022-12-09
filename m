Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8BE6C4332F
	for <kvmarm@archiver.kernel.org>; Fri,  9 Dec 2022 17:58:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63FCA4B9D1;
	Fri,  9 Dec 2022 12:58:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KdlAPCQOpGDy; Fri,  9 Dec 2022 12:58:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AA714B99C;
	Fri,  9 Dec 2022 12:58:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA0FB4B975
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 12:58:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GHJCjugus7WZ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Dec 2022 12:58:36 -0500 (EST)
Received: from out-107.mta0.migadu.com (out-107.mta0.migadu.com
 [91.218.175.107])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE3BB4B971
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 12:58:36 -0500 (EST)
Date: Fri, 9 Dec 2022 17:58:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1670608715;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=IR+jrVVuE0jVnD3pXeex+chn1g7QgKrTqJIzEs1h2fU=;
 b=XgcgOcm1DkOKZUjSCrn+qe9RWw0h2gVpf94YOFQK3dKy2YVyyw5mpkzzmrBhWvop6GONrw
 DU3fcIitfN0dyWC+lATNByCy5EUv/Eud1jWUJOS6SI3hhsXCdsXazyAc7HNBjPmcqpWa4T
 PYcbxNZR+B79FzdVQPOB5jYyuAqIYQU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Clark <james.clark@arm.com>
Subject: Re: [PATCH 1/1] KVM: arm64: PMU: Fix PMCR_EL0 reset value
Message-ID: <Y5N3R+w3GF94hxHa@google.com>
References: <20221209164446.1972014-1-james.clark@arm.com>
 <20221209164446.1972014-2-james.clark@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221209164446.1972014-2-james.clark@arm.com>
X-Migadu-Flow: FLOW_OUT
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Fri, Dec 09, 2022 at 04:44:46PM +0000, James Clark wrote:
> ARMV8_PMU_PMCR_N_MASK is an unshifted value which results in the wrong
> reset value for PMCR_EL0, so shift it to fix it.

That's just mean. *_MASK tends to be a shifted mask, although it would
appear that asm/perf_event.h does not follow this convention. Fixing
that would be nice (as I'm sure somebody else will get burned by this),
but for the sake of an immediate fix:

> This fixes the following error when running qemu:
> 
>   $ qemu-system-aarch64 -cpu host -machine type=virt,accel=kvm -kernel ...
> 
>   target/arm/helper.c:1813: pmevcntr_rawwrite: Assertion `counter < pmu_num_counters(env)' failed.
> 
> Fixes: 292e8f149476 ("KVM: arm64: PMU: Simplify PMCR_EL0 reset handling")
> Signed-off-by: James Clark <james.clark@arm.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver

> ---
>  arch/arm64/kvm/sys_regs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index d5ee52d6bf73..c6cbfe6b854b 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -646,7 +646,7 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  		return;
>  
>  	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
> -	pmcr = read_sysreg(pmcr_el0) & ARMV8_PMU_PMCR_N_MASK;
> +	pmcr = read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
>  	if (!kvm_supports_32bit_el0())
>  		pmcr |= ARMV8_PMU_PMCR_LC;
>  
> -- 
> 2.25.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

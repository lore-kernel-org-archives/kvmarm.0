Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A0013C918
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721180; cv=none; b=SUrM7nr1kBqL3JSvpRMN4zIZiaPdQ5HiLcRmoFPtS6v49dMuHfeLgNQKE17XeouIWz55G2zHfLNUdO32CX7WevhdKkq3RtpJIU0x8NOmjdibyXchAUwj3reEYkh3qFKfotCgmqSFAPtbXgtGukiEeFlHXZhAIzRIPLoUd96gw4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721180; c=relaxed/simple;
	bh=cZO6dCpt0PwPwyFlyqp9lDdewbXDrNxzC0E2dFssjr8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ez9kLxJ8Es8+xFqB1y+BF9EbiLqqkQ8vief4T5kirfPt/m+94C3EimYmZN7p/SFG+wiy9sk3J7sHVGNOCClZdIt0Lzx3kJqfCjylotbnooWiQC3WscZo4TlmHbbyK8xXC9yBESwaeg6ZxOzk9m47xzpRTdZXoIuVw+RrV6sjX5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VeGUumLJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VeGUumLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D156C116C6;
	Thu,  5 Mar 2026 14:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721179;
	bh=cZO6dCpt0PwPwyFlyqp9lDdewbXDrNxzC0E2dFssjr8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VeGUumLJg9Ecgb1G2OIvzx5YPaE355YP/2d4ad0wJ7yPFkxosRZoOx1nZVJay0ZJN
	 wVOh/lC8yMSk/rD7p4Rawv/ccKouRzfC8wO438uQzXDjIRW0WDOvJU/BqhtwurVcfc
	 +ZvX/DkJtaXxwDubC9+Bw9RVTrHxoo/IRsxjC5VBPqHRq+rqjHjfYqTwGea6WHe8LP
	 Bvj55rHbqfiN+pV0OQTsec9boA+LpvgaAQ6c5dI0BJdtK8mWmlHWtwY3oBbrJn/7Yu
	 ZRIbFZ99aTHTeGxtN3gLjUg+mhhwHLww3RZMHXPLxODGThYSuZGXGaSFTAR0OxJJdU
	 qVGWmFk1WNjUQ==
Date: Thu, 5 Mar 2026 14:32:54 +0000
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH 4/4] KVM: arm64: Add SMC hook for SME dvmsync erratum
Message-ID: <aamUFoQV74t4okXx@willie-the-truck>
References: <20260302165801.3014607-1-catalin.marinas@arm.com>
 <20260302165801.3014607-5-catalin.marinas@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302165801.3014607-5-catalin.marinas@arm.com>

On Mon, Mar 02, 2026 at 04:57:57PM +0000, Catalin Marinas wrote:
> From: James Morse <james.morse@arm.com>
> 
> C1-Pro cores with SME have an erratum where TLBI+DSB does not complete
> all outstanding SME accesses. Instead a DSB needs to be executed on the
> affecteed CPUs. The implication is pages cannot be unmapped from the
> host stage2 then provided to the guest. Host SME accesses may occur
> after this point.
> 
> This erratum breaks pKVM's guarantees, and the workaround is hard to
> implement as EL2 and EL1 share a security state meaning EL1 can mask
> IPI sent by EL2, leading to interrupt blackouts.
> 
> Instead, do this in EL3. This has the advantage of a separate security
> state, meaning lower EL cannot mask the IPI. It is also simpler for EL3
> to know about CPUs that are off or in PSCI's CPU_SUSPEND.
> 
> Add the needed hook.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>
> Cc: Sudeep Holla <sudeep.holla@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 17 +++++++++++++++++
>  include/linux/arm-smccc.h             |  5 +++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 38f66a56a766..ab7f9273fddf 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -5,6 +5,8 @@
>   */
>  
>  #include <linux/kvm_host.h>
> +#include <linux/arm-smccc.h>
> +
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
> @@ -28,6 +30,15 @@ static struct hyp_pool host_s2_pool;
>  static DEFINE_PER_CPU(struct pkvm_hyp_vm *, __current_vm);
>  #define current_vm (*this_cpu_ptr(&__current_vm))
>  
> +static void pkvm_sme_dvmsync_fw_call(void)
> +{
> +	if (cpus_have_final_cap(ARM64_WORKAROUND_SME_DVMSYNC)) {
> +		struct arm_smccc_res res;
> +
> +		arm_smccc_1_1_smc(ARM_SMCCC_CPU_SME_DVMSYNC_WORKAROUND, &res);
> +	}
> +}
> +
>  static void guest_lock_component(struct pkvm_hyp_vm *vm)
>  {
>  	hyp_spin_lock(&vm->lock);
> @@ -553,6 +564,12 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
>  	if (ret)
>  		return ret;
>  
> +	/*
> +	 * After stage2 maintenance has happened, but before the page owner has
> +	 * changed.
> +	 */
> +	pkvm_sme_dvmsync_fw_call();

Please note that this will conflict with my patch series adding support
for protected memory with pkvm. I _think_ the right answer is to
move this call into host_stage2_set_owner_metadata_locked().

Will

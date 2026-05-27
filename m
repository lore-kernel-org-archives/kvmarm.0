Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A7AE256C8B
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 12:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779883537; cv=none; b=rJcCTebfdzwnhT2uj+aP20NfPpShKe9zqlB6T63Mb6SamRR+lYkiGHeBRXGYptCnhyLZfjBug9XM8CxfTgbyX/wpvyRGp4UjGc/TYg7PHQmViCva2kCVyp0Ih1ytC/+SaHKo2Q5QJbEjs+kI7SK3ppU1FYZDjts7YsS57CaGMUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779883537; c=relaxed/simple;
	bh=Zbxpqn4Jt/9J9sZFTsb4lQB+ojGhadpcsY1uxX/YM5w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GKXy8s2UiBDY60yfpHwkF9TijCXqPvExSpPvX2cNvLQLzJvOzIMXswq+8CStHPfE1Q2/SNPgYyfMn080627H/aJIJMKEJYkv8YCrDoWR6kq0HxFVUC9m2wVL+51OoMFkkAU7bDMEZp6uYzoT+jWSN2qx/tqcPD4afKAuXuJ2G6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QbFKB+7j; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QbFKB+7j"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA7D72880;
	Wed, 27 May 2026 05:05:29 -0700 (PDT)
Received: from [10.1.38.169] (e121487-lin.cambridge.arm.com [10.1.38.169])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A51CE3F7D8;
	Wed, 27 May 2026 05:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779883534; bh=Zbxpqn4Jt/9J9sZFTsb4lQB+ojGhadpcsY1uxX/YM5w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QbFKB+7jVYsFzfC6CZJ1pOS71mhTMwWoUMCsHUiIvQtsA9VyylaEke2RIanwkvzCy
	 7DQh3WmNbyA2JaQqEg+dnLLA4AUkTebzIIvEE+Fpw4FYjUhagVYcQ8gy6cL1Vlx1AP
	 /VGoSX53cvFwGJkyY8cUdSK5lzoH74BPk/jrTVtA=
Message-ID: <7cca038b-f5bc-4dba-97cd-a77c5d5cf804@arm.com>
Date: Wed, 27 May 2026 13:05:30 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/18] arm64: fpsimd: Fold sve_init_regs() into
 do_sve_acc()
To: Mark Rutland <mark.rutland@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 maz@kernel.org, oupton@kernel.org, tabba@google.com, will@kernel.org
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-6-mark.rutland@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20260521132556.584676-6-mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/26 14:25, Mark Rutland wrote:
> For historical reasons, do_sve_acc() is structurally different from
> do_sme_acc(), and the logic to convert the task from FPSIMD to SVE is
> out-of-line in sve_init_regs(). We only use sve_init_regs() within
> do_sme_acc(), so it's not necessary for this to be a separate function.
> 
> Fold sve_init_regs() into do_sve_acc(), and simplify the associated
> comments. This makes do_sve_acc() structurally similar to do_sme_acc(),
> making it easier to see similarities and differences.
> 
> There should be no functional change as a result of this patch.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kernel/fpsimd.c | 48 ++++++++++++++------------------------
>  1 file changed, 17 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 60a45d600b460..a8395cb303344 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -1293,31 +1293,6 @@ void sme_suspend_exit(void)
>  
>  #endif /* CONFIG_ARM64_SME */
>  
> -static void sve_init_regs(void)
> -{
> -	/*
> -	 * Convert the FPSIMD state to SVE, zeroing all the state that
> -	 * is not shared with FPSIMD. If (as is likely) the current
> -	 * state is live in the registers then do this there and
> -	 * update our metadata for the current task including
> -	 * disabling the trap, otherwise update our in-memory copy.
> -	 * We are guaranteed to not be in streaming mode, we can only
> -	 * take a SVE trap when not in streaming mode and we can't be
> -	 * in streaming mode when taking a SME trap.
> -	 */
> -	if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
> -		unsigned long vq_minus_one =
> -			sve_vq_from_vl(task_get_sve_vl(current)) - 1;
> -		sve_set_vq(vq_minus_one);
> -		sve_flush_live(true, vq_minus_one);
> -		fpsimd_bind_task_to_cpu();
> -	} else {
> -		fpsimd_to_sve(current);
> -		current->thread.fp_type = FP_STATE_SVE;
> -		fpsimd_flush_task_state(current);
> -	}
> -}
> -
>  /*
>   * Trapped SVE access
>   *
> @@ -1349,13 +1324,24 @@ void do_sve_acc(unsigned long esr, struct pt_regs *regs)
>  		WARN_ON(1); /* SVE access shouldn't have trapped */
>  
>  	/*
> -	 * Even if the task can have used streaming mode we can only
> -	 * generate SVE access traps in normal SVE mode and
> -	 * transitioning out of streaming mode may discard any
> -	 * streaming mode state.  Always clear the high bits to avoid
> -	 * any potential errors tracking what is properly initialised.
> +	 * Convert the FPSIMD state to SVE. Stale SVE state can be present in
> +	 * registers or memory, so we must zero all state that is not shared
> +	 * with FPSIMD.
> +	 *
> +	 * SVE traps cannot be taken from streaming mode, so there cannot be
> +	 * any effective streaming mode SVE state.
>  	 */
> -	sve_init_regs();
> +	if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
> +		unsigned long vq_minus_one =
> +			sve_vq_from_vl(task_get_sve_vl(current)) - 1;
> +		sve_set_vq(vq_minus_one);
> +		sve_flush_live(true, vq_minus_one);
> +		fpsimd_bind_task_to_cpu();
> +	} else {
> +		fpsimd_to_sve(current);
> +		current->thread.fp_type = FP_STATE_SVE;
> +		fpsimd_flush_task_state(current);
> +	}
>  
>  	put_cpu_fpsimd_context();
>  }
> -- 2.30.2
> 

FWIW,

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>


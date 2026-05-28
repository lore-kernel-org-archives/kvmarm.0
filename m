Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C8D238E124
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 09:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779961872; cv=none; b=pF+ChZkvXWi9QcOy41ndaLMNi51fSzTVeFeawlHYKUYfgul1BGlLPf2Deu1TcpgJj9rerGvvyRd4S6oW8YlUaeCXA1E9HfN50ykRNB44rzDmhToUnQ9+Y1jNREAOwQfadavRiFCgfSGqCR86MZB0XSG2VjOE0rZl3011XxROto0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779961872; c=relaxed/simple;
	bh=X70e4vacBRXsyNdOBoIXke3uDpO205ahdrLnVP4d2Ig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=feSLJSyK8vILDpsmVuP0tzHRosQxBw47Bg9JX9ZpkelLhVxWwElM05pk2IHKjKjWTo4oFnk80E7UczMgFgekYcIXSipWBMfwjGG9v6/VU0n7kV8EDT9hnkEAawmFaQdf1llfP+ZqA/4w1lc4091tgJiapGaOCOjtIBt3lX/Puk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JUC0hrGL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JUC0hrGL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D6BBB4402;
	Thu, 28 May 2026 02:51:05 -0700 (PDT)
Received: from [10.1.28.164] (unknown [10.1.28.164])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BB2D73F632;
	Thu, 28 May 2026 02:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779961870; bh=X70e4vacBRXsyNdOBoIXke3uDpO205ahdrLnVP4d2Ig=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JUC0hrGLyJhpRgFKiws29O6BYOOSQiU2RoA5WdIMPNVCVN459BryLIxp4IkxewxTa
	 SvkC6Nndm76yZkSWhKYaa28L86KHyrdkS2Nq14BUiBrQ1OtY7FW60LiQCp+/P3iex+
	 O6ZiqsAIlAqlss3sO7lSAKP/c/Xnu/7gMcG0dZyo=
Message-ID: <77e8c8d4-5ba2-41d1-acfd-5cbdbbf65b0e@arm.com>
Date: Thu, 28 May 2026 10:51:06 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/18] arm64: fpsimd: Use opaque type for SME state
To: Mark Rutland <mark.rutland@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 maz@kernel.org, oupton@kernel.org, tabba@google.com, will@kernel.org
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-15-mark.rutland@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20260521132556.584676-15-mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/26 14:25, Mark Rutland wrote:
> As the SME state size can vary at runtime, we don't have a concrete type
> for the in-memory SME state, and pass this around using a pointer to
> void.
> 
> Using pointer to void means that it's very easy to introduce errors that
> cannot be caught by the compiler (e.g. as 'void **' can be assigned to
> 'void *').
> 
> Improve this by adding an opaque 'struct sve_state', and consistently
> passing a pointer to this.
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
>  arch/arm64/include/asm/fpsimd.h    | 8 ++++----
>  arch/arm64/include/asm/processor.h | 3 ++-
>  arch/arm64/kernel/fpsimd.c         | 4 ++--
>  3 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> index 19e670ae67598..560814acc60c0 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -163,7 +163,7 @@ extern void fpsimd_update_current_state(struct user_fpsimd_state const *state);
>  struct cpu_fp_state {
>  	struct user_fpsimd_state *st;
>  	struct sve_state *sve_state;
> -	void *sme_state;
> +	struct sme_state *sme_state;
>  	u64 *svcr;
>  	u64 *fpmr;
>  	unsigned int sve_vl;
> @@ -199,7 +199,7 @@ static inline void *thread_zt_state(struct thread_struct *thread)
>  {
>  	/* The ZT register state is stored immediately after the ZA state */
>  	unsigned int sme_vq = sve_vq_from_vl(thread_get_sme_vl(thread));
> -	return thread->sme_state + ZA_SIG_REGS_SIZE(sme_vq);
> +	return (void *)thread->sme_state + ZA_SIG_REGS_SIZE(sme_vq);
>  }
>  
>  static inline unsigned int sve_get_vl(void)
> @@ -218,8 +218,8 @@ static inline unsigned int sve_get_vl(void)
>  extern void sve_save_state(struct sve_state *state, int save_ffr);
>  extern void sve_load_state(const struct sve_state *state, int restore_ffr);
>  extern void sve_flush_live(bool flush_ffr, unsigned long vq_minus_1);
> -extern void sme_save_state(void *state, int zt);
> -extern void sme_load_state(void const *state, int zt);
> +extern void sme_save_state(struct sme_state *state, int zt);
> +extern void sme_load_state(const struct sme_state *state, int zt);
>  
>  struct arm64_cpu_capabilities;
>  extern void cpu_enable_fpsimd(const struct arm64_cpu_capabilities *__unused);
> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> index 1c2ffd063baa8..7304d9cca3e85 100644
> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -131,6 +131,7 @@ enum fp_type {
>  };
>  
>  struct sve_state;		/* Opaque type */
> +struct sme_state;		/* Opaque type */
>  
>  struct cpu_context {
>  	unsigned long x19;
> @@ -167,7 +168,7 @@ struct thread_struct {
>  	enum fp_type		fp_type;	/* registers FPSIMD or SVE? */
>  	unsigned int		fpsimd_cpu;
>  	struct sve_state	*sve_state;	/* SVE registers, if any */
> -	void			*sme_state;	/* ZA and ZT state, if any */
> +	struct sme_state	*sme_state;	/* ZA and ZT state, if any */
>  	unsigned int		vl[ARM64_VEC_MAX];	/* vector length */
>  	unsigned int		vl_onexec[ARM64_VEC_MAX]; /* vl after next exec */
>  	unsigned long		fault_address;	/* fault info */
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 66d880d081671..f9b3eeacf130d 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -808,7 +808,7 @@ static int change_live_vector_length(struct task_struct *task,
>  	unsigned int sve_vl = task_get_sve_vl(task);
>  	unsigned int sme_vl = task_get_sme_vl(task);
>  	struct sve_state *sve_state = NULL;
> -	void *sme_state = NULL;
> +	struct sme_state *sme_state = NULL;
>  
>  	if (type == ARM64_VEC_SME)
>  		sme_vl = vl;
> @@ -1645,7 +1645,7 @@ static void fpsimd_flush_thread_vl(enum vec_type type)
>  void fpsimd_flush_thread(void)
>  {
>  	struct sve_state *sve_state = NULL;
> -	void *sme_state = NULL;
> +	struct sme_state *sme_state = NULL;
>  
>  	if (!system_supports_fpsimd())
>  		return;
> -- 2.30.2
> 

FWIW,

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>


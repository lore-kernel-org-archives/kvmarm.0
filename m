Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 491F13016E7
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 14:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779893365; cv=none; b=egidePj6EYkQjyhH2t6YzhG5BR0nIZVGeBhvXvCAd/+Ivgx+ZvDuM6lphELPkSz2/q+MFSZiYWGTvSr9sz92bpyvQ6oO2PRf74Ml9hePb/aY+77cFa+Gilo8v1j/9beGdRJ/g4eb8HYpHE0vO+GAkQ8Yr7oDW7uH45P7Jxuz/Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779893365; c=relaxed/simple;
	bh=C38syTCSjjdSlrbnwDdWqfihxKKcTQGrDUikmMHKDDU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MazeBbBuag77PFQA7VKzDW2l+5tQuQBE2OaqfnLwEBucQtTDSgZyzk6ZvuTRoXThQDtwuLN0OrPP8FeV0a7THrbkWv5r3On3O1iiLpNUZvirmJv3U2r7c6P2o4sHfLryJSxn9b42vL6f8rG2ATocXrlHhG85qejZjjv062v9NTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Gfiy0djE; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Gfiy0djE"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D84827DC;
	Wed, 27 May 2026 07:49:17 -0700 (PDT)
Received: from [10.1.38.169] (e121487-lin.cambridge.arm.com [10.1.38.169])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AE98B3F905;
	Wed, 27 May 2026 07:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779893362; bh=C38syTCSjjdSlrbnwDdWqfihxKKcTQGrDUikmMHKDDU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Gfiy0djEibdXZm0BtmMGMoRzZ9/scXS0R7/AXoH5ie653Nue9RmnJ+NoUzTxkkmrX
	 H8sK+4Gqpt7TbYHgBLd4Onglv/vL66Sv76MYtTdbTMKr+4nROUANvJNfGVtTxUu4k1
	 9KMoXwsqPyDmAjdw44hq4VZKynO7lk487nwOGvC4=
Message-ID: <c5ba3af9-08b2-4be2-b9f5-58a925f0b050@arm.com>
Date: Wed, 27 May 2026 15:49:18 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/18] arm64: fpsimd: Move fpsimd save/restore inline
To: Mark Rutland <mark.rutland@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 maz@kernel.org, oupton@kernel.org, tabba@google.com, will@kernel.org
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-13-mark.rutland@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20260521132556.584676-13-mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Mark,

On 5/21/26 14:25, Mark Rutland wrote:
> Currently the FPSIMD register save/restore sequences are written in
> out-of-line assembly routines. While this works, it's somewhat painful:
> 
> * As KVM needs to be able to use the sequences in hyp code, separate
>   assembly files are used for the regular kernel and KVM code. While the
>   common logic is shared in assembly macros, this still requires some
>   duplication, and has lead to some trivial divergence.
> 
> * For historical reasons, the assembly macros take some register
>   arguments as numerical indices (e.g. "fpsimd_save x0, 8" uses x0 and
>   x8), which is simply confusing.
> 
> * For historical reasons, the SVE save/restore code and FPSIMD
>   save/restore code have distinct sequences for FPSR and FPCR. Ideally
>   this logic would be shared.
> 
> * The assembly sequences can't be instrumented, and so it's harder than
>   necessary to catch memory safety issues.
> 
> To handle the above, move the FPSIMD register save/restore sequences to
> inline assembly, and share the FPSR+FPCR save/restore with SVE.
> 
> Neither GCC nor LLVM instrument memory arguments to inline assembly, so
> explicit instrumentation is added in the same manner as other assembly
> routines. This instrumentation is implicitly disabled by Kbuild for nVHE
> hyp code.
> 
> Note that I've used the SVE sequence for restoring FPCR, which uses an
> unconditional write to FPCR. The plain FPSIMD assembly sequence used a
> conditional write to FPCR since 2014 in commit:
> 
>   5959e25729a5 ("arm64: fpsimd: avoid restoring fpcr if the contents haven't change")
> 
> ... but this was not followed for the SVE assembly implemented in 2017
> in commit:
> 
>   1fc5dce78ad1 ("arm64/sve: Low-level SVE architectural state manipulation functions")
> 
> ... so I've assumed that this doesn't actually matter in practice, and
> I've erred in favour of the simpler sequence.
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
>  arch/arm64/include/asm/fpsimd.h         | 68 ++++++++++++++++++++++++-
>  arch/arm64/include/asm/fpsimdmacros.h   | 59 ---------------------
>  arch/arm64/include/asm/kvm_hyp.h        |  2 -
>  arch/arm64/kernel/entry-fpsimd.S        | 20 --------
>  arch/arm64/kvm/hyp/fpsimd.S             | 10 ----
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  4 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  4 +-
>  7 files changed, 70 insertions(+), 97 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> index 6fd5cdf5e5f17..19b373ad0ebf7 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -22,6 +22,8 @@
>  #include <linux/stddef.h>
>  #include <linux/types.h>
>  
> +#define __FPSIMD_PREAMBLE	".arch_extension fp\n" \
> +				".arch_extension simd\n"
>  #define __SVE_PREAMBLE		".arch_extension sve\n"
>  #define __SME_PREAMBLE		".arch_extension sme\n"
>  
> @@ -86,8 +88,70 @@ static inline void fpsimd_load_common(const struct user_fpsimd_state *state)
>  	write_sysreg_s(state->fpcr, SYS_FPCR);
>  }
>  
> -extern void fpsimd_save_state(struct user_fpsimd_state *state);
> -extern void fpsimd_load_state(struct user_fpsimd_state *state);
> +static inline void fpsimd_save_vregs(struct user_fpsimd_state *state)
> +{
> +	instrument_write(state->vregs, sizeof(state->vregs));
> +	asm volatile(
> +	__FPSIMD_PREAMBLE
> +	"	stp	q0,  q1,  [%[vregs], #16 * 0]\n"
> +	"	stp	q2,  q3,  [%[vregs], #16 * 2]\n"
> +	"	stp	q4,  q5,  [%[vregs], #16 * 4]\n"
> +	"	stp	q6,  q7,  [%[vregs], #16 * 6]\n"
> +	"	stp	q8,  q9,  [%[vregs], #16 * 8]\n"
> +	"	stp	q10, q11, [%[vregs], #16 * 10]\n"
> +	"	stp	q12, q13, [%[vregs], #16 * 12]\n"
> +	"	stp	q14, q15, [%[vregs], #16 * 14]\n"
> +	"	stp	q16, q17, [%[vregs], #16 * 16]\n"
> +	"	stp	q18, q19, [%[vregs], #16 * 18]\n"
> +	"	stp	q20, q21, [%[vregs], #16 * 20]\n"
> +	"	stp	q22, q23, [%[vregs], #16 * 22]\n"
> +	"	stp	q24, q25, [%[vregs], #16 * 24]\n"
> +	"	stp	q26, q27, [%[vregs], #16 * 26]\n"
> +	"	stp	q28, q29, [%[vregs], #16 * 28]\n"
> +	"	stp	q30, q31, [%[vregs], #16 * 30]\n"
> +	: "=Q" (state->vregs)
> +	: [vregs] "r" (state->vregs)

Missing "memory" clobber here?

> +	);
> +}
> +
> +static inline void fpsimd_load_vregs(const struct user_fpsimd_state *state)
> +{
> +	instrument_read(state->vregs, sizeof(state->vregs));
> +	asm volatile(
> +	__FPSIMD_PREAMBLE
> +	"	ldp	q0,  q1,  [%[vregs], #16 * 0]\n"
> +	"	ldp	q2,  q3,  [%[vregs], #16 * 2]\n"
> +	"	ldp	q4,  q5,  [%[vregs], #16 * 4]\n"
> +	"	ldp	q6,  q7,  [%[vregs], #16 * 6]\n"
> +	"	ldp	q8,  q9,  [%[vregs], #16 * 8]\n"
> +	"	ldp	q10, q11, [%[vregs], #16 * 10]\n"
> +	"	ldp	q12, q13, [%[vregs], #16 * 12]\n"
> +	"	ldp	q14, q15, [%[vregs], #16 * 14]\n"
> +	"	ldp	q16, q17, [%[vregs], #16 * 16]\n"
> +	"	ldp	q18, q19, [%[vregs], #16 * 18]\n"
> +	"	ldp	q20, q21, [%[vregs], #16 * 20]\n"
> +	"	ldp	q22, q23, [%[vregs], #16 * 22]\n"
> +	"	ldp	q24, q25, [%[vregs], #16 * 24]\n"
> +	"	ldp	q26, q27, [%[vregs], #16 * 26]\n"
> +	"	ldp	q28, q29, [%[vregs], #16 * 28]\n"
> +	"	ldp	q30, q31, [%[vregs], #16 * 30]\n"
> +	:
> +	: "Q" (state->vregs),
> +	  [vregs] "r" (state->vregs)

Missing "memory" clobber here?


> +	);
> +}
> +

[snip]

Cheers
Vladimir

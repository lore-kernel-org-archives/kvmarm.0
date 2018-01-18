From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 16/19] arm64: insn: Allow ADD/SUB (immediate) with LSL
 #12
Date: Thu, 18 Jan 2018 21:28:05 +0100
Message-ID: <20180118202805.GD21802@cbox>
References: <20180104184334.16571-1-marc.zyngier@arm.com>
 <20180104184334.16571-17-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180104184334.16571-17-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Steve Capper <steve.capper@arm.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 04, 2018 at 06:43:31PM +0000, Marc Zyngier wrote:
> The encoder for ADD/SUB (immediate) can only cope with 12bit
> immediates, while there is an encoding for a 12bit immediate shifted
> by 12 bits to the left.
> 
> Let's fix this small oversight by allowing the LSL_12 bit to be set.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kernel/insn.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
> index 59669d7d4383..20655537cdd1 100644
> --- a/arch/arm64/kernel/insn.c
> +++ b/arch/arm64/kernel/insn.c
> @@ -35,6 +35,7 @@
>  
>  #define AARCH64_INSN_SF_BIT	BIT(31)
>  #define AARCH64_INSN_N_BIT	BIT(22)
> +#define AARCH64_INSN_LSL_12	BIT(22)
>  
>  static int aarch64_insn_encoding_class[] = {
>  	AARCH64_INSN_CLS_UNKNOWN,
> @@ -903,9 +904,18 @@ u32 aarch64_insn_gen_add_sub_imm(enum aarch64_insn_register dst,
>  		return AARCH64_BREAK_FAULT;
>  	}
>  
> +	/* We can't encode more than a 24bit value (12bit + 12bit shift) */
> +	if (imm & ~(BIT(24) - 1))
> +		goto out;
> +
> +	/* If we have something in the top 12 bits... */
>  	if (imm & ~(SZ_4K - 1)) {
> -		pr_err("%s: invalid immediate encoding %d\n", __func__, imm);
> -		return AARCH64_BREAK_FAULT;
> +		/* ... and in the low 12 bits -> error */
> +		if (imm & (SZ_4K - 1))
> +			goto out;
> +
> +		imm >>= 12;
> +		insn |= AARCH64_INSN_LSL_12;
>  	}
>  
>  	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RD, insn, dst);
> @@ -913,6 +923,10 @@ u32 aarch64_insn_gen_add_sub_imm(enum aarch64_insn_register dst,
>  	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RN, insn, src);
>  
>  	return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_12, insn, imm);
> +
> +out:
> +	pr_err("%s: invalid immediate encoding %d\n", __func__, imm);
> +	return AARCH64_BREAK_FAULT;
>  }
>  
>  u32 aarch64_insn_gen_bitfield(enum aarch64_insn_register dst,


Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

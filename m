From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2 08/19] arm64: KVM: Dynamically patch the kernel/hyp
 VA mask
Date: Thu, 14 Dec 2017 13:17:28 +0000
Message-ID: <5A3279E8.2070507@arm.com>
References: <20171211144937.4537-1-marc.zyngier@arm.com> <20171211144937.4537-9-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171211144937.4537-9-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steve Capper <steve.capper@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 11/12/17 14:49, Marc Zyngier wrote:
> So far, we're using a complicated sequence of alternatives to
> patch the kernel/hyp VA mask on non-VHE, and NOP out the
> masking altogether when on VHE.
> 
> THe newly introduced dynamic patching gives us the opportunity
> to simplify that code by patching a single instruction with
> the correct mask (instead of the mind bending cummulative masking
> we have at the moment) or even a single NOP on VHE.

(and just a single NOP on VHE?)


> diff --git a/arch/arm64/kvm/haslr.c b/arch/arm64/kvm/haslr.c
> new file mode 100644
> index 000000000000..5e1643a4e7bf
> --- /dev/null
> +++ b/arch/arm64/kvm/haslr.c

> +u32 __init kvm_update_va_mask(struct alt_instr *alt, int index, u32 oinsn)
> +{
> +	u32 rd, rn, insn;
> +	u64 imm;
> +
> +	/* We only expect a 1 instruction sequence */
> +	BUG_ON((alt->alt_len / sizeof(insn)) != 1);
> +
> +	/* VHE doesn't need any address translation, let's NOP everything */
> +	if (has_vhe())
> +		return aarch64_insn_gen_nop();
> +
> +	rd = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RD, oinsn);
> +	rn = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RN, oinsn);
> +
> +	switch (index) {
> +	default:
> +		/* Something went wrong... */
> +		insn = AARCH64_BREAK_FAULT;
> +		break;

Can this happen? You bug-on alt->alt_len != 1-instruction above, and the loop in
__apply_alternatives() is calculated in the same way.
If it can, BUG_ON(index != 0) should catch both cases in one go.


> +	case 0:
> +		imm = get_hyp_va_mask();
> +		insn = aarch64_insn_gen_logical_immediate(AARCH64_INSN_LOGIC_AND,
> +							  AARCH64_INSN_VARIANT_64BIT,
> +							  rn, rd, imm);
> +		break;
> +	}
> +
> +	BUG_ON(insn == AARCH64_BREAK_FAULT);
> +
> +	return insn;
> +}
> 


Thanks,

James

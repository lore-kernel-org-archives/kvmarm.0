From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v5 14/23] arm64: KVM: Introduce EL2 VA randomisation
Date: Tue, 13 Mar 2018 11:48:38 +0000
Message-ID: <5AA7BA96.1030908@arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
 <20180301155538.26860-15-marc.zyngier@arm.com> <5AA7B6A0.3000905@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <5AA7B6A0.3000905@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: marc.zyngier@arm.com
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org, Steve Capper <steve.capper@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

[Resending with Marc's email address fixed, looks like I miss-operated the mouse
and pasted some stray text in the address...]

Hi Marc,

On 01/03/18 15:55, Marc Zyngier wrote:
> The main idea behind randomising the EL2 VA is that we usually have
> a few spare bits between the most significant bit of the VA mask
> and the most significant bit of the linear mapping.
>
> Those bits could be a bunch of zeroes, and could be useful
> to move things around a bit. Of course, the more memory you have,
> the less randomisation you get...
>
> Alternatively, these bits could be the result of KASLR, in which
> case they are already random. But it would be nice to have a
> *different* randomization, just to make the job of a potential
> attacker a bit more difficult.
>
> Inserting these random bits is a bit involved. We don't have a spare
> register (short of rewriting all the kern_hyp_va call sites), and
> the immediate we want to insert is too random to be used with the
> ORR instruction. The best option I could come up with is the following
> sequence:
>
> 	and x0, x0, #va_mask
> 	ror x0, x0, #first_random_bit
> 	add x0, x0, #(random & 0xfff)
> 	add x0, x0, #(random >> 12), lsl #12
> 	ror x0, x0, #(63 - first_random_bit)
>
> making it a fairly long sequence, but one that a decent CPU should
> be able to execute without breaking a sweat. It is of course NOPed
> out on VHE. The last 4 instructions can also be turned into NOPs
> if it appears that there is no free bits to use.

> diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
> index 2bcbc1d33b64..a73e47804972 100644
> --- a/arch/arm64/kvm/va_layout.c
> +++ b/arch/arm64/kvm/va_layout.c
> @@ -16,24 +16,62 @@
>   */
>  
>  #include <linux/kvm_host.h>
> +#include <linux/random.h>
> +#include <linux/memblock.h>
>  #include <asm/alternative.h>
>  #include <asm/debug-monitors.h>
>  #include <asm/insn.h>
>  #include <asm/kvm_mmu.h>
>  
> +/*
> + * The LSB of the random hyp VA tag or 0 if no randomization is used.
> + */
> +static u8 tag_lsb;
> +/*
> + * The random hyp VA tag value with the region bit if hyp randomization is used
> + */
> +static u64 tag_val;
>  static u64 va_mask;
>  
>  static void compute_layout(void)
>  {
>  	phys_addr_t idmap_addr = __pa_symbol(__hyp_idmap_text_start);
>  	u64 hyp_va_msb;
> +	int kva_msb;
>  
>  	/* Where is my RAM region? */
>  	hyp_va_msb  = idmap_addr & BIT(VA_BITS - 1);
>  	hyp_va_msb ^= BIT(VA_BITS - 1);
>  
> -	va_mask  = GENMASK_ULL(VA_BITS - 2, 0);
> -	va_mask |= hyp_va_msb;
> +	kva_msb = fls64((u64)phys_to_virt(memblock_start_of_DRAM()) ^
> +			(u64)(high_memory - 1));
> +	if (kva_msb == (VA_BITS - 1)) {
> +		/*
> +		 * No space in the address, let's compute the mask so
> +		 * that it covers (VA_BITS - 1) bits, and the region
> +		 * bit. The tag stays set to zero.
> +		 */
> +		va_mask  = BIT(VA_BITS - 1) - 1;
> +		va_mask |= hyp_va_msb;
> +	} else {
> +		/*
> +		 * We do have some free bits to insert a random tag.
> +		 * Hyp VAs are now created from kernel linear map VAs
> +		 * using the following formula (with V == VA_BITS):
> +		 *
> +		 *  63 ... V |     V-1    | V-2 .. tag_lsb | tag_lsb - 1 .. 0
> +		 *  ---------------------------------------------------------
> +		 * | 0000000 | hyp_va_msb |    random tag  |  kern linear VA |
> +		 */
> +		u64 mask = GENMASK_ULL(VA_BITS - 2, tag_lsb);

(tag_lsb is 0 at this point, but you shift out the bits you didn't want later)


> +
> +		tag_lsb = kva_msb;
> +		va_mask = GENMASK_ULL(tag_lsb - 1, 0);
> +		tag_val  = get_random_long() & mask;
> +		tag_val |= hyp_va_msb;
> +		tag_val >>= tag_lsb;
> +	}
>  }

>  static u32 compute_instruction(int n, u32 rd, u32 rn)
> @@ -46,6 +84,33 @@ static u32 compute_instruction(int n, u32 rd, u32 rn)
>  							  AARCH64_INSN_VARIANT_64BIT,
>  							  rn, rd, va_mask);
>  		break;
> +
> +	case 1:
> +		/* ROR is a variant of EXTR with Rm = Rn */
> +		insn = aarch64_insn_gen_extr(AARCH64_INSN_VARIANT_64BIT,
> +					     rn, rn, rd,
> +					     tag_lsb);
> +		break;
> +
> +	case 2:
> +		insn = aarch64_insn_gen_add_sub_imm(rd, rn,
> +						    tag_val & (SZ_4K - 1),
> +						    AARCH64_INSN_VARIANT_64BIT,
> +						    AARCH64_INSN_ADSB_ADD);
> +		break;
> +
> +	case 3:
> +		insn = aarch64_insn_gen_add_sub_imm(rd, rn,
> +						    tag_val & GENMASK(23, 12),
> +						    AARCH64_INSN_VARIANT_64BIT,
> +						    AARCH64_INSN_ADSB_ADD);
> +		break;

(This mix of GENMASK() and (SZ_4K - 1) feels a bit odd)


> @@ -68,8 +132,12 @@ void __init kvm_update_va_mask(struct alt_instr *alt,
>  		/*
>  		 * VHE doesn't need any address translation, let's NOP
>  		 * everything.
> +		 *
> +		 * Alternatively, if we don't have any spare bits in
> +		 * the address, NOP everything after masking that
> +		 * kernel VA.
>  		 */

> -		if (has_vhe()) {
> +		if (has_vhe() || (!tag_lsb && i > 1)) {
>  			updptr[i] = aarch64_insn_gen_nop();
>  			continue;
>  		}

Typo? Won't this keep the first ror too, instead of just the 'and'?
| (!tag_lsb && i > 0)

(I agree 'ROR #0' is still a NOP)

Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James

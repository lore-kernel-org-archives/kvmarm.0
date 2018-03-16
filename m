From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 04/26] arm64: KVM: Dynamically patch the kernel/hyp VA
 mask
Date: Fri, 16 Mar 2018 08:52:14 +0000
Message-ID: <141abcdc-f926-2599-3f68-87c9b8f3c634@arm.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
 <20180314165049.30105-5-marc.zyngier@arm.com> <5AAAC659.70403@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <5AAAC659.70403@arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Andrew Jones <drjones@redhat.com>, Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org, Steve Capper <steve.capper@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 15/03/18 19:15, James Morse wrote:
> Hi Marc,
> 
> On 14/03/18 16:50, Marc Zyngier wrote:
>> So far, we're using a complicated sequence of alternatives to
>> patch the kernel/hyp VA mask on non-VHE, and NOP out the
>> masking altogether when on VHE.
>>
>> The newly introduced dynamic patching gives us the opportunity
>> to simplify that code by patching a single instruction with
>> the correct mask (instead of the mind bending cummulative masking
> 
> (Nit: cumulative)
> 
> (so this series removes mind bending code?)

Absolutely. And replaces it with... erm... (/me shuts up).

> 
>> we have at the moment) or even a single NOP on VHE. This also
>> adds some initial code that will allow the patching callback
>> to switch to a more complex patching.
> 
>> diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
>> new file mode 100644
>> index 000000000000..45e7802328d4
>> --- /dev/null
>> +++ b/arch/arm64/kvm/va_layout.c
> 
>> +void __init kvm_update_va_mask(struct alt_instr *alt,
>> +			       __le32 *origptr, __le32 *updptr, int nr_inst)
>> +{
>> +	int i;
>> +
>> +	/* We only expect a single instruction in the alternative sequence */
>> +	BUG_ON(nr_inst != 1);
>> +
>> +	if (!has_vhe() && !va_mask)
>> +		compute_layout();
>> +
>> +	for (i = 0; i < nr_inst; i++) {
>> +		u32 rd, rn, insn, oinsn;
>> +
>> +		/*
>> +		 * VHE doesn't need any address translation, let's NOP
>> +		 * everything.
>> +		 */
>> +		if (has_vhe()) {
>> +			updptr[i] = aarch64_insn_gen_nop();
> 
> cpu_to_le32()? (I'm not going to try an boot a BE VHE model...)

You're missing out. Let's make BE big again.

> 
> aarch64_insn_gen_nop() returns:
> | aarch64_insn_get_hint_value() | AARCH64_INSN_HINT_NOP;
> 
> It doesn't look like these aarch64_insn_get_XXX_value() helpers are forcing a
> particular endianness. ftrace uses this, via ftrace_modify_code() ->
> aarch64_insn_patch_text_nosync() -> aarch64_insn_write(), which does:
> | return  __aarch64_insn_write(addr, cpu_to_le32(insn));
> 
> So it looks like the conversion is required. Patch 16 looks fine for this.

Absolutely correct, I'm missing the byte swap. Now fixed.

> (and, I ran the teardown code on Juno big-endian...)

Wow. You *the* user!!!! ;-)

> 
> 
>> +			continue;
>> +		}
>> +
>> +		oinsn = le32_to_cpu(origptr[i]);
>> +		rd = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RD, oinsn);
>> +		rn = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RN, oinsn);
>> +
>> +		insn = compute_instruction(i, rd, rn);
>> +		BUG_ON(insn == AARCH64_BREAK_FAULT);
>> +
>> +		updptr[i] = cpu_to_le32(insn);
>> +	}
>> +}
> 
> With that,
> 
> Reviewed-by: James Morse <james.morse@arm.com>

Thanks a lot,

	M.
-- 
Jazz is not dead. It just smells funny...

From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 16/28] arm64/sve: Probe SVE capabilities and usable vector lengths
Date: Thu, 28 Sep 2017 18:32:16 +0100
Message-ID: <87k20id90f.fsf@linaro.org>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com> <1504198860-12951-17-git-send-email-Dave.Martin@arm.com> <87fubpaa1o.fsf@linaro.org> <20170928142212.GB3611@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-reply-to: <20170928142212.GB3611@e103592.cambridge.arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <Suzuki.Poulose@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu


Dave Martin <Dave.Martin@arm.com> writes:

> On Thu, Sep 14, 2017 at 10:45:07AM +0100, Alex Bennée wrote:
>>
>> Dave Martin <Dave.Martin@arm.com> writes:
>>
>> > This patch uses the cpufeatures framework to determine common SVE
>> > capabilities and vector lengths, and configures the runtime SVE
>> > support code appropriately.
>> >
>> > ZCR_ELx is not really a feature register, but it is convenient to
>> > use it as a template for recording the maximum vector length
>> > supported by a CPU, using the LEN field.  This field is similar to
>> > a feature field in that it is a contiguous bitfield for which we
>> > want to determine the minimum system-wide value.  This patch adds
>> > ZCR as a pseudo-register in cpuinfo/cpufeatures, with appropriate
>> > custom code to populate it.  Finding the minimum supported value of
>> > the LEN field is left to the cpufeatures framework in the usual
>> > way.
>> >
>> > The meaning of ID_AA64ZFR0_EL1 is not architecturally defined yet,
>> > so for now we just require it to be zero.
>> >
>> > Note that much of this code is dormant and SVE still won't be used
>> > yet, since system_supports_sve() remains hardwired to false.
>> >
>> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
>> > Cc: Alex Bennée <alex.bennee@linaro.org>
>> > Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>
>> >
>> > ---
>> >
>> > Changes since v1
>> > ----------------
>> >
>> > Requested by Alex Bennée:
>> >
>> > * Thin out BUG_ON()s:
>> > Redundant BUG_ON()s and ones that just check invariants are removed.
>> > Important sanity-checks are migrated to WARN_ON()s, with some
>> > minimal best-effort patch-up code.
>> >
>> > Other changes related to Alex Bennée's comments:
>> >
>> > * Migrate away from magic numbers for converting VL to VQ.
>> >
>> > Requested by Suzuki Poulose:
>> >
>> > * Make sve_vq_map __ro_after_init.
>> >
>> > Other changes related to Suzuki Poulose's comments:
>> >
>> > * Rely on cpufeatures for not attempting to update the vq map after boot.
>> > ---
>> >  arch/arm64/include/asm/cpu.h        |   4 ++
>> >  arch/arm64/include/asm/cpufeature.h |  29 ++++++++++
>> >  arch/arm64/include/asm/fpsimd.h     |  10 ++++
>> >  arch/arm64/kernel/cpufeature.c      |  50 +++++++++++++++++
>> >  arch/arm64/kernel/cpuinfo.c         |   6 ++
>> >  arch/arm64/kernel/fpsimd.c          | 106 +++++++++++++++++++++++++++++++++++-
>> >  6 files changed, 202 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
>> > index 889226b..8839227 100644
>> > --- a/arch/arm64/include/asm/cpu.h
>> > +++ b/arch/arm64/include/asm/cpu.h
>> > @@ -41,6 +41,7 @@ struct cpuinfo_arm64 {
>> >  	u64		reg_id_aa64mmfr2;
>> >  	u64		reg_id_aa64pfr0;
>> >  	u64		reg_id_aa64pfr1;
>> > +	u64		reg_id_aa64zfr0;
>> >
>> >  	u32		reg_id_dfr0;
>> >  	u32		reg_id_isar0;
>> > @@ -59,6 +60,9 @@ struct cpuinfo_arm64 {
>> >  	u32		reg_mvfr0;
>> >  	u32		reg_mvfr1;
>> >  	u32		reg_mvfr2;
>> > +
>> > +	/* pseudo-ZCR for recording maximum ZCR_EL1 LEN value: */
>> > +	u64		reg_zcr;
>> >  };
>> >
>> >  DECLARE_PER_CPU(struct cpuinfo_arm64, cpu_data);
>> > diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>> > index 4ea3441..d98e7ba 100644
>> > --- a/arch/arm64/include/asm/cpufeature.h
>> > +++ b/arch/arm64/include/asm/cpufeature.h
>> > @@ -10,7 +10,9 @@
>> >  #define __ASM_CPUFEATURE_H
>> >
>> >  #include <asm/cpucaps.h>
>> > +#include <asm/fpsimd.h>
>> >  #include <asm/hwcap.h>
>> > +#include <asm/sigcontext.h>
>> >  #include <asm/sysreg.h>
>> >
>> >  /*
>> > @@ -223,6 +225,13 @@ static inline bool id_aa64pfr0_32bit_el0(u64 pfr0)
>> >  	return val == ID_AA64PFR0_EL0_32BIT_64BIT;
>> >  }
>> >
>> > +static inline bool id_aa64pfr0_sve(u64 pfr0)
>> > +{
>> > +	u32 val = cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_SVE_SHIFT);
>> > +
>> > +	return val > 0;
>> > +}
>> > +
>> >  void __init setup_cpu_features(void);
>> >
>> >  void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
>> > @@ -267,6 +276,26 @@ static inline bool system_supports_sve(void)
>> >  	return false;
>> >  }
>> >
>> > +/*
>> > + * Read the pseudo-ZCR used by cpufeatures to identify the supported SVE
>> > + * vector length.
>> > + * Use only if SVE is present.  This function clobbers the SVE vector length.
>> > + */
>>
>> :nit whitespace formatting.
>
> I'll add some newlines now to make this cleaner.
>
> /*
>  * Read the pseudo-ZCR used by cpufeatures to identify the supported SVE
>  * vector length.
>  *
>  * Use only if SVE is present.
>  * This function clobbers the SVE vector length.
>  */
>
> OK?

Yep.
>
>>
>> > +static u64 __maybe_unused read_zcr_features(void)
>> > +{
>> > +	u64 zcr;
>> > +	unsigned int vq_max;
>> > +
>> > +	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL1);
>>
>> I'm confused, why are we writing something here? You mention clobbering
>> the SVE vector length but what was the point?
>
> Hmm, this deserves a comment -- coming back to this code, I had to think
> about it.  Are the following extra comments sufficient explanation?
>
> 	/*
> 	 * Set the maximum possible VL, and write zeroes to all other
> 	 * bits to see if they stick.
> 	 */
> 	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL1);
>
> 	zcr = read_sysreg_s(SYS_ZCR_EL1);
> 	zcr &= ~(u64)ZCR_ELx_LEN_MASK; /* flag up sticky 1s outside LEN field */
> 	vq_max = sve_vq_from_vl(sve_get_vl());
> 	zcr |= vq_max - 1; /* set LEN field to maximum effective value */
>
>
> [...]

OK that makes more sense. Thanks.
>
>> Otherwise:
>>
>> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
>
> I'll wait on your responses to the above first.

Still good ;-)

>
> Cheers
> ---Dave

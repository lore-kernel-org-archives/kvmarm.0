From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCHv4 06/10] arm64: add basic pointer authentication support
Date: Fri, 25 May 2018 11:18:55 +0100
Message-ID: <20180525101855.szjk4zfavi4omm55@lakrids.cambridge.arm.com>
References: <20180503132031.25705-1-mark.rutland@arm.com>
 <20180503132031.25705-7-mark.rutland@arm.com>
 <114d65a8-ffa5-7061-864a-a32aa3baa5c5@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <114d65a8-ffa5-7061-864a-a32aa3baa5c5@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, catalin.marinas@arm.com, christoffer.dall@arm.com, drjones@redhat.com, marc.zyngier@arm.com, ramana.radhakrishnan@arm.com, will.deacon@arm.com, awallis@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 23, 2018 at 09:42:56AM +0100, Suzuki K Poulose wrote:
> On 03/05/18 14:20, Mark Rutland wrote:
> > +#define __ptrauth_key_install(k, v)			\
> > +do {							\
> > +	write_sysreg_s(v.lo, SYS_ ## k ## KEYLO_EL1);	\
> > +	write_sysreg_s(v.hi, SYS_ ## k ## KEYHI_EL1);	\
> > +} while (0)
> 
> I think it might be safer to have parentheses around v, to prevent
> something like __ptrauth_key_install(APIA, *key_val) work fine.

In case v is ever an expression with side-effects, I've made this:

#define __ptrauth_key_install(k, v)				\
do {								\
	struct ptrauth_key __pki_v = (v);			\
	write_sysreg_s(__pki_v.lo, SYS_ ## k ## KEYLO_EL1);	\
	write_sysreg_s(__pki_v.hi, SYS_ ## k ## KEYHI_EL1);	\
} while (0)

... though I could just move the raw sysreg accesses into
ptrauth_keys_switch() for now.

[...]

> > +#ifdef CONFIG_ARM64_PNTR_AUTH
> > +	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_APA_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_APIA),
> > +#endif
> 
> Did you mean CONFIG_ARM64_PTR_AUTH here ?

Yes; fixed now.

Thanks,
Mark.

From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v1 05/16] arm64: Helper for parange to PASize
Date: Thu, 8 Feb 2018 12:21:06 +0100
Message-ID: <20180208112106.GO29286@cbox>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
 <20180109190414.4017-6-suzuki.poulose@arm.com>
 <20180208110042.GH29286@cbox>
 <040b00f2-3e83-a475-ae20-5e9358fc580a@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <040b00f2-3e83-a475-ae20-5e9358fc580a@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, ard.biesheuvel@linaro.org, mark.rutland@arm.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 08, 2018 at 11:08:18AM +0000, Suzuki K Poulose wrote:
> On 08/02/18 11:00, Christoffer Dall wrote:
> >On Tue, Jan 09, 2018 at 07:04:00PM +0000, Suzuki K Poulose wrote:
> >>Add a helper to convert ID_AA64MMFR0_EL1:PARange to they physical
> >                                                       *the*
> >>size shift. Limit the size to the maximum supported by the kernel.
> >
> >Is this just a cleanup or are we actually going to need this feature in
> >the subsequent patches?  That would be nice to motivate in the commit
> >letter.
> 
> It is a cleanup, plus we are going to move the user of the code around from
> one place to the other. So this makes it a bit easier and cleaner.
> 

On its own I'm not sure it really is a cleanup, so it's good to mention
that this is to make some operation easier later on in the commit
letter.

> 
> >>
> >>Cc: Mark Rutland <mark.rutland@arm.com>
> >>Cc: Catalin Marinas <catalin.marinas@arm.com>
> >>Cc: Will Deacon <will.deacon@arm.com>
> >>Cc: Marc Zyngier <marc.zyngier@arm.com>
> >>Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> >>---
> >>  arch/arm64/include/asm/cpufeature.h | 16 ++++++++++++++++
> >>  arch/arm64/kvm/hyp/s2-setup.c       | 28 +++++-----------------------
> >>  2 files changed, 21 insertions(+), 23 deletions(-)
> >>
> >>diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> >>index ac67cfc2585a..0564e14616eb 100644
> >>--- a/arch/arm64/include/asm/cpufeature.h
> >>+++ b/arch/arm64/include/asm/cpufeature.h
> >>@@ -304,6 +304,22 @@ static inline u64 read_zcr_features(void)
> >>  	return zcr;
> >>  }
> >>+static inline u32 id_aa64mmfr0_parange_to_phys_shift(int parange)
> >>+{
> >>+	switch (parange) {
> >>+	case 0: return 32;
> >>+	case 1: return 36;
> >>+	case 2: return 40;
> >>+	case 3: return 42;
> >>+	case 4: return 44;
> >>+
> >>+	default:
> >
> >What is the case we want to cater for with making parange == 5 the
> >default for unrecognized values?
> >
> >(I have a feeling that default label comes from making the compiler
> >happy about potentially uninitialized values once upon a time before a
> >lot of refactoring happened here.)
> 
> That is there to make sure we return 48 iff 52bit support (for that matter,
> if there is a new limit in the future) is not enabled.
> 

duh, yeah, it's obvious when I look at it again now.

> >
> >>+	case 5: return 48;
> >>+#ifdef CONFIG_ARM64_PA_BITS_52
> >>+	case 6: return 52;
> >>+#endif
> >>+	}
> >>+}
> >>  #endif /* __ASSEMBLY__ */
> 
Thanks,
-Christoffer

From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCHv4 05/10] arm64/cpufeature: detect pointer authentication
Date: Fri, 25 May 2018 11:01:37 +0100
Message-ID: <20180525100137.mte5z2sonob3vffq@lakrids.cambridge.arm.com>
References: <20180503132031.25705-1-mark.rutland@arm.com>
 <20180503132031.25705-6-mark.rutland@arm.com>
 <4c057e99-61a9-7f75-664d-1f16f2631766@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4c057e99-61a9-7f75-664d-1f16f2631766@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, catalin.marinas@arm.com, christoffer.dall@arm.com, drjones@redhat.com, marc.zyngier@arm.com, ramana.radhakrishnan@arm.com, will.deacon@arm.com, awallis@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 23, 2018 at 09:48:28AM +0100, Suzuki K Poulose wrote:
> 
> Mark,
> 
> On 03/05/18 14:20, Mark Rutland wrote:
> > So that we can dynamically handle the presence of pointer authentication
> > functionality, wire up probing code in cpufeature.c.
> > 
> >  From ARMv8.3 onwards, ID_AA64ISAR1 is no longer entirely RES0, and now
> > has four fields describing the presence of pointer authentication
> > functionality:
> > 
> > * APA - address authentication present, using an architected algorithm
> > * API - address authentication present, using an IMP DEF algorithm
> > * GPA - generic authentication present, using an architected algorithm
> > * GPI - generic authentication present, using an IMP DEF algorithm
> > 
> > For the moment we only care about address authentication, so we only
> > need to check APA and API. It is assumed that if all CPUs support an IMP
> > DEF algorithm, the same algorithm is used across all CPUs.
> > 
> > Note that when we implement KVM support, we will also need to ensure
> > that CPUs have uniform support for GPA and GPI.
> > 
> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Cc: Will Deacon <will.deacon@arm.com>
> > ---
> >   arch/arm64/include/asm/cpucaps.h |  5 ++++-
> >   arch/arm64/kernel/cpufeature.c   | 47 ++++++++++++++++++++++++++++++++++++++++
> >   2 files changed, 51 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> > index bc51b72fafd4..9dcb4d1b14f5 100644
> > --- a/arch/arm64/include/asm/cpucaps.h
> > +++ b/arch/arm64/include/asm/cpucaps.h
> > @@ -48,7 +48,10 @@
> >   #define ARM64_HAS_CACHE_IDC			27
> >   #define ARM64_HAS_CACHE_DIC			28
> >   #define ARM64_HW_DBM				29
> > +#define ARM64_HAS_ADDRESS_AUTH_ARCH		30
> > +#define ARM64_HAS_ADDRESS_AUTH_IMP_DEF		31
> 
> Where are these caps used ? I couldn't find anything in the series
> that uses them. Otherwise looks good to me.

Those were consumed by KVM support, which needed to detect if CPUs had
mismatched support. Currently they're just placeholders as I need a
cpucap value for the separate IMP-DEF / architected probing cases.

I *could* get rid of those and just have the ARM64_HAS_ADDRESS_AUTH case
log "Address authentication", but I wanted to have separate messages for
IMP-DEF vs architected.

Thanks,
Mark.

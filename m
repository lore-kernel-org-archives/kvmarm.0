Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE14144C9E
	for <kvmarm@lists.linux.dev>; Thu,  7 Dec 2023 17:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63C48153B;
	Thu,  7 Dec 2023 09:13:30 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E54573F762;
	Thu,  7 Dec 2023 09:12:42 -0800 (PST)
Date: Thu, 7 Dec 2023 17:12:37 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com,
	jingzhangos@google.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 06/12] KVM: arm64: Update and fix FGT register masks
Message-ID: <20231207171237.GA87398@e124191.cambridge.arm.com>
References: <20231206100503.564090-1-tabba@google.com>
 <20231206100503.564090-7-tabba@google.com>
 <20231207150001.GA29745@e124191.cambridge.arm.com>
 <CA+EHjTwC+66GyPma00XQ6VRzktYzxB7XXr+7zSKFrG6U-+EeEQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+EHjTwC+66GyPma00XQ6VRzktYzxB7XXr+7zSKFrG6U-+EeEQ@mail.gmail.com>

On Thu, Dec 07, 2023 at 03:06:44PM +0000, Fuad Tabba wrote:
> Hi Joey,
> 
> On Thu, Dec 7, 2023 at 3:00 PM Joey Gouly <joey.gouly@arm.com> wrote:
> >
> > Hello Fuad,
> >
> > On Wed, Dec 06, 2023 at 10:04:56AM +0000, Fuad Tabba wrote:
> > > New trap bits have been defined in the 2023-09 Arm Architecture
> > > System Registers xml specification [*]. Moreover, the existing
> > > definitions of some of the mask and the RES0 bits overlap, which
> > > could be wrong, confusing, or both.
> > >
> > > Update the bits to represent the latest spec (as of this patch,
> > > 2023-09), and ensure that the existing bits are consistent.
> > >
> > > Subsequent patches will use the generated RES0 fields instead of
> > > specifying them manually. This patch keeps the manual encoding of
> > > the bits to make it easier to review the series.
> > >
> > > [*] https://developer.arm.com/downloads/-/exploration-tools
> > >
> > > Fixes: 0fd76865006d ("KVM: arm64: Add nPIR{E0}_EL1 to HFG traps")
> > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_arm.h | 39 ++++++++++++++++++++------------
> > >  1 file changed, 24 insertions(+), 15 deletions(-)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> > > index 7de0a7062625..b0dc3249d5cd 100644
> > > --- a/arch/arm64/include/asm/kvm_arm.h
> > > +++ b/arch/arm64/include/asm/kvm_arm.h
> > > @@ -344,30 +344,39 @@
> > >   * Once we get to a point where the two describe the same thing, we'll
> > >   * merge the definitions. One day.
> > >   */
> > > -#define __HFGRTR_EL2_RES0    (GENMASK(63, 56) | GENMASK(53, 51))
> > > +#define __HFGRTR_EL2_RES0    BIT(51)
> > >  #define __HFGRTR_EL2_MASK    GENMASK(49, 0)
> > > -#define __HFGRTR_EL2_nMASK   (GENMASK(58, 57) | GENMASK(55, 54) | BIT(50))
> > > +#define __HFGRTR_EL2_nMASK   (GENMASK(63, 52) | BIT(50))
> > >
> > > -#define __HFGWTR_EL2_RES0    (GENMASK(63, 56) | GENMASK(53, 51) |    \
> > > -                              BIT(46) | BIT(42) | BIT(40) | BIT(28) | \
> > > -                              GENMASK(26, 25) | BIT(21) | BIT(18) |  \
> > > +#define __HFGWTR_EL2_RES0    (BIT(51) | BIT(46) | BIT(42) | BIT(40) | \
> > > +                              BIT(28) | GENMASK(26, 25) | BIT(21) | BIT(18) | \
> > >                                GENMASK(15, 14) | GENMASK(10, 9) | BIT(2))
> > > -#define __HFGWTR_EL2_MASK    GENMASK(49, 0)
> > > -#define __HFGWTR_EL2_nMASK   (GENMASK(58, 57) | GENMASK(55, 54) | BIT(50))
> > > +#define __HFGWTR_EL2_MASK    (GENMASK(49, 47) | GENMASK(45, 43) | \
> > > +                              BIT(41) | GENMASK(39, 29) | BIT(27) | \
> > > +                              GENMASK(24, 22) | GENMASK(20, 19) | \
> > > +                              GENMASK(17, 16) | GENMASK(13, 11) | \
> > > +                              GENMASK(8, 3) | GENMASK(1, 0))
> > > +#define __HFGWTR_EL2_nMASK   (GENMASK(63, 52) | BIT(50))
> >
> > By adding all these bits to *_nMASK, we're allowing a guest to access registers
> > which KVM doesn't (currently) deal with.  For example if I apply this patch
> > series, a guest can access S2POR_EL1, previously it would print something like:
> >
> >         kvm [80]: Unsupported guest sys_reg access at: ffffc42969c1f270 [600000c5]
> >          { Op0( 3), Op1( 0), CRn(10), CRm( 2), Op2( 5), func_read },
> >
> > After applying this patch series, the guest can read S2POR_EL1.
> >
> > We don't expose S2POE to the guest through ID_AA64MMFR3_EL1, so a well behaved
> > guest shouldn't access it, but there's nothing stopping it.
> >
> > My question is, is this intended? Or do we need to update the following code
> > (and comment!) to trap all the stuff we don't currently handle (along with
> > ACCDATA_EL1):
> 
> Thanks for pointing this out, and no, it's not intended. For
> consistency, I think it might be good to update the code, as you
> suggest, to prevent these accesses. If you and the other reviewers are
> happy with that solution I can respin with your suggested fix. I have
> a couple of other minor fixes as well for the series.
> 

Thanks for clarifying that.

To me it seems weird to use the generated bits directly, and I think that's why
the code seems confusing?

I think we should stop using __HFGRTR_EL2_nMASK directly in that function, and
build it up from '0'. This also matches, I think, with Marc Z wanting to move
towards setting these things based on features [1], so maybe something like:

	u64 r_val = 0;

	if (cpus_have_final_cap(ARM64_HAS_S1PIE))
		r_set |= HFGxTR_EL2_nPIR_EL1 | HFGxTR_EL2_nPIREO_EL1;

	r_val |= r_set;
	r_val &= ~r_clr;

	write_sysreg_s(r_val, SYS_HFGRTR_EL2);

That way we just explicitly set which bits we don't want to trap on. We have
some weird behaviour right now were we set nSMPRI_EL1 to 1, unless you have
FEAT_SME where we set it to 0.. but if you don't have FEAT_SME it's RES0
anyway? The above approach would fix that.

Thanks,
Joey

[1] https://lore.kernel.org/linux-arm-kernel/87bkb285ud.wl-maz@kernel.org/ (last paragraph)

> 
> Cheers,
> /fuad
> 
> 
> >
> >         static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
> >         {
> >
> >                 ..
> >
> >                 /* The default is not to trap anything but ACCDATA_EL1 */
> >                 r_val = __HFGRTR_EL2_nMASK & ~HFGxTR_EL2_nACCDATA_EL1;
> >                 r_val |= r_set;
> >                 r_val &= ~r_clr;
> >
> >
> > Thanks,
> > Joey
> >
> > >
> > > -#define __HFGITR_EL2_RES0    GENMASK(63, 57)
> > > -#define __HFGITR_EL2_MASK    GENMASK(54, 0)
> > > -#define __HFGITR_EL2_nMASK   GENMASK(56, 55)
> > > +#define __HFGITR_EL2_RES0    (BIT(63) | BIT(61))
> > > +#define __HFGITR_EL2_MASK    (BIT(62) | BIT(60) | GENMASK(54, 0))
> > > +#define __HFGITR_EL2_nMASK   GENMASK(59, 55)
> > >
> > >  #define __HDFGRTR_EL2_RES0   (BIT(49) | BIT(42) | GENMASK(39, 38) |  \
> > >                                GENMASK(21, 20) | BIT(8))
> > > -#define __HDFGRTR_EL2_MASK   ~__HDFGRTR_EL2_nMASK
> > > +#define __HDFGRTR_EL2_MASK   (BIT(63) | GENMASK(58, 50) | GENMASK(48, 43) | \
> > > +                              GENMASK(41, 40) | GENMASK(37, 22) | \
> > > +                              GENMASK(19, 9) | GENMASK(7, 0))
> > >  #define __HDFGRTR_EL2_nMASK  GENMASK(62, 59)
> > >
> > >  #define __HDFGWTR_EL2_RES0   (BIT(63) | GENMASK(59, 58) | BIT(51) | BIT(47) | \
> > >                                BIT(43) | GENMASK(40, 38) | BIT(34) | BIT(30) | \
> > >                                BIT(22) | BIT(9) | BIT(6))
> > > -#define __HDFGWTR_EL2_MASK   ~__HDFGWTR_EL2_nMASK
> > > +#define __HDFGWTR_EL2_MASK   (GENMASK(57, 52) | GENMASK(50, 48) | \
> > > +                              GENMASK(46, 44) | GENMASK(42, 41) | \
> > > +                              GENMASK(37, 35) | GENMASK(33, 31) | \
> > > +                              GENMASK(29, 23) | GENMASK(21, 10) | \
> > > +                              GENMASK(8, 7) | GENMASK(5, 0))
> > >  #define __HDFGWTR_EL2_nMASK  GENMASK(62, 60)
> > >
> > >  #define __HAFGRTR_EL2_RES0   (GENMASK(63, 50) | GENMASK(16, 5))
> > > @@ -375,9 +384,9 @@
> > >  #define __HAFGRTR_EL2_nMASK  0UL
> > >
> > >  /* Similar definitions for HCRX_EL2 */
> > > -#define __HCRX_EL2_RES0              (GENMASK(63, 16) | GENMASK(13, 12))
> > > -#define __HCRX_EL2_MASK              (0)
> > > -#define __HCRX_EL2_nMASK     (GENMASK(15, 14) | GENMASK(4, 0))
> > > +#define __HCRX_EL2_RES0         (GENMASK(63, 25) | GENMASK(13, 12))
> > > +#define __HCRX_EL2_MASK              (BIT(6))
> > > +#define __HCRX_EL2_nMASK     (GENMASK(24, 14) | GENMASK(11, 7) | GENMASK(5, 0))
> > >
> > >  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
> > >  #define HPFAR_MASK   (~UL(0xf))
> > > --
> > > 2.43.0.rc2.451.g8631bc7472-goog
> > >
> > >

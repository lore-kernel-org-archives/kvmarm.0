Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC8011A8C12
	for <kvmarm@lists.linux.dev>; Wed, 31 Jul 2024 09:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722419602; cv=none; b=p7IQOMFDiFsV4gH1SjPcK4x3Ny7z+1Ov0hZ4SO9UEr2y4UCBK+BJuCuiNEPPhQVKiAET8BTTVds1PIKRvtLE2AxzKhWnVi6sl6VNspbTkP/h35IDH8RArp9rzcoBspXWct2ti3qSQDLAVKBLvVIb9Hk8bYgN/w+rSk8q7Dc98PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722419602; c=relaxed/simple;
	bh=OJIosK3Ql2nbnFRp+YXJmhi072hMp3NTP8G7ibcFI9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TTSkUmfenPKILHtcuTb5/HQCOe/6jWUk9nv60Vw7mrIXu8FTqjxxI3WL+w17SbgSl1nFPfMpmLEES+Depsb01EWFb2MIjsDKNCBVE/WTsgdTj21weHgZ9y5gyjD/jd8BGMA/FBsPRL5YRgXzEowJsPC4aiBt1weHQPAAFhA4G50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD5831007;
	Wed, 31 Jul 2024 02:53:44 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C40C3F5A1;
	Wed, 31 Jul 2024 02:53:17 -0700 (PDT)
Date: Wed, 31 Jul 2024 10:53:14 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 10/12] KVM: arm64: nv: Add SW walker for AT S1 emulation
Message-ID: <ZqoJiiNPWBtRhRur@raptor>
References: <20240625133508.259829-1-maz@kernel.org>
 <20240708165800.1220065-1-maz@kernel.org>
 <Zqe0iBtD4389Lhei@raptor>
 <86v80m0wlb.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86v80m0wlb.wl-maz@kernel.org>

Hi,

On Wed, Jul 31, 2024 at 09:55:28AM +0100, Marc Zyngier wrote:
> On Mon, 29 Jul 2024 16:26:00 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi Marc,
> > 
> > On Mon, Jul 08, 2024 at 05:57:58PM +0100, Marc Zyngier wrote:
> > > In order to plug the brokenness of our current AT implementation,
> > > we need a SW walker that is going to... err.. walk the S1 tables
> > > and tell us what it finds.
> > > 
> > > Of course, it builds on top of our S2 walker, and share similar
> > > concepts. The beauty of it is that since it uses kvm_read_guest(),
> > > it is able to bring back pages that have been otherwise evicted.
> > > 
> > > This is then plugged in the two AT S1 emulation functions as
> > > a "slow path" fallback. I'm not sure it is that slow, but hey.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/at.c | 538 ++++++++++++++++++++++++++++++++++++++++++--
> > >  1 file changed, 520 insertions(+), 18 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> > > index 71e3390b43b4c..8452273cbff6d 100644
> > > --- a/arch/arm64/kvm/at.c
> > > +++ b/arch/arm64/kvm/at.c
> > > @@ -4,9 +4,305 @@
> > >   * Author: Jintack Lim <jintack.lim@linaro.org>
> > >   */
> > >  
> > > +#include <linux/kvm_host.h>
> > > +
> > > +#include <asm/esr.h>
> > >  #include <asm/kvm_hyp.h>
> > >  #include <asm/kvm_mmu.h>
> > >  
> > > +struct s1_walk_info {
> > > +	u64	     baddr;
> > > +	unsigned int max_oa_bits;
> > > +	unsigned int pgshift;
> > > +	unsigned int txsz;
> > > +	int 	     sl;
> > > +	bool	     hpd;
> > > +	bool	     be;
> > > +	bool	     nvhe;
> > > +	bool	     s2;
> > > +};
> > > +
> > > +struct s1_walk_result {
> > > +	union {
> > > +		struct {
> > > +			u64	desc;
> > > +			u64	pa;
> > > +			s8	level;
> > > +			u8	APTable;
> > > +			bool	UXNTable;
> > > +			bool	PXNTable;
> > > +		};
> > > +		struct {
> > > +			u8	fst;
> > > +			bool	ptw;
> > > +			bool	s2;
> > > +		};
> > > +	};
> > > +	bool	failed;
> > > +};
> > > +
> > > +static void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool ptw, bool s2)
> > > +{
> > > +	wr->fst		= fst;
> > > +	wr->ptw		= ptw;
> > > +	wr->s2		= s2;
> > > +	wr->failed	= true;
> > > +}
> > > +
> > > +#define S1_MMU_DISABLED		(-127)
> > > +
> > > +static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
> > > +			 struct s1_walk_result *wr, const u64 va, const int el)
> > > +{
> > > +	u64 sctlr, tcr, tg, ps, ia_bits, ttbr;
> > > +	unsigned int stride, x;
> > > +	bool va55, tbi;
> > > +
> > > +	wi->nvhe = el == 2 && !vcpu_el2_e2h_is_set(vcpu);
> > 
> > Where 'el' is computed in handle_at_slow() as:
> > 
> > 	/*
> > 	 * We only get here from guest EL2, so the translation regime
> > 	 * AT applies to is solely defined by {E2H,TGE}.
> > 	 */
> > 	el = (vcpu_el2_e2h_is_set(vcpu) &&
> > 	      vcpu_el2_tge_is_set(vcpu)) ? 2 : 1;
> > 
> > I think 'nvhe' will always be false ('el' is 2 only when E2H is
> > set).
> 
> Yeah, there is a number of problems here. el should depend on both the
> instruction (some are EL2-specific) and the HCR control bits. I'll
> tackle that now.

Yeah, also noticed that how sctlr, tcr and ttbr are chosen in setup_s1_walk()
doesn't look quite right for the nvhe case.

> 
> > I'm curious about what 'el' represents. The translation regime for the AT
> > instruction?
> 
> Exactly that.

Might I make a suggestion here? I was thinking about dropping the (el, wi-nvhe*)
tuple to represent the translation regime and have a wi->regime (or similar) to
unambiguously encode the regime. The value can be an enum with three values to
represent the three possible regimes (REGIME_EL10, REGIME_EL2, REGIME_EL20).

Just a thought though, feel free to ignore at your leisure.

*wi->single_range on the kvm-arm64/nv-at-pan-WIP branch.

Thanks,
Alex

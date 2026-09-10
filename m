Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD99F3BADB2;
	Thu, 10 Sep 2026 09:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789031088; cv=none; b=uSNuD/jfEZXMj7330Pl4XE8/eX/1Mga6VP0rW0mhU8KyHkIL5SgG9x0z8QPDdu7is35ct7bl2PdORcw1O6UURfeVGLTkBsd61VeRko2z6K0dvtghHK3h5RalAhBkrw33qv2B3JXbXPSI6yNxoitycohKF/wKA9tr2nnaVMZV22U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789031088; c=relaxed/simple;
	bh=k0suo/TtB67EEH6np0sjRyDNLi7c6gvhMrFggub9PZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KDicUrRJ4PiO1SPyTi0odzKBr7eHrwZTUiN2PwzI4iK+ajlh3mZ+5VqJWz8HhtuMFQDJC0uikw9LZlIhpfM9GDnQlGfrn3uxVrEhmYURxDjT9Ava+/V9LACdw4g6Tv4eYPNwgt8ahuACuG5aapgRh0YUBWSZN7dOwMjTTae5F/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CykK8PpZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CykK8PpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E481F000FF;
	Thu, 10 Sep 2026 09:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789031086;
	bh=12PQgsgrSBMhJiTZn1CaiDRAflZPBEAmfiFO1v4vyYc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CykK8PpZIyASLenIBcPVyiRuH8NfM3g33NY2WSo5tU7IhFgBcKsMmnMczB+/mWhk2
	 8Fhi9/QKvgJmQfKjYaksoJFWXOt+FB/KdUApexq4o5cHoKcpr53FS74k8BrlJ804Bp
	 nK47PM4opm94q1FrK7+yV6k2x/t47HsCh+6oRY11KZJ/5R5vmLo8XtcpLRjI/dCy0s
	 urYK+dItPtvWl/hK5v9ACT1cXOY3WRu4KOuKGFp5GHfBTS6t2d1Ke5aJQE6p1weh61
	 kwdV1QE4+80K7J927Cmi8F1S0lfz1ZzLgQFnt2zhsgf/0CRS8U/HotsXC7JgbD1q08
	 U9+83MIOUH5Jg==
Date: Thu, 10 Sep 2026 10:04:37 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Leo Soares Passos <Leo.Bras@arm.com>
Subject: Re: [PATCH 1/8] KVM: arm64: Propagate and use esr in s2fd when
 handling guest aborts
Message-ID: <aqJx0NOJxq_7H_dF@gremlin>
References: <20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org>
 <20260825-kvm-arm-prefault-v1-1-befe8947702e@kernel.org>
 <86wlst7b4x.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86wlst7b4x.wl-maz@kernel.org>

On Thu, Sep 10, 2026 at 09:39:58AM +0100, Marc Zyngier wrote:
> On Tue, 25 Aug 2026 17:00:35 +0100,
> "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> >
> > kvm_handle_guest_abort() establishes a kvm_s2_fault_desc data structure,
> > s2fd, to store and propagate state to either pkvm_mem_abort(), gmem_abort()
> > or user_mem_abort() handlers.
> >
> > Each of these, however, examines the Exception Syndrome Register (ESR) via
> > s2fd->vcpu.
> >
> > Introduce an s2fd->esr field to abstract this and propagate it to callers.
> >
> > The value of this (beyond refactoring) is to be able to later generate
> > faults with a synthetic esr, specifically to implement stage 2 page table
> > pre-faulting.
> >
> > Abstract esr-specific predicates and helpers to the esr.h header and either
> > have vcpu wrappers call these, or eliminate them if they are not used
> > elsewhere.
> >
> > Provide kvm_s2_fault_is_[write,exec,perm]() helpers for convenience.
> >
> > Since kvm_s2_fault_map() either sets perm_fault_granule to the permission
> > fault granule or 0 if not a permission fault, implement
> > kvm_s2_perm_fault_granule() to do this directly.
> >
> > Abort handlers which use kvm_s2_fault_desc - gmem_abort() and
> > user_mem_abort() - now only reference s2fd->esr and do not look it up in
> > any other way, which makes it safe to pass a synthetic s2fd->esr value to
> > these functions.
>
> Please split this. ESR helpers in one patch, hacking the MMU code to
> use it in another, s2fd->esr stuff last.

Ack will do!

>
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  arch/arm64/include/asm/esr.h         | 129 +++++++++++++++++++++++++----------
> >  arch/arm64/include/asm/kvm_emulate.h |  52 ++++----------
> >  arch/arm64/kvm/mmu.c                 |  80 +++++++++++++---------
> >  3 files changed, 156 insertions(+), 105 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> > index f816f5d77f1a..162e90c832e9 100644
> > --- a/arch/arm64/include/asm/esr.h
> > +++ b/arch/arm64/include/asm/esr.h
> > @@ -437,6 +437,32 @@
> >  #ifndef __ASSEMBLER__
> >  #include <asm/types.h>
> >
> > +static inline u8 esr_trap_get_class(unsigned long esr)
>
> nit: there is no notion of trap here. This is simply extracting the EC
> from the ESR. My personal (and wholly unreliable) taste would be to go
> for something like esr_get_ec().

Ack will change!

>
> I appreciate that you are simply propagating the names used in KVM,
> but they were pretty poor the first place, and have only been kept to
> avoid churn.

Yeah, when in Rome etc. :)

>
> Also, 'inline' is a bit of a problem given that the callers are
> __always_inline for good reasons (see 5c37f1ae1c3358).

Ack will fix up.

>
> > +{
> > +	return ESR_ELx_EC(esr);
> > +}
> > +
> > +static inline bool esr_trap_is_iabt(unsigned long esr)
> > +{
> > +	return esr_trap_get_class(esr) == ESR_ELx_EC_IABT_LOW;
> > +}
> > +
> > +static inline bool esr_abt_is_s1ptw(unsigned long esr)
> > +{
> > +	return esr & ESR_ELx_S1PTW;
> > +}
> > +
> > +/* Always check for S1PTW *before* using this. */
> > +static inline bool esr_dabt_is_write(unsigned long esr)
> > +{
> > +	return esr & ESR_ELx_WNR;
> > +}
> > +
> > +static inline bool esr_dabt_is_cm(unsigned long esr)
> > +{
> > +	return esr & ESR_ELx_CM;
> > +}
> > +
> >  static inline unsigned long esr_brk_comment(unsigned long esr)
> >  {
> >  	return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
> > @@ -460,75 +486,104 @@ static inline bool esr_is_ubsan_brk(unsigned long esr)
> >  	return (esr_brk_comment(esr) & ~UBSAN_BRK_MASK) == UBSAN_BRK_IMM;
> >  }
> >
> > +static inline u8 esr_fsc_get_fault(unsigned long esr)
> > +{
> > +	return esr & ESR_ELx_FSC;
> > +}
> > +
> >  static inline bool esr_fsc_is_translation_fault(unsigned long esr)
> >  {
> > -	esr = esr & ESR_ELx_FSC;
> > +	const u8 fault = esr_fsc_get_fault(esr);
> >
> > -	return (esr == ESR_ELx_FSC_FAULT_L(3)) ||
> > -	       (esr == ESR_ELx_FSC_FAULT_L(2)) ||
> > -	       (esr == ESR_ELx_FSC_FAULT_L(1)) ||
> > -	       (esr == ESR_ELx_FSC_FAULT_L(0)) ||
> > -	       (esr == ESR_ELx_FSC_FAULT_L(-1));
> > +	return (fault == ESR_ELx_FSC_FAULT_L(3)) ||
> > +	       (fault == ESR_ELx_FSC_FAULT_L(2)) ||
> > +	       (fault == ESR_ELx_FSC_FAULT_L(1)) ||
> > +	       (fault == ESR_ELx_FSC_FAULT_L(0)) ||
> > +	       (fault == ESR_ELx_FSC_FAULT_L(-1));
>
> I really think we could do without this sort of churn.

Sure, will avoid the var name changes etc. on respin.

>
> >  }
> >
> >  static inline bool esr_fsc_is_permission_fault(unsigned long esr)
> >  {
> > -	esr = esr & ESR_ELx_FSC;
> > +	const u8 fault = esr_fsc_get_fault(esr);
> >
> > -	return (esr == ESR_ELx_FSC_PERM_L(3)) ||
> > -	       (esr == ESR_ELx_FSC_PERM_L(2)) ||
> > -	       (esr == ESR_ELx_FSC_PERM_L(1)) ||
> > -	       (esr == ESR_ELx_FSC_PERM_L(0));
> > +	return (fault == ESR_ELx_FSC_PERM_L(3)) ||
> > +	       (fault == ESR_ELx_FSC_PERM_L(2)) ||
> > +	       (fault == ESR_ELx_FSC_PERM_L(1)) ||
> > +	       (fault == ESR_ELx_FSC_PERM_L(0));
> >  }
> >
> >  static inline bool esr_fsc_is_access_flag_fault(unsigned long esr)
> >  {
> > -	esr = esr & ESR_ELx_FSC;
> > +	const u8 fault = esr_fsc_get_fault(esr);
> >
> > -	return (esr == ESR_ELx_FSC_ACCESS_L(3)) ||
> > -	       (esr == ESR_ELx_FSC_ACCESS_L(2)) ||
> > -	       (esr == ESR_ELx_FSC_ACCESS_L(1)) ||
> > -	       (esr == ESR_ELx_FSC_ACCESS_L(0));
> > +	return (fault == ESR_ELx_FSC_ACCESS_L(3)) ||
> > +	       (fault == ESR_ELx_FSC_ACCESS_L(2)) ||
> > +	       (fault == ESR_ELx_FSC_ACCESS_L(1)) ||
> > +	       (fault == ESR_ELx_FSC_ACCESS_L(0));
> >  }
> >
> >  static inline bool esr_fsc_is_excl_atomic_fault(unsigned long esr)
> >  {
> > -	esr = esr & ESR_ELx_FSC;
> > -
> > -	return esr == ESR_ELx_FSC_EXCL_ATOMIC;
> > +	return esr_fsc_get_fault(esr) == ESR_ELx_FSC_EXCL_ATOMIC;
> >  }
> >
> >  static inline bool esr_fsc_is_addr_sz_fault(unsigned long esr)
> >  {
> > -	esr &= ESR_ELx_FSC;
> > +	const u8 fault = esr_fsc_get_fault(esr);
> > +
> > +	return (fault == ESR_ELx_FSC_ADDRSZ_L(3)) ||
> > +	       (fault == ESR_ELx_FSC_ADDRSZ_L(2)) ||
> > +	       (fault == ESR_ELx_FSC_ADDRSZ_L(1)) ||
> > +	       (fault == ESR_ELx_FSC_ADDRSZ_L(0)) ||
> > +	       (fault == ESR_ELx_FSC_ADDRSZ_L(-1));
> > +}
> > +
> > +static inline bool esr_abt_is_exec_fault(unsigned long esr)
> > +{
> > +	return esr_trap_is_iabt(esr) && !esr_abt_is_s1ptw(esr);
> > +}
> >
> > -	return (esr == ESR_ELx_FSC_ADDRSZ_L(3))	||
> > -	       (esr == ESR_ELx_FSC_ADDRSZ_L(2))	||
> > -	       (esr == ESR_ELx_FSC_ADDRSZ_L(1)) ||
> > -	       (esr == ESR_ELx_FSC_ADDRSZ_L(0))	||
> > -	       (esr == ESR_ELx_FSC_ADDRSZ_L(-1));
> > +static inline bool esr_abt_is_sea(unsigned long esr)
> > +{
> > +	const u8 fault = esr_fsc_get_fault(esr);
> > +
> > +	switch (fault) {
> > +	case ESR_ELx_FSC_EXTABT:
> > +	case ESR_ELx_FSC_SEA_TTW(-1) ... ESR_ELx_FSC_SEA_TTW(3):
> > +	case ESR_ELx_FSC_SECC:
> > +	case ESR_ELx_FSC_SECC_TTW(-1) ... ESR_ELx_FSC_SECC_TTW(3):
> > +		return true;
> > +	default:
> > +		return false;
> > +	}
> > +}
> > +
> > +/* Not valid for negative levels. */
> > +static inline u64 esr_fsc_get_level(unsigned long esr)
> > +{
> > +	return esr & ESR_ELx_FSC_LEVEL;
> >  }
>
> If that's such an unreliable helper, why is it exposed to everyone
> instead of being kept local to the single caller?

That's a fair point :) will open code instead.

>
> >
> >  static inline bool esr_fsc_is_sea_ttw(unsigned long esr)
> >  {
> > -	esr = esr & ESR_ELx_FSC;
> > +	const u8 fault = esr_fsc_get_fault(esr);
> >
> > -	return (esr == ESR_ELx_FSC_SEA_TTW(3)) ||
> > -	       (esr == ESR_ELx_FSC_SEA_TTW(2)) ||
> > -	       (esr == ESR_ELx_FSC_SEA_TTW(1)) ||
> > -	       (esr == ESR_ELx_FSC_SEA_TTW(0)) ||
> > -	       (esr == ESR_ELx_FSC_SEA_TTW(-1));
> > +	return (fault == ESR_ELx_FSC_SEA_TTW(3)) ||
> > +	       (fault == ESR_ELx_FSC_SEA_TTW(2)) ||
> > +	       (fault == ESR_ELx_FSC_SEA_TTW(1)) ||
> > +	       (fault == ESR_ELx_FSC_SEA_TTW(0)) ||
> > +	       (fault == ESR_ELx_FSC_SEA_TTW(-1));
> >  }
> >
> >  static inline bool esr_fsc_is_secc_ttw(unsigned long esr)
> >  {
> > -	esr = esr & ESR_ELx_FSC;
> > +	const u8 fault = esr_fsc_get_fault(esr);
> >
> > -	return (esr == ESR_ELx_FSC_SECC_TTW(3)) ||
> > -	       (esr == ESR_ELx_FSC_SECC_TTW(2)) ||
> > -	       (esr == ESR_ELx_FSC_SECC_TTW(1)) ||
> > -	       (esr == ESR_ELx_FSC_SECC_TTW(0)) ||
> > -	       (esr == ESR_ELx_FSC_SECC_TTW(-1));
> > +	return (fault == ESR_ELx_FSC_SECC_TTW(3)) ||
> > +	       (fault == ESR_ELx_FSC_SECC_TTW(2)) ||
> > +	       (fault == ESR_ELx_FSC_SECC_TTW(1)) ||
> > +	       (fault == ESR_ELx_FSC_SECC_TTW(0)) ||
> > +	       (fault == ESR_ELx_FSC_SECC_TTW(-1));
> >  }
> >
> >  /* Indicate whether ESR.EC==0x1A is for an ERETAx instruction */
> > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > index a3c1928bdf74..811d7a68a9f9 100644
> > --- a/arch/arm64/include/asm/kvm_emulate.h
> > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > @@ -411,18 +411,13 @@ static __always_inline int kvm_vcpu_dabt_get_rd(const struct kvm_vcpu *vcpu)
> >
> >  static __always_inline bool kvm_vcpu_abt_iss1tw(const struct kvm_vcpu *vcpu)
> >  {
> > -	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_S1PTW);
> > +	return esr_abt_is_s1ptw(kvm_vcpu_get_esr(vcpu));
> >  }
> >
> >  /* Always check for S1PTW *before* using this. */
> >  static __always_inline bool kvm_vcpu_dabt_iswrite(const struct kvm_vcpu *vcpu)
> >  {
> > -	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_WNR;
> > -}
> > -
> > -static inline bool kvm_vcpu_dabt_is_cm(const struct kvm_vcpu *vcpu)
> > -{
> > -	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_CM);
> > +	return esr_dabt_is_write(kvm_vcpu_get_esr(vcpu));
> >  }
> >
> >  static __always_inline unsigned int kvm_vcpu_dabt_get_as(const struct kvm_vcpu *vcpu)
> > @@ -438,17 +433,12 @@ static __always_inline bool kvm_vcpu_trap_il_is32bit(const struct kvm_vcpu *vcpu
> >
> >  static __always_inline u8 kvm_vcpu_trap_get_class(const struct kvm_vcpu *vcpu)
> >  {
> > -	return ESR_ELx_EC(kvm_vcpu_get_esr(vcpu));
> > +	return esr_trap_get_class(kvm_vcpu_get_esr(vcpu));
> >  }
> >
> >  static inline bool kvm_vcpu_trap_is_iabt(const struct kvm_vcpu *vcpu)
> >  {
> > -	return kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_IABT_LOW;
> > -}
> > -
> > -static inline bool kvm_vcpu_trap_is_exec_fault(const struct kvm_vcpu *vcpu)
> > -{
> > -	return kvm_vcpu_trap_is_iabt(vcpu) && !kvm_vcpu_abt_iss1tw(vcpu);
> > +	return esr_trap_is_iabt(kvm_vcpu_get_esr(vcpu));
> >  }
> >
> >  static __always_inline u8 kvm_vcpu_trap_get_fault(const struct kvm_vcpu *vcpu)
> > @@ -468,26 +458,9 @@ bool kvm_vcpu_trap_is_translation_fault(const struct kvm_vcpu *vcpu)
> >  	return esr_fsc_is_translation_fault(kvm_vcpu_get_esr(vcpu));
> >  }
> >
> > -static inline
> > -u64 kvm_vcpu_trap_get_perm_fault_granule(const struct kvm_vcpu *vcpu)
> > -{
> > -	unsigned long esr = kvm_vcpu_get_esr(vcpu);
> > -
> > -	BUG_ON(!esr_fsc_is_permission_fault(esr));
> > -	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(esr & ESR_ELx_FSC_LEVEL));
> > -}
> > -
> >  static __always_inline bool kvm_vcpu_abt_issea(const struct kvm_vcpu *vcpu)
> >  {
> > -	switch (kvm_vcpu_trap_get_fault(vcpu)) {
> > -	case ESR_ELx_FSC_EXTABT:
> > -	case ESR_ELx_FSC_SEA_TTW(-1) ... ESR_ELx_FSC_SEA_TTW(3):
> > -	case ESR_ELx_FSC_SECC:
> > -	case ESR_ELx_FSC_SECC_TTW(-1) ... ESR_ELx_FSC_SECC_TTW(3):
> > -		return true;
> > -	default:
> > -		return false;
> > -	}
> > +	return esr_abt_is_sea(kvm_vcpu_get_esr(vcpu));
> >  }
> >
> >  static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
> > @@ -496,9 +469,9 @@ static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
> >  	return ESR_ELx_SYS64_ISS_RT(esr);
> >  }
> >
> > -static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
> > +static inline bool esr_abt_is_write_fault(unsigned long esr)
> >  {
> > -	if (kvm_vcpu_abt_iss1tw(vcpu)) {
> > +	if (esr_abt_is_s1ptw(esr)) {
> >  		/*
> >  		 * Only a permission fault on a S1PTW should be
> >  		 * considered as a write. Otherwise, page tables baked
> > @@ -511,13 +484,18 @@ static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
> >  		 * first), then a permission fault to allow the flags
> >  		 * to be set.
> >  		 */
> > -		return kvm_vcpu_trap_is_permission_fault(vcpu);
> > +		return esr_fsc_is_permission_fault(esr);
> >  	}
> >
> > -	if (kvm_vcpu_trap_is_iabt(vcpu))
> > +	if (esr_trap_is_iabt(esr))
> >  		return false;
> >
> > -	return kvm_vcpu_dabt_iswrite(vcpu);
> > +	return esr_dabt_is_write(esr);
> > +}
> > +
> > +static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
> > +{
> > +	return esr_abt_is_write_fault(kvm_vcpu_get_esr(vcpu));
> >  }
> >
> >  static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 74e7e7f7564c..30d605e87b01 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1603,12 +1603,38 @@ struct kvm_s2_fault_desc {
> >  	struct kvm_s2_trans	*nested;
> >  	struct kvm_memory_slot	*memslot;
> >  	unsigned long		hva;
> > +	unsigned long		esr;
> >  };
> >
> > +static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
> > +{
> > +	return esr_fsc_is_permission_fault(s2fd->esr);
> > +}
> > +
> > +static bool kvm_s2_fault_is_exec(const struct kvm_s2_fault_desc *s2fd)
> > +{
> > +	return esr_abt_is_exec_fault(s2fd->esr);
> > +}
> > +
> > +static bool kvm_s2_fault_is_write(const struct kvm_s2_fault_desc *s2fd)
> > +{
> > +	return esr_abt_is_write_fault(s2fd->esr);
> > +}
> > +
> > +static u64 kvm_s2_perm_fault_granule(const struct kvm_s2_fault_desc *s2fd)
> > +{
> > +	u64 level;
> > +
> > +	if (!kvm_s2_fault_is_perm(s2fd))
> > +		return 0;
> > +	level = esr_fsc_get_level(s2fd->esr);
> > +	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
> > +}
> > +
> >  static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
> >  {
> >  	bool write_fault, exec_fault;
> > -	bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
> > +	const bool perm_fault = kvm_s2_fault_is_perm(s2fd);
>
> Please don't randomly introduce const local variables. I understand
> the benefit, but *if* we want to go down that road, then we do it for
> all the predicates, as a separate series, because this obviously
> applies to {exec,write}_fault as well.

Ack, force of habit :) will avoid on respin.

>
> Thanks,
>
> 	M.
>
> --
> Without deviation from the norm, progress is not possible.

--
Cheers, Lorenzo

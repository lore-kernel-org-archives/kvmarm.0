Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0020138F628
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 12:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774357032; cv=none; b=CNkKKFieVeDWi0SX/AGVyAb0XKmUyPEgTTqb/2lohH+CuR+Ge/crvdPshI6pgsUD+aOCh4CJqXOp60n41G1GY/OyRjgYr890eGDaGwQLLYS00v3eSc7oF+pgBXT8NHohMgEnz6Ck69Zu2pLl8VuF3uCsgd7MKu+ydp5jpQgGuDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774357032; c=relaxed/simple;
	bh=cbQdQbNvEjdIsfIpzc+tru+4caZBQorrCrsoyo8asdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ff/Y7Nl4jPYTTGrVDKOGtpUYqI/C4c+tY7UxWl/idBbSxSeH4GpURvJjIzVZJ0FC20C/8ucRvzSBcWWvDZGaMRFjB+bSSTryFMBJEMYH/oLlQYDFwlz8du7qtB4J4rSESoJ4ePcowOAgO22bUK+Sk7cg1Z2K2hIVzgxFXlB0ueU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=roaqIxhv; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="roaqIxhv"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 315DA1476;
	Tue, 24 Mar 2026 05:57:03 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 782DF3FAF5;
	Tue, 24 Mar 2026 05:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774357029; bh=cbQdQbNvEjdIsfIpzc+tru+4caZBQorrCrsoyo8asdM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=roaqIxhv41RmoMelSoBtZ+5Kn4t7Tu0gWq6OFEOOCOsmoUfL0FsoV/kbE0tFhFFe8
	 UEkk5hLW69Hp43KhFev3lmo8PiMr1t7QdbFOqGQXCkH6Dym8FxYSCxqlF17cNT7CGv
	 NhWkXrWFbybl2dJS/M9RltJlX5xXSOqsjXALGq+0=
Date: Tue, 24 Mar 2026 12:56:56 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 5/5] KVM: arm64: Add SMC hook for SME dvmsync erratum
Message-ID: <acKKGJG-MUm6TxOm@arm.com>
References: <20260323162408.4163113-1-catalin.marinas@arm.com>
 <20260323162408.4163113-6-catalin.marinas@arm.com>
 <acJkEEXKt_GunFLQ@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acJkEEXKt_GunFLQ@google.com>

On Tue, Mar 24, 2026 at 10:14:40AM +0000, Vincent Donnefort wrote:
> On Mon, Mar 23, 2026 at 04:24:05PM +0000, Catalin Marinas wrote:
> > From: James Morse <james.morse@arm.com>
> > 
> > C1-Pro cores with SME have an erratum where TLBI+DSB does not complete
> > all outstanding SME accesses. Instead a DSB needs to be executed on the
> > affecteed CPUs. The implication is pages cannot be unmapped from the
> > host stage2 then provided to the guest. Host SME accesses may occur
> > after this point.
> > 
> > This erratum breaks pKVM's guarantees, and the workaround is hard to
> > implement as EL2 and EL1 share a security state meaning EL1 can mask
> > IPI sent by EL2, leading to interrupt blackouts.
> > 
> > Instead, do this in EL3. This has the advantage of a separate security
> > state, meaning lower EL cannot mask the IPI. It is also simpler for EL3
> > to know about CPUs that are off or in PSCI's CPU_SUSPEND.
> > 
> > Add the needed hook.
> > 
> > Signed-off-by: James Morse <james.morse@arm.com>
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Oliver Upton <oupton@kernel.org>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>
> > Cc: Sudeep Holla <sudeep.holla@kernel.org>
> 
> In case this goes in before Will's p-guest series and with just a small comment
> below:
> 
> Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

Thanks.

I can leave this patch for later, maybe merge it after -rc1.

> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 38f66a56a766..ef8afbdd421b 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -5,6 +5,8 @@
> >   */
> >  
> >  #include <linux/kvm_host.h>
> > +#include <linux/arm-smccc.h>
> > +
> >  #include <asm/kvm_emulate.h>
> >  #include <asm/kvm_hyp.h>
> >  #include <asm/kvm_mmu.h>
> > @@ -28,6 +30,15 @@ static struct hyp_pool host_s2_pool;
> >  static DEFINE_PER_CPU(struct pkvm_hyp_vm *, __current_vm);
> >  #define current_vm (*this_cpu_ptr(&__current_vm))
> >  
> > +static void pkvm_sme_dvmsync_fw_call(void)
> > +{
> > +	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_4193714)) {
> > +		struct arm_smccc_res res;
> > +
> > +		arm_smccc_1_1_smc(ARM_SMCCC_CPU_WORKAROUND_4193714, &res);
> 
> With hyp tracing in kvmarm/next, this should be hyp_smccc_1_1_smc().

One more reason to leave it after -rc1.

-- 
Catalin

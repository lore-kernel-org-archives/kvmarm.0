Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B512E06E4;
	Fri,  2 Oct 2026 11:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790941856; cv=none; b=DPKrxK4eheV+Ot4f/akTXpg7wMH1Io3zl0v3KiVvK055zQwFJdXOTQ7X4JQte/E0JriaiQOZZ2DoxdW+RT16tAywz1v+CoUxaXSEw7Eqm32VFTx3HGSTCF9mDj7odZdy//5TxaFj/RzNl5p1bDoFQGUIwzRgFFLU43xwc2AIhB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790941856; c=relaxed/simple;
	bh=8zE6sZ62hufQRzjaqCFx/CKw4ZoK1riQkDJmFmhna4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TpIjZxueAeS41d1LynN7oNWpKtua5dQ0lO3eI3r9JgOim5wh96bCpSN0ZvbonJvksT3uyk7VLFZ9LUp50LPYOYtV1X1Ki1oncvXlDz3AOCKiDGKCiTansijzQXnpXVhPacLAkKcmNZRlGL7O0QSZ+yDRUb4DdxHcqYiiFgdLZk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hv/cbbP/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hv/cbbP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAD61F000FF;
	Fri,  2 Oct 2026 11:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790941854;
	bh=TNIqItMeAufPumNs79NYW3dgscKCUX9sisD/E7hNJnU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Hv/cbbP/HIrtze3kRTnp+L1uL6mF8s/alL0s1lApvKA7IgNBrJTyWQ+ceCSyCrkwb
	 DQAMVzQPUjLNA032sGqDch+DQEbjLtYuKi2uthMbN5kLSdIQy+KtOrSYgkN0UpmiMa
	 59OBwQIBx2sMNgJrbn6yk9vUgmosutjbLskqMRbDecviaiXWT1rc/sq7ha1bNCkMgJ
	 lvUw8X/KV1/KvTDtriDODMPR2g/TSwFFqB8Hqb4W6jNzyVCEibDhip6WN6ac0+/Zrg
	 64Oik4Cbl9nLjO5kUJIq9yCeRhQ0XgLc+EZdGYO0gt32om8GZDm8iHJRANzbmMG9Ly
	 3NdDJJMcwKQ7A==
Date: Fri, 2 Oct 2026 12:50:48 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v21 08/15] KVM: arm64: Enforce EXLOCK for SPSR and ELR
Message-ID: <ar-UxijB8qEtp4DV@gremlin>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-8-3556644cd927@kernel.org>
 <ar5thpZI5GiCfVRR@gremlin>
 <659cba01-3c53-4eb8-9124-7c62d266a64f@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <659cba01-3c53-4eb8-9124-7c62d266a64f@sirena.org.uk>

On Thu, Oct 01, 2026 at 10:11:49PM +0100, Mark Brown wrote:
> On Thu, Oct 01, 2026 at 05:26:41PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Sep 30, 2026 at 10:48:18PM +0100, Mark Brown wrote:
> > > As per I_CFFNS and the pseudocode for the SPSR_ELx and ELR_ELx registers
> > > a GCS exception with ExType 1 is generated for attempts to write to
> > > those registers when both GCSCR_ELx.EXLOCKEN and PSTATE.EXLOCK are set.
>
> > From [4] I see I_CFFNS is defined as:
>
> > "When an MSR instruction would write to the relevant ELR_ELx or SPSR_ELx
> > for the current Exception level ELy, the Effective value of
> > GCSCR_ELy.EXLOCKEN and PSTATE.EXLOCK may prevent the write."
>
> > So the lock applies to writes to the current EL's own ELR/SPSR rather than
> > to any ELR_ELx/SPSR_ELx the current EL can write to?
>
> VHE and NV complicate things so "own" isn't just the same ELx, but my
> text above definitely oversimplifies too much and so is wrong.

It's all incredibly tricky and I felt my brain melting out of my head going
through the psuedocode/definition yesterday so it's understandable :)

>
> For example refering to the pseudocode for ELR_EL1 and SPSR_EL1 we see
> in the MSR handling:
>
>   elsif PSTATE.EL == EL2 then
>       if IsFeatureImplemented(FEAT_GCS) && GetCurrentEXLOCKEN() && !Halted() && PSTATE.EXLOCK == '1' && ELIsInHost(EL2) then
>           EXLOCKException();
>
> and note the use of ELx for ELR/SPSR and ELy for the current exception
> level and GCSCR in I_CFFNS (ie, ELx vs ELy).  My interpretation here is
> that the use of "the relevant" rather than just using ELx throughout is
> an effort to cover the complications resulting from VHE and NV.  With
> the above pseudocode writes to the EL1 register from EL2 are also
> covered when we're in host mode - the fact that we're in host mode makes
> the EL1 access relevant.

Yeah agreed.

>
> I'll reword what I've written in the commit log, like I say it's wrong.

Ack thanks!

>
> > So... TL;DR is, shouldn't this function look like:
> >
> > static inline bool sysregs_exlocked(struct kvm_vcpu *vcpu)
> > {
> > 	if (!kvm_has_gcs(vcpu->kvm))
> > 		return false;
> >
> > 	if (!(vcpu->arch.ctxt.regs.pstate & PSR_EXLOCK_BIT))
> > 		return false;
> >
> > 	if (is_hyp_ctxt(vcpu))
> > 		return false;
> >
> > 	return vcpu_read_sys_reg(vcpu, GCSCR_EL1) & GCSCR_ELx_EXLOCKEN;
> > }
>
> I think so, but I'll check through again.

Thanks!

>
> The confusions you identified in the bit of your mail above this were
> the result of me doing some but on all of the simplifications.  I was
> trying to make things clearer by including some code that couldn't run
> so it was more obvious that things correspond to the pseudocode, but
> really that shouldn't have had any simplifications in it - we should
> either have all the simplifications or none of them.  I'll add more
> comments instead.

Yeah it's all very complicated, unfortunately I think, the psuedocode had me
stumped a lot when I was reading it...

Definitely agree on all-or-nothing. If we did go the 'all' route, then we'd
need to put in the ELIsInHost(EL2) conditional too
i.e. vcpu_el2_e2h_is_set() as well.

But I think simplifying that is also valid, as the resultant function above
is a lot easier to reason about and avoids people having to figure out that
certain bits are irrelevant (though comments could square that off too!)

>
> > > +	/*
> > > +	 * Note that the EXLOCKEN for the running EL is checked
> > > +	 * regardless of the register written to.
> > > +	 */
> >
> > This seems to contradict [4] - the register written to is what decides
> > whether the lock applies?
>
> [4] is section D11.4.1 of DDI0487 M.d, containing rule I_CFFNS discussed
> above.  My intent there is to express that if EXLOCK exceptions might be
> generated we check EXLOCKEN for the running EL, not one influenced by
> the written register.  Some combinations of register, EL and system
> state do not generate exceptions but those that do use the current EL's
> EXLOCKEN rather than an _ELx register using GCSCR_ELx.EXLOCKEN.

Yeah that's clear thanks!

IOW - the register/El/state decides _whether_ an exception can be raised,
the running EL's EXLOCKEN is what is consulted _when_ it can be raised.

--
Cheers, Lorenzo

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7BE33993
	for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 17:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771263150; cv=none; b=XbDzCZjaOdB2Vniu4Flzt4YUY47sfkmvkWbG/wX42TioE9cuNqM0crZyqjVV/cjm025qHOlRK0eUWz304Ve+3jgwHJb7aEEi3QEGR2CZgF6G/UHhsjqeIgLokCJPqdZMYmVJ1/0B9TuYfBj47PJIOCgzFV9yAK2PXthnZhhYMaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771263150; c=relaxed/simple;
	bh=daXkrVP5UJSKqHcyvrYKQC3kHzFoAGH19SRRs/ALmsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VU2pqqY+tASZloPBjrko8Wlz2p0MoTVVI7j5mmvvf/bSJ5UDmY/OMWaDBxX4cKecEFVH2HF66FKMfypD2cSPwzLmo97u5EM9Heks7/I2+6rf8vnyP6oCoY21G9ydDWIYcP6CL6Tn+7GEZlKmY9+bMlTN2uaqfpgaOUvxGdWyJEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EDgBe69S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EDgBe69S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A62BC116C6;
	Mon, 16 Feb 2026 17:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771263150;
	bh=daXkrVP5UJSKqHcyvrYKQC3kHzFoAGH19SRRs/ALmsc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EDgBe69SinGEbf8HSF7dtDezT09qbDp97bUbuQ4R8oWnC4DQNMxnoaZ0ThLv0O2eZ
	 wqiTy7tcQTGyFDH6kqMH+pXD6ICqk27TIJoZA5fM4eNlFh9PNPJJVtImgxxKd8h/kk
	 DaF83HW24d9bctuQkfNskFycxOkj+lQcHXC9XG6uUkhZjjyLYljamiR1ph1Ie13Nsy
	 BAB0rKy9gCfmF6nyRK3g/gqOxfsQiOoTxp+Fra4cPeGCp49JZb+Z9SC2SFNbtTifNk
	 z2tGEjzzrri779SRbmuZaoAKOOk10SzLLij9TMjoGSag/FofHJJk83qR+Op7w4KnpK
	 F53QXyGhliyMA==
Date: Mon, 16 Feb 2026 17:32:24 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>,
	James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: arm64: Disable TRBE Trace Buffer Unit when running
 in guest context
Message-ID: <aZNUqONyOUVd0opW@willie-the-truck>
References: <20260216130959.19317-1-will@kernel.org>
 <86a4x8bw38.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86a4x8bw38.wl-maz@kernel.org>

On Mon, Feb 16, 2026 at 02:29:31PM +0000, Marc Zyngier wrote:
> On Mon, 16 Feb 2026 13:09:59 +0000,
> Will Deacon <will@kernel.org> wrote:
> > 
> > The nVHE world-switch code relies on zeroing TRFCR_EL1 to disable trace
> > generation in guest context when self-hosted TRBE is in use by the host.
> > 
> > Per D3.2.1 ("Controls to prohibit trace at Exception levels"), clearing
> > TRFCR_EL1 means that trace generation is prohibited at EL1 and EL0 but
> > per R_YCHKJ the Trace Buffer Unit will still be enabled if
> > TRBLIMITR_EL1.E is set. R_SJFRQ goes on to state that, when enabled, the
> > Trace Buffer Unit can perform address translation for the "owning
> > exception level" even when it is out of context.
> 
> Great. So TRBE violates all the principles that we hold true in the
> architecture. Does SPE suffer from the same level of brokenness?
> 
> > Consequently, we can end up in a state where TRBE performs speculative
> > page-table walks for a host VA/IPA in guest/hypervisor context depending
> > on the value of MDCR_EL2.E2TB, which changes over world-switch. The
> > result appears to be a heady mixture of data corruption and hardware
> > lockups.
> >
> > Extend the TRBE world-switch code to clear TRBLIMITR_EL1.E after
> > draining the buffer, restoring the register on return to the host.
> > 
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Oliver Upton <oupton@kernel.org>
> > Cc: James Clark <james.clark@linaro.org>
> > Cc: Leo Yan <leo.yan@arm.com>
> > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Cc: Fuad Tabba <tabba@google.com>
> > Fixes: a1319260bf62 ("arm64: KVM: Enable access to TRBE support for host")
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> > 
> > NOTE: This is *untested* as I don't have a TRBE-capable device that can
> > run upstream but I noticed this by inspection when triaging occasional
> > hardware lockups on systems using a 6.12-based kernel with TRBE running
> > at the same time as a vCPU is loaded. This code has changed quite a bit
> > over time, so stable backports are not entirely straightforward.
> > Hopefully James/Leo/Suzuki can help us test if folks agree with the
> > general approach taken here.
> > 
> >  arch/arm64/include/asm/kvm_host.h  |  1 +
> >  arch/arm64/kvm/hyp/nvhe/debug-sr.c | 36 ++++++++++++++++++++++--------
> >  2 files changed, 28 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index ac7f970c7883..a932cf043b83 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -746,6 +746,7 @@ struct kvm_host_data {
> >  		u64 pmscr_el1;
> >  		/* Self-hosted trace */
> >  		u64 trfcr_el1;
> > +		u64 trblimitr_el1;
> >  		/* Values of trap registers for the host before guest entry. */
> >  		u64 mdcr_el2;
> >  		u64 brbcr_el1;
> > diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> > index 2a1c0f49792b..fd389a26bc59 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> > @@ -57,12 +57,27 @@ static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
> >  	write_sysreg_el1(new_trfcr, SYS_TRFCR);
> >  }
> >  
> > -static bool __trace_needs_drain(void)
> > +static void __trace_drain_and_disable(void)
> >  {
> > -	if (is_protected_kvm_enabled() && host_data_test_flag(HAS_TRBE))
> > -		return read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E;
> > +	u64 *trblimitr_el1 = host_data_ptr(host_debug_state.trblimitr_el1);
> >  
> > -	return host_data_test_flag(TRBE_ENABLED);
> > +	*trblimitr_el1 = 0;
> > +
> > +	if (is_protected_kvm_enabled()) {
> > +		if (!host_data_test_flag(HAS_TRBE))
> > +			return;
> > +	} else {
> > +		if (!host_data_test_flag(TRBE_ENABLED))
> > +			return;
> > +	}
> > +
> > +	*trblimitr_el1 = read_sysreg_s(SYS_TRBLIMITR_EL1);
> > +	if (*trblimitr_el1 & TRBLIMITR_EL1_E) {
> > +		isb();
> > +		tsb_csync();
> > +		write_sysreg_s(0, SYS_TRBLIMITR_EL1);
> > +		isb();
> > +	}
> 
> Doesn't this mean we should be able to get rid of most of the TRFCR
> messing about that litters the entry/exit code and leave that to VHE
> only?

I'm not sure we can get rid of an awful lot: if the host is using TRBE,
then we still need to stop trace generation, drain the buffer and
disable the buffer. Or are you thinking of some other TRFCR accesses?

Looking at the TRBE driver, I _think_ the idea is that the trace
hardware can generate trace to ETM/Coresight instead of memory in some
cases and so you can enable it at boot time or via sysfs and then
profile the whole machine, presumably using an expensive external box +
cable or via some other coresight "sink" component. But I'm really
guessing based on the driver; James and Leo will know for sure.

I've tried (and failed) to reconcile the above with what is written in
the Arm ARM regarding self-hosted trace with TRBE.

> And even then, I'm tempted to simply get rid of any sort of
> guest-only tracing, given that TRBE is not capable of representing
> exceptions that are synthesised by the host, making it the resulting
> traces useless.

I think that effectively means reverting the series merged from here:

https://lore.kernel.org/all/20250106142446.628923-1-james.clark@linaro.org/

but then we still need to clear TRBLIMITR_EL1.E.

Will

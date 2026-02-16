Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034DD17A2F6
	for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 17:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771261560; cv=none; b=gAzKx9xxqsKWOM+TJW7Qi/rdsK4YSlewg0wDoBAR1IFVMHNyvBXr0yDGjJ7cJCXkr07u9ETfPw4dBET5Or88P7jkepG0t2aLmCa5CrwRbbcMMBBKr4SFwqnRwBdjNXISw1eK7J6uJZ/gymUoSsg6QcgipR2Xsoljmvn+SnwvW98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771261560; c=relaxed/simple;
	bh=WZre1OzmSFXuIxVbmE23zObgowTy0L0he5FkW3BHZ+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VHrjPayR0G0F7Nen24LsSRec4Nm6b80n3bOLfLtA4ohT4qfEeQW84OXEX7TxoCMG1HHCh3nXV5ounLEGyzGy31BebnibIp9dDngNHgaf5TnptSyzOqUzlqXfQJT10auKPi5MlSfGKlv02BDFviWrbKQcymmHSD6k2uywJK+B2Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CquNvMmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CquNvMmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6515C116C6;
	Mon, 16 Feb 2026 17:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771261559;
	bh=WZre1OzmSFXuIxVbmE23zObgowTy0L0he5FkW3BHZ+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CquNvMmPT58a9dWKW9fQVK49sqQQ50xxE8G+FpljgDBX2nOe2pK0ZeKq9l/n+SGFs
	 fmBPr7RE6gt/aUC52QWWcyhmDnIIPWARJYIpRHjFuddnhqLij/PHg402b7MGpPo3cG
	 vslqpMRCkXHrgXjGPBWUU2fAm1NsPwoAJvBGEu2cNyXVzLul2lSGy5yGI3aCPN6TB2
	 yA3bl+gJrXl07XIMHYQD/bUlDZGPkldLzKckc+pyCh+6FfEsbSe6GXGiinazyf84QY
	 pmtunoIPchbNseshfDc8EZ3ZHwx+25aOqVhFxr3X2+zw0KLe1MwBPvA6pfkn++t3qs
	 XRJkn/+UpqyJw==
Date: Mon, 16 Feb 2026 17:05:54 +0000
From: Will Deacon <will@kernel.org>
To: James Clark <james.clark@linaro.org>
Cc: kvmarm@lists.linux.dev, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: arm64: Disable TRBE Trace Buffer Unit when running
 in guest context
Message-ID: <aZNOcv2XxTrrrEnU@willie-the-truck>
References: <20260216130959.19317-1-will@kernel.org>
 <878e304e-4162-4981-8125-bd4f67ba9dd5@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878e304e-4162-4981-8125-bd4f67ba9dd5@linaro.org>

On Mon, Feb 16, 2026 at 03:13:54PM +0000, James Clark wrote:
> 
> 
> On 16/02/2026 1:09 pm, Will Deacon wrote:
> > The nVHE world-switch code relies on zeroing TRFCR_EL1 to disable trace
> > generation in guest context when self-hosted TRBE is in use by the host.
> > 
> > Per D3.2.1 ("Controls to prohibit trace at Exception levels"), clearing
> > TRFCR_EL1 means that trace generation is prohibited at EL1 and EL0 but
> > per R_YCHKJ the Trace Buffer Unit will still be enabled if
> > TRBLIMITR_EL1.E is set. R_SJFRQ goes on to state that, when enabled, the
> > Trace Buffer Unit can perform address translation for the "owning
> > exception level" even when it is out of context.
> > 
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
> >   arch/arm64/include/asm/kvm_host.h  |  1 +
> >   arch/arm64/kvm/hyp/nvhe/debug-sr.c | 36 ++++++++++++++++++++++--------
> >   2 files changed, 28 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index ac7f970c7883..a932cf043b83 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -746,6 +746,7 @@ struct kvm_host_data {
> >   		u64 pmscr_el1;
> >   		/* Self-hosted trace */
> >   		u64 trfcr_el1;
> > +		u64 trblimitr_el1;
> >   		/* Values of trap registers for the host before guest entry. */
> >   		u64 mdcr_el2;
> >   		u64 brbcr_el1;
> > diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> > index 2a1c0f49792b..fd389a26bc59 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> > @@ -57,12 +57,27 @@ static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
> >   	write_sysreg_el1(new_trfcr, SYS_TRFCR);
> >   }
> > -static bool __trace_needs_drain(void)
> > +static void __trace_drain_and_disable(void)
> >   {
> > -	if (is_protected_kvm_enabled() && host_data_test_flag(HAS_TRBE))
> > -		return read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E;
> > +	u64 *trblimitr_el1 = host_data_ptr(host_debug_state.trblimitr_el1);
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
> >   }
> >   static bool __trace_needs_switch(void)
> > @@ -79,15 +94,18 @@ static void __trace_switch_to_guest(void)
> >   	__trace_do_switch(host_data_ptr(host_debug_state.trfcr_el1),
> >   			  *host_data_ptr(trfcr_while_in_guest));
> > -
> > -	if (__trace_needs_drain()) {
> > -		isb();
> > -		tsb_csync();
> > -	}
> > +	__trace_drain_and_disable();
> >   }
> >   static void __trace_switch_to_host(void)
> >   {
> > +	u64 trblimitr_el1 = *host_data_ptr(host_debug_state.trblimitr_el1);
> > +
> > +	if (trblimitr_el1 & TRBLIMITR_EL1_E) {
> > +		write_sysreg_s(trblimitr_el1, SYS_TRBLIMITR_EL1);
> 
> Will this restore a stale value if you do kvm_enable_trbe() then later
> kvm_disable_trbe()? Looks like the read and save will be skipped unless
> host_data_test_flag(TRBE_ENABLED) is true, so it will never save a disabled
> value.

__trace_drain_and_disable() sets the saved limit to 0 if TRBE_ENABLE is
not set, so this shouldn't do anything in that case. Or did I
misunderstand your scenario?

> kvm_disable_trbe() might need to clear host_debug_state.trblimitr_el1.

pKVM can't rely on that thing being called, so the context switch still
needs to be self-contained there.

Will

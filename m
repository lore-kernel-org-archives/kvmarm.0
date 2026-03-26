Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F877224B15
	for <kvmarm@lists.linux.dev>; Thu, 26 Mar 2026 12:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774529397; cv=none; b=re6VR65GgQnCO431txE4JB3D20I0UgTELf2vTEzfSN16tZhfnbEPcv1mUvUEif+1AKcyaNkn73detlS2hP+Wig1n1ITT+zs1azIR+7bBW96AEic6OOThEpQFU6sb+yLtKVJn+cFEXFN1LV/K7As3DhEnOP9poAgiucng9c6LMbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774529397; c=relaxed/simple;
	bh=9EnC73UJMvC+ggET7kvHMNECqIIbpyprn+Rs/3zGlU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y1R0/5JWz4OkrkISbzkxUOKdErmu3+1GHtMTv8xBEv4ZHB1YkWEJ4VCgp4ywYRitCjX0yyPjTdYWDEVsaKAvYLF6efcyckue94lfDD54EEehieCekD40fZNeYD/5dLwek1qdth/UEtqq2sPMDjAjAeJI+q3Nrnp9TlCB1bKu/OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZA/05io3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZA/05io3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC68AC116C6;
	Thu, 26 Mar 2026 12:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774529396;
	bh=9EnC73UJMvC+ggET7kvHMNECqIIbpyprn+Rs/3zGlU4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZA/05io3UVQH3utmerGfUMGXTXoc6wRUaGANt/ShbFdUtShd4kUt0y2DfIV9boYnd
	 YIPUqpJDlb1Ce0dDhXf/FAclEOjg+ZckMkqJEmz1UA8cOvQXFmr3SOfVQMFOqQx92i
	 ItAcQhogrjFcPhwwP3yJh4XmduD0A4szO0RqjG+gM10NqrWXs9KXE+q98xhmmnR7sO
	 sWUskyqUrGxCyPI7p4teIxRK2ZYIYV4rqxuZ7V66Gzm7YZu/2ZBifz9Ztx32MKBcft
	 b+iq+1Emk+kCA8BYyyCj3hca1NHn+i63Nw7hm60q2uHve0O2i8UdtvKbPvQt96TNGM
	 /nPtGNT20LTCQ==
Date: Thu, 26 Mar 2026 12:49:51 +0000
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Yabin Cui <yabinc@google.com>
Subject: Re: [PATCH v2 1/3] KVM: arm64: Disable TRBE Trace Buffer Unit when
 running in guest context
Message-ID: <acUrb1WX9M9eMXIV@willie-the-truck>
References: <20260227212136.7660-1-will@kernel.org>
 <20260227212136.7660-2-will@kernel.org>
 <CA+EHjTxcc2FArmi1hu17LW3BHUZ5zTnqbaQP0kbV39HXZfp9+Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTxcc2FArmi1hu17LW3BHUZ5zTnqbaQP0kbV39HXZfp9+Q@mail.gmail.com>

On Wed, Mar 25, 2026 at 07:27:32PM +0000, Fuad Tabba wrote:
> On Fri, 27 Feb 2026 at 21:22, Will Deacon <will@kernel.org> wrote:
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
> >
> > Consequently, we can end up in a state where TRBE performs speculative
> > page-table walks for a host VA/IPA in guest/hypervisor context depending
> > on the value of MDCR_EL2.E2TB, which changes over world-switch. The
> > potential result appears to be a heady mixture of SErrors, data
> > corruption and hardware lockups.
> >
> > Extend the TRBE world-switch code to clear TRBLIMITR_EL1.E after
> > draining the buffer, restoring the register on return to the host. This
> > unfortunately means we need to tackle CPU errata #2064142 and #2038923
> > which add additional synchronisation requirements around manipulations
> > of the limit register. Hopefully this doesn't need to be fast.
> >
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Oliver Upton <oupton@kernel.org>
> > Cc: James Clark <james.clark@linaro.org>
> > Cc: Leo Yan <leo.yan@arm.com>
> > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Cc: Fuad Tabba <tabba@google.com>
> > Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> > Fixes: a1319260bf62 ("arm64: KVM: Enable access to TRBE support for host")
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_host.h  |  1 +
> >  arch/arm64/kvm/hyp/nvhe/debug-sr.c | 73 ++++++++++++++++++++++++++----
> >  arch/arm64/kvm/hyp/nvhe/switch.c   |  2 +-
> >  3 files changed, 66 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 5d5a3bbdb95e..1532ad2b2ec2 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -770,6 +770,7 @@ struct kvm_host_data {
> >                 u64 pmscr_el1;
> >                 /* Self-hosted trace */
> >                 u64 trfcr_el1;
> > +               u64 trblimitr_el1;
> >                 /* Values of trap registers for the host before guest entry. */
> >                 u64 mdcr_el2;
> >                 u64 brbcr_el1;
> > diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> > index 2a1c0f49792b..3dbdee1148d3 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> > @@ -57,12 +57,56 @@ static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
> >         write_sysreg_el1(new_trfcr, SYS_TRFCR);
> >  }
> >
> > -static bool __trace_needs_drain(void)
> > +static void __trace_drain_and_disable(void)
> >  {
> > -       if (is_protected_kvm_enabled() && host_data_test_flag(HAS_TRBE))
> > -               return read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E;
> > +       u64 *trblimitr_el1 = host_data_ptr(host_debug_state.trblimitr_el1);
> >
> > -       return host_data_test_flag(TRBE_ENABLED);
> > +       *trblimitr_el1 = 0;
> > +
> > +       if (is_protected_kvm_enabled()) {
> > +               if (!host_data_test_flag(HAS_TRBE))
> > +                       return;
> > +       } else {
> > +               if (!host_data_test_flag(TRBE_ENABLED))
> > +                       return;
> > +       }
> 
> Can we simplify this? e.g.,
> 
> +      bool needs_drain = is_protected_kvm_enabled() ?
> host_data_test_flag(HAS_TRBE) : host_data_test_flag(TRBE_ENABLED);
> ....

Good idea. I tend to avoid 'bool's as they often make the code less
readable in my experience, but in this case it would be a lot better
than the nested conditionals I have. I'll spin a v3!

> That said:
> 
> Tested-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,

Will

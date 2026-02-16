Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ADCF2690EC
	for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 15:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771257243; cv=none; b=tXGRxoc5Swx6aUuo8KhrUl6D0CwZRfBulmHBflygiR3ObR6UkYP032QtCtn4fSLWehK2rCjvxWqz6kuwJc7VKvXHO8i6U75lGv74UwkGJ6B0Tvwm8ghrIuL7Gd5jHVD2NmBetv/xXUvKbS0kqyK+81xdAmQLvlACn1YljtTbCC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771257243; c=relaxed/simple;
	bh=TZ1gx57E4q6N8jNTPj6ZWHVzUrvETv9sDbzc2Y+0MM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hyhM0QwZfMJvaLVk/Azt6wkrkEDX0Uk34AH/MG3xBYAcSeOu0gGcFfSzlSQV7zE6e/NmTVXgURd41teVYtSsxsZro0prufJFFiOyQm2fEEWx959Z9LkNY5+Lrm91yjW9AfFTPKUMftI59dZdnOFvrhd5nlaq2+UpMy5ZlCIPL38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4977C1576;
	Mon, 16 Feb 2026 07:53:54 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1D17E3F6A8;
	Mon, 16 Feb 2026 07:53:57 -0800 (PST)
Date: Mon, 16 Feb 2026 15:53:54 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>,
	James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: arm64: Disable TRBE Trace Buffer Unit when running
 in guest context
Message-ID: <aZM9kv9X5KjeM94j@raptor>
References: <20260216130959.19317-1-will@kernel.org>
 <86a4x8bw38.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86a4x8bw38.wl-maz@kernel.org>

Hi,

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

I think not currently - I_JZRDG from DDI0487M.a.a says that after a PSB + DSB
'no new memory accesses using the lower Exception level translation table
entries occur'.

But looks like the behaviour will be changed so that it will be similar to TRBE,
according to the Arm known issues document [1], added in D23136:

'When the Proﬁling Buﬀer is enabled, proﬁling is not stopped, and Discard mode
is not enabled, the Statistical Proﬁling Unit might cause speculative
translations for the owning translation regime, including when the owning
translation regime is out-of-context'.

[1] https://developer.arm.com/documentation/102105/latest/

Thanks,
Alex

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
> only? And even then, I'm tempted to simply get rid of any sort of
> guest-only tracing, given that TRBE is not capable of representing
> exceptions that are synthesised by the host, making it the resulting
> traces useless.
> 
> I'm still trying to get my hands on a TRBE-enabled system that has
> some actual firmware tables (my O6 seems to have the HW, but no
> description of the required coresight infra).
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 

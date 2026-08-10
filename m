Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 661B5367F41;
	Mon, 10 Aug 2026 19:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786388415; cv=none; b=CWIaPK4Jzutss42ZG58HFk6WaPcyzyL83N6Qjbs7vzkSN8ywFF2p8cgZxSzVQ33QjtuosDOXKv10nJadWUkeHGJHVCVBNn8l2rIMx2HuPX2OzarkLEo84zE1g5jWWwLudWArNaO0sGdT8ciJeiecdr4uE9E7xSKm8SE3ZhuZNuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786388415; c=relaxed/simple;
	bh=U/jF6v9qP06JsWOI9lupqfGBJ2l9NBq9KuukzX6A27k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dgr/Wt83j3x5VVYwJEshC4Ptz8ib0jnGTOC93JyhdeJQehXtwmPQxQjzMyJ7m3/6kYhU0/DFE3w41HZ4wvySd0qYt2rCK3c6NaKbvtdiy9VnX7aWUllIpX6BTn7NId9eaMyG3UQ9w3o5OiqaHSAfgaQ9Nl4/ratkMy0uYubCvLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rO7JbiIn; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rO7JbiIn"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D52514BF;
	Mon, 10 Aug 2026 12:00:07 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5B30A3F86F;
	Mon, 10 Aug 2026 12:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786388411; bh=U/jF6v9qP06JsWOI9lupqfGBJ2l9NBq9KuukzX6A27k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rO7JbiIn8ep5iQSq0LaahxSLEMPDguK3ahGIPB3EJWkyyIX7bEPaY8tvW9DvUv2mP
	 5ssevyqLKeEBYof8+hVeKzQRhlEBSJ55W7H1jClOIBlLJ+1CS9aAYLca5Idm/H9tBV
	 SGGhYMy/t3tezrLSxbNyBWna9TXqdi5EYruW83lk=
Date: Mon, 10 Aug 2026 19:59:52 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: sashiko-reviews@lists.linux.dev, Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH] KVM: arm64: Correctly cap TLBI Range to the architural
 limit
Message-ID: <kepali2qvsom3x55qfdsvsf6vs6vcg3ubkz6zisjfoncrwsvaq@5nftl3thh7i2>
References: <20260810170616.746100-1-maz@kernel.org>
 <20260810174309.52D041F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260810174309.52D041F000E9@smtp.kernel.org>

On Mon, Aug 10, 2026 at 05:43:08PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> 
> New issues:
> - [High] Hardcoded BIT(48) cap truncates valid 52-bit IPAs and underflows for higher addresses
> - [High] Upper-half range cap `~base + 1` is completely ineffective due to missing sign-extension
> 
> Pre-existing issues:
> - [High] Range TLB invalidations for upper-half VAs silently fail to invalidate the VNCR cache
> - [High] Malicious guests can still trigger a host WARN_ON because the BIT(48) cap ignores smaller VM ia_bits
> --
> 
> --- Patch [1]: [PATCH] KVM: arm64: Correctly cap TLBI Range to the architural limit ---
> commit 09ab12a5dd613f7e322a9123897db5c50369508d
> Author: Marc Zyngier <maz@kernel.org>
> 
> KVM: arm64: Correctly cap TLBI Range to the architural limit
> 
> This commit caps the range of a TLB invalidation based on the base address
> to prevent guests from triggering an overflow when the hypervisor adds the
> range to the base address.
> 
> Link: https://lore.kernel.org/r/yifz3wn5gk5sr6mapi32trgk5m5kp33bquctsjmkifebnsnndt@fix6u4rthx4g
> 
> > diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> > index cdf3e8422ea12..b68806b3bd6e5 100644
> > --- a/arch/arm64/include/asm/kvm_nested.h
> > +++ b/arch/arm64/include/asm/kvm_nested.h
> > @@ -298,6 +298,12 @@ static inline u64 decode_range_tlbi(u64 val, u64 *range, u16 *asid)
> >  	num	= FIELD_GET(GENMASK(43, 39), val);
> >  	*range	= __TLBI_RANGE_PAGES(num, scale) << shift;
> 
> [Severity: High]
> This isn't a bug introduced by this patch, but earlier in
> decode_range_tlbi(), base is extracted without sign-extension:
> 
> 	base = (val & GENMASK(36, 0)) << shift;
> 
> For upper-half kernel virtual addresses, base will be zero-extended. When
> invalidate_vncr_va() in arch/arm64/kvm/nested.c checks if this invalidation
> intersects with a cached VNCR TLB (vt->gva), the cached TLB is correctly
> sign-extended. The bounds check incorrectly fails due to comparing a
> sign-extended gva against a zero-extended scope->va:
> 
> 	if (va_end <= scope->va ||
> 	    va_start >= (scope->va + scope->size))
> 		continue;
> 
> Does this leave stale entries in the VNCR cache and break memory isolation
> for nested guests when they invalidate an upper-half VA range via
> TLBI RVAE1*?

base is correctly sign-extended now [1].

[1]: https://git.kernel.org/kvmarm/kvmarm/c/239347008564

> 
> > +
> > +	/* Cap the range to the correct half of the address space */
> > +	if (!(base & BIT(48)))
> > +		*range = min(*range, (BIT(48) - base));
> 
> [Severity: High]
> Does this hardcoded BIT(48) cap incorrectly truncate valid 52-bit IPAs?
> 
> For guests with a 52-bit IPA space (FEAT_LPA), a valid TLB invalidation over
> the entire address space (base=0, range=BIT(52)) appears to be truncated to
> BIT(48), potentially leaving stale mappings in the upper 48-52 bits.
> 
> Additionally, if the base address exceeds BIT(48) but has bit 48 cleared
> (for example, base=BIT(49)), won't (BIT(48) - base) underflow to a massive
> unsigned value, bypassing the cap and failing to prevent the overflow?

There is no 52-bit support for NV guests.

> 
> [Severity: High]
> This is a pre-existing issue, but since this cap uses BIT(48), can a nested
> guest still trigger the host WARN_ON in __unmap_stage2_range() if the VM's
> configured PARange (ia_bits) is smaller than 48?
> 
> If a guest supplies a base and range that stays below BIT(48) but exceeds
> the VM's actual limit (for example, BIT(40)), it seems _kvm_pgtable_walk() in
> arch/arm64/kvm/hyp/pgtable.c will still return -ERANGE:
> 
> 	if (data->addr > limit || data->end > limit)
> 		return -ERANGE;
> 
> This bypasses the new cap and can trigger the warning, which could act as a
> Denial of Service if panic_on_warn is set.

This looks correct to me, but irrelevant to this patch.

> 
> > +	else
> > +		*range = min(*range, ~base + 1);
> 
> [Severity: High]
> Is this upper-half range cap mathematically effective without base being
> sign-extended?
> 
> Since decode_range_tlbi() leaves base as a positive unsigned 64-bit integer,
> ~base + 1 evaluates to an extremely large positive value near 2^64. Will
> min(*range, ~base + 1) always evaluate to *range, leaving the range uncapped
> and still vulnerable to the overflow for upper-half virtual addresses?

base is sign-extended now, see above.

Thanks,
Wei-Lin Chang

> 
> > +
> >  	return base;
> >  }
> >
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260810170616.746100-1-maz@kernel.org?part=1

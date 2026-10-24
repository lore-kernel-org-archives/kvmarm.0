Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792823221;
	b=s9vmkyiWeTK3r6LgrvPjyiLuD/rrA5tgpnF5XSsqIcrj0ozAdvjHPAqXRajsGJoaEzuQ
	 Qda4WtHaz3JN6sIM9oWSnG/+XW4krBFV49WNfEnTL+bNZMqtAnYG692Awqm3fMLjGBkY7
	 3IlXfA947qFQtda70pT+RH+AakOWfoODmpbMzh4buL61Ql+ErFTbd7qmtVxg57wld7ebg
	 bdcq7996MmNBIOqFHsKojdPR2i4o4tHtCbleqTlQqO1Z6iDH/r6JAqycjy4wYY4sNgWEL
	 H0E+mK2Usi83XGgdS83OTEI9xvjo3YRpVIHECkDdGtiuqXDGFcY+lrrDgsf6dRFaFTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792823221;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=+S9En87nOHBKDP9xDITQCXqiAG2G9mU536/WXxAEKjM=;
	b=viaMKG5iWp7Pw1N1qIdi3UzBWO/O6Xw1NJOk8LTm6sKj5PX7SphBgd9VaiuonXcsU+Xg
	 bCvk4Rv7TyIXQXSmE3CPz/FYafnBpW9K2d96zB9z/SOQwB9PKJWu162zXGFa3xPLkm1j/
	 cTIWe698TdvMalIYVkf9mOsyM5UsZd6OXV/eRDIvUgPodBQ6KX4EIN5VSZs1J0TjSbf6H
	 tm+thZwdUebaQhs2wbVOg8qvmMfQUD443ynnVj8XNIp/3Xfwi9FE74GujnfSIyH+CCVHH
	 2hvnOA3hfolXPjI31TLOlKHPejp5ipd+/VdBKE4BLcP3cUlW41G/kehgJv3JqTrlSjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g8RtePCQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7BB606A31E;
	Sat, 24 Oct 2026 06:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g8RtePCQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BF81F01825;
	Sat, 24 Oct 2026 06:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792823220;
	bh=+S9En87nOHBKDP9xDITQCXqiAG2G9mU536/WXxAEKjM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g8RtePCQu/twlD4PMNOBNLI9WPlik31a5cUdbrvT+ViOqWXKBTjEUjre7qA8f2mPo
	 cSTEmQ0f65hGHL4Oe02XVxZ3ORUVRBHEDTBFB6KFRGYzl9oSqdfk4ewTU4incgqfPa
	 QV1k9gq8zjJ23EfiZp/U4qAUX5D0xKN1W+NYScXCht+PQsdgM87chs5dNf6bE+GMLZ
	 J1f6ddCLyVu2SIGLOUCHMD5KqQXp1/V+AufETHL1GOY9ca2WevP9SMWW+lJw75Z7tP
	 zcT1mzL+dJxd40IXBP0+LuuqEpOtL/jQYMnyo/vn7//VRT51P1Q4cc3xNUtFsuSgft
	 1s+bLqqcjOecw==
Date: Fri, 23 Oct 2026 23:26:59 -0700
From: Oliver Upton <oupton@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 04/28] KVM: arm64: nv: Only shadow writable-dirty
 guest descs as writable
Message-ID: <atxPs59WnhOM1cJ9@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org>
 <20261023205610.1044532-5-oupton@kernel.org>
 <sashiko-outbox-183253@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-183253@kernel.org>

On Fri, Oct 23, 2026 at 09:25:39PM +0000, sashiko-bot@kernel.org wrote:
> > @@ -1781,7 +1788,7 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
> >  		kvm_inject_nested_sync(vcpu, esr);
> >  		break;
> >  	case 0:
> > -		perm = kvm_is_write_fault(vcpu) ? vt->wr.pw && vt->hpa_writable : vt->wr.pr;
> > +		perm = kvm_is_write_fault(vcpu) ? vncr_can_map_writable(vt) : vt->wr.pr;
> >  		if (!perm)
> >  			handle_vncr_perm(vcpu);
> >  		break;
> 
> [Severity: Medium]
> Does handle_vncr_perm() in arch/arm64/kvm/nested.c also need to check
> vt->wr.dirty when deciding whether to promote a write fault to an external
> abort?

Yep, what we have 'works' for the direct permission model but S1PIE
style software dirty state makes a mess of it.

> With FEAT_S1PIE enabled at guest EL2, compute_s1_indirect_permissions()
> computes vt->wr.pw = true from PIR_EL2 and the descriptor's permission index
> independently of BIT(7), while compute_s1_permissions() sets vt->wr.dirty =
> false when BIT(7) is set on a writable-clean stage-1 descriptor.

Hey, look at that! You got the architecture right this time.

Thanks,
Oliver

> When a nested guest takes a VNCR write fault on such a writable-clean
> descriptor backed by a read-only memslot or HPA (!vt->hpa_writable),
> kvm_handle_vncr_abort() sees !vncr_can_map_writable(vt) and calls
> handle_vncr_perm():
> 
> arch/arm64/kvm/nested.c:handle_vncr_perm() {
> 	...
> 	if (kvm_is_write_fault(vcpu) && vt->wr.pw && !vt->hpa_writable)
> 		fsc = ESR_ELx_FSC_EXTABT;
> 	/*
> 	 * Otherwise, inject a permission fault using the guest's translation
> 	 * level rather than the host's.
> 	 */
> 	else
> 		fsc = ESR_ELx_FSC_PERM_L(vt->wr.level);
> 	...
> }
> 
> Because handle_vncr_perm() only checks vt->wr.pw && !vt->hpa_writable
> without checking vt->wr.dirty, won't it inject ESR_ELx_FSC_EXTABT instead of
> the architectural stage-1 permission fault ESR_ELx_FSC_PERM_L(vt->wr.level)?
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261023205610.1044532-1-oupton@kernel.org?part=4

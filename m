Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570CA2C08BC
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 17:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763401987; cv=none; b=UU5mzhOKPEe5dqdv5lTkcOdKaNu1Wx47hMpVkYRXRho7jd4cLdFnG9qOSCVekClS0+ZgO32RDMn9zkVIg1p/cTn1sZ3U1A4NPAneU64pzs8RobvIqKFQOnGcD6yr8tfelpImNZVfFAg6TIaP6rsA6ukRtGbe998dckIj1sLoOzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763401987; c=relaxed/simple;
	bh=KdETyFgS3BdIRZidpLd8kGMG8VhwCntOYpxvZRPQVZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TwHDTq4ARaGsYE51swwtSwCd4tHWaobupe/4O0swy+eoU5OZBAWJx7piSdnqv88G9HWbHxIBIMr+KCqIPGMkq8FSWqBFHTlZEU8uuU70DPrIE1u2XXJ2kSLndQdD1uNFx0JuGme5RL5rw/4d8Fg/MJAk0WYQciggwHfNCSODugY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pmfjjv/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pmfjjv/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CD7C19422;
	Mon, 17 Nov 2025 17:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763401982;
	bh=KdETyFgS3BdIRZidpLd8kGMG8VhwCntOYpxvZRPQVZ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pmfjjv/1jsz21Zfe8SJfIezsUTtEoRq82aH73p1zl/wWcN0VLHuSzIi2PN2vYKX+Q
	 95ud+5zHn256vuiYY9QcMAGPCHHta97++FwhtOfbaTLo1SgzbPpfG72ghKREF4FGt8
	 FljF/k/JIqdCzVB29htscYbS8BSxx4RXnhJKbfupGBDZnNQz6u/kXj2i7Besh6XRH7
	 t7qQuAseFwcKn+ifycDI7SgYdo4/U52RfhDXP7OgrQQgA/bcks8Uks57Mp8UCohI/C
	 cO/muhHGcqMgrQ+8rYLsV1LWyaScwjwA2k9dMmmLSxyUVbfdvxR0bp4UEsoq/K+1TF
	 P19aU6Fvsufaw==
Date: Mon, 17 Nov 2025 09:53:00 -0800
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 10/12] KVM: arm64: Implement HW access flag management in
 stage-1 SW PTW
Message-ID: <aRtg_GiK_rvpQpgO@kernel.org>
References: <20251112183406.2118981-1-oupton@kernel.org>
 <20251112183406.2118981-11-oupton@kernel.org>
 <86y0o4sohe.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86y0o4sohe.wl-maz@kernel.org>

Hey,

On Mon, Nov 17, 2025 at 02:49:49PM +0000, Marc Zyngier wrote:
> On Wed, 12 Nov 2025 18:34:04 +0000,
> > @@ -490,6 +506,17 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
> >  	if (check_output_size(baddr & GENMASK(52, va_bottom), wi))
> >  		goto addrsz;
> >  
> > +	if (wi->ha)
> > +		new_desc |= PTE_AF;
> 
> What initialised new_desc the first place? Shouldn't there be a
> 'new_desc = desc;' somewhere before that?

Lol, I had this right after the read succeeds but threw out that part of
the diff.

> > @@ -1489,13 +1528,17 @@ void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
> >  	}
> >  
> >  	/* We failed the translation, let's replay it in slow motion */
> > -	if ((par & SYS_PAR_EL1_F) && !par_check_s1_perm_fault(par))
> > -		par = handle_at_slow(vcpu, op, vaddr);
> > +	if ((par & SYS_PAR_EL1_F) && !par_check_s1_perm_fault(par)) {
> > +		ret = handle_at_slow(vcpu, op, vaddr, &par);
> > +		if (ret)
> > +			return ret;
> > +	}
> >  
> >  	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
> > +	return 0;
> >  }
> 
> There is a quite a bit of churn in this patch changing the signature
> of the __kvm_at_s*() functions (and whatever calls them to propagate
> the errors). It'd be worth pulling this refactor as a preliminary
> patch, and then focus on the functional change.

Fine by me, thanks for reviewing!

-- 
Thanks,
Oliver

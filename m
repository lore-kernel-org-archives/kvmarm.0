Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792594893;
	b=4djRa0W2nUsP0/O+hA1QZ1ZK9+ZugWSpI7T7ITM0YkBL2WUuW4gSvx0GveRbRJs0FU9J
	 QIKnvCeL+Ri39m2W7QWQpnmL7f1tQjQSlYfoKVWTEiaNa76dHmZecTFCr6QQ/jtSnq5rK
	 Glz4mzbPbL/PfdicjldDiLzPNUy320WQYypEDoBk6i4Z35+4y/aGEPnRbeP8LUNCPsMIi
	 gpuf5jSRqSvvkFxxLKV02hnyUHd/tFOJJVRKvxrsNd/1Ya6XGX1LSLekFkwvCJ/yrSzM8
	 s6nmK+FaZlfsBWie1CP89tb9jzYPwTxnZx3yyL/rswE7ZQJthYLxPWyVwMNf2BS3D2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792594893;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=A4guUMc9i9ehpF1G8jQSt60WOuL8gly2/KcblJXhFIY=;
	b=14jUndmvLiJ9nbv0C6j7Q7s+jLr5XV01Gk+YYpeKgCUC6oyxlqeQS77mqUP3A273AaSq
	 +EET/QFhqO7BbQ8oTHUshIlDhfrlUQM4b0XHNxyF5oOyF0HIcfE4lM6glzHezPrtk96kj
	 aTfDtu0Jm/NGfCkX15Bo+QN8uAtCSfV1CQ4iQqdcY2Vssg/HzlBa3QBWxQqbxc9AjslZv
	 gC95FekYagLnfIqF22HSYOmmnqdokq3heeoMEVXtV2tF5vubt6V7a+wwRA+PRTkvZJj+K
	 a/yX1Pzm2NwaXvTAtpaEL7CW12+Y/yvHf/mat5GjS9gkm6PlI3IABG/Dw+2oxY7p2wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xba3Sfr2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA86606A319;
	Wed, 21 Oct 2026 15:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xba3Sfr2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC2F1F000C1;
	Wed, 21 Oct 2026 15:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792594892;
	bh=A4guUMc9i9ehpF1G8jQSt60WOuL8gly2/KcblJXhFIY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Xba3Sfr20Kz5gusDKlhGPB3CawV7BST+aPzpn6mJzugFRMC+iYEF0//1hJzhbhn5B
	 FpgprOld7c3FBThNJEx6YKXfgUWaXn73oa7/WoC6aQu97ASe6/crpYX+EXseyo/tfj
	 nh9yvk54UUA9/Jqpzbb1Y2OvJkbnXn6oqsu8W9B93EawaCC3uz5o9Ns19Bs8dcq66r
	 W5QSNhK3dUxYpMMFtCIdBs6EIFBx8gtGp7sEp5WlZWLmY3fWTPtCxZ1lLjIHPYGeNH
	 rfMdw2Cxm6lDO2ECHr+MtIu10ADMmsFvc0tAIuubT+nmA8XSiOMjp6vT2qvi9uXRN5
	 +H7iCZ4kynszw==
Date: Wed, 21 Oct 2026 16:01:26 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Oliver Upton <oupton@kernel.org>, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: arm64: Sanitise ID_AA64MMFR3_EL1.S1P[IO]E
Message-ID: <atjSmLQbm7-_oRPv@gremlin>
References: <20261020064306.1542865-1-fuad.tabba@linux.dev>
 <atc2Y4gHwtGlffns@gremlin>
 <CA+EHjTxMGFuZHPp8ULkpUiGhXos8f1B8kZ1FDigFE7afR=X6AQ@mail.gmail.com>
 <86o6cnywvb.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86o6cnywvb.wl-maz@kernel.org>

On Wed, Oct 21, 2026 at 03:03:04PM +0100, Marc Zyngier wrote:
> On Tue, 20 Oct 2026 20:30:56 +0100,
> Fuad Tabba <fuad.tabba@linux.dev> wrote:
> >
> > >> @@ -59,6 +59,7 @@ struct reg_feat_map_desc {
> > >>         const struct reg_bits_to_feat_map feat_map;
> > >>         const struct reg_bits_to_feat_map *bit_feat_map;
> > >>         const unsigned int                bit_feat_map_sz;
> > >> +       const unsigned int                idreg_idx;
> > >
> > > This field feels a bit hazardous - 0 is a valid index and now things that
> > > don't declare it are setting a valid value.
> >
> > idreg_idx is only read for the descriptors in idreg_feat_maps[], which
> > all come from DECLARE_IDREG_FEAT_MAP(), so the 0 in the others is
> > never used. Storing the encoding would work as well, I'll leave that
> > one to Marc.
>
> I don't think we should baby-sit people who hack this code. If you put
> something that is not the output of IDREG_IDX(), you get to keep the
> pieces. If you use this out of context, it will blow up in your face.

That's fair enough, I did worry a bit about identifying the idreg variant
vs. not from a reg_feat_map_desc instance though?

> > >> +static bool idreg_deps(struct kvm *kvm, const struct reg_feat_map_desc *r)
> > >> +       for (int i = 0; i < r->bit_feat_map_sz; i++) {
> > >> +               if ((r->bit_feat_map[i].flags & CALL_FUNC) &&
> > >
> > > What if it isn't a CALL_FUNC feature?
> > >
> > > Could this loop just be replaced with compute_resx_bits()?
> >
> > It's skipped, so a dependency written as a plain field match would be
> > silently ignored. Both entries today are CALL_FUNC, but
> > compute_resx_bits() handles every kind of entry and would also give
> > the res1 line something to set. It'd mean moving idreg_deps() below
> > it.
>
> I really do not want to drag compute_resx_bits() into this. None of
> that stuff is RESx. It is bad enough that we use the same structures
> to represent different type of dependencies. I also want to add new
> ways to affect ID registers that really do not fit the RESx handling.

I wonder if it's worth breaking out the resx stuff into something separate
that both call? As a follow-up obviously.

>
> > Marc, compute_resx_bits(), the rename and the loop rework are all fine
> > by me. If you agree, I can respin with them, or you can fold them in
> > when applying, whichever is easier for you.
>
> I don't care about the name, but I don't want the rest of the proposed
> changes.

Fine with me ;) the logic all looks fine so these were nits.

As you are indifferent on name, do you mind having the two functions one
calling another? That is a lot clearer to my eyes. But also not a
showstopper, obviously!

--
Cheers, Lorenzo

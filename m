Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F15413789;
	Fri,  4 Sep 2026 11:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788521729; cv=none; b=aZ/vxdTqFPe3nQTnaU4Z5z90+0tXZ4oAiCDWRdqX8I/V2moqT/0LCSWnuXKEu4xT/02qUiG7ZPVQqTboIuYNm6vkD2RJfdCUTPgIcdGQyIqTdRq9slWD5GaoVlCM6oLTKqd0s9DFWZOZDc5VASLFVISFzuXBo/ALEe7O04K0zZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788521729; c=relaxed/simple;
	bh=bFon2cbyijn7duqmOdSI5yvUMxQWCfWBLNww7mbY1xw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZrQQkjNz6ieuk1NPUVQAL1jFKPMUTQM9b/wpYWooSJp4xZZt+ABmZbtu0lDRNd1EzvJqIS1vbxChsq+5VOGOnM+jC6zLrZmOjsaXtGhtzYhygiuzLUuHbZiVjqFp0OrZrNzaRCZZxIhzyL1ENpRWLHPd5T1nglg7Tw7S5t9AJ2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f1wNJMQZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f1wNJMQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FE01F00A3D;
	Fri,  4 Sep 2026 11:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788521727;
	bh=ZUcbjHtpqvnR19LCMXErt3m2uz8G1CLJI7LE3hWN5XU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f1wNJMQZQpaMfwMSt//b2NK3WwCIF4TZMpjRTGg86K+QO2giKzdQqV8WoJsL94oJu
	 rpuG+kw/6Ra5KaTiQQiQkfHya4RIKSKzat0qJbtukFyqBHyj4FQ983QB8FiamymC2E
	 9li4sTEkbPocDa9gS/GvOYjAoAnhcscFzlTtHJ0JPvVAgKSLtYlB8o/nzJGgP5aHvk
	 Ulrb+7S8n2DX5AobdL6y2EqRclbRRPtovnbEF8xaOAH0fbb0+1YDl5QnqIuTQc+5ET
	 nY70DULvOseupl/HUMwQLQygVP9SN1XZlOjdp0iPrxIi3h0uZ8sJOTEOIUggDaZITL
	 89dSivkNIC3PA==
Date: Fri, 4 Sep 2026 12:35:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: Initialise TCR2_EL2 for nVHE mode
Message-ID: <d9c3a882-fcf7-4cd3-93df-b0218961e145@sirena.org.uk>
References: <20260904-kvm-arm64-nvhe-pie-v1-0-29d59f245e6c@kernel.org>
 <20260904-kvm-arm64-nvhe-pie-v1-1-29d59f245e6c@kernel.org>
 <86o6ed4gln.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4uSnjEPzp0Lu0fcB"
Content-Disposition: inline
In-Reply-To: <86o6ed4gln.wl-maz@kernel.org>
X-Cookie: A is for Apple.


--4uSnjEPzp0Lu0fcB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 04, 2026 at 08:32:04AM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > +alternative_if ARM64_HAS_TCR2
> > +	/*
> > +	 * Disable any features we enabled in case the next user doesn't
> > +	 * have TCR2_EL2 support.
> > +	 */
> > +	msr	REG_TCR2_EL2, xzr
> > +alternative_else_nop_endif

> I don't see the point of this. The MMU is off, and if the next piece
> of SW can't correctly initialise the HW, that's its problem.

So we don't care about reverting back to users who are just plain
unaware of the register?  In practice for Linux that's fairly old
kernels, but people might feel adverturous and try or try some non-Linux
thing.  This stuff is all a bit edge casey with what we support.

> And with this hunk gone, the rest should be moved to the following
> patch.

I can do that, I kept it separate since TCR2_EL2 has some other controls
in it and people might want this independently.

--4uSnjEPzp0Lu0fcB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqarPkACgkQJNaLcl1U
h9AePgf/auU0op5L5XAarh4ZglS+Q/pFf3liO41gDHvtvMd6TU7icHKGsNte0eXg
z/lPZIM3VvPMiYuwv54MQ41GMD4gltvAGRFd06CvOgSp/4nK7DbFLSh7sANjO9yq
bP9rYA8oD8ZG30rtyDL7cyxSzoYwju1IV+A2OQk/rcgKzY6a+ccKAO9qtJgVo6+H
uWUVEBIchyKHOsCprtnksi6ux/rrcsXTXW54m9EWN05U69za6QB0HtVUeqbyoPJm
y4PLK6MpJ6Dtb5uSpuz522EXJ7OCdm+ykfZturrHz9VjgsLeUH2Gm4tSlud0uGca
ciQnyl3g6k8lftMcfutdVHbVJ85Uzw==
=lvvy
-----END PGP SIGNATURE-----

--4uSnjEPzp0Lu0fcB--

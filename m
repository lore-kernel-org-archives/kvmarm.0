Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E680220683
	for <kvmarm@lists.linux.dev>; Fri,  6 Dec 2024 17:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733507028; cv=none; b=laBWL7LLytgZK02RZRD8kxXfPCCqclKK9Qr7otfv+znl206MX1TNJo8Q/yIFCW4Bbf7WvuN2ENZYDfO5FkCHwN6bIU1xplg64OkSeQApP+oggqLT5W/ETL+UlmhodA2LCgjQCJGYRXSCEjHq2M57YCvglZCbXpapE+bhlERbrRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733507028; c=relaxed/simple;
	bh=m36ms2felAIm8ttAb0ORtpc8vmNP200R40r2sWRfe6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GVIu953aiDrpjv75CwEqN/U6xGjJXckwN2IYOe9E/zr+H9XEvz4tZpuxmOgt9GmADJl7Hf/c+xVR+FjROoVT/1ur0cnouT1i3cZGVcz+BIZh0xYAJWCT31IaBsTqxzEDTryivrWkI1Bn6ZGrglY9LlOF1YCcEtcPbKT7qLcveNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VZXDzbVv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VZXDzbVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEA8C4CED1;
	Fri,  6 Dec 2024 17:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733507028;
	bh=m36ms2felAIm8ttAb0ORtpc8vmNP200R40r2sWRfe6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VZXDzbVvYAfO1SbeJe/TLE6CMGABko/B1N+zOIs/vX9f/jOKXNSmLyrESFHJ3Lzq/
	 S6z3Ln/Sg3f2Vkwk7Vx+EGehY5smJgnxQaqjDMjOjGz91Y8qnCXpREmvhauXADpA+B
	 6WAXrsk+itZqusmlmcR/pzWdapVbT2kthDUvDroOmpALoFq3SXjaiRjSAZaXNG29rE
	 Dpsl/CIZEtEnoRMf86D7rm/moNHFik6BGNsbQfxsvfzY3ab0SNh13gnSbrr9rbnQFJ
	 3Hneqbu7YGavvxZgKe0N04fhjeVqgrUA/rnZf8bAOIGrJk8R49nRYTtNAwwgT6o+Zl
	 Dwe9OFYWXHLRQ==
Date: Fri, 6 Dec 2024 17:43:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Quentin Perret <qperret@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oliver.upton@linux.dev, james.clark@linaro.org, will@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, kristina.martsenko@arm.com
Subject: Re: [PATCH v4 06/14] KVM: arm64: Set protected VM traps based on its
 view of feature registers
Message-ID: <70992791-af72-43ed-88cc-1bb5a8acaf9a@sirena.org.uk>
References: <20241202154742.3611749-1-tabba@google.com>
 <20241202154742.3611749-7-tabba@google.com>
 <Z1M1DYbvuqAEU5c-@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4iR098i89+hFApT8"
Content-Disposition: inline
In-Reply-To: <Z1M1DYbvuqAEU5c-@google.com>
X-Cookie: Sales tax applies.


--4iR098i89+hFApT8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 06, 2024 at 05:31:57PM +0000, Quentin Perret wrote:
> On Monday 02 Dec 2024 at 15:47:33 (+0000), Fuad Tabba wrote:

> > -	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_RAS), id_aa64pfr0) <
> > -	    ID_AA64PFR0_EL1_RAS_V1P1) {
> > +	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP)) {

> I'm admittedly getting a bit lost in the kvm_has_feat() macro maze, but
> should this be:

> 	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, V1P1))

> to replicate the existing check?

kvm_has_feat() checks for a value <= the supplied constant while the
existing check is just < and the values for the field are:

UnsignedEnum	31:28	RAS
	0b0000	NI
	0b0001	IMP
	0b0010	V1P1
EndEnum

so they're both checking for the same thing.

--4iR098i89+hFApT8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdTN80ACgkQJNaLcl1U
h9BWPgf+IQiyhQrKBJvuASNYJ/HHdApW24+9RZSV8wxRm63d5lAl4Wl5Mh78cHTL
P9yv+xL4VRJ34d9S9Vko6160kelDqIf3oMuyEJYMluKpGEy5L7fazjPdusj3CrJP
3moUCZDvr5TvJ64mXXlTyU9VKsC2miihqrnlPO0siYsWP1ZrmvmbzS6rSh7dZceg
W82rM4+3wTQj+hAzP26UHRRPneo+n8prEb/qrZ6eHjCYkKQdB3usSyBwsvOdRebR
GSiXe33WBxpgL2PYc8sNM53Qc5jir2U2t2ivinp9wpNQHzzAfibP94h/s7Z0rRAa
SgPzixBbmLmWFsOHYwa5U0IcS+5uVQ==
=+crv
-----END PGP SIGNATURE-----

--4iR098i89+hFApT8--

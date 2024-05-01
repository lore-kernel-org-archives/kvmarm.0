Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA5D2581
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 14:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714573010; cv=none; b=mqrol18m4GAcRVmb/k/IsaL0J2sz3NS8pOC+V1b+JjYMITnNLR267MpWq3bINcgO2rSIUyJTq9Rd8hwgpdcYWRcAzaC0XjYeexmDxbVvgXhUgmoZZXax5CZ0A2GXp0FlvsSGzZY9Hqr+LDr3caIQh6Y/Ew8h1Hma6lLpOUpbens=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714573010; c=relaxed/simple;
	bh=HLuHYetnS9X6mFB0aDfW6MjiXPavMNjNn3QsfeaK5NQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dqDl0uxdMoy7hQsOwF5N+9GiP83aOFdIsKQqUhXCGSi6rSO3ZrecUnhAYMhtNoZPGja1wjrkVxydIacCn9+H3eG+8yvne014dT+2u0GAy3rIZiV/oekXHlJVK+xfkv2fXP7MZzznph7AX6R36nJgnzk2kjD4R9k/AO6JkXbxT5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VVLQGv4G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VVLQGv4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0857BC072AA;
	Wed,  1 May 2024 14:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714573010;
	bh=HLuHYetnS9X6mFB0aDfW6MjiXPavMNjNn3QsfeaK5NQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VVLQGv4GAPpRkb2mopkNn2/kGtN/k+D1htY2k+m7zR3Ft40YSuGTdqLlg7udBNSiM
	 4LAd+RKuziQzZ/uXIXR2MHGvqOKCzXhGYsDp0kj4sCXbg9q/dsvfnAZwopDXKFBCLD
	 q91tG5wcexs0lRWKbpe0Mk0+U23WURKxViKblH9ZBiT/uUBfHk0FpcwhlhE7iC0aVv
	 ajVAOQjkXJ0mL91IYd/5DoEqvL368qF2bsbAJMOQgHvwCFDKAhHSv2noDy9unMEgrR
	 q4dAK6EofstWi73NNOeJuf+4/VawyUx9Z2c/TC1yWna2a1zCPz+wfBuFi5e2mxZZ/3
	 x2oIHV/Mn+hqg==
Date: Wed, 1 May 2024 23:16:48 +0900
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	smostafa@google.com
Subject: Re: [PATCH v4 02/30] KVM: arm64: Move guest_owns_fp_regs() to
 increase its scope
Message-ID: <ZjJO0Cz9cIv51uTO@finisterre.sirena.org.uk>
References: <20240423150538.2103045-1-tabba@google.com>
 <20240423150538.2103045-3-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="L6E/k7hG6Wh0BnNI"
Content-Disposition: inline
In-Reply-To: <20240423150538.2103045-3-tabba@google.com>
X-Cookie: lisp, v.:


--L6E/k7hG6Wh0BnNI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 23, 2024 at 04:05:10PM +0100, Fuad Tabba wrote:
> guest_owns_fp_regs() will be used to check fpsimd state ownership
> across kvm/arm64. Therefore, move it to kvm_host.h to widen its
> scope.

Reviewed-by: Mark Brown <broonie@kernel.org>

--L6E/k7hG6Wh0BnNI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYyTs8ACgkQJNaLcl1U
h9DXzAf7BaJsVE9Z/ZB/B2+y14xY6QRlw4YmK3LtYrkU93ZBb8LyDKoudb9ZR5nE
xL+uBOu7kD59WT3vVLmhg/yhRCO4ggV4QSTHHfSJ9LBunCxncTAZ2G2FtWHiFszT
3GRkIDgHq0b5DY2MC03VE8aRZBU1U5xi61wnV+txfNZZdF9PctcI823PscJTk35E
eoAXS4d1IPhmMe7KLkfkz2yDUZEkJcevYgol+JXQ0gLdK16ldt1NJwsMU+hK8ioy
96QpPvKZUBU68wDzOl5+Qj33d0Vjj13OREZskgTJS2v+klKw6tVTPHKOxaEVzlda
PGOTCFx0Z+iGOMYpNK5Z280lpXlEtA==
=hTwe
-----END PGP SIGNATURE-----

--L6E/k7hG6Wh0BnNI--

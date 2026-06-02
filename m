Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537B63EBF0C
	for <kvmarm@lists.linux.dev>; Tue,  2 Jun 2026 15:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780414435; cv=none; b=EprQtPu7K+wFZnvzS/3gyzY1DPfdbSrKUNF3rHomvv1PHaDbEKEc0Rug4Sac14RGE7gM9gf6M1wSL7RaNWoRIF9dFnWq4vlro0gk9hCsVC/lh39OBRhMm3ljXEjMetkCyNHzYbTt0oyT4Aim+X+gZ2XjtB589vYDdzYaTEO807U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780414435; c=relaxed/simple;
	bh=hXmuqkMM0keTDgXDcH/szFN+Q8zrk48JBXukkDuFbok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e5juoPufL2ahIqAJ+a8pRo9/dF72rnITQ4ZgVnh4bIMCwTfYZ4lFvpFt4v21V+ZCn807z7v8/w7+wIfgW0469cZzdCmMWyCl5+68tYg0JqenO5RPl02wthqhfy4aPFW7eA1MmEtIfeOTeNzQ+PwSmoebnVtksgjafGAeXbs5/9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mOK3Ygls; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mOK3Ygls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096B31F00893;
	Tue,  2 Jun 2026 15:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780414434;
	bh=hXmuqkMM0keTDgXDcH/szFN+Q8zrk48JBXukkDuFbok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mOK3YglsN97RzjXV66yS/2QZMXGICxWHJgQxIR/Ffsl1+Wuud6L07TSectumhIVVl
	 kjpN7lDxQVm9Op5GkrD85YRdXev3doKJyQdFWOw9ao2EU1VIn4VO4gxVFxUxym8ONj
	 rB6T+iiSG/gXq2x4j0pefygY/QZpaiSy8+wTLlWdPZqAQrotp+PPPLpShqiFOMDATY
	 sk/o9dXIltdx6gbdPpEJ9T9vKBjnltMQuVAqRVeFJsf7qmTs8mY/4fzPmG5GWQDryM
	 vjFTLtS+iz0N3pRipiILAWhh8Mdlf5XTAZDv0hpO8hzbMTzU8LYXVuZVb4/xDHjFvb
	 t930OXi2B16SA==
Date: Tue, 2 Jun 2026 16:33:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, vladimir.murzin@arm.com,
	will@kernel.org
Subject: Re: [PATCH v3 18/18] arm64: fpsimd: Remove <asm/fpsimdmacros.h>
Message-ID: <cfcb0399-c6e3-4dec-a274-b29a81dcafb5@sirena.org.uk>
References: <20260602151150.925126-1-mark.rutland@arm.com>
 <20260602151150.925126-19-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ueTDfOkr/ueaW1pT"
Content-Disposition: inline
In-Reply-To: <20260602151150.925126-19-mark.rutland@arm.com>
X-Cookie: The wages of sin are unreported.


--ueTDfOkr/ueaW1pT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 02, 2026 at 04:11:50PM +0100, Mark Rutland wrote:
> We no longer need any of the remaining macros in <asm/fpsimdmacros.h>.
>=20
> Remove all of it.

Reviewed-by: Mark Brown <broonie@kernel.org>

--ueTDfOkr/ueaW1pT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoe99wACgkQJNaLcl1U
h9BF/wf/WM5AU2Uogw1Ovhdnt2THWHJFR6c5KgvcrXCOpkL8geF15+HrpsTM5hZk
vB7stAjuS+e8GnJuJwDILN8J3z9uPLMJOuhfIUNCpxoDgUDUBLisjPnRkWpTngma
IqmrRBwRTqhORulrdKdHnPkbzwtbq41mtHbOQaS1gKw2kw4LfpEf2qeGHkOqq5Uw
QbGZNVq4sBugeO8/4opZz3LXg6nqXKtTlVmyxaXbPis0nKbd/KKPrQ6cO/k3WZw8
YvIrElhMP0iD8Qn4+yR+VrF+W5HgBcKV67ZOQyNy8aILXaB03y4Tuq+dNzqwYedg
37DUHg+h8sXDZZGWlJrBxZtesivHaA==
=yGu6
-----END PGP SIGNATURE-----

--ueTDfOkr/ueaW1pT--

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EF723EAB4
	for <kvmarm@lists.linux.dev>; Wed,  7 Jan 2026 11:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767785017; cv=none; b=tB3gCOSIPYGT68mRLonuXUefZZBBQp4uf8H2ShziM4FJWl8oa5fW/59ZKtODNr/3YJ6SvzrWDYloSWiVlWl5JJBETFsKXVnYlQntvJvCHP43b/yAFQ/zdCfIDxhsSSXU/9tTXQUOXiQLPmiRYeX7/vN6IOMPD30uP0uGICgQlW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767785017; c=relaxed/simple;
	bh=dn2+c2FoopOCirq4VSlDMFYYIIkVyKutLY5f+zRioxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PjwApsDiuCpd0X2yNKJqKxdWMIC2gDzDlm4JXsRq4lZexykHavwBXYtWDPQzwt0HmRStPcxJKcQDkxvtvur7v7YFK9R88TVPhpmcL96XwdF0r7t0jwuwwrTPkWBpxSHPMdJFjAK9bCYFbS3YWsgdR5zRGUqLnpR71iZEnX+tZ1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YSwrZQqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YSwrZQqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9EAC4CEF7;
	Wed,  7 Jan 2026 11:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767785017;
	bh=dn2+c2FoopOCirq4VSlDMFYYIIkVyKutLY5f+zRioxM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YSwrZQqSBpYh0wMySfXpKWuVeMacsQxTdE/FO4cNwMqzYRrzeL5lgzq0vN3iBW/iB
	 8vGQn/05f4TeIQONJCr8kvOX+Al8ar0a5F38Z9odHjAWCgTIgBq//bspytddLJDgLc
	 PZzcLPGdo0kpPkpTJ8W5mGnEu73SiWU195V4FLw3NWfCamsRhvqunc9bg2lMaExvQR
	 fa2hKg7vdkzosyNaZMxT/GAauhy6UM7f1mEmKvEopDcMAKOAMMs4XZMoVydFCGml2X
	 gvXzzPpg95htzdzENFWgmdis/QGqzovg/1wQLMgQDT8I637Uio/uR5MxsuLM2XO7hf
	 OugUd3cdbNHKg==
Date: Wed, 7 Jan 2026 11:23:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, maz@kernel.org, oliver.upton@linux.dev,
	tabba@google.com, will@kernel.org
Subject: Re: [PATCH 2/3] KVM: arm64: Shuffle KVM_HOST_DATA_FLAG_* indices
Message-ID: <36fd77fb-362b-455b-8507-f59360153c91@sirena.org.uk>
References: <20260106173707.3292074-1-mark.rutland@arm.com>
 <20260106173707.3292074-3-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wmrKsawYFX++f6+M"
Content-Disposition: inline
In-Reply-To: <20260106173707.3292074-3-mark.rutland@arm.com>
X-Cookie: Is there life before breakfast?


--wmrKsawYFX++f6+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2026 at 05:37:06PM +0000, Mark Rutland wrote:
> There's a gap in the KVM_HOST_DATA_FLAG_* indices since the removal of
> KVM_HOST_DATA_FLAG_HOST_SVE_ENABLED and
> KVM_HOST_DATA_FLAG_HOST_SME_ENABLED in commits:
>=20
> * 459f059be702 ("KVM: arm64: Remove VHE host restore of CPACR_EL1.ZEN")
> * 407a99c4654e ("KVM: arm64: Remove VHE host restore of CPACR_EL1.SMEN")
>=20
> Shuffle the indices to remove the gap, as Oliver requested at the time of
> the removals:

Reviewed-by: Mark Brown <broonie@kernel.org>

--wmrKsawYFX++f6+M
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmleQjMACgkQJNaLcl1U
h9Dlkwf+PzIZ1iMjULrauU21DeSQdSgVk/G/LtZhuHfqa5HZo0nQ+i3mQ9QrlK0a
Y4oXxW9UM2TMruaFCtmP/6IY6+LxjgaDC4vxdb31tInKlqNt8JnCpS3M1kvCJ84W
K+xLBUo0FgmvVPwjTG8WlNN4Q31uAaeAC+TrVwmpiSXBQCSyyd8XwRAMsu4fpQpg
5f0vHHJkMudSdvsIf6SkcsEfOcINARqpLE55+fqUZD0uEj3Ll2pKGTwPDE7duMYR
gwliFxV3LftkKdY1v0RdFkXOegvNcQaJxslMjzDJPSmBszGjknMcBHEFRloKXdRX
TtxGO+yz+ktywVsZrNcrdCxV3QJIsA==
=qbTT
-----END PGP SIGNATURE-----

--wmrKsawYFX++f6+M--

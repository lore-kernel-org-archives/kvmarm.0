Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9726421146C
	for <kvmarm@lists.linux.dev>; Tue,  2 Jun 2026 15:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780414602; cv=none; b=B6QZfgaJoQGXKG0/U6UFiJaTGyPoFK/A5QDdYtRcEco03rD1rFAsfTPWn+vza/dOt7gv8zSamW1M7trXTuibpF5dwfl6bnUgbVF9qjgUXPP+iReyh1kEqG7Jq8sT38LoW4Y8x5tLEzoDtL56fj+9/Mo6M0qmKPsIzAw9AZEBg+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780414602; c=relaxed/simple;
	bh=cWm/fQay75hiRdKiEgvnZPknUhkxSY80k7N9/VbrXRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rTn+5AC4yCkJonOQrmZ2NtzB/daM2LfR9NBs9Lr/jiBLbAHF12lRxfIdcdsB5pW/zNxCfBeMAwrZg0GBpAclb4zkhBoUt2lMNLFysjUls2UxJ6ZFhye+wMGVDjSUX9Mg8yn2EwXvSGvwGxjfqLhk1ozxzwrF3GSg42OwK2C+0dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HhvdFS6v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HhvdFS6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEA01F00893;
	Tue,  2 Jun 2026 15:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780414601;
	bh=cWm/fQay75hiRdKiEgvnZPknUhkxSY80k7N9/VbrXRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HhvdFS6vKZ5SKHZrB9dNLILIS2exZr7Ws39LLas1R6pcHaKSLfQ+VhKaE9nZZLt++
	 HXJCgIIiuFiaWvRHidoL8S1QRy6bWQuvFCvJPs7D+VCcfgawyiMOrrEQqPRpDllOhE
	 vhNrHWd/zXvgqOjJMpKoScak5MEHkQ4p9TRsjpRdSG1rTaBSFvRZwM/Ae10v46kbsW
	 vQ1GRuywBIBQBcPteKNNlZrxuL7pxq2yMlGYXxeiNpk53jFQr0c4Ec/RS+udu9iIE6
	 oKP2KDZnH2bXCOSt4OgYbyLd4n1w2bEKxcqW10ToNO2oJZVBPKvKBaqzgQlfPpcYD9
	 81jLerY4yPbPQ==
Date: Tue, 2 Jun 2026 16:36:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, vladimir.murzin@arm.com,
	will@kernel.org
Subject: Re: [PATCH v3 02/18] KVM: arm64: Don't override FFR save/restore
 argument
Message-ID: <09e2c46f-476e-41b7-8af5-cf0a49e1368c@sirena.org.uk>
References: <20260602151150.925126-1-mark.rutland@arm.com>
 <20260602151150.925126-3-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="QbqOPhHa1rLTcf+s"
Content-Disposition: inline
In-Reply-To: <20260602151150.925126-3-mark.rutland@arm.com>
X-Cookie: The wages of sin are unreported.


--QbqOPhHa1rLTcf+s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 02, 2026 at 04:11:34PM +0100, Mark Rutland wrote:
> The __sve_save_state() and __sve_restore_state() functions take a
> parameter describing whether to save/restore the FFR, but both functions
> silently override this with '1'. This has always been benign (and
> callers have all passed 'true' since the parameter was introduced), but
> clearly this is not intentional.

Reviewed-by: Mark Brown <broonie@kernel.org>

--QbqOPhHa1rLTcf+s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoe+IMACgkQJNaLcl1U
h9Azlwf+IinEPaGZ9AD9+V7H1w4KdgTEtn9nENeY/1wsbrlkX085rqIrygpmBpM8
k+yTHSjTF8fkdD9nqqanQE0aqRnO2pyyyz3jM8r66HM2SLGsSRoW5cndRr9Oyvo/
BW1H2XPh1qaXn39y96nLDs6WoBiDFLk/kShhz9QXRcOsO30ShBmDadfErQqWv22K
61zkh3QfDlCVx2KoAMolkoG1l7Vf6r+g7LvodAJ2J2jExDKW4gD9ur1KTAM69B2/
jHWBXKygjqEdIaeXyNpxZk7nivay5iTSe4mO9rWoJCFoPOpNB87LU1spOAzeOq4W
pGuFGn9K1nTmB5EXiFgZEz1VVFz/4A==
=BW2b
-----END PGP SIGNATURE-----

--QbqOPhHa1rLTcf+s--

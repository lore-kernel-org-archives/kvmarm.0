Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518B03F44CB;
	Thu,  9 Jul 2026 11:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783597442; cv=none; b=ZgXFfXiq03HQu3dta3rEXYG+rmQMntEPobK9ttesp78kvx7WlCynMYnvc/d7Jl/RWx3zTZqUckGnk6W9v974rgrLAxqwxM07r7iJAl7FoTXyU9salNuC5n9dg6fc5VeMpmkfTBqyuGHzLmUral5yG5y7YD9fM4yN4tJHwQeG9Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783597442; c=relaxed/simple;
	bh=SDuZ9XKtIIcUDNLCmati6JxqmOkTYKk3QU4b9VRA0AA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YEAWTsR9ZCOxnO6xwSWqX+ED+fY+wjcpP7H+9crAGp4GpGICYKSvv7t0ISUeHhI+EqjpYgUvc0zfFrZ7E/fmBjuYNRzzvO1gVFkO/FsIgxPLo06qEToLtiT33pbY9/9ebdyuZA6ZpvWP7G8f8761ohfiskuXtf4T6+JYjggq/SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YJr3Esz2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YJr3Esz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D991B1F000E9;
	Thu,  9 Jul 2026 11:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783597441;
	bh=TtGOdqwY0KuojvV8YYw/HtNgBXr2vYI0UMqzFnUtGbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YJr3Esz2DICzZk5KDvEXQNvo6ASxPM9Zw2D5kGxAoIyEbtolY+mldGhVCsFrLzFfA
	 g8LomLwuURqx6wdNvGaCqnDIaGLqUVV64fhcC0yFwhuaOso0dAonQakqoQdeZGszFN
	 R8WllypdDbwT/dpUkSzz/DTlR2lt0HknEfqgyAhmvcOE4UdR6YfFfofZlbLsB6C5DZ
	 8QDeEDHlzatbnLGQWMi/H7g9AgF1S0zVO09lKDFD9bOE4MU5Qch9B/4wOn2hFgtCvx
	 zIvaVa0Tjp3GCz4ygWegRppEcRf5BCRwQrD0JE2j+vlOtTgjdEG7CXia5Kw28tk6nq
	 QSvIgmP8uUj5g==
Date: Thu, 9 Jul 2026 12:43:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v11 00/29] KVM: arm64: Implement support for SME
Message-ID: <eef020cf-68d8-42f2-9303-292068c839a2@sirena.org.uk>
References: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
 <CA+EHjTyAxBx4jhGq-Gme5hPi1ZyDAkL2CP_U22ykkQemD1dUhg@mail.gmail.com>
 <ak-Fyvzpj9SkF75j@J2N7QTR9R3>
 <CA+EHjTydGzbgi9FwWQaFjuRNqUFC_HeOfHggZAHhPL4FfLYBog@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lZsf7WESsK5u0OW0"
Content-Disposition: inline
In-Reply-To: <CA+EHjTydGzbgi9FwWQaFjuRNqUFC_HeOfHggZAHhPL4FfLYBog@mail.gmail.com>
X-Cookie: MS-DOS must die!


--lZsf7WESsK5u0OW0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 09, 2026 at 12:31:45PM +0100, Fuad Tabba wrote:

> Thanks, I have 7.2-rc2, but `git show
> 4c45e14df2f4e77982ad70d6d8e3fe750edd4c37` gives me `fatal: bad object
> 4c45e14df2f4e77982ad70d6d8e3fe750edd4c37` . The SHA for rc2 is
> 8cdeaa50eae8dad34885515f62559ee83e7e8dda (which is what shows in the
> link above, not sure what ID is, which is the part that matches your
> SHA.

Which version of git are you using there?  I'd expect that anywhere in
the git UI that takes a commitish (like git show) would do the right
thing when given either a tag name or the hash for the tag, it certianly
seems to for me with 2.47.3.  I'd have thought it more likely that
you've not fetched the tag and therefore don't have the object.

--lZsf7WESsK5u0OW0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpPiXkACgkQJNaLcl1U
h9CmrQf/e6LMFzC4cy2DvRx3al+SDYi/cTU553QQ/IWhh4rA+PABr4GBmfuVgCcL
4Dp/Le4V6hRNPKhBNVBKJdugKbKOypc5lildh4HuXeCxwOHLUxm/4/xDNE29bAD3
gwyQ40mmVrWG5G983wOiXJTBnz/4j1LQ3O7zzO68HYwbgu9We+PrD1HLDTQhfyMo
BcRSm/9HCrOklBJFf5VILalR79AvLDgI0ProCmvrRrKk5sZz98Nqumo7nLqN/vra
OycGQBsvmHnnkNGH/cpEKTEPGUJWsHmWYdzwoZecuDe+eJpX0yD9bSLGtomtXSou
dRHplDX80nR4V4HlwCiravHQDsPHgA==
=iYLX
-----END PGP SIGNATURE-----

--lZsf7WESsK5u0OW0--

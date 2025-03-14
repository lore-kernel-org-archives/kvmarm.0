Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B357D17579;
	Fri, 14 Mar 2025 15:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741964869; cv=none; b=GbivIzVu8PJOU7d51dzO7Tdv9IIgBueeR144rmkD9l9PVLTZSyabYAcwleQwPioKWALQX95sNteuPHLn4JVJu9EH+IusvgCWezeS/q4v/OM/gQpzpyj1DkWivHdMEyBjHpW7rUEJuzVWF33v18ZTT1h5m/qaYGNmmgWD1nmHpLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741964869; c=relaxed/simple;
	bh=auGt9XWP0Qbzw3OPjJr1G6NzqivSoczirlHeVfF6E10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sZADa86Ri9Xk7uniyi8p2hZumUomjBwFipIVtqByRTqqp63TYiyiQYZEv0nlesDvbaQtptLwSqsMXtohQNZOmP54fv7Ek1NGjUdpltj4P6j9CEbtD11zO7S9UXIcf5iRivsYhJ962mab9bNwFZQxVKAQV6R4IaohJYNKvGm+qgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XNy5Dld9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XNy5Dld9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE39C4CEE3;
	Fri, 14 Mar 2025 15:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741964869;
	bh=auGt9XWP0Qbzw3OPjJr1G6NzqivSoczirlHeVfF6E10=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XNy5Dld9pXvBnJf7wFR2PSc2XDHnXiK4b460XZRPxQk4OI9ncVfutK1DC+v3Ca7iq
	 8hatfFD9HqzC6G0xlxxkVw7+Xhu5afEzXQZZXm+weAOhZXM/LKsA0kQ7XqIGt04ZmN
	 PRHTmKa2cyrMcd/TFdZch5GLtrXLTy3pBtBt/sKM9bQLFsLAyi9VDYbroS0g1c7tWR
	 9nDRO7GOWk3GbTScXZ4mOKDkmgUJq/MENFAZJJ5Be3tPavyh1qZXNjOB2PCGLLFlsp
	 bIvokHWi1xBp5PzSdliL2ixusTBWMibIQB0p+RPp9PYmfkZ8c2cKGDPzGnueoufAqi
	 X08d4J+ZWL6fQ==
Date: Fri, 14 Mar 2025 15:07:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 6.12 3/8] KVM: arm64: Remove host FPSIMD saving for
 non-protected KVM
Message-ID: <fb6255b7-0ba2-45a3-93fd-2ebebfac61be@sirena.org.uk>
References: <20250314-stable-sve-6-12-v1-0-ddc16609d9ba@kernel.org>
 <20250314-stable-sve-6-12-v1-3-ddc16609d9ba@kernel.org>
 <2025031427-yiddish-unrented-2bc2@gregkh>
 <Z9Q_zW_mM-v2iPHC@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="S8XTGybJTDvyceBH"
Content-Disposition: inline
In-Reply-To: <Z9Q_zW_mM-v2iPHC@arm.com>
X-Cookie: Reality does not exist -- yet.


--S8XTGybJTDvyceBH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 14, 2025 at 02:40:13PM +0000, Catalin Marinas wrote:
> On Fri, Mar 14, 2025 at 06:32:45AM +0100, Greg Kroah-Hartman wrote:

> > What is the upstream git id for this on?

> It seems to be 8eca7f6d5100 ("KVM: arm64: Remove host FPSIMD saving for
> non-protected KVM").

Yes, sorry.

--S8XTGybJTDvyceBH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfURj4ACgkQJNaLcl1U
h9Am2Qf/b4EHZqu6pDkBYyouOVfn8Z/DkFLUSyW1rFgzV1MJ+UBtBsdKnClTUz2/
HbeF25PC/M9OJgPZDBVbyvMcSidxldZib36id+wvTgvvZvAPr/fiAW/T8AXmPT+T
OujSaupg0i2yN3LtCcDbI9cytqJjYzD+eXHp2RZehpJvA2pWTJ/zLAq0d0WE55BD
FAZx74C24WZ7InXKCP+U5hE2jpHp2iIuK5H+lTY6AJCpgOn9R6aIGkeo9SK5UCSC
0k0oWK77zGxIe3B3Vxj/NvRkfk8D5rrh+pGJkuTihWjDzoCNyi8moceHdTO1YoVO
aA73+5Bj6jDghbg3JPgw/01G2fO2yQ==
=YUsB
-----END PGP SIGNATURE-----

--S8XTGybJTDvyceBH--

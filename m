Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845A9364D6;
	Wed, 21 Aug 2024 15:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724253604; cv=none; b=egq7Qu5J//VLlK8F98sBmqNg1p985eqFRXm5QqZWaKAuitEFARgt1I4zUdXr7JUhGBpVyBt2wttA8dzNeyuyQ0IVJlGGe2xZJIWWaqtAIa1aqpEDwGIQzTlw9jLGm7jnCnR+BACQBZnVr04t1X3z1ooeOKIBhEVrGC2oJmNmaig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724253604; c=relaxed/simple;
	bh=LW2B0rUQmtGb5KJOrbVlBsBL1I7G2UBAhAr7AKIy7DU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dT0uAL52Hoa/fv/IgyydWR0Q9VLKslx7ayXRAT4ngLYqzL3VdbHmQK2EkAu0REKKJtFA1DbTBkB4foqeMQdUoS9RhXz0A9+zL/Cw/Pt7WsjqnJ8KQPihOzsqIll5Zot9fQy70aT8/H+l1GaARQCLzF0BptspLGJUU06C0Dkz45Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sBuDlxDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sBuDlxDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0144C32781;
	Wed, 21 Aug 2024 15:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724253604;
	bh=LW2B0rUQmtGb5KJOrbVlBsBL1I7G2UBAhAr7AKIy7DU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sBuDlxDnVGXQYmQh2efA6iMuIIX4A/W4/ykvFpg/TmZwaeKY4OuzQVN7+eOTPCv15
	 Q0qQp6emkGr3CW5GcKW0ylLsLYTdj3j9fMKuooqHq9AHjsT7OY9+Dt1UBe7TwXAg8k
	 IDi4WguvQBWTULRIcwGGRMZ6NapR5fRvgemWiyJxOpdMpgIv245P8nSPPxp5AfUijt
	 3QeezUZwXl9b8SQPN4aP7xBG/YBA7j7btBU0zIT7w+lcM7PJ0mvYNE11RATSgXiDGq
	 ZINd3zU4vNNEagaju6RlK8nhtfd3mDzIirJsJqyQE/Vg7ph0O03EKCkxc8QR+/krVG
	 lQ6VBRKjFmDIg==
Date: Wed, 21 Aug 2024 16:19:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: arm64: Control visibility of S1PIE related
 sysregs to userspace
Message-ID: <5304749b-04c8-44f4-b4de-b2d0cef61169@sirena.org.uk>
References: <20240821-kvm-arm64-hide-pie-regs-v1-0-08cb3c79cb57@kernel.org>
 <86ed6ixa32.wl-maz@kernel.org>
 <e123ee24-2a0c-4ab3-8dc3-2906bf96f38d@sirena.org.uk>
 <86cym2x7cv.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6cLz53WUGCeFW2Yg"
Content-Disposition: inline
In-Reply-To: <86cym2x7cv.wl-maz@kernel.org>
X-Cookie: You are false data.


--6cLz53WUGCeFW2Yg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 21, 2024 at 03:45:20PM +0100, Marc Zyngier wrote:

> Ultimately, we need to revisit the way we deal with visibility, as
> adding a myriad of helpers checking a combination of features doesn't
> scale. That information should exist as a static table, just like the
> trap bits.

Indeed, I was wondering about just adding a description of the relevant
ID register field to the sys_regs table.

> But until then, that's probably the way.

OK.

--6cLz53WUGCeFW2Yg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbGBZ4ACgkQJNaLcl1U
h9Cz5gf9FFQ0KM4qx77AR0jIauNqQZvDlayfaImNDovZWP2kGj9p04KMoOY3uiqU
FFUmJOuNuzH5Fg8HmgoCsmQxO9xrEW0E/qKVf+Vyw1VUat8v2CkRCsBCVbeOrZlI
nCdLja4AwoCuuSazo77dd6BTqUs93qBE+5CIhWm9U4P1AFIRZiFZGweOwODn8WYy
xVWBGfkqSMnQ/sfF2PMxOlEKK2pET0lnpJPRIm1KoZNhUTzRU2LrAHdMrdvA840V
59CVMBYcdUbBUxB7pjULgpD9LJVdgRL+e1VJCymhmaChxvjgg+2vzKfcNIuR0d7M
PfldwjFzCW76/Ls0SF93Jp3NGiCHww==
=pEMe
-----END PGP SIGNATURE-----

--6cLz53WUGCeFW2Yg--

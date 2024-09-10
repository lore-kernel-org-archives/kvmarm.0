Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A24618FDDF;
	Tue, 10 Sep 2024 14:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725977966; cv=none; b=qEOdP3MAtSXqq4L65xXPeR777R7finEL/bRmcPeyzTjkzUGFjHBGRE3wk6jmLAyDYTYCgksiOQcsL9dpB1h6Yb3BzMkR407vLr51NUUz2n53kaqohhnGxqXoXwubnLv3v9OH5AhsQERGBx6Rd/OB9x6WogxxvvSAhz0B5Gthvkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725977966; c=relaxed/simple;
	bh=ZES5LO9BASmSUM5s+UjAld5zKXpcF8iy4zrbeykzqts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nzfLwFpmUaJK6k9cybEZ/XvGg8nlAPOG7Z7dN0dziYP7VoTgD2yDd8d3E/GPYL7kj4ivf+n+ooT92dX3iMIwgPbVXz8vNxzRUweXIocOM0MJaCoCwesgheMLGD2WTsc9rq4Sdel8P7G4lcNs+eawxjzBHXiiE8CiyNT8BEcDj20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZTkS7gM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZTkS7gM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F175C4CEC3;
	Tue, 10 Sep 2024 14:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725977965;
	bh=ZES5LO9BASmSUM5s+UjAld5zKXpcF8iy4zrbeykzqts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZTkS7gM5vhmA/K1h0i2dTchicnTU/Bcv9AoxDvAndUQhdMg83lL8q4tMnVujlmMvu
	 tfWQEaTc2FfyOJhB+ZMBBtTi4WHGdzSadvumPjf4TtQfnVVSiITDOP+HkZT1byuxCC
	 1sHA7PMfkfjaOKzcxZyW/KEhtwws39/VXP+ix32r1fRtimxYuGkm0qXOJn1j9eVnny
	 ZfOvJ2nve4pfQOJnFfAaKuqVIuM9nTLmAgJe5t4pVn49vDsfk3L17ZrlweFGc520+4
	 XGWmzTf3XmGJUC820G5XoG1Ss/UuMbWV7xbscxm51RLePXvR3EskkSSMfzKzyDu98N
	 +nnKuXBgDH3dg==
Date: Tue, 10 Sep 2024 15:19:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 0/4] KVM: arm64: Fix underallocation of storage for
 SVE state
Message-ID: <0d18dda8-347a-4cd5-b17f-40c646fc3fab@sirena.org.uk>
References: <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-0-b6898ab23dc4@kernel.org>
 <86a5iw3ri2.wl-maz@kernel.org>
 <fec60c7f-0cc3-44e2-8be1-09c120e8523e@sirena.org.uk>
 <ZowGFl/1AEuevh96@e133380.arm.com>
 <a3f2f13e-be22-4a09-a8a6-5faef818defe@sirena.org.uk>
 <CA+EHjTyCvG2KL=LPhbAf+Wo66QoC_EMk1xn+R9X-yKunHQ-JhA@mail.gmail.com>
 <Ztspjf0SHx7nz2lV@finisterre.sirena.org.uk>
 <CA+EHjTyjVMw5CtEiLoZzvnnano94UGx_URhFBd7BRYm89K+XmQ@mail.gmail.com>
 <ZttDmNTX0vuddRrZ@finisterre.sirena.org.uk>
 <CA+EHjTww9OjB3OH85x_2Hs_yiaFxQwYXLZKn7o5MqUALkFyKMg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dI15yW6hBRPlcadE"
Content-Disposition: inline
In-Reply-To: <CA+EHjTww9OjB3OH85x_2Hs_yiaFxQwYXLZKn7o5MqUALkFyKMg@mail.gmail.com>
X-Cookie: You're not Dave.  Who are you?


--dI15yW6hBRPlcadE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 10, 2024 at 01:49:37PM +0100, Fuad Tabba wrote:
> On Fri, 6 Sept 2024 at 19:03, Mark Brown <broonie@kernel.org> wrote:

> > My general feeling is that it would have been perfectly fine for pKVM to
> > enforce what the host kernel wants to do anyway, if we ever do add
> > support for using asymmetric VLs and care about doing so on a system
> > running pKVM then dealing with pKVM imposed limits at that time seems
> > more than reasonable.  It probably wouldn't be the largest part of the
> > work.  Equally we now have the code so we may as well use it?  It's not
> > imposing huge overheads.

> From pKVM, this would work and other than the potential for future
> support for using asymmetric VLs, I don't really see a problem. Much
> of the complexity was an attempt not to make pKVM more restrictive
> than other modes.

Right, so it's just a question of if we want to use the code that
doesn't impose the limit given that we have it already.  I'm throwing a
patch that limits the host VL into CI, should be out today.

--dI15yW6hBRPlcadE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbgVWcACgkQJNaLcl1U
h9ARqAf+M1h9wtjrbe8SCruTA7Y9+imhZLonUGVJXlWQ+UOgZqt6jc7PffvFMz1z
rgYnYSvf1Au9n95OMLOPor0FFMEGX3mBhauC3jxpT4Pur0j+QuDiIlgRZqEE54jA
mRWugKbt/KqVah9QOTTuiLPzFCMga3u910cfAt7v6CGBqXsa7DmW64ue3YRV5/Ja
V3TWjTWJ0VnTBBi+8O4TK/B5QzjJgK260OaIltJPbuY7x5GHwgXLY9UqFl+aeWRy
++MZCRUvYIGbAZ9TMX+lVu/hmJDczSDqcMfc7QirfTkRlPQuLvrmw5i0XAtBEhNc
Acm13DwSaVDZoLmJ2ykrOKHGEiYKfA==
=Yand
-----END PGP SIGNATURE-----

--dI15yW6hBRPlcadE--

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DC6ED3
	for <kvmarm@lists.linux.dev>; Wed, 26 Oct 2022 16:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF80C433D6;
	Wed, 26 Oct 2022 16:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666802097;
	bh=TtDTBjBUojNQCXsy6xxRVdf7pH+sDI8DqHwAmlGHg0I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=elZ2YY/ZiLK4FbwQ+a4lG2Wu2MoavrUxYZ5YX2xen+VSeSaTRIgZwTOztet6e2Ypw
	 EzM5eLe+j6cMTGGVPOPEXv8HS6y/Ns9c1qVDc463sXeBpBHjMcrqsmC8X30pJ39vLG
	 Icp9SHXa7RyZDLR2DKSOCNar2SAdwpw8IvJW0KaCvrUKYHjZnN1gxO8dq8pPnXnmcW
	 ACTUkRglldmLrvOv90hHkPvLzCmtT0RPj4vb1YcAJ7htrij4OF3Y0Etgndgx6rsb7H
	 2ZwZSyTV+f4siBlEFeYvoL8FdKVSYXSQLrMmm/hcrGdiULsVmeKUHTAufsTWV3uTd6
	 L49YitP0G1wQw==
Date: Wed, 26 Oct 2022 17:34:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Vincent Donnefort <vdonnefort@google.com>, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org
Subject: Re: Hang with nVHE mode and SME
Message-ID: <Y1lhrB3lq5dZAin1@sirena.org.uk>
References: <Y1lEWJ7rO4m1CKWL@google.com>
 <Y1lNKcXfy/nHzTQ9@sirena.org.uk>
 <86ilk6ef5x.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="D0FYaXrrhMWIIMbA"
Content-Disposition: inline
In-Reply-To: <86ilk6ef5x.wl-maz@kernel.org>
X-Cookie: Prunes give you a run for your money.


--D0FYaXrrhMWIIMbA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 26, 2022 at 05:13:46PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:
> > On Wed, Oct 26, 2022 at 03:29:44PM +0100, Vincent Donnefort wrote:

> > rather than on the if statement?  A brief grep around the qemu source
> > suggests that this register and fine grained traps in general are not
> > implemented which is invalid with SME since this is required for SME in
> > nVHE.  SME is a v9.2 feature, and v9.2 includes all the requirements of
> > v8.7.  FEAT_FGT has been mandatory since v8.6 (where it was added).

> It is very unfortunate that the SME spec doesn't call out this
> explicitly, while it is calling out the dependency on FEAT_HCX (OK,
> one is mandatory and the other isn't).

Indeed.  It was there in the internal drafts but it looks like it got
removed as redundant when the v9.2 dependency was decided on but it does
make it harder to spot the interaction.

> > I did originally have a check in there for either/both this or FEAT_HCX
> > but it got taken out during review due to the architecturual
> > requirement.

> So the question is whether we work around this in the kernel (not
> enabling either KVM or SME if FEAT_FGT is not present), or leave it as
> is with the hope that QEMU gets updated.

> I'm inclined to do the latter. Thoughts anyone?

I tend to agree.=20

Note that we don't need to use FGT in VHE mode so we could restrict
virtualisation with SME only in cases where we're in nVHE mode, though
narrowing the restriction does make things more complicated so may well
be more trouble than it's worth and we might need to revise if we start
using the SMPRI_El1 trap in future.

--D0FYaXrrhMWIIMbA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmNZYawACgkQJNaLcl1U
h9Adjwf/VvWF5OwkvIiBLyj3RB9n1E10j9Fffu11wRoMXx35/kN7uHtK3L90CFz7
fel0BmVMzVbsUz19AldteUNMAPPOKL5DY/0u2zLPqI8afLPWCuYu4KWDQmFzKW2o
LIEfXvNaOdhUG5wOtKQ60v1b2P8XCDJagPOxbHPPMdVkOTSchFGbrrafFMVZY/Wq
IAWYBDB36tjQ9/aJwN61Yvy7CJ7avN9S/VV3wRWxrVkYZiXCP5km7jKYuv3tOsbv
yBlxg37vYLeTsy7EW8ndB55ZkNFqqCgv2T3+QZNs7Oma/LBxWideWeRilOp4b/mO
tOmvObFxKp/4gSrS1Wr3vMVAWlc2Xw==
=q6hE
-----END PGP SIGNATURE-----

--D0FYaXrrhMWIIMbA--

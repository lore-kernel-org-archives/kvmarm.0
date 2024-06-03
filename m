Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3931D54B
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 14:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717424226; cv=none; b=VAInlPhf1alJFIDy+2Et+KFzWcl9oSWl5PPPD5sz6vqIQsq9vjign9F0PXdaRRMDvZG/jieYn+1V8wwIJE+4sAzmVRMOQmP+9vREPffA/L78PrsnOYzx1LoTpVWtBPAgRqVCUbXjjiP8snT+Cm+FT5i35YuNuq/N7qMcq/F7pQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717424226; c=relaxed/simple;
	bh=Q9pvybY5ichoZ/mheUJBhgQVyqsIIVyFsBUSTYXn2Xs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XRrJn7FVheMhdMMMqZAgakqOCk5B1LJy4Tj/RqWk1Akuk8ueAvpjCgceG6ttrhvdM10Y0ORp1P3LGETcuA19BZS53zBkZJHSY3/IrL1sPUuocig46oxoxtsgBtj0aiZUfxTj4jr8u5DjRlCHJQ6IC0GvCAlQzfLUn35Hoism7Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NZhHzvuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NZhHzvuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2E2C2BD10;
	Mon,  3 Jun 2024 14:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717424226;
	bh=Q9pvybY5ichoZ/mheUJBhgQVyqsIIVyFsBUSTYXn2Xs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NZhHzvuY2Vvsa3Glo9Mg8YjYu31RbQIof4Yx5rQee2BWbJx4gpwXmmQKAgJWV54+P
	 5DJ1AvmMQDelKXVyA+X51HVPm1g9Wse6wrMelxseXhMsIpCg1OAuf4jwmxewAUgPaM
	 1CHCRYbikx+4/TwJVvOusm6RMHeBqnd6tR82uJd9A7IiTJsFwKuroo/n9Nh/zra4cP
	 1Bwy5rAPZSsSrO+SRIAyrT/r/JCwDERh21Fq9UKapCNvYSfm90q/odIrYIRXBSpmMe
	 sJr/hLFl4p6riSFOCBR4hU3ZwBK5z2cmCbMJx4kYU6qXkG9AHBUS0E+YnPt7ptUuQO
	 7sNCb7UQM1EFQ==
Date: Mon, 3 Jun 2024 15:16:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v4 1/9] KVM: arm64: Reintroduce __sve_save_state
Message-ID: <cba7577f-3db7-4984-bb4f-8356cf6db166@sirena.org.uk>
References: <20240603122852.3923848-1-tabba@google.com>
 <20240603122852.3923848-2-tabba@google.com>
 <8d33e86e-893c-45b8-b16c-61a4fb91cc30@sirena.org.uk>
 <CA+EHjTytTLK=bzTPa71DL1SKejprYgCbacdu7Z==YNf2TJMijw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VXiXr8XqvmHoKvPb"
Content-Disposition: inline
In-Reply-To: <CA+EHjTytTLK=bzTPa71DL1SKejprYgCbacdu7Z==YNf2TJMijw@mail.gmail.com>
X-Cookie: Don't let your status become too quo!


--VXiXr8XqvmHoKvPb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 03, 2024 at 03:11:38PM +0100, Fuad Tabba wrote:
> On Mon, Jun 3, 2024 at 2:55=E2=80=AFPM Mark Brown <broonie@kernel.org> wr=
ote:
> > On Mon, Jun 03, 2024 at 01:28:43PM +0100, Fuad Tabba wrote:

> > This is still trying to use x2 as an argument here?

> Since __sve_restore_state also has the same problem, I fixed both in
> the following patch:

> KVM: arm64: Fix prototype for __sve_save_state/__sve_restore_state
> https://lore.kernel.org/all/20240603122852.3923848-3-tabba@google.com/

Ah, I see - it'd have been good to note that in the changelog.

--VXiXr8XqvmHoKvPb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZd0FsACgkQJNaLcl1U
h9CLZwf/SrvBREBsyY7s53dIaIw0CsSMi29VuxiBHyu1ciNBJ1cVOw26rHgOgvNI
o6Lz2GpQxjim2u2cyxLKTzzasFSAa0Wnhua9v1Vsv0HM0f1/RUqPv3871kTkYzqU
R+w9M3B5An/eYT5y2QdThG0gZYuIPG038h0oxF/fodY/zgohzYuWrhwSAXokRWL6
wvEifpdFYhMFSvCpOLL8pbOjicVPbyc2V2pgfYwcItBQFGcLod3tSJJwXQugg02y
CEcE7raPb5laVfzc2cV+wvzuDRe/KZOv9qntQxDl35GE+kCucAmmm5EdQWn9WmIX
C4+JOVa2TKDZoJgiM06lAsZjb312CQ==
=WurX
-----END PGP SIGNATURE-----

--VXiXr8XqvmHoKvPb--

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0177E3CF699;
	Tue, 26 May 2026 10:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779790785; cv=none; b=SYNecmCMNh90O35tfjTXOTkMjGXpx4m/AJ2P25ZHxlfI6mW3PPtGZJQdfhXnmWz/TeEpYXxvrnFGX+GE5Dp71kL6cKSEW9t4EvgOzyiiY2+00bJr4vKmw5nC6Dunzmo2UWkvr+VqsWegT5Ic5L0Yef2J1YaySi9MYGQt4ixSBLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779790785; c=relaxed/simple;
	bh=mEvmHRYpqK28C4lllXKLqjw2rOqYfTsUYY3YBCrWFY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YDn9STLpkzO4TTKJ++O19IGCHXDZpVgR0zpj+De9etuORP1P8iYOhIDbRLErsKgZ000/NfG/CbBmLLTphTQfx6m/jxG6jjRA6H4mqt1PqNwBja8vJxKbfPLBdH51x2wDN6NSdOeaFqjaitc2vOWM9nbglJFbd+D+h9O78KgZupE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VvOwFLah; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VvOwFLah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1831F000E9;
	Tue, 26 May 2026 10:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779790783;
	bh=EMxpQmTjCQ6YYHFflXj5KI5bPtCqrLFvEvMHOInAGjA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VvOwFLahmsKGzLreqDRyvIkSIuhcPMXsklNZ5PHm9NhzHTLYjwfn5E/uRYB+NZJeH
	 T/Jk+mEYO8a0WZj/Np+770VbTN6QUgy/S3o8IkyKSwKxdOFQsarNsr2Ky/nDDRyY04
	 HwHCYK+e+JWfErkdLRsfQFru6w5lUz0jeSo2WW9mOelHjCHco5CZAE6XuWRE1++RAb
	 js3+2/8MjmCxanHWhzH/M+nng8pyZ8UCqgZ1SKybQO8tdkKdR/0VvQZzE8T3OtHp01
	 5TX7lrUxCz6qA7MwJkOsPaLWXW7gao4NH+y/Rb/ntqTMK1DQKMUx15TUYoV5iDTlKP
	 s98Idt/wW/Irw==
Date: Tue, 26 May 2026 11:19:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Preserve all guest ZCR_EL2.LEN values
Message-ID: <b4fdceb6-5fa7-4829-a60e-6f80f47f032a@sirena.org.uk>
References: <20260522-kvm-arm64-fix-zcr-len-nv-v1-1-ec254e9078cf@kernel.org>
 <ahSWwl-uCv4ZW-nE@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="RL/ZeSeTiUvxwP7H"
Content-Disposition: inline
In-Reply-To: <ahSWwl-uCv4ZW-nE@J2N7QTR9R3>
X-Cookie: You are fairminded, just and loving.


--RL/ZeSeTiUvxwP7H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 25, 2026 at 07:36:50PM +0100, Mark Rutland wrote:
> On Fri, May 22, 2026 at 07:00:04PM +0100, Mark Brown wrote:

> > Since b3d29a823099 ("KVM: arm64: nv: Handle ZCR_EL2 traps") when guests
> > write to ZCR_EL2 we have clamped the value of ZCR_EL2.LEN to be at most
> > that configuring the maximum guest VL. This is not the behaviour the

=2E..

> Have we sought feedback from architects? While I said "*or* the
> architcture requires a clarification", I think it should be clarified
> more explicitly either way given that the pattern is unusual.

> Given this is particularly subtle, please keep me in the loop when
> speaking with architects about this.

TBH it didn't strike me as subtle, I don't see anything in the
architecture which would lead me to expect the current behaviour.  The
psudocode all just has direct assignments for the write and there's
language in the ARM (eg, in the ZCR_EL2 description) saying "for all
purposes other than returning the result of a direct read of ZCR_EL2"
which seems specifically intended to cover there being a divergence
between the written and effective values, though I guess it doesn't
explicitly mention writes in the text. =20

When I saw the code it looked like something KVM was doing for some
KVM reason that was obscure to me, the lack of clarity seemed like it
was on the KVM side.

--RL/ZeSeTiUvxwP7H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoVc7oACgkQJNaLcl1U
h9C5hQf+Pn14856B4Py7Pz8HRV87FyRnoP8UMgUuC8d7Fz5BC0Xr+U6ugjlgZlry
yjK7eZ3LusILO/1JnPbdZLPuMFDgfKkwaGyDw4tvX+6mw7FZOTZP2+dfow8G7gQs
vE7CE0d8eBBL2mh6updIvf5IxImvyhC8ifSwxMEEt3xp5ROAxISABKA1V4eHJ6mT
ReWoLIonclaNncyt4mJEKzM0zDfL3NrVSmi4XGKKuqOeVGF2xf5c923LZk0/RoRp
nP3rQrOXpMTbikdif5N9SmMyzi2a0BoBN41+24axwLmcAeNeNtkhxy8s5ZlURz/1
pwwqS2hV/zq7pPoXhfVohlIA0XHTkQ==
=k37g
-----END PGP SIGNATURE-----

--RL/ZeSeTiUvxwP7H--

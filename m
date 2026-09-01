Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201F415E5DC;
	Tue,  1 Sep 2026 22:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788302917; cv=none; b=Kc2/294/QvOf/cAv197T3sEm8mCb6iCrakxt/Sw53av6QIs6IwgOXrI1FyvQS0OBXx3BG4Lo6orAqJQ0e0m1Ni7J3/FNsCZ81AHoJ8tgMIw4pcyUAKl8R9R2ofRj0DveLMQ9LuXExm+1GzxkfGVXgTYUazEZ3C3LCBkU3Mk4WwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788302917; c=relaxed/simple;
	bh=oAPagxXKSG903Fz2+yDbyEBCts+GqLEH8Ui0mXOZbwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CtZAYFBDL7G+sx/osRswyh3SjEWs+7Wta02OhCjfJuZqJKWtION94FjMjfovB8wW0nwD3nPN9YGoD0fmOewqbpIGhNkyEnhG/f0xY575IN6u1jRRQkYZhT8dAzMcNxJ3WfCOIp0mIm/TRhNeQ+oobWIfYJHRK7zp+jBHK8jErRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iLk2WBba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iLk2WBba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2071F000E9;
	Tue,  1 Sep 2026 22:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788302915;
	bh=oAPagxXKSG903Fz2+yDbyEBCts+GqLEH8Ui0mXOZbwk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iLk2WBbaD6peeI5BDaS4Bx+VSnGTLf011nilr8S9KU3CctqkKp97TrKH89DFjBzEW
	 1fzVss90v1lOKkV4yLOoKHorhxEqyeH7XhbhtZEKbZ0MUyTmylMhujNu5yOSZMa8RQ
	 ERdqZVp907JaX5RBipioirsflBjtQFa388i0HeEI/FbTCeEpBYKSBJxoyr1jpPbZTD
	 WX0NDtAN6WRhMLqCH3tPXs+HEE0lU178b2LbZs4RvKYb24BfYDSMQIQRnZrr0TvvwX
	 NPXQkQd28EXVydEH4zj7Rp5fSmtbB4/YqReABJnlbaTZfDVFe4v8CSwdiLM4SC9EsN
	 CIaX3G/BJENGg==
Date: Tue, 1 Sep 2026 23:48:32 +0100
From: Mark Brown <broonie@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v20 08/14] KVM: arm64: Enforce EXLOCK for SPSR and ELR
Message-ID: <33d383ad-9715-4aa7-a7a3-79b3cb1e243d@sirena.org.uk>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-8-f31750bdfadb@kernel.org>
 <20260901221520.B0CB01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="U9c1PxmpW/gL7TXH"
Content-Disposition: inline
In-Reply-To: <20260901221520.B0CB01F000E9@smtp.kernel.org>
X-Cookie: Prevent forest fires.


--U9c1PxmpW/gL7TXH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 01, 2026 at 10:15:20PM +0000, sashiko-bot@kernel.org wrote:

> > +static inline bool sysregs_exlocked(struct kvm_vcpu *vcpu)

> According to the ARM Architecture Reference Manual, the pseudocode for
> AArch64.CheckEXLOCK(target_el) restricts EXLOCK exception generation to c=
ases
> where PSTATE.EL =3D=3D target_el.
>=20
> When a guest running at vEL2 accesses ELR_EL1 or SPSR_EL1, the target_el =
is 1,
> but the PSTATE.EL is 2. Since 2 !=3D 1, the hardware would not generate an
> exception here. However, by checking the running EL's EXLOCKEN (GCSCR_EL2)
> and ignoring the target EL of the register written to, KVM will inject a
> spurious EXLOCK exception into the nested EL2 guest.
>=20
> Can we update this to skip the check when target_el !=3D PSTATE.EL to pre=
vent
> spurious exceptions during guest context switching?

AFAICT this conflates the conditions for setting PSTATE.EXLOCK with the
register write checks being done here.

--U9c1PxmpW/gL7TXH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqXVj8ACgkQJNaLcl1U
h9DNRwf8Cy74ZvWijPzQEY8kuiFEkmVkOT2UVU4f0J7hSM49Q9/KuYRQFWmRsH1o
6drltcpzJBC5rCantg9Cf3U1KLoWCBQ56Sc3zEUa5/B29/o1xh7cKeK7yqchHj3V
rIUmN8MmHPp7uFDd5iMn5/kmnz6A5KiXtKi1sIro7MTkysR6xLdonlKvynKB8Apj
nDZp+HMvgF51k1jsMq5TUO6jMJ9Qg8VrmR1q5k7sk22EwUymCK0EcR1AJ6K9dKMM
xAMVVk6i65OeVCHWtcsIhyuj9F3xNWHtPPRX4/Qcm+arY+N6U+jFIZqPrMVhKqwi
5yQfYfn5qePT48mGdiKsKxuCMGwRJw==
=BwoE
-----END PGP SIGNATURE-----

--U9c1PxmpW/gL7TXH--

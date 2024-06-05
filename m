Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D69A18C34D
	for <kvmarm@lists.linux.dev>; Wed,  5 Jun 2024 16:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717606361; cv=none; b=GIkqq+j1G8T1N6OtmyOXEFZ4vWUuwp86gQA1Hj7SIT33v6m6T+agJbzcib+CytpbnkSMtBFrlAFM7te1IMME1uNbZvm9RgvmD4jCq6B+70d4Zosj/zG+BixIQiM/2nyNBPKDWgZ1Pu4aUU7Nz1Pkul3PFZvDUl+pexRtHT17QoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717606361; c=relaxed/simple;
	bh=PnMxRuBRpdnW5YMBO0HgLl11HMbFZOO0XWYZGK4bMKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GQ+/N89RFO6uR+BslOsbh4Ee+4I0XLGVY5LK+5s8IZys927uRqVPabGPA3+k1CWMulkWB83HxEKsygjzC5b5kN64zhLrOrFtHGacfxgQQGXpJg9G6trPOnQnhMyXWqPV/KS+tpagdOkYRIDbOd0ytLyu9dVSj8yUnXTcv1FCyjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sb14dJEv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sb14dJEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06ED8C2BD11;
	Wed,  5 Jun 2024 16:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717606360;
	bh=PnMxRuBRpdnW5YMBO0HgLl11HMbFZOO0XWYZGK4bMKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sb14dJEv08r5vq4fE9Midu4MQ4t0xTrRbAQMvOrSkrPCerKSMbIRH96XKTd8hO5x5
	 8V5DuvUzZW7WCPW7IRL5LACTWRQl7ggczlVVeQVwf29/g8jV0pIAbtaiJoaRGF8dMm
	 bkPeYWfiWq5AryWTxWqhO9Paq6HM1XXepTHqaoXJgcZMlj0WgegYs9XIdz9ZQsGFoW
	 GR9qKsHNI6ZGwyH6BtaoGqtzFlyLXWo+wGhr6tUKSSidoj58zO87topUh0xn7qOwM+
	 E8Sy2Vq1zqg17RWeoQKW/GSSg6c89t58hTzpe13zhJLFEXgsNweUePKEp2KtPAvhyu
	 Rgjk9J6XxFTuA==
Date: Wed, 5 Jun 2024 17:52:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v1] KVM: arm64: Allocate for maximum vector length for
 pKVM host sve state
Message-ID: <93b31a5d-28e1-489a-b51d-89fc16ddd0db@sirena.org.uk>
References: <20240605150312.3684150-1-tabba@google.com>
 <cff5b8a1-d837-474e-9b92-b538d7e6caae@sirena.org.uk>
 <CA+EHjTx1Z5FyKO-YMPS83whX39eDAE5G6BzPJtpa6Z1kVpXgMg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+Zjji+u0hk+i3CpB"
Content-Disposition: inline
In-Reply-To: <CA+EHjTx1Z5FyKO-YMPS83whX39eDAE5G6BzPJtpa6Z1kVpXgMg@mail.gmail.com>
X-Cookie: Simulated picture.


--+Zjji+u0hk+i3CpB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 05, 2024 at 05:14:23PM +0100, Fuad Tabba wrote:
> On Wed, Jun 5, 2024 at 4:46=E2=80=AFPM Mark Brown <broonie@kernel.org> wr=
ote:
> > On Wed, Jun 05, 2024 at 04:03:12PM +0100, Fuad Tabba wrote:

> > > +     /* The maximum vl encountered for any cpu in the system. */
> > > +     int max_system_vl;
> > > +

> > As previously mentioned I'd really prefer not to call this _system_ due
> > to the potential confusion with the maximum VL we're using.  Naming is
> > hard.

> I agree :) I have no strong preference really. It's just that for me
> max_cpu_vl sounds like it's per cpu. But now I'm just bikeshedding...

seen?

> > > @@ -1031,7 +1031,12 @@ static void vec_probe_vqs(struct vl_info *info,
> > >
> > >               vq =3D sve_vq_from_vl(vl); /* skip intervening lengths =
*/
> > >               set_bit(__vq_to_bit(vq), map);
> > > +
> > > +             if (!max_vl)
> > > +                     max_vl =3D vl;
> > >       }
> > > +
> > > +     info->max_system_vl =3D max((int) max_vl, info->max_system_vl);

> > It's not clear to me why we stage this in a local variable prior to
> > updating the global value, and like I say it does feel cleaner and safer
> > to keep the current split between enumeration of the PE and integration
> > of the results.  This should *work* but it doesn't feel consistent with
> > the rest of the code.

> To me it felt more clear like this, but I'm fine with not doing the
> staging first.

That was the start of the thought path that lead me to implement based
on splitting it out of vec_probe_vqs() like the rest of the code does,
the logic doesn't really fit in here for multiple reasons.

>=20
> >
> > > -               kvm_host_sve_max_vl =3D sve_max_vl();
> > > +               kvm_host_sve_max_vl =3D sve_max_system_vl();
> >
> > I appreciate that we're adding a host_ on the front of it but it would
> > feel safer to keep the name of the hypervisor copy of the value
> > consistent with where we copied it from, sve_max_vl is a different thing
> > in the host kernel.
>=20
> I agree, this should be renamed.
>=20
> Thanks!
> /fuad

--+Zjji+u0hk+i3CpB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZgl9EACgkQJNaLcl1U
h9B9TQf/a1+i40xXAUku/m6vCeP0CpDDHMcbwsUkeV/CAuWNKvT5TBeKVKqfihd+
+l01oVf3QiLd7BbCZyLcnRefbzTAQqUDuN3Qx8aVxjzJK/RZknUML0h+V5qDrmcO
SAWekqSssxEZdn2LEgTz+o9qx9XAGcALoZHRsqifqAYNAnv2sQ8zGSIzNhT5xz1j
Rf6A1EMmKenoLrW8sy82RfEn5up1JJiKYKuRQxPCNu9uoU9X9sGrTVvsZoSODxSH
6VS6X+p0H44nUUqZz5O2qQSGzLBUUS2hPM9PoWQJMQLU8Py9HxAbUuxIg8eQYCWw
Hp/Q3rXMK9crExNM0jI+BSpHgHnmVQ==
=SFl+
-----END PGP SIGNATURE-----

--+Zjji+u0hk+i3CpB--

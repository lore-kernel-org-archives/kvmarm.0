Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87FD8BF7
	for <kvmarm@lists.linux.dev>; Tue,  4 Jun 2024 13:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717506803; cv=none; b=AG7kmbKP3TWKkyxxx3Jjumfid2DFaEKZhIZ6VKjrWlVGhQrJYqaGZ4I/URZ74yZqaGTZq/55G0p9ETy1fETRTQ8orUvj3bxxdWvhfuMFO75fItMcWphmKTYfE28VXEcQiHxXJYHhXbIXXLJ2YNkItT12Dlk97CO+P09HcRgP7Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717506803; c=relaxed/simple;
	bh=9iWdGrtI8Rq80HS3TNeOwpnDEe+tVQWVpLygmElE6ik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PTErhVoYB6ChHMbjFAaOKJFLCUdeLQKoLNQgkLyqBPB+B6/OeOTU4IChBbNSZ7YX7uyTntVjhQiytoPw8rVcZJGTeytEkDZooxGy/qrmwEc1uWEZJdl2d0YJ7tqeCmfMhvFJhUqpRPNs9Um9GXqMUCdVkJDYAQd9vcambJqhlaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hckskllI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hckskllI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F88AC2BBFC;
	Tue,  4 Jun 2024 13:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717506803;
	bh=9iWdGrtI8Rq80HS3TNeOwpnDEe+tVQWVpLygmElE6ik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hckskllIDVCc+2DNceK94mxTvfBsu0WStpf47kjJWsWymJ146rGINGXs3yTbmcjzh
	 AGBisiD8GQl0FwWgwcajcMWVBOjHAc7PmzymgJPp2VLleUZ10sT6cvAJEo2ksADDsB
	 0M070eHFA3UrsMh5JFAek5LLUsVj0396BGLuyELluVpsqJJKo9Hrtv8hkDe4lcoPaS
	 w9LhBeAk8Pq4RCF/EgYTSmAJTTz3mh9c3RwYUu3Qqnz0jJ/2PthdSKKAcqz2vPiAVr
	 TkOM0TV9z0fs4zI5gYARgxiZWuRkMSWy0mvSs0nK+Ag6W08OTeDPVFWCNKvkVGKsn8
	 SwjuIlNMuIOWg==
Date: Tue, 4 Jun 2024 14:13:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v4 6/9] KVM: arm64: Eagerly restore host fpsimd/sve state
 in pKVM
Message-ID: <e8e7928b-9f79-4015-a144-fade7ac84c6e@sirena.org.uk>
References: <20240603122852.3923848-1-tabba@google.com>
 <20240603122852.3923848-7-tabba@google.com>
 <728c100c-ea38-4802-832d-04521821d169@sirena.org.uk>
 <CA+EHjTw6ybZ8+YuRjmRcpm7rC_aHPn7H1V4cejrN1Zo9njhbGA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DAwe+cNrAO4uVmb/"
Content-Disposition: inline
In-Reply-To: <CA+EHjTw6ybZ8+YuRjmRcpm7rC_aHPn7H1V4cejrN1Zo9njhbGA@mail.gmail.com>
X-Cookie: Is it clean in other dimensions?


--DAwe+cNrAO4uVmb/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 04, 2024 at 01:03:07PM +0100, Fuad Tabba wrote:
> On Mon, Jun 3, 2024 at 4:52=E2=80=AFPM Mark Brown <broonie@kernel.org> wr=
ote:
> > On Mon, Jun 03, 2024 at 01:28:48PM +0100, Fuad Tabba wrote:

> > > +static void fpsimd_sve_flush(void)
> > > +{
> > > +     *host_data_ptr(fp_owner) =3D FP_STATE_HOST_OWNED;
> > > +}

> > My previous comments about this being confusing still stand.

> Sorry, I missed this in my reply to v3.

> This follows the convention for save/flush in hyp-main.c. Since the
> act of flushing the fpsimd/sve state is lazy, i.e., only takes place
> if the guest were to use fpsimd/sve, then the only thing that we need
> to do to flush is to mark the state as owned by the host.

I think this needs a comment mentioning what's going on here.

> You suggested inlining this, but since this is static, I think the
> compiler would do that. Even though it's only one line, it maintains
> symmetry with fpsimd_sve_sync().

The reason I was suggesting inlining was that it removes the need to
name the function.

--DAwe+cNrAO4uVmb/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZfEusACgkQJNaLcl1U
h9ABmwf8Dca7YHBtLwwwM93bnAPM4PiJa1ieHybexUMlTMCCPYmIuXIfyddQPut/
+ZD1mBRqIyYLzvExSknCZU9SSYwpGmCKzgms9/twV75MshgGBP2iwNX7K5aFe9pV
YfyIjjtPt/PV1PK7Y6zqYiDGhE/HgPBHVPQ71H757/D+Dlq6nM8U6mkA/NRoQF3a
Vx7zr1YhqCW+A3YejfdxtZcApUEoQ9hFNKCuE2mHLI1b/w01wdPqwED49RTuDn4w
u+l7OHSHgVszqpk9X+RmimYdMoixV/5d0rYmWzzsC9oLgUM8GIzC2vw2dQEglbHT
qp7l1IkgwE5hpJLHvp2tVD2hYlc0dQ==
=hJe6
-----END PGP SIGNATURE-----

--DAwe+cNrAO4uVmb/--

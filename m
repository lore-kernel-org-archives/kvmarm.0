Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8A3381B05;
	Thu, 20 Aug 2026 15:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239181; cv=none; b=j9k75fSXLPiIK5GL+sjKCKh9tNYUaYdOTLCxp7iUB1Nf5wntQG/Hxib1KYh84WzxgAmAw1xDfvsRXOu6PiI6E1Cb3axkUCcV4Of0UVbFE4j/dUslSk1fd+Tu5+xBUAKCc1fWblaHX89GRVZ/pKQjkhbNmgQ8itqXJzKs6DdEwYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239181; c=relaxed/simple;
	bh=+hcUe+OUgSlQkV7v2P+3uKFo88JRgku5IL1veTqJYl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yn0V6DC4iw8BgUhkYK3sZbVNzyL4OuRXmMcrQmLaRBzarENlqmBBOFV5qVyJyk5WdKNpDA7u5Ou8Wx160JeO6l9WC9hCiex71j5XpMEia8AUF5CfBozZOASfFxUYYDhc3ca8yCI7a7Zuxn1R6PBBn0sQj8ZDFhpiwRSamcNFRN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=geE15Eku; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="geE15Eku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B6F1F00A3E;
	Thu, 20 Aug 2026 15:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787239180;
	bh=b5hJuXbQ5dC9VlpMlCqdUtrRiywrezf0F9uuzsr0IXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=geE15EkuV/lUtNOdTTHxH/hk2Tx/U5yHSm4N+DvJTQKO7lsaHxcbqdJ3pHZZGFjua
	 eHYu9z2Ly5eIzxpDcP94K9UAJ77+WLKUwFJHmCw88GzSupH/qU7RdI/DIjQNbOfQSw
	 MPoj0D1LEyy3EJegmFooEDF6f6WUDywE0DP1M0BVv+8rakExSJxmxtFMc5p8SbAbop
	 /wVHhD+XNspcBvtjMZeLR/1IvcECqXMjqNkSB971KzwsKg4kAEOR65oW7aZe5VnR6X
	 4WD+4oQcegob3+47+3J3pPivtZEh6g0Anl20SduPm6WttyslrpTULRWMOdM7N6/vBJ
	 N8s707BKUDl8A==
Date: Thu, 20 Aug 2026 16:19:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v19 03/14] KVM: arm64: Manage GCS access and registers
 for guests
Message-ID: <c4d3ef8c-b5da-4435-81e7-7f9ee88b988d@sirena.org.uk>
References: <aoXamcdKoMynTkpX@LeoBrasDK>
 <48be9e5d-357a-4863-8682-8b3f34c69723@sirena.org.uk>
 <aobUGyq8nInJYkdA@LeoBrasDK>
 <97ad6e83-b22b-4881-b644-66fa99f68d64@sirena.org.uk>
 <aocOi3wjcliZqoe7@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VryGsj2zZuDPeMrP"
Content-Disposition: inline
In-Reply-To: <aocOi3wjcliZqoe7@LeoBrasDK>
X-Cookie: Happiness is a hard disk.


--VryGsj2zZuDPeMrP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 20, 2026 at 03:28:39PM +0100, Leonardo Bras wrote:
> On Thu, Aug 20, 2026 at 03:07:14PM +0100, Mark Brown wrote:

> > I think what would help here would be to move to generating more of the
> > save/restore sequences rather than open coding them, we could have lists
> > of registers and then use data about the feature dependencies that the
> > architecture has (hopefully it's already in the MRS, I didn't check) to
> > generate these optimised feature checks rather than having to open code
> > them.  Possibly even list features and generate some of the register
> > lists, though that would need far more special case handling and it's
> > *much* less clear if there could be a benefit.

> Yeah, that would automatize the feature dependency for register loading,=
=20
> but maybe code would not be that clear on how it works? I have questionab=
le=20
> taste, though.

I was thinking of generating as part of the build process rather than as
a one off so you'd not actually look at the code in the normal course of
affairs.

--VryGsj2zZuDPeMrP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqHGwUACgkQJNaLcl1U
h9ClIAf8C1PPh/jm0zRwE2TlZckmkQSd0+wAv9s16BA+buMf1y7Blt2cCUAx/+pm
U3mobFvFSDF1COBWKajgd4TM0wmEbUYDYEd6bwxW38JUSWESaQNkEotcw/D+wCRG
p16FUPjNexyrTzf1utNn/xnnDihxAxVkv5GaJtLvBISbIC+Sa+sw+PnIwTflkjYC
CPJmsQEDCzRj+ibEU7rU6KTpUI7udB1A3s8uhnYVji5qsJlUZRVgyM4IbXTA37df
n5ErCgi7ROl4Lzz53SFIvTdPwJntXuA96OSgfesk7LAJo+7Eq3KJggXX3OxSw6BS
/F0eUbyIwjde7bxekGufQIE7j0rWnQ==
=hyYp
-----END PGP SIGNATURE-----

--VryGsj2zZuDPeMrP--

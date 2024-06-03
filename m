Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EE2757E0
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 14:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717424146; cv=none; b=PlLZC7tpP7qE8casQEybHkYq3YiH1taL5nTWiEiWh/d4Wc7sj6OhjsZ2jLofEQomZYQJpJSI3kLn6gDEmW41E9uF3ano/0qEREnO1Slebu9iNkYd7RgORd6adtO+D0F9pBXTnD0hEZ9xr2VA353Y9Xc1o0SizxvjNym9Zd/3wBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717424146; c=relaxed/simple;
	bh=Klu/mfViGUNYGuRmc7jcXWtSgDIE4VUDOInXF2ZRXhg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZBwh3h2gZDrY0Ohi8EzKgD64ar1Wg3iP79JXdcnzuma/EVaQVZDpVy6kPZYIlhiKxTT7K5CVvsE6KofpcAV4A7aL13PZXKEnfKvFS/yNBf1lV0pcColSc+l70u6wyYtkHa6wtc4OqC8LFu3MscAJCg6x7pZ7RQ90+RiHEEuhcFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DE392dNm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DE392dNm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66762C2BD10;
	Mon,  3 Jun 2024 14:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717424146;
	bh=Klu/mfViGUNYGuRmc7jcXWtSgDIE4VUDOInXF2ZRXhg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DE392dNmGCtI+U9E8V1VnEs5AO+wAvxGSX8bNA3sJ9IjjQCdW0oq3UiYRr419mVOd
	 Wk67ABd0jlwCosd1Ls8O72PsIJwHtf5y6xc9OWqEpinLh+rY85YZxnCUhZuvqhllL/
	 LbF8Tuo9CoAXCGRBJmbW+0uyxSngZcm/u4Xu5iv1CM6nRikrNvKQMw0fJw5mtSdvlk
	 HreSHCfYH9umLnasrqREjyM6Prq5MJrauGTvbJ+Pofap0sNP3ENzNd8SKlFt8IJ/OY
	 eeEvjVD0BOGpZySqVArVSYVQL7SYzef8AfacgPLKrvmvyd6lzFCc6p7C8YNhxl1Con
	 4AIVKMhp9oWsQ==
Date: Mon, 3 Jun 2024 15:15:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v3 05/11] KVM: arm64: Eagerly restore host fpsimd/sve
 state in pKVM
Message-ID: <382e0746-84a4-4c59-9187-ca9b87f9d265@sirena.org.uk>
References: <20240528125914.277057-1-tabba@google.com>
 <20240528125914.277057-6-tabba@google.com>
 <f205aea1-bc52-41ff-9545-704cda9e23ff@sirena.org.uk>
 <CA+EHjTz_u2M-wsNnD_f=_R+dJoYwL9gUrBz=YwdqGZbtTT-aaA@mail.gmail.com>
 <6e473418-dbce-4008-94fe-f60174d3f8fe@sirena.org.uk>
 <86jzj6kuh4.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sAQ5DdecvoMn8b2d"
Content-Disposition: inline
In-Reply-To: <86jzj6kuh4.wl-maz@kernel.org>
X-Cookie: Don't let your status become too quo!


--sAQ5DdecvoMn8b2d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 03, 2024 at 02:48:39PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:
> > On Mon, Jun 03, 2024 at 09:37:16AM +0100, Fuad Tabba wrote:

> > > Also, one of the concerns in terms of performance is now with
> > > nested-virt support being added, and the overhead of doing the
> > > conditional update when we know that it's unlikely that anyone is
> > > implementing vectors as big as the max.

> > I guess there's the option of doing a restore of a value fixed during
> > initialisation instead?

> And what do we gain from that?

Reducing the number of places that need updating.

> > programming what we think we're using to use to avoid surprises.  For
> > example in this series we allocate the buffer used to store the host SVE
> > state based on the probed maximum usable VL for the system but here we
> > use whatever the PE has as the maximum VL.  This means that in the
> > (hopefully unlikely) case where the probed value is lower than the PE
> > value we'll overflow the buffer.

> In that case, we need the *real* maximum across all CPUs, not the
> maximum usable.

If we stick with setting all the bits then yes, we'd need that.  It'd
also be more robust than trusting that the host won't set a higher
length.

--sAQ5DdecvoMn8b2d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZd0AgACgkQJNaLcl1U
h9D8twf+IiLSHg/Bh4jO7gRZoLdQVV/IQXACzvAF+uWdAW6W5biUeyApMExFE6p9
nQB/Dg9dbushwIIRlwHF1wJm4dpUvjHKayuxmr4gzOA0LzB9xb5XKYDbEDUJxbZo
x9k+58f+kui4h6LaUDu/qgYxEnvOuFm2ItjI9ONjizDgJpcTVGntNayDe6R/F3t6
UasqkqDzW/uYoVwNNU/w7vUF7NYANFlyXUBL2YExyQ6oCn2wmb1okfeTdWg/mNGH
waOJ/FQOwiPm/CjF2VN5vQBimTq0TfTr1dWkJAwHTY5d6chEPGisWIUepFkmWYMu
DBtkBOiKuZk3LbLrxT5qg5s7r4GUFQ==
=qgfT
-----END PGP SIGNATURE-----

--sAQ5DdecvoMn8b2d--

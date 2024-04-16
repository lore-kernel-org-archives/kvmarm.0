Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453B9127E3B
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 10:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713265050; cv=none; b=M3lAqnkVyTC7hm73HHTefu6hFCuEKoFqDKOsQZ4vhkNDKTO3gPuMOOnbZObaM+FMrIPC/JguFR6wFW4R9C1sIOcHU8ByAQT3Pi9VBEJ4vz69zLK/T4DyYY4XaTT6Z0jX5sszEXcZadRBsVDPr6wz3sb34fBd9paZoW8+Xcg8R0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713265050; c=relaxed/simple;
	bh=olyoAKtbkKU2EfEIR+bN3aTZZqwogUsVdORoA8Y7DI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ol/6RzUenoQ1KHkMb02ZdKs3oX9uu/jcTV6xowRd89ZHkpCF6Fk1GtY66XM3lLbOsXmeZGYQ04cGFYA5Jrqk698rVOANkzMq+8JbJL/Qm2nP925esZh4kcRtBqpmHE/mF0eADnTv3DUNoHw2UbDS/F5ag2IgWOMK07k1ThRhqGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iw0WRtVc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iw0WRtVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77042C113CE;
	Tue, 16 Apr 2024 10:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713265049;
	bh=olyoAKtbkKU2EfEIR+bN3aTZZqwogUsVdORoA8Y7DI4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Iw0WRtVc7Kwo77AL4BSNh5phglc7B5YB2UkDGLjTXKjOPxxdtxNQNbpToVNo9EABd
	 kplWZZ9zjaG2C58m33ZLZeeya/dO+Rj4yWqnY4EZtVSM+fSXtNLlsvwiRbjllFQrBr
	 1G0XEEFp1/7olrmu7MXP9gfzDEYZ6ZIqOJkXp/abqbOZj4Lwzdu6njC3xL03bsvJ5N
	 Qquh7w4stexVu4ZbPeAqd0CgYDvk4m62TZyJuxUU/5uXhKeh3KwVb+z0YvATqr0hjr
	 1OguZep6SFe6rem//dBq2b3evC9NerKfXMXX5NHeaU+UT2lXJ8iJOa2VY2Dze8PCee
	 yPRi3ojA91CaQ==
Date: Tue, 16 Apr 2024 19:57:27 +0900
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	smostafa@google.com
Subject: Re: [PATCH v2 01/47] KVM: arm64: Allocate per-cpu memory for the
 host fpsimd state in pKVM
Message-ID: <Zh5Zl6uoOzQOEpqh@finisterre.sirena.org.uk>
References: <20240416095638.3620345-1-tabba@google.com>
 <20240416095638.3620345-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="r9WePB6+xP9iWgd+"
Content-Disposition: inline
In-Reply-To: <20240416095638.3620345-2-tabba@google.com>
X-Cookie: You might have mail.


--r9WePB6+xP9iWgd+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 16, 2024 at 10:55:52AM +0100, Fuad Tabba wrote:
> Allocate a per-cpu fpsimd_state to store the host's state when in
> protected mode. Since the host_fpsimd_state pointer has been
> excluded from kvm_vcpu_arch, no memory has been allocated to
> store it in protected mode, and its value hasn't been set.

Reviewed-by: Mark Brown <broonie@kernel.org>

--r9WePB6+xP9iWgd+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYeWZYACgkQJNaLcl1U
h9DZoAf/SOXWXKE7R6rg2hfE/JUg0a7e/oHOxTmdZqURJ7KWqKDjwhC6uJq2UVPT
1lgdvQqrYE1WpIdZieww2ta6gmeNldOnAGYT6Xqj6GxxhkB9wYdi9EG7M+U8/zrp
sjqZsr0poFkFSZXlh2F03y3QZ9y/s6IZyFj0Wp6xctM1zEG06/ROPTrOL+bw6E+s
kreOJ4Q5H6/tcb21c1w4rvme/UzuvVLPKPQpe+uhnQu3crwAXj6QvX4zAm/j+pLx
SD3mjX1EQZvdyFSNZJqNeCjAubro6zMU7MeBImevE5SoJPLruidvbfqcMrJ4tMak
7gGq51mU25p39kYK6yULgfT8HnZwWw==
=E/Ve
-----END PGP SIGNATURE-----

--r9WePB6+xP9iWgd+--

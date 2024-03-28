Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077DF137928
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 19:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711653607; cv=none; b=RFsZlL0X1T6TIF1z7abL6J6qSkaQfFy9qicYWk2TEigeV9Z0/W/Wx8fwd7VJxZMRDb4tGqBivdwTvYZl3CKC6NcPSymuh0x562yXj3SnXlJnmaaWOmG6YsZ9frWdDlzlxXCYdbBVsAjexiwQsWgYUkJvLfBicg6PpHXhNm/0Crw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711653607; c=relaxed/simple;
	bh=MEDQhzGUZA4JT3K4UKfYtt/Wh/8snJiEXlH3Vw+wyi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XUXfkjopJWgn1QSMJC+B6PxKg4NwtF1Q0e9OVjTSJsObhIOO7f29YO/a1mSuKzXcSKVIOTS3Q/GNZ0MiJkPkfxdtZuACG0nYJ60oTb3nleYGXNc2KH2aoL1Y/Qa9eXVL4M10vLDYLYLrrB1o2WUW1BpPloKqS4DjfHwLn1ibjPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KulNp2xA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KulNp2xA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6AAC433C7;
	Thu, 28 Mar 2024 19:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711653606;
	bh=MEDQhzGUZA4JT3K4UKfYtt/Wh/8snJiEXlH3Vw+wyi4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KulNp2xAAncwg3KYj6cCxwSFXUiXsIMfVWYt/SrvqP5Qrnw1DxruVKaA5GkT3L2Ea
	 jWVDk+CKAhnLfKTt9bBrRojWCMYKV+5Zl+jVdpYQCemzBUFsxrdxmbgddtfItjVeWC
	 kC0O0N6x0BV3vs2wCTr/tT1n5EPZbIRdUOPFLy3/Dt5maWmU/QcIQYo6oz7b9gcfE3
	 9flHByJmIH5zxWnrPtwFPDD6gm4mspEc7mNP0jtzHyLgZ5sQsVkihqvMpbqBDrDLaw
	 hXoD22ULV9oUFrRsI9alRpoXcQylX/IaIYkuj7ZIPbh8Ei9B0x84JaqjCvpWo4tOx/
	 Lv6qREZbHFefw==
Date: Thu, 28 Mar 2024 19:20:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com
Subject: Re: [PATCH v1 16/44] KVM: arm64: Do not map the host fpsimd state to
 hyp in pKVM
Message-ID: <be2a582b-725e-4405-864b-3f53db91aeb7@sirena.org.uk>
References: <20240327173531.1379685-1-tabba@google.com>
 <20240327173531.1379685-17-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="U9TvosPgzVOUP9Ok"
Content-Disposition: inline
In-Reply-To: <20240327173531.1379685-17-tabba@google.com>
X-Cookie: Yes, but which self do you want to be?


--U9TvosPgzVOUP9Ok
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 27, 2024 at 05:35:03PM +0000, Fuad Tabba wrote:
> pKVM maintains its own state for tracking the host fpsimd state.
> Therefore, no need to map and share the host's view with it.

Ah, that explains why that was confusing me!

Reviewed-by: Mark Brown <broonie@kernel.org>

--U9TvosPgzVOUP9Ok
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYFwuAACgkQJNaLcl1U
h9AM1wf+LFlhP3Nj25xl5pYNn1fF1fm71mBmD7h+iwL2VMNLcSDZOwdf2v8NGbc2
aJ0rKNGolR6ksxPETMHIjBnuiKqeXGPZQ3QPvVh7XRYvBCPYjoN9Gwehd+xMj8pa
062sm+oERx5Tz6B6NBcB+bD9TAgXoY9of0JZvKLRiRMul8FOjWDGQ7BaDBWEFd0j
rnkhUvytBQtXuZ0YE6VXqX7ti+khSqRGjbwPzk6v29llvqu3NIzVZVhIkmzNptQ6
qMqF/dxsMCnU7AZ1M2Wg7+1AYQooWbc0qPmNSbbJES1OBqlbaSEkPePYktfnIdk/
e/U48mfwrYQFJEDZz5XorHBfpmNf+A==
=uzQP
-----END PGP SIGNATURE-----

--U9TvosPgzVOUP9Ok--

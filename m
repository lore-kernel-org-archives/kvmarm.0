Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AC01AE0A2;
	Thu,  4 Jul 2024 15:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720105952; cv=none; b=R5bR93ks03QE1FnemW7V2+xxwLiNcvVhojWRawWvVLsI9kH6WJaJyOfddtnLnnPn/k+oQ+7LC4dGj8wJbGXtv4/i9Zv1POoFU8t+Blxd3nwlQ9+daBAP82PAl9dArJW7s7IyzoNCOPqXKGd34maA0Cx+UXtRPw1ztZn02KDH5oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720105952; c=relaxed/simple;
	bh=M4HwyuMAPXcyVU3UeaZFM94yR3yCo7oz/R2J2IW8NfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pwfJ44gjVh56nmBwB9MhKruQJlbyyf6eDY1L01KgU2fb4PQWMEqQ7tuTdL3RDonHgnfBafN5kuLyzM3CsP6mBN6/xOaumlGjaAtMZgFosin3cLRs/UfCKZpuUzbRgfR1xjCq2gh+wwBai+QRFba2c3Wc5xFuwM6lX4TioHdZQ8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=izIqCzof; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="izIqCzof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB34C3277B;
	Thu,  4 Jul 2024 15:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720105951;
	bh=M4HwyuMAPXcyVU3UeaZFM94yR3yCo7oz/R2J2IW8NfU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=izIqCzofrGwmVzybepKyB4tDZ9DfyCB3xZA+GCrxemC4tkfgeVe0DavVNrIV20ilO
	 djHcEJsfjY69+7yHXCSgTCuxXIlQN92xiurpVlA0LORW1cGdwaAUWmo1pQwnHS4bhE
	 /FenURnRQoc3yr5EcfJ2jyx61c6uIqBYS5GjLUTyKn7QXQBIfhPTIQQG95epGjpK1k
	 TfuIVFH1bD+GzfhNnGSl1V8XUz0juAGFAtwZbxf55XunNz4xiWcSZ0mgxr8cQ4tA54
	 lyOswH8T1paOaWBvrjhV8qSVQp0Nd06r9UAakWoyuEMQmLArktAjIgNJoFlXgv8Npv
	 FTRi/WEXshImw==
Date: Thu, 4 Jul 2024 16:12:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 2/4] arm64/fpsimd: Discover maximum vector length
 implemented by any CPU
Message-ID: <25198c5a-6e23-481a-86fd-11158734615a@sirena.org.uk>
References: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-0-c88f4eb4b14b@kernel.org>
 <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-2-c88f4eb4b14b@kernel.org>
 <ZoavUGcYLULHpVfg@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gJkKdYVuZpq+zndj"
Content-Disposition: inline
In-Reply-To: <ZoavUGcYLULHpVfg@arm.com>
X-Cookie: Today is what happened to yesterday.


--gJkKdYVuZpq+zndj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 04, 2024 at 03:18:56PM +0100, Catalin Marinas wrote:

> I guess the %lu suggested by Fuad can be done when applying the patch.

There was a v3 that did that:

   https://lore.kernel.org/r/20240607-kvm-arm64-fix-pkvm-sve-vl-v3-0-59e781706d65@kernel.org

although now I try to follow that link it looks like it somehow went
AWOL, though my local git/b4 has everything that shows it was actually
sent.  I've no idea what went wrong there.

--gJkKdYVuZpq+zndj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaGu9oACgkQJNaLcl1U
h9DGIQf/SX2vuuYz+P+2Qj7jWv+vg/Ez/XoGfni0tH+qD2dJz7agdKGn8+4AqOmA
ISo/dqla0QL13z06NG9YszHi4B84G71QzJi/UneHDv2pyvCPJ/xN+sWp0WELKE2Y
omVNXR29tfawy7O/zeZbLkFoG19KRBpqpLgBB3ZpeZiGWv+0Uw1JrTXhhDn58Jzm
S3Nm5GTv37MTN0LFT5hQ+UjInUTIXWxqSh3wouceYaQgPlVf+o31CN+xJRDZ5i5l
6F+dQWx0ppX5qu8WRLfaACNkCY24jqL+RpPA47+00HXdatDjl+s2mpnUyrSRuHVk
6xRct5lDlozeR0Y2wF2EGY6wAKXcxw==
=NLwO
-----END PGP SIGNATURE-----

--gJkKdYVuZpq+zndj--

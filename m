Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AD9747D
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 11:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6115BC433C8;
	Wed, 14 Jun 2023 11:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686742757;
	bh=LlWh19f3RlQqn8kuFR1+oUZNvEUJmzlu21blsqywozA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DgG26Rw3HLR7AZxK+QEqzeFtCmZne7K6DoJdgHHEp29eGDcJq2mOmQWQFUwauwbgr
	 pzwv4NMbHAtkVg1PTuAjVewVVvNgzwjZfq2re4mmiHROFwwU5oIN6mTycajoVNRTIc
	 tydtjY9+wYhqQptrvd+JyDsu3xbi00uOje+EqKwwwzQMnIcV6sM3U0lyQZE6j6pBx6
	 uBhFmvcVN7D4uqZQ4IRAMOulfrlHnfuXrczigJ+xoP7VeMAVeWB8TWT04cGBOAsDpP
	 NKX51f/gu9zehUc4FfwxzYdlpo4Lf1Yd1GlqM0ZzNixfz4t7KYiAWSaetJOKFKirVO
	 7d1gyAK+XRcGQ==
Date: Wed, 14 Jun 2023 12:39:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>, kvmarm@lists.linux.dev,
	coresight@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 08/14] arm64/sysreg: Convert TRBLIMITR_EL1 register to
 automatic generation
Message-ID: <58471fc8-9b45-4d6b-90a2-02fed759b33b@sirena.org.uk>
References: <20230614065949.146187-1-anshuman.khandual@arm.com>
 <20230614065949.146187-9-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="J0Tx8fSl0ebs3TtD"
Content-Disposition: inline
In-Reply-To: <20230614065949.146187-9-anshuman.khandual@arm.com>
X-Cookie: At participating locations only.


--J0Tx8fSl0ebs3TtD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 14, 2023 at 12:29:43PM +0530, Anshuman Khandual wrote:
> This converts TRBLIMITR_EL1 register to automatic generation without
> causing any functional change.

Reviewed-by: Mark Brown <broonie@kernel.org>

vs DDI0601 2023-03

--J0Tx8fSl0ebs3TtD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmSJpt8ACgkQJNaLcl1U
h9CIJQf+Nt54C+QjxoV8wGNnAHT5W1Fz+L93k8Plp4tL7p6BFbpf1JYiYXZWRV+9
XyS/WsLgBMzoU3I5QKdcE17HQmeWi287tbMPWG2wqMS6Ho/KmioXWK4yoFqTQbwp
+FFSVMTz6QO0m/r0+RnIsgaEZALNRLsx3ZT+hK7AAQThtxQqJd5iVETGkVwJqOop
EDksRtQ6O35Onl73laZehRCgz8aP5b3w0jbva9JO12qWPE6O/+cZ54Xta8NaSQeu
JPf4BkBy3ULjZrbiinwtjOWj9FlPvQ4ralXhA0uvU8cn4SBp6O8y5dGtW40oVa7x
HAtM37Lsd0DBI3B9wRNMjBpS9wYQaQ==
=KN/O
-----END PGP SIGNATURE-----

--J0Tx8fSl0ebs3TtD--

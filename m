Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E127476
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 11:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24378C433C0;
	Wed, 14 Jun 2023 11:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686743150;
	bh=RnYUYlyseQWe6kP6NkFrayfM25rEhRPBxhVqsJcyjXM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q+gQTP4iSjBsGZCwnog4aQwiSTZR5h9yTG+rTdD2EqvsfsmcL5ItbziHcC/0fqVB9
	 FSsO9CDZ7l2FMFHXa4HxKvowoFxPbcU7AQAnd0Qgq0FJb1DUzR7ukXyU3JSovP+oJL
	 nxP/EwAKh5keL8sN3w1lAhFvfaR8bkzd0HkrgxZlHqagRDVuwh8jbj8tDt8wWF8h9n
	 LV1T+s+Xi1QPZEh0edDxxNMByoVNtcWzDKcwsPUhK61DsBPJ+/Z1QMYjbiT5+d/QiD
	 aU416k5EsBx9wJE4H9+CewJHF2o8ihzUgAPFuRnROHrOoOn3vzqNEbJbL1Hoz+TpuA
	 9uNP2kQm2xG+A==
Date: Wed, 14 Jun 2023 12:45:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>, kvmarm@lists.linux.dev,
	coresight@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 14/14] arm64/sysreg: Convert TRBIDR_EL1 register to
 automatic generation
Message-ID: <1b11779b-fda6-4542-86e6-b3680b0797d7@sirena.org.uk>
References: <20230614065949.146187-1-anshuman.khandual@arm.com>
 <20230614065949.146187-15-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="s0Bh6Ya3IA1ZXxZP"
Content-Disposition: inline
In-Reply-To: <20230614065949.146187-15-anshuman.khandual@arm.com>
X-Cookie: At participating locations only.


--s0Bh6Ya3IA1ZXxZP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 14, 2023 at 12:29:49PM +0530, Anshuman Khandual wrote:
> This converts TRBIDR_EL1 register to automatic generation without
> causing any functional change.

Reviewed-by: Mark Brown <broonie@kernel.org>

--s0Bh6Ya3IA1ZXxZP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmSJqGgACgkQJNaLcl1U
h9AMiQf/dhEyCHXQn9f0aYQEEXv9tph7vPyq4K6kLVyUwBcwzy+J1Ro9UjUz/EeZ
1eWPHFRfgVn/5nAdCoGj95bsdXUMhTAiKwmRg1++OnIjoUwJODMu5YcBWXxPeEhB
0LFSGi4/cuHxYDqqrCGsew6F6+HC4Lr34Eh6m47KH/ZS0wGlcYDdfqGH+WxwYfKr
EgBo5LOp2rHKxmdamAkkBKQV+MsFLfDIqS/qiMU90UiJwqnYBBMw1xgd3GTb9y5e
nb5oN+e8Uwf/q+I0klxE8urD+HYqILrTksdr9Un2UDN1Tmrf1ctGzLpZ04mDbGnm
CRjUb93TBXjpMHAPVV3GDXuxJaJk9g==
=mnQ0
-----END PGP SIGNATURE-----

--s0Bh6Ya3IA1ZXxZP--

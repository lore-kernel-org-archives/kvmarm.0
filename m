Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED90747D
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 11:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE80AC433C0;
	Wed, 14 Jun 2023 11:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686742846;
	bh=yfIpY4rh0PQQJiD3Tj6Aesccar7erUcLnV807RwTXak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uPre9dDTlhW/8CgvW2H2tAoQuj8/TAoxqDoY05niFGGmVtkfZgbAX6r3m82OIgwh+
	 eU44hLZrgMwwArqjJLVblSyMRhCypkpjpIfEVPZsLF525jImsbZTLFxfaPXpiEMria
	 1WzQM///YZUZNb3zbl/qBIelvRGODNpwG674R5PbhKzY5uBbDuJ1LwUk0hpQuh4gx5
	 WfL9wGl0lGj56E36C0D49iIo5v6ouiv2Dt5zftgkmPN40T7uy/Iy1IJI3zQbfiJels
	 B1kWn7xtjv6Wm7TwaNX10EyjNuHqgzsYCCp9UCGD6F582ZnoCTMJQQRNM0Q7Asz9vI
	 6cN8ShNWtBG2w==
Date: Wed, 14 Jun 2023 12:40:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>, kvmarm@lists.linux.dev,
	coresight@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 09/14] arm64/sysreg: Convert TRBPTR_EL1 register to
 automatic generation
Message-ID: <636fc512-99a1-487c-9732-f492faf3b385@sirena.org.uk>
References: <20230614065949.146187-1-anshuman.khandual@arm.com>
 <20230614065949.146187-10-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="LWGxwLDa8LTrbT3N"
Content-Disposition: inline
In-Reply-To: <20230614065949.146187-10-anshuman.khandual@arm.com>
X-Cookie: At participating locations only.


--LWGxwLDa8LTrbT3N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 14, 2023 at 12:29:44PM +0530, Anshuman Khandual wrote:
> This converts TRBPTR_EL1 register to automatic generation without
> causing any functional change.

Reviewed-by: Mark Brown <broonie@kernel.org>

--LWGxwLDa8LTrbT3N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmSJpzcACgkQJNaLcl1U
h9Cl3gf/UEqB1zIVm7ftJMn1awglm4kDYVQ9Qp+PLxT/mfSZn1A47FEzRieD012l
x7NqkC0ynqVcfV5zj+PwFvfXy7LbfQZA8DtsYVxIseQ3peKVJtJfwrHw+d509GDD
2EgZSygypiloYIpecqHwnxImy70+5k+kgtXAylPYhY/exYS3EWVibxR0Re5Q4ecM
Wl2sGEkjcfqmKWUDIpEHnAFqAEwGTGM2aYcBDZJ4euswe9vWml4HqiRqOnc/A8J5
AMx9OUx2sD4MRIm/P8jmGvATuFPmFUKLEbHTSVVBDeovRfiVpeA1J3iJsbfhjXEV
PlFGO2IaLOEJpQBMI5yMAJ0qBq292A==
=ufYo
-----END PGP SIGNATURE-----

--LWGxwLDa8LTrbT3N--

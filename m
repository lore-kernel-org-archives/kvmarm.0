Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985588466
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 12:00:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82E3C433EF;
	Fri,  2 Jun 2023 12:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685707254;
	bh=+Rx5zu53T1l4Ys6EZxxPMCEp5ML9nHZOu92WFN0XVN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bB8mR9iZ0z8jANS8H1kqShGzeveGxS3Iy2tllOU/cfbgfpI5zvSiYLe5rHDZCnhgh
	 Vn87z+5JSO23HVDFUAphcYBLDdr26pEeT/MDtfMMSqHqA3/N9oLfsgkr8rGeqIvHju
	 bZOBhJTb3cPd46I6pbTFHRRb7DahFtaVzzDib3n8c/TE8h3sU/p9yh6FytDIQE/yN0
	 ga8IatG1Qha4DN9HSU02HCzpbyEbfTjiGP5itHXlKIwVWZinfRoF04a++bcG9wwlha
	 czjGBKm+UXjHAB36TbNVVY71E/YO4m+4GMGZYj4AZ02rXiCsKcDZhxGQToX4jfYdAn
	 nCkse4147WKtw==
Date: Fri, 2 Jun 2023 13:00:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>, kvmarm@lists.linux.dev,
	coresight@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 11/14] arm64/sysreg: Convert TRBSR_EL1 register to
 automatic generation
Message-ID: <62835524-cafc-4f30-9b45-01b0f86697fa@sirena.org.uk>
References: <20230602062552.565992-1-anshuman.khandual@arm.com>
 <20230602062552.565992-12-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XhUAfCvumHQvhCK9"
Content-Disposition: inline
In-Reply-To: <20230602062552.565992-12-anshuman.khandual@arm.com>
X-Cookie: War is an equal opportunity destroyer.


--XhUAfCvumHQvhCK9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 02, 2023 at 11:55:49AM +0530, Anshuman Khandual wrote:
> This converts TRBSR_EL1 register to automatic generation without
> causing any functional change.

Reviewed-by: Mark Brown <broonie@kernel.org>

against DDI0601 2023-03.

--XhUAfCvumHQvhCK9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmR52e8ACgkQJNaLcl1U
h9AfYwf/ZxCNDVMmeSqkmWETOEAf862T8UEDNomlUvfxnxN1qNa0udAJm+G78IhD
/RwcM86ZjHQZaCCOn8WT/m201HLnULh2mnOXhuGyt4QxPR+J2qL1fXEN6LZAKKYv
8AwW6oJED2/rlpCLOU92xL+QtJzzsHJbEDq1dfmOnk+AwpRM8Ejg8IcJ1NajM5J1
51Xb6tBYYehHRSKU/AqsobB7IZz0wYw61V+o7OuDmfqTlabteOqAvrX0Og0UNgY7
rjCIx7ZqUyZGXc2Kw0VzBJolSE+r3trSVe9hcvDxziJR7ptILC+PzztUS2C4DVoi
t+Co62cARuAgW+IJpbgECLN+nV56aQ==
=kj5n
-----END PGP SIGNATURE-----

--XhUAfCvumHQvhCK9--

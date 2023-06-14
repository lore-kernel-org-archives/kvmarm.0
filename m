Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97731FD3
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 11:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9900C433C0;
	Wed, 14 Jun 2023 11:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686743059;
	bh=h43AKhmglYVQfgYvOwHTAXgkDhXru+sKnjL81Q5afXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ojyufhMtgVjJt6MBi7OHVMYJHcPjj393SquMDMBL++YKoJPy02sjdRRacyegcUetb
	 4kRTCWwj+7P1tZKGzaZ0A6JosZj56a0piJY6O98yM6Bi8ukod9qB7mQmru1CxXxfaU
	 3gi5+zVEDuqLlx4r9plXBVKdwyyh/PjPeuZ6AmyDQMEyXouDLNya0yz0rJAz69e6F5
	 Qe+J6bRbK31i9Drbp6HS2eWnUU18Cxx1DmeJnFYmHclLFRHdsru7rYhFQKZxdhNrlP
	 pSWr2JAEmE0Vm0PKPCrzkgOQLB4lPSsW6yTWd3tRvk548XYjGeoOKzXoORFpqe7v1g
	 YxvYEvorBVOJw==
Date: Wed, 14 Jun 2023 12:44:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>, kvmarm@lists.linux.dev,
	coresight@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 12/14] arm64/sysreg: Convert TRBMAR_EL1 register to
 automatic generation
Message-ID: <e54adbad-5007-4490-80f1-b09a0d9dced5@sirena.org.uk>
References: <20230614065949.146187-1-anshuman.khandual@arm.com>
 <20230614065949.146187-13-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YiMgr3LHDD/ut3sn"
Content-Disposition: inline
In-Reply-To: <20230614065949.146187-13-anshuman.khandual@arm.com>
X-Cookie: At participating locations only.


--YiMgr3LHDD/ut3sn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 14, 2023 at 12:29:47PM +0530, Anshuman Khandual wrote:
> This converts TRBMAR_EL1 register to automatic generation without
> causing any functional change.

Reviewed-by: Mark Brown <broonie@kernel.org>

--YiMgr3LHDD/ut3sn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmSJqAwACgkQJNaLcl1U
h9DLZQf/VFGRPg+sqD4ffhwKjIKUdLjpQe8xjQsvkZaUnzwPKYKpksBMErh3JlHB
ea7TFpfeUonTxQnFuCcGuIyjaMjOClkh+x0SnwuzA+K8ueUMMoBSuI5YMe3MbZuY
WZEJJNyDTrbReR5xwMQUIeOF1AfIDQocrX9YqnbjpK5/YHegsccWS0ybhnK0spDE
FgttbZz138UE33dxXe06VhrERvrbVQJZn6W+6sQhTQk10w6GGenCfcGw90DI3/2o
jV+QotpJ6XeFa1ltA4qDZmXfqlsv1kZHN9AQucz4InkwoCM7PlOQZUikWj0Aa45A
RapraVPG5y2EZ6BE5J1yehtq0RrsvA==
=fUtH
-----END PGP SIGNATURE-----

--YiMgr3LHDD/ut3sn--

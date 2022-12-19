Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F186187A;
	Mon, 19 Dec 2022 13:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7697AC433EF;
	Mon, 19 Dec 2022 13:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1671455560;
	bh=SiMFS9SNL7VYiasdR0xL2Aevm/BpT8USH6YhYIrsfUY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eqVew1bp3uy/a0JBIUl09xCTjov+uyF9y0VHQcgJTkpUQV3Q9yatct81MNxAI6T5Q
	 vqC5Uzm8fN9jkotNS2GHIOMbxubhBhvMwCS7IcvKSoQQmrb5Lrvn53xI1qe3i19px9
	 bFnaWGIXiCD5Fkg9bGm+IBx5AF7xN7f2AbQCgVfZYicHzaR9mXwE8NnjHUtLFtt1Qz
	 9hkaYwOQS09wuZjjqWStfEUD0SWSo/jAHT1+6B96bohPEkFg+45+qusvXF9PBx2hPO
	 06F12uVmyVUudH1tYGHATZt2qIviIWwx0O/LEKf+AASEGwxRa1owTJdMeAiJIdv31d
	 nMchHFhuc1xBA==
Date: Mon, 19 Dec 2022 13:12:34 +0000
From: Mark Brown <broonie@kernel.org>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>, asahi@lists.linux.dev,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Sven Peter <sven@svenpeter.dev>, Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH 1/3] arm64/sysreg: Add CCSIDR2_EL1
Message-ID: <Y6BjQiR5gUhIAyIS@sirena.org.uk>
References: <20221211051700.275761-1-akihiko.odaki@daynix.com>
 <20221211051700.275761-2-akihiko.odaki@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oTrc6UTzbBTSf7fh"
Content-Disposition: inline
In-Reply-To: <20221211051700.275761-2-akihiko.odaki@daynix.com>
X-Cookie: Pay toll ahead.
Message-ID: <20221219131234.N9nBZoL8-93DhigcMNzwfXe8cRd2MBnbNhkZtc2rUZk@z>


--oTrc6UTzbBTSf7fh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 11, 2022 at 02:16:58PM +0900, Akihiko Odaki wrote:
> CCSIDR2_EL1 was added with FEAT_CCIDX.

This corresponds to the definition in DDI0487I.a.

Reviewed-by: Mark Brown <broonie@kernel.org>

--oTrc6UTzbBTSf7fh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOgY0EACgkQJNaLcl1U
h9AhTQf/SdZDrzwS6EDB4hBMBmeYOfYy8tMZjCFZ05VY8WKbOIpl2TpdAOUOVINE
mqpmP7yEg56sP+rldgR+KjcL0T1AF5pyKZ2kU+HQdzo11FiFg6e2ulTSl+VFG4Fn
ztcTgaWLUqTyttNyiBo7Suadzo/T7SsNIh7s5Rnd1USz4yvvtCasI3C/btgVGZIs
HLBhVNOdRhLP6HyuTi43qMAaIT+UO4I78tEtt+NABG1fCx0jlMdzaxZG+JyQtaeX
6yMxIOCHnc86P2vK1FeopSTYD2ZJbUy+LcX50HCKp/4OsU6SscxZ8t8MjOA8EgkW
AZw9As6VAbETFTDokR+8/RmJLt4BGg==
=6/73
-----END PGP SIGNATURE-----

--oTrc6UTzbBTSf7fh--

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB00A3D
	for <kvmarm@lists.linux.dev>; Fri, 12 May 2023 04:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C0DC433D2;
	Fri, 12 May 2023 04:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683864180;
	bh=4Hv121P/Sj7BAXfRRl37k5PAP4WfnZcp1qJTu0V6SHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JXHmw7X4NKI6lI1CauY30/ZJlDt+MSyrUDC0CJfgUFRotKK6WtmHMFeGz4hcX/kVH
	 NoGceq1udwIkzPl1NalO7xaD+Ecd30aC1v0lLmLSGzzjRJ90ewtlVq/CqoK/uuE1jj
	 55yCmzzl/e5YjZLH6C/57hrCzBNJ64aNxfW1hpK0gVHqktDuZL6OO/Qh3Nr9Z/u40m
	 xs/A38ElRpSPBabXGYmGGgbKrjhMk0VBPtvyogPGdAntoV+81A3UJfIzzZXOIrbs/F
	 9uq94IlVnUzmWFD0o6+z+lbDK63SvVfMVBp/jDEZnFdI0dTqGAn3LyY0g9oEixD79r
	 yz8JGOxMJLqjw==
Date: Fri, 12 May 2023 13:02:57 +0900
From: Mark Brown <broonie@kernel.org>
To: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Luis Machado <luis.machado@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/11] kselftest/arm64: add MOPS to hwcap test
Message-ID: <ZF24SVYq27LKOwmW@finisterre.sirena.org.uk>
References: <20230509142235.3284028-1-kristina.martsenko@arm.com>
 <20230509142235.3284028-12-kristina.martsenko@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="CXfWWGf7Bizbf7PV"
Content-Disposition: inline
In-Reply-To: <20230509142235.3284028-12-kristina.martsenko@arm.com>
X-Cookie: Avoid contact with eyes.


--CXfWWGf7Bizbf7PV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 09, 2023 at 03:22:35PM +0100, Kristina Martsenko wrote:
> Add the MOPS hwcap to the hwcap kselftest and check that a SIGILL is not
> generated when the feature is detected. A SIGILL is reliable when the
> feature is not detected as SCTLR_EL1.MSCEn won't have been set.

Reviewed-by: Mark Brown <broonie@kernel.org>

> +	/* CPYP [x0]!, [x1]!, x2! */
> +	asm volatile(".inst 0x1d010440"
> +		     : "+r" (dstp), "+r" (srcp), "+r" (size)
> +		     :
> +		     : "cc", "memory");

Verified against DDI0602 2023-03.

--CXfWWGf7Bizbf7PV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmRdunAACgkQJNaLcl1U
h9CmZggAhHA/CXsC6+GZWboyNKrPZpCGcROekjNW7m2iVobs1ar0sgZ6VZ7TIgFv
e9T9qiGV1uja3u/kEukTwTHjjSsye7NwxraWPNNxe6eVndkrLk32PTYtoZSDNvfN
jede3PKmUxWvrK7zWcQSXMImm+PJEEZ+gIzhS5WJ1AyZBfXX5yud1J5k99GKM/MK
l7mKLH/G5Dj/NqHWntDUXisUP07TIVOlOs+FDJ1I2LOsocJ52mPPwwaq0GcugmP7
0eLItzCseg9bNc3tKb/wA+AvYt3uTlwcIFq88VTDglllC5B52FWqqUU2NT6uiD3s
hXORHP7fG9furKNaLPf3yk7SlWuPxw==
=6yHa
-----END PGP SIGNATURE-----

--CXfWWGf7Bizbf7PV--

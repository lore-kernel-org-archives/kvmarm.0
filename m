Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A5E15AE8
	for <kvmarm@lists.linux.dev>; Tue, 10 Oct 2023 11:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MP8FK35Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532CEC433C7;
	Tue, 10 Oct 2023 11:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696938543;
	bh=zUqQnZEPLugS1UJalrP71ma2Nf9jKbn1AsiWReIsL8s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MP8FK35ZcDUMN2Lk8EwuXB+/X1WnUC2az5MXfsgBuFFEvKum8meWKLz/gYMfzaVgL
	 GhEzOtUVJ3OxlR5Ft4hmcIBfd9O06YewS16LkuEz29R4cR/vr7TNSHaLwtG8sC/Vxx
	 BhwH91cLH7BusaUtGZazMdy1eFYMnX8d4uPs/r0HyOyUdJY5ITvSOt6fC6Ga1zdCEZ
	 xQuUEiYFwDcirtnPemN4lh0FDGb5S2GfXMkh+gHuFn3LKZV6P/4uoE0xpMXBTdRoC4
	 le25VAeWSGqkCthPBi1uLOltrApqOv4tC6z5CgRTHXWDJcvtAJSc6QIiUDp1HcWoAY
	 4pmHuSq2iTilA==
Date: Tue, 10 Oct 2023 12:48:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, nd@arm.com,
	akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
	catalin.marinas@arm.com, dave.hansen@linux.intel.com,
	maz@kernel.org, oliver.upton@linux.dev, shuah@kernel.org,
	will@kernel.org, kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 15/20] arm64: add POE signal support
Message-ID: <5cf9c84f-c961-4550-95d1-730b9aee34a2@sirena.org.uk>
References: <20230927140123.5283-1-joey.gouly@arm.com>
 <20230927140123.5283-16-joey.gouly@arm.com>
 <a6e6c8a3-15b1-48e3-84fa-810ce575c09a@sirena.org.uk>
 <9fd11f36-3987-4f45-94be-7cf89a05ad04@sirena.org.uk>
 <20231010095802.GC2098677@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hFDyTH2AbeoUjBmm"
Content-Disposition: inline
In-Reply-To: <20231010095802.GC2098677@e124191.cambridge.arm.com>
X-Cookie: I feel partially hydrogenated!


--hFDyTH2AbeoUjBmm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 10, 2023 at 10:58:02AM +0100, Joey Gouly wrote:
> On Mon, Oct 09, 2023 at 03:49:29PM +0100, Mark Brown wrote:

> > Actually, now I think about it we at least need an update to the frame
> > parser in userspace so it knows about the new frame.  Without that it'll
> > warn whenver it parses the signal context on any system that has POE
> > enabled.

> Do you mean in libc?

No, in the signal handling selftests.

--hFDyTH2AbeoUjBmm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmUlOiIACgkQJNaLcl1U
h9CIEAf8CRE5WHyTik4pOM+XL9HR1T2xFQXLUUr0lY3oQuyYnqRNePoS/3G4eWB7
rGIN1t87on3+ry+3VUT8Jdw/nLrpqz5Gxbk+vSpd0kqoi0QBm1oaOqSwDfC61HxB
Dp2gSFRXl2sB4CfJNw2XtaWnjD69oHV2LcvvnnXhEsiRDqXqRF2feDNNv3ivaEHz
h8cXeq8h3k5Z3xE7/fM8KhwIRV/4b4cz/IUNBLOeXF1S++LXjOmGaBfa9KiU6LJv
JgHPIZdZiWQ//EMN47eF1bV+ShlkI72ItFp3+VnCQoGXSWW8WbKg28/dJFmt9Wxj
w9TtS7calQgseOnMeaCw+ln9iEX7yQ==
=0gak
-----END PGP SIGNATURE-----

--hFDyTH2AbeoUjBmm--

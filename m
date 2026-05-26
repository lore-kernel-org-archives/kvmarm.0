Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C571B6D08;
	Tue, 26 May 2026 15:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779808778; cv=none; b=iGySVkyULjZ1sUA+SRMBKojQaZUeYA0z9GiPwV0wU62rSdKQuixHtFeCNXH99GjTtIk5xzf9MEJGtah3r1chwvU3rIVRQ14+TeZxkmo9VW3xULvEXtR4r5TaAsd0zIB/rHUvf+u0HozTg3nyaBC5RxIVeWZSUBDobJWpeIX9t6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779808778; c=relaxed/simple;
	bh=IjCdT7QUzYPO0qYM3E33rBp7fz7JoKrppWlCCqiyh1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mXSTAU+O9+8swTMBPrYy2+m2xhqjzS1+zoUSnz7MqlgTZuNtUBxDiFy+7pAmXGDvdYoHFoekhSiFE/VzViNLOCdgzGUusUN6WHtSFoQdPfR6BxKlP1ER/Y2QHuAWqJ8PbO0ZCIbqemiavmpj+UqBhj4s4mARVvPc0LxMieCivy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DEXgZHuw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DEXgZHuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C411F000E9;
	Tue, 26 May 2026 15:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779808776;
	bh=Fj96/yHeNPt6Cv4EkJ4bgbsXqIfa2PjP2NmQ5QjGnZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DEXgZHuw791/GRbMTcEj+6sGSTqq8DcjMj+sMViOavnQ7zCZ1XF093R0JwczhqgLW
	 rWzmwVldZKVRyxDJp8jkNVDFSQ4mz8lUiQzzw3d6FwTP1fVx6aVcpYivjY5fMYo3pj
	 gkQg9QVkMK9nzrCsfj5DASsHTvJhWbbnhEikgkKCmNfTO1sDzOnONxPnIpoiz/zEoz
	 68YRryRoA3VRde5fpfdWcb3qBQ2KcgLO4iSzhh59cdngtJQF7NXAy0MPsvAoKw7ZUg
	 FjEXx7lwWFiKCNp9cQOHX6p/zGyaoPiPy0Hg1JaibiaGNdDzip5H24JrHuVX8tfSYO
	 OgGLH694iilFw==
Date: Tue, 26 May 2026 16:19:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v10 02/30] arm64/fpsimd: Update FA64 and ZT0 enables when
 loading SME state
Message-ID: <733ec6da-c8de-4b6b-9ab7-1f819a1a8465@sirena.org.uk>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-2-43f7683a0fb7@kernel.org>
 <ahWWqU51Zffmhlo5@J2N7QTR9R3>
 <d8074c6b-9bc9-496e-8a74-94ac18ce9a55@sirena.org.uk>
 <ahWsRNb9uZhf46hG@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lTHQvf4c3zxfQxl6"
Content-Disposition: inline
In-Reply-To: <ahWsRNb9uZhf46hG@J2N7QTR9R3>
X-Cookie: You are fairminded, just and loving.


--lTHQvf4c3zxfQxl6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 26, 2026 at 03:20:52PM +0100, Mark Rutland wrote:
> On Tue, May 26, 2026 at 02:25:56PM +0100, Mark Brown wrote:

> > I was explicitly going for the opposite of that in order to make it
> > harder for someone implementing a future extension to miss a place where
> > an update is required, having the callers independently constructing the
> > register values feels like it's asking for trouble.

> I didn't say callers should *construct* the value independently, and I
> showed how to centralize the construction in a __task_smcr() function.

> I think callers should pass the entire value around rather than a
> collection of discrete booleans: constructing a collection of discrete
> booleans is functionally equivalent to construction the entire value,
> and we can more easily manage the construction and passing of the entire
> value.

I got that, the problem I see is that it's equivalent to passing the
entire value right up until the point where there's another field that
needs managing and then every place that sets a new value needs to make
sure it does the right thing.  I think a __task_smcr() that constructs
the value each time time as you suggest avoids that well enough.

--lTHQvf4c3zxfQxl6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoVugEACgkQJNaLcl1U
h9BPlwf/Ze/FTGkfrNEWHYQnTukgy62jd2hLEoI81w2cJWeW1iKUcQRKDOnQqfoO
tdiYqwOiv+lncrlx2l1VXph79UoTYcP6qxN3lKt1cGQVqaTEDXmtMz4uQ4ZJo5Sq
mqMEFr4VxrejxmenvuTBM4Oz9NT+nGVviTN0lZor1Kn6+8TDPhbJ5SuTCsPy1W1g
Vc+z92OsPbX2Pv/0v9diUBqEZ5IMEbDL8oGAn7XTXFkgO5ERDV5rDuMn5bza4a2c
g9SL5xHA4uqZtpCHJWFUninWXEF82rbjg3oJxg0V63ZTMsfoZaW30LH3RATwqbSw
fx5ZyMSwIve2BQRIl/4avbmXOPJBpw==
=v5ln
-----END PGP SIGNATURE-----

--lTHQvf4c3zxfQxl6--

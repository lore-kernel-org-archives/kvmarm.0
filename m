Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B212C3DA7DF;
	Mon,  7 Sep 2026 14:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788792951; cv=none; b=CQklIewHFKW+MJJqM3z2cFhYff8LdqCLbhbXbvm1i3yurdLfgRIqwMwbUEiFPi8xlMpIxRSgDs+UoPqsYagdVYc0sWD0TzBoGyUQdFH2U2XIiEa2e/JUBjia2ECvi5I72lga9H3LXVl+ma2fs4suOsGklvZp2V1DqXdOC7SrdIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788792951; c=relaxed/simple;
	bh=2jjD9H14qZFuN1A2ZEy20p76oWP14OoN1nDHd0sWhho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nMyj/mSPjSLvS+BRooqhOF194FHFVdHURo6knjiW1OaRyvY+dHnrEPA/Bgb2h73WmuKp6ncB2Mui0Hy1mmf3N+jQuKS4ROJXLul5LfJjyxXlpdcMpVS3pMaGNI6uxkbWkc29oReeunWa4DdJbMRWeNqj7CrsS8f6rd5I36+VCl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GeB0F78r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GeB0F78r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1881F00A3A;
	Mon,  7 Sep 2026 14:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788792950;
	bh=jZrePntlHVDK9rodlmxxLGUgDqQdmgMc0bpMFEHwxJ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GeB0F78rB6Y8pThJerenvvl44gFR6MWAitakMRGR8hHx3fAJn/RYT1io+zjG+kLV7
	 QFLgkRNYf/Dolcv3sEpveUNbfVk9ubRQCaIVvZoV84Tekx87cV4Yt+/4sWLzmDKWRc
	 y/etunm7qrGurs7vSFyLpC8LzsavBs4ZRO+7f0A1hDGYSi07b/r0tfWr8Bss6++GQ+
	 7BazWC7NDYoxrKRO7e9pIFMXkQaLkwgLt4uGx0QIjTjWg345+vBehr+ksPLoOKiYNQ
	 FbE06SF1xNCqx7/3XznXY0zkmsNjxaC/pE8nvtxdOqJJbSSDCTqz7UCXDYCduKY57W
	 +VS1d0RYeYukQ==
Date: Mon, 7 Sep 2026 15:55:43 +0100
From: Mark Brown <broonie@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	Leonardo Bras <leo.bras@arm.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v20 03/14] KVM: arm64: Manage GCS access and registers
 for guests
Message-ID: <1effee02-41f0-4680-9a6f-9b9f12459ec1@sirena.org.uk>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-3-f31750bdfadb@kernel.org>
 <apmfx08vccSd2MXw@gremlin>
 <d2659ac3-2f00-4fc4-8f9e-0585691a4ba2@sirena.org.uk>
 <apqA_SuoA6-TyHsS@gremlin>
 <apszJZ17KUvd6BJ7@sirena.co.uk>
 <ap7GPxGs3nhT70sS@gremlin>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ii74x8XOAcc6drmt"
Content-Disposition: inline
In-Reply-To: <ap7GPxGs3nhT70sS@gremlin>
X-Cookie: Who's on first?


--ii74x8XOAcc6drmt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 07, 2026 at 03:14:34PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Fri, Sep 04, 2026 at 10:07:49PM +0100, Mark Brown wrote:
> > On Fri, Sep 04, 2026 at 09:54:51AM +0100, Lorenzo Stoakes (ARM) wrote:

> > I think the best thing overall would be to leave the runtime paths as
> > they are and refuse to run with an architecturally invalid setup, that
> > would avoid bloating the fast path.

> Ack, it'd be nice to not have to worry about that.

> Presumably we definitely want an oops on a GCS violation in general?

Yes, the guest is going to want GCS exceptions delivering if they've
enabled them and something triggers them.  It might also be relying on
the GCS for stack traces even if nothing triggers any GCS related fault.

--ii74x8XOAcc6drmt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqe0G8ACgkQJNaLcl1U
h9AMhwf/ZEOA93+3vTR1PmXwHKzlv94Ja4BeBP/DlIKj2/RESX9cBT1C074Ii+JE
6SpAj8Gm8mWroTcAFXodksUYQmNAlviEbpV+wmiPn8mRO3HaIagbvAvGbiQYRVEP
mlcbLjt8qbCHmjiAkfL2JG2q4I7wvKhOHiQr3uRGaFuX+oAW8KRkesDw4ukC8GX8
NaxmBY8DL33LFkIQTCYlyqF68vFM55S+UD+SxrOPpswmpptwu8+WuKG4WLpkQk5S
EvjhRC2jwkT9746QCpt1Xyrilc05Xv1dkDTAa8GLHcfLwHwjkKivXcdXNFw8uLwV
9xLwVcyB8p0TztiucJK0FzKKU7/RzQ==
=KAik
-----END PGP SIGNATURE-----

--ii74x8XOAcc6drmt--

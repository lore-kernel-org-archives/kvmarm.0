Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4125F22B594;
	Sun, 19 Jul 2026 12:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784465973; cv=none; b=eN4YYGVG1W0T2k5lwrA8uGFTtBbFMykKnlZD4zf9iOXhJ1zJ0WCA5oWlojjCtTp7qjcifXGijNB2VzXypiKPeZAGwzg5A+B/0UKyUvUE7Ra2fA8vzlevZF6eYoYzHW/fZsx6TTioCIFRXpafyYwgXUCUbaqAlGMdwctCgmW/rOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784465973; c=relaxed/simple;
	bh=tNtYGC2EJFlGi7TRbEJqSxVtjzAJPz/PG74LELuNwZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DBOwjFkYMHiexh+QB/8Q92PMpL3tA0fuwZZqU5XP5goFoT+mxIU/VhtOij83qgloGwdYdl66sttzgT4HBxF3HTiUHzw4cdrUr8G+wJx/1fzPGHITYLX0LWnSpeJM1RTD643msKonPahDRXc2YUz7mYnS9DP12HD6NQliiQi3ClE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RMvdkFlp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RMvdkFlp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBBB1F000E9;
	Sun, 19 Jul 2026 12:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784465971;
	bh=dz6nstKPpdzr3m3YV5N5XtGEglEWs9DHWHKhwuF1feU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RMvdkFlpGDTGUknV5qMv7bvE17VSPmAKTlGBUF0dGAFTJIm5YEMiHRqDBCQodxSTY
	 Ge9fz3IG2p0LxJTSK4uvO9VLO6lxN9I70ZNr31wO8qXETMT7OK6O8mjwj7gxC5H5Aa
	 ewZJvnjGNPAZL9onmVrfy8cENJCMslHIdl+eM6QVFGhkQSwKCyZSTlY25S4ltfuh0P
	 Kv+mAVZazCnspK3pbXmA3iCAqR8+wEd0HAJlUkfnPPYL3D6hA8HBRc0oR91uWmdD+Q
	 n2D0/dLV9W+Ualim3Ug8bC9mPBH3yO+XeTq+BG9fS7qDxo6NwPxPQ+6bf2ob3AI5YZ
	 FHoaByhPLJAMQ==
Date: Sun, 19 Jul 2026 13:59:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v12 02/29] arm64/fpsimd: Update FA64 and ZT0 enables when
 loading SME state
Message-ID: <df08b81a-13b6-4273-88e7-0627063d4e9c@sirena.org.uk>
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
 <20260709-kvm-arm64-sme-v12-2-d0301d79ef58@kernel.org>
 <ali39DG6qie7XTuD@J2N7QTR9R3.cambridge.arm.com>
 <15a9ae14-395d-472a-a5be-9e46524fb493@sirena.org.uk>
 <3c76650f-ddda-47ae-a676-86016d8e39a6@sirena.org.uk>
 <CA+EHjTw9rGvQyev-4i7zkO5bPPZKGYn858485dCs8iHmCi0t3w@mail.gmail.com>
 <43f21c65-c5ba-44a3-9741-548390df369b@sirena.org.uk>
 <87a4rnqsuu.wl-maz@kernel.org>
 <18229974-b26d-4eed-82f7-7af7e1c26634@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cL9XJNQtGuI5OnYK"
Content-Disposition: inline
In-Reply-To: <18229974-b26d-4eed-82f7-7af7e1c26634@sirena.org.uk>
X-Cookie: Courage is grace under pressure.


--cL9XJNQtGuI5OnYK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 19, 2026 at 01:40:28PM +0100, Mark Brown wrote:
> On Sun, Jul 19, 2026 at 09:35:53AM +0100, Marc Zyngier wrote:

> > So leave this is a straight ISB, no optimisation. Once you come back
> > with actual data showing that this is a terrible bottleneck affecting
> > real workloads on real HW, we'll look at it. But until then, please
> > keep it as stupid as possible.

> I've already left the KVM hypervisor code like that - I only updated the
> code here in the main kernel since that keeps the end effect for
> existing systems and workloads the same.  I am aware that there has been
> a great deal of attention paid to the barriers we have in the context
> switch path so I am concerned that other people might have a different
> view on adding one.

It does also look odd do a conditional update of SMCR_EL1 and then
unconditionally add a barrier after it, even if the conditional
update suppressed the write.

--cL9XJNQtGuI5OnYK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpcyiwACgkQJNaLcl1U
h9BpXwf+JYCe7VHaj7TfzZjCVUNf+N0uc2PbXDf9kiTps6TxEHMS/Lt7w8P5oqs3
RDVLBZIPc43UyiYr27EH+NxHBS/jOGSdzNHCjkN4TN6hg+IEE08yL7RbnSH85hzX
+iXiGHYKj6uzU0VxOCmw48BLoe1wkh4iToQT+ffGDaAd1yxraMDKWk1gom8j6Eaa
Br6L+q2EfnbvuqtpZWEQ1WPGuRrcrcnTyrkEz2eQbNNAyMD1boHr9LHNeCRFoJSn
2nDxtRYj6T2Vocmt59QX4JajZwM9fbfsZOR5NszhGW7Tm1EqgxbVg439ieY+ryMw
AXrrkxhculDDRGWss27Ds2c+Cu+6ww==
=CtjM
-----END PGP SIGNATURE-----

--cL9XJNQtGuI5OnYK--

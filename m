Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC00837A4AF;
	Fri,  4 Sep 2026 21:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788559011; cv=none; b=WxU6LsACShjMIY2SVsgVBlq9jgoUTvwqpuHdUjA1Zp3cdSnAlrCaqZ091a9+5V7stbrKJZctiqOSZp03PUT6KXluU9FqlnPXyZtqPFnIlRREau+rNJv1AHD0iz+IFfCE7GVJ7RmaAEeqVD80coOxEZAONdoQOrd87mFILG8ogIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788559011; c=relaxed/simple;
	bh=mDIvNTMMYeK7GsPNDD/Z4tGz1X/p8URxHyfgdZ5Z8DM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oijWaEgT5mv0r5ufE1pnti8HfRMA18Sk2tITEOhzYXlYm4YHCYgEwHgKPZp0gf2LU1X/IkVbfqjECfZQQ2CmytZmC6ZOnPXIVF4gQDO8pySunXYRfVJaZ+bFC++rEJY5vYknMN56nMqR/zTfNW57AdDnI4KV0jEXHd9SLnUtCEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RbHCANIi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RbHCANIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2201F00A3D;
	Fri,  4 Sep 2026 21:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788559010;
	bh=WLLN6D/aLaiSZCc6VRO4G+fmb2F/w3i1SeqpgrJDHo4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RbHCANIivrUJeL+oLXqYTr+R4r3BsqdM4cQvevCYwT6Dx7hhRQHEHuxPhEGrzY8Dc
	 93YNYH2AahXbS2hroX7eS4yqeIyySc5cq+STIsNypvImYjwxw+dGXsELvtimyuL3sf
	 MGiGdlE1MZPDGo129o2qeReweS2riv51lC9YBXs/xgw1lRrAdMTMYheHdKdtPLwtCi
	 DE0DNyXJJBHHOeuBboM7SwnWn9AS+YeWeqvy+b+zppTFa/pbyK6mIu+qp5r/5LUq0e
	 WH9h7w+zBBOfDbeaMJbvDG31qh4E1s4THHW8iZgBuey2+RCgsZeZfaFEDtWExZbzdz
	 3zz/va3OKRI+A==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 44EAA1AC52F1; Fri, 04 Sep 2026 22:56:48 +0100 (BST)
Date: Fri, 4 Sep 2026 22:56:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v20 06/14] KVM: arm64: Validate GCS exception lock when
 emulating ERET
Message-ID: <aps-oNeG3RjzqHQs@sirena.co.uk>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-6-f31750bdfadb@kernel.org>
 <apmUQETDlhTIuJIY@LeoBrasDK>
 <2dfd8a6c-42c2-466c-b3d6-2313466fc3d5@sirena.org.uk>
 <aprEsh-xogu8zFnK@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TZSwDlEzCnBqnKB1"
Content-Disposition: inline
In-Reply-To: <aprEsh-xogu8zFnK@LeoBrasDK>
X-Cookie: My vaseline is RUNNING...


--TZSwDlEzCnBqnKB1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 04, 2026 at 02:16:34PM +0100, Leonardo Bras wrote:
> On Thu, Sep 03, 2026 at 08:22:44PM +0100, Mark Brown wrote:
> > On Thu, Sep 03, 2026 at 04:37:37PM +0100, Leonardo Bras wrote:

> > > > +	if (kvm_check_illegal_exlock_return(vcpu, spsr))
> > > > +		return false;

> > > >  	/* If ERETAx fails, take the slow path */
> > > >  	if (esr_iss_is_eretax(esr)) {
> > > >  		if (!(vcpu_has_ptrauth(vcpu) && kvm_auth_eretax(vcpu, &elr)))

=2E..

> > We need this because ERETs from vEL2 are handled in software, modulo the
> > NV3 fast path mentioned at the top of the function.

> Oh, and this is done in __fixup_guest_exit() because vEL2 is not a=20
> nested guest. It would be it's guests' exit that would be dealt in=20
> fixup_nv_guest_exit().

> Is this correct?

Well, it's as much because that is the point where we handle the EC
specifics.  __fixup_guest_exit() does general handling of guest exits
that applies to all ECs and then dispatches to an EC specific handler,
it is common code with nVHE.  When we have NV then fixup_nv_guest_exit()
is run beforehand to do extra handling that applies to all ECs in the NV
case, but any EC specifics for NV still go in the relevant EC specific
handler.

--TZSwDlEzCnBqnKB1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqbPp8ACgkQJNaLcl1U
h9DFBwf8D5V/G8mDF5LtW3QQNUxhO8RJk17+tPVKa2yUGPdsVLrSA7bw5X/vbgDg
WS485cIPTSH/+3VE9pa/EbV3gQps9QWT4FUIyMNEPS1Uk4M1VYYzRnXUd8vN7E7n
9ZSEkjKz+O1MXm198k5LeY3vrLTDSH2ACHa+cIkp1Mf0eqV5cahEjEZYw0A0HL22
5hYMKI69FWMHCU/Xu+KaNRuLmqA76LyzFWNCXAAuI9E4gM3Y4DVzmj0fwcAADwwP
RRcvCAIazVSryyiTq2LnpE42nRWNAbTM6AUbwWEnvsrs01HU3YABGNkKZW04ilMu
LMPVCobegoaSeXNobAfZsKW92a3nSA==
=kVDG
-----END PGP SIGNATURE-----

--TZSwDlEzCnBqnKB1--

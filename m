Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E9041A905;
	Thu, 20 Aug 2026 14:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787234841; cv=none; b=VP38O7LFMtxn9he9cEDgNS2R7X6ADnDDDKmaMoXleAE3OSuUDmpL893a/hpSf+tjLcQ+wf4HNZoHrT8SeJ2zaSelzfQ8R8+Y9HXliQQfiDXODN1CPc0rc0V1OOv0fNoxB80eRwJAzHs6/KugcOsDrIPZrGjST5fpMTHGACeh5Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787234841; c=relaxed/simple;
	bh=BWFZu1UB5WOFgUHvBfz9LP+2PZviTxTRd7ekOqmlm2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CJL8WB8h4TdGvFneHAvOf5Zvw2/lNXBVg4irZsD7ktOsBDH4yDkjSypT1ywToKsPlBVX9GVlUFRgyyxTZPZr6xqcd6r+B1YPmETYBbNFDIy4GlHDwcZI/uJl7eJfMYRv5kdEUKox7K2a5TO/+KvprwAybzIspIX70mQUIOoYLTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nOb0EU04; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nOb0EU04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0F61F00A3A;
	Thu, 20 Aug 2026 14:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787234840;
	bh=YTVeD8lMjWa5ij09OpkdIK39+vXoHqSUmwQ1NzOwQ0U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nOb0EU04uLhNxtmCrhdLxsW06tKdI4Mr01zN4KF7OSNGGbd/es3K2dRht9Kfpya/c
	 eDKO/zM8W77rLsmDXUr6d1hv6O+MUhji4n9a3NEmcflNTqBgEs3d/05mKXxNic53at
	 77v8juvy560VMiUb943P+w6nZ4Ffn67WS55/v++1vdKsYxoNweSSAu/tBwaCTWci81
	 Yy1+J97F9lPHDx8QKqgjSAbqRLVgJSJlRC3rUhiP58LnOM1UrXSnpX3lIwBpRyw66e
	 L57ReVVahTU7VivIF97C5JnlNwdQU+b0pg1smvG/xPw/zVvkR/+K2v5N2oF3ZsaDbs
	 gT2ja8o7NAE2A==
Date: Thu, 20 Aug 2026 15:07:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v19 03/14] KVM: arm64: Manage GCS access and registers
 for guests
Message-ID: <97ad6e83-b22b-4881-b644-66fa99f68d64@sirena.org.uk>
References: <aoXamcdKoMynTkpX@LeoBrasDK>
 <48be9e5d-357a-4863-8682-8b3f34c69723@sirena.org.uk>
 <aobUGyq8nInJYkdA@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="M7nrGBP04zh/ghJC"
Content-Disposition: inline
In-Reply-To: <aobUGyq8nInJYkdA@LeoBrasDK>
X-Cookie: Happiness is a hard disk.


--M7nrGBP04zh/ghJC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 20, 2026 at 11:16:59AM +0100, Leonardo Bras wrote:
> On Wed, Aug 19, 2026 at 05:46:00PM +0100, Mark Brown wrote:

> > This is just because there isn't a preexisting ctxt_has_tcrx() check
> > already there, FEAT_GCS architecturally depends on FEAT_TCRX and there
> > was a request to make this explicit in the code to try to optimise
> > things a bit.  The compiler should skip over both blocks at once if TCRX
> > isn't there rather than having two separate tests or static branches.  I
> > didn't add new checks where there were none since I expect that to be
> > unhelpful for code generation, you'd get the reverse situation and emit
> > two checks.

> Humm, but then why saving GCSPR_EL2 does not depend on TCRX/E2H? Or maybe=
 a=20
> better question, why are not GCSPR_EL2 and GCSCR_EL2 saved in the same 'i=
f'=20
> clause under ctxt_has_tcrx() (and E2H set), if they are restored in the=
=20
> same 'if' clause?

> As you mentioned, GCS depends on TCRX, so it should be fine, but just by=
=20
> reading the code I see:
> - GCSCR_EL2 :
> 	Save if 	GCS=3D1, TCRX=3D1, E2H=3D1
> 	Restore if 	GCS=3D1, TCRX=3D1
> - GCSPR_EL2 :
> 	Save if 	GCS=3D1,
> 	Restore if	GCS=3D1, TCRX=3D1

> Which looks kind of confusing for the as a first time reader.

> Does it make sense?

I agree that the current situation is a bit hard to follow, I'd actually
originally written things without the explict dependency because of that
but Marc wanted the optimisation.  There's similar things with other
registers in the current code (eg, the PIE and POE registers are in the
same situaton as GCSCR_EL2).  One thing I did miss here is some nesting
inside the PIE checks for EL2, I'll update for that.

I think what would help here would be to move to generating more of the
save/restore sequences rather than open coding them, we could have lists
of registers and then use data about the feature dependencies that the
architecture has (hopefully it's already in the MRS, I didn't check) to
generate these optimised feature checks rather than having to open code
them.  Possibly even list features and generate some of the register
lists, though that would need far more special case handling and it's
*much* less clear if there could be a benefit.

--M7nrGBP04zh/ghJC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqHChEACgkQJNaLcl1U
h9CqVAf/bGuZAca2zy1jw2JFlzhPianxfgGGbPyR/9IGHqxer652lSCKy3wH9Bq6
8zu10796n5f3hVlvSDCqZDtmJgjv8phYk/ZO3n23QeVxyuC7JcHtdNO7i1sp+az1
gLNRTmC8dUTyjDbr8jKnlt4CHPcTTjbv52XDWdrM1Akuw6c71MUFCxn0xEm4emfK
fzIRBYJhILEaZXwWE/lUcmuSsg3crIjFY3rItDLow0wrzFdRRBEcbVsayk6cAdKM
o+cxdaVEerFzRrSEIk0C+p4aJ479s2VQW3GxopC0LfZynh/S5fzWjDXueenbt/q3
3n1mavmIU4gRdAimBYPrSNRPboQchw==
=RN3F
-----END PGP SIGNATURE-----

--M7nrGBP04zh/ghJC--

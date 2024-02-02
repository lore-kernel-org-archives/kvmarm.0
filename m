Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D165D46448
	for <kvmarm@lists.linux.dev>; Fri,  2 Feb 2024 13:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706880664; cv=none; b=OfROahY0u9932WJzVWmLYUqt4vTl632WUqZQxHLZ+QIaAwg/UNpLLoDqlzoo64yMWtl+ySxtxu45PiRpI7FrfvmL03Hhj/OG8ntgUzzAfR/43bR+qjyjWOVrDdZ/01EOoahfTCi3hNWWjZZPIgIrBJMNCNEcxHBiCJDI1TgHYEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706880664; c=relaxed/simple;
	bh=A9NaAVFzxh6xMtlLojco0S+of3aUGoMNBajCF+WEn3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JspBKwNvkGGW3Wv0uHQT54q+Wf2weq5Vb/XydvXYaazsaNakye/hMSu4MO4SmPVapVS5TeTTPaQ5KZEp7Pry7QAsv5zEn/MGLQ4pgli+KJnYHeQcheLxWY+CfEqtS6HA6vFaK8rUyisap58pIRdj7jwOkFh9bHpGcmttse0yQaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qAtkPYc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qAtkPYc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB722C433C7;
	Fri,  2 Feb 2024 13:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706880664;
	bh=A9NaAVFzxh6xMtlLojco0S+of3aUGoMNBajCF+WEn3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qAtkPYc8gXQ6V2154QLnwDl0S3s8NqO4k+MfOzPHpK0lGrs2gYfBIwNWeNtVsmCR9
	 BmtN9VzRLJn75QYvuz5q7KwJ+FyhhdQq0YVldpsz1xoPO78Bgw285tp+pA5hEpeEv+
	 uZ4zRSZcrKpxmn1RqisJvkKL5JH7lWBmc68KN0n5U2N2HNrCiqvQIXQu5c4rZAS1lU
	 HBFXZ2Wwe+hBgq/tuBBKu5NmE1S12vbB4TAC/FmG27LYDaVmg1FkI7SDxe0Nqa21l7
	 +5A5y3F/KlWIH74DtGyhTVB5FkvSE1/6t/vwnNUYWfEw6rdJl0wD5B+Wd7tQoFHpZ7
	 Fg8XHJCFbrGbQ==
Date: Fri, 2 Feb 2024 13:30:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH v2 06/25] KVM: arm64: nv: Add sanitising to VNCR-backed
 HCRX_EL2
Message-ID: <4911fc9f-5eeb-4861-b44b-f80f9f512fb1@sirena.org.uk>
References: <20240130204533.693853-1-maz@kernel.org>
 <20240130204533.693853-7-maz@kernel.org>
 <ZbytUKPFYiP2cdd8@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MPiD38BZhwoZZEbm"
Content-Disposition: inline
In-Reply-To: <ZbytUKPFYiP2cdd8@linux.dev>
X-Cookie: Do not write in this space.


--MPiD38BZhwoZZEbm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 02, 2024 at 08:52:32AM +0000, Oliver Upton wrote:
> On Tue, Jan 30, 2024 at 08:45:13PM +0000, Marc Zyngier wrote:

> > +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, D128, IMP))
> > +		res0 |= HCRX_EL2_D128En;
> > +	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, THE, IMP))
> > +		res0 |= HCRX_EL2_PTTWI;

> Ok, not fair. The latest public version of the ARM ARM doesn't have any
> of this. Where are you getting it from?

We publish updates of the system register and instruction encodings much
more frequently than we publish updates to the full ARM, these are
released as DDI0601.  You can currently find them at:

    https://developer.arm.com/documentation/ddi0601/
    https://developer.arm.com/downloads/-/exploration-tools

but those URLs might change at some point (the second one has downloads,
the first is a directly viewable web page).  There's also DDI0602 with
SVE instructions.  These are generally the first place that gets updated
when new things are added.

--MPiD38BZhwoZZEbm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmW87pIACgkQJNaLcl1U
h9A/cwf+JjX4+OtxqQN0ZE4w4tomIEOi352GLIB9ArXkwBSKwyCQaq8GaI+qICo1
Shr6zuGSJc8TrL1YfVfztsBItZ8pFiTE/Z85E7IWuv1U3xSsMZaTLq4KNJc1Y5J5
OA/9etVZUXevmUR72Ua6vpGfxDtX4WvjXGid+29g231qKK9i/zdUi/oP/tqFKFtS
2dWydiefESKMBaBrISzIH0XDaaDihlrI+Vt7wO722JFNPlQ5kHkBMs2upawj9kBP
7XHxJaZmCMXeg8AdqHVVPZMGMTEoURvutJar+d+tuJvIP9wcjeQTwGKhSUQ2OC8R
z24lpdgTzVyu06csuV163+4cn3ed+g==
=m4ZP
-----END PGP SIGNATURE-----

--MPiD38BZhwoZZEbm--

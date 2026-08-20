Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA327479873;
	Thu, 20 Aug 2026 17:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247982; cv=none; b=EDNxuGAq5IG9Lxcs6vEhbsJqTnDKdw+2CIdXaNgOPZgO1IfwmVC9sSoBM1X8eBcxGFMEqetT9JNX/PwWqJLJbEjqve2+4/D8aSlxk+P+9ja0gYj+bqaGGIn9waJJWArt2esJJZuGM0JjDaBnrcmVb28ILdT4KBX7PHXw/hxylrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247982; c=relaxed/simple;
	bh=hWIQt8gAunIPMaqoFxebZCkDoeJrWPUidCYegi/maMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tgM/H/K97fB9/DcxeKF4hoM5p3AwGV5nma3RoFb8RglN0t/BO3HzVnNzrVWW5h5XjF86XupzO/zjxQutYbluvVwaf3/g0JNjZy86IH15U11NXZ5XxqAhGhTnHxUsA1qp+RD7CAZ5j/qxXFJrGRAh7yeJw+/2hF6zyeCvBRbmKaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sgo4pIwT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sgo4pIwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650FF1F00A3D;
	Thu, 20 Aug 2026 17:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787247981;
	bh=IuL6duWr+CYzX2VNv28Ah9jjzSSNSLqAkLn62+Nh1qc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Sgo4pIwThzrHFDsns964yrkniMujs5PZApj4wsrhwvpaMUaaWUrbO30PuBEkq9Qg+
	 +aTPa45D8Xp1NZX6rxPbxC9HO5u0pihgvOuvqmlhZaDuMayY+uqAKfUneQBEfUnzbr
	 Se89N4zlfh9chg9Du3nBwigNwHQaLS49vvIqCuyAbdzVDBx5x8ZLcNNc07Arz2tnQI
	 i5XLX5qcNpm0CmrPmMZ0vKXFHnVMuI751MGLZjGUB5GknRIQfrcgGEb1fmbdO/8Gow
	 LB7MB6EGiAI8Njq5ZUgRchO0J2+LbBizsJNkbX7FlAYeIePcFr3QIQO8S00oYa6fu8
	 F50xjqYJ5cQtw==
Date: Thu, 20 Aug 2026 18:46:15 +0100
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
Subject: Re: [PATCH v19 05/14] KVM: arm64: Set PSTATE.EXLOCK when entering an
 exception
Message-ID: <328346e2-3ace-411a-87ac-31d4d71fb66a@sirena.org.uk>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
 <20260812-arm64-gcs-v19-5-9105afd828ac@kernel.org>
 <aoczkgxXzqtotl9G@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xPTUhSm0fjJwoIXt"
Content-Disposition: inline
In-Reply-To: <aoczkgxXzqtotl9G@LeoBrasDK>
X-Cookie: Do not try this at home.


--xPTUhSm0fjJwoIXt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 20, 2026 at 06:04:18PM +0100, Leonardo Bras wrote:
> On Wed, Aug 12, 2026 at 08:12:04PM +0100, Mark Brown wrote:

> > +	// PSTATE.EXLOCK is set to 0 upon any exception to a higher
> > +	// EL, or to GCSCR_ELx.EXLOCKEN for an exception to the same
> > +	// exception level.  See ARM DDI 0487 R_WTXBY.
> > +	new |=3D compute_exlock(vcpu, mode, target_mode);

> we have here, instead (naming is bad):

> 	if (is_exlock_set(vcpu,...))
> 		new |=3D PSR_EXLOCK_BIT;

> this way it looks more like above sets, such as this one a few lines=20
> earlier:

> 	if (kvm_has_mte(kern_hyp_va(vcpu->kvm)))
> 		new |=3D PSR_TCO_BIT;

> How does that sound?

I have no strong feeelings on that TBH, I can see preferences either
way.

--xPTUhSm0fjJwoIXt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqHPWYACgkQJNaLcl1U
h9AwsQf/S3inTcyT1hgfbbryNePusskL/mmJx87RtuQbYbRy7diJF/0tJ9xVra03
qEGdF968NEAo0tQ3c8ufBUdLaeeHZPdm+rnaDMLJPGGj1O9Bj1scUrvA2oxx7oLt
jzTSO+ZFh3u3518O/QyUApNibBHtJdazfSZfaBkOFUcwJZN3QBO6hhfNKSlCpD1/
OYNT2Y5yuhgdIgWgCDKwH5K+Cd1PtvLt4cFqT5T3slwMcPiAtU/eCZZv96Wgu+Qu
O8+7FmKmryrXBmmHBr36WzkzsOskNyZ6FOzvkFN3zokCEoHcZm8ZKJtE53pxIU9p
uTqNNqstrEWAcMGEmIdNGRkhZopBWg==
=Ma8R
-----END PGP SIGNATURE-----

--xPTUhSm0fjJwoIXt--

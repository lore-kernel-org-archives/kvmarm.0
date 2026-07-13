Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3519919F121;
	Mon, 13 Jul 2026 12:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783947225; cv=none; b=nEDWscJ1ffrZRO0As8FZlmQtRrA9ER/0dHCdiN0OKh373x0fYIkKFCRIzo5buxT5byQGXUPYZbvvhNKznUVD07kAWxPYBdgocZrsUjXDtjs/gIMVyphft9nZvpZLS+QpuS9kOGmGAza0fCvXxiht257ydu0FzL5JIIilJ+bknDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783947225; c=relaxed/simple;
	bh=67vC3E8mCRha9hYVm2Kif9yJocvFNOZSlF8fz0bW2T0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZGTUv6u4uvJNYgrhdSL7PduP851Ay/+vsdRqPfTUSHuHKDvm+i1+X7cMF7t4sOaUpU9tgeCotny5kTkwvaq4xI7n3Tn1y8dAWipSl+sc0po1f301Unelyo5y0psjhTnNrdBiNJF+vFGzPYhHRtbZ/LkG2o1dOsX3UjehXjJFFVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RQH+fvdU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RQH+fvdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949301F000E9;
	Mon, 13 Jul 2026 12:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783947223;
	bh=67vC3E8mCRha9hYVm2Kif9yJocvFNOZSlF8fz0bW2T0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RQH+fvdUuTn7iqWED4cXgkbpL5b565ibEf3+ckEuPZWQBL/DEvzxtTBPyheXNrD4d
	 AZwGO2Knfc9zJNOzMTQgrrYRaLAN494GiWJ/SPMoTyGZ9Tg8iQjT6y9Hkn5C9TkJsm
	 T84nVgN6fr1H4NqdnrSjhYak/IQwENtNL7uN1RzQ1hjjRhXU40owmbwRCc1T0BjMkQ
	 ydN7KVbJeeuJ+eolkwL4kS5PnId4sOXDLLjC/5M22skK0JUWp4DOTMnI1PPOD1+EjG
	 5ioQsFsS++SqPpCXVk+cD7wghqLhJ2psbuWd5GZfyL2U13Mq4oemSUbU4I9oDyn+0k
	 SiXEplyovH7Ig==
Date: Mon, 13 Jul 2026 13:53:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v12 04/29] arm64/sve: Factor virtualizable VL discovery
 out of SVE specific code
Message-ID: <a6275b3d-d32a-4658-ae02-6d7af347b3c7@sirena.org.uk>
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
 <20260709-kvm-arm64-sme-v12-4-d0301d79ef58@kernel.org>
 <CA+EHjTzVLnXu1E3guYVABoxLLE4foTM6j1fdew-phtFrBqJ2Fg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="NySqPGRbhkwbqql5"
Content-Disposition: inline
In-Reply-To: <CA+EHjTzVLnXu1E3guYVABoxLLE4foTM6j1fdew-phtFrBqJ2Fg@mail.gmail.com>
X-Cookie: Courage is grace under pressure.


--NySqPGRbhkwbqql5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 12, 2026 at 03:12:31PM +0100, Fuad Tabba wrote:

> nit: this is a reimplementation rather than a straight move, the
> no-virtualisable case returns 0 (and drops the WARN_ON) where
> sve_setup() returned SVE_VQ_MIN. No change for SVE (that case isn't
> architecturally possible), and 0 is correct for the SME case this
> helper now also serves. Might be worth a word in the changelog, since
> "pull ... into a separate function" reads as pure code motion.

That's reasonable, I'll update the changelog.

--NySqPGRbhkwbqql5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpU39AACgkQJNaLcl1U
h9Bv8Af/esNQJhQ1vINdTOSWx7oXRYHDQ9JpDR91x/iv9ZbQBhC+p0iJQXu+UHv1
P3S9sApgeTWxnXK3aRduh//PZzX/hVMaimqGmWv0lsaGZgRiE0YUchgqYiAnnRhU
q6xuvn5obacZHXSTTca7zfibwlFUqCPj6axMIYvIAQzWIvKNuWUdpv0JHU/x1WAq
GGKUVhJrTYpFIEYZx18nHFisaImH5GOyLTI4Eug3A3gi514G4frwvVN/1i62szTD
5N+xYmXfbNiuwfSWlKYj+wn66vI8LxZh7abrF/vQeSGEhYmmpaGxsRbqd8St65wv
Jc0e8hG53Lv9IuTXclPHyyA7Ui+agA==
=2Dqq
-----END PGP SIGNATURE-----

--NySqPGRbhkwbqql5--

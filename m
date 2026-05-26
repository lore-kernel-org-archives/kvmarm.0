Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A0737998A
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 15:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779810147; cv=none; b=dPw3VTxpyRRjnJmulgIvYimpfA7Cm56N+QXnr67LO8sGmDJScXQx2o9b7l6qPD9j5rK17ueuxaGS2OuNxE+Jqs+ZDAxgPpBTobBlMUszfYiuicYUOKCRMto1WvVa46h/MSYvK/ISyRVqwA/fk70MZ4wFtWXBKzzyasExPFI20dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779810147; c=relaxed/simple;
	bh=xlWfipCfpVrBkBpAdX/tN7AaGo2a4SCb8Dd/ea6jDuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jikzko+lBGIFrLp4Yzbq1z41kd8LHHfFeWbgly18v2hQioN5beHeKdJtgEIIFgjpaP02p/q3BXxnxeCZ/wcDd5QAIXhEjjA6uwJ0gH+rffSCVGBkb1awZaRKYiBmbXEb/DekWG93TcgsqfQ728BcRKv0YccCRbo8n8RP668JHD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ho9Mwa3W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ho9Mwa3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC651F000E9;
	Tue, 26 May 2026 15:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779810146;
	bh=xlWfipCfpVrBkBpAdX/tN7AaGo2a4SCb8Dd/ea6jDuk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ho9Mwa3WhHSdo7xEuFgtdR/cQ34pFe1npVVRysfDY9CzFIYmnThmBFnEWJ5ComMBT
	 8ZDkNmuiTIalJbOf3wZJNkifn2t10XtdzMU7bvaPnk3AD6hEZ2xEU3t5VGHtrieSFg
	 A4naN5Rir2bdI/5TGpEIQgQCTlvjo7NrDWVxde2kTku9DBDjz4kCc1XeJA2mShNEFD
	 xAKasSBbNS2/rVIXRGIwIcXYGBMOFd3sfj7p8ALlsmHzb1w339CbIG95fgGNNceOjV
	 vmd4dXJFrx8dQG1wAIrvRbSfcjfctFypiIssNDbsc5JXKpURjFOi+/ytHF17JU0j30
	 p49X/wQTnXt5w==
Date: Tue, 26 May 2026 16:42:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, will@kernel.org
Subject: Re: [PATCH 06/18] arm64: fpsimd: Remove sve_set_vq() and sme_set_vq()
Message-ID: <7eaaac65-cb58-4808-8b54-83cc5beb0b42@sirena.org.uk>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-7-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OMsXyzo8b24o7qHQ"
Content-Disposition: inline
In-Reply-To: <20260521132556.584676-7-mark.rutland@arm.com>
X-Cookie: You are fairminded, just and loving.


--OMsXyzo8b24o7qHQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 21, 2026 at 02:25:44PM +0100, Mark Rutland wrote:
> The sve_set_vq() and sme_set_vq() assembly functions (and the
> sve_load_vq and sme_load_vq macros they use) are open-coded forms of
> sysreg_clear_set*(). There's no need for these to be implemented
> out-of-line in assembly, and the 'vq_minus_1' argument is unusual and
> confusing.

Reviewed-by: Mark Brown <broonie@kernel.org>

--OMsXyzo8b24o7qHQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoVv1wACgkQJNaLcl1U
h9AE8Af/cdVzDAtuMAzFV5XhnfVEkEQuVDx/Ewt1ITp0WL10LAgaKMiNGY+fn/bs
UPn297NFIf4xDb7KwuGQPO/ocs2IaTsYL9Dh4WMPrW7Y0RlhzEgP88u4ZRaN2gvr
+t83aeAij9rWvCkqf1g9CcASMz//VMwG5nMa2NKySYpT7aNdxBBVB8Vy5ixRNHJe
Al9r9xg0MCdxVr+uhTNQ8smW2uyNKXyVTHKA9tjfuPqa+SY9K88uSHdMUdnDZ0uP
8tLk90UaleDzvvUlaYjtAN2idk3+xdnIHPVq+3XHk5q34ntAHzvmEUpq8D2xdo3I
oIUR+8gcyi/EB8CRprGHPM0HoV5qhw==
=pLbJ
-----END PGP SIGNATURE-----

--OMsXyzo8b24o7qHQ--

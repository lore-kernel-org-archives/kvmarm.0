Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BCB13B58A;
	Mon, 11 May 2026 12:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778503359; cv=none; b=mUxFXwoKctENBnsKeZ6rdCQpGgdbGJQAC1b/UepV8lM2bW3GP7/MRPWMXetWQj/V2xFXvpLHu6ft5Z/UcydJgRn6yGBY92+ETo9kZxUbuBpG/qN5hZGmCquP4+dudhGQtkxmu+z6aT1wSs53PRhdI0B1SDCoO2pT8MyTBdWhGl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778503359; c=relaxed/simple;
	bh=pYD09DsDxe/u4ilOmhS2skYVkR2myP8qJ3xnhphSpY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f17GgS+EK9pKr01EfzjaiqFcoYh6MuGAnwhVqnXxXULFlZartKEiS5kcb6Mc5Y3mTc4hRa7W8QvJOJ2zmW/+F7KX0UYRSzGlaTSqFZ5ceViv9GMu1NwmyoQPN2b6XPLM4fluHLoytlJiA0eYtzzSt/GxM6Qi1l02+7qJ2OiMrFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HMzeD+F0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HMzeD+F0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16463C2BCB0;
	Mon, 11 May 2026 12:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778503359;
	bh=pYD09DsDxe/u4ilOmhS2skYVkR2myP8qJ3xnhphSpY8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HMzeD+F0LmEMwTQFrhGfdrsCKn7booeRX+vlAVri2V2f1V76IeHzz7BG5DWjlKuZ0
	 eSjJkgMpPpwmwAMME13LOZwUH6jrKtJPa+UcsUh5muV7bnkRdiOA7SzHRjM6p+6BvR
	 M9AnGxDOZIpUs5Vq+n8Tvozcad7h5hkJKqCWufFSdA9qoLdhy/OeFJ5T05eHTwDqLm
	 3aTaWWQqIMZX7dlXuRsdLYoZDGO1nzl9JT8V1/PKw3uAWx5b2OXAE+g64TuOysxHa0
	 chlfaziVpuZGn4QmcVFFCiRbVOS04PpKxosmBJAO6qkAZLHmQwB/qePt9ltyN9lF+M
	 3cEJb51enKcuA==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id EA5DB1AC58A9; Mon, 11 May 2026 13:42:36 +0100 (BST)
Date: Mon, 11 May 2026 21:42:36 +0900
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
Subject: Re: [PATCH v10 04/30] arm64/fpsimd: Determine maximum virtualisable
 SME vector length
Message-ID: <agHOvFiI1e3y_ur4@sirena.co.uk>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-4-43f7683a0fb7@kernel.org>
 <agGwWE2hcj9O4EGu@J2N7QTR9R3.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8I5lQUED2RQSZNsg"
Content-Disposition: inline
In-Reply-To: <agGwWE2hcj9O4EGu@J2N7QTR9R3.cambridge.arm.com>
X-Cookie: Truckers welcome.


--8I5lQUED2RQSZNsg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 11, 2026 at 11:32:56AM +0100, Mark Rutland wrote:
> On Fri, Mar 06, 2026 at 05:00:56PM +0000, Mark Brown wrote:

> > +#define SME_VQ_INVALID	(SME_VQ_MAX + 1)

> Does using (SME_VQ_MAX + 1) for this make something easier than if we
> used 0?

There were checks for VLs less than $THING which were causing annoyance
IIRC but it should be workable since we shouldn't offer SME to guests if
the invalid VL comes up.  I'll look again when I'm back from holiday.

> To solve all of the above, I think what we actually want to do is find
> the largest uniformly implemented VL which is smaller than the smallest
> partially implemented VL.

Yes, that's what we're going for.

--8I5lQUED2RQSZNsg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoBzrwACgkQJNaLcl1U
h9BD+Af+InI7f6CgI/Kl7rjYPDy/01C1QRQjXjxrG9nJHf2fp57ZuQPJO32v1e+8
54g+pxbwOJMMyR87wxnj8tTcQbJQqtIAiInLxPlIs06Wxs4/hV20mhOD9fDIPDq+
0DK2xWI2URuTWI8xvkWN7v8Nzi9uWmJ9AIuunvFYrz9GPUZIICEiu7+/sm4bD8fd
9RjnDI1/gmn6NjVlFh81aWDaBFFqomK1WGMwa1NVnpDTj6sv++fyeh0/0AdgpJMv
haYVOScpgtqOh/V0+Ryxf+zlYjFf37AIOTPvweJ7zWYtcHPqXmQLgXe7VUseb2Xe
IpiAILfnTKYKlw8vN0jO1Wcdzjwt4w==
=5P29
-----END PGP SIGNATURE-----

--8I5lQUED2RQSZNsg--

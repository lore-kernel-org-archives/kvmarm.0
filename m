Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB123126BB
	for <kvmarm@lists.linux.dev>; Mon,  8 Sep 2025 18:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757357529; cv=none; b=ski1xi88WWKObQlyuw4YBq3HjWtdCS9YR46MMnEArXq04MxsP/JlM0x0YXhozDuKezc2+EmAuxV1C3zZ5zAUwYJtIMlXEcsbw0XZBtInAjHjESQNGKbmWhjZpuSOYHms7UCeEf2GKYYh3snxCKon7IBp8e1kWeLmDJCxFSX5sJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757357529; c=relaxed/simple;
	bh=m68Pt8x6Gn2SMxw3EHoWKD57HOEBiJN6VoL6dEjKCmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jFL6kZwzbW63fn23sJow+U57gKK2NBciqiSup1xDSJ3aRu3dQd11BTUbbBv5elLHrEbQFonFJcctGaoFZHANdkJXKM2DFrbDB873LA5v+FFPoYHBgLR9TdIoPdl0xffFCoJIwuuW+iqIhnTnNGRrMHBa0FUwu4GdGjU5b7XO1Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PfXlh9Wt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PfXlh9Wt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9710AC4CEF1;
	Mon,  8 Sep 2025 18:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757357528;
	bh=m68Pt8x6Gn2SMxw3EHoWKD57HOEBiJN6VoL6dEjKCmY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PfXlh9Wt3uLCHIQwCbJQ1AFsSlCFT02O0yKivlP00jueALrQTy1gJ/abqUQIWyTSx
	 tsZ2rdHv3+CB1BCOremg+o21YgtdsScUBx+bWZ/MUmGaz+19r+hZ/KSWpzDL736z7C
	 Zm3iA/T1M/adp7a6BvyFX9hQtFYB2MG2Mmvv5ySlqBn0nSybPKQdbQF73rLs/AAOVo
	 cmrvoMYWX6k3TqqR9vB/4lA/etwNklkBhx1puWo3e+3/mFdAzIqVRvSdgPucbe+X0J
	 KoPnghRafy9CtOrcwg5FjsKgMoIrn/xExfjAaYL+WI3LLzdX7X90Nrk3znsuXJFvDl
	 DjfdOJN6Omtfg==
Date: Mon, 8 Sep 2025 19:52:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
	mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com,
	vdonnefort@google.com, qperret@google.com, sebastianene@google.com,
	keirf@google.com, smostafa@google.com
Subject: Re: [PATCH v3 9/9] KVM: arm64: Reserve pKVM handle during
 pkvm_init_host_vm()
Message-ID: <22a563c0-886a-4ccd-84e5-3093986b164b@sirena.org.uk>
References: <20250827101949.4089456-1-tabba@google.com>
 <20250827101949.4089456-10-tabba@google.com>
 <1a248f14-60f2-4f8f-8b4d-3c63e602fd54@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="i0zjPKqI1O/A7XsB"
Content-Disposition: inline
In-Reply-To: <1a248f14-60f2-4f8f-8b4d-3c63e602fd54@sirena.org.uk>
X-Cookie: All celebrity voices impersonated.


--i0zjPKqI1O/A7XsB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 08, 2025 at 05:05:56PM +0100, Mark Brown wrote:

> I'm seeing the KVM selftests failing in -next on multiple nVHE
> platforms (pretty sure it's all of them) which bisect down to this
> commit, when booted in standard nVHE mode the selftests are all failing
> to initialise with:

I'm seeing a different failure on the same commit with qemu in VHE mode,
we fault during pkvm_init_host():

<12>[  112.802609] kselftest: Running tests in kvm
TAP version 13
1..34
# timeout set to 120
# selftests: kvm: demand_paging_test
<2>[  113.800187] Unhandled 64-bit el1h sync exception on CPU0, ESR 0x000000005a000000 -- HVC (AArch64)
...
<4>[  113.812056] Call trace:
<4>[  113.812571]  show_stack+0x18/0x24 (C)
<4>[  113.813078]  dump_stack_lvl+0x60/0x80
<4>[  113.813448]  dump_stack+0x18/0x24
<4>[  113.813711]  vpanic+0x124/0x2ec
<4>[  113.813965]  abort+0x0/0x4
<4>[  113.814198]  arm64_exit_nmi.isra.0+0x0/0x94
<4>[  113.814517]  el1h_64_sync_handler+0x2c/0xac
<4>[  113.814812]  el1h_64_sync+0x6c/0x70
<4>[  113.815266]  pkvm_init_host_vm+0x20/0x48 (P)
<4>[  113.815629]  kvm_dev_ioctl+0x264/0x80c
<4>[  113.815960]  __arm64_sys_ioctl+0xac/0x104

Full log:

   https://lava.sirena.org.uk/scheduler/job/1794785#L2258

--i0zjPKqI1O/A7XsB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmi/JdIACgkQJNaLcl1U
h9Cvvwf+Ku5H3aGiM3kg/odyEYKyIW4ICYg1jzmGniLupkXuokO0cH1M366JiPzT
ZC9GuQ3A254VEX5dtn5tmrqunRSdw5Bg56ZQGrv5Vm5L9CYfJOKZYFXeLGl6RVoG
80tGrMayx0aEBZe7LnJfBrdsueaic4wZgpy/BwZOk4IEJoTe9ZGnuJS0nAITdQL0
jW95c0sv1Xwou087X3A0keW8BvK+rBkfChvOlKwZZYfqqr5eGxrGUuY95zSovG02
jv2RgxU4jyvBjE09PGVaXefRD2a2V9LPi4Od2buIjFflquoopAV1936DJ9FnjSLb
Yc784pyDabfwRQcOoup/T+fkRcBkyA==
=nG4j
-----END PGP SIGNATURE-----

--i0zjPKqI1O/A7XsB--

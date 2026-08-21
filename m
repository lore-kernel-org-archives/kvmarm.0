Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6943B7753;
	Fri, 21 Aug 2026 23:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787353287; cv=none; b=IDaDrgK+/u5Bcgt4fL8OtQ7LwYqjogVYkbMrv8XcYcgR9B0ajWxCWucTdONyhRZrkQ3h5QZH8hOIDmqD4zpVAkST4IpRmQ5aK3T/wzbLeJtXJYCi3JT3Emb5ZYli4nUUgCNoxBUMfiPiVv32r1xWKVuAk79bxZs1nVxaFcIaSVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787353287; c=relaxed/simple;
	bh=03VkZjfehRNlVo5fNmIMDZ/aWcfIjCbGXvZ2PtdSPuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pf5GKnD4kox/Vc/HOu8ZjFp7/Ph6uLohlg+sUTc+TNG3bM9xoVqRFdP+s32DW73sUr277+6J249fSGByWHxfinBiR5Np/Jsqnd5osfcxH1rL30eoBJHPRI/TgPRGG1Q+Cr4UKwJQjUUbpaohR/gjL79iPchKacrcKRhBvT7itDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FYZDHLdv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FYZDHLdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34A41F000E9;
	Fri, 21 Aug 2026 23:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787353285;
	bh=hzKschgZvZGUF+9ira6QlB794ZxUSF02QB3OINA6m74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FYZDHLdv2T49SIJc79K3OCHvMXN7BV0y4762ev5Ts0hcMOLFdsSlaquyA70X7Jgp8
	 uQTnZz4XLTvX+bLUhUdn4IGb0wmorlxDuaAlgDLR6Wgok/c6LuvvvCnfCTarRc1LNV
	 eLR8FQwjwvGzfPPE2O/+xQaiUCz8DtiIcgk2pD3Xmy1+36pPpLTpzHkgxFK3Eh3tzM
	 Gbe/y5X2Vm4RkPrLuQT4LWaRjbUYRu9OYga5R9ve84gzepx+56HDJe2jc8TVT/Vt9T
	 IEkhnfC5i5ck4OIWSj6/DUBF3Yn2EwKLUoQgJjzzJOOKcBbu0S6f3gtMiYl9qa3TJ6
	 eDAio2HmeO2tw==
Date: Sat, 22 Aug 2026 00:01:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei-Lin Chang <weilin.chang@arm.com>
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
Message-ID: <f46a292d-5d60-4117-a2db-c54e7acfd0f1@sirena.org.uk>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
 <20260812-arm64-gcs-v19-5-9105afd828ac@kernel.org>
 <wu4y6mfg7avc32gg55vkxy565errbecy6kgckmthrjvuben2sc@xmrqciocdmgb>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="47Ov55ow126IRHuo"
Content-Disposition: inline
In-Reply-To: <wu4y6mfg7avc32gg55vkxy565errbecy6kgckmthrjvuben2sc@xmrqciocdmgb>
X-Cookie: Package sold by weight, not volume.


--47Ov55ow126IRHuo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 21, 2026 at 03:15:26PM +0100, Wei-Lin Chang wrote:
> On Wed, Aug 12, 2026 at 08:12:04PM +0100, Mark Brown wrote:

> > +static unsigned long compute_exlock(struct kvm_vcpu *vcpu,
> > +				    unsigned long mode,
> > +				    unsigned long target_mode)
> > +{

> > +	/* When taking an exception to a higher EL EXLOCK is cleared. */
> > +	if ((mode | PSR_MODE_THREAD_BIT) != target_mode)
> > +		return 0;

> This is essentially doing an EL comparison, which is also done in
> kvm_check_illegal_exlock_return() later. Would it be clearer if we
> follow the EL comparison pattern there? exlock_el_from_spsr() can have
> more use too.

Yeah, I wasn't super happy there - it's partly a question of what's to
hand and already in use in each location.  The rest of this code is
using mode.  I think given your valid concerns about the naming around
parsing out the EL in kvm_check_illegal_exlock_return() it's easier to
go the other way, make that code look more like this and hence sidestep
the naming issue.

--47Ov55ow126IRHuo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqI2L8ACgkQJNaLcl1U
h9DSmwf/Ti0qrhR56sAQYWMszAac7N7dyJ3/ETOQS6tSsbmRY66niGgwbEcvnlmT
iO/PPDo/y69zkAb/VJI+/SwgyfEdUgsZ1EaoiU6svLwuuGCs5EAVZuKgRbJgUy6K
f5hqKyIKwydaHgcMm5lyGK830e1Wnd9Fs/huhmqm1L6/0XJzAo4qdXv8rwQRyAD/
fIsWz2zBB2eOw8hrICNHcsj9HUlwGb9GXIHi6OkLZUFvCI3S67LRMJB6RSP04erl
jZyM5Hm6qhCQoxlwVQvrrrnv7rrnUdbpsoHHAHymeTBfiRvEs5hPwv/elFOsaFGu
qg/SXCg5sZWsIWQtuQ3IO69sfo5bMQ==
=6Imv
-----END PGP SIGNATURE-----

--47Ov55ow126IRHuo--

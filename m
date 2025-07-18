Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DC0221F1A
	for <kvmarm@lists.linux.dev>; Fri, 18 Jul 2025 22:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752876110; cv=none; b=Sctx1oUawksD7ZSBRbFn+41JAZVVaBWfSu4qtd94bgiHGXgnBecvA8mau764EWkrQ7AJJqrs4+JiZKMnqX+s4TJnj5nIY+Yivg0oTFO5rRH7iNBIuURxeSJ/dwKqeqZvV6Qj6Kz3r7vud+Mmxkw24jE0S890DoPZTEqisSfloOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752876110; c=relaxed/simple;
	bh=hXuCQQJ/aBYxr9xdPI3GXwnfAYmOgsrm4RW3Xdli+5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rkyamnvubrt38//iT+DSgtQAYK9EFMYQ+AbUAXXCuKzT7RJCeP0Lpxd1KvEFQQjormiKHmamzPQedmoXHyUCanOrFONSvYXYw1b1fUmI3vhlfhE+JgcqzZQ5PF+WVd7zENH+QwWZFyxBjVgkaWfpdbpbT/ftSLqUs0MmNgykVts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PA0UGopi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PA0UGopi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B3DC4CEF1;
	Fri, 18 Jul 2025 22:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752876110;
	bh=hXuCQQJ/aBYxr9xdPI3GXwnfAYmOgsrm4RW3Xdli+5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PA0UGopic/T6ZhAUp2bfPw71SpMUKCAk1QYO2jhw/yTpgLxMS+Hq37gg0rKtsJ+J4
	 CmOblSDgXWoMgiKJyK9VXOotpjcCL/46vfIS4XA8A+mI/aOjfUr+7+nB7a7PG8vAUI
	 dFtJYY0nTqv34+ePCe54nzVgKC9RwRlfZxySbm/iV0mwlG4uXklEe0x5py9+r/G7n6
	 tmRYbclG2KllKO1BHAwU7zRHfSvB9snN7fwIv5z9Mk4oaVKHaRjd6rbnJ83CqiKj/X
	 +o6a9ecC4xa+VVPMNR0Zxlc+BOS+icCgptfgDebZwY3vVfvwPPJ+CRS/YxHGpVA86T
	 lRls25ILisHEA==
Date: Fri, 18 Jul 2025 23:01:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v3 18/27] KVM: arm64: nv: Take "masked" aborts to EL2
 when HCRX_EL2.TMEA is set
Message-ID: <18535df8-e647-4643-af9a-bb780af03a70@sirena.org.uk>
References: <20250708172532.1699409-1-oliver.upton@linux.dev>
 <20250708172532.1699409-19-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fIi54NbSaRe3rg+P"
Content-Disposition: inline
In-Reply-To: <20250708172532.1699409-19-oliver.upton@linux.dev>
X-Cookie: What UNIVERSE is this, please??


--fIi54NbSaRe3rg+P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 08, 2025 at 10:25:23AM -0700, Oliver Upton wrote:
> HCRX_EL2.TMEA further modifies the external abort behavior where
> unmasked aborts are taken to EL1 and masked aborts are taken to EL2.
> It's rather weird when you consider that SEAs are, well, *synchronous*
> and therefore not actually maskable. However, for the purposes of
> exception routing, they're considered "masked" if the A flag is set.

For the past few days the external_aborts KVM selftest has been failing
in -next on a number of platforms with:

# selftests: kvm: external_aborts
# Random seed: 0x6b8b4567
# ==== Test Assertion Failure ====
#   arm64/external_aborts.c:19: regs->pc == expected_abort_pc
#   pid=2598 tid=2598 errno=4 - Interrupted system call
#      1	0x0000000000402f93: __vcpu_run_expect at external_aborts.c:85
#      2	0x0000000000402197: vcpu_run_expect_done at external_aborts.c:97
#      3	 (inlined by) test_mmio_abort at external_aborts.c:136
#      4	 (inlined by) main at external_aborts.c:323
#      5	0x0000ffffacbd7543: ?? ??:0
#      6	0x0000ffffacbd7617: ?? ??:0
#      7	0x000000000040272f: _start at ??:?
#   0x0 != 0x4028f8 (regs->pc != expected_abort_pc)
not ok 14 selftests: kvm: external_aborts # exit=254

This appears to be happening on many, possibly all, VHE platforms being
tested - nVHE appears fine.  I ran a bisect, fixing the selftests
version at the one in -next due to the renaming of this test, which
pointed at this commit.

Full log:

   https://lava.sirena.org.uk/scheduler/job/1585350#L3418

bisect log:

git bisect start
# status: waiting for both good and bad commits
# bad: [d086c886ceb9f59dea6c3a9dae7eb89e780a20c9] Add linux-next specific files for 20250718
git bisect bad d086c886ceb9f59dea6c3a9dae7eb89e780a20c9
# status: waiting for good commit(s), bad commit known
# good: [04991f9d52f128b90c39e4e26c27a2bb03f82eba] Merge branch 'for-linux-next-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
git bisect good 04991f9d52f128b90c39e4e26c27a2bb03f82eba
# good: [04df9b7af77fe92aac33c006e8d48dfcdf12bd47] Merge branch 'main' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
git bisect good 04df9b7af77fe92aac33c006e8d48dfcdf12bd47
# good: [ef3a80d9cf6739dcb358b47052470a474ca9202e] Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/ulfh/mmc.git
git bisect good ef3a80d9cf6739dcb358b47052470a474ca9202e
# bad: [a4ff72f2a847bbec65a94387fd64e9673fd3d997] Merge branch 'usb-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
git bisect bad a4ff72f2a847bbec65a94387fd64e9673fd3d997
# good: [eb7455bf812f1ce0f91f3e6d64726d821bab0f15] Merge branch 'edac-for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git
git bisect good eb7455bf812f1ce0f91f3e6d64726d821bab0f15
# bad: [31a02958732db752412d656c35689a1bac43b86d] Merge branch 'next' of https://github.com/kvm-x86/linux.git
git bisect bad 31a02958732db752412d656c35689a1bac43b86d
# good: [c10f79ba55517270cb35953ac2f82a56cf9dbf74] Merge branch 'selftests'
git bisect good c10f79ba55517270cb35953ac2f82a56cf9dbf74
# good: [b7ba58c6c588667934ca3738f84b439ec0c4a075] Merge branch 'non-rcu/next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
git bisect good b7ba58c6c588667934ca3738f84b439ec0c4a075
# bad: [a826c1169d283ed62a5eaa7872d763545d263b60] Merge remote-tracking branch 'kernel/maz/irq/gic-v5-host' into kvmarm/next
git bisect bad a826c1169d283ed62a5eaa7872d763545d263b60
# bad: [da53a2014ebb996e07218d1491ac8e12ed770780] Merge branch 'kvm-arm64/doublefault2' into kvmarm/next
git bisect bad da53a2014ebb996e07218d1491ac8e12ed770780
# good: [fff97df2a0bd215979ae224b97e3e4075030a953] KVM: arm64: Route SEAs to the SError vector when EASE is set
git bisect good fff97df2a0bd215979ae224b97e3e4075030a953
# bad: [a90aac55324920de988cc447f4227c04ad769351] KVM: arm64: selftests: Test SEAs are taken to SError vector when EASE=1
git bisect bad a90aac55324920de988cc447f4227c04ad769351
# bad: [075c2dc7367e7e80d83adae8db597e48ceb7ba94] KVM: arm64: Advertise support for FEAT_SCTLR2
git bisect bad 075c2dc7367e7e80d83adae8db597e48ceb7ba94
# bad: [59b6d08666f0424f3e0ade08ab664fac65a09c5d] KVM: arm64: nv: Honor SError routing effects of SCTLR2_ELx.NMEA
git bisect bad 59b6d08666f0424f3e0ade08ab664fac65a09c5d
# bad: [ce66109cec867c9afd2ee1ecf1aff8d73cdb2f89] KVM: arm64: nv: Take "masked" aborts to EL2 when HCRX_EL2.TMEA is set
git bisect bad ce66109cec867c9afd2ee1ecf1aff8d73cdb2f89
# first bad commit: [ce66109cec867c9afd2ee1ecf1aff8d73cdb2f89] KVM: arm64: nv: Take "masked" aborts to EL2 when HCRX_EL2.TMEA is set

--fIi54NbSaRe3rg+P
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmh6xEkACgkQJNaLcl1U
h9Dt0Qf/SErbdg12z9NvpyRypTvRU7C7Nl4qe25cjMUyqiyIXAGwBuSSg6otIkOm
LZoXmtzin6CrraGdpi7fr+zwUOUROp3FRjA6Gr74W+dgxotivMhhVxat3mCCbxxD
pAuo/f23SKNGfuXTwSn1YBKZgSp7U6Z0YbLjTJW4tJTPM6D465XkLyaQtxHUcsAy
4QL4vbWGCEdB4OTdCNVi5c8Zzc+8pwjt33uu4MP4aY27MKv8p+WiGOCgr7jHA0vR
8/exywm5AlT6v2CafckSNQKBJ0HzYUldLyoOtr+f0YgD0xVNZB1us/FLLjCCO3aJ
Cai+4qFtFg979B1HdDYyQBQjCHk4UA==
=B6cG
-----END PGP SIGNATURE-----

--fIi54NbSaRe3rg+P--

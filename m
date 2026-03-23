Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D8B18FC80;
	Mon, 23 Mar 2026 13:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273084; cv=none; b=LTDICnhKOQGT8CFeS/ywWhyfO+FgKn/+V8pWfesEGSKb9xmtYOYREDqXO1WJJ0k1vnRCxQjikzls0MI+OFqEPWsNKlSccg8zC2rcLMzs1+02nPEn8PCa5O8l5r+lP8qb88CzPcBEQdv7LN9HgfIlMjVlZekp6U5OdvUMfzMCf6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273084; c=relaxed/simple;
	bh=USMzPIu1/1gwLcFqDyGpJPU6fyEk3mOxUeH0qtfA7+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fCWtBI+lFxmIVJqgUmUj3ILKtR6QxVKA8m9e+LAdYphF7IM+izBFmXB2GXdEHkD10SnCqq2wvLVIFut+uz5spGpLiUlx9B8APXzWgaTRnjZJQkNc0Z09pjOIJgJuNotSJWRKMcrFGkGpWTAgFH6weP6sGdQa3fsIuaYTmcQGulk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OU6XHM0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OU6XHM0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D04FC4CEF7;
	Mon, 23 Mar 2026 13:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774273084;
	bh=USMzPIu1/1gwLcFqDyGpJPU6fyEk3mOxUeH0qtfA7+4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OU6XHM0UffNDTEB4SvGp5qtXj77lQnim9j70B1Ao/FtqQGkpL+JILHVyU1MoPJY5a
	 gfpBJjq2mBHAPZq74NqdSN+wdgGM/f56FnhflLgMyj2EcFrPWRtCBQ7su1v/gh231I
	 9tfs/46j/7w1TUsxkZCCgEUXLBaWWHSBY5OSi6j1Y1v+D00Es5+/h29/vGfRvG5+U1
	 M+kpRsaJo6ZOmGg+X5uD+a2fXCSK69WJraAal7nkqdX+smv4l6dWcSQ37W+UoVqBrz
	 3kCBsVmPfJ5bGAOqihh/B0q9cWA9qaCxrfbs0dcySWU/bytIDRnhH7SLTgPn7Jgtdu
	 Enppi209j2aIQ==
Date: Mon, 23 Mar 2026 13:37:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>
Subject: Re: [PATCH v7 12/41] KVM: arm64: gic-v5: Sanitize
 ID_AA64PFR2_EL1.GCIE
Message-ID: <3be4971e-31a4-4033-9583-88d7fc96104f@sirena.org.uk>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
 <20260319154937.3619520-13-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MlKsc4YS4+0PkdYN"
Content-Disposition: inline
In-Reply-To: <20260319154937.3619520-13-sascha.bischoff@arm.com>
X-Cookie: You will triumph over your enemy.


--MlKsc4YS4+0PkdYN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 19, 2026 at 03:52:50PM +0000, Sascha Bischoff wrote:
> Add in a sanitization function for ID_AA64PFR2_EL1, preserving the
> already-present behaviour for the FPMR, MTEFAR, and MTESTOREONLY
> fields. Add sanitisation for the GCIE field, which is set to IMP if
> the host supports a GICv5 guest and NI, otherwise.

...

> All of this extra work is required to make sure that "legacy" GICv3
> guests based on QEMU transparently work on compatible GICv5 hosts
> without modification.

I'm seeing a regression in -next in set_id_regs on a range of platforms,
including physical ones like the Toradex Verdin AM62 and i.MX8MP-EVK,
with a GICv3:

# ok 105 # SKIP MTE capability not supported, nothing to test
# ==== Test Assertion Failure ====
#   arm64/set_id_regs.c:651: test_reg_vals[encoding_to_range_idx(uc.args[2])] == uc.args[3]
#   pid=3573 tid=3573 errno=4 - Interrupted system call
#      1	0x0000000000403047: test_guest_reg_read at set_id_regs.c:651
#      2	0x00000000004024cb: main at set_id_regs.c:805
#      3	0x0000ffff9e85251b: ?? ??:0
#      4	0x0000ffff9e8525fb: ?? ??:0
#      5	0x00000000004027af: _start at ??:?
#   0x1111 != 0x1001111 (test_reg_vals[encoding_to_range_idx(uc.args[2])] != uc.args[3])
not ok 20 selftests: kvm: set_id_regs # exit=254

Platforms without a GICv3 appear unaffected.

Full log:

   https://lava.sirena.org.uk/scheduler/job/2584795#L4111

bisect log:

# bad: [0ec822710d040a1e4a13be04494dc9f0462f8ba7] Merge branch 'for-linux-next-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
# good: [0e4f8f1a3d081e834be5fd0a62bdb2554fadd307] Merge tag 'parisc-for-7.0-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux
# good: [09e70e4f119ff650d24c96161fd2f62ac7e424b0] regmap: Synchronize cache for the page selector
git bisect start '0ec822710d040a1e4a13be04494dc9f0462f8ba7' '0e4f8f1a3d081e834be5fd0a62bdb2554fadd307' '09e70e4f119ff650d24c96161fd2f62ac7e424b0'
# test job: [09e70e4f119ff650d24c96161fd2f62ac7e424b0] https://lava.sirena.org.uk/scheduler/job/2565604
# test job: [0ec822710d040a1e4a13be04494dc9f0462f8ba7] https://lava.sirena.org.uk/scheduler/job/2584795
# bad: [0ec822710d040a1e4a13be04494dc9f0462f8ba7] Merge branch 'for-linux-next-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
git bisect bad 0ec822710d040a1e4a13be04494dc9f0462f8ba7
# test job: [a5d4dfaac4b2810ec2be80d2a9a1facce7dc554d] https://lava.sirena.org.uk/scheduler/job/2584889
# good: [a5d4dfaac4b2810ec2be80d2a9a1facce7dc554d] Merge branch 'mtd/fixes' of https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git
git bisect good a5d4dfaac4b2810ec2be80d2a9a1facce7dc554d
# test job: [d04c0e637ff3323b010804dbfe349fb9c1309253] https://lava.sirena.org.uk/scheduler/job/2585075
# bad: [d04c0e637ff3323b010804dbfe349fb9c1309253] Merge branch 'dma-mapping-fixes' of https://git.kernel.org/pub/scm/linux/kernel/git/mszyprowski/linux.git
git bisect bad d04c0e637ff3323b010804dbfe349fb9c1309253
# test job: [e3d585ed3ff891a00c2284fef4be9cf8581735ab] https://lava.sirena.org.uk/scheduler/job/2585150
# bad: [e3d585ed3ff891a00c2284fef4be9cf8581735ab] Merge branch kvm-arm64/vgic-v5-ppi into kvmarm-master/next
git bisect bad e3d585ed3ff891a00c2284fef4be9cf8581735ab
# test job: [0a9f38bf612b195e04236d366ed9f769ce14cc27] https://lava.sirena.org.uk/scheduler/job/2585330
# bad: [0a9f38bf612b195e04236d366ed9f769ce14cc27] KVM: arm64: selftests: Introduce a minimal GICv5 PPI selftest
git bisect bad 0a9f38bf612b195e04236d366ed9f769ce14cc27
# test job: [4d591252bacb2d004b7c7f5db439bfa23b552ee7] https://lava.sirena.org.uk/scheduler/job/2585661
# bad: [4d591252bacb2d004b7c7f5db439bfa23b552ee7] KVM: arm64: gic-v5: Implement PPI interrupt injection
git bisect bad 4d591252bacb2d004b7c7f5db439bfa23b552ee7
# test job: [da92ff15ca4c5b0f75ec1cb3d2e275db2ff2c810] https://lava.sirena.org.uk/scheduler/job/2585906
# good: [da92ff15ca4c5b0f75ec1cb3d2e275db2ff2c810] KVM: arm64: gic-v5: Add Arm copyright header
git bisect good da92ff15ca4c5b0f75ec1cb3d2e275db2ff2c810
# test job: [070543a85adce329672012a1fe35fa48c76e02d5] https://lava.sirena.org.uk/scheduler/job/2586294
# bad: [070543a85adce329672012a1fe35fa48c76e02d5] KVM: arm64: gic-v5: Trap and emulate ICC_IDR0_EL1 accesses
git bisect bad 070543a85adce329672012a1fe35fa48c76e02d5
# test job: [a258a383b91774ac646517ec1003a442964d8946] https://lava.sirena.org.uk/scheduler/job/2586455
# bad: [a258a383b91774ac646517ec1003a442964d8946] KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE
git bisect bad a258a383b91774ac646517ec1003a442964d8946
# test job: [f656807150e3e1c6f76cab918e5adfad6d881d58] https://lava.sirena.org.uk/scheduler/job/2586592
# good: [f656807150e3e1c6f76cab918e5adfad6d881d58] KVM: arm64: gic-v5: Detect implemented PPIs on boot
git bisect good f656807150e3e1c6f76cab918e5adfad6d881d58
# first bad commit: [a258a383b91774ac646517ec1003a442964d8946] KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE

--MlKsc4YS4+0PkdYN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnBQjYACgkQJNaLcl1U
h9DTIwf/W12+7bv3l6vdsZYzXz9UkyBV+fFwNob5fA9ESs077+n5J/rLY2sDZ9f4
5q9rL8PMztjFc01LhDZ20SS96O1fHDMG3zlM5cqT71ydvqYbXxDjeUGDJ2q04mM3
EpSZWfAePSmWXtfrKNpPyvv/tUixTjBx8L8njZN76ub+6j/G1/JmQLZPzK/p9HMZ
04F7t6TyjzyTc66+9MWhnOT0YuCoeW0F40l0DGmsCkS4UvUo4ZGWCOgH7dhxB7Sa
bIwBBg1uQ3slkJSZt4SDENiBbDKVvMrsKD5im8ne4vsZSlzhmxI2YX0RiKRdFtwq
Qv3jM/t8g0tmkeezGlCcrKRdh+1U4w==
=ZAl7
-----END PGP SIGNATURE-----

--MlKsc4YS4+0PkdYN--

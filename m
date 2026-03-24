Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED863368BC;
	Tue, 24 Mar 2026 12:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774356450; cv=none; b=RUSsn7vAJh+SnbRPmxV6sHHhc9ze4/6stqcCpzkxlzRsGmbv81k0LLNf0mWIpL2IpKDUB4pkHKOj5IwpxWuSZynKPtJNECIzvARyJw/P3agQqKPUpMX9yquZHBRjdq2Z2LPR2Zh0qnbp3MzKFq9nKvepMWngws2tzMTQaGxCIWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774356450; c=relaxed/simple;
	bh=Hs5NN0Xw501p0mYPPTi5mdNMUytgK95JTGwv0k/Zx+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SmLjt75OcE+gu7pEoo3XqNW1rvJGsg86giYGxgm4+p79+w+a10bm2QWjxg50OISuMPepFgOZbisn8eF+u265FjfUYJdQPFWlQ+mcdPPGTe8UrkEf1hIm5NMpRVtXjw/XYBa5OHU/bAIFZxa6E1VmdK9aHtw8ZallNxGAuNmNNmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rw/d6G4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rw/d6G4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C91BC19424;
	Tue, 24 Mar 2026 12:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774356450;
	bh=Hs5NN0Xw501p0mYPPTi5mdNMUytgK95JTGwv0k/Zx+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rw/d6G4Ezmrp/6pLXfqsGb8zsT2oIIOuHYmS1k5dR423pXOfKzc9+gX/F7EFKXdya
	 MNMl/hEf685MQw6FX0fmM8qVRqr9x7zeey0RVmZV0BTCVMyzHFxKMkpkTEcSeLd0Q9
	 6o+zauJhYa2bhFGbTi68F4/ucakqTDzOvty9LS0jowVgeblfddwHZX25iIK4NoSOF1
	 Ay2GqQlNuYlcUFWVOh6e0ZK2gMjr07eLw2YnVFkkWUFT3rv189Evft5bBZ1ogsyZXi
	 t6p6t4kAQRJnZY+Ld8vQ0hpJonJUNVR9y2IgdVvRsBDEFjPy5OWgchWzzUq2gcJSDS
	 1UXm/irWTzgzw==
Date: Tue, 24 Mar 2026 12:47:24 +0000
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
Message-ID: <638a3453-91c9-4a76-8241-25d5c27ca518@sirena.org.uk>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
 <20260319154937.3619520-13-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="E0V79KpFpV4nuoMQ"
Content-Disposition: inline
In-Reply-To: <20260319154937.3619520-13-sascha.bischoff@arm.com>
X-Cookie: Should I do my BOBBIE VINTON medley?


--E0V79KpFpV4nuoMQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 19, 2026 at 03:52:50PM +0000, Sascha Bischoff wrote:
> Add in a sanitization function for ID_AA64PFR2_EL1, preserving the
> already-present behaviour for the FPMR, MTEFAR, and MTESTOREONLY
> fields. Add sanitisation for the GCIE field, which is set to IMP if
> the host supports a GICv5 guest and NI, otherwise.

We're also seeing an issue with this in the aarch32_id_regs test:

# selftests: kvm: aarch32_id_regs
# Random seed: 0x6b8b4567
# ==== Test Assertion Failure ====
#   arm64/aarch32_id_regs.c:25: read_sysreg_s((((3) << 19) | ((0) << 16) | ((0) << 12) | ((1) << 8) | ((1) << 5))) == 0
#   pid=3111 tid=3111 errno=4 - Interrupted system call
# sh: 1: addr2line: not found
#   0x10000000 != 0x0 (read_sysreg_s((((3) << 19) | ((0) << 16) | ((0) << 12) | ((1) << 8) | ((1) << 5))) != 0)
not ok 9 selftests: kvm: aarch32_id_regs # exit=254

which for some reason only manifests on TX2 of the platforms I've seen.

Bisect log:

git bisect start
# status: waiting for both good and bad commits
# bad: [e3d585ed3ff891a00c2284fef4be9cf8581735ab] Merge branch kvm-arm64/vgic-v5-ppi into kvmarm-master/next
git bisect bad e3d585ed3ff891a00c2284fef4be9cf8581735ab
# status: waiting for good commit(s), bad commit known
# good: [f338e77383789c0cae23ca3d48adcc5e9e137e3c] Linux 7.0-rc4
git bisect good f338e77383789c0cae23ca3d48adcc5e9e137e3c
# bad: [0a9f38bf612b195e04236d366ed9f769ce14cc27] KVM: arm64: selftests: Introduce a minimal GICv5 PPI selftest
git bisect bad 0a9f38bf612b195e04236d366ed9f769ce14cc27
# bad: [4d591252bacb2d004b7c7f5db439bfa23b552ee7] KVM: arm64: gic-v5: Implement PPI interrupt injection
git bisect bad 4d591252bacb2d004b7c7f5db439bfa23b552ee7
# good: [da92ff15ca4c5b0f75ec1cb3d2e275db2ff2c810] KVM: arm64: gic-v5: Add Arm copyright header
git bisect good da92ff15ca4c5b0f75ec1cb3d2e275db2ff2c810
# bad: [070543a85adce329672012a1fe35fa48c76e02d5] KVM: arm64: gic-v5: Trap and emulate ICC_IDR0_EL1 accesses
git bisect bad 070543a85adce329672012a1fe35fa48c76e02d5
# bad: [a258a383b91774ac646517ec1003a442964d8946] KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE
git bisect bad a258a383b91774ac646517ec1003a442964d8946
# good: [f656807150e3e1c6f76cab918e5adfad6d881d58] KVM: arm64: gic-v5: Detect implemented PPIs on boot
git bisect good f656807150e3e1c6f76cab918e5adfad6d881d58
# first bad commit: [a258a383b91774ac646517ec1003a442964d8946] KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE

--E0V79KpFpV4nuoMQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnCh9sACgkQJNaLcl1U
h9DYIgf/SuArUXAvR0Exh14zdhXrCO8O+CXwvECOEycekzRm3hTdQJRvNCTvnCqE
yBHraxmR8jdNYvqUn06djFs123wiu1bwJqjk+eC/CFTqTTNe0LcW/vmexBTMxehg
8mH1Emm+3VGCM3PZhf/60jySeNIygDszCT4ox1GKsiZ8c8vk2unqcBBHkp5hNwlZ
ObRq3RJYU6zl/SC6TY0BOG1XhgVwtaAuqegoVN7jy1RLIIoesXUqmQj+XglPeqxS
m/NgqXRuBB4e2ZuXMDVNf93HtxYtFxm1D9qnufpBzlTWFzbtX6XGMAdG7gopjYfw
d3jkKW90HAa5sy77547VHa19kKQxnQ==
=DImS
-----END PGP SIGNATURE-----

--E0V79KpFpV4nuoMQ--

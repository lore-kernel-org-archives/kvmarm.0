Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1310C3176EB
	for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 19:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771614545; cv=none; b=o6uOCCD+9toYt73mEFimAgyHVJEDAsWcTX3ZxiJx81b5rFrYdoXPAs2DFmwIm0883VwfiR163IpPGQs6XEABARGYEss7Zgnw5i5S60MOFBIGny639pJ6lKIGLNfban/SgTWL5vnLQgVWX9DVvR7X5nQ2igfdYqUX6lzEBprwWTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771614545; c=relaxed/simple;
	bh=cficQLvFW1xnbalHv2i28cVFq4nhHX5+c3ubaVEri3A=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=m7lgcMhIoCVhvRXkTGTJKs6B+bjEwrTXjnUQ2/8m3UfgcmYWgDyElSgknLiNlLHWoJ831Udot1XCz/HSEkumsxSAzMhKsgsEnmMwHCC6EGyjUpODjPwhP+L/SEQgVXqZFq0hao/DgVLvkhrhNWh25Pb91GL5DKboBldgr3xa3gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a8Bvg4F9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a8Bvg4F9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9CBC116C6;
	Fri, 20 Feb 2026 19:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771614544;
	bh=cficQLvFW1xnbalHv2i28cVFq4nhHX5+c3ubaVEri3A=;
	h=Date:From:To:Cc:Subject:From;
	b=a8Bvg4F92sL1ntiObWb2zc6QaSN0lney+8+qmZvVBq3vzUd9nMZK3DcNyINhs/idA
	 ouo2knHcjqaBT4vqs7UJBW6UedN3jrAc1jaso3TXpKTC6CPeirg6cYs/cUWo+YWlYT
	 xI1qx5kUslezdT45KJ14bG8eNJxDhky5a2/JXsyJEryHn2IRkMymgwnfCWTKx6ZZkH
	 icEXWJ/kcB4eJVEHf7a1YEcwDWr3E9jWK1KIi+q1uhaHgU+Bsz8bER8u/36dsr01Rt
	 dsgbeur8jr0d5M9WcmaVt88lln7gOcPIUWiLD5k2KnER053G0gm29nKUU4lSvEHFma
	 TJzDSW6TWnsog==
Date: Fri, 20 Feb 2026 19:08:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>
Subject: pKVM breakage in mainline on n1sdp
Message-ID: <60916cb6-f460-4751-b910-f63c58700ad0@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5FRjekU5r0A0GCLv"
Content-Disposition: inline
X-Cookie: Booths for two or more.


--5FRjekU5r0A0GCLv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

At some point since the 30th of January we have started seeing issues=20
in mainline when running kvm-unit-tests on N1SDP in pKVM mode:

TESTNAME=3Dpmu-mem-access TIMEOUT=3D90s MACHINE=3D ACCEL=3D ./arm/run arm/p=
mu.flat -smp 1 -append 'pmu-mem-access'
<4>[  114.487201] ------------[ cut here ]------------
<4>[  114.487206] WARNING: arch/arm64/kvm/pkvm.c:393 at pkvm_pgtable_stage2=
_map+0x1ac/0x1c4, CPU#1: qemu-system-aar/1955
<4>[  114.502672] Modules linked in: stm_p_basic coresight_tpiu coresight_s=
tm stm_core arm_spe_pmu coresight_funnel coresight_tmc coresight_replicator=
 coresight arm_cmn sha256 cfg80211 rfkill fuse dm_mod ipv6
<4>[  114.520924] CPU: 1 UID: 0 PID: 1955 Comm: qemu-system-aar Not tainted=
 6.19.0 #1 PREEMPT=20
<4>[  114.529261] pstate: 40400005 (nZcv daif +PAN -UAO -TCO -DIT -SSBS BTY=
PE=3D--)
<4>[  114.536469] pc : pkvm_pgtable_stage2_map+0x1ac/0x1c4
<4>[  114.541681] lr : pkvm_pgtable_stage2_map+0x58/0x1c4
<4>[  114.546805] sp : ffff80008673b900
<4>[  114.550366] x29: ffff80008673b900 x28: 0000000000200000 x27: 00000000=
00200000
<4>[  114.557748] x26: 0000000000000000 x25: 00000000fffffff4 x24: 00000000=
0000000f
<4>[  114.565130] x23: ffff008047b65198 x22: 00000000080cbc00 x21: 00000000=
00040000
<4>[  114.572512] x20: ffff008046f65680 x19: 0000000000000200 x18: 00000000=
00000001
<4>[  114.579893] x17: 0000000000000000 x16: 0000000000000000 x15: 00000000=
00000000
<4>[  114.587275] x14: 0000000000000002 x13: 0000000000000002 x12: 00000000=
0031bf68
<4>[  114.594656] x11: 0000000000000000 x10: 0000ffff8be01000 x9 : ffff8000=
800728b0
<4>[  114.602037] x8 : ffff80008673bab8 x7 : 0000000000000001 x6 : 00000000=
00000008
<4>[  114.609419] x5 : 0000000040200000 x4 : 000000000000000f x3 : 00000000=
00000200
<4>[  114.616800] x2 : 0000000000040000 x1 : fffffffffffffff4 x0 : 00000000=
00000000
<4>[  114.624182] Call trace:
<4>[  114.626875]  pkvm_pgtable_stage2_map+0x1ac/0x1c4 (P)
<4>[  114.632088]  kvm_handle_guest_abort+0xe7c/0x12ec
<4>[  114.636953]  handle_exit+0x60/0x184
<4>[  114.640689]  kvm_arch_vcpu_ioctl_run+0x35c/0x968
<4>[  114.645554]  kvm_vcpu_ioctl+0x254/0xa50
<4>[  114.649638]  __arm64_sys_ioctl+0xac/0x104
<4>[  114.653896]  invoke_syscall+0x48/0x110
<4>[  114.657894]  el0_svc_common.constprop.0+0x40/0xe0
<4>[  114.662846]  do_el0_svc+0x1c/0x28
<4>[  114.666409]  el0_svc+0x34/0x10c
<4>[  114.669798]  el0t_64_sync_handler+0xa0/0xe4
<4>[  114.674228]  el0t_64_sync+0x198/0x19c
<4>[  114.678137] ---[ end trace 0000000000000000 ]---

The same tests running on N1SDP in VHE mode seem happy, and I've not
seen any other platforms showing issues.  Unfortunately due to various
infrastructure issues I don't have more detail on when this started
happening or anything, I'll update if I get more.

Thanks
Mark

--5FRjekU5r0A0GCLv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmYsUsACgkQJNaLcl1U
h9AfFgf9FSIZD6w3va6f48EUw0OHwlWyQ8KdSDbnx0BsjfCkDLY9YuIXsT3hJ+vN
YcUMPuLALkY9ZcCS7muEzOgRLb9K6WEowjllVosOLMRWjab/WgOjaGDrI8oUYqPP
RNhoqwJ0Set3ZkRC4mHfVwPpT8XuzAOI2zEYtSBDbpnnUhj1cYtzjGg0PuYcfrR7
OMteZZR1cceOY23kRsP2z2ZkWc2rrojtilCBil6YkFYTGVA5tAAyTcyBICzLoLQo
3bMjZ865WcHgSk2laachCUBDTkTZxzKqdVYkKN/euWTGB02ePMRPNpPISHY6xAnN
pO1CdNuyd1IFiRSJKo2Sb/G3WnvFTQ==
=IH/Z
-----END PGP SIGNATURE-----

--5FRjekU5r0A0GCLv--

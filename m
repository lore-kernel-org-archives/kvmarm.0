Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3BA29A1;
	Thu, 16 Jan 2025 01:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736990206; cv=none; b=LqIGEcivDB2NiAvO1rDTDdaVdEQzVgFhK3ci/LWJx9oYJzmwpr0NgXrVMxT1G3HZewiIexeXZYFx3/88MkLAHLZaPVjIPCxBJT00jf3Vl5ChG4Z5+Cfmr+thCkZk2AElVUs7qb9D/3rr6gGBQYGChlMBBCPUk9NVQNO3fmRI9QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736990206; c=relaxed/simple;
	bh=as21cXjdA/2pfwyzVElv8Bk/Dy84kxEaP5730sCmIgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qBoGGgWVa3VauEbLEbXTDgvOjA1Aj2LicDh93EnOLlQWkni2yxdFXAI+MKzXcFPm3jqvpxjWoObpx5ctMeRM3tkl2XNd917H9hTLUk/690proO9tN/40fj6btQUp+U/zV00zOxRz25YXX+zPQU8k/10Wt1Bzz4CAJfkq5i8z4E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oOUgRctp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oOUgRctp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92389C4CED1;
	Thu, 16 Jan 2025 01:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736990205;
	bh=as21cXjdA/2pfwyzVElv8Bk/Dy84kxEaP5730sCmIgs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oOUgRctpjH5DSRqIsIBbrjSrPSgTtlJq9KhHSNskOcTBCnpLfMhNhFTg8ecLTfIAP
	 Vzrgk0shWd76e1z5yFbDWLMLnJ2rBINs9Or2lDZJh7OKZYrGQDVsaW6AkYsoaMvU9V
	 ljgt0hJNRI5PoZY+KJBh0Pe5TyDTPXjcAsGEnhCWbss6D9oU7ovMFrV6QPaH7TFGMf
	 tAg50+q4E9tmLteOhhA7A9ck5nw1FlANaATWan1FlnaRqdPNCFrWdrY0e7Yyjj2Y7d
	 yG8MvCZP3F5Xw7E3qhjzEguGGn3XsmMt3bsAw8o1d4n7GUkDrbGYtpon5Xzd1nSDi3
	 qg7lQB/5+JVCw==
Date: Thu, 16 Jan 2025 01:16:40 +0000
From: Mark Brown <broonie@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com,
	will@kernel.org, Aishwarya.TCV@arm.com
Subject: Re: [PATCH] KVM: arm64: Fix the upper limit of the walker range
Message-ID: <14cce00c-29bd-4feb-b7d0-7aae6e948d1e@sirena.org.uk>
References: <20250114145050.563658-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oYMiFEg3WcLKkCBt"
Content-Disposition: inline
In-Reply-To: <20250114145050.563658-2-sebastianene@google.com>
X-Cookie: Real Users never use the Help key.


--oYMiFEg3WcLKkCBt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 14, 2025 at 02:50:51PM +0000, Sebastian Ene wrote:

> Prevent the walker from running into weeds when walking an
> entire address range.

The KVM page_fault_test selftest started failing in next-20250115 on
at least n1sdp and TX2 in VHE mode and a bisect seems to point to this
change.  The bisect only just finished, I've done no further
investigation.

When the test fails it generates backtraces like that below:

10090 07:18:48.591814  # selftests: kvm: page_fault_test
10092 07:18:48.612833  <4>[  142.366626] ------------[ cut here ]------------
10093 07:18:48.629034  <4>[  142.376417] WARNING: CPU: 67 PID: 2985 at arch/arm64/kvm/hyp/pgta# Random seed: 0x6b8b4567
10094 07:18:48.630599  ble.c:1569 kvm_pgtable_stage2_destroy+0xc4/0xd0
10095 07:18:48.639827  <4>[  142.376417] WARNING: CPU: 67 PID: 2985 at arch/arm64/kvm/hyp/pgtable.c:1569 kvm_pgtable_stage2_destroy+0xc4/0/d0
10096 07:18:48.661552  <4>[  142.399733] Modules linked in: cfg80211 rfkill fuse drm backlight dm_mod ip_tables x_tables ipv6 ipmi_devintf mlx5_core ipmi_msghandler thunderx2_pmu
10098 07:18:48.683362  <4>[  142.427185] CPU: 67 UID: 0 PID: 2985 Comm: page_fault_test Tainted: G        W          6.13.0-rc7-next-20250115 #1
10100 07:18:48.694497  <4>[  142.448679] Tainted: [W]=WARN
10102 07:18:48.704998  <4>[  142.455147] Hardware name: HPE Apollo 70             /C01_APACHE_MB         , BIOS L50_5.13_1.0.6 07/10/2018
10104 07:18:48.729915  <4>[  142.475415] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
10106 07:18:48.741211  <4>[  142.489920] pc : kvm_pgtable_stage2_destroy+0xc4/0/d0
10108 07:18:48.752027  <4>[  142.500581] lr : kvm_pgtable_stage2_destroy+0x54/0/d0
10110 07:18:48.752565  <4>[  142.511242] sp : ffff8000b11fbc20
10112 07:18:48.764562  <4>[  142.518408] x29: ffff8000b11fbc20 x28: ffff000821983480 x27: 0000000000000000
10114 07:18:48.782841  <4>[  142.533266] x26: 0000000000000000 x25: 0000000000000000 x24: ffff00081b7c4020
10116 07:18:48.797302  <4>[  142.548124] x23: ffff8000b0425940 x22: 0000000000000000 x21: ffff00081b717ac0
10118 07:18:48.808410  <4>[  142.562981] x20: ffff8000b0425000 x19: ffff00081b717ac0 x18: 00000000ffffffff
10120 07:18:48.830055  <4>[  142.577838] x17: 0000000000000000 x16: 0000000000000000 x15: 3839322f6d766b2f
10122 07:18:48.840894  <4>[  142.592694] x14: ffff800082d8f0e0 x13: 3d524f4e494d0030 x12: 0000000000000000
10124 07:18:48.852003  <4>[  142.607550] x11: 0000000000000000 x10: 0000000000000001 x9 : 0000000000000001
10126 07:18:48.863071  <4>[  142.622407] x8 : 000000000000003f x7 : 000000000000007c x6 : 0000000000000001
10128 07:18:48.888794  <4>[  142.637264] x5 : 000000000000002c x4 : 0000100000000000 x3 : 0000000000000000
10130 07:18:48.902333  <4>[  142.652121] x2 : 0000000000000000 x1 : ffff000821983480 x0 : 00000000ffffffde
10132 07:18:48.916662  <4>[  142.666978] Call trace:
10134 07:18:48.927909  <4>[  142.672397]  kvm_pgtable_stage2_destroy+0xc4/0/d0 (P)
10136 07:18:48.938802  <4>[  142.683059]  kvm_free_stage2_pgd+0x5c/0xa4
10138 07:18:48.939382  <4>[  142.691801]  kvm_uninit_stage2_mmu+0x1c/0x34
10140 07:18:48.949888  <4>[  142.700891]  kvm_arch_flush_shadow_all+0x6c/0x84
10142 07:18:48.960867  <4>[  142.710680]  kvm_mmu_notifier_release+0x30/0x84
10144 07:18:48.971358  <4>[  142.720295]  mmu_notifier_unregister+0x5c/0x11c
10146 07:18:48.982128  <4>[  142.729911]  kvm_destroy_vm+0x13c/0x288
10148 07:18:48.982657  <4>[  142.738128]  kvm_vm_release+0x80/0xb0
10150 07:18:48.993228  <4>[  142.745994]  __fput+0xcc/0x2dc
10152 07:18:49.004397  <4>[  142.759982]  __arm64_sys_close+0x38/0x7c
10154 07:18:49.015114  <4>[  142.768373]  invoke_syscall+0x48/0x110
10156 07:18:49.025588  <4>[  142.776415]  el0_svc_common.constprop.0+0x40/0xe0
10158 07:18:49.027236  <4>[  142.786380]  do_el0_svc+0x1c/0x28
10160 07:18:49.036803  <4>[  142.793548]  el0_svc+0x30/0xd0
10162 07:18:49.047405  <4>[  142.800193]  el0t_64_sync_handler+0x10c/0x138
10164 07:18:49.058357  <4>[  142.809458]  el0t_64_sync+0x198/0x19c
10168 07:18:49.058893  <4>[  142.817325] ---[ end trace 0000000000000000 ]---

FVP seems OK, I can get full logs if needed.

bisect log:

git bisect start
# status: waiting for both good and bad commits
# bad: [e7bb221a638962d487231ac45a6699fb9bb8f9fa] Add linux-next specific files for 20250115
git bisect bad e7bb221a638962d487231ac45a6699fb9bb8f9fa
# status: waiting for good commit(s), bad commit known
# good: [7b90deb712bbacdf8aa1fc01bf155cab5c21d98a] Merge branch 'for-linux-next-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
git bisect good 7b90deb712bbacdf8aa1fc01bf155cab5c21d98a
# good: [5f78eb69f34a94a82ff763b0eae49b6227b0b298] Merge branch 'main' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
git bisect good 5f78eb69f34a94a82ff763b0eae49b6227b0b298
# good: [825975f20474f1a6d68c0338d832ac5adaeed8b7] Merge branch 'master' of git://git.code.sf.net/p/tomoyo/tomoyo.git
git bisect good 825975f20474f1a6d68c0338d832ac5adaeed8b7
# bad: [f8ea9541257c3f2de0e6024aa4f7f9b2ba374e9e] Merge branch 'usb-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
git bisect bad f8ea9541257c3f2de0e6024aa4f7f9b2ba374e9e
# good: [9b8df195bf092153caa81b40160a0f4a766471e2] Merge branch 'non-rcu/next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
git bisect good 9b8df195bf092153caa81b40160a0f4a766471e2
# bad: [24808e495053d0fe90b27eef1f0d3cc8a3db5445] Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext.git
git bisect bad 24808e495053d0fe90b27eef1f0d3cc8a3db5445
# bad: [a8293f931a58022b9e6ac7a45718bee25331cb87] Merge branch 'riscv_kvm_next' of https://github.com/kvm-riscv/linux.git
git bisect bad a8293f931a58022b9e6ac7a45718bee25331cb87
# good: [e880b16efb78f9c7449239a76814aeb015daf2a1] Merge branch kvm-arm64/pkvm-fixed-features-6.14 into kvmarm-master/next
git bisect good e880b16efb78f9c7449239a76814aeb015daf2a1
# good: [a1caf40a7a2c732cec1a33ec7e23d816e9103ac7] Merge branch kvm-arm64/coresight-6.14 into kvmarm-master/next
git bisect good a1caf40a7a2c732cec1a33ec7e23d816e9103ac7
# good: [a066bad89c6c79890bb8f45aef8662dcd0562a62] Merge tag 'kvm-selftests-treewide-6.14' of https://github.com/kvm-x86/linux into HEAD
git bisect good a066bad89c6c79890bb8f45aef8662dcd0562a62
# good: [af79caa83f6aa41e9092292a2ba7f701e57353ec] RISC-V: KVM: Add new exit statstics for redirected traps
git bisect good af79caa83f6aa41e9092292a2ba7f701e57353ec
# bad: [f922030f1c8541f76a103fee39ce38f15ba00c93] Merge branch kvm-arm64/misc-6.14 into kvmarm-master/next
git bisect bad f922030f1c8541f76a103fee39ce38f15ba00c93
# good: [36f998de853cfad60508dfdfb41c9c40a2245f19] KVM: arm64: nv: Apply RESx settings to sysreg reset values
git bisect good 36f998de853cfad60508dfdfb41c9c40a2245f19
# good: [0b7ff31fba40a61cfb341c8eea1540aaa6f256b9] Merge branch kvm-arm64/nv-resx-fixes-6.14 into kvmarm-master/next
git bisect good 0b7ff31fba40a61cfb341c8eea1540aaa6f256b9
# bad: [bc9e4ec6e98838314c07575a5fbc06755d21913c] KVM: arm64: Fix the upper limit of the walker range
git bisect bad bc9e4ec6e98838314c07575a5fbc06755d21913c
# first bad commit: [bc9e4ec6e98838314c07575a5fbc06755d21913c] KVM: arm64: Fix the upper limit of the walker range

--oYMiFEg3WcLKkCBt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmeIXfcACgkQJNaLcl1U
h9DeMAf/bSHl+b/VtEL3vuX6fHlDjkc/2U4TkQjdWrYOMi5PTCl/2AFu7rI3gs7X
8MkcOHLec+ufL40UXO1g0KBOOIcSXthmqBdRsKcUEmxYYBaoyez7zwL8NJdDRZ52
Bar8rWfwE8eJSh/GrXUILKaRt3M6sFRBeyApjsKxJU0lBPJcAcSVnigaugRumlwj
l9L9JDPA55AyGXAl36r5YUDmcaHJvMHkH6bcC+wPB8d5iR6kBD8jP09Dki1S+ZwM
be2dor7i2uzjC2AmseLxulKHl3sHKXEuQn/fqqFjQOVtzGBvwi03WMijM83KQL/M
xm0VLiOg6Re5PRbp5L8M9J9C+NcAsw==
=kYdH
-----END PGP SIGNATURE-----

--oYMiFEg3WcLKkCBt--

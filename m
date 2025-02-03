Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC0C1D47AD;
	Mon,  3 Feb 2025 19:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738612251; cv=none; b=aNlNoOOp2Nm48QV7Ng6qAH/pDc7u/2pjZr+3dESH+ALzba0DGsfbRF4uqK1Qs2pHFUhFwt96SrMKcrPvI50dnvQywbsxu6mumR6DVuCBD9Pu8aR4UEKgOSzwTrMg1miPkLbHF5+WetK0sIzUCmqBkayztTsCgPWX3JzjTCIVmyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738612251; c=relaxed/simple;
	bh=XGTTmaTbuMSIUnCt/V5Tc/8kvFz5nJOKfbKLcWa9s3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MAIAIGY62r5jijzJ1M0Ux/nV4V+fDsVgt/+Koa+kz2qDj00+RAhjDZHxcNuSRehmzCsN29Eyid0sYoykcK3eGxitQt2y2ZX+BrjzIzWNqxu/OqVw5DQURbhs8T+bRuIJAUo/7IkeNLFzMO/8shM8XASgSedcs1bTmaFojPhUtAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bAXZqrDi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bAXZqrDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FB8C4CED2;
	Mon,  3 Feb 2025 19:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738612250;
	bh=XGTTmaTbuMSIUnCt/V5Tc/8kvFz5nJOKfbKLcWa9s3Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bAXZqrDiQryC0tZT1Jvjwk0Hug2a/rdR9Nw+kTstb0+BCXLrUOuSQbo1lVNQ2vmSi
	 K1tImNuPQdfBlAMkQL6jOnwINQ3bYRrRJT3pqTwxAwuS8kfwiNUXlcwlhNgNOLgj11
	 +MWeuhHdpwvVW+kzNtlI3ZE1qn26hGWUmJzyiNyyUVcp63QMwW3b+S0jmYc/5g4Ay2
	 tte+dvrLu3DOqnqk0g8fgdWQZpfjbS2KE7wNbHASFpK8NmqSwoCxbcwqIrK4IdMg+D
	 n8yL1s/oeiWuWMr66w06GKok5qw1gS8x8m4DJgyReEPoMOMWeR2ydjXhSHWq0NwYTs
	 D1QGf0cmG5mpg==
Date: Mon, 3 Feb 2025 19:50:44 +0000
From: Mark Brown <broonie@kernel.org>
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 09/18] KVM: arm64: Introduce __pkvm_vcpu_{load,put}()
Message-ID: <5ca7588c-7bf2-4352-8661-e4a56a9cd9aa@sirena.org.uk>
References: <20241218194059.3670226-1-qperret@google.com>
 <20241218194059.3670226-10-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ANfi4BZEZ3mG3n3g"
Content-Disposition: inline
In-Reply-To: <20241218194059.3670226-10-qperret@google.com>
X-Cookie: Happiness is a positive cash flow.


--ANfi4BZEZ3mG3n3g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2024 at 07:40:50PM +0000, Quentin Perret wrote:
> From: Marc Zyngier <maz@kernel.org>
>=20
> Rather than look-up the hyp vCPU on every run hypercall at EL2,
> introduce a per-CPU 'loaded_hyp_vcpu' tracking variable which is updated
> by a pair of load/put hypercalls called directly from
> kvm_arch_vcpu_{load,put}() when pKVM is enabled.

Current mainline crashes when running the arch_timer_edge_cases selftest
in pKVM mode on a LibreTech Le Potato board, with a bisection pointing
at this change.  The system dies like this:

# selftests: kvm: arch_timer_edge_cases
[  130.599140] kvm [4518]: nVHE hyp panic at: [<ffff800081102b58>] __kvm_nv=
he___vgic_v3_restore_vmcr_aprs+0x8/0x84!
[  130.603685] kvm [4518]: Cannot dump pKVM nVHE stacktrace: !CONFIG_PROTEC=
TED_NVHE_STACKTRACE
[  130.611962] kvm [4518]: Hyp Offset: 0xfffeca95ed000000
[  130.617053] Kernel panic - not syncing: HYP panic:

Full log:

   https://lava.sirena.org.uk/scheduler/job/1092083

Bisection log:

git bisect start
# status: waiting for both good and bad commits
# bad: [2014c95afecee3e76ca4a56956a936e23283f05b] Linux 6.14-rc1
git bisect bad 2014c95afecee3e76ca4a56956a936e23283f05b
# status: waiting for good commit(s), bad commit known
# good: [ffd294d346d185b70e28b1a28abe367bbfe53c04] Linux 6.13
git bisect good ffd294d346d185b70e28b1a28abe367bbfe53c04
# good: [6250ebe666e425e173df5e11e8a612d57921f48d] i2c: Fix core-managed pe=
r-client debugfs handling
git bisect good 6250ebe666e425e173df5e11e8a612d57921f48d
# good: [647d69605c70368d54fc012fce8a43e8e5955b04] Merge tag 'pci-v6.14-cha=
nges' of git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci
git bisect good 647d69605c70368d54fc012fce8a43e8e5955b04
# good: [13845bdc869f136f92ad3d40ea09b867bb4ce467] Merge tag 'char-misc-6.1=
4-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc
git bisect good 13845bdc869f136f92ad3d40ea09b867bb4ce467
# bad: [9f10e7fb6a06bce4f81de5fd0f2f0390f99e89e4] Merge tag 'phy-for-6.14' =
of git://git.kernel.org/pub/scm/linux/kernel/git/phy/linux-phy
git bisect bad 9f10e7fb6a06bce4f81de5fd0f2f0390f99e89e4
# bad: [58f504efcda54a9079a38203acc088c3354aaa60] Merge tag 'tty-6.14-rc1' =
of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
git bisect bad 58f504efcda54a9079a38203acc088c3354aaa60
# good: [a37eea94f775132866ecdd466fd88027d7125515] Merge tag 'sparc-for-6.1=
4-tag1' of git://git.kernel.org/pub/scm/linux/kernel/git/alarsson/linux-spa=
rc
git bisect good a37eea94f775132866ecdd466fd88027d7125515
# bad: [5e68d2eeac70978a06406c5b156815ceb00437f9] Merge branch kvm-arm64/pk=
vm-memshare-declutter into kvmarm-master/next
git bisect bad 5e68d2eeac70978a06406c5b156815ceb00437f9
# bad: [d0670128d42fa170bf8ba878cd23504c5c5cccc7] Merge branch kvm-arm64/pk=
vm-np-guest into kvmarm-master/next
git bisect bad d0670128d42fa170bf8ba878cd23504c5c5cccc7
# good: [c4a6ed85455979ef3fbadc2f1bdf18734b0ecea6] KVM: arm64: Promote gues=
t ownership for DBGxVR/DBGxCR reads
git bisect good c4a6ed85455979ef3fbadc2f1bdf18734b0ecea6
# bad: [d0bd3e6570aee42766e7bd884734ae078667ea1e] KVM: arm64: Introduce __p=
kvm_host_share_guest()
git bisect bad d0bd3e6570aee42766e7bd884734ae078667ea1e
# good: [5398ddc5c90bd418b90d859e9267aa39399021af] KVM: arm64: Pass walk fl=
ags to kvm_pgtable_stage2_mkyoung
git bisect good 5398ddc5c90bd418b90d859e9267aa39399021af
# good: [c77e5181fed54b25d489eb7d2ccb5c1c72a1063c] KVM: arm64: Make kvm_pgt=
able_stage2_init() a static inline function
git bisect good c77e5181fed54b25d489eb7d2ccb5c1c72a1063c
# bad: [f7d03fcbf1f482069e9afac55b17de3bd323b8f6] KVM: arm64: Introduce __p=
kvm_vcpu_{load,put}()
git bisect bad f7d03fcbf1f482069e9afac55b17de3bd323b8f6
# good: [99996d575ee69d4327bad98a0148729b73dde23a] KVM: arm64: Add {get,put=
}_pkvm_hyp_vm() helpers
git bisect good 99996d575ee69d4327bad98a0148729b73dde23a
# first bad commit: [f7d03fcbf1f482069e9afac55b17de3bd323b8f6] KVM: arm64: =
Introduce __pkvm_vcpu_{load,put}()

--ANfi4BZEZ3mG3n3g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmehHhMACgkQJNaLcl1U
h9DQ7Af+P8sebWSERdjUjYV29cH9b32wtbxJMRD1Dyu0ctLbCzNOmkbja6PAw6gg
WWur9Ds0FBcbMpWutMe3tQIF6r9ZZYobChRBsdqLRjz+hIwngMxicmhhM2vvXc7t
D4Z8ayasEqR7OjLfEHc+lnVsgYtaswDKQq0ABGSWJhEsBSnP45Z1qqslLxiqItUq
L2+OjIgJ0R95hsceAWbBaTmOVfzFhVHkABPqDIVLE/lWTWN+I24DABPW8KdnpGE3
L1D6Cdw2jz2Sbi1/wzs12TorVXKRUmfTPtQtcInQNSdW1RIXeFgtlEY8f2c9fexp
1aJFPcx2HxUBLJGMrnO6kx1IwN0xdQ==
=8hjS
-----END PGP SIGNATURE-----

--ANfi4BZEZ3mG3n3g--

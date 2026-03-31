Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC423389471
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 19:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774984546; cv=none; b=bNCCH4kvP+936azMJtF4KAEY64Z44dgorsVI8O/jnN3uK8xvD5v7x1ZF8KExxr5wlHfRHTeHbM+Z45T5q4y82u0Sl7DQRqKHRehM45Ma4LWgJD+5vnpR/c8LP257HixNUwe0SeJ755EnNLKY9AwBSg5pXnTXPV4xZOu6m2U+YGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774984546; c=relaxed/simple;
	bh=Kv09EzxBaqHzp8erJI0JQ06M92FTkHRl6CCf/dPyyoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z4s3OniPccQtHoJJ3x+u8tU7iXikQUC4QA+eBunPICB/29G+dH/m/rVlmanysBOqDwchCPUmpldwxLiADjjXd+RY3Q11UBoc8TJ3p9HFIEfZa3ggjLWyyIoZWdIio1ifvK6Ub3JvvUqVaXpvdNfDHoq+DeR1aWOtZixEBSTjw/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ErDWozDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ErDWozDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E68C19423;
	Tue, 31 Mar 2026 19:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774984546;
	bh=Kv09EzxBaqHzp8erJI0JQ06M92FTkHRl6CCf/dPyyoU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ErDWozDbTtLYdYLyIfqpjA03XnnUKYJvhwfEa2YVKItkyYeCaXPhrPSA2BNJDXx9R
	 Vgx6fGLuUogEkCTRPJpCn6s9pCoXrY5pxjgEX5au+25HM/kMlN2OgiX6mwdMYjGnSL
	 9sUvyWm+LcZUI6AW1sEEiyBTW9AigZA3PKCu7F5al/ulWMU6AKQVHpLr/16QEKMQ8O
	 fU95xD1PZ4g6phTtCruNuve4+hjPAlifoEFzK5YNhHyIaETmePm9gpxmKMaEIZEPBC
	 qsMqrtRudH+EjyAikenFcWpr16S4Z6jsjaZnZLtfjO/GLH70ynCq55D6V3ZEOjIvLL
	 RWvjJ4WXDIFjg==
Date: Tue, 31 Mar 2026 20:15:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v5 11/38] KVM: arm64: Split teardown hypercall into two
 phases
Message-ID: <0cf948e9-be64-4c75-97f8-a560442eb5d2@sirena.org.uk>
References: <20260330144841.26181-1-will@kernel.org>
 <20260330144841.26181-12-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8GoRgmplqT4y55Qw"
Content-Disposition: inline
In-Reply-To: <20260330144841.26181-12-will@kernel.org>
X-Cookie: Check here if tax deductible.


--8GoRgmplqT4y55Qw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 30, 2026 at 03:48:12PM +0100, Will Deacon wrote:
> In preparation for reclaiming protected guest VM pages from the host
> during teardown, split the current 'pkvm_teardown_vm' hypercall into
> separate 'start' and 'finalise' calls.
>=20
> The 'pkvm_start_teardown_vm' hypercall puts the VM into a new 'is_dying'
> state, which is a point of no return past which no vCPU of the pVM is
> allowed to run any more.  Once in this new state,
> 'pkvm_finalize_teardown_vm' can be used to reclaim meta-data and
> page-table pages from the VM. A subsequent patch will add support for
> reclaiming the individual guest memory pages.

We've started seeing WARN_ON()s generated in -next on N1DSP when running
kvm-unit-tests under pKVM:

1821 23:03:59.721620  <4>[   17.558270] ------------[ cut here ]------------
1822 23:03:59.725053  <4>[   17.558274] WARNING: arch/arm64/kvm/pkvm.c:373 =
at __pkvm_pgtable_stage2_unshare+0xbc/0xfc, CPU#3: qemu-system-aar/390

=2E..

1839 23:03:59.850178  <4>[   17.697247] Call trace:
1840 23:03:59.853079  <4>[   17.699940]  __pkvm_pgtable_stage2_unshare+0xbc=
/0xfc (P)
1841 23:03:59.865729  <4>[   17.705500]  pkvm_pgtable_stage2_destroy_range+=
0x90/0x214
1842 23:03:59.866226  <4>[   17.711145]  kvm_stage2_destroy+0x74/0xd0
1843 23:03:59.869119  <4>[   17.715403]  kvm_free_stage2_pgd+0x5c/0xc0
1844 23:03:59.881700  <4>[   17.719746]  kvm_uninit_stage2_mmu+0x1c/0x34
1845 23:03:59.882197  <4>[   17.724262]  kvm_arch_flush_shadow_all+0x6c/0x84
1846 23:03:59.885123  <4>[   17.729127]  kvm_mmu_notifier_release+0x30/0x84
1847 23:03:59.897681  <4>[   17.733905]  __mmu_notifier_release+0x74/0x264
1848 23:03:59.898181  <4>[   17.738596]  exit_mmap+0x260/0x268
1849 23:03:59.898513  <4>[   17.742247]  __mmput+0x38/0x120
1850 23:03:59.898817  <4>[   17.745637]  mmput+0x50/0x5c
1851 23:03:59.901098  <4>[   17.748766]  do_exit+0x220/0x8f4

A bisect points at this patch:

git bisect start
# status: waiting for both good and bad commits
# bad: [cf7c3c02fdd0dfccf4d6611714273dcb538af2cb] Add linux-next specific f=
iles for 20260330
git bisect bad cf7c3c02fdd0dfccf4d6611714273dcb538af2cb
# status: waiting for good commit(s), bad commit known
# good: [a010730e610019b6d010ec43ce737cb59a37809d] Merge branch 'for-linux-=
next-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
git bisect good a010730e610019b6d010ec43ce737cb59a37809d
# good: [5c552968883f4b10da9a1baeefd38a28afe993cd] Merge branch 'for-next' =
of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
git bisect good 5c552968883f4b10da9a1baeefd38a28afe993cd
# good: [de8f4e3b3d9aec5d4fdd5113ff09a6904b8a9f91] Merge branch 'for-next' =
of https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git
git bisect good de8f4e3b3d9aec5d4fdd5113ff09a6904b8a9f91
# bad: [7b3de9ac54f51bf09357802f02f0672de8bd49c0] Merge branch 'for-next' o=
f https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x8=
6.git
git bisect bad 7b3de9ac54f51bf09357802f02f0672de8bd49c0
# good: [6778bd8a07f6f11414325ba6fe6d263f6b6994c9] Merge branch 'for-next' =
of https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git
git bisect good 6778bd8a07f6f11414325ba6fe6d263f6b6994c9
# good: [1cb1ca5899ab60d85e21ccf38da645a875fcf242] Merge branch 'edac-for-n=
ext' of https://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git
git bisect good 1cb1ca5899ab60d85e21ccf38da645a875fcf242
# bad: [4476dfd35bb0428c406fa68ce0d2125960535150] Merge branch 'next' of ht=
tps://github.com/kvm-x86/linux.git
git bisect bad 4476dfd35bb0428c406fa68ce0d2125960535150
# good: [8f3483cd04d6ee6579594417d4a19394de63463a] Merge branch 'selftests'
git bisect good 8f3483cd04d6ee6579594417d4a19394de63463a
# bad: [5ad2ff071b5980f072a85c8114649218971c586e] Merge branch kvm-arm64/pk=
vm-protected-guest into kvmarm-master/next
git bisect bad 5ad2ff071b5980f072a85c8114649218971c586e
# bad: [9ff714a09222128da16900fc7c15dea65692fc26] KVM: arm64: Inject SIGSEG=
V on illegal accesses
git bisect bad 9ff714a09222128da16900fc7c15dea65692fc26
# good: [f0877a1455cc6a93be14e4da741ce26ac0d6ca6d] KVM: arm64: Prevent unsu=
pported memslot operations on protected VMs
git bisect good f0877a1455cc6a93be14e4da741ce26ac0d6ca6d
# bad: [ea03466e806fea942841a41cfaab8db8c851aa71] KVM: arm64: Handle aborts=
 from protected VMs
git bisect bad ea03466e806fea942841a41cfaab8db8c851aa71
# bad: [6c58f914eb9c4ce5225d03183ae1290d72b5f639] KVM: arm64: Split teardow=
n hypercall into two phases
git bisect bad 6c58f914eb9c4ce5225d03183ae1290d72b5f639
# good: [73c55be08932a348f8b0a44f561c33eaa2cf1ad2] KVM: arm64: Ignore -EAGA=
IN when mapping in pages for the pKVM host
git bisect good 73c55be08932a348f8b0a44f561c33eaa2cf1ad2
# first bad commit: [6c58f914eb9c4ce5225d03183ae1290d72b5f639] KVM: arm64: =
Split teardown hypercall into two phases

--8GoRgmplqT4y55Qw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnMHVwACgkQJNaLcl1U
h9BYagf/a2JwqkW6D0z00TeXyfyuBgXNVVd3QybL72MgeRflfCH5HiZXB0urOMa6
HWnaz2sI8ZpTL0EMiVjzP6Us+/IEjtl8TOr8yppaAXMN2jvJHKmw3/SecMHPc5Oo
uU4qFWrA9wxJ6fGxjNz3w8dZupXPdCE/pwa0sc+YbCiSmd2XcTqOIYO8lCjc2rK3
X83YZECX3sezeDL1g20VczgRPqAqH01DwetC+VqT3QLsUXd/rOqz/VvtG47QCNhB
fgakUREqy3yHm94nj3UPx9jfvyzmT03pONuDrzMpwMnznp5N3TSYPF9dgPeudWp/
ghqCSGj4VwIvf4ghFZh2SDJ/GA8pjw==
=1/1R
-----END PGP SIGNATURE-----

--8GoRgmplqT4y55Qw--

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48282F21
	for <kvmarm@lists.linux.dev>; Tue, 11 Apr 2023 21:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D461C433D2;
	Tue, 11 Apr 2023 21:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681247708;
	bh=nMjKRU+GtE/n8hGzcVdnShwnmtftP0ZwpGceLWxMhDw=;
	h=Date:From:To:Cc:Subject:From;
	b=qZ6xgi7cnaTI9U4zBEEfKG44DOky21ZbilqYifVOgc2+ZeiADveli1Wf79+HjyFyN
	 B2YAsGKxWB2erz5HHnyMNwKrZVszpOCeW3SAXPKdS1DRP09owdD8P1+WogyL6TTyOi
	 U7nlBl0/NJYUWqUwER+IGrEl26v3MlQuD3EgcltVoGbgvgO6zeb7cA9AGTcrYwO8Nl
	 2Q0bCvh95AQcv39PkGvYHDyXSZ/iJoBnIoswE3CaofE+bytDdiTaN4LgpRmSbFqYt5
	 LcdbF0U2A5DMOcDXtm1ss5+mYdj69rfnlq45Zsxqf8KoaWCeGA+hmTkfZo3MM/QKYm
	 SF31RZZh4wcDQ==
Date: Tue, 11 Apr 2023 22:15:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com
Subject: pmu-chain-promotion kvm-unit-test failures in mainline
Message-ID: <cdf922b3-1ac3-438d-8817-6c4d693b1fc3@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IPt2Msy58KbOMwEc"
Content-Disposition: inline
X-Cookie: I demand IMPUNITY!


--IPt2Msy58KbOMwEc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Arm's internal test infrastructure has started seeing failures for the
pmu-chain-promption test in kvm-unit-tests on TX2 when running mainline
and kvm-unit-tests commit 2480430a36102f8ea276b3bfb1d64d5dacc23b8f
("configure: Show the option in case it is not known").  The log I'm
seeing from the test runner is:

TESTNAME=pmu-chain-promotion TIMEOUT=90s ACCEL= ./arm/run arm/pmu.flat -smp 1 -append 'pmu-chain-promotion'
FAIL pmu-chain-promotion (7 tests, 2 unexpected failures)

Unfortunately I don't have direct access to a TX2 so can't readily
alter the test run other than replacing the kernel.  I believe the
specific failures were:

FAIL: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter enabled: CHAIN counter was incremented and overflow
FAIL: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter enabled: 32b->64b CHAIN counter was incremented and overflow

A bisect (log below) identified 7af9da8ce8f9a16221e ("thunderbolt: Add
quirk to disable CLx") as the breaking commit which doesn't seem
entirely credible unless there's some image size thing going on, the
issue manifests with v6.3-rc3 and not with v6.3-rc1.

git bisect start
# bad: [009795d283d1f9f043e5a4ff97d4140cde17e2d3] Add linux-next specific files for 20230411
git bisect bad 009795d283d1f9f043e5a4ff97d4140cde17e2d3
# bad: [0d3eb744aed40ffce820cded61d7eac515199165] Merge tag 'urgent-rcu.2023.04.07a' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu
git bisect bad 0d3eb744aed40ffce820cded61d7eac515199165
# good: [fe15c26ee26efa11741a7b632e9f23b01aca4cc6] Linux 6.3-rc1
git bisect good fe15c26ee26efa11741a7b632e9f23b01aca4cc6
# good: [d0072ca529674c36421023ffe90837a7de9387f3] mm: mmap: remove newline at the end of the trace
git bisect good d0072ca529674c36421023ffe90837a7de9387f3
# bad: [b527ac44eb1782cf179d4e08ceda7d2a9643aff5] Merge tag 'for-6.3/dm-fixes-2' of git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm
git bisect bad b527ac44eb1782cf179d4e08ceda7d2a9643aff5
# good: [d7b5c942f0752894a91a925c7249116333d4ab25] Merge tag 'for-v6.3-rc' of git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-power-supply
git bisect good d7b5c942f0752894a91a925c7249116333d4ab25
# good: [18940c888c85fd7527375343bd4fcc94a540c69c] Merge tag 'sched_urgent_for_v6.3_rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 18940c888c85fd7527375343bd4fcc94a540c69c
# bad: [69620d5c030553e81562f6f6f490c1fdd7f798fd] Merge tag 'drm-misc-fixes-2023-03-30' of git://anongit.freedesktop.org/drm/drm-misc into drm-fixes
git bisect bad 69620d5c030553e81562f6f6f490c1fdd7f798fd
# bad: [451b15ed138ec15bffbebb58a00ebdd884c3e659] usb: chipidea: core: fix possible concurrent when switch role
git bisect bad 451b15ed138ec15bffbebb58a00ebdd884c3e659
# good: [1272fd652a226ccb34e9f47371b6121948048438] usb: cdns3: Fix issue with using incorrect PCI device function
git bisect good 1272fd652a226ccb34e9f47371b6121948048438
# bad: [1716efdb07938bd6510e1127d02012799112c433] thunderbolt: Use const qualifier for `ring_interrupt_index`
git bisect bad 1716efdb07938bd6510e1127d02012799112c433
# bad: [cd0c1e582b055dea615001b8bd8eccaf6f69f7ce] thunderbolt: Add missing UNSET_INBOUND_SBTX for retimer access
git bisect bad cd0c1e582b055dea615001b8bd8eccaf6f69f7ce
# bad: [acec726473822bc6b585961f4ca2a11fa7f28341] thunderbolt: Fix memory leak in margining
git bisect bad acec726473822bc6b585961f4ca2a11fa7f28341
# bad: [7af9da8ce8f9a16221ecd8ba4280582f5bd452fc] thunderbolt: Add quirk to disable CLx
git bisect bad 7af9da8ce8f9a16221ecd8ba4280582f5bd452fc
# first bad commit: [7af9da8ce8f9a16221ecd8ba4280582f5bd452fc] thunderbolt: Add quirk to disable CLx

--IPt2Msy58KbOMwEc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmQ1zdUACgkQJNaLcl1U
h9BVaAf9Ec1OpG7xfM5ay9jfU2qeZQdIJ0dIJzcVej7CFrvGJ2wgt87ga5PNfyiT
3mzksn6udC7RctDIIBs4B3NBg7UIFm2D2tW/x3TEbdnsDdULR3BiJZBUJVJOfbcN
3U4oXuophlUvKi5LryaicpIptQpo+GSyi362E1O/Icmsd8oy58sqxeZxvZL5E8QV
xlxebHTng2UnuKKsWz8tuGSTIapudE7Enb+EGueAsxidoqzLrLk64Qpz8b3g/u3k
wu/6USMoWadNkDE3OcH4a/pqofvpj4VVl/F2ZaDmyqCgJk27ZTVqn+vWbg8NoYuN
MgyOaSy6NdAhqXh5eQK06+9zwA0Q4Q==
=PwQq
-----END PGP SIGNATURE-----

--IPt2Msy58KbOMwEc--

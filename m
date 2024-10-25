Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B88F1FC7D9;
	Fri, 25 Oct 2024 10:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729853683; cv=none; b=rRMvNIIWHe96H2MhP6AUsCS1iktUoCNAyPgoppzcVXzApJ0NPPKQTMLcleRc2466e/0crQqvNdTIK7Dm3EKj7emQ0c5lwCDGmU/b4bwxm1KDxIJcPROagE5YFShBK65t24lrwz1INUrROPlQOWWNPM5b5xIxfCuL9sHqh5XGNXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729853683; c=relaxed/simple;
	bh=NMrbIE7m12dPqV1Z3n/gS0Txjw3cXnFgI8+kZXLcLB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pr1o+vQpbOd648NrT/hQAxCP2cLBZuiCDOb1ggXofIZYlT4sMh4gwXhdyGoGbxx1w2OQEdq+G7a5cmI84k/w6B30Esqy6brCcH5zh8MBpcdRWqHPgxEKUlqAX5VXNtn0Pgh+vUXXicebzuD4Tmk88p8mTURDAjTFxXAH7v2nueA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R2whcWvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R2whcWvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220ACC4CECD;
	Fri, 25 Oct 2024 10:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729853682;
	bh=NMrbIE7m12dPqV1Z3n/gS0Txjw3cXnFgI8+kZXLcLB8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R2whcWvDR/PCSSP4DjUDcLxYQdy/95WyWAkhc5q3+TQ6tALzqIP6huUkRUJCA0RUi
	 6T/DCTxM9DKTKhzd6/QegR6t07huOMNYy0cTugylMk9jyowm4Aj6pAwzZnNI9lR9B2
	 +NT8XthWH++muZKV+CNzrbc5W7b30PlegnbYiFxW5JVl99hyLpSkcxd5S6XnAKJTzt
	 kch6zq9zjDVBH1PPbUYnhzendmzxaeAr/0IWU7JE8VO0/+s/9AzGCxehHLhRno7N7Q
	 a3l7QQoCCLSlheLjBrhJPxAG56oRGBoNF+ykK7U7QD2UtHmMVV7fe8Qssn52NpPRgn
	 ZCkR+vgbEv8UA==
Date: Fri, 25 Oct 2024 11:54:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>, stable@vger.kernel.org,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH] KVM: arm64: Don't eagerly teardown the vgic on init error
Message-ID: <eb6e7e29-b0a8-47b1-94c4-f01569aa55cb@sirena.org.uk>
References: <20241009183603.3221824-1-maz@kernel.org>
 <3f0918bf-0265-4714-9660-89b75da49859@sirena.org.uk>
 <86ldyd2x7t.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="f1SfmhQ4GPa7UgZL"
Content-Disposition: inline
In-Reply-To: <86ldyd2x7t.wl-maz@kernel.org>
X-Cookie: Often things ARE as bad as they seem!


--f1SfmhQ4GPa7UgZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 24, 2024 at 07:05:10PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > # ==== Test Assertion Failure ====
> > #   lib/kvm_util.c:724: false
> > #   pid=1947 tid=1947 errno=5 - Input/output error
> > #      1	0x0000000000404edb: __vm_mem_region_delete at kvm_util.c:724 (discriminator 5)
> > #      2	0x0000000000405d0b: kvm_vm_free at kvm_util.c:762 (discriminator 12)
> > #      3	0x0000000000402d5f: vm_gic_destroy at vgic_init.c:101
> > #      4	 (inlined by) test_vcpus_then_vgic at vgic_init.c:368
> > #      5	 (inlined by) run_tests at vgic_init.c:720
> > #      6	0x0000000000401a6f: main at vgic_init.c:748
> > #      7	0x0000ffffa7b37543: ?? ??:0
> > #      8	0x0000ffffa7b37617: ?? ??:0
> > #      9	0x0000000000401b6f: _start at ??:?
> > #   KVM killed/bugged the VM, check the kernel log for clues
> > not ok 10 selftests: kvm: vgic_init # exit=254

> > which does rather look like a test bug rather than a problem in the
> > change itself.

> Well, the test tries to do braindead things, and then the test
> infrastructure seems surprised that KVM tells it to bugger off...

> I can paper over it with this (see below), but frankly, someone who
> actually cares about this crap should take a look (and ownership).

I'm not even sure that's a terrible fix, looking at the changelog I get
the impression the test is deliberately looking to do problematic things
with the goal of making sure that the kernel handles them appropriately.
That's not interacting well with the KVM selftest framework's general
assert early assert often approach but it's a reasonable thing to want
to test so relaxing the asserts like this is one way of squaring the
circile.

--f1SfmhQ4GPa7UgZL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcbeO0ACgkQJNaLcl1U
h9CYWggAhZeL7arTcbfSYjm9iBbxz0wTjV52BOyL0NAmhjGaHipkl/iNLk65tjuu
Ru0565ygr7xFQCbadPpkVsbn4KKaeHo+3cqtlPR45eShijH8TY81xIw8lp1uNYVh
4uy9zhIzL0YLuiXrpI+wQ/FW4C1bnXCh3CsBhm2SvPzZpj51nzwnZgEfROJ2BCPc
i75RPztWPmmce2XDSWLP/j967nI87+fhUdBQbjlRN82B0OHtNrAmXer5b6Qh17U0
YPKMiyGnUayJ5U/vTHngRy4cJGnaYmb1w/Vvst5SqBjmhwf9pPbZgp4oZf5mL9MT
8qxWB/NhANiYbf6pilkXli/hSwDhBQ==
=Bczd
-----END PGP SIGNATURE-----

--f1SfmhQ4GPa7UgZL--

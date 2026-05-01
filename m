Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD4654768;
	Fri,  1 May 2026 02:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777601477; cv=none; b=jYmT8H9SKmAbvXdZbivEmwd2R60j3D+8iQATJgsyCaZCrfyCcDp5N3AzgN3SsIPaswpdR+OjdpA5AIf4Ju7z0jHok8uTXvCnRiVMZoMkdx6lqE05DXaaJAbt+ZY33PHClf5TKOYNI86dLwOkw59UCyF5J4uwcTiBv2BHNICOEuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777601477; c=relaxed/simple;
	bh=9QR0cnUgXF6rP+G/fgL1ZOPWMm8v63S58EfEC1IYVzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OHEWWJGvM5+6YcI/22U2P26dQfVWruzteqmNgT/tOabSX8XnN5BpyjYfMA5FUnnPNfA5rGZu8txwnrHJ83Eg95Sm7Xc4HjLSNq7dw9C06s+YlENuzPoUqXKnho9eVFtFFf/bf56HC7eLmk/+/rJqFPesIC9iVjFZ3T6FE6AXMOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uRa3t4sD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uRa3t4sD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA878C2BCB3;
	Fri,  1 May 2026 02:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777601477;
	bh=9QR0cnUgXF6rP+G/fgL1ZOPWMm8v63S58EfEC1IYVzQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uRa3t4sDDbQpv7M6lTSaoochov6MAYzb6y7riWmPgQGz26Fxvq1g0V6HxcEVB4OOZ
	 dDm6eFhIZRdVv31oRZYaYzcM7dzco1gJXHNAbV9z2w6ENGowfGEpvZjgqb+1Ow3lsx
	 9gYSbxshRf5euC1t6Eq4JDevvKjmwWKRicLObAiTsLAHsFzXK7MlcdnWyBzJwVVYBM
	 OXGarWvtRJ0/zcrnZPCMdqlgy6S/nsKNYM2bX5T6wASoFB/USX7PPs2/5lDpaeNa5f
	 sIQhDVq9nGKrvIyg/x9pS/ik1r8n0Pn28IWUnGTQvJqAD8FFrt8N5nUDZyBahPQGnu
	 zC9DTSnlxWZGA==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 94D0A1AC5863; Fri, 01 May 2026 03:11:14 +0100 (BST)
Date: Fri, 1 May 2026 11:11:14 +0900
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>, Saket Dumbre <saket.dumbre@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Chengwen Feng <fengchengwen@huawei.com>,
	Jonathan Cameron <jic23@kernel.org>, Kees Cook <kees@kernel.org>,
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Thomas Huth <thuth@redhat.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>, Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-acpi@vger.kernel.org, acpica-devel@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH v1 00/12] KVM Dirty-bit cleaning accelerator (HACDBS)
Message-ID: <afQLwhnDLtCHnjeQ@sirena.co.uk>
References: <20260430111424.3479613-2-leo.bras@arm.com>
 <86bjf0zj2p.wl-maz@kernel.org>
 <afNZQKIiKmHPD5My@devkitleo>
 <86a4ukzel3.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ssT59TgwkbIJmTw+"
Content-Disposition: inline
In-Reply-To: <86a4ukzel3.wl-maz@kernel.org>
X-Cookie: 667:


--ssT59TgwkbIJmTw+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 30, 2026 at 03:51:20PM +0100, Marc Zyngier wrote:
> Leonardo Bras <leo.bras@arm.com> wrote:

> > There is no enablement needed on VMM side.
> > Yes, I have created a VM on upstream qemu with --enable-kvm and migrate=
d it=20
> > on the same host. (Inside a model)

> > That was the first test I used, but then I found out that kvm selftests=
=20
> > stress up multiple scenarios in an easier way.

> Except when they don't. In my experience, the selftests are only there
> to give the CI people the fuzzy feeling that they are doing something
> useful. I have a collection of examples indicating that what these
> things test is not representative of the bugs we have in KVM.

There's a bit of a circular thing there - if things are working well
then the selftests really shouldn't be representitive of the problems
that turn up since people ought to have seen any issues they show during
development.  If you could share your list that'd be helpful.

TBH the various stress style tests like the dirty bit ones in the KVM
selftests are actually a bit of a pain for CI IME.  Since they all
control their runtimes by iteration counts rather than time there's
scaling issues, the performance is such that on lower end systems
they're often on the edge of generating timeouts leading to unstable
results.  They also interact so poorly with the fast models that the run
time blows up spectacularly which is it's own problem trying to run
them, that's partly on the model side of course.  These performance
and/or stress tests really aren't idiomatic for kselftest so there's
always going to be some tension with trying to run them in that
framework.

--ssT59TgwkbIJmTw+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmn0C8EACgkQJNaLcl1U
h9CS4gf6A7/M0j4C+bjIv3MUjhE/mp8ttmFweM6NFGjW71XsY5UMxrlSOLPo8FsA
dc18jjcaPaGl6ozZGbZnEdt4/olC2ZeZCW+itSIOMNCTlcUpK7MRkAu6/L0/NRyF
hUup3657nGbemC0awUnJgdPtnRl2cUej+eLw6rLa6LUpC2VNQixM1GputtDlcbMB
xtTncUwiuypXtPjVfGwx6NasjoOux+XHXF3s2tdeFX8crXdtFojI6aGqNZ0+abxH
RT/GD1WIOVZwmAQ0PYhC8XkPYyL8wQ92yjVZGjw5vXDPNlS/CesakgrnLJcL5pfq
wxdoTRitTAuP8hoREPUgw/vN5C7QQA==
=FWnL
-----END PGP SIGNATURE-----

--ssT59TgwkbIJmTw+--

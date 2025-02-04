Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0B92D057;
	Tue,  4 Feb 2025 14:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738679546; cv=none; b=LPkPy9rcz7YFW14TdqhdhR9MWD3luS9nuErujFZb3DkwtbnjSGlzgtanzD/IZ4hdQ4tjTUv5vfTNi4OS9kzqSA6lCA15TTHWhDgr+Bl8QEtbQiYD9kzziodYyDjN2TF/huJ6E6y8H9PG3mdHhPggl/DPDAN0GGPfNCYsVED8ynE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738679546; c=relaxed/simple;
	bh=Euhfoq6TLskk749URRaDQVtHzdaHQ0kVMWrkuF1TOiE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pWOWQvLf3XG4+zP9u527HYONtAc+vfpUHDY68Hh8QcjF6sEa+bnPmoFn1JxddVWETyGeIKbha5ppbAaMu3sH5C/zd4sAPhDPbDARnj6NkhIwzzcrt/17zNHow2P3yDleKlWZoJTWYeoArVtmuITAliP4UK3FzGMyLTh7M/1B+dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MStt8VdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MStt8VdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB569C4CEDF;
	Tue,  4 Feb 2025 14:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738679545;
	bh=Euhfoq6TLskk749URRaDQVtHzdaHQ0kVMWrkuF1TOiE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MStt8VdEbhnU3lJQFNILR4VHWyYCuJCm/CRHQGsd39ojT6M3neKzZAU5x+6waMIpX
	 ecqofxDZdaGWtspwyR78ggfxGeB2pxuRDTdGXjahJYO4XHLEmn2+2ZL5p5XPAIeW9r
	 //plznm4yIY6evAtoLr/RPWdE75UACnXobpuSNXWNICLTuiuCQLilPGJjDG5LMam9d
	 PQU1Ec/3jmiZxhzml730YJ6RjktXP1Wl+6/xqwMbOcQVYVR6fZGstE9Fc4kWjduehs
	 9MgOpBvSk4fsfEYag1G8/7I6mVmz+qPEoAuMTVbYM8UZLoUU7StbrNeJZbT++siohr
	 60L14ebr+U70w==
Date: Tue, 4 Feb 2025 14:32:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: uJap072421@linux.dev, Quentin Perret <qperret@google.com>,
	Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 09/18] KVM: arm64: Introduce __pkvm_vcpu_{load,put}()
Message-ID: <5b73e1ac-a48d-4064-a095-26cd9662f0c1@sirena.org.uk>
References: <20241218194059.3670226-1-qperret@google.com>
 <20241218194059.3670226-10-qperret@google.com>
 <5ca7588c-7bf2-4352-8661-e4a56a9cd9aa@sirena.org.uk>
 <Z6FO04PZtY8fsJhq@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hZGwqvAiR40zlt9m"
Content-Disposition: inline
In-Reply-To: <Z6FO04PZtY8fsJhq@linux.dev>
X-Cookie: Spelling is a lossed art.


--hZGwqvAiR40zlt9m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 03, 2025 at 03:19:03PM -0800, Oliver Upton wrote:
> On Mon, Feb 03, 2025 at 07:50:44PM +0000, Mark Brown wrote:

> > Current mainline crashes when running the arch_timer_edge_cases selftest
> > in pKVM mode on a LibreTech Le Potato board, with a bisection pointing
> > at this change.  The system dies like this:
> >=20
> > # selftests: kvm: arch_timer_edge_cases
> > [  130.599140] kvm [4518]: nVHE hyp panic at: [<ffff800081102b58>] __kv=
m_nvhe___vgic_v3_restore_vmcr_aprs+0x8/0x84!

> Thanks, fix posted here [*], although as a consequence this machine will
> stop running KVM in protected mode (which was never meant to work in the
> first place).

Yeah, I wasn't clear if this was something that was intended to work or
not - it's all in a constant state of flux.

--hZGwqvAiR40zlt9m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmeiJPMACgkQJNaLcl1U
h9BDAAf+JAMcfN7yntUjtlLw50z/v5lCegG7EiTtVEvT8kwLbYGS7ld2HEzfNFiK
rTlpfALF2b81GimdH35TTPRl1FFgPygwCt4j8N1GcXiFif47Q1a3TRwNjb+wJUH1
Dm/iTV7HxZk7fPqefyEGirTNt6e4f2hkso3/XHVRCsn3BKhPYU2OAUj0CFqzrrd2
SdGFMZJnRe8QewuZ3g4EpCg9UvuZXjG8Af7u4WrYw+DAceX8dC+Eajct50FX9p5l
fDoUDAacSMXph9h8tu/dHxpKLNym8nExy1zpuUXu2U4Ckzr4x37HgyqZ1AZOYrij
hH1WYyL88f6C8+HLlWIotC0pRHV8Nw==
=H6/6
-----END PGP SIGNATURE-----

--hZGwqvAiR40zlt9m--

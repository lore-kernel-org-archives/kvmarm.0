Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955F713CFA8;
	Fri,  5 Jul 2024 17:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720199938; cv=none; b=DkhKPgp5Nr6JUEhht9F17mMFdp76RaNNE/LVZ+jsyv4gf5ZEz5KJlRRGucl0fsowezyZ/R5LvNl3hbSbpC5y2MY0B8d7XXRpNHR2ZybrOMRx8tZb4Y3kZ4wU/aMlL/JPYxqYTTLREMRfy5XFOVaiGTFDmWi1zbo81SvUhijzJLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720199938; c=relaxed/simple;
	bh=1ituLkOnC1WTd8BmbU85n2/gdw3Sgu9chR+b8QtLOL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H3BvX3iM0z/m83Ub6VR5TWKPdxu7VlS7lWvDqTUEgPQqzQEhgmefb3p/XFEmXIP7ebATTPHcGctDxyX0K1esPTH7xUJ604d7TXjuj8GBJKm4eqg2s1yOgZx+Ua3+wj+Idedl5Gpt7MYH4jao/dSH0sMqkMCwuvBDidGyZTXrco4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YWK+TGoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YWK+TGoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA25FC116B1;
	Fri,  5 Jul 2024 17:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720199938;
	bh=1ituLkOnC1WTd8BmbU85n2/gdw3Sgu9chR+b8QtLOL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YWK+TGoR6MVqxQCW1zcXJpb2GwT2/RhOuNMoFSAk+X0rrZlFRugJigCYDbffQnUNW
	 XWVwbQefZHUnrALHlzSxXuewRrvKn1GyKg/Eurx24TeoPIJqrY0w4nlxuhgSCSsZ8p
	 nqS1lztQuytmIgRUO4n3BcYlnn8CylQq4FWxtoduCa09bMoYnXIbkGaIno003peroT
	 iYwpaf/crdUL+dtbeI+AqLDn/2pd/Y9H/2F34W4MoHEMep5xLzJNooJ3ebNlXse0Qr
	 j1JySWiQDe07/g9AFBqWagaoyAK6cT0cqpWwp0gYBvFLGUM9h8WmelBAT58Z2ZSDfR
	 QBZqH9uAJ/czg==
Date: Fri, 5 Jul 2024 18:18:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 0/4] KVM: arm64: Fix underallocation of storage for
 SVE state
Message-ID: <fec60c7f-0cc3-44e2-8be1-09c120e8523e@sirena.org.uk>
References: <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-0-b6898ab23dc4@kernel.org>
 <86a5iw3ri2.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="U5p+oewpuxta8YH0"
Content-Disposition: inline
In-Reply-To: <86a5iw3ri2.wl-maz@kernel.org>
X-Cookie: Look ere ye leap.


--U5p+oewpuxta8YH0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 05, 2024 at 02:20:05PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > As observed during review the pKVM support for saving host SVE state is
> > broken if an asymmetric system has VLs larger than the maximum shared
> > VL, fix this by discovering then using the maximum VL for allocations
> > and using RDVL during the save/restore process.

> I really don't see why we need such complexity here.

> Fuad did post something[1] that did the trick with a far less invasive
> change, and it really feels like we are putting the complexity at the
> wrong place.

> So what's wrong with that approach? I get that you want to shout about
> secondary CPUs, but that's an orthogonal problem.

As I've said from a clarity/fragility point of view I'm not happy with
configuring the vector length to one value then immediately doing things
that assume another value, even if everything is actually lined up
in a way that works.  Having uncommented code where you have to go and
check correctness when you see it isn't great, seeing an inconsistency
just raises alarm bells.  It is much clearer to write the code in a way
that makes it obvious that the VL we are using is the one the hardware
is using, for the host save/restore reading the actual VL back seemed
like the most straightforward way to do that.

A similar thing applies with the enumeration code - like I said in reply
to one of Fuad's postings I originally wrote something that's basically
the same as the patch Faud posted but because it is not consistent with
the surrounding code in how it approaches things it was just raising
questions about if the new code was missing something, or if there was
some problem that should be addressed in the existing code.  Rather than
write an extensive changelog and/or comments covering these
considerations it seemed more better to just write the code in a
consistent manner so the questions aren't prompted.  Keeping the
approach consistent is a bit more code right now but makes the result
much easier to reason about.

The late CPUs thing is really just an answer to the initial "why is this
different, what might we have missed?" question rather than a particular
goal itself.  Adding a warning is as much about documenting the handling
of late CPUs as it is about highlighting any unfortunate implementation
choices we run into.

Basically it's maintainability concerns, especially with the enumeration
code.

--U5p+oewpuxta8YH0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaIKvoACgkQJNaLcl1U
h9A7Zwf/f+n4dM8+OgqZHibhjB9e9RE3NquJ4DqHhCAvYwl8b4vB3y8KAvv1uL19
42PvcWTcg28wAmt9BR2eF05J0mOZXToD0He2aNaNQKoSF1gG7ayBM7KzVqfh9qMF
aaZDUnkD3jvlf39WvsKWnmD06+fG15bovccYLNlATl5AXVsve1gT3znNTp+dL+Wj
TY4pcyGbDTdsaGTjdDlEldvJ3D3uMncRHRhGX7nBIzHLb4GqSwYiMXBSOtir94y6
oAPbwPU8RKPSa3Mb9Zrsj5/SG6fn3NoOKvqyOeQGR6g54V7GpL/ltsEsplA9/AOI
PFxv7rPneFxb8D8sXVDCOJ0kQMtnug==
=/oWC
-----END PGP SIGNATURE-----

--U5p+oewpuxta8YH0--

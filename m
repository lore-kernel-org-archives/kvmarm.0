Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3EF1DB94D;
	Wed,  4 Sep 2024 15:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725464943; cv=none; b=PKu83Vhp+tFA6NJc+2zmTwRZanrmhIvMgV1w7UYFcNbcqTIqvNIJYKsq9hCN+C4LY5Z0FjpID/SKXn4j0R0kxASXyqyCwSTe46Amg/qm9Ux2l7Ra+ICQvfusbGjjm6yLI6gwPzKCM1s4DqjArTD5UchDBz8mW2im8vgmThxR6rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725464943; c=relaxed/simple;
	bh=9ET7CwVzW3Y/Gyot7w2SlJZJyyMRXdJh6HR64nY8rkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KZPBZ9+dqQsIbPkBYkci/N1+71V8ZzwGOQbbnDl0jsvTauOCWrBc/XLjho5AU1GiGdjLwULs8+SkJJK1Bww5JazTEdylEiTqxppdFYIYWB0v4lhD146XrzFxXK1lDLa4J1QB1ZvsHM6sZf3z3yVIIA2i1qXoQmUljQE/Iak0X8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VLp1/ysF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VLp1/ysF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBA3C4CEC2;
	Wed,  4 Sep 2024 15:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725464943;
	bh=9ET7CwVzW3Y/Gyot7w2SlJZJyyMRXdJh6HR64nY8rkU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VLp1/ysF6DNSNO7GL+lptXOXMih/o19RRXSbna4n9p2UQVehTAt5TTgji07VG4MO7
	 TJ/6r3kgHQgQmw6g34tnLEWs0UMQiJeO5m8SnvnuJEnZ7v1kUrALGPFprQJRSXpRYR
	 Tk8t1/ZchChOsYBlkLG74RfLdjIDWexxLmjrJ1WiuRIYO9i1UI+4exEZEaJKicRzpv
	 qa6+3CHQW4o+gyRhpVtPAbFtD2DGYnQMEaLpoL8eUF1VcC2iIl61k3xUnbU5NilLTX
	 gqs+dfup3GHOW9mCUOS1qM9+UEnxIFaYZDXnT2kq6JEKYbQRmA/5Td9mfcijoFrtiY
	 TM3LzdzZXuaFA==
Date: Wed, 4 Sep 2024 16:48:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 0/4] KVM: arm64: Fix underallocation of storage for
 SVE state
Message-ID: <a3f2f13e-be22-4a09-a8a6-5faef818defe@sirena.org.uk>
References: <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-0-b6898ab23dc4@kernel.org>
 <86a5iw3ri2.wl-maz@kernel.org>
 <fec60c7f-0cc3-44e2-8be1-09c120e8523e@sirena.org.uk>
 <ZowGFl/1AEuevh96@e133380.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yeKNGGR1n0YihxRe"
Content-Disposition: inline
In-Reply-To: <ZowGFl/1AEuevh96@e133380.arm.com>
X-Cookie: Linux is obsolete


--yeKNGGR1n0YihxRe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 08, 2024 at 04:30:30PM +0100, Dave Martin wrote:
> On Fri, Jul 05, 2024 at 06:18:50PM +0100, Mark Brown wrote:
> > On Fri, Jul 05, 2024 at 02:20:05PM +0100, Marc Zyngier wrote:
> > > Mark Brown <broonie@kernel.org> wrote:

> > > > As observed during review the pKVM support for saving host SVE state is
> > > > broken if an asymmetric system has VLs larger than the maximum shared
> > > > VL, fix this by discovering then using the maximum VL for allocations
> > > > and using RDVL during the save/restore process.

> > > I really don't see why we need such complexity here.

> The first patch is orthogonal cleanup, and the rest doesn't really add
> complexity IIUC.

...

> > Basically it's maintainability concerns, especially with the enumeration
> > code.

> I tend to agree here.

Did anyone have any further thoughts on this?  It's been roughly a
release cycle since I originally posted this, and there's been no
changes requested since -rc1 (which was itself just a rebase).

> The host could never use over-max VLs except in non-preemptible kernel
> code, since code doing that would be non-migratable to other physical
> CPUs.  This is done to probe SVE only, and the extra bits in the vector
> registers are never used at all.

> Can't pKVM just hide the non symmetrically supported VLs using ZCR_EL2,
> just as regular KVM does for the guest?

> (I may be making bad assumptions about pKVM's relationship with the host
> kernel.)

That's one for the pKVM people.

--yeKNGGR1n0YihxRe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbYgWgACgkQJNaLcl1U
h9BHAwf8D6ZCKGynDWz+yMuGcpeCTTE+wTrnOK/GQN3mMYt6pN4v0L8z5XEQZeco
bL8rVYjugL/uRRv19TrzJcvm46VQlmDtkRD41B1dy7vZFp7DCID2tAkMQyFxu0NU
jYF48UHUWtnDa5Tpluj+eSNvdHjqk4bvqLXSMmigSnQibu2R1HZ01l+bSrQgmwqn
9B1d2VgTJPKnTtJJ8CNLocEM5zs2ZhPG3H+p4omSClALzNvSBUuUozhdfDeWm+1O
IPwAVQR/1HG0YfYpah8cZKIYmz7pJHDSVol1SrfHF8LyLmdsTFGTMvloEiByi64I
Stg+7CNujMMqFiaG7OxYFQ66xqJigQ==
=dleX
-----END PGP SIGNATURE-----

--yeKNGGR1n0YihxRe--

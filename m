Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D40A433C5;
	Fri,  6 Sep 2024 18:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725645814; cv=none; b=TWy+zZT/UlqOghHiyMil8PpJszDdR4uZpSE/HVqH/JBUguEOiVPsRUAXn0RMREd3+tb599K6DyLMDOk5zYy31Ch4VrDiMQB83AufHIUBwpERvg4DvhcLOAXfyvKy9Hymyy+kLZJ+AGsQRyRdr6oxQ8JH/FNX8U6mTQsHsKUQao8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725645814; c=relaxed/simple;
	bh=MaepPoj4f+kv5HccYYdZGuJLeAvjHzHutksgg/mHnt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r7pCy+ThdRkFtwzeTQWM94G9ob55K8x1Jabe8Sj1qKQEjY4i49FGMsJY/FOf+Yy9ZGz0hYQ81qD7D50CMoRBdmY1iYRj/wCBVNJGKfMaxmQS8tLwQ0guKSNlapWL4nhR7/hGmh3OfGi4pfxtwRLnrS6wPT0MQ/WYwY5PvY2hk/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HAnnDzfO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HAnnDzfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB61BC4CEC4;
	Fri,  6 Sep 2024 18:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725645813;
	bh=MaepPoj4f+kv5HccYYdZGuJLeAvjHzHutksgg/mHnt8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HAnnDzfOhy4jtVpPPbKxWZBmJzrcYHHSey4W1v5aVouL841Ja0UV+wL+1XSiFmdlK
	 TJMOxUkqvvZ0cKBQdrYRb/BTym9wG2jGOa5C+JnWFibEt9B2yMEET3bNzJm+NpuJMK
	 N9uaBXDXNl0RyuEYn8QgK7UXgiOqJHCiHhmYSar+x5SZmQuLcacdsiUh30s5lIqpae
	 CKMrBsjCeHwx1cQUUD4LZgv4Jje12vmRgr1sRrSDpHCpvWeEv/iD+kndJHPAUpNNR4
	 zBNjnW0w1c2gHxOtEjZznjms75Nh6m87ouYlUpDJMO4r/KwIo0NrcYElFtfpvgYXHu
	 Z742GInoV3GoA==
Date: Fri, 6 Sep 2024 19:02:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 0/4] KVM: arm64: Fix underallocation of storage for
 SVE state
Message-ID: <ZttDmNTX0vuddRrZ@finisterre.sirena.org.uk>
References: <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-0-b6898ab23dc4@kernel.org>
 <86a5iw3ri2.wl-maz@kernel.org>
 <fec60c7f-0cc3-44e2-8be1-09c120e8523e@sirena.org.uk>
 <ZowGFl/1AEuevh96@e133380.arm.com>
 <a3f2f13e-be22-4a09-a8a6-5faef818defe@sirena.org.uk>
 <CA+EHjTyCvG2KL=LPhbAf+Wo66QoC_EMk1xn+R9X-yKunHQ-JhA@mail.gmail.com>
 <Ztspjf0SHx7nz2lV@finisterre.sirena.org.uk>
 <CA+EHjTyjVMw5CtEiLoZzvnnano94UGx_URhFBd7BRYm89K+XmQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="876DBiDwz3wh081n"
Content-Disposition: inline
In-Reply-To: <CA+EHjTyjVMw5CtEiLoZzvnnano94UGx_URhFBd7BRYm89K+XmQ@mail.gmail.com>
X-Cookie: Your love life will be... interesting.


--876DBiDwz3wh081n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 06, 2024 at 05:14:09PM +0100, Fuad Tabba wrote:
> On Fri, 6 Sept 2024 at 17:10, Mark Brown <broonie@kernel.org> wrote:
> > On Fri, Sep 06, 2024 at 04:35:29PM +0100, Fuad Tabba wrote:

> > > Yes, but that's not really the issue here, unless I'm missing
> > > something else. The issue is that pKVM needs to store the host's SVE
> > > state too, to be able to restore it. So hiding non-symmetrically
> > > supported VLs for the guests shouldn't be relevant.

> > If the host kernel is also running at EL1 and it's only the hypervisor
> > running at EL2 then the hypervisor can control the VLs that the host
> > kernel is able to access?

> Yes it can. But do we want to impose limits on host VLs when running
> pKVM that might not exist without pKVM?

I mean, at the minute the host kernel will just not configure any
non-shared VLs so pKVM isn't making a difference anyway.  Even when we
add kernel mode SVE usage kernel mode FP is preemptable and schedulable
so we'd not likely want to use non-shared VLs there either.  If someone
ever felt moved to add support for using any non-shared VLs the most
likely usage would be for userspace and we'd constrain any tasks using
SVE to the cores that support their VLs similar to how we handle CPUs
with no 32 bit support.  Hopefully the scheduler would cope well with
that.

> Although AFAIK, such hardware doesn't exist in practice, the reason we
> went down this rabbit hole from the beginning was to ensure that we
> wouldn't run into problems if it were to happen.

Yes, it's not an issue with any presently known hardware - the issue is
leaving nasty surprises should someone build it rather than anything
immediately practical.  Ideally they won't.

My general feeling is that it would have been perfectly fine for pKVM to
enforce what the host kernel wants to do anyway, if we ever do add
support for using asymmetric VLs and care about doing so on a system
running pKVM then dealing with pKVM imposed limits at that time seems
more than reasonable.  It probably wouldn't be the largest part of the
work.  Equally we now have the code so we may as well use it?  It's not
imposing huge overheads.

--876DBiDwz3wh081n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbbQ8EACgkQJNaLcl1U
h9BJdQf9EaCUYACbwn8Gsi3F9+IIPcNkmI4y6CIhJzPGv67wAB9AX3/y3IS4yOd4
K0+/T+5JfeHMUxTxSGn6rBmlV4bwTTXJOQN+Ipg6AMdJyyuyt0dXUlaxocfySagt
hp5RsmVV0K+b3G0hl1EDcoBs4NX7FjXdD+MNRdE5OgaW2oqZVidbTj2lyL67HX8p
/1Shzczzkl3kXP5b/r0AYgYihA8a/I4eC7P1+AKiXa4ZqGYqfi5GI9dVtIuzs3R5
xU+9vmLEmAqyThtU6MaIeaKsQDF2Xxpw0MbOQVHbeEzdKtdp0Hnz0GOmzlnR2l91
7PBiDNWlKbIAsC7x8XSv49uJ1nPNsw==
=L/vW
-----END PGP SIGNATURE-----

--876DBiDwz3wh081n--

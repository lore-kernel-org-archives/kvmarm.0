Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AD83EF66D;
	Mon, 11 May 2026 12:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778502669; cv=none; b=j0xJqcL9EhOVs1Nt0J6vFFil77+k8LRE1ZiJo0ycv+L2R1KKbYvX+pJzunsmjIntWQq3YsjO6Mrg4equr++QZGFy03cVeAAtEhLOEG9KGvVXRjbtcC+7DICXSSYUrnvI9ieUSTfk6f2AOeC2Rwl0qo+zjsoEgpDqBJ3Zd6f8U9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778502669; c=relaxed/simple;
	bh=4cj4AFpxR7VfRzsb4XVcpSOKHntygkHpeH2TRzpG76A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BaP9h9acv2ENAUrKbX9Xh0wBkp//vd3tlosqBR7fhM4tKxVVDZRcnlNjAKlePWsS6Mudzeuo7W0HWhPVU28W0flfJnDJdOg6qIcxiffMfFmQ0JqglyXg/lhZ7LMWQKuUM4+MTPFr1mvXa6WeKRDUxW8EjTVbehNm24rLQ1u2/IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ik+Jsoeg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ik+Jsoeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C90C2BCB0;
	Mon, 11 May 2026 12:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778502669;
	bh=4cj4AFpxR7VfRzsb4XVcpSOKHntygkHpeH2TRzpG76A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ik+Jsoeg6Q3DJuanPHz1lpNamzmd17Yr5QPCV8lyzZTR8FB/LKe+SXBQRARyF3Q6E
	 ugGWVkLSx7xQOY2BOpClEh36pzqyfKnvC/6lBvcZNDtCRocKIM4VnXlk2Jk4QSDHY6
	 fIhnWYrcmxdyarFsFke6+3jj7kE38dPsZIsTKtGv43mZcGCF0tH37wnju55G8vayL1
	 l5Uj4B7pK9w4MJR2hHx6sIJg37t4GoDh7lquM0WSg6eHo3uGZWmY2DNGWjuA1YB3Pl
	 5batzUW6ViddTwtV6B7gw53TbJHoAuZBsxoahpSezLjrNCGGgBz6IMl7VUfifq6jz+
	 o/fVhTzgqoYeA==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 1B24E1AC58A9; Mon, 11 May 2026 13:31:07 +0100 (BST)
Date: Mon, 11 May 2026 21:31:07 +0900
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v10 01/30] arm64/sysreg: Update SMIDR_EL1 to DDI0601
 2025-06
Message-ID: <agHMCyu12-q9qSyI@sirena.co.uk>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-1-43f7683a0fb7@kernel.org>
 <af4ZYVFsbYlEfdOu@J2N7QTR9R3>
 <af6DH_j7pyEm4HyI@sirena.co.uk>
 <agGyAvutI1GOCQkI@J2N7QTR9R3.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pfCVkcJhE9mTQmhr"
Content-Disposition: inline
In-Reply-To: <agGyAvutI1GOCQkI@J2N7QTR9R3.cambridge.arm.com>
X-Cookie: Truckers welcome.


--pfCVkcJhE9mTQmhr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 11, 2026 at 11:40:02AM +0100, Mark Rutland wrote:
> On Sat, May 09, 2026 at 09:43:11AM +0900, Mark Brown wrote:

> > We're exposing the affinity fields so there's a build time issue.

> What I'm asking is what is the rationale for updating these definitions?
> e.g.

> * Are we planning to use any of the fields in a specific way in the
>   *host*?

> * Are we planning to use any of the fields in a specific way in the
>   *guest*?

> * Is this updated just out of habit?

> Knowing the rationale would help with review, even if that rationale is
> just "it seemed nice to use the latest".

The immediate motivation for including this in the current series is the
above.

> Which people are aware?

Probably a conversation best taken off list.

> > > Do we expect to expose that to VMs, or just hide priorities entirely? I
> > > suspect we probably want to require that the guest sees
> > > SMIDR_EL1.SMPS==0, and not care about any of that.

> > Currently we're not exposing priority support to guests so we don't need
> > to worry about it yet.

> Do we plan to in future?

The plan to evaluate the priority support that hardware implements in
the context of practical systems and consider if and how to expose it
for either hosts or guests, we need to ensure we've got a good
understanding of the system impacts and user needs.  Architecturally the
priority support is all very implementation defined.

--pfCVkcJhE9mTQmhr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoBzAoACgkQJNaLcl1U
h9DPQAf/SInPpjUAtj1bRvp1YePRMRh2qdaVto7ygoI98Dhsvq+5UWD7dCYSDKJt
2aAm55eLL3hSs4fkLK4HPUnXDsBez6ZxoGQPvFtcuM74FRKPBHuKQ9GvWB6ueO08
owAzkEPBUqaDWkHup7eQwXwlXtksLw2WaTniQaAaKLprrLIDAr97U30kaLowRMbm
/1HPUx42NG+yEZs7O0KfEPKzl6WdApz2zxBxRgLYzgs3QHKJDiQZ9g9z1NryLgSK
+QHdfRFhN/iRUaHqgHY50zCrysR8LUXjYSjS/VbSk3c4O1m2AF0GV84j3uwAunYy
4Y6zZmylTgiqhjTcKPAYWPsp8DKdiQ==
=Gq3j
-----END PGP SIGNATURE-----

--pfCVkcJhE9mTQmhr--

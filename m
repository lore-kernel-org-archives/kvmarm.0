Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE17195FFE;
	Wed,  5 Jun 2024 13:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717593462; cv=none; b=qW6NIV0H1sH/ascH3yxVBYKQKWYy9esM0wgdTKUn6sSjd6C5hEN0RsQwL3L02L01SuaW7wvJyAj0seB4BJUldAz3s1+wJuinwf5B3eEgNRXOizeM1tTFAcuFVaGKmysYVaV0fZFBzN51wqb7dce2y3O9cbF4r8OnsJsMb0FswFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717593462; c=relaxed/simple;
	bh=vtQ2ztx8bpH23oukRF3ssYiPY1N+3RM1KbSa8Y3gtMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CimEi61m5mb4URUgIk2nOw3kZpj1MyJECjrtOWi0daKgyPCHM7EVMw+QPA7FIEULfv+znXLf/HxJAkEMT7EVMPCThu5CGUU0SuU9ai3346YyP0NV+8lMroZXrX1NICOsDS3kxRUog6dCyfJ1k68waDkfWhVJp55fJ39nXYBaOSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D9MWZXpg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D9MWZXpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A32C3277B;
	Wed,  5 Jun 2024 13:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717593461;
	bh=vtQ2ztx8bpH23oukRF3ssYiPY1N+3RM1KbSa8Y3gtMI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D9MWZXpggxNZc7BjJRmi1eMi1B+ACAxvQmCHEHCVtJBIcpFyC9YhRc0H/UXzuPmlG
	 YnJ7hRsNCSM6NsvJilBJW6DkTi1nZE+DoGZhHeDMyzXSY3mdbFGY+h+mWaJ0z7pwdK
	 5ldaXygtkZ51rGVANBCLhaX7U0zSuKof2fdppKUMSO9FcdGDRRNm2byOb/xd+w0OhK
	 hIIDD1muQfkKS3nV+n25SppPZso/pHV32VCTNUAI1svtJBQyYGRcSKNlcU1btm4x1v
	 AvAtWv9/mJXAyjtrWPRA9sNBNbzZ5WDWuLnlSi+UfjBPqXDUp3djTJHAVL5q+so+MJ
	 dj53S1SCdEY5Q==
Date: Wed, 5 Jun 2024 14:17:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 3/4] KVM: arm64: Fix FFR offset calculation for pKVM host
 state save and restore
Message-ID: <af6fd3c0-f411-4f33-aa8a-885873a74c73@sirena.org.uk>
References: <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-0-680d6b43b4c1@kernel.org>
 <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-3-680d6b43b4c1@kernel.org>
 <CA+EHjTxrCOv44T8uq1e2Vvm0SooRKix1zwhFqQF6=GN2H1iB2g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ZWJVHrSAVB/AiNlk"
Content-Disposition: inline
In-Reply-To: <CA+EHjTxrCOv44T8uq1e2Vvm0SooRKix1zwhFqQF6=GN2H1iB2g@mail.gmail.com>
X-Cookie: Simulated picture.


--ZWJVHrSAVB/AiNlk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 05, 2024 at 01:12:34PM +0100, Fuad Tabba wrote:

> If my understanding of the spec is correct (which more often than not
> it isn't), I don't think we have an issue as long as we use the same
> value in the offset on saving/restoring, and that that value
> represents the maximum possible value.

Yes, we could also correct the issue by switching to use the system
enumerated maximum but that still leaves us setting one value and then
immediately assuming a different value.  Reading the actual VL from the
hardware makes the code more obviously self consistent.

--ZWJVHrSAVB/AiNlk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZgZW8ACgkQJNaLcl1U
h9DYowf7B0Gh80pKdwlt71H4rUSGM0FVdVPx5yOdZVq/tPzh3QMHcGxzpzZJIDF+
Hcf2sOiu4qRXzj4836C0XN+V7FbmcOBmtfFqxD8jDrqUr6QJh9yaDL2VWWY3iasq
lG/KeDXr732vAO/70R0iWfrZWY7zAyJz4IsM8ts+tQ6yNrqy1vcOzTLDL45ubqNI
uo18MPYYttI8WRZE7Vsl8PVj/HPpvtIXH4H1D/xmkRHza4hAXoAChkgcu5o8K7uQ
HlxcaRF843E8XdbLY/cau42pcM6s1/cbQZj9NhrKLOIIjlaaKeqmgOJCoLGu0wWs
OohMPKqkLvMaucrnrq5nkJQ0DkzHDw==
=1EVk
-----END PGP SIGNATURE-----

--ZWJVHrSAVB/AiNlk--

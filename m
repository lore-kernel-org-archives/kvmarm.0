Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B20F81E;
	Fri,  5 Jul 2024 17:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720200336; cv=none; b=KeuDT3gVuLSlNn/1TkgV4TXYgWq3+g4roRMQto6DE1etM9mmWdSuld3n2h0ewrmFl7QuXpUWCvKogElqf9bFd5OGw2itvnH1SM1InvB1TQtKnBPYPkQ2uWGcf6mSBE5D+2tHnJHLKhC6AL0oHrZZvBpKQ/JVDfN3YKiol/j8mpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720200336; c=relaxed/simple;
	bh=oZtDZlzppPlYNNFWRwu0OzDYCMqR7kJRLTTKrnrJubM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=te7AQW3Ww/yv23SRxiSOlf9DPkpYoVhdLntLAm+AJzA+j8EHprznjKnU5NxPwRgX/0zphOx6AOdWHulN1CWkBMs+z0xol2LOJhtgr4zcAuBjDv1Ug76tXMaCbREljU+ESGye7LEYdBl5znF6aUdcqhU71M4W1ZYhve/iwzVkBck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fb5IRLF1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fb5IRLF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93479C116B1;
	Fri,  5 Jul 2024 17:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720200335;
	bh=oZtDZlzppPlYNNFWRwu0OzDYCMqR7kJRLTTKrnrJubM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fb5IRLF1k5eW0Ls5EDnMKjxLYSsfc/91S607mw4rkfjrftrBbXD19aoL/E1Rqs6cs
	 F4n9CKHoYA4sP0M876KFpscQSGcO9Vy4m+vkndKl47U6Wf72LMHHCGRUd+K9QNTP/E
	 4Rzm0rIy/aX5K6WuVFGaRFQwn3QSLSjwvgps4ss3mSUFI2kYMbCJ2pS7Tp251v9hUs
	 Som1vay13TY2Y2KHoM6ODXkYRwSnexA9hYDSdE7pgjy9VK3eCxXLOp85va63AII0RE
	 ijyKJSR0FgayBtx95SyjapO3O5aq07bxINkLmO77B+JHrdjHXdDqo7hsWDOEWamk3U
	 XTQu8+Axergyg==
Date: Fri, 5 Jul 2024 18:25:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 3/4] KVM: arm64: Fix FFR offset calculation for pKVM
 host state save and restore
Message-ID: <f1b357b6-b1c5-4d4e-a597-9fb2ff144627@sirena.org.uk>
References: <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-0-b6898ab23dc4@kernel.org>
 <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-3-b6898ab23dc4@kernel.org>
 <868qyg3r6i.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AfCAYV/OLD8b47zA"
Content-Disposition: inline
In-Reply-To: <868qyg3r6i.wl-maz@kernel.org>
X-Cookie: Look ere ye leap.


--AfCAYV/OLD8b47zA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 05, 2024 at 02:27:01PM +0100, Marc Zyngier wrote:
> On Thu, 04 Jul 2024 18:28:18 +0100,
> Mark Brown <broonie@kernel.org> wrote:

> > When saving and restoring the SVE state for the host we configure the
> > hardware for the maximum VL it supports, but when calculating offsets in
> > memory we use the maximum usable VL for the host. Since these two values
> > may not be the same this may result in data corruption.  We can just
> > read the current VL from the hardware with an instruction so do that
> > instead of a saved value, we need to correct the value and this makes
> > the consistency obvious.

> Which value are we correcting?

The vector length used when laying out the storage, especially in the
case where the hardware VL is larger than the largest VL used by Linux.

--AfCAYV/OLD8b47zA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaILIkACgkQJNaLcl1U
h9D8QAf+OR5lhqAIeMFQwoQmGlSwN9wJuxSiB0cEHlYSv8g6mrLz39UDh27uN6el
xYGyB3cKhDi8aRBd26hOyvrdf1slTKD3nHrTxr+asDG/6AJLoah+9EoDcCYkJk8z
1fGiH3C12kDNuRD62Szv3TVS0elJOkjgQWYU8dFWdb9jEZiPJpnsLALSEt2lhr+5
X2T9T6DifnxalpOXVJJhitoT2PQHfuwRgZJWCLxjyjFZQ26ax8yWxyTmj+9Wrpdp
+gICJKM1AOeTPbkcT2lNCZAKVpQBlLiYBND+vuFuYi5MDRiGR0dTqAnCxo2uRPqJ
PHj6RSngJ+s1Re3qWCtQLBEuvNz2Mw==
=YeVv
-----END PGP SIGNATURE-----

--AfCAYV/OLD8b47zA--

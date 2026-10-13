Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E7B1386C9;
	Tue, 13 Oct 2026 14:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791903376; cv=none; b=CJ3jDnzLF/3nwGEIESzduLlZU+6siuH0HmwQNYj0uWPz3zV9kq9V7loFDS9nMpsegMbSRkUBQ50tMPG8qemNRSz7JidnWCQvQ+M2ED0lKiKXfNyr3w6hj2bzv2ETr+1zbBw9BF8nwwArzBXFBt9+Lir1o7JNJu21xJb499gOCJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791903376; c=relaxed/simple;
	bh=YF2VkmBRsOzuoyFTDhFxGgzmei/0DrD0kJUmCM8GHXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rJjAcbsrYF0LVyCuggFMKgIc/aNKm+HNRS8F1Kwezkgyu3nBiB9+5KS4xia74JFjuURTOhORecRF3RwmzK8ZrDynKttO2U0e/wW4Fllt3Bhz1zWt1c19HHU9+JNJ8xtiEJgzoNAaKiyhf3apP9L1T4gR0QnPgf9OBq17QP73x0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L2cAR/jg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L2cAR/jg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014B71F000FF;
	Tue, 13 Oct 2026 14:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791903374;
	bh=YF2VkmBRsOzuoyFTDhFxGgzmei/0DrD0kJUmCM8GHXo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L2cAR/jgaFvnqz/+ml4gBaPFTnsa5gwroTiOohvWU86l/GfUyk6Z6537Lqoy5lZz4
	 uALtttTrmkEn1wiXh2Hyq6rRithWs2EXI9NxdtPammlZW/rv6JIUMMDbD5vPpcbB9b
	 dHHf60eNDwATIIjbht6BbUQzJbWt9PhSq50EzSpK4Ftafq3nyMhyKH1IUXPNr+I4dX
	 /xSG/Ak9PzF3BKhbIFKZoPW5CTZY6jSjeDz2fc1Ze3aoPG6Q8YNxnp+NaZeBCWOcNO
	 Po4nr0oXW1DGpxdJDn0yB/exYR6eY2O4Rsj2/MQmw4w0z0JQWrtoauJA9OfX6Abi8t
	 5ve6Av9oCu/AA==
Date: Tue, 13 Oct 2026 15:56:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>, Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] arm64: sysreg: Fix the names of two misspelt fields
Message-ID: <a2e3bd65-f374-4d37-af0f-893308d06892@sirena.org.uk>
References: <20261013130247.4135515-1-fuad.tabba@linux.dev>
 <20261013130247.4135515-3-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Sv3KlJBOQ6zDEouw"
Content-Disposition: inline
In-Reply-To: <20261013130247.4135515-3-fuad.tabba@linux.dev>
X-Cookie: Some equipment shown is optional.


--Sv3KlJBOQ6zDEouw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 13, 2026 at 02:02:45PM +0100, Fuad Tabba wrote:
> Two fields in the sysreg file have the wrong name. In DDI0601 2026-09,
> bit 10 of HFGRTR2_EL2 and HFGWTR2_EL2, which traps SCTLR2ALIAS_EL1, is
> nSCTLR2ALIAS_EL1, not nSCTLRALIAS2_EL1, and bits [39:36] of SMPRIMAP_EL2
> are P9, between P8 and P10, not F9.

Reviewed-by: Mark Brown <broonie@kernel.org>

--Sv3KlJBOQ6zDEouw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmrORogACgkQJNaLcl1U
h9BU1wf7BE2VjyOr8aFe2QuONbWs8JFIHDIapTog3Nkys38qJkUOPcdiY8BGlq1J
7ygK94Z+FHYVx6oOoQQNcPASntkrde2wYxRzHOqPD/IfpljcPO1JfaLLH04N+F83
9BYsZbxdnZLNBCzks2jSAPSKN4e3GLu7YpehOrwnlx80hm7gLQ8fwp/T1l39zwx0
vIoqMM96mB03rMTmQTbmqTK7XCpyWn1iMcaXG9YPywDLZHgzqG/893p2zvsGvXEP
esx7M5MVnVWLqySDkd503wNp6lfT7WOhtDFmjRRBuG0N3HkJUuMzUU0T6acRPj89
gWqE0kIZQbs3r8/iiSS/F1bo1W98Zg==
=P7Fn
-----END PGP SIGNATURE-----

--Sv3KlJBOQ6zDEouw--

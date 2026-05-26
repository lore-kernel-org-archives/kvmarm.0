Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08F93F58CE;
	Tue, 26 May 2026 13:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779801966; cv=none; b=eg5MljHaJpj4RD0a64ZX1SJ7gNMxTzTNuupA8Bl9boOyw13KHMLAlaBq8xcO35NPY+BV+7kiIPsVCmoXXE/lVVt3AVBvUxuQHoic9m/F3hFMFS5E1Gj6mXWzGVdD60l3jCD4StZdv2xwA+ZRXY38xUjzzPTyHRP8FMMC5FPPBnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779801966; c=relaxed/simple;
	bh=42BQf5cb0aa7ANVrL7TApWSiKbz/Y4tfFfyXq/jCX7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=THuiAoBO3FIL+8c3oD31BXojgWptORyWlFZhwsgP48c55GR0/QodHAm2vo1W/Ww2jQscEWHAFJj0NXOR+7mhac/HaR9t/1tyFy9lw4O2POlGbcHiE/U1i2Hg6/kFWqxzm4FBY0tJlESmcln5iebMXRGcq/0OWayKW54NacR8eRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TITtatTj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TITtatTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793F71F000E9;
	Tue, 26 May 2026 13:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779801963;
	bh=F1H6PxWdK7ElO8sXwbyLzjpAZlZnOUADTxmFnZZJISI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TITtatTjeuXKHP3vxhkMEUcUKI7aQF+KQAkDyIgK0iTk1YtqaWlWAc/NduBPKYfWd
	 BYW65ooqwULFumubeML0s9CcVKhQhpv2s8C7oUbhV8rJyac8kfYLoPiODnjdRE+lHp
	 PKTeqF/mQc5XZ/bIJd/1eNRUWf6eqa9qn7kmpoCxlqOOg5QLSgqziQLKkPsHiFNyBZ
	 +oHX5/MU89S30gtshdh+SRGe292Rl4cGaKO+xtSkF9ucMVDKcYaJW3Gy3pwh/oTJ8m
	 c/FdR9OPiamccYfUrulbWfvS1VaYCglE8LB09DUrqfmsi4f8/Ie/o3sAE3TMiB4zoD
	 rP31HXqWZpJmA==
Date: Tue, 26 May 2026 14:25:56 +0100
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
Subject: Re: [PATCH v10 02/30] arm64/fpsimd: Update FA64 and ZT0 enables when
 loading SME state
Message-ID: <d8074c6b-9bc9-496e-8a74-94ac18ce9a55@sirena.org.uk>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-2-43f7683a0fb7@kernel.org>
 <ahWWqU51Zffmhlo5@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="H7xcdA+9c3FyZG2q"
Content-Disposition: inline
In-Reply-To: <ahWWqU51Zffmhlo5@J2N7QTR9R3>
X-Cookie: You are fairminded, just and loving.


--H7xcdA+9c3FyZG2q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 26, 2026 at 01:48:41PM +0100, Mark Rutland wrote:
> On Fri, Mar 06, 2026 at 05:00:54PM +0000, Mark Brown wrote:

> > We provide a helper which does the configuration as part of a
> > read/modify/write operation along with the configuration of the task VL,
> > then update the floating point state load and SME access trap to use it.

> > +		if (fa64)					\
> > +			__new |= SMCR_ELx_FA64;			\
> > +		if (zt0)					\
> > +			__new |= SMCR_ELx_EZT0;			\

> I'd strongly prefer that we make it the caller's responsiblity to track
> all the bits within SMCR, rather than requiring each caller to pass a
> bag of booleans.

I was explicitly going for the opposite of that in order to make it
harder for someone implementing a future extension to miss a place where
an update is required, having the callers independently constructing the
register values feels like it's asking for trouble.

> 	unsigned long __task_smcr(const struct task_struct *tsk)
> 	{
> 		unsigned long vq = sve_vq_from_vl(task_get_sme_vl(tsk));
> 		unsigned long smcr = vq - 1;

I agree that's a better pattern for the main kernel - we could also do
something similar with a task_set_smcr() which wraps the explicitly
specifed version.  That would I think avoid most of the issue you're
seeing?

--H7xcdA+9c3FyZG2q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoVn2QACgkQJNaLcl1U
h9B0uAf9FsOQ191IjRxjDWRTIzKuXKL2RhEm/vJESCmoiliG05She/LfLMIqhDji
Q/cC/kYbmSE3xPCIIztZVByWhLSAIjMP1qWJ8W3yjzVVb22SlVdR5LgX7Ul7v2hz
VT9uQ1cHmCbdotaBfkRiVvlege2YZwhAYTA5zCvqN+4yL2CWGjB4260gU2yh+jXJ
pwK0TpvHk5jC3X3JLLtW9B9YzzcmWKbkwe1wQCsRvG9K8HHdXJzLHn30t5o7NSsY
nr3laBeKco7QBfqsrXfyQhpPahS34qLzpYrf41C3ZjLxt2nBIr/lGGN1Fs4owBdt
Kh2RXpL5IcSeFr8jyQ2A4InBCsw8kw==
=vL5s
-----END PGP SIGNATURE-----

--H7xcdA+9c3FyZG2q--

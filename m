Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E8F521211;
	Fri,  4 Sep 2026 21:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788556078; cv=none; b=gA+mvmmkq1Ows4gUBMLZMqi2+s8sQnuOZFgdSmubypPOHkKsiRN3lda9gVkWIqkv0xBiwzjtxaAnRFjYGWL12HQhW32xwAYjK/dxdtwtQYfUcAtidwGMZs6oEe3tJQOrzV2C88Pgd7yBr1EX1WwBP1Yo19bexhnTJIQnaQi+DtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788556078; c=relaxed/simple;
	bh=OcN3BZ4A6KpdYS+WMT/+ILplvgW62mU+jHQZrpov2J4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZdBH+Ah+Dr4qY20NJj1KXId4UavIuForYaHUkv6/7c7W8xTKoBC/A5DxoIjmDw3hk6CAZVWY1F5SYLg1Rl+ndDK0+ayAdakotLL1vAZ5+x4FGvtnizefV54x1sR0pXwxVo8POqOXxcHFIJRubn21zpi/a3E4Xy1YYdCR3YbmdYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S50/g39Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S50/g39Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893101F00A3D;
	Fri,  4 Sep 2026 21:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788556071;
	bh=v7qKDhZ+F/2Bi/cyOsP+5DU9BRD5spx5V6SRGgxoqJo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S50/g39YB+UKTmtZhDM86RL7eGgd5uMqzVcDE1aAlJT8XMQAqeHfkE58X7ZAr26AU
	 onB1eejg3jb1WO8cKRmxSPB3MvyMNkr+eT23R7PfSmy7LO9lko3ShF5ipG7JZ7cvjK
	 q7gKapYUS2LKKN7GMUzxJQeSbrSD8BweqOm9/PJ3wP56Q8qBtTRvbEQXecVhtbHxyT
	 V1F0xaFHoUj4i7tRvSu7cjG+ZxAaQ5wQiUaK5QERMs4M/zsPmmXntBhiXosa0wCNDL
	 NGiSltNgHL1pCcWcMBTEQwVSodVuiSuCD2HOgsoLUQe9Mudv0UuHFyJgj7i2Mz0Lsq
	 yQK3y0OxWGV8A==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 77FD41AC52F1; Fri, 04 Sep 2026 22:07:49 +0100 (BST)
Date: Fri, 4 Sep 2026 22:07:49 +0100
From: Mark Brown <broonie@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	Leonardo Bras <leo.bras@arm.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v20 03/14] KVM: arm64: Manage GCS access and registers
 for guests
Message-ID: <apszJZ17KUvd6BJ7@sirena.co.uk>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-3-f31750bdfadb@kernel.org>
 <apmfx08vccSd2MXw@gremlin>
 <d2659ac3-2f00-4fc4-8f9e-0585691a4ba2@sirena.org.uk>
 <apqA_SuoA6-TyHsS@gremlin>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UxxT9yru8a/XGYWy"
Content-Disposition: inline
In-Reply-To: <apqA_SuoA6-TyHsS@gremlin>
X-Cookie: My vaseline is RUNNING...


--UxxT9yru8a/XGYWy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 04, 2026 at 09:54:51AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Sep 03, 2026 at 09:41:26PM +0100, Mark Brown wrote:

> > originally written the code without expressing this dependency but on a
> > previous version Marc asked for this nesting as an optimisation.  Since
> > it's about optimisastion adding checks that don't otherwise exist on the
> > restore path would doubtless get the similar complaints.  Exactly the
> > same concerns were raised on v19.

> Could you implement the nesting the same in the cases where there is a bare
> ctx_has_gcs() as an alternative?

> So then it'd always be tcrx -> s1pie -> gcs everywhere and that'd resolve things
> also and make things symmetric.

> You could also I think express the dependency if it makes sense to.

Clearly we *can*, it's a question of what'd be acceptable - it'd result
in the compiler emitting a bunch of extra alternatives and conditionals
in the context switch path.

> > We could do checking of the ID registers at vCPU creation so we could
> > avoid worrying about them in the fast path but there was also feedback
> > about not doing that.  One idea I had was to generate feature

> Could you possibly check in sanitise_id_aa64pfr1_el1(), something like:

Sanitising the writes is a bit tricky since multiple ID registers are
involved, TCRX and S1PIE are in ID_AA64MMFR3_EL1 while GCS is in
ID_AA64PFR1_EL1 so you'd create an ordering constraint for userspace,
and you'd also have to handle the case where TCR2 or S1PIE are turned
off with GCS already enabled.  It feels like a bunch of complication,
especially if you start applying the same approach with other features.

If we're going to validate the ID registers it feels safer to check at
the point where we finalise the ID registers and refuse to start the
vCPU if there's an unsupportable configuration, that would mean the
check would only need to be done in one place and userspace wouldn't
trip over any ordering requirements with how it updates registers.  Only
userspaces that set architecturally invalid configurations should see an
error.  We could also handle things by fixing up the configuration at
the same point, disabling features that are missing their dependencies,
that's a bit more friendly in the short term but could lead to trouble
later on as it means we hide issues in userspace.

I think the best thing overall would be to leave the runtime paths as
they are and refuse to run with an architecturally invalid setup, that
would avoid bloating the fast path.

--UxxT9yru8a/XGYWy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqbMyQACgkQJNaLcl1U
h9DE8Qf/VR7HYcBaMw2G7Ups8tn2qUfYjOTJ99VnF8o6I1RpC8Nl2GgzkjHXBJyx
/nQjWZNQ2wAy/rdn2lQtjolxCA4p5ZnYXJwG6dVQmDAKGSvJJ5MxqgRAt0i220TR
F7XnsZKbtHp+rri39JMZoLszEfc28vUcUxh19+PF1UQfRaXniazCXbnBOAqyU6lM
+ROUaor3Rve9TvHm/uqKw7eiDnyYIZjxn/nj3S9GdFwTVKstI0WX1iu+LHNPcuva
qO3rGmzDFOtxScggNgCj497tEj1vvj8qb1Cz/+NnC5Px4NJKgqUq03twCDtTkWOr
flTA3wHWYD88gDv/NRFpxyWaWE+XdQ==
=j1jf
-----END PGP SIGNATURE-----

--UxxT9yru8a/XGYWy--

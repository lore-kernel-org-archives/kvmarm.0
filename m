Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37851E87F
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 10:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713264718; cv=none; b=cd+VqSgNnMz/oGRCnOqvDgVOlzJ1Dl0Wf26g9vQlhnFOraoqoy7ScRcaWRSjVLOlUD3pFZ5KcY3mRUpP6lXfF9OhEy7dp9q3V36HUO7UOo4dobSeGC7xVRpO6fKQGNNRRpdogNtl7zNq6uYcM5vZnbvBz+1rue3sJAqdDc6d9bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713264718; c=relaxed/simple;
	bh=CZ5QG08qUJlexZDDtW7Jg9mJP3iHpGKkNQvJkaxZ0eA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O+TrVpk8r7PO35cDhAwfJdD2PLpuGQP4p6Hc7sbYycJRLHL1wTRxjdV42JLOzALzV7FaJ0k1y3JWo0aifXW8q+5yQ/pF6iueCd8ELdlCeP/9vBU6/aKKz0pSodS0LU4krduqmeExY+VhmlysJc5lrd71oohSq6DHOi9M7QOUWTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ltBtlWUu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ltBtlWUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186B5C113CE;
	Tue, 16 Apr 2024 10:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713264717;
	bh=CZ5QG08qUJlexZDDtW7Jg9mJP3iHpGKkNQvJkaxZ0eA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ltBtlWUu6kI79KCbDQhhq6xjGsEPxgmccCd16aTIBkXxA6C8lrdzK9Ov3dt/S6dXi
	 kihP6eIJz3Ghl/ZSZu4kxwqpJfCNnCLK1k627XSKyr0S2OXWmr776MgD69PS3r1xtb
	 TX5wygdSuhTlOAEOknWlmTazI7KxhImMxIZfcoakMRvxtBXLb564TdngqWK5ML/L0C
	 UFm509f/C5OU7Syo4fsAo9/JfcxFE/OapmeDkM/GBxcNA99DOElLlsX7+FdDZZY0c5
	 hXu5KjqdvwLMoCLiIj6Oz5iMwPYPeBsAnBwWeEBLUnf5fAcJD2e6cQZNa7/MgFR9cA
	 4QuIQp2teBVoA==
Date: Tue, 16 Apr 2024 19:51:54 +0900
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	smostafa@google.com
Subject: Re: [PATCH v2 46/47] KVM: arm64: Add host_owns_fp_regs()
Message-ID: <Zh5YSuPq1cW5V3lt@finisterre.sirena.org.uk>
References: <20240416095638.3620345-1-tabba@google.com>
 <20240416095638.3620345-47-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OjEPLMf0VzTTSbs3"
Content-Disposition: inline
In-Reply-To: <20240416095638.3620345-47-tabba@google.com>
X-Cookie: You might have mail.


--OjEPLMf0VzTTSbs3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 16, 2024 at 10:56:37AM +0100, Fuad Tabba wrote:
> To avoid direct comparison against the FP_STATE_HOST_OWNED, add
> a new function that performs the check, host_owns_fp_regs(), to
> complement the existing guest_owns_fp_regs().

Reviewed-by: Mark Brown <broonie@kernel.org>

--OjEPLMf0VzTTSbs3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYeWEoACgkQJNaLcl1U
h9DeHQf+O4jLPTeW4AEJhDIXM0imA5Qwq9pkoflVEvjQkhJdKrMiehqNca0kNjxr
z0BbRktH9mgPR2PO9F6Bk0I0IsgJ+Zkh6eYL9vn2POB5/ZwYfVhWcCuRO+qdjxLv
d2ihVnlkH4wXdUeLLOfYJ3I8lwbBmO/80seOpRCsNW40gOoeRpOK4ADWVDUF0fOG
//WuajJ+dN4mEY8SEKEZryD7JNJ/qC/x3qa7OjLBaoOcE0VNCDDOm06pM6I/c9f6
kw4nlTQfSfcdWgkypZa39RUmZQCHFqDzgFgi5QnnvFhg4RPfit5Xn3aRYVzCQGz4
LLdms29tRbRd43p4RhdtOxXDdNbBBA==
=gE4h
-----END PGP SIGNATURE-----

--OjEPLMf0VzTTSbs3--

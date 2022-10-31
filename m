Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815BC17E
	for <kvmarm@lists.linux.dev>; Mon, 31 Oct 2022 12:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87D8C433D6;
	Mon, 31 Oct 2022 12:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667219890;
	bh=BJuHg1KuwZ+0wLsUE6QSxH4UbYhYGYccEFEyhYMXnhw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nPMj5Blv1QM4WdGb81ZHA7eLKgcnKJl1N98WlzH/yT8c6h63ing9scN7i9sJZwdJ2
	 Q+JvaVqzGkEQSRmQy6Q9hZJMPRp7mKL7lGQ6Jgr1lcNyZdkgxhk5z5wttrfP0LmucP
	 F6QyZ0Nd6NGxx5o2AVv1HkgIqBanGoPqtfUEfI2TnWHHWJuUML3vFUWwDy7IUFSsoj
	 G9eWQDT6vveFwOpTGFX0BCPg2HGdqq10NtpZml3dfQ64A0APlSCGF0H5C04Uq63ZR2
	 Nro7Jp3NQe1chIDlaXTgFwa3H/aIR73kry2OXrWUlpuNjhqNkJKJddaCB7wJiQvPO8
	 uMdofIXh1WXMQ==
Date: Mon, 31 Oct 2022 12:38:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v1 0/2] KVM: arm: Refuse to enable KVM on systems with
 SME but not FGT
Message-ID: <Y1/BrN8UpZz72X6M@sirena.org.uk>
References: <20221027205246.812586-1-broonie@kernel.org>
 <8735b6hmxo.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fd6t/19JUNXN1Xbl"
Content-Disposition: inline
In-Reply-To: <8735b6hmxo.wl-maz@kernel.org>
X-Cookie: Sign here without admitting guilt.


--fd6t/19JUNXN1Xbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 29, 2022 at 12:46:43PM +0100, Marc Zyngier wrote:

> I think this goes the wrong way around. SME without FGT is invalid,
> and yet you keep SME around and device to kill virtualisation support.

> I'd rather it is SME that gets disabled when the kernel boots at EL2.
> Furthermore, this is only working around a QEMU issue which can be
> fixed (as opposed to HW that is forever baked).

I do agree that it would be better if we were able to do this the other
way around however access to SMPRI_EL1 at EL1 is not controlled by the
SME enable control for EL2, it is controlled by either the fine grained
trap or the EL3 SME enable trap.  This was the primary driver here
rather than the issues with writing to the FGT registers.

> To me, it looks like the most reasonable course of action is a mention
> in the QEMU release notes that virtualization and SME are currently
> incompatible, and that the user needs to chose one or the other.

Trying to resolve it at the qemu level would certainly be fine, though
note that qemu has already released versions with problems so there's a
bit of stable door/horse issue and it'd just be a note on the web site
and any point releases.

> We had similar issues in the past where QEMU would ignore certain trap
> bits (HCR_EL2.TID{1,2,3}), leading to KVM misbehaving. Did we disable
> KVM? No, we fixed QEMU instead. This case isn't different.

OK.

--fd6t/19JUNXN1Xbl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmNfwasACgkQJNaLcl1U
h9BH1gf+LzdPYfUs8PogAguk9Nr4XS+uLN4sDJgASv1HjMKYm6b6yFixMIpGbAha
dYZgyXypnUkKiEtE4t1WqxCRvOJGy5nIqKQAhiYEhqVm6WB7HWizu2zDb40VMfh+
HTseseiS2AifR44U6QGQ3lux1gymO/nkNF+7J+G1oP9TT6lyh4GUpWVFvnbcZiE4
MjOJ2lqpPLOpIgvUxmHIMRw1qqO7Q/J+sRhq1w0f2DSSsCwgEyL5eTIZws0NIRVr
dVH2kEXNEgZyteSGy1PZNBlOH5PDndDhdJBicvWKZst7Fx4zF+T1WhXB8P+K836g
AnhADCZvtwA1kNvmdh+4FsukPQBGOw==
=GxQv
-----END PGP SIGNATURE-----

--fd6t/19JUNXN1Xbl--

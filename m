Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35560379974;
	Thu, 13 Aug 2026 15:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786636791; cv=none; b=E/0a3GZqIe9y91a0rYZV8dF0Ynoe9U+ZyoQfyJZGno9ALRqKe9rS2RqzfecR1I26TAjRwD/Rpk+YyZSnh14kdbqM93qNaPEPuoB9qjl450suq6Rd4YtCUia39lHowZxuTKaY4nXcKz6+lTcao3CqRppSHaXWydx7hR87KUYfhKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786636791; c=relaxed/simple;
	bh=rKdzEaB6WkyQKiaetuzxAeCyCkoIM5yLYJSw7iS6/8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OSHxIW3CPVUqchA7upzajG0Ys9uBXVAUDym9hy5+ICXXBl3ghiUdj0u+Op81XZGWrW3VZUdq04pcsNizq2DAbyVZqFbUzKU9/9VPcuLVO/+m0WT8NmmuA4LXbeXJ9Qw73J9Xd/3yA6923OryX0ezyCHWDavhEa6Dojw0o9HRHhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B8W4ndih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B8W4ndih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7211F000E9;
	Thu, 13 Aug 2026 15:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786636789;
	bh=cBLS0FUJYhQkT1zB8ZANDPYH4FFbqlmbBM7/T/YIqRo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B8W4ndihMue/+2EAWms1e0Bq8lI0vlF75HckH/GSe9oxI23AKQqPlBstT2kWvBw9y
	 hBqAAufqxC7EgH5vuASZmVMONVy706R1bXu1A8QxKhInkjp1iFpXZ7KGSr9V+1Orz6
	 6MmRehRlhUD2i+kBh3A9hF0YdnkJIf2PiJdIkQT/+BCB+AUYtBlv1mO20ZwZrr7pOp
	 00GbaYZlvDUQ6GwvlTVfSowHMntAHYRYOhvk/YGFs9PZUy5aGPaH3J+gcTYD5K8nio
	 wU3WujaHdwOV2tt+U0uk+ZAI285x0a2QQEvwY3e46Rcje7iZ5+g53pE7ZvwlyQZ2FS
	 tCrQNUQjv4gLA==
Date: Thu, 13 Aug 2026 16:59:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] KVM: arm64: Block ID register changes after we
 rely on the values
Message-ID: <81c8d950-2413-4d9e-961d-ae96ab10beb8@sirena.org.uk>
References: <20260803-kvm-arm64-idreg-final-v2-0-d7d7e4efc640@kernel.org>
 <20260803-kvm-arm64-idreg-final-v2-2-d7d7e4efc640@kernel.org>
 <8633wi1372.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="s0CQpxfWlxjP5lls"
Content-Disposition: inline
In-Reply-To: <8633wi1372.wl-maz@kernel.org>
X-Cookie: Immanuel doesn't pun, he Kant.


--s0CQpxfWlxjP5lls
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 13, 2026 at 03:54:09PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > Avoid these issues by adding a new flag that we set when we finalize the
> > system registers, blocking ID register changes after that has been set
> > even if something fails later on. Do this in kvm_vm_finalize_sys_regs(),

> We already have KVM_ARCH_FLAG_ID_REGS_INITIALIZED. Why do we need
> another flag for something that appears to be similar? Why can't we
> broaden the scope of the existing flag to cover the above?

That looked like it was for the other end of the process, where we set
up initial values, and that userspace should still be able to configure
values afterwards.  A combination of the naming of the flag and the fact
that it was introduced as part of the writable ID registers series[1]
but didn't block ID register writes made it seem like it was intentional
that userspace should be continue to be able to write to the registers
after the flag has been set.  I have to confess to being unclear what
the intent with that would be, but as this is ABI I was trying to err on
the side of minimal changes. =20

I would be unsurprised to learn that it's just an oversight, in which
case we should just use the same flag instead as you suggest.

[1] https://lore.kernel.org/r/20230609190054.1542113-7-oliver.upton@linux.d=
ev

--s0CQpxfWlxjP5lls
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmp96e8ACgkQJNaLcl1U
h9A80wgAha8llle9+QqQT+mJR2RuxsY6SQP/3Kj2ODe3Ammr9HvKe7VFlUnYcZf0
5oQVJfqxCR9Khm8XwlPTFbUnhRxNI2WHnwrIBoDULd1MK3EKjfpNNJrr9jOBS35a
XHX00r6VuPASZW5onDlxMgzEGQI0a0ngcUSUBH0YZcATe8BzpLBjTEhLAhhDBBrF
HNahJz6MNNtvPSoSyBe32zavOVQlSMaaY1YFoBxh0TGuym1Z9OH9n3p70mQBeN+T
9sIV0iJBdEjdPCcx75P+5P04cGp+XyjG3HE41FYAsqTZrKGsEAqUrk9NHqKBlomH
rzBBLk8MTWWmlEVKRz1p/gF2972u3g==
=uPvA
-----END PGP SIGNATURE-----

--s0CQpxfWlxjP5lls--

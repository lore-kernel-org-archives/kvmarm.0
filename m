Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDC228ED
	for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 14:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5F6C433EF;
	Mon, 12 Dec 2022 14:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670853826;
	bh=WMh5ZyXqeKJW6oTCT2wcbPgTDVWszL4kojbNn2ctuqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FQsF4LgWK7KrsWUfamqD3i2IiAmLYnZ2MXHPeVk5OHMI60FCtuenj5fxagQazZrOK
	 v3aylVLNh3G5IQdnvLOD15qS1qCOE6yYph3tULfHqQLwgApk8wp/9RVlQWLSrnDvUD
	 AYUrRyP8V2KnVdoWqzVYZZyga0Mc7pWXx1YOYFIcpaOPkVQHSlMA5tHhyxqqbiE9f2
	 jWt+ko46O3mmvD9eBz3MwZhrl2MYD24Ix19NfkkG3tshNgd7grWoAADyQBVD65TJ3/
	 k+0XJqFRW6kzHeLVLdzRChaC+2/AreDbrTb2Xw575kHWSCdGtfWrR62wdPvaMI3g32
	 E1JYQna5po/Mg==
Date: Mon, 12 Dec 2022 14:03:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 10/14] arm64/nmi: Manage masking for superpriority
 interrupts along with DAIF
Message-ID: <Y5c0tW7sidPE0oxd@sirena.org.uk>
References: <20221112151708.175147-1-broonie@kernel.org>
 <20221112151708.175147-11-broonie@kernel.org>
 <Y5IchpFrIB3y8575@lpieralisi>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uQvl9ZFcA5HnipCs"
Content-Disposition: inline
In-Reply-To: <Y5IchpFrIB3y8575@lpieralisi>
X-Cookie: It was Penguin lust... at its ugliest.


--uQvl9ZFcA5HnipCs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 08, 2022 at 06:19:02PM +0100, Lorenzo Pieralisi wrote:

> I think I found a nasty spot. We are currently not handling ALLINT in
> arch_local_irq_enable/disable(). The issue I am facing is that we might
> end up preempting in IRQ context with ALLINT set in the exception path
> - arm64_preempt_schedule_irq() - which means we are running with all
> IRQs masked (that's normal; what's not normal is that local_irq_enable()
> does not clear ALLINT, see below).

Right, and handling ALLINT in arch_local_irq_enable/disable() isn't
exactly ideal since it means that whenever we mask interrupts we also
mask NMIs which somewhat reduces the value.

> When we schedule (preempt_schedule_irq()) we do require a
> local_irq_enable() to enable IRQs; ALLINT is still set, so
> local_irq_enable() does not do what is expected so we are calling
> __schedule() with IRQs disabled, which does not seem right.

> Now we need to debate what the fix for this can be but nonetheless
> it is something to be addressed.

A first pass suggests that we should be handling this like we do for
other preemptions and returning early from arm64_preempt_schedule_irq()
if ALLINT is masked.  If we are handling a regular IRQ then ALLINT will
be unmasked and we'll call into preempt_schedule_irq(), if we're
handling a NMI then ALLINT will still be masked so we don't attempt to
schedule.  I've pushed out a change which does this but not yet properly
tested it.

> Clearing and setting ALLINT in arch_local_irq_enable()/disable()
> seems to solve the issue (now I moved on to debugging something
> else, will post the outcome here because this fix does not seem
> to fix the issue completely or I am hitting another bug).

Do you have any specifics on how you're seeing problems?  You did
mention boot stalls offline but I've not been able to to reproduce this
locally in a way that I can identify (based on your mail now I've made
sure I've got preemption enabled).

--uQvl9ZFcA5HnipCs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOXNLUACgkQJNaLcl1U
h9AoRgf/cIM0Mmm71guqPyvBr5Cs5le0aRw49I+IBB+L9+NAtVbjrvobckWkKXA3
vYKQ9WUh0fxZ88qgI+my5Ktw/sQj2AwBi3AiriQVzA3NfpjtAd91PJ3rQym8oudd
QyFnFLYOB9oYbNoyaX2rFHypCEQgX6T7tbVpRona/hYBwYKs/oXtUdEhP4OHTmhG
DdQB5TGYajLojqeY7m+JvrT59ahUC7SDi97g/KKxCZZyJBesVWfL6qTuhaRBbrC1
YFXTA4LVR8AAAwaEOa407LRbPGTyibr5ozYF79vTxy+BZIxRsCc9XL/ouTQUu3I4
XMF8t56fWIwPUVrcy3wCo1CQPAFfTw==
=wZjc
-----END PGP SIGNATURE-----

--uQvl9ZFcA5HnipCs--

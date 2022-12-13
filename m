Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219DA33E1
	for <kvmarm@lists.linux.dev>; Tue, 13 Dec 2022 13:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2229FC433A4;
	Tue, 13 Dec 2022 13:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670937310;
	bh=ny2LP1+qhbiF25Fg6TL6Uyqx2whwSG+lVJwxhXmWS7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kn5pl4xlY0nLg6Hvi6+456GuKAhO0saTMygWttz/RNLWKgC2uS5D96tIB2OtaoI4n
	 mss0b1HEtm/My1yvnX/IfpYo9N+ds240ctHFq6dFCYbm/xkCUg2u4V+qMbTh2NJwLL
	 YXOPX1tphUo0UOQMl4NQT/iP7w0s6Y8WIH1pwaHhSp7j8wFTjGdfWkDCcL/qJfkzR9
	 6CFDu3GQRcgW/94o1JfilkwECoyFafvoHO0ECxCkrmG2EsXkdzw4AvtgcR07NYktPf
	 NsHlq/piRcpRFFBOm02S4b3tNE7RbXafPr/RhBipTPx+h5rKvQysNNH2VgPm4kEfvt
	 dEiVraSIEEfTw==
Date: Tue, 13 Dec 2022 13:15:03 +0000
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
Message-ID: <Y5h617/poqLRQU8H@sirena.org.uk>
References: <20221112151708.175147-1-broonie@kernel.org>
 <20221112151708.175147-11-broonie@kernel.org>
 <Y5IchpFrIB3y8575@lpieralisi>
 <Y5c0tW7sidPE0oxd@sirena.org.uk>
 <Y5g55A3N9rXmS4LK@lpieralisi>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YwpPvNz3I82Uo82R"
Content-Disposition: inline
In-Reply-To: <Y5g55A3N9rXmS4LK@lpieralisi>
X-Cookie: Edwin Meese made me wear CORDOVANS!!


--YwpPvNz3I82Uo82R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 13, 2022 at 09:37:56AM +0100, Lorenzo Pieralisi wrote:
> On Mon, Dec 12, 2022 at 02:03:33PM +0000, Mark Brown wrote:

> > A first pass suggests that we should be handling this like we do for
> > other preemptions and returning early from arm64_preempt_schedule_irq()
> > if ALLINT is masked.  If we are handling a regular IRQ then ALLINT will
> > be unmasked and we'll call into preempt_schedule_irq(), if we're
> > handling a NMI then ALLINT will still be masked so we don't attempt to
> > schedule.  I've pushed out a change which does this but not yet properly
> > tested it.

> Yes that's what should happen (actually if we are handling an NMI we
> should not even get to the point where a decision about preemption is
> made el1_interrupt() just returns).

OK, great.  It would be good to understand where the preemption is
happening, I suspect you're hitting it from some place I'm not.  I did
verify that I'm seeing preemptions during boot, it just wasn't stalling
for me.

> > Do you have any specifics on how you're seeing problems?  You did
> > mention boot stalls offline but I've not been able to to reproduce this
> > locally in a way that I can identify (based on your mail now I've made
> > sure I've got preemption enabled).

> defconfig, barebone rootfs, boot stalls (because we are scheduling with
> IRQs off and there is nothing clearing ALLINT in the preemption path
> so system hangs).

> I don't know why you can't reproduce it don't know if it is the Kconfig
> or file system configuration (or the FVP params - for this to show up
> FEAT_NMI must obviously be enabled - I am testing the branch Marc posted
> so that I can test the vGIC patches but this is definitely not a vGIC
> bug).

It might be Marc's changes I guess, I didn't pull them in but I don't
see anything there that should be doing anything without running a guest
either...

--YwpPvNz3I82Uo82R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOYetcACgkQJNaLcl1U
h9AtMwf/eYU5UrTg4kHnD8mnqZdBmFV15qEcuNjgzqVn5TAo3qx3zN3hxRbMO9TP
uzvK7VzLns+JgsVJ/jNO1kcfsUqGLpBKGhHqNlDb/as7iN95QaRvQSHQTp35aOE4
/Nnzled+t1jjJ7fK5a9y9P921hAmc4BKxUlX5KuvkHaTAtJ8TCYjh2FTBQqnZU+R
X8uMZaqV91xkDcf4A+3Tx3MQC9KVieMpsQiyTwkOMKC6qJSZlStWrNLWXGk02oc+
vKN31vog+sB3Qw4zeEAp2wrqcYA/mEbWEOcJlaAGmDukv656s0wo5SBuaqy/6TiO
gw+OFTlReEsnFVCEOSS1SdUE570kUQ==
=zZ7z
-----END PGP SIGNATURE-----

--YwpPvNz3I82Uo82R--

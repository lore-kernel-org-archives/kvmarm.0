Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE158BF1
	for <kvmarm@lists.linux.dev>; Wed,  7 Dec 2022 19:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F24C433D6;
	Wed,  7 Dec 2022 19:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670440507;
	bh=pDzNFT6tT7LnrAu1EdvQo6usSywiQl00XzB086r7gaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SDzm2ImoGirc0zLmoKfwaTccXSfkR3iAuKTvNM6GY5OSjma0p3Qmxjw1Nwqe0KWKF
	 Hx6C8QUkwJn3u4xvaBD7za6qFpZEH4KO9D7l2kwMtmk/3bIaberd4v0ls3aJmZ8s7W
	 wyfFxkHaX9kBm6V3R2UqJe/Cywq63Dv2es2t1lvuqsWFHFbPDKi1rY6ZbminMvrJLA
	 lbK/o5q2jmdd/Qp10CC7a+6+R/1qzSefIYBMBoAFrtWRI0QS+ITP3W68TXm8pat6q6
	 iDgxWGkbPExXk+cZfsSy4TWvkonMsD3Q5NO/ORUFPKVTbbhn8MyMuiZty2nN9ybKJD
	 T3Lo1LQxWJXcw==
Date: Wed, 7 Dec 2022 19:15:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 12/14] arm64/nmi: Add handling of superpriority
 interrupts as NMIs
Message-ID: <Y5DmNVS6NTrN1Xit@sirena.org.uk>
References: <20221112151708.175147-1-broonie@kernel.org>
 <20221112151708.175147-13-broonie@kernel.org>
 <86k033lblt.wl-maz@kernel.org>
 <Y5CUA+yZDn5wqHQF@sirena.org.uk>
 <87zgbzrqhv.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="spnBxAOb49KKVpVU"
Content-Disposition: inline
In-Reply-To: <87zgbzrqhv.wl-maz@kernel.org>
X-Cookie: What!?  Me worry?


--spnBxAOb49KKVpVU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 07, 2022 at 06:57:32PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > Any CPU new enough to have FEAT_NMI is architecturally required to also
> > have FEAT_CSV2 since that's mandatory since v8.5 and FEAT_NMI is a v8.8
> > feature.  FEAT_CSV2 means the hardware doesn't need the mitigation, and

> "Hypothetically", CPUs that advertise CSV2 could subsequently be found
> to actually require extra handling, and I really wouldn't take such a
> bet.

> The reasoning by which CPU designers follow the ARM feature dependency
> rules doesn't hold any water either, and hasn't for years (ARM itself
> has been backporting features into CPUs that have a much older base
> architecture). You don't have to look very far to find implementations
> that cherry-pick whatever they want. The sad reality is that nobody
> gives a damn about this rule, and ultimately pick whatever they see
> fit.

My guess would be that the Spectre stuff is generally considered
sufficiently important that it'd also get mitigated but as you say you
never know.

> And given that this is only one static branch away, that the runtime
> cost is likely to be a big fat zero for non-affected platforms, for an
> event that is vanishingly rare anyway, I'd rather we stay consistent
> in the whole interrupt path and keep the mitigation code in.

Yeah, that's certainly a valid argument and I do tend to agree that it's
better defensive programming - like I said I was trying to thread a
needle between the two anticipated review reactions.  I'll hold off for
now in case anyone else has strong opinions in the other direction
though.

--spnBxAOb49KKVpVU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOQ5jQACgkQJNaLcl1U
h9Cdmgf/TW0sobzC06EWl+fhx2JcB9W0fqdbil4/6o/Kqr96QYbr2obTs4POWI7u
Bv1iizqor58kXjI5T+GgX/bcAZXpTtz3tV9LCFUgXWfL4Y/jzxMNRV4RNQbURhNi
stM4qd0iuis2rfDzeDCJGi431IyRi4Cuak7DBz89KhnHD3RwJsL7CdG31o1jCpKo
wk0ptUjXf9l8hLWcUCW0fHWygSQ6HKH1zIIKDuZAccItP3mcfKLutTsAQOgG/GAM
Ht11wRWCg+539DJuJxQnfYfEMZdNdsiJpBm0SZqRtjSiRnEynLEYEe5T6Bv+P7hh
GP/CvXyN1fcja9AtjAQWVRrSXmnV8w==
=C9a0
-----END PGP SIGNATURE-----

--spnBxAOb49KKVpVU--

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FA63FC2
	for <kvmarm@lists.linux.dev>; Mon, 14 Nov 2022 11:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C80BC433C1;
	Mon, 14 Nov 2022 11:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668425123;
	bh=E+z9SfAMFJTP2XUimAoePgFySxqR5kohHO4BJqd7v+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dMIHo1SBULrlr3qZlE5oMVAf+wG7FAsTmag+x7TEB6oaPCFo8WQmTRGgtQI1sPad/
	 q/62WuH+wq0iVkBPu+Hc3UobLeXJlx3tiz8yJcFob9/3wL2W/gWiQms23Y1Yey1n0L
	 gXM9koxwsEUFf3qjNHyGcpfeHqYPeSbn9fwd7AGhF3zeCnl22btKZSLRcpu87ksrgG
	 /qld9z76kk8b+GW7jbEO+bzule16pS5le5b5/LxIMwxJm6poMcGfwmSb2yAotW63Cw
	 CiEmiWDjgvnrl2rTzG9PiwEuduaBVRsed1icsLTvue6l37nspYGoy9xSd77uBiILQh
	 kfDoN2u86wJJA==
Date: Mon, 14 Nov 2022 11:25:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Zhang Lei <zhang.lei@jp.fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 7/8] arm64/sve: Leave SVE enabled on syscall if we
 don't context switch
Message-ID: <Y3IlonLu6MHlIzHm@sirena.org.uk>
References: <20221021230321.1159287-1-broonie@kernel.org>
 <20221021230321.1159287-8-broonie@kernel.org>
 <Y3IY9es/x1w8BZVL@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="idtGuAJArH1vq1lE"
Content-Disposition: inline
In-Reply-To: <Y3IY9es/x1w8BZVL@arm.com>
X-Cookie: Ego sum ens omnipotens.


--idtGuAJArH1vq1lE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 14, 2022 at 10:31:17AM +0000, Catalin Marinas wrote:
> On Sat, Oct 22, 2022 at 12:03:20AM +0100, Mark Brown wrote:

> > The syscall ABI says that the SVE register state not shared with FPSIMD
> > may not be preserved on syscall, and this is the only mechanism we have
> > in the ABI to stop tracking the extra SVE state for a process. Currently
> > we do this unconditionally by means of disabling SVE for the process on
> > syscall, causing userspace to take a trap to EL1 if it uses SVE again.
> > These extra traps result in a noticeable overhead for using SVE instead
> > of FPSIMD in some workloads, especially for simple syscalls where we can
> > return directly to userspace and would not otherwise need to update the
> > floating point registers. Tests with fp-pidbench show an approximately
> > 70% overhead on a range of implementations when SVE is in use - while
> > this is an extreme and entirely artificial benchmark it is clear that
> > there is some useful room for improvement here.

> If SVE is no longer in use, does the explicit SVE regs flushing cause
> any noticeable overhead? I guess even if there's a small overhead, it's
> only temporary until a context switch clears TIF_SVE again.

The overhead of the flushes is measurable, IIRC it was about 2-3%
on fp-pidbench for vector lengths 256 bit and above which have
additional overhead due to needing to flush the V/Z registers.
OTOH that's an entirely artificial benchmark and as you say soon
as the task gets context switched it'll stop incurring that
overhead.  Given that the improvement we get in the case where
the task is continuing to use SVE is more than an order of
magnitude greater it seems like a sensible tradeoff.

> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks.

--idtGuAJArH1vq1lE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmNyJZwACgkQJNaLcl1U
h9DVxQf7BLluHKiKQO7yf8EiDCpztS/5aKoR8DZCKRX4X9p1UmA6dahNqwvKElYu
dPy5VyuXlDTuSqU3SYIZ55qSF5alHQndN7t8tqujy9fmmeJ796hiV0twfEFllMPg
0zyv1GUXTaqn1W16KXj3g1+03Pc3UYWJSSBN00W8gcSjItJXg0zylXJJzhT2UEKk
49kZjRNRzwx71hfPsl2VggzpsLiEW00Dn37UNcY5rwoZnyUBNw+b6klxCX0kk+WX
myhmr8vxj5MlICPE7YIvajTFkhPt2cG8+u2Fmlmx2Q1XJUEK5bBnLaeHgc5CiPrS
8GSDmYbt0nsuEQrqXBx+7wX27pPZLw==
=omrS
-----END PGP SIGNATURE-----

--idtGuAJArH1vq1lE--

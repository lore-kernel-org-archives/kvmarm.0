Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32036403AF0;
	Mon, 24 Aug 2026 11:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787569925; cv=none; b=SyL4DuBG8TlP8QuPtSwvjLLA5PBzGUmfuZD4vQFNeaqjDXdO48rtoan+Awlw+b4R5r7xVvZZdJsNcKk5k2ywZUEZ7q8bw37CYopaFgKibrNIuCR7DRWblMMGKUkh4Wn7NzYN+YWSJoCYy1xvEwjEmANug0Ok7byTj8UEkw56kcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787569925; c=relaxed/simple;
	bh=m+morNN8RGBMipO5t+xTLWNLDa2XTQgVC0dfxL3TCxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VVps+ouzwKttoDxxj8Bpz9Yr9yUpOwUSs1nK4+1bCH5utMkx07moj4y4Uwk6DnwEnqkxU4pRievRlQAg+VX1OUz25oOr+VE10vX97fpKDdCxOlhTmg+ZVlc+vDYH5c8ix9QQxuwuSsxsJuKu4KITZcL8EbNFcuPtQtZIejVJtiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AMLFr5yZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AMLFr5yZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9641E1F000E9;
	Mon, 24 Aug 2026 11:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787569923;
	bh=mx+rPoWvI9AkDoOzj5LLsBB5vj6AWlJD0KdPs8BiNks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AMLFr5yZzIs0z67GZnwj0OMggnSxwjtK/svgoRHvLnZJLflICjZ7c2H/0ZLr8XRBQ
	 5peiDCre1Ou8Z17lQI6z7iqe4HP79Am7rOUrqCSkivt2tlw6V656d0fFf3inVa0ilc
	 LREZ5spgc8ePqqERgIM4DGL+XM8vLXJBlXG7T9t2XLYv3UCSLqOzHVPmG7Aab4KDho
	 pGz1SEWBqKdmf0x9ghpwGzEbRm5UTisGHBnqw+0ZmEMpGEaT2tebudhm35NtO/NbMN
	 dcCnvz2BRnKAmLUzV4NpD/iZKt0SLlKiWMhpo5BFzjprSZTMUVGSp89AAcFK1kRU3W
	 NSVohXySukHMw==
Date: Mon, 24 Aug 2026 12:11:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v19 06/14] KVM: arm64: Validate GCS exception lock when
 emulating ERET
Message-ID: <e0decd21-bd0e-4eab-aa94-b9e97e7b4d7d@sirena.org.uk>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
 <20260812-arm64-gcs-v19-6-9105afd828ac@kernel.org>
 <vdmz43ogvmwu4liilfqzdrgsf5v765bucl7mybhfdxj7yrywkd@5mssukdegdwg>
 <02b970b2-dbd9-490f-bfc0-be10708e0f9b@sirena.org.uk>
 <q3lxbu2palhkejnkvncs2iili6vvkcl7boftn4snf4fjy6fhvg@ehrwmqt6eh3m>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TdbCqlH/hxhqcRtu"
Content-Disposition: inline
In-Reply-To: <q3lxbu2palhkejnkvncs2iili6vvkcl7boftn4snf4fjy6fhvg@ehrwmqt6eh3m>
X-Cookie: Accuracy, n.:


--TdbCqlH/hxhqcRtu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 23, 2026 at 02:18:15PM +0100, Wei-Lin Chang wrote:
> On Fri, Aug 21, 2026 at 11:19:30PM +0100, Mark Brown wrote:

> > As the comment mentions it's not quite that - ELFromSPSR() in the
> > pseudocode has rather more going on in it that I'd managed to convince
> > myself wasn't relevant in this specific context.  I didn't want to give
> > it a name that would cause someone to think it did the full thing and
> > trip them up using it in a different context where those things do
> > matter.  I do agree that this results in awkward naming.

> Right sorry, I missed the pseudocode part. ELFromSPSR pseudocode is
> doing more than what its name indicates...

> If we want to stick with the pseudocode then what do you think about
> el_from_spsr_nocheck/el_from_spsr_raw?

Yeah, those names could help though given your other comment about this
not looking the same as the code in exception.c I ended up changing it
to this:

        /* Check the EL only, ignore thread mode */
        pstate = vcpu->arch.ctxt.regs.pstate;
        cur_mode = (pstate & PSR_MODE_MASK) | PSR_MODE_THREAD_BIT;
        target_mode = (spsr & PSR_MODE_MASK) | PSR_MODE_THREAD_BIT;

instead.

--TdbCqlH/hxhqcRtu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqMJv0ACgkQJNaLcl1U
h9CjOQf/QMmd6D+ASrY8SyYNHelRK0EJIwW4oBSv0gXC6TA0EC73stA7cfWcDeY6
U23YT5yN83tHNVoYDjoFrCutJf47NIZNcOJtQbUdTekGUcr5t/upVCOo2nrS5SJg
syjCHDN8fK+T/qD6u3qWQSbJAe/K5lr67Olv4W9Oxg+qwAiMvb14NtuSQWu+RLwk
hJpyPCK+UCYOB4XM3rEYX+6O2zkJa1SfhUHPdR+yGguBA7I4kAeimhpttufCkTTr
UDY/P7qmfzE5jrgnh/NFDKWxClVFO6Rh+N/S+Qre6cY9PVPT8G1A3n9HGPxYPzdd
n2Jqdfo3C3vbaigTCWrY2B4EwG8l5w==
=YW/9
-----END PGP SIGNATURE-----

--TdbCqlH/hxhqcRtu--

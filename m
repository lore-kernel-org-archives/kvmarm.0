Return-Path: <SRS0=7Ft5=OE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EDD1C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 14 Sep 2021 10:39:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0896E6112D
	for <kvmarm@archiver.kernel.org>; Tue, 14 Sep 2021 10:39:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0896E6112D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DD494B0F4;
	Tue, 14 Sep 2021 06:39:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W+5l1BSpersy; Tue, 14 Sep 2021 06:39:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2666C4B0B4;
	Tue, 14 Sep 2021 06:39:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DCCB4B0B4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 06:39:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dR2-ciapXHlM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Sep 2021 06:39:41 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 246C34B093
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 06:39:41 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91A826112D;
 Tue, 14 Sep 2021 10:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1631615980;
 bh=X/xWVryAoLR7F4gV0F2zY4/xYU1ChD2peTUfv0rUZc8=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=VMQ3Uy3nchC/bZwF0x8e+1q47nyPm+/I0t6LMEt3rojKp8ZMlO6cDZd58Ez/nsLGy
 2W283wCjSURRX5KHRrB57FdM1zweXDeu2ZpTXBKn2mjfUoeRqILe2drBy9HfF473Qu
 p4EGedimD4SrGl9ve13ObSIQD3uuVNldUU7VOcoLrwsvpgjNlDIM3YmTjvTSz35lII
 XondBEOe0/Vkvj6I3xQ/jcc+zdMCOQUAW2s1lj/KfASpqZ6j0mRspEuwkV8lkBzgOn
 VaF9l7MHrDaCGQK0NL3HK8j54cKDwork356wqYoMsfjNSh8QDQTmMITvMfQH30C9kB
 wbSqDa5qRu2kA==
Date: Tue, 14 Sep 2021 11:39:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v4 02/18] KVM: arm64: selftests: Add sysreg.h
Message-ID: <20210914103900.GC4434@sirena.org.uk>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-3-rananta@google.com>
 <20210909171755.GF5176@sirena.org.uk>
 <CAJHc60yJ6621=TezncgsMR+DdYxzXY1oF-QLeARwq8HowH6sVQ@mail.gmail.com>
 <20210910083011.GA4474@sirena.org.uk>
 <CAJHc60z0kLzrA3FfQeD0RFZE-PscnDsxxqkVwzcNFcCkf_FRPw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJHc60z0kLzrA3FfQeD0RFZE-PscnDsxxqkVwzcNFcCkf_FRPw@mail.gmail.com>
X-Cookie: This space intentionally left blank.
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5385409398145231002=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============5385409398145231002==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0vzXIDBeUiKkjNJl"
Content-Disposition: inline


--0vzXIDBeUiKkjNJl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 13, 2021 at 04:38:29PM -0700, Raghavendra Rao Ananta wrote:

> I was looking into this though and could only find some utilities such
> as tools/iio/, tools/spi/, and so on, which seem to create a symbolic
> link to the header present in the kernel (rather than copying). Is
> this what you were referring to?

TBH I'm not exactly aware of how it works, just that it does work - the
main case I was thinking of was the uapi headers, mainly when used in
kselftest.  Those look like they're actual copies rather than symlinks
so I guess it's a different mechanism to what's used by the other tools
you found.

--0vzXIDBeUiKkjNJl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmFAe8MACgkQJNaLcl1U
h9B44Af/SfJ+AN5Ix/ZXr/siuBNgcCpe3/mrChxg41mKS/t+k7AWSAqfnOD/iUcf
oZC0i22AAWeRNATEsToyHoax/Bqdr/HWpOSzajwbgP9Dn9rhvpJscPAxy4kq1Y78
hwa+3eHPhRfPx98ZiT5HFFVPtx2eg1wDiO4YkHGyDfEO8ChLMpylYJPI4IwIzU36
ZpT0Ked+cJvArWiX5JslxeGzHn+jJazjkO//PdltUMw6JnhNfHV3uXYfvMsmBOsd
yRAtlgPEah/p33l4ZmkTH7y0quM4XaWFmNOOH4yuMDn2dAr2+9cg2TRbL0jQzAVL
pqf78AH3B6XfTRQDQRSvHCkerk8o8w==
=R/0t
-----END PGP SIGNATURE-----

--0vzXIDBeUiKkjNJl--

--===============5385409398145231002==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============5385409398145231002==--

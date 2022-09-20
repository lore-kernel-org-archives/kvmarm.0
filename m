Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C09DAC6FA82
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 19:02:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EE6E4B492;
	Tue, 20 Sep 2022 15:02:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0mt8Z-SSoMkC; Tue, 20 Sep 2022 15:02:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 073234B651;
	Tue, 20 Sep 2022 15:02:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 332C94B492
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 15:02:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4E0N+1BDibJZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 15:02:22 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F00AF4B653
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 15:02:21 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id B5B12B81FCC;
 Tue, 20 Sep 2022 19:02:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64D3C433C1;
 Tue, 20 Sep 2022 19:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663700539;
 bh=e4RdzMbmqssDZj6YNrbYQr/MFBi9d/pz3WHxIb17d/4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=DYYp8CZ6fZTbp1OUc4dQcGD4HIhBC5tI23OV2Pbu2lDdq3p/ic/YGR8oXvGSZkIQO
 9bo9L6CVw27hhEQJSU+gvyvPRb024TXxPVTUr4kYA6ve/+xr0HEkIHg0yEYpxOvEHp
 ETSqxweO2l4oGBRfztdJhlNnxbj5D0tblNXH/P0fCt+j96xzKdaLHydexjwhWgUOKJ
 SAcplXnmGkJzAIiYRNQU1TP2dfeXnOAqO5laCibD5cVYryfdTgqZLWQCsDwWLdtGZJ
 ge9m/1NLNbRXP+shOvPEdenoFahJFvkDd6NBHGvEfq8lfZ9CkSXFvu8vhK/pb9oFBo
 IWfEJ7uWWTF5w==
Date: Tue, 20 Sep 2022 20:02:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 5/7] arm64/fpsimd: Load FP state based on recorded
 data type
Message-ID: <YyoON+yTX2yYSngN@sirena.org.uk>
References: <20220815225529.930315-1-broonie@kernel.org>
 <20220815225529.930315-6-broonie@kernel.org>
 <87tu51kiwi.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87tu51kiwi.wl-maz@kernel.org>
X-Cookie: One FISHWICH coming up!!
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Zhang Lei <zhang.lei@jp.fujitsu.com>, Andre Przywara <andre.przywara@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: multipart/mixed; boundary="===============3915298587665801850=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============3915298587665801850==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ZBbNE+TjxR42kj/A"
Content-Disposition: inline


--ZBbNE+TjxR42kj/A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 20, 2022 at 07:19:57PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > Now that we are recording the type of floating point register state we
> > are saving when we save it we can use that information when we load to
> > decide which register state is required and bring the TIF_SVE state into
> > sync with the loaded register state.

> Really, this sentence makes zero sense to me. Please at least add some
> punctuation, because the only words that spring to mind here are "DOES
> NOT COMPUTE".

I'll try to come up with something...

> > +		default:
> > +			/*
> > +			 * This should never happen, we should always
> > +			 * record what we saved when we save. We
> > +			 * always at least have the memory allocated
> > +			 * for FPSMID registers so try that and hope
> > +			 * for the best.
> > +			 */
> > +			WARN_ON_ONCE(1);
> > +			clear_thread_flag(TIF_SVE);
> > +			break;

> What makes it impossible for FP_STATE_TASK to reach this point? If
> that's indeed an impossible case, please document it.

That's what the "we should always record what we saved when we
saved" is doing, and the comment in the header about it not being
valid to record _TASK as a saved state.  When we write the
register state to memory we must always write either FPSIMD or
SVE register values depending on which registers we saved state
for.  _TASK is not a meaningful state for stored register values.

--ZBbNE+TjxR42kj/A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmMqDjYACgkQJNaLcl1U
h9D8cgf/bZDjZiHr0ERfKDZveO/P+wzd61PRV4G2z2t6N31UTQD0IjSKZC6lfCgi
Bxv/hPEe1nJPYflr7hrrSCilSsHrG837YiqC0UStJalElT8SBxuw2hXhhPh/K1J5
yW/WsWuaDkQ63mR0mXeRVkXDQA19gcao4LkMTUi5HaOnU02mRf9jPe0cHoS0ok/g
nH0G8Loz7PaXXOs5BRuFY/kqJW3r37eZigsmiyq6ToVqKEbmymBA2sS1LdnB9JK+
elVjv5S4aDK82mTIIWk/ohSGBBKZBxASLqjY3j8XxGB3pfEq+IhZeEModNWP2rQd
GqboXbQVqVzhO63/By8FCIANqe41UA==
=cELP
-----END PGP SIGNATURE-----

--ZBbNE+TjxR42kj/A--

--===============3915298587665801850==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============3915298587665801850==--

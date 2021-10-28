Return-Path: <SRS0=pYg6=PQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C4DC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 13:03:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 888ED60FC4
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 13:03:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 888ED60FC4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A35D4B153;
	Thu, 28 Oct 2021 09:03:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X+YGCVxqjz+b; Thu, 28 Oct 2021 09:02:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BEC84B162;
	Thu, 28 Oct 2021 09:02:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 084E14B10D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 09:02:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CZvVQV5D59yS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Oct 2021 09:02:56 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 451444B104
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 09:02:56 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F34960F02;
 Thu, 28 Oct 2021 13:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1635426175;
 bh=HS3bqWpOjF2gD6b9ws2zfTWy7XJxCId1PuTDK2PG8SQ=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=AAQ/6Gy8cTjxo00NXScYPV7aekKaW9wpGTKrOhUxLOyWoNk5aj4Ou3/1XYJ4aSkWz
 pV5U+1HsFarcxnzjYdZQTuEGgJ5uSG3tRR+B9jEEZDYBte3o7EydK7oTwrtMXtxxsv
 qUUcMPuvP36l6pkJY2Kj/0hFbhtE0NUtMebbnz6aVZAuJkAV9nzF7H5yGxrernMuXw
 sPLUkf6g/v0WDvaNTLqfhqsqyIOoFn9PE6OWASWLyeGq0z5s/FwLF/khqeBKr7eyiw
 Db3TxEmGH6es3BvbblqT5lAZa7Ml06xNZ7xUNQyKhnSluzHKcXgJcxUoZrIJrZX87y
 25LvV03aLK5bQ==
Date: Thu, 28 Oct 2021 14:02:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 2/5] KVM: arm64: Get rid of host SVE tracking/saving
Message-ID: <YXqfegqTu80ruUPP@sirena.org.uk>
References: <20211028111640.3663631-1-maz@kernel.org>
 <20211028111640.3663631-3-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211028111640.3663631-3-maz@kernel.org>
X-Cookie: try again
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Type: multipart/mixed; boundary="===============6426438814811146574=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============6426438814811146574==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="iTgLDb21f45sENgM"
Content-Disposition: inline


--iTgLDb21f45sENgM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 28, 2021 at 12:16:37PM +0100, Marc Zyngier wrote:
> The SVE host tracking in KVM is pretty involved. It relies on a
> set of flags tracking the ownership of the SVE register, as well
> as that of the EL0 access.

> It is also pretty scary: __hyp_sve_save_host() computes
> a thread_struct pointer and obtains a sve_state which gets directly
> accessed without further ado, even on nVHE. How can this even work?

> The answer to that is that it doesn't, and that this is mostly dead
> code. Closer examination shows that on executing a syscall, userspace
> loses its SVE state entirely. This is part of the ABI. Another
> thing to notice is that although the kernel provides helpers such as
> kernel_neon_begin()/end(), they only deal with the FP/NEON state,
> and not SVE.

> Given that you can only execute a guest as the result of a syscall,
> and that the kernel cannot use SVE by itself, it becomes pretty
> obvious that there is never any host SVE state to save, and that
> this code is only there to increase confusion.

Ah, this explains a lot and does in fact make life a lot easier, though
we're going to get some of the fun back for SME since the ABI does not
invalidate ZA on syscall.  That said there we have a register we can
check to see if the state is live rather than having to track what's
going on with TIF.  I've also currently got changes in the SME patch set
which do mean that we won't clear TIF_SVE on syscall entry while SME is
active, however I can rework that to fit in with this change easily
enough which given the simplifications introduced seems like it is
clearly the right thing to do so:

Reviewed-by: Mark Brown <broonie@kernel.org>

--iTgLDb21f45sENgM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmF6n3kACgkQJNaLcl1U
h9DsCQf9EFvV/AS5kqg1XCjZtSOxwVpUegl7BRhkzM0GAp+XZVvQhhe3+1WZ923E
7GFNl6LlJST3Ey6ZwpwpR956TJPk20on7q/v31194sRtikdoZhFsgRq55hDnD9vi
591aPeInRI5K61V83HJExubBHm24HHlE1t2nk7sJylWKfSP0qjeLeOvA6IABskJf
bsRDvysWc7KiuQKJUQ1BFW9RWGn4ItD0eawIQfG+iEFMjdr3rA0U500eFc+5DBa3
v31nrJA4a9aRnl2TgWozh+t7wzqkMcDZb06QvxhXDiNYKAqtcgVOq6Nkn10vbQYc
Zm2aPpB82LAyPzfPFjHgRb2cjuxL4w==
=Bf9h
-----END PGP SIGNATURE-----

--iTgLDb21f45sENgM--

--===============6426438814811146574==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6426438814811146574==--

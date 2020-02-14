Return-Path: <SRS0=Bd71=4C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C493C3B196
	for <kvmarm@archiver.kernel.org>; Fri, 14 Feb 2020 11:40:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 04EC7222C2
	for <kvmarm@archiver.kernel.org>; Fri, 14 Feb 2020 11:40:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04EC7222C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59BA74AD09;
	Fri, 14 Feb 2020 06:40:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N20sInOdGGiC; Fri, 14 Feb 2020 06:40:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F3114AC84;
	Fri, 14 Feb 2020 06:40:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F9DF4AC84
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Feb 2020 06:40:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sjhbNr0hh2S8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Feb 2020 06:40:29 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DD0D4A536
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Feb 2020 06:40:29 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 080AE1FB;
 Fri, 14 Feb 2020 03:40:29 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D94D3F68F;
 Fri, 14 Feb 2020 03:40:28 -0800 (PST)
Date: Fri, 14 Feb 2020 11:40:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] arm64: kvm: Annotate assembly using modern annoations
Message-ID: <20200214114027.GA4827@sirena.org.uk>
References: <20200213153820.32049-1-broonie@kernel.org>
 <b25323d02c76441ee12c206f07907383@kernel.org>
MIME-Version: 1.0
In-Reply-To: <b25323d02c76441ee12c206f07907383@kernel.org>
X-Cookie: Shipping not included.
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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
Content-Type: multipart/mixed; boundary="===============6487561418076175493=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============6487561418076175493==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 13, 2020 at 09:36:56PM +0000, Marc Zyngier wrote:
> On 2020-02-13 15:38, Mark Brown wrote:

> > -ENTRY(__kvm_call_hyp)
> > +SYM_FUNC_START(__kvm_call_hyp)

> I'm not convinced by this particular change. _kvm_call_hyp is called
> directly from
> C, and behaves almost like a normal function. What's the issue here?

I'm not sure I understand your comment here - this is annotated as
SYM_FUNC_ which is the annotation for things that look like normal
C functions.

> >  	.align	11
> > -ENTRY(__bp_harden_hyp_vecs_start)
> > +SYM_CODE_START_NOALIGN(__bp_harden_hyp_vecs)
> > +SYM_INNER_LABEL(__bp_harden_hyp_vecs_start, SYM_L_GLOBAL)

> Why isn't SYM_CODE_START_NOALIGN enough? And what is the rational for

The _start and _end labels that were there before are explicitly
referenced by code, removing them would break the build.

> the _NOALIGN, btw? I'd expect an alignment of 2kB to be more than enough.

So that the explicit .align above takes effect rather than anything the
macro decides to do, I'm trying to err on the side of caution here.

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl5GhycACgkQJNaLcl1U
h9BYiQf/UDA5Bn3eC2tVqBjo/2riAuZxuEKslb28fpoAHn0FoAs6efK1cvZbWC53
I8Gg8Db7FHtOOAajMvK3F1CR37bh08QcLzBpxnekSDyWxFuYmZ7Kj0VYMgM3U0NL
lWfu+GBH7CLALhWlvGEtFiT1/tJu2N5A/VBmWWj4Pgg4sX/8qK5Gfwp0tsEgIcFd
KY/d8w64tkqat/HmC6O04yWk/pD2X9uF2kHZrWunxQh9Il2uTkh9ATXwuY+u+Do5
aBZn70oRqmeKgCNZv7SZx53nEBpbY2IiqBs5nTgOEfEY62jgcu3eAWbLh6Xl4tqM
bca+Au8ZxyI9ALvFo5ZPVjS/5dxUTw==
=s9OP
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--

--===============6487561418076175493==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6487561418076175493==--

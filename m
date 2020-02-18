Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A90C34026
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 13:45:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 55CFA2173E
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 13:45:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55CFA2173E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93DD24AF16;
	Tue, 18 Feb 2020 08:45:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4xriZ0-bsC3S; Tue, 18 Feb 2020 08:45:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 848724AF3E;
	Tue, 18 Feb 2020 08:45:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 749EB4AF1F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 08:45:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uo-LYp61ZmFH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 08:45:52 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3ACAC4AF16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 08:45:52 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D2B21FB;
 Tue, 18 Feb 2020 05:45:51 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 93CAA3F6CF;
 Tue, 18 Feb 2020 05:45:50 -0800 (PST)
Date: Tue, 18 Feb 2020 13:45:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH] arm64: kvm: Modernize annotation for __bp_harden_hyp_vecs
Message-ID: <20200218134549.GG4232@sirena.org.uk>
References: <20200218124456.10615-1-broonie@kernel.org>
 <49f7de5f1d86e7edcc34edb55d5011be@kernel.org>
 <20200218130619.GE4232@sirena.org.uk>
 <20200218131436.GE20212@willie-the-truck>
MIME-Version: 1.0
In-Reply-To: <20200218131436.GE20212@willie-the-truck>
X-Cookie: No alcohol, dogs or horses.
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
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
Content-Type: multipart/mixed; boundary="===============2734428783482223438=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============2734428783482223438==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xjyYRNSh/RebjC6o"
Content-Disposition: inline


--xjyYRNSh/RebjC6o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2020 at 01:14:37PM +0000, Will Deacon wrote:
> On Tue, Feb 18, 2020 at 01:06:19PM +0000, Mark Brown wrote:

> > OK, I can do that for the KVM stuff - I've been actively trying to keep
> > the patches separate where there's no dependencies between them as it
> > avoids things getting caught up in review for more complicated stuff or
> > cases where someone decides they want extra cleanup while we're at it
> > which is especially useful when only some of the series is needed for
> > building on top of as is the case here.

> I get what you're saying, but I still it find it much easier to get a
> series of independent but functionally-related patches with a cover letter.
> I usually end up cherry-picking the ones that are ready to go, so then
> there's no need to respin those.

I see - I'd not seen that happening with the arch/arm64 stuff, more the
opposite, so I was working on that basis.

--xjyYRNSh/RebjC6o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl5L6owACgkQJNaLcl1U
h9BP8wf9ERM0KFYfeZGYds7VE6HIIEp0LpNTUPTZHOnKSFsozVEHdLLxG3JmxL7D
SWKHdAPHvPqeRNTzG1IiGQluuKtXTmtJQOfN+iOt3EVF9oUK58foxw35s5GyROQJ
9o/J/jLAKqpkXqKl0d0wIO8EdDqnwnkjHO/eJRWTPQS5RCSPPDBsC02Oag8jrA5y
lhBblLjm5B46hNl0iuFIA04emH7XFCI8vBG1KStDkeuLn8+2IxMa17//BjZPx7oT
IHZ0ZMujmSleMbBeDbAzPnvev82fDvpuMJI5PCIx//BSwt9FFdRMe4zUD7RZCDxu
6DcbCbwJ7x+tB/Sx+11kDPA+kjrPLA==
=uX0C
-----END PGP SIGNATURE-----

--xjyYRNSh/RebjC6o--

--===============2734428783482223438==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2734428783482223438==--

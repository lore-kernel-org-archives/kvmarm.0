Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E758C34026
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 13:29:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CFF52206F4
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 13:29:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFF52206F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E2204AF3B;
	Tue, 18 Feb 2020 08:29:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DKzwcm6CTD99; Tue, 18 Feb 2020 08:29:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1182B4AF2B;
	Tue, 18 Feb 2020 08:29:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4AC24AF25
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 08:29:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vnk+TyD7WwhE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 08:29:48 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCC684AF1D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 08:29:48 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E6EE1FB;
 Tue, 18 Feb 2020 05:29:48 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D6A4D3F703;
 Tue, 18 Feb 2020 05:29:47 -0800 (PST)
Date: Tue, 18 Feb 2020 13:29:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH] arm64: kvm: Modernize annotation for __bp_harden_hyp_vecs
Message-ID: <20200218132946.GF4232@sirena.org.uk>
References: <20200218124456.10615-1-broonie@kernel.org>
 <49f7de5f1d86e7edcc34edb55d5011be@kernel.org>
 <20200218130953.GD20212@willie-the-truck>
MIME-Version: 1.0
In-Reply-To: <20200218130953.GD20212@willie-the-truck>
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
Content-Type: multipart/mixed; boundary="===============5614570297848674981=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============5614570297848674981==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xaMk4Io5JJdpkLEb"
Content-Disposition: inline


--xaMk4Io5JJdpkLEb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2020 at 01:09:53PM +0000, Will Deacon wrote:
> On Tue, Feb 18, 2020 at 12:56:52PM +0000, Marc Zyngier wrote:
> > I'd really appreciate it if you could send these as a series, instead of
> > an isolated patch every other day.

> Same for the non-KVM parts, please :)

Ugh, right.  As one series or as different serieses for the different
trees that apply things (eg, KVM and crypto)?  The multi tree stuff
worries me.

> I *think* the current ones to track are:

Yes, apart from:

> [PATCH v6 00/11] arm64: Branch Target Identification support

The BTI stuff is unrelated at this point, the annotations are only
needed for in kernel BTI which I've not posted yet, it also depends on
the in kernel pointer authentication stuff so I was waiting for that to
settle down before I finish off the in kernel bits and post them.
Pulling it into the series with the asm stuff would result in a very big
series with an absurdly large CC list which doesn't seem helpful.

--xaMk4Io5JJdpkLEb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl5L5skACgkQJNaLcl1U
h9A0+wf9FFahSW1aXRWX6QOqWWehnMMCBtHBkDLgY+JP3PYifs+16nrVLf7SgS1k
vRtZX3P9E1utLkdlT+Cm7OLrZ1lOaFzRO/GZRbmrAkjU9u/77UGrWjJtuD/hGT1B
K2pozKaQvNN3qyWfGxZeASiPWCeWF0LDKkG9i4xHUlKNpkvfmrJGGXFqUiZ/cr/X
ePL2BDA1ZUtTOoK7z/eE3e7ffessqk71dTYIczOWRDPVDSWQEG/7y+dD0aze+SA5
Uwpni4LzpnTM1JuTSo6cKzZ5AUqmXGofsGtd1W8kT5nVjoWhx1iYcchTtv63kYF8
o5yBVA/vK66i7TIOtqP2AnZHvI735Q==
=1hZh
-----END PGP SIGNATURE-----

--xaMk4Io5JJdpkLEb--

--===============5614570297848674981==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============5614570297848674981==--

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 022D5C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jun 2022 09:14:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 849984B272;
	Fri,  3 Jun 2022 05:14:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mrHMDQbAjyYz; Fri,  3 Jun 2022 05:14:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FC704B21A;
	Fri,  3 Jun 2022 05:14:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7430C4B21A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jun 2022 05:14:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MW5SgJMcGeQS for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jun 2022 05:14:15 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 70BB04B0B6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jun 2022 05:14:15 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 5EE6D618A6;
 Fri,  3 Jun 2022 09:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFA5C385A9;
 Fri,  3 Jun 2022 09:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654247653;
 bh=4iuDbJF2TwkFPPuM8NAW+pNui4kNwDghbT0ZtFlrIoo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=IadcjXgN2S8TgWWHwoYa0dtkT3cmgLdPmTvmlOMNv3gTXLIiT7Di5I9cBgsix7/1y
 R9JIIdE+VNCULWo8pkHEGJxPTwEpq0DLwnojTyWZqSsj3nupP377Y6rS/kp6gxxtse
 ts4APAk3ft5mjGlJqRPjcnsm2vpjhYkUTbFEgluln/vknywi+LMZzJJLrJfUjYSFqc
 /xs+iXMZKMlKMYPHkrhZ4E9xdtSqdcfaPLFkDAwIVqWqd/K68xevhAZt9ZgyZwzW53
 ieVQWZB6tJluCjXE3EHtZxb0N2j4SfEH4V0bcqxQc8CjbT5iMrNFUBY3XJT9srbWlY
 hij98GFpZCe6A==
Date: Fri, 3 Jun 2022 11:14:11 +0200
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 04/18] KVM: arm64: Move FP state ownership from flag to a
 tristate
Message-ID: <YpnQ43WaGH96MxyY@sirena.org.uk>
References: <20220528113829.1043361-1-maz@kernel.org>
 <20220528113829.1043361-5-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20220528113829.1043361-5-maz@kernel.org>
X-Cookie: May your camel be as swift as the wind.
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
Content-Type: multipart/mixed; boundary="===============2822050534180743877=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============2822050534180743877==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cd3Wn50AMs8p39su"
Content-Disposition: inline


--cd3Wn50AMs8p39su
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 28, 2022 at 12:38:14PM +0100, Marc Zyngier wrote:

> As it turns out, this isn't really a good match for flags, and
> we'd be better off if this was a simpler tristate, each state
> having a name that actually reflect the state:
>=20
> - FP_STATE_CLEAN
> - FP_STATE_HOST_DIRTY
> - FP_STATE_GUEST_DIRTY

I had to think a bit more than I liked about the _DIRTY in the
names of the host and guest flags, but that's really just
bikeshedding and not a meaningful issue.

Reviewed-by: Mark Brown <broonie@kernel.org>

--cd3Wn50AMs8p39su
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKZ0OIACgkQJNaLcl1U
h9Cdugf+Myti+VeYZN6D7RQ33L8t8tcj56eKqSK77fyOPsgjiMWKaCavzpRJWlBI
r2+yl/Wof+1erS6BJIVjItrz/37KiGdseN1W0cq48lubZkokkYR95NdJmtWcftTx
G4ZHPVkRT8PaLB/bnNXI0vFgUWuE/WpzJ+09QCu9DXIo79IP9num7T66O53/cMBZ
FUs0Iui5Z8qaV6QKDPgYYDFVFHSqdJxZlJpJroKbZxvJklf1HJ7jqRp3Gwex1+XT
lw01XQ+XNsarPtO0HUmaaVUfy/FSSNmrS0CI9+CMZ4DfkYQQvGEZ0XpHaSfhQ+7Z
ufNvIKzvmt5ZMl9jrr8BOkFMe40YUQ==
=c9Pn
-----END PGP SIGNATURE-----

--cd3Wn50AMs8p39su--

--===============2822050534180743877==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2822050534180743877==--

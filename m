Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C20C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 30 May 2022 14:51:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBD0B4B178;
	Mon, 30 May 2022 10:51:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FRbWyIA27ujP; Mon, 30 May 2022 10:51:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2CCA4B192;
	Mon, 30 May 2022 10:51:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF6B94B178
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 May 2022 10:51:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JxQRLzWCXbZX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 May 2022 10:51:29 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E3C554B19F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 May 2022 10:51:29 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id D7B9C60F47;
 Mon, 30 May 2022 14:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE87DC3411E;
 Mon, 30 May 2022 14:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1653922288;
 bh=zIS303ND/ipmUxzUl0cjT6WILUpauYfW4NIWc/vz/oo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=d96MfobovSzVRjGjNOhCLFB3kwhwzT9duEtP6BfpsqNOx6Dlsw7TL9p8OynqPl1xx
 tZKJt5XBiPYT7FhnT15yJHRl+crOFznGvfjbA5bV168fGTK6O9R0fR0oV9o84wOZFK
 RL7W/9N7rGmrgYPw1m8mM0DiBLrHw045eorTvRl2uKfaa6+pe5aoDFVZwGkhMvCU6U
 rtG+RwDDUd8fjuUHP3oP3mnXmYwYM1Pc2C4ROTu4rxRrPMS+pQBqcJtynGnkBSMxo+
 L1InQ8FcyYzr3egtS/KL6QGm7PZMpG8mb9UEbo6Vb2IQxP8sBke6IVpuoSsDc638WT
 NW+1mUzJwx7dQ==
Date: Mon, 30 May 2022 16:51:25 +0200
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 02/18] KVM: arm64: Always start with clearing SME flag on
 load
Message-ID: <YpTZ7btyYNOidHmO@sirena.org.uk>
References: <20220528113829.1043361-1-maz@kernel.org>
 <20220528113829.1043361-3-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20220528113829.1043361-3-maz@kernel.org>
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
Content-Type: multipart/mixed; boundary="===============6380787444174705675=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============6380787444174705675==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="09dlo0gX1RQg6igT"
Content-Disposition: inline


--09dlo0gX1RQg6igT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 28, 2022 at 12:38:12PM +0100, Marc Zyngier wrote:
> On each vcpu load, we set the KVM_ARM64_HOST_SME_ENABLED
> flag if SVE is enabled for EL0 on the host. This is used to
> restore the correct state on vpcu put.

s/SVE/SME/

but otherwise

Reviwed-by: Mark Brown <broonie@kernel.org>

--09dlo0gX1RQg6igT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKU2ewACgkQJNaLcl1U
h9CsOAf/ch7hbdVBEYHqj9l2Bu7hPD45KvDptN/N2xZb8fzBVzmvvY+hO36KHUUJ
Wpdw3LosZwyeVxuDAKFeJRPZm/KeiNTS8eD51W6ZjeL4gDXLY1i0WFpDIr4Ue74b
mrElUFTjjrxgBQDSL2nwY9+dgwYxrKAM7697ortKfcU1aUUg9NfoOTagFwzFy0pn
P4ylovcmwFO9OWVhk9gXJwcaAi/4NttFQHrgMUkXyn9CTPLP3XzMeRxn6v+KBHCK
sbdXlECu/fK7NEkHylhE5IPKfZRqAgn4TydtOM5LseTeiLbasOPqWWF0sRRnfOjC
+o+/WxGkZCXXwQR8mhH/TR9JEOdfDA==
=SNHP
-----END PGP SIGNATURE-----

--09dlo0gX1RQg6igT--

--===============6380787444174705675==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6380787444174705675==--

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E06FC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  1 Dec 2021 12:56:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B52D54B20B;
	Wed,  1 Dec 2021 07:56:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6SgUlj2QqJNp; Wed,  1 Dec 2021 07:56:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CC904B200;
	Wed,  1 Dec 2021 07:56:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0899C4B1A9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 07:56:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LxPVwK6NphYe for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 07:56:52 -0500 (EST)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C83584B19A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 07:56:51 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id CB962CE1E64;
 Wed,  1 Dec 2021 12:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC8AC53FCC;
 Wed,  1 Dec 2021 12:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638363402;
 bh=cnf6mfxlAvT1EOVOQLzydeQXHEFrZLvejOYfDA/BBzU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=SimVJWW+qLh2pH2sPCh8qp7C4Lli3mx0D3w0p0GxOWg1GIAmJeGsCk/iF7IHk+0mq
 aqb+L0EpbrdzsL9y9BnjWt7rPEkaxIiaFKMLVfTWuge4JfxPJAZhwppYtddXYqlItd
 hcVRET9aiMMfOO3Y+DbpOHdjtXSTBSlKtXJkxtW7Z1yO2VKaRCfTTxfOdt80KepEtZ
 o6tFVxquQg3hUs6eQC7M2VU7x+SI7Ep08kGerYaOsDXvX0/GsCf1hwCZi63kmTzENM
 YSH8l0NN5vmOxQF/u5ypaiAw8K3CVn96fhRKR8DIgxQT6WExXyp+E60Rl102SPev/K
 rVbFWP8HfXXpg==
Date: Wed, 1 Dec 2021 12:56:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 3/6] KVM: arm64: Remove unused __sve_save_state
Message-ID: <YadxBLbaSxkBuqaF@sirena.org.uk>
References: <20211201120436.389756-1-maz@kernel.org>
 <20211201120436.389756-4-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211201120436.389756-4-maz@kernel.org>
X-Cookie: All true wisdom is found on T-shirts.
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
Content-Type: multipart/mixed; boundary="===============6713360584470576358=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============6713360584470576358==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="SujizcpWR574KISM"
Content-Disposition: inline


--SujizcpWR574KISM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 01, 2021 at 12:04:33PM +0000, Marc Zyngier wrote:
> Now that we don't have any users left for __sve_save_state, remove
> it altogether. Should we ever need to save the SVE state from the
> hypervisor again, we can always re-introduce it.

Reviwed-by: Mark Brown <broonie@kernel.org>

--SujizcpWR574KISM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmGncQMACgkQJNaLcl1U
h9CaowgAgKZUZSBDBwrJAF4oArHVKzIxedIFVD0xv22xdR4NfTcy2Dmv3sbM08Va
41yJc4LOvrd51ybnaFI6zrhSBk/TKUR+/ayCmKnR/lgchfIdipAyDTYWsR+KXuF3
TUpo6HlxvvDkYf5VkoM1cBz1l8AX6ooLrT9e0Ndc2FUmBKkpVZS69FasbEw8Odzj
vzkjUe+ThdgHV1K4lwHZX1vzf78A6XTAE8eqTjM2oF+6XIBGBR0ZKvPGQ6SHij47
29oGnpXpg9M2v+1hHlffr3oT0XWdelA58Bh1TJifF3fdIOMX1Ys3IkhAVtIJcezT
HD7ctSuEw7HGwOKl/OYsku062y9QRA==
=0x81
-----END PGP SIGNATURE-----

--SujizcpWR574KISM--

--===============6713360584470576358==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6713360584470576358==--

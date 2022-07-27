Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C06BC04A68
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jul 2022 17:32:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 017D54C9D5;
	Wed, 27 Jul 2022 13:32:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xmHaK3CZ3iKN; Wed, 27 Jul 2022 13:32:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F12844CA1A;
	Wed, 27 Jul 2022 13:32:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E212B4CA17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 13:32:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N0JBpDrg5tS1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jul 2022 13:32:40 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE3164C9D5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 13:32:40 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 36048B821E9;
 Wed, 27 Jul 2022 17:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F3AC433C1;
 Wed, 27 Jul 2022 17:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1658943157;
 bh=q47QgoXCm1d+pbl6jIqi2IRTu7bwzcZuMzbuDfSeIRo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=tHtY/iIkrpMF/Uv7EFlWhixNyJBu2K9QHZz+9n431yeiYJNvpwKwRYlHpssWbZTyd
 uxBnpxL5+VyORGuHopD8TijpL+aGXyD5fr7vA70GrSIaqxk13toS5uVO6o4oFWz1H0
 uYPGNYIknDmwI/NqDN5EJWxhQ3Cog3q4g7/4huHVtFTz5oteRS0TDLasiwCrYjRtK9
 SiNFVXeY5rgS+aUBiR0YdOx4K5osShIlptdmg2gztTLWCXUERRa/eh+ScC7bMsZnpa
 7VG5knWzWxZEi0H5CJrmOH0CIPw294RLxCYc4AjP1UOtmoAUQoPPyFGuSshJacgG5Y
 V052/lig31PCA==
Date: Wed, 27 Jul 2022 18:32:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 3/6] KVM: arm64: Make unwind()/on_accessible_stack()
 per-unwinder functions
Message-ID: <YuF2rfXvhPM60GkC@sirena.org.uk>
References: <20220726073750.3219117-18-kaleshsingh@google.com>
 <20220727142906.1856759-1-maz@kernel.org>
 <20220727142906.1856759-4-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20220727142906.1856759-4-maz@kernel.org>
X-Cookie: No motorized vehicles allowed.
Cc: wangkefeng.wang@huawei.com, kvm@vger.kernel.org, catalin.marinas@arm.com,
 ast@kernel.org, vincenzo.frascino@arm.com, kvmarm@lists.cs.columbia.edu,
 madvenka@linux.microsoft.com, kernel-team@android.com, elver@google.com,
 linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com,
 mhiramat@kernel.org
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
Content-Type: multipart/mixed; boundary="===============0974867909078320838=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============0974867909078320838==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hbdw/Jodnr/WTir2"
Content-Disposition: inline


--hbdw/Jodnr/WTir2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 27, 2022 at 03:29:03PM +0100, Marc Zyngier wrote:
> Having multiple versions of on_accessible_stack() (one per unwinder)
> makes it very hard to reason about what is used where due to the
> complexity of the various includes, the forward declarations, and
> the reliance on everything being 'inline'.
>=20
> Instead, move the code back where it should be. Each unwinder
> implements:
>=20
> - on_accessible_stack() as well as the helpers it depends on,
>=20
> - unwind()/unwind_next(), as they pass on_accessible_stack as
>   a parameter to unwind_next_common() (which is the only common
>   code here)

Reviewed-by: Mark Brown <broonie@kernel.org>

It feels like more of the accessibility stuff *should* be sharable, but
yeah.

--hbdw/Jodnr/WTir2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmLhdqwACgkQJNaLcl1U
h9Drtwf+K7Q5M0yDprpbWSTZ0Syqie6HYKfELQLgEhMb2bOBWuV0OqB/qxlHp4IA
gjP6FYZ1zifSN71xa4FkRiDDSFVEoJt7nCGUMZ9pI7OtRBS2kfYpADm4PqNgPehO
0Jc/GLnGVpjElbcT5GWIw4u+B5/MiV5WHXg+Oh9cc+XsJ0IDkUQEzEYe6r8fjJ4Y
a9bkkJkJDPXbzsWjQyOEwaJb180/oNnZ11M82yKceTA04WVX0kkE07wi8mcu+3zj
uX3ZmhBEBzzorRIFsDbWr/ae/gNZD8+m8HVilhX4XguihkQVJSa4eUKinsEok0ck
fNLlqdAjhoFixn0YXu7iJAIq1OaZEg==
=ejhR
-----END PGP SIGNATURE-----

--hbdw/Jodnr/WTir2--

--===============0974867909078320838==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============0974867909078320838==--

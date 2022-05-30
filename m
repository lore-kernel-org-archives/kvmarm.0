Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC29C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 30 May 2022 14:42:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB6BD4B346;
	Mon, 30 May 2022 10:42:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UzcaBGjAV0Li; Mon, 30 May 2022 10:42:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98EEF49EE3;
	Mon, 30 May 2022 10:42:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA12F49EE3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 May 2022 10:41:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eB1ZXd3Gc3qn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 May 2022 10:41:58 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9CC0949EB4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 May 2022 10:41:58 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id C553760F47;
 Mon, 30 May 2022 14:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CCEC385B8;
 Mon, 30 May 2022 14:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1653921717;
 bh=8abrn0+fyaPOA35f7xmWZpHOHqa414fCZZbKmkVupjM=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=pqwLJQyttHeCPer1sfDH0foSp8e/arMMnFrMmAru9XrZ6jm7g/ajrEcIvpf4/sGG8
 j+mEfsV8h2gk7WZptLWACzxOAyIyN2p8t5LHZluCv/mpLj+mKbccprao57jsNMQgcn
 FKnAHaVnVyGHF05wiz5jDb2dm4jpMxLWhZX4mwr8OjIXrsErRQIZobH/VG6z6E33sl
 eSFuyCLMbqKiHRCj5NUnbmS7KTlV9tKcZqIlEKX2ldQ9IEAo8XtAivLXb7Uzn19oUF
 7gL9/wR8KRd9D24wVXGUQLmuu7LICcpmWXyk7qDp+lD3dUMcZkhyXK1y3YoUuHEYi5
 gurOAs1LGl21w==
Date: Mon, 30 May 2022 16:41:54 +0200
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 01/18] KVM: arm64: Always start with clearing SVE flag on
 load
Message-ID: <YpTXsgd1MPpJEjUJ@sirena.org.uk>
References: <20220528113829.1043361-1-maz@kernel.org>
 <20220528113829.1043361-2-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20220528113829.1043361-2-maz@kernel.org>
X-Cookie: May your camel be as swift as the wind.
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Type: multipart/mixed; boundary="===============8282362885616285232=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============8282362885616285232==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ttQtBwibfUEMVFH9"
Content-Disposition: inline


--ttQtBwibfUEMVFH9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 28, 2022 at 12:38:11PM +0100, Marc Zyngier wrote:
> On each vcpu load, we set the KVM_ARM64_HOST_SVE_ENABLED
> flag if SVE is enabled for EL0 on the host. This is used to restore
> the correct state on vpcu put.
>=20
> However, it appears that nothing ever clears this flag. Once
> set, it will stick until the vcpu is destroyed, which has the
> potential to spuriously enable SVE for userspace.

Oh dear.

Reviewed-by: Mark Brown <broonie@kernel.org>

> We probably never saw the issue because no VMM uses SVE, but
> that's still pretty bad. Unconditionally clearing the flag
> on vcpu load addresses the issue.

Unless I'm missing something since we currently always disable
SVE on syscall even if the VMM were using SVE for some reason
(SVE memcpy()?) we should already have disabled SVE for EL0 in
sve_user_discard() during kernel entry so EL0 access to SVE
should be disabled in the system register by the time we get
here.

--ttQtBwibfUEMVFH9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKU17EACgkQJNaLcl1U
h9Bxzgf/W2VmJBtB0a4vcrBCgfX7ollA3ex5VNB6egRZO8MINJrGPpI+Jv5J21sA
1ouYS/mgLxtq0X8ACQX1wcCv4SHFzZ+fOj0D7PM85BvUxWWF4AYlyjZ9dfpx0t4X
BQykcxau0Ep3Gj27LAkCQxvAe/X5QEuymskYptEMrIigKy2Af+LwdwJNy03Pw/M7
BJBGRk6DKpX9GBCnNx/zVjAp3wkpW50q67c2S+A35z2VzD5Fpk7zQWtwQGCp+X/D
/UZr74rJl6izdLI+ycIFUr41Lq95C7cl4/mHC1h4S9i9ceklOthnl1BgxOY0c/FT
zsZnSWRL7SBHTEnNr46EjfpsiId3Cg==
=aTTw
-----END PGP SIGNATURE-----

--ttQtBwibfUEMVFH9--

--===============8282362885616285232==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8282362885616285232==--

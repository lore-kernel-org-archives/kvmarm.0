Return-Path: <SRS0=/McF=PJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD34C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 21 Oct 2021 15:57:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C661A61056
	for <kvmarm@archiver.kernel.org>; Thu, 21 Oct 2021 15:57:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C661A61056
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67DDC4B08B;
	Thu, 21 Oct 2021 11:57:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ixw3faF7pUa5; Thu, 21 Oct 2021 11:57:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C19A4B165;
	Thu, 21 Oct 2021 11:57:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A4D74B08B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Oct 2021 11:57:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KicUDiad08vB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Oct 2021 11:57:19 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D90634A7FD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Oct 2021 11:57:18 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B91A61056;
 Thu, 21 Oct 2021 15:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1634831837;
 bh=thJx0ql4zsrQ3ldjl2tC3lMokz2U/gzzD30/9U8kz/c=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=HONkM9N7y+63m80uXk6oJMy3DWWv8D4t1Lj0tv5+bqUpIvORBrFvWI6agd8TPeZIq
 BPs9tFFTDlZDwYoS7fgpy2qfPHofu9XIATLjdjSoVlij85MvHlNSrusXefBsGbinzL
 QbevuOpdSqt4VgorJOMj4Gfieou5bPNuLAi40y1JlEA0lKiiHPZ5P0qJw0rz2Q7NNL
 y9R0azVeYjwaBgWqoKDgPMMQhcliuiXg5n5O43XMlvgLy1GxPNZvkBq/dUsfjq0TSx
 4Qx4bjUufFxriAPvdFnpFesnNwu/ZrhLjNs505mSZOanWw9DM+T5jVYN9EsQGonI7/
 K0NdgguyUzn/w==
Date: Thu, 21 Oct 2021 16:57:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 4/4] arm64/fpsimd: Document the use of
 TIF_FOREIGN_FPSTATE by KVM
Message-ID: <YXGN26tHnRyWkWns@sirena.org.uk>
References: <20211021151124.3098113-1-maz@kernel.org>
 <20211021151124.3098113-5-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211021151124.3098113-5-maz@kernel.org>
X-Cookie: I program, therefore I am.
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
Content-Type: multipart/mixed; boundary="===============0330782139320405102=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============0330782139320405102==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IeDufIOZPw7Arkzk"
Content-Disposition: inline


--IeDufIOZPw7Arkzk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 21, 2021 at 04:11:24PM +0100, Marc Zyngier wrote:
> The bit of documentation that talks about TIF_FOREIGN_FPSTATE
> does not mention the ungodly tricks that KVM plays with this flag.
>=20
> Try and document this for the posterity.

Yes, more documentation here would definitely be helpful - it's pretty
hard to follow what KVM is doing here.

>   * CPU currently contain the most recent userland FPSIMD state of the cu=
rrent
> - * task.
> + * task *or* the state of the corresponding KVM vcpu if userspace is beh=
aving
> + * as a VMM and that the vcpu has used FP during its last run. In the la=
tter
> + * case, KVM will set TIF_FOREIGN_FPSTATE on kvm_vcpu_put(). For all int=
ents
> + * and purposes, the vcpu FP state is treated identically to userspace's.

I'm not able to find a kvm_vcpu_put() function in upstream, just
kvm_cpu_put_sysregs_vhe().  There's kvm_arch_vcpu_put() which is called
=66rom the vcpu_put() function in generic KVM code but they don't show up
until you start mangling the name in that comment.  It'd be good to
mention what vcpu_put() is actually doing and a bit more about the
general model, KVM is behaving differently here AFAICT in that it flags
the current state as invalid when it saves the context to memory rather
than when an event happens that requires that the context be reloaded.
There's no problem there but it's a bit surprising due the difference
and worth highlighting.

I think I'd also be inclined to restructure this to foreground the fact
that it's the state of the current task but that task may be a VMM.  So
something more like

	...contain the most recent FPSIMD state of the current userspace
	task.  If the task is behaving as a VMM then this will be
	managed by KVM which will...

making it a bit easier to follow (assuming my understanding of what's
going on is correct, if not then I guess something else needs
clarifying!).

--IeDufIOZPw7Arkzk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmFxjdoACgkQJNaLcl1U
h9A4wgf/dZ00LwDAdKbmHEpnXv8/wNofkka0/fogNjInmTdPmd23jPG2rP3KZ/yC
t7YubXwU8NRBAlxIG7570hCwq5PuOfaw3DYpb+vzrkgJaHuM4OUFlsUqZj2PqZDX
4cPa+zOkdR4bPABHHKkvMArt8CgfF20qeV+MjJTyksG8GNhpaLC+xbQMFzSTxx/8
j4CK8DtfI12HzqH6VP29HkXjZJhjc+y+goTCJdm+IK91wkdG/bcDaz5hauC9rjsO
77FcO+oedQsdOdsxxUZZ+4zQ0w8htwq62JF+gorJyDZLdSY85hT9B9+zPXTRcWZm
0zmnxUJCvu9ggcIxpllmZ1vjqjbn/A==
=mdJ2
-----END PGP SIGNATURE-----

--IeDufIOZPw7Arkzk--

--===============0330782139320405102==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============0330782139320405102==--

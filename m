Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 402ADC00140
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 14:34:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 901994C5EE;
	Tue, 26 Jul 2022 10:34:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id beg6XHajjB8d; Tue, 26 Jul 2022 10:34:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BC804C6A3;
	Tue, 26 Jul 2022 10:34:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 926424C5F9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 10:34:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a5EheeBnTe7J for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 10:34:14 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 80A5E4C5EE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 10:34:14 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 2714AB81651;
 Tue, 26 Jul 2022 14:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF61C433C1;
 Tue, 26 Jul 2022 14:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1658846051;
 bh=p2tvdR/m+sxzsLxs5/qItkjzVJ2I3yM1XR+mYnyc0Ug=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Hs411YusHafoixLqrOgQ8ZHvLCB304wjjhSD+OqtW2UZ6ekEV6fP6SoDMENpF13e1
 Z8um+b+iJadQi6/xEdDV8LIiuvPt5ooPNH9j9UCo1TmU/rbMltHejT+UWgmsofeikE
 CVnSy5XhQ342WdJZW0pnVTOYWV6/gzWMm3pP3PjNM46ChyQ+JVjvTUC23v5/LcfnYa
 p3C1M2HeqUG3Te7u1Bqn5cs8SGVEFQQvyLrsGDCX8xqxAnSR39bqvknotpyymfO11w
 6eZ+4wHjrqkzc7O+gmoRh8svTz1Gt7xvKgd5EZrZ+kfaBiSY2DkvGyxYlrtkzYNiEQ
 vge4MqDJq39WA==
Date: Tue, 26 Jul 2022 15:34:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH v6 04/17] arm64: stacktrace: Handle frame pointer from
 different address spaces
Message-ID: <Yt/7WzuBzc1m/6JU@sirena.org.uk>
References: <20220726073750.3219117-1-kaleshsingh@google.com>
 <20220726073750.3219117-5-kaleshsingh@google.com>
MIME-Version: 1.0
In-Reply-To: <20220726073750.3219117-5-kaleshsingh@google.com>
X-Cookie: All rights reserved.
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, ast@kernel.org,
 vincenzo.frascino@arm.com, will@kernel.org, android-mm@google.com,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, madvenka@linux.microsoft.com,
 kernel-team@android.com, elver@google.com,
 linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
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
Content-Type: multipart/mixed; boundary="===============2230859917778614560=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============2230859917778614560==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="EaZlof6ZidZOvm5w"
Content-Disposition: inline


--EaZlof6ZidZOvm5w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 26, 2022 at 12:37:37AM -0700, Kalesh Singh wrote:
> The unwinder code is made reusable so that it can be used to
> unwind various types of stacks. One usecase is unwinding the
> nVHE hyp stack from the host (EL1) in non-protected mode. This
> means that the unwinder must be able to translate HYP stack
> addresses to kernel addresses.
>=20
> Add a callback (stack_trace_translate_fp_fn) to allow specifying
> the translation function.

Reviewed-by: Mark Brown <broonie@kernel.org>

with or without one very minor thing:

>  static inline int unwind_next_common(struct unwind_state *state,
> -				     struct stack_info *info)
> +				     struct stack_info *info,
> +				     stack_trace_translate_fp_fn translate_fp)
>  {
> +	unsigned long fp =3D state->fp, kern_fp =3D fp;

As a coding style nit I don't love having multiple assignments on a
single line especially as part of declarations.

--EaZlof6ZidZOvm5w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmLf+1oACgkQJNaLcl1U
h9D6QggAgqsmZ8mydShiSjezLG0cke2LdLT+FUK0qBgaBpRGDl0V3nysu3AwZHDK
x5J27veMMJPOhXrlIBGeexncpsAzerUu0gnqaCaSchCg3+nJ5icOwm3oseVBWNqU
qkgBVFEKk1mSwMjn7NfgsfJl+hCxykg+E3UqycOPMskyx88qiAqjPXUYJ/3au3Gt
gWu5Q2uNZ2TRdvPT5z0Cued1slb4+y+aPSZW/6KqYnrVARg+Tk6O1QDHYO+DakOU
e2R7hexHSyrGA5gkg5nh2REeVAi46Lf1xTDYhO8JxdS2l6rwLswP2Dw/bUyYIyqv
JCGy7XtA5k4RK05GlerYcRM8q5DnhQ==
=YaN6
-----END PGP SIGNATURE-----

--EaZlof6ZidZOvm5w--

--===============2230859917778614560==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2230859917778614560==--

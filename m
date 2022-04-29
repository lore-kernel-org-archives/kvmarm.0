Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C111C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 29 Apr 2022 13:24:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0BDC4B201;
	Fri, 29 Apr 2022 09:24:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 61a7n0lZsVlO; Fri, 29 Apr 2022 09:24:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A863E410DE;
	Fri, 29 Apr 2022 09:24:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE9AD40D0B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 09:24:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id liZUn14nfNAJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Apr 2022 09:24:49 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9624F40B85
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 09:24:49 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 3FF7AB8330E;
 Fri, 29 Apr 2022 13:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F392C385A7;
 Fri, 29 Apr 2022 13:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1651238686;
 bh=9+eEncYlwkaV6r7GtViKcetUKKSK0ecyfUig/hEuNnI=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=pd8vtQRrdIPSpq1EqtjnJq0eFGUCemeJ8qRCc6/mp1U4semEJtdCm+6dxfmJgfSZE
 8u7QiQi9R1yTxU0m4zWQzNZjprqJigsVkbBRrny13IoxZt/oHP8cQ3H55LiEkdZY5m
 LNLh9sa4jUjgqVAcIQ1pHpNwq76ytrX+aLafrTUyJhRdL7lpMAqwrdBcKd3s22xHn2
 /l1M6zW3wVAhafuQwVIWzyd+pDd7ipu4LClnblpstPSt13CEIwENngNKl0mUFg9adD
 pMcM97FQ48W7QNV/QV5j6IbeHpKDLMuyhivJgo7g+LxfszKPs1wjSS+zUpUc/Nu8j+
 2Eg0ccvi2Z2HA==
Date: Fri, 29 Apr 2022 14:24:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH 4/4] KVM: arm64: Unwind and dump nVHE hypervisor stacktrace
Message-ID: <YmvnFuAIBjQxQfqM@sirena.org.uk>
References: <20220427184716.1949239-1-kaleshsingh@google.com>
 <20220427184716.1949239-5-kaleshsingh@google.com>
MIME-Version: 1.0
In-Reply-To: <20220427184716.1949239-5-kaleshsingh@google.com>
X-Cookie: Are you still an ALCOHOLIC?
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Marco Elver <elver@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 will@kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 surenb@google.com, Peter Collingbourne <pcc@google.com>,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>
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
Content-Type: multipart/mixed; boundary="===============7575757855625283946=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============7575757855625283946==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KmavymclFYg5AbyJ"
Content-Disposition: inline


--KmavymclFYg5AbyJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 27, 2022 at 11:46:59AM -0700, Kalesh Singh wrote:
> On hyp_panic(), the hypervisor dumps the addresses for its stacktrace
> entries to a page shared with the host. The host then symbolizes and
> prints the hyp stacktrace before panicking itself.
>=20
> Example stacktrace:
>=20
> [  122.051187] kvm [380]: Invalid host exception to nVHE hyp!
> [  122.052467] kvm [380]: nVHE HYP call trace:
> [  122.052814] kvm [380]: [<ffff800008f5b550>] __kvm_nvhe___pkvm_vcpu_ini=
t_traps+0x1f0/0x1f0
> [  122.053865] kvm [380]: [<ffff800008f560f0>] __kvm_nvhe_hyp_panic+0x130=
/0x1c0
> [  122.054367] kvm [380]: [<ffff800008f56190>] __kvm_nvhe___kvm_vcpu_run+=
0x10/0x10
> [  122.054878] kvm [380]: [<ffff800008f57a40>] __kvm_nvhe_handle___kvm_vc=
pu_run+0x30/0x50
> [  122.055412] kvm [380]: [<ffff800008f57d2c>] __kvm_nvhe_handle_trap+0xb=
c/0x160
> [  122.055911] kvm [380]: [<ffff800008f56864>] __kvm_nvhe___host_exit+0x6=
4/0x64
> [  122.056417] kvm [380]: ---- end of nVHE HYP call trace ----

This will be really helpful!

Reviewed-by: Mark Brown <broonie@kernel.org>

--KmavymclFYg5AbyJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJr5xYACgkQJNaLcl1U
h9AKIwf+L8bCCODKWgL1wYrEellpME7cjpfW7uY6BxNZBEZJ6V+CuQxbHx7shY1D
qc/lcT1/R3JS7INc3mLr0Nw1K5UxC3jHXujCFw0LezQtuC5243YayR1J+v20WtHu
dia7rJkm6qSPMBbfkJ0IFAn2jCioXZJjeEUld6Q601dktI5CgD0P3gWdm7SoZ/SB
ORt2nNPMVhH571i+HBAeVN5lkk5Y7d8XnlNkqGsnhDiMhZPkg1qrgvcFivsu9HOW
ub+n9WLPOLK0PrZhttDvYnOCiUhNsFI6k3wfujbF0ulDN7GO7giLr6z9dVTq+HFg
G4mI/GfeiPZigTdZ3Uz6dGuiirqvTg==
=x5xf
-----END PGP SIGNATURE-----

--KmavymclFYg5AbyJ--

--===============7575757855625283946==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7575757855625283946==--

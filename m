Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEFA1A4F2F;
	Sat, 13 Jun 2026 00:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310637; cv=none; b=asJ4AYJOmeuB0aFu1qKI5TUwwsCMcgAhWzIK92K+aDsjyTqfSKIDj2ifqzJ4/5cnm6ohtDS+loVDbrZpbX4sAzsSlaZNQRDZdMUpYmSW5iYSyXSye13/ug0/NXbVRyDb9fLkpHSGuXrZy15nUN92Jbi9bnh5Y2qvcUkENcjY+M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310637; c=relaxed/simple;
	bh=SDIRli9h7lS7JMITUEERw90vqGRt/rDfi1jpRo7XY+I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lzSQA6WUG4XDR+gupIwk/iVXI/TErf7ylPyUoS7BPTBgpXfuTTiCeMi8FwO/9oc6tXHzruBGDMb/AzjOeZyCPzNxiUqNUIGhjOL51eQC2FQr7YtnXAsACs8X8I9dkRG4UwbJ2oYyJHdbDFxhLToiSu4MQiLN1Nz7MO48M6ID88U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Im18FB8J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Im18FB8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3561F1F000E9;
	Sat, 13 Jun 2026 00:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781310636;
	bh=gOk6SGOGIVcTuRyCC6GmUUJZ+Bg1tlxCPP/MJIVz4jA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Im18FB8JDZT4jWmRCqPRRUSWYl/vJ+uTQg/0Ibp3ZVA5Wb0nXV9sUYuDZKDxL4SI/
	 LRIYnA1NhJLHqQ40UdW3LyD2pyyH2+jBVfq5I9+YevgmvDJKL2URW7kRA5Ao4frOkz
	 Lwk+++G7BAdilYnIcg01hAkB5HD8OWFVBLCpwA/6mRlM/olEvlX56gUqbpdbTW+RHP
	 Is1mcwAZokKnvB5QXLPZgxM+bFWz3ZKIFsvZ5+Z02RL50Y0BlkdTxGE6TKFCwe6wAQ
	 /ZzFMWYv0IZ2EIRfRryKPemAqvr/6Xqeb2IbfjmhVPmDPVi740MKFKqUOI+puerdKT
	 CuuVSiXsEzWdQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 05/20] KVM: selftests: Seed libc's RNG before using
 it to generate a seed for KVM's pRNG
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260613002031.745413-6-seanjc@google.com>
References: <20260613002031.745413-6-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 13 Jun 2026 00:30:35 +0000
Message-Id: <20260613003036.3561F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Missing `<time.h>` inclusion causes an implicit function declaratio=
n of `time()`.
--

commit 3749f42be6b5df3b7d863a819171920d1f5980cc
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Seed libc's RNG before using it to generate a seed for KVM'=
s pRNG

This commit updates the KVM selftests initialization to seed the RNG used
by random() with the current time. This ensures a different seed is used
in each test run instead of using the same static seed.

> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
> index 1016865d3f7a2..2e08d9fcefc77 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2284,6 +2284,7 @@ void __attribute((constructor)) kvm_selftest_init(v=
oid)
>  	sigaction(SIGILL, &sig_sa, NULL);
>  	sigaction(SIGFPE, &sig_sa, NULL);
> =20
> +	srandom(time(0));

[Severity: Low]
Does this file need to explicitly include <time.h>?

While it might compile cleanly on standard glibc environments due to
transitive inclusions, using time() without explicitly including <time.h>
can cause an implicit function declaration warning or error on stricter
build environments like musl.

>  	kvm_seed_rng(random());
> =20
>  	kvm_selftest_arch_init();

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260613002031.7454=
13-1-seanjc@google.com?part=3D5

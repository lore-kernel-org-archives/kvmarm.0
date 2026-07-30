Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0E2443311;
	Thu, 30 Jul 2026 19:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785439837; cv=none; b=tPZbxhiBfqIFKgx8Q/SO+Z7h20neVJALyiQxMnQZ/AX90iwNINi4XfwePJ335V97hp5C73Yu8b+wZhIu0obv/nuu3FaO/zP0RG4cGzDfY2yCkP588nmA5qikFnTaCmEHmXsrRQoPQJV63erFbyudQi9Gzpit0vKAxREWFasj3dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785439837; c=relaxed/simple;
	bh=DaCjTmbL6p7di5d++oNrL8Ofz30+foNSGfxXkphRMEA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=n7Xp3UNkwnm51MSE2i6TYGI3VONYZhyWTgjRiTK9njlMR/qbqR61qCzd1YAqEIR20UhofEyFalcim3j1EKpcGKJdGHKNTQ9GQDujUbZBS6s/b6ZNjmKgFexfvPQE5RYworME/NUmkT4fyuSxyD/T0fHH0DzbjhnpHqvIx3s1lBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DhSzjzxx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DhSzjzxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEDF1F000E9;
	Thu, 30 Jul 2026 19:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785439836;
	bh=82TlRvTtX2bDRajBQGT1fcOoiBLPeCWS47hSoXkFqwo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DhSzjzxxWp3Dkeg9s49dKJpjksD2BPR6al5nmQDSS8XuCmuUbMtCOkEMo3xwuW1+k
	 1mhMM4vHfT62j6s2RcO1cTpuhRmBzneBgQvc1iJvBaWGbNvkzrre4igUs8WDT8nxdu
	 ahfIQ8Z7ZpnUKXiFwx43nFDwiQ2jefnIEUd0eDXUwbs2eo/CtzygASdLHEucB/ud0w
	 /Ki/mdcWYK9XfLqDuFVHKddA3eOdgxgAzYn9wCc1eBOb+B7k115wzZOP0w7pEpniZ4
	 O9tG/Xid7I1KQScH3H5qDHxcqYcW+BD2zzckMDWexJlV/ku3Aqvdk8i9zadoZmSGbb
	 Fyct6xkvguiUQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/9] KVM: selftests: Drop unreachable, dead code from
 hardware disable test
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260730191908.2084803-5-seanjc@google.com>
References: <20260730191908.2084803-1-seanjc@google.com>
 <20260730191908.2084803-5-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 19:30:35 +0000
Message-Id: <20260730193035.CFEDF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Replacing a blocking `pthread_join` with an infinite busy-wait l=
oop (`while (1);`) in the child process unnecessarily burns CPU and causes =
scheduler contention with the parent process.
--

--- Patch [4]: [PATCH 4/9] KVM: selftests: Drop unreachable, dead code from=
 hardware disable test ---
commit 80b1aa13e14f4a3f65225bf79adc03a7a8eda318
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Drop unreachable, dead code from hardware disable test

This commit removes unreachable code from the hardware disable test to redu=
ce
noise and simplify the test logic. It refactors thread creation and replaces
a blocking wait with a busy loop in the child process.

> diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/=
testing/selftests/kvm/hardware_disable_test.c
> index 1bcbd13e99947..e08aef94382f3 100644
> --- a/tools/testing/selftests/kvm/hardware_disable_test.c
> +++ b/tools/testing/selftests/kvm/hardware_disable_test.c

[ ... ]

> @@ -96,21 +84,19 @@ static void run_test(u32 run)
[ ... ]
>  	pr_debug("%s: [%d] all threads launched\n", __func__, run);
>  	sem_post(sem);
> -	for (i =3D 0; i < VCPU_NUM; ++i)
> -		check_join(threads[i], &b);
> -	/* Should not be reached */
> -	TEST_ASSERT(false, "%s: [%d] child escaped the ninja", __func__, run);
> +
> +	/* Wait for the parent to SIGKILL this child. */
> +	while (1);

[Severity: Medium]
Since the child and parent share the same CPU affinity, will this busy spin
loop cause unnecessary scheduler contention with the parent process when the
parent's timer fires?

Because the processes are pinned to a single CPU core, spinning in this loop
burns CPU cycles and forces the parent to contend with the spinning child f=
or
CPU time.

Would it be better to use a blocking wait like pause() or sleep() here to
reduce scheduler latency and avoid 100% CPU utilization?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730191908.2084=
803-1-seanjc@google.com?part=3D4

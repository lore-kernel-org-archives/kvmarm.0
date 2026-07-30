Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36ADB39C006;
	Thu, 30 Jul 2026 19:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785439773; cv=none; b=a2RMu2Kqfwuavgtz0zBFQPmwJET6A/iQveu7ZiG4R9/5NWb7cEZwO/YswimF1Kw2q6yUDTR/0IukbHQGhDz4cU4Nqit4L5dhiI9UgfKXTSc/3KeXBKEhH9tWi7n4aeLq4lvHnzsWhwWS0BuD222D/vWbPZRqCi5ajyCduS4NQMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785439773; c=relaxed/simple;
	bh=aVyWpYe69afz2kVzVwmlAckclc/mRq3/NwZ+dIy2iLg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=I53ei+lEUcTLFl6qzgHoYLJj0KBQ7MHDHAG7MzD3wW/PWNHPqq2jXUTuU6LwtsARTKcX1BmtKf+QuzaZavEiwS9YjDR/q7HBMbkmF18hTDI6Imi37lnqmWB/6kq+YECXdQ1R213L3biVceME+lqgaCwFiSUGv4tCNMb/xt7ysDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BAA3fxf3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BAA3fxf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE681F000E9;
	Thu, 30 Jul 2026 19:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785439770;
	bh=OWLIYN8jBjjmmF58gbLcXqx8hjz6IiEikUKRCm1Wcwk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BAA3fxf3dd15Jvry0J9UUDRIMCN8kQ5NTO9TKkdhHu13kIKoHXWzS3aqB/QxrUmG4
	 wusyGY/B5jhRql1pQOWFTkSPBBuvomFGAy8ZlMmRXDPoCYvJ8s7R3ByepoKkLAwb4f
	 AHeCnHpCJP1YHrgYbDMJcp6U6glQ0tKKLlcbaJN5EUm2TPFdYuvvdIJXfRldVb3wR7
	 jUqRGQFUD+8LitMxyonX9/i/4/Sm79DU1pSh8Y/B4zJIt1tL+yE+EMcxFrjA03keiZ
	 BAjLHEjdJR906hFIRGv5F0gikUbT5ADgIL+AEO7wE5gsBqyOfLBdgxulnietug6daA
	 fuzF7vKziGHJQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 8/9] KVM: selftests: Add KVM syscall wrappers for
 pthread_{g,s}etaffinity_np()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260730191908.2084803-9-seanjc@google.com>
References: <20260730191908.2084803-1-seanjc@google.com>
 <20260730191908.2084803-9-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 19:29:29 +0000
Message-Id: <20260730192929.ACE681F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] KVM syscall wrappers for pthread functions produce misleading er=
ror messages on failure.
--

--- Patch [8]: [PATCH 8/9] KVM: selftests: Add KVM syscall wrappers for pth=
read_{g,s}etaffinity_np() ---
commit 9fc7623d339b95135fb5ecb9685356bc8dff9829
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Add KVM syscall wrappers for pthread_{g,s}etaffinity_np()

This commit adds KVM wrappers for pthread_getaffinity_np() and=20
pthread_setaffinity_np() to simplify selftest code. It removes the need=20
to manually check for success or supply the size of cpu_set_t in the tests.

[ ... ]

> diff --git a/tools/testing/selftests/kvm/include/kvm_syscalls.h b/tools/t=
esting/selftests/kvm/include/kvm_syscalls.h
> index 002b5a4e59eb2..3d82351bef92e 100644
> --- a/tools/testing/selftests/kvm/include/kvm_syscalls.h
> +++ b/tools/testing/selftests/kvm/include/kvm_syscalls.h
> @@ -97,6 +97,22 @@ __KVM_SYSCALL_DEFINE(ftruncate, 2, unsigned int, fd, o=
ff_t, length);
>  __KVM_SYSCALL_DEFINE(madvise, 3, void *, addr, size_t, length, int, advi=
ce);
>  __KVM_SYSCALL_DEFINE(sched_getaffinity, 3, pid_t, pid, size_t, cpusetsiz=
e, cpu_set_t *, mask);
> =20
> +__KVM_SYSCALL_DEFINE(pthread_getaffinity_np, 3, pthread_t, thread,
> +		     size_t, cpusetsize, cpu_set_t *, cpuset);
> +__KVM_SYSCALL_DEFINE(pthread_setaffinity_np, 3, pthread_t, thread,
> +		     size_t, cpusetsize, const cpu_set_t *, cpuset);

[Severity: Medium]
Will these pthread wrappers print misleading error messages on failure?

The pthread_* functions return positive error codes directly on failure=20
rather than returning -1 and setting errno. If __KVM_SYSCALL_DEFINE formats=
=20
its failure messages assuming errno is set, failing to set affinity could=20
result in printing a stale or unrelated error string (such as "Success")=20
alongside the return code, which might impede debugging.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730191908.2084=
803-1-seanjc@google.com?part=3D8

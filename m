Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498833783C5;
	Fri, 31 Jul 2026 20:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785528703; cv=none; b=Y2mxMYkMGwT3pYsaRN2sLMpf799sW0f/B9S+CNvPYg86s/jkdpgC11b63hmNvVtMQI41GuUrJKEzlEDANPBO73RZ6Yhd681oqkTg9cOSIWD7QHfNi9OZ6eH19PDHQk0VRYoR/hZiIThkMU+mVCndrpiqOowDqbHV4skBXr6wd4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785528703; c=relaxed/simple;
	bh=2TOOrMG3BDCQ965Fh6fB0DJfBAYrTT7cm9wx8TCeDwg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cgZc9l0yvY8e9pE6abl2J5nWJj6+SLmNWhVkCWRcf1pUgqVd+l9YtvZOLhVTajYlTccfcdYYgSDEr43/K7rQvZuGGTG9TZYv0h0bGntl7U/WHOXXWcIAwgd/I0nm4uTE+mYSP5qezfqBufMt+bU0v6+9DQEuwlGr9+VDbHS7iHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RzjpH1FP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RzjpH1FP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF0C1F00AC4;
	Fri, 31 Jul 2026 20:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785528701;
	bh=212dNqAYyuDALpdVKIYLVZtbY6/IY6Q7Nvevmsxznaw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RzjpH1FPDLC+UuXVzPw1A159uBdVbOJdm8mmsgVD0RoPug4BCSkguLiDGDZPhUESj
	 8zoDmxS5vxzDseKOvJ8NT7n5YpxXSoW+AroLDuftASuQD4cOby7GamqOgCM3bIzof2
	 NVNrbRcuweaEh0CA1T2Sbl4QUhh1XTxHo2wD2zWWxgg/ejKT/aS4h5iEM5dltWat7M
	 JmVlbgdyt5hmQfDS3lJLgdmT+y6olwc7gBFgZgUCzC0Un8K/Xh7CXuM/O+iJwY8SS3
	 kkkQjlDqbXrHHKglbrxVjZD43DRDnzV6CbTatKPN+L1XmgQftb6Q+oQ8r8AS3mkemp
	 tntF8SGpIkPoQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 03/12] KVM: selftests: Pre-set threads affinity in
 hardware disable test when possible
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260731195612.2697986-4-seanjc@google.com>
References: <20260731195612.2697986-1-seanjc@google.com>
 <20260731195612.2697986-4-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 20:11:39 +0000
Message-Id: <20260731201140.5AF0C1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The fallback logic for setting thread CPU affinity is guarded by `#=
ifndef _GNU_SOURCE`, which is always false because KVM selftests unconditio=
nally define `_GNU_SOURCE`. This renders the fallback dead code and breaks =
builds on non-glibc systems.
--

--- Patch [3]: [PATCH v3 03/12] KVM: selftests: Pre-set threads affinity in=
 hardware disable test when possible ---
commit 242db3bb38cdcdb7592d9d34951b2c689c2c39b5
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Pre-set threads affinity in hardware disable test when poss=
ible

This commit pre-sets thread affinity using pthread_attr_setaffinity_np to
reduce pthread creation latency on large NUMA systems. It attempts to add a
fallback using kvm_sched_setaffinity when _GNU_SOURCE is not defined.

> diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/=
testing/selftests/kvm/hardware_disable_test.c
> index f088b4af3ccc7..b4edeadfa3f45 100644
> --- a/tools/testing/selftests/kvm/hardware_disable_test.c
> +++ b/tools/testing/selftests/kvm/hardware_disable_test.c
> @@ -36,7 +36,9 @@ static void *run_vcpu(void *arg)
>  	struct kvm_vcpu *vcpu =3D arg;
>  	struct kvm_run *run =3D vcpu->run;
> =20
> +#ifndef _GNU_SOURCE
>  	kvm_sched_setaffinity(0, sizeof(cpu_set_t), &threads_cpu_set);
> +#endif

[Severity: Low]
Since the KVM selftests build system unconditionally defines _GNU_SOURCE,
will this fallback code ever be reached?

[ ... ]

> @@ -80,22 +84,28 @@ static inline void check_join(pthread_t thread, void =
**retval)
>  static void run_test(u32 run)
>  {
>  	struct kvm_vcpu *vcpu;
> +	pthread_attr_t attr;
>  	struct kvm_vm *vm;
>  	pthread_t threads[VCPU_NUM];
>  	pthread_t throw_away;
>  	void *b;
>  	u32 i, j;
> =20
> +	TEST_ASSERT_EQ(pthread_attr_init(&attr), 0);
> +#ifdef _GNU_SOURCE
> +	TEST_ASSERT_EQ(pthread_attr_setaffinity_np(&attr, sizeof(cpu_set_t), &t=
hreads_cpu_set), 0);
> +#endif

[Severity: Low]
Could this break the build on systems using alternative libc implementations
like musl?

If _GNU_SOURCE is unconditionally defined by the Makefile but the libc
doesn't provide pthread_attr_setaffinity_np, this might result in a
compilation error rather than using the intended fallback.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731195612.2697=
986-1-seanjc@google.com?part=3D3

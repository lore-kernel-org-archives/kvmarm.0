Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8613B583A;
	Fri, 31 Jul 2026 17:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785518454; cv=none; b=mPHJ4arCGrtcJVMAC+Syv2jZJ58z/0S/YYWkXwwOFXnTWpUoN8xEu9zXJS+McN15jvXr4IgSRSWxeovIhsZhHcfX6MrV0USq1cWgX/xUSlFH8kLRN7yyyPsng771eZ97clcsaNzUqEKNhf9tA6qHCADTmEInakn84JuBcBTwJEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785518454; c=relaxed/simple;
	bh=kXNyVd6Hl1b4XPi5kJ+vslDhGijeAnhZuFbZAT/jD6o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WKjZexM70QU4K+QJybDY+qhx1dkNek0jyfZOX91Ni66JqdoK9x0CQTGsIGzVFPstXnJvRLiTSnxJrZbuQftdJMB/3EzJVbleBt6OKOe1PWQxtXtJOq3IZbWB7eHccxmAolnWW0k81ZP/Sq5DEAqK7vvwGuQ68o3Wpk7vTALDXj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MpxjxgN4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MpxjxgN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE901F00AC4;
	Fri, 31 Jul 2026 17:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785518453;
	bh=NRz1Wfjplcsv2UjSdD74Nss7uYefJwHhB2A0KSe8/oA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MpxjxgN49MTc9ET9H4cr5GIXczLxXqMGO8JnMDe2kLPmBcIa/ojf516Il3iJNp6IC
	 FBUIvpx3DbrrHxT2NZFLU2U358YDZX3HKUwNI1v0kZqfsWL41Ss01CmOajDqu8ISNR
	 NnZ7EnffV2H/sMdua2g7qH3f/qMQPg55PrijfREpa7Hu52VLC9/gHpg/yRT2sjddCY
	 hduNIGc85Wzz/AZ5fFJR1QuCRuAD1ZAyK0MzoP/K4dy+hOIGDYRICfLokP2/rxu6z4
	 Sd2Shx8+ByGoe1L951D2weZXt9PbFvkXvZnGFECKzmpffK4wyrg8ZVAujxkymqXtxP
	 6W1YOVv+6t9SA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 03/12] KVM: selftests: Pre-set threads affinity in
 hardware disable test when possible
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260731170619.2620845-4-seanjc@google.com>
References: <20260731170619.2620845-1-seanjc@google.com>
 <20260731170619.2620845-4-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 17:20:52 +0000
Message-Id: <20260731172052.9FE901F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] The return value of `pthread_attr_setaffinity_np()` is ignored, =
leading to silent failures and divergent error-handling between libcs.
- [Low] The test incorrectly uses the internal glibc macro `__USE_GNU` to d=
etect GNU extension availability.
--

--- Patch [3]: [PATCH v2 03/12] KVM: selftests: Pre-set threads affinity in=
 hardware disable test when possible ---
commit e87ff4fe7aad8c6f99e1f03d8e09fe9b5ceed69d
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Pre-set threads affinity in hardware disable test when poss=
ible

This commit attempts to reduce the perceived latency of pthread_create() on
large NUMA systems by pre-setting the CPU affinity for grandchildren threads
using pthread_attr_setaffinity_np() when building against a compatible libc.

> diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/=
testing/selftests/kvm/hardware_disable_test.c
> index f088b4af3ccc7..d8288147b0a69 100644
> --- a/tools/testing/selftests/kvm/hardware_disable_test.c
> +++ b/tools/testing/selftests/kvm/hardware_disable_test.c
> @@ -36,7 +36,9 @@ static void *run_vcpu(void *arg)
>  	struct kvm_vcpu *vcpu =3D arg;
>  	struct kvm_run *run =3D vcpu->run;
> =20
> +#ifndef __USE_GNU

[Severity: Low]
Does checking __USE_GNU correctly detect the availability of this API across
different libc implementations?

__USE_GNU is an internal glibc macro. Other implementations like musl provi=
de
pthread_attr_setaffinity_np() and support _GNU_SOURCE, but do not define
__USE_GNU, which would unnecessarily disable this optimization for them.

Should this code check for _GNU_SOURCE or rely on a standard feature test
macro instead?

> +	kvm_sched_setaffinity(0, sizeof(cpu_set_t), &threads_cpu_set);
> +#endif
> =20
>  	vcpu_run(vcpu);
> =20

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
> +	pthread_attr_init(&attr);
> +#ifdef __USE_GNU
> +	pthread_attr_setaffinity_np(&attr, sizeof(cpu_set_t), &threads_cpu_set);

[Severity: Medium]
Is it intentional to ignore the return value of pthread_attr_setaffinity_np=
()
here?

If this fails (for example, due to cgroup CPU mask restrictions), it silent=
ly
leaves the attribute unmodified and the optimization is missed. Meanwhile, =
the
fallback path in run_vcpu() using kvm_sched_setaffinity() explicitly asserts
and fails the test on error.

Should the return value be checked to maintain consistent test behavior and
error handling between the two paths?

> +#endif
> +
>  	vm =3D vm_create(VCPU_NUM);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731170619.2620=
845-1-seanjc@google.com?part=3D3

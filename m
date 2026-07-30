Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFE545FFD8;
	Thu, 30 Jul 2026 19:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785440032; cv=none; b=k4t6lxOi8DV/djeu2CeIRzQ71QjJbRhNzgn4+O1Q7/PWd4WQD4N2bczsaWnmKBhlK1inFuhzQXjUwXv2WQBui1R1lunk2yaUHVm/uaI1FSpLBhY5unBxRPjhlP8SwF1Az1+tmBMnEUrJWlWa/E1o0oet+2FIMb4S0cxFnfTwIW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785440032; c=relaxed/simple;
	bh=kHSN5ILgApJYkaGVbEBotqD70K8ep0mw6ft7p8CSHjM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kr7eMkHIyn79ZS9Uwwk6Q6h/hb3yfPn2rLm+Wjk/oKavq8WMmIOK2NNaBxWSGQ288SZpFQAXUEkXnLkqmsU/rNHOPskb5NhBCi6tvx+MUsy4TERdnMaSkmnrUj0sAJqCD2PhQS1Uo7EDRcD5FcPyS/KCFIsrsqzNFLRQPSsm72Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IDKe2JZd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IDKe2JZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B801F000E9;
	Thu, 30 Jul 2026 19:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785440030;
	bh=fElrHXjHjbDfyYuv6EqYRU3JPw+VgaoKt0VcpbMeV0s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IDKe2JZdAoXpWAI8F+LUlCBpkhNptIDJVC+FQKEvSofArRUaDa3VQiWdAV6QCSA3b
	 x4HfJ0ljFKB/KgcGNJrErcru/zb/mRhQ/Ss+IWFgzUf7w5St5MFA05TYQwYwoNZj57
	 jPb72nIhQM+1kGPv5zs9dOuit04/3MPUbF6Ln+AAHsemOfjdUFvDhw7MnS32aHYNay
	 xUKJUF82sjoH2ApQYCMcfe7wVzVCckT9Dp40QnRJaCOk4ykCpDpoYOE+KUxO+xaK0C
	 tP55uGD5lf8P58FkfCau4oR8RjxzjrBjdg/A4LspJJJPqibrJK1jX3skNTmngOi+tJ
	 iv/0uW04OO10g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/9] KVM: selftests: Affine child tasks to other pCPUs
 in hardware disable test
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260730191908.2084803-4-seanjc@google.com>
References: <20260730191908.2084803-1-seanjc@google.com>
 <20260730191908.2084803-4-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 19:33:49 +0000
Message-Id: <20260730193350.60B801F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Thread initialization race causing severe CPU contention on the =
parent's single CPU, defeating the patch's purpose.
--

--- Patch [3]: [PATCH 3/9] KVM: selftests: Affine child tasks to other pCPU=
s in hardware disable test ---
commit b00682d387a4f6e1d76a822e983d388f7469a322
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Affine child tasks to other pCPUs in hardware disable test

This commit modifies the hardware disable test to affine child tasks to
different pCPUs than the parent task. This is intended to prevent the
child tasks from starving the parent task on preemptible kernels.

> diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/=
testing/selftests/kvm/hardware_disable_test.c
> index 3147f5c97e943..1bcbd13e99947 100644
> --- a/tools/testing/selftests/kvm/hardware_disable_test.c
> +++ b/tools/testing/selftests/kvm/hardware_disable_test.c
[ ... ]
> @@ -84,16 +85,11 @@ static void run_test(u32 run)
[ ... ]
>  		check_create_thread(&threads[i], NULL, run_vcpu, vcpu);
> -		check_set_affinity(threads[i], &cpu_set);
> +		check_set_affinity(threads[i], &child_cpu_set);
> =20
>  		for (j =3D 0; j < SLEEPING_THREAD_NUM; ++j) {
>  			check_create_thread(&throw_away, NULL, sleeping_thread,
>  					    (void *)NULL);
> -			check_set_affinity(throw_away, &cpu_set);
> +			check_set_affinity(throw_away, &child_cpu_set);
>  		}
>  	}
[ ... ]
> @@ -147,12 +143,30 @@ void wait_for_child_setup(pid_t pid)
[ ... ]
> +static void setup_child_cpu_set(void)
> +{
> +	int cpu;
> +
> +	kvm_sched_getaffinity(0, sizeof(child_cpu_set), &child_cpu_set);
> +
> +	if (CPU_COUNT(&child_cpu_set) < 2)
> +		return;
> +
> +	cpu =3D pin_task_to_random_cpu(pthread_self(), &child_cpu_set);
> +	CPU_CLR(cpu, &child_cpu_set);
> +
> +	while (CPU_COUNT(&child_cpu_set) > VCPU_NUM)
> +		CPU_CLR(kvm_pick_random_cpu(&child_cpu_set), &child_cpu_set);
> +}

[Severity: Medium]
Since setup_child_cpu_set() pins the parent thread to a single random CPU
prior to spawning children, won't the newly created threads in run_test()
inherit this single-CPU affinity upon creation?

Because check_create_thread() spawns the threads before their affinity is
explicitly updated to child_cpu_set, they might immediately begin executing
on the exact same CPU as the parent.

Could this result in the child threads starving the parent on that single C=
PU
before the parent gets a chance to execute check_set_affinity()? This seems
like it might heavily delay the migration and trigger the same CPU contenti=
on
that this patch aims to fix.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730191908.2084=
803-1-seanjc@google.com?part=3D3

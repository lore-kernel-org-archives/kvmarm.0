Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327ED51C32A;
	Fri,  4 Sep 2026 18:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788545468; cv=none; b=s1PqybQ4vdGZZWagYzIOiNLrLAbOLQ5XhaTTnwAkVDa46YIlBNVaKOSO3Yu48tISj4fR1MrtAg5TKLkI7ZmIps9Ny3xC9hnHbjq3tE5wPcXBoDVXm3YSqcPOVpjaG9Twera462db47+QIKw+/UelFXDLslZaFy1BG1HEI92Ce5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788545468; c=relaxed/simple;
	bh=EapvxWNWy6tZzPP+ivrKYRudkb+Lrq4EpETndZMPegw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=styjc/DO/v5FVv3S+k1KYhrZPgaq2g15NYYdo/coR6+GmeBPMi1sqwtI6Jhk6swTvHFogAcnHXFvbs6RJumAVFWTco8lgj3DEaRKH4AS2+7uGHR6dYZtI9b42opi1uZNErQck3Ejo0AzJB3wXi8U1Y7eCEr6iMP2PLO7XW0nL6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dtii09kC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dtii09kC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25871F00A3D;
	Fri,  4 Sep 2026 18:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788545465;
	bh=VlM/auzmbD799O66sL928/awy9S44nY91MSnPD26CiM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dtii09kCO5JiA2Wj7zXVZ8/qfsXSuaYIwUG3TCB1ozImlwEFS/HGhMsXfXRpBBWfc
	 o1uTWJvMniNsqpD0uJicTZUFkf3mMWCxR61b4mDd4OQAHFtaJrbc2M83tb8Ba8bDzl
	 ePHGvd5GUu+1e5MfW3kJrhQ4qLAUkh7tyunLp0WHDw2L3KI65cvBTnP6DSQByHfdLv
	 TnY52n8ynV1OSAacUCjyt+w3glaQTkift0IPa4Y2rHhDUJeiDBLWMswi/sTGK4u/nu
	 ZWFslKK9KL5aExMp5qF5O9rbokDG2MQJFOiA4jzvMAKQty/YeBG1+tRMvpGvhMpkqH
	 6TzICjIaZn2YA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/4] KVM: selftests: Test steal time across vCPU pid
 changes on x86
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dongli Zhang" <dongli.zhang@oracle.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260904175550.430266-4-dongli.zhang@oracle.com>
References: <20260904175550.430266-1-dongli.zhang@oracle.com>
 <20260904175550.430266-4-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 18:11:03 +0000
Message-Id: <20260904181104.B25871F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] The delay accumulation loop can hang indefinitely because the ba=
ckground thread uses a fixed wall-clock timeout instead of synchronizing wi=
th the main thread.
- [Medium] Unchecked return values from pthread APIs lead to undefined beha=
vior and potential test hangs.
--

commit 4093ded4f0187a7d185578eeea38cf167b09f1d2
Author: Dongli Zhang <dongli.zhang@oracle.com>

KVM: selftests: Test steal time across vCPU pid changes on x86

This commit adds a selftest to verify that KVM correctly resets steal-time
accounting when a vCPU is run from a new host thread. It creates a backgrou=
nd
thread to accumulate run delay and checks if the steal time remains monoton=
ic
across PID changes.

> --- /dev/null
> +++ b/tools/testing/selftests/kvm/steal_time_change_pid.c
> @@ -0,0 +1,162 @@
[ ... ]
> +static void *do_steal_time(void *arg)
> +{
> +	struct timespec ts, stop;
> +
> +	clock_gettime(CLOCK_MONOTONIC, &ts);
> +	stop =3D timespec_add_ns(ts, MIN_RUN_DELAY_NS);
> +
> +	while (timespec_to_ns(timespec_sub(ts, stop)) < 0)
> +		clock_gettime(CLOCK_MONOTONIC, &ts);

[Severity: Medium]
Does this background thread rely on a fixed wall-clock timeout instead of
synchronizing with the main thread's delay accumulation?

If scheduler interleaving allows the main thread to run during this window,
its accumulated run delay will be strictly less than MIN_RUN_DELAY_NS when
this thread exits. Once this thread exits, CPU 0 becomes uncontended and
the main thread's delay accumulation loop will hang indefinitely.

> +
> +	return NULL;
> +}
[ ... ]
> +int main(void)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	pthread_attr_t attr;
> +	pthread_t thread;
> +	cpu_set_t cpuset;
> +	long run_delay;
> +	long run_delay_delta;
> +
> +	ksft_print_header();
> +	ksft_set_plan(1);
> +
> +	CPU_ZERO(&cpuset);
> +	CPU_SET(0, &cpuset);
> +	pthread_attr_init(&attr);
> +	pthread_attr_setaffinity_np(&attr, sizeof(cpuset), &cpuset);
> +	pthread_setaffinity_np(pthread_self(), sizeof(cpuset), &cpuset);

[Severity: Medium]
If this pthread_setaffinity_np call fails (for example, if CPU 0 is not in
the allowed task mask), could the threads run on different CPUs? This would
prevent the main thread from ever accumulating runqueue wait time, causing =
it
to hang forever in the sched_yield loop.

[ ... ]
> +	run_delay =3D get_run_delay();
> +	pthread_create(&thread, &attr, do_steal_time, NULL);

[Severity: Medium]
If pthread_create fails due to resource limits, will the thread variable
remain uninitialized?=20

> +
> +	while (get_run_delay() - run_delay < MIN_RUN_DELAY_NS)
> +		sched_yield();

[Severity: Medium]
As mentioned above, if do_steal_time exits before MIN_RUN_DELAY_NS is
accumulated by the main thread, does this spinloop hang permanently because
the background thread is no longer consuming CPU time?

> +
> +	pthread_join(thread, NULL);

[Severity: Medium]
If the thread variable is uninitialized due to a prior pthread_create
failure, does passing it unconditionally to pthread_join invoke undefined
behavior?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904175550.4302=
66-1-dongli.zhang@oracle.com?part=3D3

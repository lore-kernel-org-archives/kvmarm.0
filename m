Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD67395243;
	Sun, 16 Aug 2026 05:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786859721; cv=none; b=fEg3mQgFS/TMA7+2ql+l1WMiUnoGhRG1eX+8uKvoNSwh8JhhrJWkM8/Rm+GyXKNYbcwP7mOK3nCgGHa0nOYoLx0N3B3fo00M2gT6MSAvll6W8eXYpaXMdkMZP+BhhxJvSAuX91RFcdpCV4YISFF1GYqkE8XtGjjaAlmQx9WY6j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786859721; c=relaxed/simple;
	bh=nahgdkQqpBuPTnNsfR/w8RZeNMm5xkcykO1RYwg7zuU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LfdZ22KDaGrPYqia/xnH8Ue38A29/+Vu+FgzUxItNe7pSai2SWEODuM7b0oPDQnsygSpygdpbl2t36VgenUd+mzbxXilKYpv/u3nuoP80f0/nWpRhQm6i744uYtR6YWHevOro9TPo+63PLUh20sSIIGG2xg7+y33sNabyge9ndg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZ9m06/0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZ9m06/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96F11F000E9;
	Sun, 16 Aug 2026 05:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786859720;
	bh=MjbNaWToAnIzgZzPysZS6Kqukk1Otp0g6q2SVcF/XUk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AZ9m06/0obrlnIG+8hNyuKqpB5sJd3UwZ7Imdom5EzE/frzKBKMM37earNUZ3Dduc
	 iblfFxoWH/YRtGXjsovjDRFTAdH3HXPCusLsfwiYEcPOcCkuAz9K/z9mbCsQ3BFBCM
	 7o05qg2DwnL0RvSFbjN4cDPpLnqsCuP+5SXbpjPVA6R5KU2UKekmNF4VGBKA0SDNPS
	 BBg06o26KW+Rfgtrds/0N5SWF7lRjIYttZlmcXNaRMW88k2mrBaS8kIU8xdfOSQWM/
	 wqPsnwCN6bJmcLNVDQj97aJLqhWXPS5BOp5PDEpoECEPIZeas1IM+lNHiFKMrQMm2a
	 PJrsmoILISPGg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/4] KVM: selftests: Test steal time across vCPU pid
 changes on x86
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dongli Zhang" <dongli.zhang@oracle.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260816053630.527528-4-dongli.zhang@oracle.com>
References: <20260816053630.527528-1-dongli.zhang@oracle.com>
 <20260816053630.527528-4-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 16 Aug 2026 05:55:19 +0000
Message-Id: <20260816055519.E96F11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] The test races and hangs infinitely if the main thread is schedu=
led during the helper thread's 200=C2=B5s wall-clock window.
- [Medium] Unhandled `pthread_create()` and `pthread_setaffinity_np()` erro=
rs lead to an infinite test hang and undefined behavior.
--

--- Patch [3]: [PATCH 3/4] KVM: selftests: Test steal time across vCPU pid =
changes on x86 ---
commit dbc0e15e73158fcb584e1322da57a03214c88dd3
Author: Dongli Zhang <dongli.zhang@oracle.com>

KVM: selftests: Test steal time across vCPU pid changes on x86

Add a selftest for the case where the same vCPU fd is run from a new host
thread after steal time has already been enabled and updated.

> diff --git a/tools/testing/selftests/kvm/steal_time_change_pid.c b/tools/=
testing/selftests/kvm/steal_time_change_pid.c
> new file mode 100644
> index 0000000000000..3c39594db398e
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/steal_time_change_pid.c

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
Is an error check needed for pthread_setaffinity_np()?

If CPU 0 is offline or excluded by the process taskset mask, this will fail
silently. The threads would then run on different CPUs and avoid runqueue
contention, preventing the main thread's wait time from increasing and
potentially causing an infinite hang in the later sched_yield() loop.

[ ... ]

> +	steal_time_enable(vcpu);
> +	run_vcpu(vcpu);
> +
> +	run_delay =3D get_run_delay();
> +	pthread_create(&thread, &attr, do_steal_time, NULL);

[Severity: Medium]
What happens if pthread_create() fails here?

If thread creation fails, do_steal_time() won't execute to generate
contention, and the subsequent loop waiting for run_delay to increase could
spin infinitely.

> +
> +	while (get_run_delay() - run_delay < MIN_RUN_DELAY_NS)
> +		sched_yield();

[Severity: Medium]
Can this loop hang infinitely if the main thread is scheduled during the
helper thread's wall-clock window?

The helper thread do_steal_time() bounds its execution to strictly
MIN_RUN_DELAY_NS of wall-clock time:

static void *do_steal_time(void *arg)
{
	struct timespec ts, stop;
	clock_gettime(CLOCK_MONOTONIC, &ts);
	stop =3D timespec_add_ns(ts, MIN_RUN_DELAY_NS);
	while (timespec_to_ns(timespec_sub(ts, stop)) < 0)
		clock_gettime(CLOCK_MONOTONIC, &ts);
	return NULL;
}

If a scheduler tick occurs during this window, the main thread may preempt
the helper thread to evaluate this loop condition.

While the main thread is running, its runqueue wait time (run_delay) does
not increase, but the helper thread's wall-clock timer still advances. As a
result, the helper thread could exit having been on the runqueue/CPU for
exactly the requested wall-clock time, but the main thread will have
accumulated strictly less than MIN_RUN_DELAY_NS of wait time.

Once the helper thread exits, there are no competing threads on the pinned
CPU, so the main thread's wait time stops increasing permanently, causing
this loop to spin infinitely.

[ ... ]

> +	run_vcpu(vcpu);
> +	sync_global_from_guest(vm, guest_stolen_time);
> +	main_steal =3D guest_stolen_time;
> +
> +	TEST_ASSERT(main_steal >=3D MIN_RUN_DELAY_NS,
> +		    "Expected steal time >=3D %ld, got %"PRIu64,
> +		    MIN_RUN_DELAY_NS, main_steal);
> +
> +	pthread_create(&thread, NULL, vcpu_thread, vcpu);

[Severity: Medium]
Should we check the return value of pthread_create() here?

If it fails, the thread variable remains uninitialized, which would trigger
undefined behavior when passed to pthread_join() on the next line.

> +	pthread_join(thread, NULL);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260816053630.5275=
28-1-dongli.zhang@oracle.com?part=3D3

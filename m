Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC9A310645;
	Mon, 21 Sep 2026 14:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790000223; cv=none; b=t8z0GV/wfEHTWpH7Im6YwPXKo56+ZrRxB1Er053UvIylTIkVsBQQc6a2UetcVzQrE5TyKGNY8IgcFEzTY+noUqWT7E2jlqbH8+qoGA9KfAAN3N0oHLHfhSGZY7RMmlUTSigpjRolnkj4ozN2kehuy+Q/1seZ9aZrZhkTfkouo9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790000223; c=relaxed/simple;
	bh=2qq8KfM2YOSpp0BCA0r02D0yFEX0yj1ZCE2mOf/9jU8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Dvsnsa7tSiUGP7qrNC9KEkbhzekSkUgFJkJhZUy4RDKn/HeW0wjGQu/GUX1CsTExsXHr5l3o5rIJw3Tr4+n9oe3SeVCQ/CQT08U+tpSsBo/vgDdRpYLpZ7LJCjtVSxIZvbcOUfxjQXqMRCC8utXA73VqaMDu/ngWt50T/aSLE1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QBfd496z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QBfd496z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CFD1F000FF;
	Mon, 21 Sep 2026 14:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790000221;
	bh=JVtOhCEnFF4VMLoP4FDqz9BM7LYVVOhqz0dAz47yYnM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QBfd496z8brZlJiAq6yr49Fz4QaVh5Qg03HGrh16xJAtRh+HIlk9l6PDEhrkG65dI
	 ekltsVd/Z4vbRFTGL02WUqDhwx5320Ni2bbK8B2KqQtYRDtEdyYNLpkZ7D4yg+BRLF
	 tMuZMQTIsY9F8gCBCD2z+LpDN7PXLVlREPUbD1SmfXA8tL2JC598bSyDW0Sqw50TVE
	 FhC+lit9CAR09D+jGg4onNf3MBXblWUQxF2652xGdtdYA/ygNyGOjUTl0/FYkzF+Oo
	 eA9MabTRscmD+43/IjWikviUV+7nL/U0yVRQSnlrfuYMuum6mwf6wYNu4haQh2o6IK
	 1YzSfFUMX9Yhg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] KVM: arm64: selftests: Test a timer set past the
 counter's wrap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260921140427.2211373-4-fuad.tabba@linux.dev>
References: <20260921140427.2211373-1-fuad.tabba@linux.dev>
 <20260921140427.2211373-4-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 21 Sep 2026 14:17:00 +0000
Message-Id: <20260921141701.33CFD1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] selftests: flaky test due to scheduling delay in test_timers_pas=
t_counter_wrap
--

commit 8788b1ebd8d97a89915e8766ef7a7c75ad83b3c9
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: selftests: Test a timer set past the counter's wrap

This commit adds a KVM selftest to verify timer behavior when programmed
with a cval past the counter's wrap point. It programs an unmasked timer
and tests that no unexpected interrupts fire since the guest's counter
cannot realistically reach the deadline.

> diff --git a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c b/=
tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
> index d9c9377a63256..69986a7f0d37d 100644
> --- a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
> +++ b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c

[ ... ]

> +/*
> + * With the counter at wait_ms, a tval of -(wait_ms + long_wait_ms) puts=
 cval
> + * within long_wait_ms of the counter's wrap: a deadline further away th=
an the
> + * counter can reach. Unmasked, so an early ISTATUS shows up as an IRQ.
> + */
> +static void test_timers_past_counter_wrap(enum arch_timer timer)
> +{
> +	s32 tval =3D -(s32)msec_to_cycles(test_args.wait_ms + test_args.long_wa=
it_ms);
> +	int i;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(sleep_method); i++) {
> +		sleep_method_t sm =3D sleep_method[i];
> +
> +		local_irq_disable();
> +		set_counter(timer, msec_to_cycles(test_args.wait_ms));
> +		set_tval_irq(timer, tval, CTL_ENABLE);

[Severity: Medium]
Could this sequence lead to a flaky test on a loaded host system?

If a host scheduling delay exceeds long_wait_ms between setting the counter
and writing the TVAL, the guest's CNT can advance such that:
CNT > wait_ms + long_wait_ms

When set_tval_irq() then executes, the hardware calculates the absolute
deadline as CVAL =3D CNT + TVAL. Because TVAL is a negative value of
-(wait_ms + long_wait_ms), CVAL evaluates to a small positive number
instead of wrapping around to near U64_MAX.

Since CVAL is now less than CNT, the timer condition (CNT >=3D CVAL) is
met immediately, and the hardware legitimately fires the unmasked timer.
This would cause the subsequent assert_irqs_handled(0) check to fail.

> +		sm(timer, msecs_to_usecs(test_args.wait_ms) + TIMEOUT_NO_IRQ_US);
> +		local_irq_enable();
> +		isb();
> +		assert_irqs_handled(0);
> +		timer_set_ctl(timer, CTL_IMASK);
> +	}
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260921140427.2211=
373-1-fuad.tabba@linux.dev?part=3D3

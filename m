Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777CDE54B;
	Fri,  7 Aug 2026 17:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786125015; cv=none; b=PN2D2NED06+NB0X96YO3IqFHquTeyuupToK1s/bkQnTP2iFfBl6kCgBHce93fujErod0Akyeu3qE8VI14eWjxCg7lYUHhzNq/qnr0eiLKzzoaQGxhGzp1vcrqNXEDXztQF7BNEBROLaywujLIsQKDPjnaZOUzOaxyswtiuUeR4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786125015; c=relaxed/simple;
	bh=zSV6oXNfGbD/JzkJuzI6FRRLRjhgAv5gSV9ZZk0NnCM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YwfSfmS/1pNgBNBrOln8htM2YqoyB29qvXKM1oMT+HNnwlMkRMrMsJ51QANwdeTwzTzUrldV45NYG42aA+fdEYvNAhn3of45t0SdjHgDkJ8BBuTORCBMYA2sPAu+LLgAFNHcHlJ+UwQupbZVwZGKE5N1wNn+jwkGI0VOqaJVt+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IGfVmh5U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IGfVmh5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FC71F000E9;
	Fri,  7 Aug 2026 17:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786125014;
	bh=ybrTXnzvrwJBryS+JumQ/iM90ZGiwhM/VqCp0YR9wHg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IGfVmh5UkeTIe6DMxuqWzFufhgbET9a9fdru7rhgRd4eZx3f2Yt7EQGOrJC9bbDc+
	 CP2UdD8GwTGDYdEB30ynX+jUBTJ0V5Xy2GxLuI3vV992iRdLPXC14DbJBuJ1aYz0kU
	 7CKZFsvCibppLBKrQbXInKGDeF291oQLLZyKaWijR/HtLwji5PgWRo5+E+Xw6A8tUL
	 QZFE8hnviwO+ATfZPoRY7ihjpbNugUosC7C2voFv6daVew36r+p7TrHfCurGLISTeq
	 5anSxQXjXaysgDKdvh9v33/vam47eljBwp4WdJevwVlbs/WBqWwZba3timVqrgVoWN
	 0fR23PcSATMVg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 48/49] KVM: selftests: Add VGICv5 IST save/restore
 coverage
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260807111159.429128-49-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-49-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 17:50:13 +0000
Message-Id: <20260807175013.D7FC71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing Context Synchronization Event (ISB) after control-plane sy=
stem register writes.
--

--- Patch [48]: [PATCH v5 48/49] KVM: selftests: Add VGICv5 IST save/restor=
e coverage ---
commit 3f2c979e78365e70421bcaaf39f350d8b4a83086
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: selftests: Add VGICv5 IST save/restore coverage

Add end-to-end VGICv5 IST save/restore coverage. The test verifies that
interrupt state saved from the ISTs can be restored into a fresh VM before
first run and then consumed by the guest.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/=
selftests/kvm/arm64/vgic_v5.c
> index 71bda5661c74e..47e147bc14b87 100644
> --- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
[ ... ]
> @@ -359,6 +406,165 @@ static void guest_lpi_code(void)
[ ... ]
> +static void guest_ist_restore_code(void)
> +{
> +	local_irq_disable();
> +
> +	gicv5_cpu_enable_interrupts();
> +
> +	if (!guest_get_vcpuid())

[Severity: High]
This is a pre-existing issue, but should gicv5_cpu_enable_interrupts()
issue an isb() before it returns?

Looking at the implementation of gicv5_cpu_enable_interrupts() in both the
host kernel driver (drivers/irqchip/irq-gic-v5.c) and the selftest helper
(tools/testing/selftests/kvm/include/arm64/gic_v5.h), it writes to control
plane system registers like SYS_ICC_CR0_EL1 without an explicit context
synchronization event.

In this new test code, we perform a conditional branch based on
guest_get_vcpuid() immediately after returning from the function. Without an
isb(), could this conditional instruction be executed against an
architecturally undefined pipeline state?

> +		gicv5_set_pcr(VGIC_V5_IST_PRIO_HIGH);
> +
> +	GUEST_SYNC(GUEST_CMD_IS_READY);
> +
> +	local_irq_enable();
> +
> +	while (1)
> +		wfi();
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D48

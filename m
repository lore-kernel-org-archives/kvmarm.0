Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4C2311C32;
	Fri,  4 Sep 2026 13:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788527292; cv=none; b=TOhBE4c7eNRe85BtnrD2CzbclkQAYMVtB7KnjMw1rWNrhx8CAHiXkEkzneXxBD8GlZu7lPBigbiJm4ZZnhRT1WuKrgJ6Y3lvI/yOlPOwFBrZ2hS+UqUsVTmEMzXvGggPFFrNMkteUHLrPfi0g2dBWcmL8f9gKOjbUFwJJusjIZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788527292; c=relaxed/simple;
	bh=jGdgWPwjXRzab3e5ApmpH/CITkVzWpz2G0/BMS9M20U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UFGBQGwBRQSr39Vjpt2R5xw9fxPb7bypMmbTa+DmURJJa8p/XhD/Nq599WmIwTcIwndAe/2q/6LpyX5BWoaug3U+VVmUGVzqqfZGN/n97F5PR5RJEEPHAjmtBzrrT5XNw3MLWeymyruomMLpyCkWZB1SzpuSYJMRsarJmFy/jhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a1dPzIoj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a1dPzIoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6851F00A3D;
	Fri,  4 Sep 2026 13:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788527287;
	bh=W6QWpNRlVwZmj4ZVXIep4F11w4wTqmyh6tjh89MqQkU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a1dPzIojjl7vyB5otKXGGouGr4Jf9iinGVCmLVfHDxLryE7n03QLl8p7x48LascTC
	 wXnFJ7eE2endcyIenUuCBQ0S0jO9C5kWlt8dKO9fh/WvKOm3cdZKDG3pE6KdG4HPPf
	 /bLc6qHsQ+7t5QguaK5BVZ8VWLeL4vG33+B66AiywlvkEp7174qM6A73GP5RqJExpU
	 4GwP5rLwCGlHJ6yulB6D6LSx0duAkCBHIsRS7TodC4AXNAfFuWuFdebfjMYHmH2P23
	 v1C/9YetderRiceU2ZtnLiWd0ZxOsqvzkjrcbORwwgjElUF4bWbjuMjFPUF12oqjIr
	 cu3+u1p/MOSMg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 16/49] KVM: arm64: gic-v5: Request doorbells when
 VPEs enter WFI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260904113404.4051341-17-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
 <20260904113404.4051341-17-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 13:08:07 +0000
Message-Id: <20260904130807.9A6851F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ABBA deadlock between scheduler `rq->lock` and IRQ `desc->lock`
--

commit 53b46a42489c35d884554bb95601a01f175a2eb9
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

    KVM: arm64: gic-v5: Request doorbells when VPEs enter WFI
   =20
    When a GICv5 VPE is made non-resident as part of the vcpu entering
    WFI, request a VPE doorbell so that KVM can be notified when a
    suitable SPI or LPI becomes pending for that VPE.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index d7d6db5014269..5a058ef8fe701 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> @@ -1095,6 +1095,52 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
[ ... ]
> +			/*
> +			 * Make the doorbell affine to this CPU, if it isn't
> +			 * already. Actively check the cpumask first as it is
> +			 * cheaper than changing the affinity every time.
> +			 */
> +			if (!cpumask_test_cpu(cpu, aff)) {
> +				int ret;
> +
> +				ret =3D irq_set_affinity(db_irq, cpumask_of(cpu));

[Severity: High]
Does this create a lock inversion between the scheduler's rq->lock and the
IRQ desc->lock?

When a guest executes WFI, KVM calls kvm_vcpu_block() -> schedule(), which
acquires rq->lock. The scheduler then invokes preempt notifiers:
fire_sched_out_preempt_notifiers() -> kvm_sched_out() -> kvm_arch_vcpu_put(=
).

This eventually calls vgic_v5_put() while rq->lock is still held.
irq_set_affinity() then unconditionally acquires desc->lock.

Because the established kernel lock hierarchy requires taking desc->lock
before rq->lock, this reversed order (rq->lock -> desc->lock) appears to
introduce an ABBA deadlock.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904113404.4051=
341-1-sascha.bischoff@arm.com?part=3D16

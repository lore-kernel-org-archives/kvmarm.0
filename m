Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED863ACA6B;
	Fri, 12 Jun 2026 20:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781294474; cv=none; b=Yz+nUY97QRwTK5Bbd9mPym9ZSD3il459lQeulCwarbj+sf1TcJWHcIkWJcxPzoOKIscfDg9jESmjpBddh7p15D8pyHrJda6WToppoRZ8O+tmX+YSpiFgJImwlamFwAMNqbDBzJ1xlV/I5u6GQ1IDCGDt6wzVz/BhNo1fqv3IRxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781294474; c=relaxed/simple;
	bh=Mx9xbRlNx6ZnOxh2JtOsNt+CKKABoMFgZWQ5dmEF898=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UgUBiPIDq4Y5m8SB8QBjwFZWtrsoP7fBfP7EfMfpihxKUXeA+t6wQeP3XyQtsf+nqryHRGuQSPtSYGOEyZ7KSWX5n6p1/unxYXJxiqp3JGwp7nmeo+F1N5dI8ZFTMuIfA90DJ7X8hM4HDV/qbsVphaA/uoOnMZttVvKGQhrKOSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NJDbvbAW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NJDbvbAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11D71F00A3A;
	Fri, 12 Jun 2026 20:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781294472;
	bh=GohqCMod4X3F2A0JK+UCem9vPNCDLH7fryAZ4aplsHU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NJDbvbAWvlgEqR6w6y/JrVLACUbL8QshdI3UlF/bECSHVqOAFnAEi5E3tkpoASz5y
	 XQEboYT3LZ68hdywYXwLaYMnIC9RsRSlIqjX64a+omBx/a4a9ztzV7zmIF9cgMfOCA
	 xs/I4hxKWIkjj5t8RLbloXS6nhQ0pk7aGYFWpTZGiacb0oG5F+JDtLJ0yx80y2gdQ7
	 c2t5WVuB1+dscT37Tk9RLvIrhK7PtuQ/AT3Wf7pEDmOyctFDLrSY3pANe2T5qgaXx1
	 ns5YTkd2ufASlbg2Y3GXI5H0bIuc41tAtbN+2h63mkqRIeXxrU5Iw6hoCtr1pU9lmq
	 kxVakNXv/Xoiw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 19/21] KVM: selftests: Add find_bit to KVM library
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260612192909.1153907-20-coltonlewis@google.com>
References: <20260612192909.1153907-20-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 20:01:11 +0000
Message-Id: <20260612200111.C11D71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The non-atomic `__vcpu_rmw_sys_reg` macro is used to update `PMOVS=
SET_EL0` from both the VCPU thread and the PMU NMI handler, leading to lost=
 guest overflow events.
--

commit 5ccb539bf3353bcdda1d741299b5fc364734f717
Author: Colton Lewis <coltonlewis@google.com>

KVM: selftests: Add find_bit to KVM library

This commit adds the find_bit functionality to the KVM selftests library.
It resolves separate compilation issues for selftests that have a dependency
on find_bit by including it similarly to rbtree.c.

> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
> new file mode 100644
> index 0000000000000..2d2294b78ebe0
> --- /dev/null
> +++ b/arch/arm64/kvm/pmu-direct.c

[ ... ]

> +void kvm_pmu_put(struct kvm_vcpu *vcpu)
> +{

[ ... ]

> +	/* Save pending guest hardware overflows. */
> +	local_irq_save(flags);
> +	val =3D read_sysreg(pmovsset_el0);
> +	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=3D, val & mask);
> +	write_sysreg(val & mask, pmovsclr_el0);
> +	local_irq_restore(flags);
> +
> +	/* Stop guest counters and disable interrupts in hardware. */
> +	write_sysreg(mask, pmcntenclr_el0);
> +	write_sysreg(mask, pmintenclr_el1);
> +	kvm_pmu_set_guest_counters(pmu, 0);
> +	preempt_enable();
> +}

[Severity: High]
Does this non-atomic register update risk losing guest overflow events?

Since __vcpu_rmw_sys_reg() is non-atomic, and local_irq_save() does not mask
NMIs on ARM64 when pseudo-NMIs are enabled, could an NMI interrupt the VCPU
thread exactly between the load and store phases here?=20

If the PMU NMI handler injects a guest overflow flag during this window,
wouldn't it be overwritten and permanently lost by the stale writeback?

[ ... ]

> +void kvm_pmu_handle_guest_irq(struct arm_pmu *pmu, u64 pmovsr)
> +{
> +	struct kvm_vcpu *vcpu =3D kvm_get_running_vcpu();
> +	u64 mask =3D kvm_pmu_guest_counter_mask(pmu);
> +	u64 govf =3D pmovsr & mask;
> +
> +	write_pmovsclr(govf);
> +
> +	if (!vcpu)
> +		return;
> +
> +	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=3D, govf);

[Severity: High]
Is this concurrent modification safe?

Since this NMI handler asynchronously modifies PMOVSSET_EL0 using the same
non-atomic __vcpu_rmw_sys_reg() macro used by the VCPU thread in kvm_pmu_pu=
t(),
could they race?=20

If this handler runs while the VCPU thread is performing its own
read-modify-write on PMOVSSET_EL0, wouldn't the guest overflow flag be
overwritten and lost, leading to incorrect counter states in the guest?

> +
> +	if (kvm_pmu_part_overflow_status(vcpu)) {
> +		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612192909.1153=
907-1-coltonlewis@google.com?part=3D19

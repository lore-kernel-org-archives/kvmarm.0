Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0336236B93B;
	Tue,  8 Sep 2026 16:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788886003; cv=none; b=qc7N2/Oyz8pscx/OrfSGVmPNa1zKF1isTIY0SoeEK2UISb1+q25b0tLcNEBCa43KY+4sh01NPQgoLV5hb/57HAUCFWZxyhq4v6jWffn/MYe14tYXX540Hf9xlMQER5+Wn6p4gc3B47WPhN6eKk72ICkwjJiPmdwDf6YmG4a+FpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788886003; c=relaxed/simple;
	bh=3VD492QNE2GeGsncB73/0hZ7CIWz+TZ7qm/WwPcuLLo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cL8dpzKoSwTFQ01pk8G3mmm+MZmg8Mxyz0SldUeK01AqvC2fAAh4XZJhlOgSbQq/FreIsYpDl07Hm60UiZJyAYwODJAvyFvdSk5LXKIg5RMl7KuV7gEBNJMReNMnngqOkktjzHqh9ExWIEEQuG9svXXptbNiIlhr1henHYMtjJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DaZtM4x5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DaZtM4x5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416911F00A3A;
	Tue,  8 Sep 2026 16:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788886001;
	bh=1wYs7wF5Dn70OfCJVDpfXp5mDw9uyD1wmciOQVXgPWk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DaZtM4x5vMYws14mTosM+MS2W6BRhgVgsgExNalCVT+Ne3fUAxi/LRy/WRIW1nzAL
	 bviLSBQ36n3aXVfnZlrgOR1cFU8IakkgmoxLA+E/9EzozuJf35dq1vaC9JtVWIBGng
	 nXVEYNrez4JcW3y8SC78itNX0lsKsiwKF5uawiQz1sxavD4iZ8QdoZ//Q8wzSbjo5M
	 HB4tsgE4FZHV6B/s+44ybv7mZY9hli+iCvQptyV3hMd4t7uE8hdAB1zDGQgf6p7Cap
	 mZ09HnmP5jATySXTPBrHdLdsANPv/HwZXW9XXg+n3qhzUlzmybvyny2OmQQ3oNtTfP
	 rF7b4WwjUUZ3w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 09/20] KVM: arm64: coco: arch_timer: Prevent timer
 offset configuration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260908162223.1683432-10-suzuki.poulose@arm.com>
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-10-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 16:46:40 +0000
Message-Id: <20260908164641.416911F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unprivileged host userspace can trigger a kernel WARN (and potenti=
al host panic) by setting SYS_CNTVCT_EL0 or SYS_CNTPCT_EL0 via KVM_SET_ONE_=
REG for a confidential VM.
--

commit 563a7eb94c0d2b010c530d4a42b1717738d5106a
Author: Suzuki K Poulose <suzuki.poulose@arm.com>

KVM: arm64: coco: arch_timer: Prevent timer offset configuration
   =20
Confidential guests, including protected PKVM guests and Arm CCA Realms, al=
ways
runs with 0 timer offset. Prevent the configuration for them.

> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 6ac3321f4c575..eba84cab95d01 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -1079,7 +1079,7 @@ static void timer_context_init(struct kvm_vcpu *vcp=
u, int timerid)
> =20
>  	ctxt->timer_id =3D timerid;
> =20
> -	if (!kvm_vm_is_protected(vcpu->kvm)) {
> +	if (!vcpu_is_confidential(vcpu)) {
>  		if (timerid =3D=3D TIMER_VTIMER)
>  			ctxt->offset.vm_offset =3D &kvm->arch.timer_data.voffset;
>  		else

[ ... ]

> @@ -1110,7 +1110,7 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>  		timer_context_init(vcpu, i);
> =20
>  	/* Synchronize offsets across timers of a VM if not already provided */
> -	if (!vcpu_is_protected(vcpu) &&
> +	if (!vcpu_is_confidential(vcpu) &&
>  	    !test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags))=
 {
>  		timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read());
>  		timer_set_offset(vcpu_ptimer(vcpu), 0);

[Severity: High]
This is a pre-existing issue, but does this configuration allow unprivilege=
d=20
host userspace to trigger a kernel WARN?

For confidential VMs, ctxt->offset.vm_offset is initialized to NULL in=20
timer_context_init(), and KVM_ARCH_FLAG_VM_COUNTER_OFFSET is skipped=20
here in kvm_timer_vcpu_init().

However, if userspace calls KVM_SET_ONE_REG for SYS_CNTVCT_EL0,=20
arch_timer_set_user() handles it like this:

arch/arm64/kvm/sys_regs.c:arch_timer_set_user() {
    ...
    case SYS_CNTVCT_EL0:
        if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.fla=
gs))
            timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read() - val=
);
        return 0;
    ...
}

Since the flag is clear for confidential VMs, this will unconditionally inv=
oke
timer_set_offset() with a userspace-controlled offset.=20

In timer_set_offset():

include/kvm/arm_arch_timer.h:timer_set_offset() {
    ...
    if (!ctxt->offset.vm_offset) {
        WARN(offset, "timer %d\n", arch_timer_ctx_index(ctxt));
        return;
    }
    ...
}

Because vm_offset is NULL, this triggers the WARN if the computed offset is
non-zero. With panic_on_warn enabled (common in cloud environments), could
this allow unprivileged host userspace to panic the host?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908162223.1683=
432-1-suzuki.poulose@arm.com?part=3D9

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6F33C5522;
	Sun, 16 Aug 2026 05:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786859727; cv=none; b=GgcNRe58ml7NjkVsxUJsshP094FY4ICaUBZRjBFXcYa9JrdvOmO9cZwHzQZBlzRNkWiSxSDffpK+Gg3akZnnMFrYe/giliQj3TjwJu2aPNYrlIsjYTAIsDB7fEoA/G4tGhLtJT/Q8BDQevwSCnn4Xd3ZJ1oIWY/HgH30/rOEzGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786859727; c=relaxed/simple;
	bh=KFU7DcTQ9dXc7a00lVpoE2cuL3f04kJwqGoRfuj8nnI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KZjEVJkhgM+kHM0nE1sOPFQ9VAbO58/OvgN1qisMqy0RywN77QNGZRF8hoF1La2Gq2brX78BzmR0x2hJhdG7EE7qsjgAJu44WRnvQpzWAAioDe/7A+DZRsVBqgoytP3An1nsFu2rosPyQShr8UfkkZdBxmzhmujKbVu8zn9Yac4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fg1N4Huh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fg1N4Huh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41D61F000E9;
	Sun, 16 Aug 2026 05:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786859725;
	bh=z91W/pRu/ZnTGcuDy4zh03KFAv4l/s2gPANdNuwm3Iw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fg1N4HuhGmuBFLQqoziAZa7oKU+n3b95rfVGUcw7wXcqxTHhkmCdy6cbHcHUnjoDt
	 VulkrYZzpSxskfy1d//WdjYLDn/+nA9i3A725miOYeUO4cUGkQWO2OB6AA1DbVrgQB
	 VteGVCsarwz6DdCkfGc2vlfcNbCvpnNouJaJdtsqR6BVj1F2qE7epjzB1eNa+sMtLi
	 DMopmyaGkNTWOpkWm1uQjtXRZ1SHvR0nq0U4WOzS2vGOLVJ2fJC8lFsbmOehbYFWLD
	 zZra8hkz0wmkJY6/ntEzQLLupz4XUCAb0A+Qd1o3xcZeg9OzVsKtEWWPWAf7aDkcxd
	 vGjhXxsLWHJTw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/4] KVM: x86: Reset last_steal on vCPU pid change
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dongli Zhang" <dongli.zhang@oracle.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260816053630.527528-2-dongli.zhang@oracle.com>
References: <20260816053630.527528-1-dongli.zhang@oracle.com>
 <20260816053630.527528-2-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 16 Aug 2026 05:55:25 +0000
Message-Id: <20260816055525.A41D61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The patch addresses the steal time corruption on vCPU PID change f=
or x86 KVM PV but completely misses the equivalent KVM Xen steal time (`vcp=
u->arch.xen.last_steal`), leaving it exposed to the identical integer under=
flow.
- [High] The identical vCPU thread migration bug exists in ARM64, RISC-V, a=
nd LoongArch steal time accounting, but the patch only implements the fix f=
or x86.
--

--- Patch [1]: [PATCH 1/4] KVM: x86: Reset last_steal on vCPU pid change ---
commit d7367ba78784ba11d9b540abce98359a8e902828
Author: Dongli Zhang <dongli.zhang@oracle.com>

KVM: x86: Reset last_steal on vCPU pid change

KVM does not reset last_steal on vCPU re-creation/hotplug, causing a bogus
large steal time due to run_delay starting from zero. This patch fixes it by
resetting vcpu->arch.st.last_steal in kvm_arch_vcpu_run_pid_change on x86.

> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 801bf9e520db3..b7cb2ceda6d9a 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -40,6 +40,7 @@ config KVM_X86
>  	select HAVE_KVM_MSI
>  	select HAVE_KVM_CPU_RELAX_INTERCEPT
>  	select HAVE_KVM_NO_POLL
> +	select HAVE_KVM_VCPU_RUN_PID_CHANGE

[Severity: High]
This is a pre-existing issue, but does this same integer underflow bug exist
on other architectures?

Looking at ARM64, RISC-V, and LoongArch, they all track steal time using
current->sched_info.run_delay and subtract the old last_steal value, which
appears identically vulnerable to underflow on vCPU thread recreation.

For example, on ARM64:

arch/arm64/kvm/pvtime.c:kvm_update_stolen_time() {
    ...
    steal +=3D vcpu->arch.steal.last_steal - last_steal;
    ...
}

(Note that arm64's kvm_arch_vcpu_run_pid_change() returns early if
vcpu_has_run_once(vcpu) is true, skipping the opportunity to update last_st=
eal.)

Are there plans to address this on the other architectures?

>  	select VIRT_XFER_TO_GUEST_WORK
>  	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>  	select KVM_VFIO
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 47cb9eba113b1..33be45eec32bc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
[ ... ]
> @@ -3717,6 +3717,13 @@ void kvm_service_local_tlb_flush_requests(struct k=
vm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_service_local_tlb_flush_requests);
> =20
> +int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.st.last_steal =3D current->sched_info.run_delay;
> +

[Severity: High]
This isn't a bug introduced by this patch, but should this function also
reset vcpu->arch.xen.last_steal?

Looking at kvm_xen_update_runstate() in arch/x86/kvm/xen.c, the stolen time
for Xen runstate is calculated similarly:

arch/x86/kvm/xen.c:kvm_xen_update_runstate() {
    ...
    u64 steal_ns =3D run_delay - vx->last_steal;
    delta_ns -=3D steal_ns;
    vx->runstate_times[RUNSTATE_runnable] +=3D steal_ns;
    ...
    vx->last_steal =3D run_delay;
}

If the thread changes and run_delay resets to 0, wouldn't vx->last_steal
also cause an identical integer underflow?

> +	return 0;
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260816053630.5275=
28-1-dongli.zhang@oracle.com?part=3D1

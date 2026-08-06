Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483DD439F60
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 10:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786011365; cv=none; b=ZatO/5CwmsWxBeBt/VTJn8W5VpHCXkmN1dQSALkhvxWosBZaxI9+ZqGsutyN58CVMJBfYRegCG4yp9AjniseMFDe9fuYjuJ7twyZXW0DO6dH/ndT0/n2aejJxGiULHyVVY96piFs98bOplmmm511qLd72wF0505xfNqeacS3Jeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786011365; c=relaxed/simple;
	bh=8byFxbLtHAkuhaNh+hEzusrcMmHS3UnFs4zTDjNBGkc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mI5anwX6XgEoizGiskCBsyvd77GXkL0fUX2553dPv6VE1Z2/Z9LxIQEcdcZLE4QQN2cRM6iyBMT7mhkW8GUt6CPcvqJiyz+lNUA2mnVuRSDGmiJtROjHSZlVZqyKSjjkuhOkVm/DpHh2SXF6U/1y7tZNYFFTaNki9Uv+z71xqjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eVOILT3J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eVOILT3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207261F000E9;
	Thu,  6 Aug 2026 10:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786011360;
	bh=XovcRziraWl/xyurvQbt2xOZQ/19qBLH0drS2MLaASM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eVOILT3JzIXeu02kGx//eQHd6VzH8wq8yClE0kDYMXacNy94XdwB7xh2NKqg09S5Z
	 4jmnW9me2wSrvV/RUnLHG0dmpDmd0QFjLWwg1auNVwdC95pknqd8fVQ39PvlsoUx5i
	 /1pOPyGvRqgAWGAfEwwqXiipvQ/C11Ewvf7bQyKwC+n92v3Hlk9MNI91rCMXbO+k6w
	 gQ8z/9eElbbAjLn0m77/tA9Ca5yQFcEcJdCrMI1gF1k4OWrac1H7dzP809CqsE7PHH
	 7fWG6+w+hkCQMHZhIerPyvwHaMPq0zVUZ4yreP1drxo5aSPXjlIKTkor+debVX7B5C
	 hCASnTqveum7A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 3/4] KVM: arm64: vgic: Do not access the GICv5 CPU
 interface from EL1
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260806100256.371164-4-fuad.tabba@linux.dev>
References: <20260806100256.371164-1-fuad.tabba@linux.dev>
 <20260806100256.371164-4-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 10:15:58 +0000
Message-Id: <20260806101600.207261F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing Context Synchronization Event (CSE) after writing to SYS_I=
CC_ICSR_EL1.
--

--- Patch [3]: [PATCH v1 3/4] KVM: arm64: vgic: Do not access the GICv5 CPU=
 interface from EL1 ---
commit 5b0cdbb37754741e9006b6abdf408b239ed6b887
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: vgic: Do not access the GICv5 CPU interface from EL1

This commit fixes an issue where the GICv5 CPU interface was incorrectly
accessed from EL1 on systems without FEAT_GCIE_LEGACY. It restricts GICv5
access to VHE, similar to the existing GICv3 handling.

> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 74bace10a22ed..df58c0042ed63 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -1042,11 +1042,15 @@ static void vgic_flush_lr_state(struct kvm_vcpu *=
vcpu)
>  static inline bool can_access_vgic_from_kernel(void)
>  {
>  	/*
> -	 * GICv2 can always be accessed from the kernel because it is
> -	 * memory-mapped, and VHE systems can access GICv3 EL2 system
> -	 * registers.
> +	 * GICv3 and GICv5 drive the CPU interface through EL2 system
> +	 * registers, so only VHE reaches them from the kernel. GICv2 is
> +	 * memory-mapped and always reachable.
>  	 */
> -	return !static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) || h=
as_vhe();
> +	if (kvm_vgic_global_state.type =3D=3D VGIC_V5 ||
> +	    static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
> +		return has_vhe();
> +
> +	return true;
>  }

While reviewing the GICv5 access paths related to this change, I noticed a
related issue in the GICv5 context restore path:

arch/arm64/kvm/hyp/vgic-v5-sr.c:__vgic_v5_restore_state() {
    write_sysreg_s(cpu_if->vgic_icsr, SYS_ICC_ICSR_EL1);
}

[Severity: High]
This isn't a bug introduced by this patch, but does this write to
SYS_ICC_ICSR_EL1 require a subsequent isb() instruction?

According to the ARM64 KVM architectural rules, any write to an ICC_*_EL1
register (excluding ICC_PMR_EL1) must be immediately followed by an isb()
as the very next instruction.=20

Because __vgic_v5_restore_state() writes to SYS_ICC_ICSR_EL1 and then
returns, the caller will execute subsequent instructions without a Context
Synchronization Event. Could this leave the CPU operating with an
architecturally undefined pipeline state during the vCPU switch?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806100256.3711=
64-1-fuad.tabba@linux.dev?part=3D3

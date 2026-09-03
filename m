Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A44E37A848
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452743; cv=none; b=W2SSlcoOKS6EQ/A5yuwAGJH/EuJmFB9CVUTtnZVFysvtsoYYRF9OW56mXYmaVgqlq3KnFaCE8AOIwymTlUW2ySg7uV286/DiDmbPo42PVTyD0Ck06BToP8k6GlCu333ubJFi5nTRW+2Lov2M8QzddBAKxeH6f9SDqC/aySQPdOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452743; c=relaxed/simple;
	bh=jZHzcRXBoCov1EOGrgBCafYJ88Lud8s63zfixvZQH+c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=f5yZXLvrzwRgjawV5ktalCenTXp3JqMWpGLxwkYK6Nl5D/g2tjzQ0Ltw+V7mp0hJn1ngM7QVCr16+WCzWRbdNb6zYV+FnzJbQ/CprwbrBlHX1MeioU7QHAEvhvx6JfGspR4kdOC375e8he3xMGNmVpG0+zkebtR5Q01o+mXhn6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gBMiXr1w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gBMiXr1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32DC1F000E9;
	Thu,  3 Sep 2026 16:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788452741;
	bh=kPCJIevEviLvYeGSdCim0SC8oTSSfUr9hTZzCly1YpA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gBMiXr1wQYMVqw+VFaXVpbiR0WILUNW7S8ClJb0d0oZt+M6kByRQmeiZ6zBiYOmmZ
	 0FNXTaCeY6CeQ7ra30MIyRRGd9myBVEIW3WgjplEDHXve3rqmpaggOoQ5C5OYGmGbo
	 xW2Y9vnF6I5YsS9KfER62J7pFD64sqKrpHdU9/KtPI7TRdELaBVWoofFg9o2xJ8iCF
	 MoqOwCSIHPnYteSGkC6A7FphV85j6sJf0fS8CSB1syVFwH71Fabc6l7gbDQcS1Xc84
	 a91qfyHD55ggS16kOH1SedcyYU2KFWjClHpnM+9+provHQKkkpyc/09o2tzeIJfQo/
	 7EXZpOBsIN3zg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: Trap guest MPAM accesses whenever MPAM is
 implemented
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260903160819.831518-1-fuad.tabba@linux.dev>
References: <20260903160819.831518-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:25:41 +0000
Message-Id: <20260903162541.A32DC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] KVM fails to trap guest accesses to MPAM registers when the saniti=
zed MPAM capability evaluates to false (e.g., due to `arm64.nompam` boot pa=
rameter or asymmetric CPU topologies), allowing the guest to directly acces=
s physical host MPAM hardware.
--

commit 4af5e7631ab3a7072311a3251a8c2768e198ef2e
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Trap guest MPAM accesses whenever MPAM is implemented

This patch updates KVM to trap guest accesses to MPAM registers based solely
on the ID registers rather than the ARM64_MPAM capability, which also
requires MPAMEN to be set.

Link: https://lore.kernel.org/all/CA+EHjTxeWxZiuSmnKLGLxTBXP4oJT7-LuffbPAyC=
SZZ5TW=3D5Ew@mail.gmail.com/

> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeatur=
e.c
> index 17b83a2518a8f..36a27692e5cf7 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2501,6 +2501,13 @@ test_has_mpam(const struct arm64_cpu_capabilities =
*entry, int scope)
>  	return (read_sysreg_s(SYS_MPAM1_EL1) & MPAM1_EL1_MPAMEN);
>  }
> =20
> +static bool
> +test_has_mpam_sysregs(const struct arm64_cpu_capabilities *entry, int __=
unused)
> +{
> +	/* The registers exist whether or not firmware enabled MPAM. */
> +	return detect_ftr_has_mpam();
> +}
> +

[Severity: High]
This isn't a bug introduced by this patch, but it appears to be a
pre-existing issue. Does relying on detect_ftr_has_mpam() here leave the
physical MPAM hardware exposed?

The detect_ftr_has_mpam() function checks the sanitised CPU feature
registers. If the host is booted with the arm64.nompam parameter, or on
systems with asymmetric CPU topologies where the boot CPU lacks MPAM, this
check will evaluate to false even if the physical hardware on the current
CPU implements MPAM.

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp=
/include/hyp/switch.h
> index 1ce7130e25490..8941335724f6b 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -298,7 +298,7 @@ static inline void  __activate_traps_mpam(struct kvm_=
vcpu *vcpu)
>  	u64 clr =3D MPAM2_EL2_EnMPAMSM;
>  	u64 set =3D MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
> =20
> -	if (!system_supports_mpam())
> +	if (!system_supports_mpam_sysregs())
>  		return;
> =20
>  	/* trap guest access to MPAMIDR_EL1 */

[Severity: High]
This is also part of the pre-existing issue mentioned above.=20

When system_supports_mpam_sysregs() returns false due to the sanitised
feature registers, this early return skips setting the TRAPMPAM0EL1 and
TRAPMPAM1EL1 trap bits in SYS_MPAM2_EL2.

Since the hardware traps remain disabled, could this allow a malicious
guest to directly access physical MPAM configuration registers (such as
MPAM0_EL1) and bypass hypervisor isolation? This might allow the guest to
manipulate host cache and memory bandwidth partitioning, potentially
causing a denial of service against the host or other VMs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160819.8315=
18-1-fuad.tabba@linux.dev?part=3D1

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66213AF676
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784568997; cv=none; b=f/KscR+t8bmwAOa5NmM9Meh+WGi1jU4IlO+VbwRkWhubZFBy0ApOPVGfWy9xg7Ec2tgbaiTple5jM6rzxi0M0HOJXnW01Y5Cidc8UWKUPMUST2s03upThqHNQTBAfNt+1hh40azeLgeLAwXyxQti6Cd2OXCM9Wwhikyx2iYItoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784568997; c=relaxed/simple;
	bh=lOWwaV6mRqfscKrngK6TfUq1Z5QT9EX6UE4RWpIlweg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=K/P8uqhP2NBqKA1GG9JPdNj66G6QNyz+bencdhFrZ+zGnJEVmz5igtzCIcpa+jinAx0SMEUbEf1cWjx5Z8HV07PCeOdVmtouHSsyN1+9G30YORzS+js+ildT19R96EAOab9UzOGS9yrPpn770XpiFKQ6O+2hRd28bux/VMsnP+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZEnmP3j3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZEnmP3j3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338151F000E9;
	Mon, 20 Jul 2026 17:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784568996;
	bh=kP55Ssm1zwgse01OQ2RUiggVl+uvrynpuA7yT3PyODU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZEnmP3j3szYb+YFEmZWydy7M4VyZN1CEz6RkZniSxcc6JXglokPTZWaGwZzvXwBjs
	 mDk8cHLWaWmWlUnI0LWWFI5eOtR3zr5bqElWO2VGkaCGduLs6ZYABb0bd86aNQskO1
	 +YJpepXgvVa9sBu/Ww3H7F/tdDLX0BlDW5MwaF4OHK544eRS/jvYtTDN+aic4RRwP7
	 KBbQmauOT+WhRxKBGJoMtT7aPcsluKqr/rqve6UKe4oUXaPviHCp5eonnGet8OJmih
	 VyPTVTewupeVauEpv0gmB2LCTmvDAmwwExmENTiH7sswA/o8wRz9i//RvXiBAQbyqi
	 yQE3yMOoBfFhQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 07/17] KVM: arm64: Add PKVM_HYP_REQ_HYP_ALLOC request
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260720171513.1415357-8-vdonnefort@google.com>
References: <20260720171513.1415357-1-vdonnefort@google.com>
 <20260720171513.1415357-8-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 17:36:35 +0000
Message-Id: <20260720173636.338151F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `__pkvm_hyp_topup` hypercall is placed in the always-on band=
 rather than the pKVM-only band.
--

--- Patch [7]: [PATCH v3 07/17] KVM: arm64: Add PKVM_HYP_REQ_HYP_ALLOC requ=
est ---
commit 81cda010af35643b23cac0204f67a6bcf2085291
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Add PKVM_HYP_REQ_HYP_ALLOC request

Introduce a new pkvm_hyp_request type asking the host to top up the pKVM
heap allocator.

> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kv=
m_asm.h
> index 043495f7fc78b..b77acfd7d1c8a 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -89,6 +89,7 @@ enum __kvm_host_smccc_func {
>  	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
>  	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
>  	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
> +	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_topup,
> =20
>  	MARKER(__KVM_HOST_SMCCC_FUNC_PKVM_ONLY),

[Severity: Medium]
Should this hypercall ID be placed after the PKVM_ONLY marker?

By placing it before MARKER(__KVM_HOST_SMCCC_FUNC_PKVM_ONLY), it becomes an
always-on hypercall. If it were called in standard nVHE mode or before pKVM
finalization, it would access uninitialized pKVM heap allocator state, which
could potentially crash the hypervisor.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index d3c69de698f48..439b91fc8aecf 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c

[ ... ]

> @@ -740,6 +765,7 @@ static const hcall_t host_hcall[] =3D {
>  	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
>  	HANDLE_FUNC(__vgic_v5_save_apr),
>  	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
> +	HANDLE_FUNC(__pkvm_hyp_topup),
> =20
>  	HANDLE_FUNC(__pkvm_host_share_hyp),
>  	HANDLE_FUNC(__pkvm_host_unshare_hyp),

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720171513.1415=
357-1-vdonnefort@google.com?part=3D7

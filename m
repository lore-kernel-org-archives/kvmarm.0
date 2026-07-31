Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE75326928
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 14:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785509537; cv=none; b=M5cJt+sM/1AiV3ixyyqEr5Z/Yzz4dNq+xi0t8lY8W+s0rUCSw/hFj5eKdfZDmAveDKXdffmls1UP05EhhYcXugGhoIE8tMZtAmK/0/Z+NxOs87Ay/THGif9Z5x4QTGjkUvkjpd+wIxg6k98wWmbpez+2Q3QRS+7tMmPeJU9/nyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785509537; c=relaxed/simple;
	bh=GdRoDxHI0CJJUVxImPMWVV2Sdi5QUknbHx/MjU4SNNY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hlZga6UAtkGXREIxQ7TdsekgxEAIF571g4C9dQx7J2TvDztzx3kpBmV1ZMxxIAiq1/zIAGm6ADj2vwGbg4pieirFEXM+m/bMDUkII9J1McycSiE1Xx2h77OJrwpNbyCFtj3/+19CJVBr8ivnJI3nPl/cB1XwLK/Wap95o5dsoMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UpZF5aYv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UpZF5aYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1AB01F000E9;
	Fri, 31 Jul 2026 14:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785509535;
	bh=t4OyjhMz/HbTg8Nk1dKpY6fZdu7ciZ97Xq9HKfsEzzE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UpZF5aYvltwFBhiZ9d1viJHT3to4F2tEWDM9qitV2t1T37YyeTU1SKriBGZhk19Pb
	 MwOPJ6vmctDyw475z9q8vfrp7eV8/uGbEWbpOUBObMyh+MAloYsSY6bbeoxgzVDMLF
	 bpl2AJ8GCTesTz7hw93JxoaI7CyfGPvlQvlqRw+YBkMmp6AeppBCvT2eRha7YfG4+7
	 4nP6RX8KubW+7DKwATqiChR77s4g1K1hr0dIUiM8KicaBozOeGPLlFM7tzR4b7bi7G
	 mS5gJSybSSF8uT0jizfcVzsrbirK32p8vscySwVLFIDev3AQX7laBi3TL1oHcKMAk7
	 /qyH1ZIVFfC2g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 07/17] KVM: arm64: Add PKVM_HYP_REQ_HYP_ALLOC request
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260731143541.956291-8-vdonnefort@google.com>
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-8-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 14:52:15 +0000
Message-Id: <20260731145215.A1AB01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The __pkvm_hyp_topup hypercall is incorrectly placed in the alwa=
ys-on band, making it reachable in standard nVHE mode.
--

--- Patch [7]: [PATCH v4 07/17] KVM: arm64: Add PKVM_HYP_REQ_HYP_ALLOC requ=
est ---
commit c7805b75faa5ebe4c309f41eb0346f2ae0a468dd
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
Should __KVM_HOST_SMCCC_FUNC___pkvm_hyp_topup be placed after the
__KVM_HOST_SMCCC_FUNC_PKVM_ONLY marker instead of before it?

Placing it here in the always-on band makes it reachable in standard
nVHE mode or before pKVM is finalized. If the host kernel executes this
hypercall during those phases, it could attempt to invoke
hyp_alloc_topup() against uninitialized pKVM heap structures, potentially
causing a hypervisor panic.

[ ... ]

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

[Severity: Medium]
Does this handler registration also need to be moved to mirror the
enum placement in the finalized-only band?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731143541.9562=
91-1-vdonnefort@google.com?part=3D7

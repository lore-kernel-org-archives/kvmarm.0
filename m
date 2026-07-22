Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFB54C97;
	Wed, 22 Jul 2026 08:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784709174; cv=none; b=uUGzkXal5XnSbaAABIgbQa9BchzcVb+PrYNCdIXI7/LZdr9aH9Ay+w1+5Ex1G2dNMNwOhlalfC3wRWRVhsl5h3vESsptYq0N54yK5NqsRFLF5f2XmfgbbgAH4fQqXKi6lYFlj4PAi7pvRpASEhd9SqxvcwAgKtw/t13UylZPOg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784709174; c=relaxed/simple;
	bh=sH809wSkYURPMlkYvqabuFBTR+xCwZRhfApQ5r6cb4w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=g+9VRDJDjBvTI86FC2Rq/wxGmAFqOdCZl5vbAfuMF7XVPWMuYiEKHvVB0tiDPGEguCFXb1BbXRqgI8w12y6A8rl1EwGdrXM8nruZSOA7RVQ3O2bd0bxNcWUA5o40gmsUaHIXt1d60P0mkVO+IGizPX7CHjWJujtUj8IJnK1Fjq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mTVF5/az; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mTVF5/az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3351F000E9;
	Wed, 22 Jul 2026 08:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784709173;
	bh=iEGPn/5CCt/KNZY7SptrV5aWQBYfYqXR6JoJu2HxlAw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mTVF5/azZw2zXLNWRN8TNRJZyonRrZ/oxcopogprruZmLcbhVKaiWPwi5ElUiqYhN
	 Tuvbnj5+5DshdL0iXf/eIp3qU30cEEW8sP17bExB8IuWMFV1AbxxZSMfAW1hXRDqRP
	 qelC0HZL82kTu0TNzCtaiWGGPK6wc5H11FHADynKP9SoukBP7gL/gfMP1HLRYy63dC
	 QHXFt7oGFTzKqo7kHnmtL4NH82jh3dRgekzxcTGyXNJMHxc/kB/kzgVzg+fq521Tvy
	 emsQoS5Jm8V0aSCadStU9m0jq6a5jKUS2VeSacAIFmZKOuEbcLma2P3xXf5tMRXkbU
	 bZ4Ed77e/3pPQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 11/28] KVM: arm64: Expose FEAT_NV2p1 to NV guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260722074234.3330999-12-maz@kernel.org>
References: <20260722074234.3330999-1-maz@kernel.org>
 <20260722074234.3330999-12-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 08:32:52 +0000
Message-Id: <20260722083253.1F3351F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The ARM64_HAS_NV2P1 CPU feature capability is checked dynamicall=
y to enable FEAT_NV2p1 logic in KVM, but the capability is never registered=
 in the kernel's CPU feature framework, rendering the new feature entirely =
dead code.
--

--- Patch [11]: [PATCH v3 11/28] KVM: arm64: Expose FEAT_NV2p1 to NV guests=
 ---
commit 2bb48d2c7459805b9d877b250f95afb9c6786a43
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Expose FEAT_NV2p1 to NV guests

This commit exposes the FEAT_NV2p1 feature to nested virtualization guests =
by
updating the ID_AA64MMFR4_EL1 register limits when the hardware capability =
is
present. This intends to reduce the number of traps for NV guests.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index fb54f6dad995c..82be8bcb07035 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
[ ... ]
> @@ -1738,7 +1738,11 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 =
val)
>  		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features)) {
>  			val =3D 0;
>  		} else {
> -			val =3D SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY);
> +			val &=3D ID_AA64MMFR4_EL1_NV_frac;
> +			if (cpus_have_final_cap(ARM64_HAS_NV2P1))

[Severity: Medium]
Is ARM64_HAS_NV2P1 registered in the kernel's CPU feature framework?

It appears that the ARM64_HAS_NV2P1 capability is missing from the
arm64_features array in arch/arm64/kernel/cpufeature.c. Because it is not
mapped to a hardware ID register field, this capability check in
limit_nv_id_reg() will always evaluate to false.

Does this render the newly added FEAT_NV2p1 support unreachable?

> +				val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR4_EL1, NV_frac, NV2P=
1);
> +			else
> +				val =3D SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY);
>  			val |=3D SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, E2H0, NI_NV1);
>  		}
>  		break;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722074234.3330=
999-1-maz@kernel.org?part=3D11

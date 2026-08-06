Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B343ED3B3;
	Thu,  6 Aug 2026 09:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786008954; cv=none; b=TV+vsxjS5qMo+Wj9DE/iAwe4KIUqx/k+adxWg+r4dk0eGWkLQx17uinokAX/r+ncZOtfASXWuwIFfVzYPUZsUQOmYoqYdVsGQLM2rCExFn+7k8qdyRRyrG/LcmC3d4kqNDG+fls4Iyeg/yE9mH5RiBUcfvNdr5mABVmh9bPY4IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786008954; c=relaxed/simple;
	bh=KbwxlGICKFXhHrYvbv54R8rJFBMxY0dH5agXYHQbRGc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mG+gBu9oXVJuwZfnDYmxAY9jOCeXO2MYGrt4dv+m+4m/hthnDFuaUnBg2Facb7XIM+ejBfehaKfAJbFsJF5hbYAIrBImmFEKbyoBy04bpqlwByMHXuDmYjj3MOh0NYNKKudrfhYvv0Rts/F1CEQLrefdOc94DmTVw30K89Fo+Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A377F1om; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A377F1om"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F4B1F00A3A;
	Thu,  6 Aug 2026 09:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786008953;
	bh=6XrKrsZiqomYZfhCqpUHERezyM0DCfcB71KnYkpRsE8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A377F1omUPUOI9j5MGHi6HzZVSsiOujuLHkltaUzMp/zzA7zqv038wBiYfIpTD7UT
	 W7RNBKe7GajcHUcqtSNpU1XMuPt5G1cpM4+pOHJjs6lBrTrltbN+WD7dH5jDOJVCtG
	 IHag1/RATS4/oywPBGXDbhOJ4xDv7IBgse+Oa+K4Ms0ec5dT4L6KfDzmGmtM0PuIym
	 aXy1rEK9Cb2u8Pfq7fj+qhkKcXpQV3sOgbBb7bPFOM6YusLSFlRJDy7U2NYdfYNoGt
	 u6njQ+vr/USD22HfEie1A6xuNhs7La2iMrMu0TaIOBLixoYVGuAwVYMtjc0eIDeFMF
	 XshcmfWnHDDZw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 8/8] KVM: arm64: Add VNCR TLB tracking again
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260806091026.620700-9-maz@kernel.org>
References: <20260806091026.620700-1-maz@kernel.org>
 <20260806091026.620700-9-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 09:35:52 +0000
Message-Id: <20260806093552.C9F4B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The fast-path TLBI handler incorrectly skips the slow path for nat=
ive EL2 TLBI instructions when E2H or TGE is clear, bypassing software VNCR=
 TLB invalidation and leaving stale mappings.
--

--- Patch [8]: [PATCH v2 8/8] KVM: arm64: Add VNCR TLB tracking again ---
commit 65741607ee5db3e8d57cf0e1773bb1031e83a3ee
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Add VNCR TLB tracking again

This commit introduces a VM-wide counter to track valid VNCR TLBs. It aims
to improve performance by taking the TLBI slow path only when there are
active VNCR TLBs that need invalidation.

> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/swi=
tch.c
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
[ ... ]
> @@ -424,10 +424,15 @@ static bool kvm_hyp_handle_tlbi_el2(struct kvm_vcpu=
 *vcpu, u64 *exit_code)
>  		return false;
> =20
>  	/*
> -	 * If we have to check for any VNCR mapping being invalidated,
> -	 * go back to the slow path for further processing.
> +	 * If we have to check for any VNCR TLB being invalidated, go back
> +	 * to the slow path for further processing.
> +	 *
> +	 * The synchronisation betweem TLBI and walk is provided by the
> +	 * speculative increment of the TLB counter on walk, and the
> +	 * invalidation counter. Yes, this is fiddly.
>  	 */
> -	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu))
> +	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu) &&
> +	    atomic_read(&vcpu->kvm->arch.vncr_tlb_count))
>  		return false;

[Severity: High]
This is a pre-existing issue, but does this condition incorrectly skip the
slow path for native EL2 TLBI instructions when E2H or TGE is clear?

If a nested hypervisor running in nVHE mode (E2H=3D0) or temporarily cleari=
ng
TGE executes an S1E2 TLBI instruction, kvm_hyp_handle_tlbi_el2() will execu=
te
the hardware TLBI. However, since the fallback check requires both E2H and =
TGE
to be set, it evaluates to false. This returns true and bypasses the softwa=
re
VNCR TLB invalidation.

Should the check instead read atomic_read(&vcpu->kvm->arch.vncr_tlb_count)
unconditionally for any successful EL2 S1 TLBI so that stale software VNCR
mappings aren't left behind?

> =20
>  	__kvm_skip_instr(vcpu);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806091026.6207=
00-1-maz@kernel.org?part=3D8

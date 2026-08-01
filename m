Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1779B48987E;
	Sat,  1 Aug 2026 13:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785589496; cv=none; b=SsyJvEo731n4yB8/AnWUqdfTlPMptc3wiVLGfwZeLoH1yPf6Kqy6VVorHc9KzgO+3/zhug3Xu2TfVOA69EuJzN7/zuNoO/UaRoCz4eZxWDfmEJBfn6J566G7o0sgz2YBzGqaKgx8BIVpLxXrV31rJd8yjfj6+LEn2WY+mFjQQSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785589496; c=relaxed/simple;
	bh=QDSobYaFNB+LTZfIP2XhkTTQNd0oBaXQUBz15SpTzR8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=d4EdCIqO1w8AQI86jM9BB6EfeLIkTbHrYAxO4SEBPfi51JnBRjYi/Z+Z2f0OywKaeLXu27gmCawHxn7oqZxEIzf4w2mL9xaZXe4OTQVByyqK9ebMcq+o8s1QYYKVsGs3xlrK2snbrGbJKojL+5Jasmo3mBS38ToEj2QioN32DQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f4e2hUlE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f4e2hUlE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9F11F00AC4;
	Sat,  1 Aug 2026 13:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785589494;
	bh=AfxE/12yI14QEgsNJxYP3yxweqYsFFxRxPcTDSeDpu4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f4e2hUlEOMGi0XCPxyZK+Hobqgko2lbWyclC8367jn+90xDKRXTzN2/SbIXullTfn
	 s/bw8zDHQSjwBU388kurjOUkjmpfTbOWf9HjsAbVR/a1mXE59ZRFGwI8ekpCsOWwdC
	 JWAuF+Fc5YPGZQAf2v2r3elRE/XTgIqWbyMcxddM63+/wESeqFj/5oFPYLsVubfwOp
	 jRiAW90gL47sg2z1QhvYvpV/XyWrJLni5fUQddbvxGCVcgHSsvl3/gRTaUMi78NQYJ
	 n/d3V/J4HqjQA//Jd4XLHaJanXQn1u4PUWod6zOvCSD08M2LPYvMTKzn9uQcTexREF
	 p9fc0GCxp1AkQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/6] KVM: arm64: Add VNCR TLB tracking again
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260801124818.366274-7-maz@kernel.org>
References: <20260801124818.366274-1-maz@kernel.org>
 <20260801124818.366274-7-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 13:04:53 +0000
Message-Id: <20260801130454.5D9F11F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Cross-CPU invalidation of VNCR TLBs (e.g., via MMU notifiers) =
clears the fixmap and resets `vt->cpu` but fails to clear the per-CPU `L1_V=
NCR_MAPPED` flag on the CPU where the vCPU is running. When the vCPU is sub=
sequently scheduled out, `this_cpu_reset_vncr_fixmap()` checks the local fl=
ag, finds it set, and hits a `BUG_ON` because `vt->cpu` is `-1`. This allow=
s unprivileged host userspace to panic the host kernel.
- [High] The fast-path check in `kvm_hyp_handle_tlbi_el2()` skips VNCR TLB =
invalidation for EL2 TLBI instructions when `E2H` or `TGE` is 0, leaving st=
ale translations in the software VNCR TLB.
- [High] A TOCTOU race exists between lockless guest page table walks and g=
uest TLBI intercepts, allowing stale VNCR translations to survive invalidat=
ion.
--

--- Patch [6]: [PATCH 6/6] KVM: arm64: Add VNCR TLB tracking again ---
commit bde680578e8485472440ba4858d93cb92173897d
Author: Marc Zyngier <maz@kernel.org>
Date:   Sat Aug 1 12:48:18 2026 +0000

    KVM: arm64: Add VNCR TLB tracking again
   =20
    This patch re-introduces VNCR TLB tracking to force EL2 S1 TLBI handling
    onto the slow path when valid VNCR TLBs exist. It uses a VM-wide atomic
    counter to track the presence of valid VNCR TLBs, updating it under the
    MMU lock.

> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/swi=
tch.c
> index c09b1d411c584..eb59549ec2172 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -424,10 +424,11 @@ static bool kvm_hyp_handle_tlbi_el2(struct kvm_vcpu=
 *vcpu, u64 *exit_code)
>  		return false;
> =20
>  	/*
> -	 * If we have to check for any VNCR mapping being invalidated,
> +	 * If we have to check for any VNCR TLB being invalidated,
>  	 * go back to the slow path for further processing.
>  	 */
> -	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu))
> +	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu) &&
> +	    atomic_read(&vcpu->kvm->arch.vncr_tlb_count))
>  		return false;

[Severity: High]
This isn't a bug introduced by this patch, but does this check skip VNCR TLB
invalidation for EL2 TLBI instructions when the guest is in nVHE mode?

If a guest running with E2H=3D0 changes its EL2 page tables for the VNCR_EL2
mapping and issues an EL2 TLBI, this condition evaluates to false.

The fast-path will return true, skipping the slow path that would normally
handle the invalidation. Could this leave stale translations in the software
VNCR TLB?

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 8d5b0208ad728..2a7dd9f9fb597 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
[ ... ]
> @@ -998,9 +999,11 @@ u16 get_asid_by_regime(struct kvm_vcpu *vcpu, enum t=
rans_regime regime)
>  	return asid;
>  }
> =20
> -static void invalidate_vncr(struct vncr_tlb *vt)
> +static void invalidate_vncr(struct kvm *kvm, struct vncr_tlb *vt)
>  {
> +	BUG_ON(!vt->valid);
>  	vt->valid =3D false;
> +	atomic_dec(&kvm->arch.vncr_tlb_count);
>  	if (vt->cpu !=3D -1)
>  		unmap_l1_vncr(vt);
>  }

[Severity: Critical]
This is a pre-existing issue, but does this cross-CPU invalidation path lea=
ve
the per-CPU L1_VNCR_MAPPED flag set locally?

If an MMU notifier on CPU B calls kvm_invalidate_vncr_ipa() which reaches
invalidate_vncr(), unmap_l1_vncr() will clear the fixmap and set vt->cpu =
=3D -1.

When CPU A (which was running the vCPU) exits the guest and calls
this_cpu_reset_vncr_fixmap(), won't it see its local L1_VNCR_MAPPED flag st=
ill
set and trigger BUG_ON(vcpu->arch.vncr_tlb->cpu !=3D smp_processor_id()) be=
cause
vt->cpu is now -1?

[ ... ]
> @@ -1460,6 +1471,8 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu=
, bool *is_gmem)
>  		vt->valid =3D true;
>  		vt->cpu =3D -1;
> =20
> +		atomic_inc(&vcpu->kvm->arch.vncr_tlb_count);
> +
>  		kvm_make_request(KVM_REQ_MAP_L1_VNCR_EL2, vcpu);
>  		kvm_release_faultin_page(vcpu->kvm, page, false, vt->wr.pw && vt->hpa_=
writable);
>  	}

[Severity: High]
This is a pre-existing issue, but is there a time-of-check to time-of-use r=
ace
between the lockless guest page table walk and guest TLBI intercepts here?

CPU1 locklessly resolves the guest virtual address via __kvm_translate_va()
earlier in kvm_translate_vncr().

Before CPU1 acquires the mmu_lock and increments vncr_tlb_count, CPU2 could
modify the guest page table and issue a TLBI.

The TLBI on CPU2 would see vncr_tlb_count =3D=3D 0 (or vt->valid =3D=3D fal=
se) and
complete. CPU1 would then acquire mmu_lock, pass the mmu_invalidate_retry()
check (which only tracks host MMU notifiers), and install the stale
translation.

Could this result in caching a stale VNCR mapping?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801124818.3662=
74-1-maz@kernel.org?part=3D6

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2386E52D2C5;
	Tue,  8 Sep 2026 16:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788886772; cv=none; b=FR5eLBaW/G6GqRWd/IpmevIil0hKCfLJPOenAtP/cpNLdAtPmdzSinrSpTjB/YfKtoeiAO1TQp8Cp0bwtaOFDgRTaWohfEAMCMUSj6eFQkmgx3rfpOt8CNQEEfek8UwMF3jWt1qdDdRV06yLU9CdbAFq28kdeDJEC/CO+xBvm6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788886772; c=relaxed/simple;
	bh=EpIin4myBYV02c3Z+bx/t2OVLrwt099/BwdetDcIpqQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=j6EAd44gkEG7OVbhp5jxmE78V1IggmgfaKmWK5iPUiUjpcsdfxK/gDCEooSegUP8asRTuF4nzlphnxomFLfBzVPq828W8KIr6NXVZX/VTL8qiL4zUaPOH2GJiECk+SxO3xTLrtr9BMWBm50UArn3T6LGd9lLpR5keVUQb48qWIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wie+Vm21; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wie+Vm21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561841F00A3A;
	Tue,  8 Sep 2026 16:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788886770;
	bh=8/KtpTFKvUWRLhTMuPej1s/OU7YPlFaQBklVy6chUL8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Wie+Vm21dKWSnQbRcjkyHFMOQZB29JhWrt1WrEv/N3PGGOQzUCHA3Aka6EzLX1LX3
	 m5djFjt79t3ynI2IjfSN837yO8+mwMvvAd7Bofg+aICjax6Vu7jGfR0iGvtv2YCD+N
	 ZePZrjqdaG8+hw8qTEXM1MM9ClUDDQgssr2fp+SacMiflLJZ37wbxZqOse981n29Me
	 Y2XMtUG9rMec+T1jkwRgsjruYnSAk0m7p7cTcLv1jSE1gqLce6K+oUzdj90nDMBR5r
	 FMIVAccDkbMLMwwZuuInzX/NtRyieAQFl69mrYtTsF+MH9YuWJrRuK7HUHPmjxdRR1
	 bKGzRzrrDX6zQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 19/20] KVM: arm64: Add VM specific callback for S2
 MMU operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260908162223.1683432-20-suzuki.poulose@arm.com>
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-20-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 16:59:29 +0000
Message-Id: <20260908165930.561841F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] Mismatch between forward declarations and definitions of pKVM =
S2 MMU operations structs causes KVM to silently skip critical memory manag=
ement and TLB flush operations.
- [High] `kvm_arch_flush_remote_tlbs_range` incorrectly returns 0 when the =
callback is NULL, bypassing the full TLB flush fallback mechanism.
- [Low] The `type` parameter in `kvm_vm_init_vm_s2_ops` is entirely unused.
--

commit 31d5dcbadc8339bf6a74dc7f2dc04dbc627760d7
Author: Suzuki K Poulose <suzuki.poulose@arm.com>

KVM: arm64: Add VM specific callback for S2 MMU operations

Add VM type specific S2 MMU operation backends which can be initialized per=
 VM
flavor, to keep the handling cleaner.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 67852acf7a6f8..e78a56fb73696 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
[ ... ]
> @@ -174,26 +190,36 @@ static bool memslot_is_logging(struct kvm_memory_sl=
ot *memslot)
[ ... ]
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
> +				     gfn_t gfn, u64 nr_pages)
> +{
> +	if (!kvm->arch.vm_s2_ops->vm_flush_remote_tlbs_range)
> +		return 0;

[Severity: High]
Should this return an error code like -EOPNOTSUPP instead of 0?

By returning 0 (success) when the callback is NULL, the core KVM
implementation in kvm_flush_remote_tlbs_range() will assume the flush
was successful and skip the fallback to a full TLB flush
(kvm_flush_remote_tlbs). This regression can lead to stale TLB entries
if a VM flavor explicitly omits the range callback.

> +
> +	return kvm->arch.vm_s2_ops->vm_flush_remote_tlbs_range(kvm, gfn, nr_pag=
es);
> +}
[ ... ]
> @@ -963,6 +996,18 @@ static void kvm_stage2_destroy(struct kvm_pgtable *p=
gt)
>  	KVM_PGT_FN(kvm_pgtable_stage2_destroy_pgd)(pgt);
>  }
> =20
> +static const struct kvm_vm_s2_ops *arm64_vm_s2_ops[VM_FLAVOR_MAX] =3D {
> +	[VM_VHE] =3D &kvm_default_vm_s2_ops,
> +	[VM_NVHE] =3D &kvm_default_vm_s2_ops,
> +	[VM_PKVM] =3D &unprotected_pkvm_s2_ops,
> +	[VM_PROTECTED_PKVM] =3D &protected_pkvm_s2_ops,
> +};

[Severity: Critical]
Is there a mismatch in the struct names for the pKVM operations?

This array uses unprotected_pkvm_s2_ops and protected_pkvm_s2_ops,
but the actual populated structs defined at the end of this file are
named pkvm_vm_s2_ops and protected_vm_s2_ops.

Because of this mismatch, the array points to the zero-initialized
tentative definitions instead of the populated ones, meaning all function
pointers for pKVM guests will be silently NULL. This skips operations like
stage-2 unmapping, which could lead to stale TLBs and unmapped host memory
access.

> +
> +static void kvm_vm_init_vm_s2_ops(struct kvm *kvm, unsigned long type)
> +{
> +	kvm->arch.vm_s2_ops =3D arm64_vm_s2_ops[kvm->arch.vm_flavor];
> +}

[Severity: Low]
Is the type parameter intentionally ignored here?

The function is passed type from kvm_init_stage2_mmu() but directly queries
kvm->arch.vm_flavor instead, leaving the parameter entirely unused.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908162223.1683=
432-1-suzuki.poulose@arm.com?part=3D19

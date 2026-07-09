Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399773EF66B;
	Thu,  9 Jul 2026 11:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783595662; cv=none; b=iHYCY/Qze4YtOkAsF+AxkBiyKjISTdPqSmxZbxD3EkfOVPuw+8gqi2rGAJh/6k3SyqLGZgmrn/z1gAwUUZh6Ux0YFy1qY+f4x+Y0hMJTIzzVDc0dMKefqiGEjO7mXU8G1vQoEAdwtPq/VmVQ2C+/40XhJGEH3xBO+3snrCvUds0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783595662; c=relaxed/simple;
	bh=uZ2QblxdpDN30sCIstqWeYt+isziiGDJbqYHlgtLJYU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rDbe6KLDf82j/9sQv43e2KpD6iJ2WVyuUaPJ4OSg8258c0rhFZgwZL6+kw9ig1raQWUq+wycOetGaNqK+bUmSdC4MLFxOk9/6o3TssKjCnqKH8VCGoQWxThFzRzMZCbgY3nhgATHol5tVRXSwivUzaJc6v7AqkdU3tEGR8b1OJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o2e1W8Z+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o2e1W8Z+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCF01F00A3A;
	Thu,  9 Jul 2026 11:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783595661;
	bh=djGMkeSZMVNpXC6MEek7XuwalUgtosWGMzH2yUvE9ew=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=o2e1W8Z+ALpudGs/pw2ZIeOivQ1XryGHF50i4S41UfOZswIxnvLpEgUwC2dFlMXqb
	 di7t9WXqPJbHdcfWQ6JRsjBnntJwfb9FXkVJuVeJ3EkPUYMzH4o3Gq/MrxUY16GTML
	 TIGjna06iqXYM2sVPlCpzAiuUUGMj8Lh9aoZAqrEgRCuwopvVUXMMm+uoxgPZ0F1i9
	 0uE9KAO+PEbRE6AookpZwGUyM2NdC22C6xV5GQK9zFw4dvFv9OvzjMHR82FD3JlEpZ
	 nww8diTkw0f1Rak6XxfCGCMddHLejtnwzhevk9Khb5CQ6/TzfI1ujG7Kvm2aesiHwd
	 dpK0jnMMvENsQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 3/6] KVM: arm64: Add auto DBM support for hardware
 dirty tracking
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tian Zheng" <zhengtian10@huawei.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260709104026.2612599-4-zhengtian10@huawei.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
 <20260709104026.2612599-4-zhengtian10@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 09 Jul 2026 11:14:19 +0000
Message-Id: <20260709111420.CFCF01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] kvm_pgtable_stage2_wrprotect() fails to clear the DBM bit, all=
owing hardware to silently bypass KVM's dirty page tracking.
- [Medium] VTCR_EL2.HD is never set, rendering the hardware auto-DBM featur=
e inactive.
- [Medium] DBM is never enabled for VMs running under protected KVM (pKVM) =
because the hypervisor initializes stage-2 page tables with flags=3D0.
--

--- Patch [3]: [PATCH v4 3/6] KVM: arm64: Add auto DBM support for hardware=
 dirty tracking ---
commit abb55a98f1d8a61624044b5be480dccd88753db2
Author: Tian Zheng <zhengtian10@huawei.com>
KVM: arm64: Add auto DBM support for hardware dirty tracking

This patch introduces support for the ARMv8.1 Dirty Bit Modifier (DBM)
attribute in KVM. It allows hardware to automatically promote write-clean
pages to write-dirty without trapping to EL2. The DBM behavior is controlled
via a new page-table level flag KVM_PGTABLE_S2_DBM.

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 91a7dfad66866..21ec456ecc411 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1367,9 +1381,26 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgta=
ble *pgt, u64 addr,
>  	if (prot & KVM_PGTABLE_PROT_R)
>  		set |=3D KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> =20
> -	if (prot & KVM_PGTABLE_PROT_W)
> +	if (prot & KVM_PGTABLE_PROT_W) {
>  		set |=3D KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> =20
> +		/*
> +		 * No DEVICE filter needed here: relax_perms is only called
> +		 * on FSC_PERM faults. Device pages always get full RW from
> +		 * initial mapping and are never write-protected during
> +		 * migration, so they never trigger a permission fault.
> +		 */
> +		if (pgt->flags & KVM_PGTABLE_S2_DBM)
> +			set |=3D KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> +	} else {
> +		/*
> +		 * Clear DBM on W=E2=86=92RO downgrade to prevent hardware from
> +		 * silently upgrading RO+DBM back to W+dirty, which would
> +		 * bypass KVM's write tracking and cause data corruption.
> +		 */
> +		clr |=3D KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> +	}

[Severity: Critical]
The commit message mentions clearing DBM on W->RO downgrade. Should this lo=
gic
be in kvm_pgtable_stage2_wrprotect() instead?

kvm_pgtable_stage2_relax_perms() is used for resolving permission faults, n=
ot
for bulk W->RO downgrades. Meanwhile, kvm_pgtable_stage2_wrprotect() clears
the KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W bit but misses clearing the newly introd=
uced
DBM bit:

arch/arm64/kvm/hyp/pgtable.c:kvm_pgtable_stage2_wrprotect() {
    ...
    return stage2_update_leaf_attrs(pgt, addr, size, 0,
                                    KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
                                    NULL, NULL,
                                    KVM_PGTABLE_WALK_IGNORE_EAGAIN);
}

If DBM remains set on a read-only PTE, won't hardware with HDBSS enabled
automatically upgrade the PTE back to writable upon a guest write, bypassing
the stage-2 permission fault and causing data corruption during live migrat=
ion?

[ ... ]

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index e086c01a9325e..346efed6e6050 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1014,6 +1014,9 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm=
_s2_mmu *mmu, unsigned long t
>  	if (err)
>  		goto out_free_pgtable;
> =20
> +	if (system_supports_hdbss())
> +		pgt->flags |=3D KVM_PGTABLE_S2_DBM;
> +

[Severity: Medium]
Are we missing the corresponding VTCR_EL2.HD update?

The architectural requirement for the hardware to interpret the DBM bit is
that VTCR_EL2.HD must be 1. kvm_get_vtcr() in arch/arm64/kvm/hyp/pgtable.c
does not appear to include the VTCR_EL2_HD bit, which would mean VTCR_EL2.HD
remains 0 and the hardware will ignore the DBM bit.

[Severity: Medium]
Also, does this logic properly enable DBM for protected VMs?

In pKVM mode, the host's pgt is merely a dummy structure. The actual stage-2
page tables for protected VMs are initialized at EL2 via
pkvm_guest_prepare_stage2() calling __kvm_pgtable_stage2_init() in
arch/arm64/kvm/hyp/nvhe/mem_protect.c, which unconditionally passes 0 for t=
he
flags parameter. Will this cause KVM_PGTABLE_S2_DBM to be ignored in the
actual page table used for pKVM?

>  	mmu->pgt =3D pgt;
>  	if (is_protected_kvm_enabled())
>  		return 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260709104026.2612=
599-1-zhengtian10@huawei.com?part=3D3

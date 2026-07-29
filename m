Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41763AFD1E;
	Wed, 29 Jul 2026 10:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322543; cv=none; b=JtrEuOkoWvzCTE3xn5gFfF3UH+v1zGStMw6JCfPcCd3vxirXL+EnaPYlf+H3u5GZ+8IhKUVMPnx6deSizDOsOqoU9aSvkqkLxNukwcp+U7k4CKje3LX9W1ZrEP10cAK2LZLIYaabYUWTlbpg7auuccMYT4PEBs8eQD8dq8zdiGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322543; c=relaxed/simple;
	bh=SAFcae7IVBpwz6W8X0rbdw0EFsgtNfVjmvq+L0HyXps=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jmxacza3eQfxFIi/KfxLv2hzMUJZ/zjAYrz36hcFfJ0+IT7qN6rlou9B/0rSXkhxDn/YStQt1Vg5UZlUVLN2JNuE2cRGndRpxvYLCcJ2MYbsokyMOgvJ8ViM7CC+2Ywho+b5XcvD/ZI39ZuUNuB1+Bid8ciw2Dq+stwTc9ckfVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EVnScmXP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EVnScmXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FECC1F00A3A;
	Wed, 29 Jul 2026 10:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785322541;
	bh=qA2+NQKO0v6ZcVbODPyG2Vag2Qn9H+ENfa9BnZ0jrSE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EVnScmXPjqTvY7KqRFhs5d7EhrkvgmOCLEAArorDxeW13kgn/7ZW3XBoFGs2Y7OjB
	 I0AK040SHzoTKPzmdxs2SYGsLQDbgGaz20mtrjwo8AvHkozeBwSxkv9hj4wW//yea7
	 4cZFFDRUTrHwFHtY92TKicjJ8y2Y9pzq4SaVAImIQdzxUujTR1IvQ0QDg2DT2uHSJ6
	 8A2nSDB4AFG/Yw64GGp2hjR18/exdOkNSXOrMqAAom3A+eA9/YcranSGDdn3zoRDJ5
	 dp1LuBciH1j3F6/d69DZWk/SrMhngdylsvjo8J+cE8WOAVmy50Juba2I2/z3anSKDt
	 XT5FyZEK7TyDw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 01/11] KVM: arm64: HDBSS bits
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260729104548.3439958-2-leo.bras@arm.com>
References: <20260729104548.3439958-1-leo.bras@arm.com>
 <20260729104548.3439958-2-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 10:55:40 +0000
Message-Id: <20260729105541.3FECC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] The patch is explicitly marked by the author as a test hack that s=
hould not be merged upstream.
- [High] Hardware Dirty Bit Management (DBM) is not cleared when write-prot=
ecting pages, allowing guests to bypass software write-protection (such as =
userfaultfd-wp or software dirty logging).
- [Medium] Left shifting a negative signed integer is undefined behavior in=
 C.
- [Medium] The hardcoded split_page_chunk_size is excessively large, causin=
g massive memory allocations under the mmu_lock.
- [Low] HDBSS entry macros are defined in a `.c` file instead of a header f=
ile, making them inaccessible to other subsystems.
- [Low] Typo in the parameter name of `has_vhe_hdbss`.
--

--- Patch [1]: [PATCH v3 01/11] KVM: arm64: HDBSS bits ---
commit 125f04d66539bf05e0255567036409a407e48004
Author: Leonardo Bras <leo.bras@arm.com>
Subject: KVM: arm64: HDBSS bits

A brief summary:
This commit introduces preliminary support for the Hardware Dirty state
tracking structure (HDBSS) feature on ARM64. It adds CPU feature detection,
sets the DBM stage-2 page table flag when write protection is relaxed, and
configures eager page splitting chunk sizes for testing purposes.

> I added them here in order to fulfill the dependencies and be able to
> easily build and test this patchset, but this particular patch should *no=
t*
> be merged upstream.

[Severity: High]
Since this is explicitly marked as a test hack meant only for local building
and testing, should this patch be dropped from the series before it gets
merged upstream?

[ ... ]

> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeatur=
e.c
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2131,6 +2131,11 @@ static bool hvhe_possible(const struct arm64_cpu_c=
apabilities *entry,
>  	return arm64_test_sw_feature_override(ARM64_SW_FEATURE_OVERRIDE_HVHE);
>  }
> =20
> +static bool has_vhe_hdbss(const struct arm64_cpu_capabilities *entry, in=
t cope)
                                                                           =
  ^^^^
[Severity: Low]
Is this intended to be named scope? The standard convention for capability
matching functions in cpufeature.c uses scope for this parameter.

[ ... ]

> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> new file mode 100644
> --- /dev/null
> +++ b/arch/arm64/kvm/dirty_bit.c
> @@ -0,0 +1,16 @@
[ ... ]
> +#include <asm/kvm_dirty_bit.h>
> +
> +/* HDBSS entry field definitions */
> +#define HDBSS_ENTRY_VALID BIT(0)
> +#define HDBSS_ENTRY_TTWL_SHIFT (1)
> +#define HDBSS_ENTRY_TTWL_MASK (GENMASK(3, 1))
> +#define HDBSS_ENTRY_TTWL(x) \
> +	(((x) << HDBSS_ENTRY_TTWL_SHIFT) & HDBSS_ENTRY_TTWL_MASK)
> +#define HDBSS_ENTRY_TTWL_RESV HDBSS_ENTRY_TTWL(-4)

[Severity: Low]
Because these HDBSS entry macros are defined directly in the .c file rather
than in the newly created header arch/arm64/include/asm/kvm_dirty_bit.h, th=
ey
are inaccessible to other subsystems. Should they be moved to the header fi=
le
so dependent patches can use them?

[Severity: Medium]
Will HDBSS_ENTRY_TTWL_RESV trigger undefined behavior here? The macro expan=
ds
to ((-4) << 1), and left shifting a negative signed integer is undefined
behavior in C (prior to C23), which can lead to shift-out-of-bounds splats
at runtime.

> +#define HDBSS_ENTRY_IPA GENMASK_ULL(55, 12)

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1367,9 +1371,13 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgta=
ble *pgt, u64 addr,
>  	if (prot & KVM_PGTABLE_PROT_R)
>  		set |=3D KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> =20
> -	if (prot & KVM_PGTABLE_PROT_W)
> +	if (prot & KVM_PGTABLE_PROT_W) {
>  		set |=3D KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> =20
> +		if (pgt->flags & KVM_PGTABLE_S2_DBM)
> +			set |=3D KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> +	}
> +

[Severity: High]
Does kvm_pgtable_stage2_wrprotect() also need to be updated to clear the DBM
bit?=20

Currently, kvm_pgtable_stage2_wrprotect() clears the=20
KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W bit to trap writes, but if=20
KVM_PTE_LEAF_ATTR_HI_S2_DBM is left set, the hardware will autonomously upd=
ate=20
the PTE to allow writes without generating a permission fault. Could this=20
allow guests to bypass software write-protection mechanisms like=20
userfaultfd-wp or KVM software dirty page logging?

>  	if (prot & KVM_PGTABLE_PROT_X) {
>  		ret =3D stage2_set_xn_attr(prot, &xn);
>  		if (ret)

[ ... ]

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1027,8 +1027,12 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kv=
m_s2_mmu *mmu, unsigned long t
>  	for_each_possible_cpu(cpu)
>  		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) =3D -1;
> =20
> -	 /* The eager page splitting is disabled by default */
> -	mmu->split_page_chunk_size =3D KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> +	 /* The eager page splitting is disabled by default if system has no HD=
BSS */
> +	if (system_supports_hdbss())
> +		mmu->split_page_chunk_size =3D 256 * 1024 * PAGE_SIZE;

[Severity: Medium]
Is this hardcoded split_page_chunk_size excessively large? This evaluates to
1GB on 4KB page systems and 16GB on 64KB page systems. When splitting this
chunk, kvm_mmu_topup_memory_cache might attempt to allocate a massive amount
of page tables under the mmu_lock. Could this cause severe latency spikes or
allocation failures under memory pressure?

> +	else
> +		mmu->split_page_chunk_size =3D KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> +
>  	mmu->split_page_cache.gfp_zero =3D __GFP_ZERO;
> =20
>  	mmu->pgd_phys =3D __pa(pgt->pgd);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729104548.3439=
958-1-leo.bras@arm.com?part=3D1

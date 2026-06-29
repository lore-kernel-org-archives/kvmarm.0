Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD50336402D;
	Mon, 29 Jun 2026 11:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782732898; cv=none; b=lMK8KP1WFBCTmHRveaiO1xbZ/2r4JkCU4q36DWywHx76RCMrzjYr38uu5sQEGyCiFMnSy1CbG4uAI9CTlmni0WmsPpyQe5ox3ZRJcv7tUuZ2zzXtncfPcqpY46uYrFM1Nbs6lIXpgzurYgwrNngs8IUQULKLRMLs4zpyeeFFd6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782732898; c=relaxed/simple;
	bh=85XMVtESTbk2an2+nJ/vXioi6pYxQ78SgmU50i9ywY8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CKM/ifgHIJEi3Bdy/hm6l5b55KNap2YNCfly6LV6oxezy8z6Rd/r6rePqRYwnXYf3B7wd1veI1JdIFe9WgqlSQ5kEtRabvWszPPwhE1AYhHL97nSwMUlHhYVSIlIaNn01tRYK5En+rxVp2HKyioND0HWmQ2GTZ5mcBTsYUHcb/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D6B616Uy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D6B616Uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7B61F000E9;
	Mon, 29 Jun 2026 11:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782732897;
	bh=buFHfVGh++4RxhxJF68s8qCs9IAly+AtaTMVwapcyWg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D6B616Uy/jW9bOTr71EEnh2D0cwniYFMoEFMOLdlkuRK6bu+b7YYebV3HMpeVMRAb
	 /kHgCDuDoUNDZZV1dYojvmrh4LRa+IcOH7c4UkxqJZo1zAhlQiD9OinAlWvT/hL/48
	 YYBzARsvcR0/P5D9gFpFX6U9YOhMgnHm0O3n99zPGlzmrNZaE1UnCYEBBiPqnQNcU1
	 0lJ9KjgAXDho/brvSXYbU2rlvOMwxJT4PWcsEY/koQO1vHozh81NZ3QF8TtfmChdDk
	 QCck2n9CQjmRoXlbxjMLmV1FJPc/yoIh9nsvmoliUu43C5gAAU0Z9T+cpDjRl7kqEp
	 S/bIN43A9LmUA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 01/13] KVM: arm64: HDBSS bits
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260629111820.1873540-2-leo.bras@arm.com>
References: <20260629111820.1873540-1-leo.bras@arm.com>
 <20260629111820.1873540-2-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 29 Jun 2026 11:34:56 +0000
Message-Id: <20260629113457.0D7B61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] Mapping writeable pages with both DBM and S2AP_W set causes `k=
vm_pgtable_stage2_wrprotect` to silently bypass software write-protection.
- [High] `has_vhe_hdbss` incorrectly uses `is_kernel_in_hyp_mode()` which e=
valuates to true during early boot for pKVM (nVHE), erroneously enabling VH=
E-specific features.
- [Low] Typo in the parameter name for `has_vhe_hdbss`.
--

commit 49089779295fae526ba79b7c7e78d31fbe6a9636
Author: Leonardo Bras <leo.bras@arm.com>

KVM: arm64: HDBSS bits

The commit introduces HDBSS bits from a future patchset to fulfill
dependencies and allow building.

> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeatur=
e.c
> index 9a22df0c5120f..aa327eebaf1ca 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c

[ ... ]

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
This isn't a bug, but there is a typo in the parameter name (cope instead
of scope).

> +{
> +	return is_kernel_in_hyp_mode() && has_cpuid_feature(entry, cope);

[Severity: High]
Does using is_kernel_in_hyp_mode() here erroneously enable VHE-specific
features for pKVM (nVHE)?

During early boot feature detection, is_kernel_in_hyp_mode() evaluates to
true because the host kernel boots at EL2 and only drops privileges to
EL1 later during device_initcall_sync (finalize_pkvm()).

This early check could force ARM64_HAS_HDBSS to be enabled on pKVM
systems, propagating the KVM_PGTABLE_S2_DBM flag to hypervisor-managed
stage-2 page tables.

Should this use is_vhe_hyp_mode() instead to avoid incorrectly matching
during the nVHE privileged window?

> +}

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 91a7dfad66866..e16729f0b7bd2 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c

[ ... ]

> @@ -731,9 +731,13 @@ static int stage2_set_prot_attr(struct kvm_pgtable *=
pgt, enum kvm_pgtable_prot p
>  	if (prot & KVM_PGTABLE_PROT_R)
>  		attr |=3D KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> =20
> -	if (prot & KVM_PGTABLE_PROT_W)
> +	if (prot & KVM_PGTABLE_PROT_W) {
>  		attr |=3D KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> =20
> +		if (pgt->flags & KVM_PGTABLE_S2_DBM)
> +			attr |=3D KVM_PTE_LEAF_ATTR_HI_S2_DBM;

[Severity: Critical]
Can setting KVM_PTE_LEAF_ATTR_HI_S2_DBM here lead to a silent bypass of
software write-protection?

When a page is mapped writable, both DBM and S2AP_W are set. If KVM later
write-protects the page via kvm_pgtable_stage2_wrprotect(), only S2AP_W
is cleared:

kvm_pgtable_stage2_wrprotect() {
    ...
    return stage2_update_leaf_attrs(pgt, addr, size, 0,
                                    KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
                                    NULL, NULL,
                                    KVM_PGTABLE_WALK_IGNORE_EAGAIN);
}

This leaves DBM intact. Hardware interprets DBM=3D1, S2AP_W=3D0 as a clean
writable page and automatically sets S2AP_W=3D1 on the next write without
generating a Permission Fault.

For pKVM, this allows a guest to bypass memory isolation. For nested
virtualization, nested guest writes will silently set S2AP_W=3D1 without
trapping to the host, resulting in lost dirty pages during live migration.

> +	}
> +
>  	if (!kvm_lpa2_is_enabled())
>  		attr |=3D FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260629111820.1873=
540-1-leo.bras@arm.com?part=3D1

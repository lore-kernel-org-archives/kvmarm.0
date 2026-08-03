Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2186C367F48
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785754470; cv=none; b=A01eZe5//i4upBpn2n5MDjseNE5/DA2kmvYlOD7Z14zw6OstkNE66YBwINdqlhivv7Vi0QkeyA2I8tFNjE/vskc1Jd+593nKQbrdSMYYkhdt1rxMz0LgSmAy7QCKc3jlj+Uz8b/0SS4itJ0hTbbZJWc/veOE0ktKq5CCRMfmAE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785754470; c=relaxed/simple;
	bh=t9eTWG1ZW2dInn7dSVtAL3kH6KM5d9S3JaHrk5yzR2s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jysn/suPYzYJKgCdsgoXfXKhoxYDVSOjkDWjcO5AT7aLVdYGJD5PQZMnLRF8Re52le2rJ8ma5H+PMyMKkgHqkYBpqZOMfEMvVLGkyPk2yS6ElTaTlZ+yXKQAaAUmX79rYxPcF0OIfplixl5fIaJtrkUtBWupTd12+d+AC1wj530=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EBv1uL39; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EBv1uL39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EEF1F000E9;
	Mon,  3 Aug 2026 10:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785754468;
	bh=VB+eifxzgyb8j9z78sXIuGCGtW7Z5BOKhx+U4s1J0yc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EBv1uL39MLZ0VFRhdEv/2hUgqGnbfp8LR45OWknMAo6xgOxMamhL3n4rqmaqwJeja
	 orflKDskjnDkEond0gD5LoKNjKK8NnFP8fol6pSo0Ovfmp6jXddmf5Dxywy1Mn+xvi
	 YlJqEdw1s5d3+zb2y7Sd1iMP+hspOV77SFWPf4gTGV/gQCyyESUeeKFg//MjVG+sRr
	 YGSUNOK7NHeIvdcWnr8WPTdi0MR/Pb9k/g1bsqp5QC4s0Ktt5tO52t/Npy9KlHVja8
	 FnPaZx8Ue4WQiPKt6Dlp77ksVte/StG2PWzFThzaXKkqwDYY7gerWxggeXjocdonum
	 YREt95vkmqVlw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 16/20] KVM: arm64: Add __pkvm_host_split_guest HVC
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260803100904.3563942-17-vdonnefort@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-17-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 10:54:27 +0000
Message-Id: <20260803105428.76EEF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Failed guest stage-2 page table splits leave the host stage-2 owne=
rship metadata permanently split, causing subsequent split attempts to fail=
 with -EINVAL.
- [High] Incorrect WARN_ON() semantics in host_stage2_split_gfn_meta() turn=
s a recoverable memory allocation failure into a fatal EL2 panic.
--

--- Patch [16]: [PATCH 16/20] KVM: arm64: Add __pkvm_host_split_guest HVC -=
--
commit 76334f00eacfa593f4125057892101e13067d2e0
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Add __pkvm_host_split_guest HVC

This HVC allows the host to break an existing block in a protected VM. This
will later allow the guest to share a sub-region of an existing
huge-mapping with the host.

> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/n=
vhe/mem_protect.c
> index e16dde4c5f4b9..71ebd1856cb0c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
[ ... ]
> @@ -660,14 +658,49 @@ static int host_stage2_decode_gfn_meta(kvm_pte_t pt=
e, struct pkvm_hyp_vm **vm,
[ ... ]
> +	end =3D phys + size;
> +	while (phys < end) {
> +		u64 meta =3D host_stage2_encode_gfn_meta(vm, gfn);
> +		kvm_pte_t annotation =3D FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, =
PKVM_ID_GUEST) |
> +				       FIELD_PREP(KVM_HOST_DONATION_PTE_EXTRA_MASK, meta);
> +
> +		ret =3D host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
> +				      phys, PAGE_SIZE, &host_s2_pool,
> +				      KVM_HOST_INVALID_PTE_TYPE_DONATION, annotation);
> +		if (WARN_ON(ret))

[Severity: High]
Can a memory allocation failure here trigger a fatal EL2 panic?

Since WARN_ON() at EL2 expands to a fatal BRK instruction with no "warn and
continue" semantics, an -ENOMEM from host_stage2_try() will cause a hypervi=
sor
panic rather than taking the error path.

> +			return ret;
> +
> +		phys +=3D PAGE_SIZE;
> +		gfn++;
>  	}
> =20
> -	*gfn =3D FIELD_GET(KVM_HOST_PTE_OWNER_GUEST_GFN_MASK, meta);
>  	return 0;
>  }
[ ... ]
> @@ -1748,6 +1788,39 @@ int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm=
_hyp_vcpu *vcpu)
[ ... ]
> +	ret =3D host_stage2_split_gfn_meta(phys, ipa, size, vm);
> +	if (ret)
> +		goto unlock;
> +
> +	ret =3D kvm_pgtable_stage2_split(&vm->pgt, ipa, size, mc);

[Severity: High]
Does this leave the host stage-2 ownership metadata permanently split if
kvm_pgtable_stage2_split() fails?

If the guest split fails (e.g., due to memory exhaustion returning -ENOMEM
or -EAGAIN), the error is returned immediately without reverting the host
stage-2 modifications made by host_stage2_split_gfn_meta(). This could cause
subsequent split attempts for this block to fail with -EINVAL due to the
desynchronized state.

> +
> +unlock:
> +	guest_unlock_component(vm);
> +	host_unlock_component();
> +
> +	return ret;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803100904.3563=
942-1-vdonnefort@google.com?part=3D16

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795556563;
	b=skap11Gt+Q3x8wtpRISRrSezrViPMtUy+N0PXDEXL6tFAcrz1Rl4JJQu6lrnfUcoGN7S
	 g4PFrGndvYA9CPn+aEh1N/SfJR6bdpN2W5DFimCZiL4mSvgAXu4cywiCl9x3UE7nJZm7i
	 ulB0mxzFX50Q9lLcTWussFTg3DXoPqBVp+UdA+42Q6aXSh3jXlfxiIJTRpeVhjMhIFWlO
	 lqIxNK8HzK5aJZBDQ0ySJKPE9uJrXGsvhnzFajWwdwyyqyecQ0YJjFTBwvPkgNc1Ww7ML
	 tS4WlElRzFEpGeeVp/V3J6p1pF3S9j+fxgOOFpVEPSOcC+XmAhrzVVbQ0BicUw22kzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795556563;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pujBGrssMlXaUw6dwF9LIaRO2F1DbYaMiIt+WhUFxpI=;
	b=bcw/qZPK1NVOnKLSCru1V7zCEPXAUPUGAJV9lp0KWrGkUPuJjd5/LIaRBJXvrQ2awBFg
	 fK/3Tt95P4TfWPmRqOc5P7ytbeprActtgz39CzUEsTMVxnqRiIlYMAoAjQ6O9cOkwclWy
	 r3EVk0323c6A2eau6NxJFcaUfupBSUHbYrDjQDqBlcuY+5fQIcgOSULTMXUB/kFCbu3oQ
	 jKRP95UjAa24ie4KV+ij8eFiHnZzvwoFYuximr8YCIknDnP0R9g1W3f0j0W6+bjiWj4Ml
	 QsaK/TD6d3JvIIz2+jMlUi/N2TGfwgTYp5XMz1CSAvwiCBKP3/p7M3jT99XBYVgwzMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NzA6tGHr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF644606A321
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 21:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NzA6tGHr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9BC1F000CA;
	Tue, 24 Nov 2026 21:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795556563;
	bh=pujBGrssMlXaUw6dwF9LIaRO2F1DbYaMiIt+WhUFxpI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NzA6tGHr0XtCqDwG6uWMukHkpdvGTJsQ5U6W6FfrGWO5lFJRbONMmDLOSHbwZ83PY
	 1Ke1qKmHHkgJIGcCjSmMz/1UiyhzKyAzx9hcDE2NwDcbMdWT83AotP/ov/ynlOyCj2
	 8nVvnCZlq4IVLzloyIEx8PDBN13tx+7rKqyGGS2A+pVquTGyd1vWvhWhWB/ZeTy73N
	 lMhuk2PneR+tIvJTu7df45Ce5SuKf/00NZHfW+/u5B7zbMeNnOw91web7wkihHHJAn
	 JL4h2gv2nWaeikCbdAUw0HKxiQ+s/leid2WPzaGcjRzVoUOmauUqJ5xyKqqK++T5/D
	 PwTa1LYZ9PqPA==
Message-ID: <sashiko-outbox-232055@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 6/6] KVM: arm64: nv: Park shadow S2 MMUs emptied by
 a guest range invalidation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nathan Chen" <nathanc@nvidia.com>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261124211218.2751086-7-nathanc@nvidia.com>
References: <20261124211218.2751086-1-nathanc@nvidia.com>
 <20261124211218.2751086-7-nathanc@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 21:42:42 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] KVM: arm64: nv: stale guest_s2_mappings left by
  s2_mmu_unmap_range()
--

commit f58fa33431acb8934a7b0dc10a9031b3bb889b94
Author: Nathan Chen <nathanc@nvidia.com>

KVM: arm64: nv: Park shadow S2 MMUs emptied by a guest range invalidation

This commit exports kvm_nested_s2_park() and calls it from
s2_mmu_unmap_range() so that grown, unreferenced shadow stage-2 MMUs
emptied by a guest TLBI range invalidation are immediately parked.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index df81adf962599..99dcd2549b08a 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -4123,6 +4123,14 @@ static void s2_mmu_unmap_range(struct kvm_s2_mmu *=
mmu,
>  	 * the TLBI.
>  	 */
>  	kvm_stage2_unmap_range(mmu, info->range.start, info->range.size, true);
> +
> +	/*
> +	 * The guest hypervisor may have unmapped everything this MMU held,
> +	 * e.g. all memory of a nested VM being torn down. If it is grown and
> +	 * now empty, return it to the budget rather than leave it for a
> +	 * recycle to unmap again.
> +	 */
> +	kvm_nested_s2_park(kvm_s2_mmu_to_kvm(mmu), mmu);
>  }

[Severity: High]
Can calling kvm_nested_s2_park() after a partial range invalidation
(TLBI RIPAS2E1IS) leave stale kvm_guest_s2_mapping entries in
mmu->guest_s2_mappings and kvm->arch.mmu.guest_s2_mappings?

When a guest TLBI RIPAS2E1IS unmaps a range smaller than a recorded block
mapping (or unmaps a block across multiple sub-block ranges),
stage2_unmap_walker() unmaps the entire overlapping block PTE and can leave
mmu->pgt empty, while kvm_remove_guest_s2_mappings() only frees mappings
completely enclosed within that single unmap range:

arch/arm64/kvm/nested.c:kvm_remove_guest_s2_mappings() {
    ...
		nested_start =3D s2_mapping_to_nested_start(mapping);
		if (nipa <=3D nested_start && nipa_end >=3D mapping->nested.last) {
			interval_tree_remove(&mapping->nested, &mmu->guest_s2_mappings);
			interval_tree_remove(&mapping->canonical,
					     &kvm->arch.mmu.guest_s2_mappings);
			kfree(mapping);
		}
    ...
}

Because kvm_nested_s2_park() only checks kvm_s2_mmu_empty(mmu) (which walks
mmu->pgt), it marks the MMU invalid via kvm_init_nested_s2_mmu() and clears
pending_unmap without draining mmu->guest_s2_mappings.  Later full-VMID
invalidations skip the invalidated MMU, and reactivating it in
get_s2_mmu_nested() sees !kvm_s2_mmu_valid(s2_mmu) and skips setting
pending_unmap.  The leftover mappings leak across park/grow cycles and let
kvm_nested_unmap_cipa_range() unmap unrelated nested IPAs after the MMU is
reused for a new nested context.

Should kvm_nested_s2_park() call
kvm_remove_guest_s2_mappings(mmu, 0, kvm_phys_size(mmu)) before parking the
MMU?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124211218.2751=
086-1-nathanc@nvidia.com?part=3D6

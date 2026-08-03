Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AA830F7FB
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785752930; cv=none; b=J/sbobLLcf12oRoGEv0HWdKPQYhZmJUfT2W6RdePbwcbD+IjepxMN8Cg4XKGwo0kCcaWz1dkevV5+/KWnXF6uaQ534tdkBiJ4j/SKOLg0aNt2iKI3ESRegbyxmgrn/CsGXW9rkD8Y8anQHADjWJIaQlTSOR5hiqbfsEVfSj9EBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785752930; c=relaxed/simple;
	bh=yddf3cvGgIe7Oe1zaqkAUXeEkSsXJvlhzx+V6NOWvqc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AmeCzrguWynmLz/g65kBT3zuN9ObfHvF3F0Ac8fBSPD5Q+ruFaacv4BMpt3giMgsrxmZk7czH8Ca19o9aGe67qQuETPdP0Fs3eG/WSnaWe5T9edQjTdIy4Ae1zFIYXFv3UkOAxehvwraI9vNpM6tQ5+TprCiROYRMQGfNoyR8Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hZ9PsStY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hZ9PsStY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3861F000E9;
	Mon,  3 Aug 2026 10:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785752929;
	bh=ayuhUD5iZgLt+XMwwmvUcoZ6U8ficQI9IP9lzsKR28g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hZ9PsStYW2Li4wSo+ixneDaNQCaQBqZxHLWad5A6cR3+ZOWcFaZ++VXljxIhw7ouS
	 g7QfAeaIal/cMG/MWW7PuATugmNSjWiv465nEhyUyAT+OParPpqvA9oyEjAkXiMOMy
	 fTPJ19kex6YrUyidnMUe96Eh1RWa6QoWDqO9jNwi/mUzDinmOB6IJotSEfzMKyOhZT
	 fTeLitaOb/HzmSP6Uo9PiJ4OrUMxc+fM8Ws4fE6EfYN+V9PsNeLCfxoBbHz86Q3kdz
	 xid/K0qRtNJzAjpLSMBe2gPl5kMJi3j+pelUSEU+R96WR0KA/9Ny3KXR4HoQ8eiCxr
	 4EWY0pBDRe3jg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 08/20] KVM: arm64: Add a range to
 __pkvm_host_reclaim_page_guest()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260803100904.3563942-9-vdonnefort@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-9-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 10:28:48 +0000
Message-Id: <20260803102848.BA3861F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The guest teardown reclaim path relies on guest stage-2 page-table=
 walks to validate and translate the GFN for ownership transition instead o=
f enumerating by EL2 ownership metadata. If a guest page lacks a valid stag=
e-2 PTE, the reclaim fails and the memory is permanently leaked.
--

--- Patch [8]: [PATCH 08/20] KVM: arm64: Add a range to __pkvm_host_reclaim=
_page_guest() ---
commit 268a05000f92ceab485eb6ee82a421828dd4d08d
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Add a range to __pkvm_host_reclaim_page_guest()

This patch adds a nr_pages argument to the __pkvm_host_reclaim_page_guest()
hypercall to prepare for stage-2 huge mappings support for protected VMs. It
allows reclaiming either a single page or a block of pages.

> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/n=
vhe/mem_protect.c
> index 9ea448895c15e..ce637f1a55b37 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c

[ ... ]

> @@ -1365,35 +1386,40 @@ int __pkvm_host_force_reclaim_page_guest(phys_add=
r_t phys)
>  	return ret;
>  }
> =20
> -int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm)
> +int __pkvm_host_reclaim_page_guest(u64 gfn, u64 nr_pages, struct pkvm_hy=
p_vm *vm)
>  {
>  	u64 ipa =3D hyp_pfn_to_phys(gfn);
>  	kvm_pte_t pte;
>  	u64 phys;
> +	u64 size;
>  	int ret;
> =20
> +	ret =3D __guest_check_transition_size(0, ipa, nr_pages, &size);
> +	if (ret)
> +		return ret;
> +
>  	host_lock_component();
>  	guest_lock_component(vm);
> =20
> -	ret =3D get_valid_guest_pte(vm, ipa, &pte, &phys);
> +	ret =3D get_valid_guest_pte(vm, ipa, size, &pte, &phys);
>  	if (ret)
>  		goto unlock;

[Severity: High]
This is a pre-existing issue, but does relying on a guest stage-2 page-table
walk here to find the page to reclaim lead to a physical memory leak?

If a guest page lacks a valid stage-2 PTE (for instance, if a previous
mapping failed or the guest unmapped it), get_valid_guest_pte() returns
-ENOENT.

This causes the function to exit early, skipping the ownership transition a=
nd
leaving the physical memory permanently marked as PKVM_PAGE_OWNED by the de=
ad
guest, which can lead to host resource exhaustion.

>  	switch (guest_get_page_state(pte, ipa)) {
>  	case PKVM_PAGE_OWNED:

[ ... ]

> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 58d8474b563e6..a9645480d1648 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c

[ ... ]

> @@ -373,7 +373,8 @@ static int __pkvm_pgtable_stage2_reclaim(struct kvm_p=
gtable *pgt, u64 start, u64
>  		struct page *page;
> =20
>  		ret =3D kvm_call_hyp_nvhe(__pkvm_reclaim_dying_guest_page,
> -					handle, mapping->gfn);
> +					handle, mapping->gfn,
> +					mapping->nr_pages);
>  		if (WARN_ON(ret))
>  			continue;

[Severity: High]
This is a pre-existing issue, but does driving the reclaim from the host's
local tracking tree here contribute to the leak mentioned above?

Because this loop enumerates pages using the host's mapping tree instead
of having EL2 enumerate them by their recorded ownership metadata, any
discrepancy where a page is owned but lacks a valid stage-2 PTE will
result in the memory permanently leaking when the hypercall fails.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803100904.3563=
942-1-vdonnefort@google.com?part=3D8

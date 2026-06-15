Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053C43C5DBF;
	Mon, 15 Jun 2026 16:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539743; cv=none; b=EFGZvnMF37c5ZpaYrgTIfm/0i4cCqtkiinpnotPr9Ea7Xf60fSdF5K1BS/j9ZnkbQbm3SEYK3NkvzTP2K10VmVjlK+4MS7JVoLQpnT6Rt3tYGhSa0Qp2cR5+odw/ZSpBhiNtQoJI3vJ5G+bOmlMZiT1zwY0922R2BdkmkjOqg+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539743; c=relaxed/simple;
	bh=WHn10bh0M8W5dvO+SvrKHEfFBYqMMDKX8azQKMhpKW0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=p/iZltP6BfyUgelbRHlVnwhGHnojMsMkKLNvuCXaAZQWTnyxEULG6J4iGb2s6bklzdbnJpebCEUHWjECObyFvTD0Ed/F194hxId10j23dXzNf1Lybb2Kd7GS9sqecd3XRwFmCYgLNpGEKi/lezgXedqcpKCyN2jpHQxn5+JQ2gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QRanFp6j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QRanFp6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1A61F000E9;
	Mon, 15 Jun 2026 16:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781539741;
	bh=Da12Do+in3iMzyoYY7rMMqw1/ZGqAn7ElggiEDpGLdk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QRanFp6jZzPqmsWSsGET8xXPj2zdeQhCk63YSZxYwBda1qjvovECtIsZhuiQKqCkt
	 rpk29IP414/kd9g84qUC1Y1o1Mn64kC3/hGfKaBFvHjhdKfLr0gBgLHTRsaVSesw6p
	 Bzs5FuGZndfN5MRAiIyuwLG3LrogaOOallHQdUqhWg0yE3gX6mfWTdiuZWdgileIAc
	 NvbmPGwIiR3v2JzOJL/q06/sgfq83IQf322EvajDTyLM1LmZEnFc36wEo9x8nMukXU
	 5e+LeNlvJ3WD+2SXMhQ40vk2DnR+O+4sw3E2WrQKh7Yt1YRo2HEdSo8LfZxnlD2/I8
	 cQJ2P4EymDuUg==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH] KVM: Ignore MMU notifiers for guest_memfd-only
 memslots
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260615155244.183044-1-alexandru.elisei@arm.com>
References: <20260615155244.183044-1-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 15 Jun 2026 16:09:01 +0000
Message-Id: <20260615160901.9A1A61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Skipping MMU notifiers for guest_memfd-only memslots breaks th=
e pfncache retry protocol, leading to a host-level Use-After-Free.
--

commit 8278d4b7bdd8bdfe7a6bc39dd2a0418838234428
Author: Alexandru Elisei <alexandru.elisei@arm.com>

KVM: Ignore MMU notifiers for guest_memfd-only memslots

This commit modifies KVM's MMU notifier handling to ignore guest_memfd-only
memslots. The rationale is that guest_memfd memory is not evictable or mova=
ble,
making traditional userspace MMU notifier tracking unnecessary.

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
[ ... ]
> @@ -592,6 +592,10 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_r=
ange(struct kvm *kvm,
>  			unsigned long hva_start, hva_end;
> =20
>  			slot =3D container_of(node, struct kvm_memory_slot, hva_node[slots->n=
ode_idx]);
> +
> +			if (kvm_slot_has_gmem(slot) && kvm_memslot_is_gmem_only(slot))
> +				continue;
> +

[Severity: Critical]
Does this change inadvertently introduce a regression in the pfncache retry
protocol?

Looking at the pfncache framework, it maps guest memory into kernel space a=
nd
explicitly drops the page reference after mapping it:

virt/kvm/pfncache.c:hva_to_pfn_retry() {
    ...
    kvm_release_page_clean(page);
    ...
}

It appears to rely entirely on KVM's MMU notifiers (kvm->mmu_invalidate_seq)
to invalidate the cache when the page is unmapped by the host.

If a VMM defines a guest_memfd-backed memslot with KVM_MEMSLOT_GMEM_ONLY
but still provides a valid anonymous user mapping as its userspace_addr,
could this regression lead to a use-after-free? By unmapping the anonymous
memory, the host would trigger MMU notifiers, but this new check skips
the memslot. As a result, kvm->mmu_invalidate_seq wouldn't increment, and
KVM might retain a kernel mapping to a freed physical page.

Could this allow the guest to read or write arbitrary host physical memory?

>  			hva_start =3D max_t(unsigned long, range->start, slot->userspace_addr=
);
>  			hva_end =3D min_t(unsigned long, range->end,
>  					slot->userspace_addr + (slot->npages << PAGE_SHIFT));

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260615155244.1830=
44-1-alexandru.elisei@arm.com?part=3D1

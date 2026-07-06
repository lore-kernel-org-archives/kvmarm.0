Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65C63AF656
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 18:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783361563; cv=none; b=pUD3fY9Pqn8vLdNCmmp8hOvmFDn0mKXYk/vDqyTWh4/0cWFdU+vjt6IL/MVVGpI39KBkNdj4t70ZNLy4v9WuMaBWSALc9h0VjZRaPjKoo+nMBZ5Kr5lIZrPPBUk+BxnJFitcAaihMnhRvUvi/2raj5qnBKoPzygrQdWGtcytCiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783361563; c=relaxed/simple;
	bh=am3lKgaNiD5kjRzSmI6f8QsFH6X0RGGeP1X69boOg9M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=T5Ql+jFTUjeL87a5Zz/vUJVHFQ6HiCb0PrdWRBVEf/O9yz4qf70Iao64FXpf2JoOXXCnMI8W4pPzBjURqqhCLf72QBoEkC1DXaO1+S1uFJzNxA6LvZjZvxTLSCDuVJHijo5Qe99LmuGBUg6gomyKRtm/N2i1oNZGRFGiLbKhA4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=btP0OOj+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="btP0OOj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276E21F000E9;
	Mon,  6 Jul 2026 18:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783361562;
	bh=D6pYqF638pQpv/Pq5bHxqfei45aJbooRpe9WkjtLCaI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=btP0OOj+g0WXklUAHfHALeeKF8O7f7DLopcKJlP0uAVIBrhdAUDjEVM66+izj0z47
	 IChQ7RwUpjJVRWa2q5woSJGb9HkA4cpgR/lbkLozDwm5dKoxwjV1REwFIF9otWZ1GD
	 kxB96Y2VBaHGWyEuJycoFcJz8Rxn1O5O2NxzRAjcsEiLTOnpxpZ3qNjmdln4A62Y87
	 Sm9J2jbli8sOqlBUbkgakp6tqoDNYXHYdlsHpdAXs/UFsQ+VFX4Wmh8TM5PCRFloYZ
	 nQ2fw3mpw1NRrI8/PBegtzyJ5QVBFZNnEhYMZWm0gnjydRoys0OFJ3JKf//zTd1F5N
	 DH3IwafrQXHuw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 04/18] KVM: arm64: Add a heap allocator for the pKVM
 hyp
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260706175415.2604046-5-vdonnefort@google.com>
References: <20260706175415.2604046-1-vdonnefort@google.com>
 <20260706175415.2604046-5-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 06 Jul 2026 18:12:41 +0000
Message-Id: <20260706181242.276E21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] hyp_allocator_map remaps already-mapped pages and corrupts unm=
apped tracker state due to unaligned next chunks.
- [High] Fatal EL2 WARN_ON creates a dead-branch trap and panics the hyperv=
isor on global lock contention in hyp_allocator_alloc.
--

commit d07913766ae6b18b86e593f40b4fc4a8165e2722
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Add a heap allocator for the pKVM hyp

This commit creates a heap allocator to manage VA-contiguous memory for the
hypervisor, replacing donations embedded within HVCs. It supports allocatin=
g,
freeing, topping up from a host memcache, and reclaiming memory.

> diff --git a/arch/arm64/kvm/hyp/nvhe/alloc.c b/arch/arm64/kvm/hyp/nvhe/al=
loc.c
> index 0000000000000..07ef0a13855f7
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/nvhe/alloc.c

[ ... ]

> +static int hyp_allocator_map(struct hyp_allocator *allocator, struct chu=
nk_hdr *chunk,
> +			     struct chunk_hdr *next,
> +			     void *addr, void *end)
> +{
> +	void *unmapped =3D chunk ? chunk_unmapped(chunk) : allocator->first_unm=
apped;
> +
> +	/*
> +	 * hyp_allocator_can_create_chunk() already validates addr/end
> +	 * belong to the chunk.
> +	 */
> +	WARN_ON(end <=3D addr);
> +
> +	/* The chunk does not span an unmapped region */
> +	if (!unmapped)
> +		return 0;
> +
> +	while (unmapped < end) {
> +		void *page =3D pop_hyp_memcache(&allocator->mc, hyp_phys_to_virt);
> +		int ret;
> +
> +		if (!page) {
> +			end =3D PTR_ALIGN(end, PAGE_SIZE);
> +			*this_cpu_ptr(allocator->topup_needed) =3D
> +				(unsigned long)(end - unmapped) >> PAGE_SHIFT;
> +			return -ENOMEM;
> +		}
> +
> +		ret =3D __hyp_allocator_map(unmapped, hyp_virt_to_phys(page));

[Severity: Critical]
Does this loop correctly handle unaligned next chunks when re-mapping
reclaimed memory?

If the allocator reclaims a chunk where the next chunk is unaligned (e.g., =
at
PAGE_SIZE + 32), the unmapped hole is safely truncated to PAGE_SIZE by
PTR_ALIGN_DOWN(next, PAGE_SIZE). However, if the chunk is later reused with
an end address extending into the partially shared page (e.g., PAGE_SIZE + =
16):

The loop in hyp_allocator_map() iterates while (unmapped < end). When unmap=
ped
reaches the end of the true hole (PAGE_SIZE), the loop continues because
PAGE_SIZE < PAGE_SIZE + 16. It then pops a new physical page and maps it at
PAGE_SIZE, overwriting the existing active PTE containing the next chunk.

Additionally, the unmapped =3D=3D next reset check fails because of the una=
ligned
next pointer, propagating the corrupted tracker state.

[ ... ]

> +static void *hyp_allocator_alloc(struct hyp_allocator *allocator, size_t=
 size)
> +{
> +	struct chunk_hdr *chunk;
> +
> +	size =3D max(size, MIN_ALLOC_SIZE);
> +
> +	/* Ensure we do not overflow ALIGN(MIN_ALLOC_SIZE) */
> +	if (size > U32_MAX) {
> +		hyp_allocator_set_errno(allocator, -E2BIG);
> +		return NULL;
> +	}
> +
> +	size =3D ALIGN(size, MIN_ALLOC_SIZE);
> +	if (size > (allocator->end - allocator->start - chunk_hdr_size())) {
> +		hyp_allocator_set_errno(allocator, -E2BIG);
> +		return NULL;
> +	}
> +
> +#ifdef CONFIG_NVHE_EL2_DEBUG
> +	/* The allocator can modify the hyp stage-1 */
> +	if (WARN_ON(hyp_spin_is_locked(&pkvm_pgd_lock))) {
> +		hyp_allocator_set_errno(allocator, -EINVAL);
> +		return NULL;
> +	}
> +#endif

[Severity: High]
Can this lock check trigger a hypervisor panic under normal SMP contention?

At EL2, WARN_ON() expands to a fatal BRK instruction, meaning the error
handling path here acts as a dead-branch trap and will never execute.

Furthermore, hyp_spin_is_locked() returns true if the lock is held by any C=
PU,
not just the local one. If host userspace triggers concurrent VM creations =
or
VCPU initializations, driving concurrent EL2 hypercalls to hyp_alloc(), CPU=
 A
might hold pkvm_pgd_lock while CPU B concurrently evaluates this WARN_ON().

This converts standard SMP lock contention into a fatal host denial of serv=
ice.

> +	scoped_guard(hyp_spinlock, &allocator->lock) {
> +		chunk =3D hyp_allocator_alloc_chunk(allocator, size);
> +		if (IS_ERR_OR_NULL(chunk)) {
> +			hyp_allocator_set_errno(allocator,
> +						IS_ERR(chunk) ? PTR_ERR(chunk) : -EINVAL);
> +			return NULL;
> +		}
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706175415.2604=
046-1-vdonnefort@google.com?part=3D4

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D20B2DC767
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784568371; cv=none; b=uBqHBG7Kj0cO8ilDCrYTj+vIenK/O5llRpoJgL5Qafh3Y6eMerY4YY8wAn8/PiEFWnfnqUF13s3h0LIlj08Jm8Mq4wCJ7hoP8g7Yf/TQlbP+oeS2MjBoPpRZw5X+L/4z/vlBwg0kPtZdXoal5ye53zCx1g9IxgRkSBdESj2HFRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784568371; c=relaxed/simple;
	bh=jitLO3J2G+rOHn6QSujUQFlQ/Ni5oaNqpBkx0d4mF2o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Jkfk8OfvVYMLidRPW4y3wIe8+n+5/IX65UM3ED0U4hLEp7S8FIvF+e/oEFAmq69pR1miLGOkhzLWDrF9xGfdaPylMPdWqKauRyesIU9nEZSbgazYMz+fF9eDj8GnIUt8fEx4R1+7pWSunLFpm+jTlsG8Kl9Ub0NUzCVPYr8aTfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=muUcm0YL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="muUcm0YL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1311F00A3A;
	Mon, 20 Jul 2026 17:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784568365;
	bh=/ELN5yyeSjAvLqeKvuXZLpEoAFERkREAJ4XnyKcgHCk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=muUcm0YLzCSWrn8YaLGQsnTZ+9ZZokXPXCC2Loj9tg2+rFG1LbUHTsaFOcmrGpZVD
	 zDL1gBbVJzwfuOxLB0aNoMaADKsMLVrNY1cjcomIm6yOUhqkrmo0AbZN09/K0Gv9xN
	 eEHRa6oxGkkBojGbKitpXnNLI2suXfamdbVqt8VH8oGH0eVYEKFe2t0Ikr0lQYlbTL
	 v0GUYHK74cNNiXw7kkwXEn2ezUiS4naC7jb9dCbsPGDyRvFyU/YyEN9+q0qohTPfjw
	 yn4Q2D3z0dDdoiSuAyXkBDmUnskqJc/UTx4DKxvA7RILyOWbUQmggfz16GT6pVwv4k
	 6QuQEPViyoIvQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 04/17] KVM: arm64: Add a heap allocator for the pKVM
 hyp
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260720171513.1415357-5-vdonnefort@google.com>
References: <20260720171513.1415357-1-vdonnefort@google.com>
 <20260720171513.1415357-5-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 17:26:05 +0000
Message-Id: <20260720172605.8C1311F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ABBA deadlock between `allocator->lock` and global component locks=
 (`host_lock_component` / `hyp_lock_component`) during memory reclaim.
--

--- Patch [4]: [PATCH v3 04/17] KVM: arm64: Add a heap allocator for the pK=
VM hyp ---
commit d447b5e9c6a4ffa49271c884ed8ffeb170f35542
Author: Vincent Donnefort <vdonnefort@google.com>
   =20
KVM: arm64: Add a heap allocator for the pKVM hyp

This commit introduces a generic heap allocator for the pKVM hypervisor
to manage VA-contiguous memory dynamically. It allows the hypervisor to
allocate and free memory on demand, replacing static memory donations
from the host. The allocator supports memory reclaim, topping up, and=20
includes chunk metadata hashing for corruption detection.

> diff --git a/arch/arm64/kvm/hyp/nvhe/alloc.c b/arch/arm64/kvm/hyp/nvhe/al=
loc.c
> new file mode 100644
> index 0000000000000..32c923d83f78b
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/nvhe/alloc.c

[ ... ]

> +static unsigned long hyp_allocator_drain_memcache(struct hyp_allocator *=
allocator,
> +						  struct kvm_hyp_memcache *host_mc,
> +						  unsigned long target)
> +{
> +	struct kvm_hyp_memcache *mc =3D &allocator->mc;
> +	unsigned long drained =3D 0;
> +
> +	while (target && mc->nr_pages) {
> +		void *page =3D pop_hyp_memcache(mc, hyp_phys_to_virt);
> +
> +		memset(page, 0, PAGE_SIZE);
> +		kvm_flush_dcache_to_poc(page, PAGE_SIZE);
> +		push_hyp_memcache(host_mc, page, hyp_virt_to_phys);
> +		WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(page), 1));
> +
> +		target--;
> +		drained++;
> +	}
> +
> +	return drained;
> +}
> +
> +static void hyp_allocator_reclaim(struct hyp_allocator *allocator, struc=
t kvm_hyp_memcache *host_mc,
> +				  unsigned long target)
> +{
> +	if (!target)
> +		return;
> +
> +	guard(hyp_spinlock)(&allocator->lock);
> +
> +	target -=3D hyp_allocator_drain_memcache(allocator, host_mc, target);

[Severity: High]
Does this sequence create an ABBA deadlock?

In hyp_allocator_reclaim(), allocator->lock is held via the guard()
before calling hyp_allocator_drain_memcache().

hyp_allocator_drain_memcache() then calls __pkvm_hyp_donate_host(),
which acquires the global component locks (host_lock_component() and
hyp_lock_component()). This establishes a locking order of:
allocator->lock -> component locks.

Since hyp_alloc() is intended to be a generic heap allocator called
during hypervisor operations (such as VM or vCPU creation) where
component locks are likely already held prior to the allocation, could a
concurrent reclaim trigger a deadlock when it tries to acquire the
component locks?

> +	if (!target)
> +		return;
> +
> +	do {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720171513.1415=
357-1-vdonnefort@google.com?part=3D4

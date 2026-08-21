Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0649E446C18
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 09:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787303706; cv=none; b=CQJl/plx3U1bbV+0n6yX1pGNpJDQoykbVi5hGyyGK9loutOvFqxOjkCeChwUZYlmlr0JW5+Xn1MwLPFlSVVcVpjxiV8WYo4dufd1WelYiRp2jABlR85zLi3Cai0IvgLf8/82q4+eOtioN/3RE61kNqj6vu2mnXYAXupD1I9UcDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787303706; c=relaxed/simple;
	bh=l1chOlTAGYGvci4a1jVKkvPiFL5CKvRizTrrLTPyYM0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hf46kFppGPEPdA1dC80oiOgqcOzSYdpAdqhx1oR3S7WluvHToq0M7IpkroNzIQGzOIFqcQBBuIGZ4T4EbFSvmL65rcr+mx9VuoYU9FoT0BiAFpI4D+FHcwoDeG71qAeQ+CCA634PpjiP1EDC6kcAqykKlB9rq7Gk0ChyOqBqG0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RqwWWm24; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RqwWWm24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6FC1F000E9;
	Fri, 21 Aug 2026 09:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787303679;
	bh=hdl+A8heZVeyYISGfv6viXmyNz6I1FSK/lSsoPGGOPs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RqwWWm24IdJZ//1FTGYL8yvsf7EkMHRAsrFvqZ08fkChG8XGe7ksizm+0853dRele
	 8t09jRmHfXLppSj7upfh8Zv6+rj6TkLrgsWnmRoa3xqPpRdsA0CEWLR2/zjf7WrgQG
	 4eok1x2AtOCwpAi4YBF3er+4OLyJOQcFtAim+XY7G08XrLl1+hnSz6WdJwWBuqTSqf
	 Z0QyOy917Ti1dsx1ISGKoIRt3im7utF1mWgz1UOT22hHnttgrCIACF/0DR+A3K05Ug
	 tJFnH4CmOt1ENaE7MVrFx8ZsiUP63GAPXLE5LAccXLqFf+HGfcxoIRALHJc7q0dsDa
	 Uz6kl2CbsCzig==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5.10.y] KVM: arm64: Retry fault if vma_lookup() results
 become invalid
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bjoern Doebel" <doebel@amazon.de>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260821090538.3493280-1-doebel@amazon.de>
References: <20260821090538.3493280-1-doebel@amazon.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Aug 2026 09:14:39 +0000
Message-Id: <20260821091439.8A6FC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Missing read memory barrier (`smp_rmb()`) before resolving the=
 guest physical address, which breaks the MMU notifier retry protocol.
--

--- Patch [1]: [PATCH 5.10.y] KVM: arm64: Retry fault if vma_lookup() resul=
ts become invalid ---
commit f032c4129aeef677df2aa27f38db191cca6b6b3d
Author: David Matlack <dmatlack@google.com>

KVM: arm64: Retry fault if vma_lookup() results become invalid

This commit reads mmu_invalidate_seq before dropping the mmap_lock to detect
if vma_lookup() results become stale before acquiring kvm->mmu_lock. It also
moves the MMU cache top-up earlier in user_mem_abort() to avoid spurious
fault retries.

Link: https://lore.kernel.org/r/20230313235454.2964067-1-dmatlack@google.com

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 26068456ec0f3..2cda74acada2e 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
[ ... ]
> @@ -818,32 +831,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
>  		fault_ipa &=3D ~(vma_pagesize - 1);
> =20
>  	gfn =3D fault_ipa >> PAGE_SHIFT;
> -	mmap_read_unlock(current->mm);
> =20
> -	/*
> -	 * Permission faults just need to update the existing leaf entry,
[ ... ]
> -	if (fault_status !=3D FSC_PERM || (logging_active && write_fault)) {
[ ... ]
> -	}
> -
>  	mmu_seq =3D vcpu->kvm->mmu_notifier_seq;
> -	/*
> -	 * Ensure the read of mmu_notifier_seq happens before we call
> -	 * gfn_to_pfn_prot (which calls get_user_pages), so that we don't risk
> -	 * the page we just got a reference to gets unmapped before we have a
> -	 * chance to grab the mmu_lock, which ensure that if the page gets
> -	 * unmapped afterwards, the call to kvm_unmap_hva will take it away
> -	 * from us again properly. This smp_rmb() interacts with the smp_wmb()
> -	 * in kvm_mmu_notifier_invalidate_<page|range_end>.
> -	 */
> -	smp_rmb();
> +	/*
> +	 * Read mmu_notifier_seq so that KVM can detect if the results of
> +	 * find_vma_intersection() or gfn_to_pfn_prot() become stale prior to
> +	 * acquiring kvm->mmu_lock.
> +	 *
> +	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
> +	 * with the smp_wmb() in kvm_mmu_notifier_invalidate_range_end().
> +	 */
> +	mmap_read_unlock(current->mm);
> =20
>  	pfn =3D gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);

[Severity: Critical]
Does removing the explicit smp_rmb() here in user_mem_abort() break the MMU
notifier retry protocol?

The comment states that we can rely on mmap_read_unlock() for an implicit
smp_rmb(). However, mmap_read_unlock() via up_read() typically provides only
RELEASE semantics.

RELEASE semantics prevent prior memory operations from being reordered past
the unlock, but they do not prevent subsequent memory reads from being
hoisted up before the unlock.

This means the CPU is permitted to reorder the lockless page table reads
inside gfn_to_pfn_prot() to execute before the read of kvm->mmu_notifier_seq
occurs.

If a concurrent MMU notifier (e.g. from page reclaim) unmaps the page and
increments the sequence counter between the hoisted PFN read and the
mmu_seq read, KVM would capture the new sequence number.

Would this cause the mmu_notifier_retry() check under mmu_lock to falsely
succeed, allowing KVM to map a freed host page into the guest's stage-2
page tables?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821090538.3493=
280-1-doebel@amazon.de?part=3D1

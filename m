Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488BB45D5EA;
	Wed, 29 Jul 2026 11:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785323923; cv=none; b=QejdhZglSkFZN4iNdYkmowjF6UY1P6APBwlqI680XNDfM6G8Pk0wpI4My+Vv/z4353DMSyJ9QOj9Pv5WWlEejyD+shcvYikJlPumt/sKOa8QDyHY+NPTwk7pycy+joyIgKF46PcqPH7oqpjSUHlSmdFWx6Y9z6e8K5laHlPFIHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785323923; c=relaxed/simple;
	bh=++bSxl20HLx+h9xti22qG58rGMWk83XlZz8rHEJ1I54=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=k1oElpLir7dxcTo5q/X4+ar/8R0/1vn4GPZaREn6fq+p2gCbsDghj6BX8CTJ9/YIqC2qRr5kyqtdOo/PlrmSf/LVqXGaGQguw5c01P4izrFLMqlUc4Ix7m9dpZ6qBHWKT3JeCTXCfdxdckLpFtbLPR+rmBCkX0YIY6lrFG5tZWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JtKXt6TL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JtKXt6TL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A501F000E9;
	Wed, 29 Jul 2026 11:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785323922;
	bh=oMhh3k36sEhrErqXi44EBnMWfkCt5wo3hwKFA1Stt+U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JtKXt6TL3YAOfN9IRCt2vDdh1qNJfyYbvwP2XFAfnfQYEjujqlSrT9uAaPvJigzE5
	 TIsUNcAfruyOrxD/wG4ip2WlvqTtuNfuQ/bREnszwMgDiOLaSnfiVd/ygbuS2ZQCr8
	 WT1SuF+LKURlziibMQE//VXqOTy8YsoiTEnZgMb5GpdSnGFn2e8FIkyD/YIF4t8AZu
	 0kbdL0Up3NbyfAPNusy6O0Wcy/irGB7QEJdZSgz2OzhU/j0PtjJKZ5RnfiMCYEAvD5
	 A5LA6k7IBTOcj/0+6x4gSmTjjrJp0VEU1CJlHvmSfQeNnBPNGQ7B2bKYOENv3pZbzO
	 T6jq7AT/EJe+w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/11] KVM: arm64: Add hardware-accelerated
 dirty-bitmap cleaning routine
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260729104548.3439958-7-leo.bras@arm.com>
References: <20260729104548.3439958-1-leo.bras@arm.com>
 <20260729104548.3439958-7-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 11:18:41 +0000
Message-Id: <20260729111841.B3A501F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] Dropping `mmu_lock` during eager page splitting allows concurr=
ent guest writes to be permanently lost.
- [Critical] Direct EL2 system register access from EL1 host kernel trigger=
s an UNDEFINED exception on nVHE/pKVM systems.
- [High] Infinite hardware polling loop with preemption disabled risks hard=
 lockups and renders the preempt notifier dead code.
--

--- Patch [6]: [PATCH v3 06/11] KVM: arm64: Add hardware-accelerated dirty-=
bitmap cleaning routine ---
commit 67bd2745169abaea5a656577d6b7add50b3e09f1
Author: Leonardo Bras <leo.bras@arm.com>

KVM: arm64: Add hardware-accelerated dirty-bitmap cleaning routine

Implement arm64 version of kvm_arch_dirty_log_clear() making use of FEAT_HA=
CDBS.
It converts dirty bitmap entries into HDBSS entries in 64-page blocks and f=
eeds
them to the HACDBS mechanism to clear dirty states. It also supports hugepa=
ge
splitting.

> diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/=
asm/kvm_dirty_bit.h
> index dd16438f06518..d368a23a84b30 100644
> --- a/arch/arm64/include/asm/kvm_dirty_bit.h
> +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
[ ... ]
> +static inline bool kvm_arch_dirty_clear_enabled(struct kvm *kvm)
> +{
> +	return system_supports_hacdbs() &&  kvm->arch.mmu.pgt &&
> +	       (kvm->arch.mmu.pgt->flags & KVM_PGTABLE_S2_DBM);
> +}

[Severity: Critical]
Does this check need to verify if the kernel is running in VHE mode?

If this executes on an nVHE or pKVM system (where the host runs at EL1),=20
and the hardware supports HACDBS, the ioctl will proceed and call=20
dirty_bit_clear(). That function directly accesses EL2 system registers=20
like SYS_HACDBSCONS_EL2, which will trap or UNDEF when accessed from EL1.

> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> index 33826bbd16d91..5a6266205295e 100644
> --- a/arch/arm64/kvm/dirty_bit.c
> +++ b/arch/arm64/kvm/dirty_bit.c
[ ... ]
> +int __kvm_arch_dirty_log_clear(struct kvm *kvm,
> +			       struct kvm_memory_slot *memslot,
> +			       struct kvm_clear_dirty_log *log,
> +			       unsigned long *bitmap,
> +			       bool *flush)
> +{
[ ... ]
> +	write_lock(&kvm->mmu_lock);
> +
> +	for (unsigned long i =3D start; i < end; i++) {
> +		unsigned long mask;
> +		gfn_t offset;
> +		atomic_long_t *p;
> +
> +		if (log) { /* Clean only what is in the input bitmap */
> +			mask =3D bitmap[i - start];
> +			if (!mask)
> +				continue;
> +
> +			p =3D (atomic_long_t *)&dirty_bitmap[i];
> +			mask &=3D atomic_long_fetch_andnot(mask, p);
> +		} else { /* Clean everything, save to output bitmap */
[ ... ]
> +		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> +			kvm_mmu_split_huge_pages(kvm,
> +						 gfn_to_gpa(offset + __ffs(mask)),
> +						 gfn_to_gpa(offset + __fls(mask) + 1));

[Severity: Critical]
Could this lead to silent memory corruption due to dropped locks?

The software dirty bit is cleared above via atomic_long_fetch_andnot().=20
Then we call kvm_mmu_split_huge_pages(), which drops mmu_lock internally:

kvm_mmu_split_huge_pages()
  need_split_memcache_topup_or_resched()
  write_unlock(&kvm->mmu_lock);
  cond_resched();

While the lock is dropped, a vCPU can write to the page without trapping
because the hardware DBM bit is still set. Once the lock is reacquired,=20
dirty_bit_clear() clears the hardware DBM bit. The write gets lost because
both software and hardware bits are now clean.

> +		do {
> +			idx =3D mask_to_hdbss(&mask, hw_entries, offset, ttwl, idx, entries_s=
z);
> +			if (idx >=3D entries_sz) {
> +				ret =3D dirty_bit_clear(kvm, hw_entries, idx);

[Severity: High]
Is there a risk of a hard lockup here during hardware polling?

Looking at dirty_bit_clear(), it polls SYS_HACDBSCONS_EL2 in a while (true)
loop without a timeout fallback.=20

Since __kvm_arch_dirty_log_clear() takes write_lock(&kvm->mmu_lock) before=
=20
calling dirty_bit_clear(), preemption is disabled on non-RT kernels. This=20
makes the preempt_notifier registered inside dirty_bit_clear() dead code=20
and guarantees the CPU will spin forever if the hardware hangs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729104548.3439=
958-1-leo.bras@arm.com?part=3D6

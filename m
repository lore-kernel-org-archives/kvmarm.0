Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAA34570EE;
	Wed, 29 Jul 2026 11:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785323336; cv=none; b=Ddw3rXU1bg5EttC0CLvo9B3Db6GjkfFIrejqW5ZjFhmgcnRvQ3rH+jfS0oAlhk4T9V73i4JZ/BWgS1ziLJrFkZ7TztV0ZOAyFXtkVeoB7zEZqWp0F7i/Y+gLndaxMK9kLWBpMvZEN6F4kb/seAv+yJ3sV9nVmJZnXbJiYyM2hUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785323336; c=relaxed/simple;
	bh=WsBB2fJ0g6xkP5QNn6rYrqJIAmkolyD6LzqYwWBdFPE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=i7x55dXThNwNqg8cEQlnUa2rLdXaiXfnffcanZaNod7fdsZwjbiDsABdArbbBgHx//pjDsl6LGBKFo9FqEhgppH40aw3IJJKY+pUvpOEHGtSN4dBbXbQBd6eI99/GMGUyrAKlOKJPMsfpHRDOdUKN+nXZO8QOayw+U5szt/dTq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jYC33EAJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jYC33EAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFC31F000E9;
	Wed, 29 Jul 2026 11:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785323335;
	bh=1E/IOmJhpU2BpQ7aoq5kfvtFwML8C52qc0I0D3sPGrg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jYC33EAJxYKfwH2xOcHF7wjjYl6u9St/2IlUl87zG1ttabayO0tStS2vO9VL9RCLt
	 p9AtEmJRoXjaNrT1myLW2GNifYFw5UlbLhrFbwikq7bMIbFBIdyyt2v+oPNWVMoPCS
	 enE3+PrbzEyG5JYupW3Fs4RnR5HONvTdMcGBdjd+sV0ejwP5OWuNViUmznpyG8bAb8
	 6cmtiN5hU/ZJlYIPD02bfkCltJ1MPfQBEB93SdUYqBx1ZJYvrXazzcdXJqQ+cj/MiI
	 Q5qvzXGxn20ok39996YV9+JVjex6uX38qZliqOykBfrDdvAAf8ZSvuGW4d0RedNpye
	 xUmIi81XvLF5A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 07/11] KVM: arm64: Dirty-bitmap: avoid splitting
 previously split blocks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260729104548.3439958-8-leo.bras@arm.com>
References: <20260729104548.3439958-1-leo.bras@arm.com>
 <20260729104548.3439958-8-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 11:08:54 +0000
Message-Id: <20260729110854.ACFC31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Dropping `mmu_lock` during eager page splitting creates a race win=
dow that can permanently lose hardware-managed dirty bits (FEAT_HAFDBS), le=
ading to silent guest data corruption during live migration.
--

--- Patch [7]: [PATCH v3 07/11] KVM: arm64: Dirty-bitmap: avoid splitting p=
reviously split blocks ---
commit fb963a566e307a780c669718446f8bf7c2c6ef94
Author: Leonardo Bras <leo.bras@arm.com>

KVM: arm64: Dirty-bitmap: avoid splitting previously split blocks

If previous dirty-clean already split a block, then avoid calling the
split helper on that block again.

> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> index 5a6266205295e..d7e624f9b6308 100644
> --- a/arch/arm64/kvm/dirty_bit.c
> +++ b/arch/arm64/kvm/dirty_bit.c
> @@ -295,10 +296,15 @@ int __kvm_arch_dirty_log_clear(struct kvm *kvm,
> =20
>  		offset =3D base_gfn + i * BITS_PER_LONG;
> =20
> -		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> -			kvm_mmu_split_huge_pages(kvm,
> -						 gfn_to_gpa(offset + __ffs(mask)),
> -						 gfn_to_gpa(offset + __fls(mask) + 1));
> +		if (kvm_dirty_log_manual_protect_and_init_set(kvm)) {
> +			gpa_t split_start =3D gfn_to_gpa(offset + __ffs(mask));
> +			gpa_t split_end =3D  gfn_to_gpa(offset + __fls(mask) + 1);
> +
> +			if (split_end > last_split) {
> +				kvm_mmu_split_huge_pages(kvm, split_start, split_end);

[Severity: High]
Can this sequence lose dirty state due to a race with hardware dirty bit
management?

In __kvm_arch_dirty_log_clear(), the software dirty_bitmap for the target p=
ages
is fetched and cleared before reaching this point.

When kvm_mmu_split_huge_pages() is called, it can temporarily drop
kvm->mmu_lock to allocate memory.

During this unlocked window, a vCPU could locklessly write to the page. With
FEAT_HAFDBS enabled, the hardware automatically sets the PTE dirty bit with=
out
trapping to KVM.

After the lock is reacquired, the loop proceeds to dirty_bit_clear(), which
unconditionally clears the hardware PTE dirty bit (via FEAT_HACDBS).

Because the software bitmap was already cleared and the hardware state is w=
iped
without feeding the dirty state back, could a write during the unlocked win=
dow
be permanently lost if userspace reads the page data before the clear opera=
tion?
The next KVM_GET_DIRTY_LOG would not see it.

> +				last_split =3D ALIGN_DOWN(split_end - 1, PMD_SIZE) + PMD_SIZE;
> +			}
> +		}
> =20
>  		do {
>  			idx =3D mask_to_hdbss(&mask, hw_entries, offset, ttwl, idx, entries_s=
z);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729104548.3439=
958-1-leo.bras@arm.com?part=3D7

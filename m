Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0CF31A065
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 14:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786543264; cv=none; b=JQLpYP4Ck5dE7fD/G3MgxiOCg5jxi7V907qIbxPw6kkk1coBJX+lXx1Zqa2luyVhJUCwwqXh+UoTQhmmD3+OJ/Utp5bvhYYXO6ItjcSgQAfvW1e10jISMTY/ODTw9UrpoRonWMn907h/F4+NSUXdwyNx+q8jHG6E4yCbpm+ewgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786543264; c=relaxed/simple;
	bh=WOJInSgW85XGZONmFlBScgLbqy0owEpxbjypHhGgWrM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OBvPjpVNy6QlndmtZEc9w4tUSGrWXfHQsTO3RbcpKwyOOWCyQPlBtkOF/tTxYpE2P3TuU8Wnu4NYiWuhgtc+B7nw7rWwJPAWh728Ip/whEQ/r1urCvdIpVatC+P37yKXnE9eRtwOXOai76ANrYI+hcYCZuoEBe+L+A/chTBbBjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mNtttJb7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNtttJb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77AC1F000E9;
	Wed, 12 Aug 2026 14:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786543262;
	bh=B+KghM+r7Uc99cx5iGZohqhy3vsTCtziRQv6LyEQlGc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mNtttJb7sqLXa/7m5guBfAm6v9C+t5zRVvy6UYykEh3e2ohNdHxZw80b3Xizrm22Z
	 c7dwEz2FoGbZ5825cKJHlIp0abel3gm2TfKmcQ/b3FS7lg2cXNepDS49qvFMTm4ofw
	 AiJ8n7tyqGWnt/usLAmHx3v6azOcUS6jZIVNyNvMMXOiRMrTxA8yHYA8tzUNef03Bb
	 EtK8ZmWD1MuUZHrIY4cJ/ZY0XtKhSMoDKWaHcPrCrwkZxV9yoAVlqhlkkSYFVEQcJk
	 urkgzkQZP9fa9bKASgu/FrlWVBaVnlcgFJ2r/9WzcamDZvQNVHhUVvZfCIWg2CscXj
	 4e7F5loTLJfnQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: nv: Fix null ptr deref in
 kvm_nested_s2_unmap() on S2 teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260812-kvm-arm-nested-virt-fix-v1-2-4ad883f1b6a5@kernel.org>
References: <20260812-kvm-arm-nested-virt-fix-v1-0-4ad883f1b6a5@kernel.org>
 <20260812-kvm-arm-nested-virt-fix-v1-2-4ad883f1b6a5@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 14:01:01 +0000
Message-Id: <20260812140101.D77AC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Use-After-Free on `kvm->arch.nested_mmus` array due to concurr=
ent teardown.
- [Critical] Incomplete Fix: `kvm_nested_s2_wp()` is vulnerable to the same=
 NULL pointer dereference and UAF.
- [High] Data Race: `kvm->arch.nested_mmus_size` updated locklessly causing=
 uninitialized memory reads.
--

--- Patch [2]: [PATCH 2/2] KVM: arm64: nv: Fix null ptr deref in kvm_nested=
_s2_unmap() on S2 teardown ---
commit 04c9d62ec51b0000a28c8099341f6a2d31ce7848
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

KVM: arm64: nv: Fix null ptr deref in kvm_nested_s2_unmap() on S2 teardown

This commit adds a NULL check for kvm->arch.mmu.pgt in kvm_nested_s2_unmap()
to prevent a NULL pointer dereference. This happens when the MMU lock is
dropped during stage 2 teardown, allowing concurrent progress that clears t=
he
page table.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 17123f0b6daba..9fc0b1696dcb6 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1295,7 +1295,11 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may=
_block)
>  			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);

[Severity: Critical]
This isn't a bug introduced by this patch, but does this loop contain a
Use-After-Free vulnerability?

While iterating over the nested_mmus array in kvm_nested_s2_unmap(),
kvm_stage2_unmap_range() can drop kvm->mmu_lock inside stage2_apply_range().

Concurrently, if kvm_mmu_notifier_release() calls kvm_arch_flush_shadow_all=
(),
it frees the kvm->arch.nested_mmus array unconditionally and without taking
kvm->mmu_lock:

kvm_arch_flush_shadow_all() {
    ...
    kvfree(kvm->arch.nested_mmus);
    ...
}

If the array is freed during the lock-drop window, the local mmu pointer
becomes dangling, and accessing it when the lock is reacquired could result
in a Use-After-Free.

>  	}
> =20
> -	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
> +	/* NULL pgt should only be possible if raced when mmu_lock dropped. */
> +	if (kvm->arch.mmu.pgt)
> +		kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
> +	else
> +		WARN_ON(!may_block);
>  }

[Severity: Critical]
This is a pre-existing issue, but does kvm_nested_s2_wp() suffer from the e=
xact
same NULL pointer dereference and Use-After-Free vulnerability?

Like kvm_nested_s2_unmap(), kvm_nested_s2_wp() iterates over the nested_mmus
array and drops mmu_lock via stage2_apply_range_resched(). When it resumes
and exits the loop, it also unconditionally executes
BIT(kvm->arch.mmu.pgt->ia_bits).

Should the same fix be applied to kvm_nested_s2_wp() to prevent a guaranteed
NULL pointer dereference when kvm_arch_flush_shadow_all() clears the page
table in the window where the lock is dropped?

[Severity: High]
This isn't a bug introduced by this patch, but is there a data race on
kvm->arch.nested_mmus_size?

In kvm_vcpu_init_nested(), nested_mmus_size is updated outside of
kvm->mmu_lock and without memory barriers:

kvm_vcpu_init_nested() {
    ...
    kvm->arch.nested_mmus_size =3D num_mmus;
    ...
}

A concurrent reader like kvm_nested_s2_unmap() can see the updated size
before the stores initializing the new array elements become visible. Becau=
se
the new array is allocated with kvcalloc(), an uninitialized/zeroed
mmu->tlb_vttbr causes kvm_s2_mmu_valid() to incorrectly evaluate to TRUE.

Will this cause the reader to process the zeroed mmu structure, passing it
to kvm_stage2_unmap_range(), which would dereference a NULL mmu->pgt or
access a partially initialized pgt?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812-kvm-arm-ne=
sted-virt-fix-v1-0-4ad883f1b6a5@kernel.org?part=3D2

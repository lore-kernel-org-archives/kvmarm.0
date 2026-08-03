Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E19D3955D0
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 11:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785754918; cv=none; b=sJmUt4Qm8U6XWWkbRHUoLvUpO1puet3SWwAs2yPHaICzoqI2/7rvb/iYRK/fCexgER71erNwk/M3OC2L0UOhC6KlsqApztWgfVHBt+v0BQQS6UzjDofc/YnkQpzLEtF+RC5PVuOcVqL3LfdnvQN8fOSlofiw14RJSpCENtn1hGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785754918; c=relaxed/simple;
	bh=Bq2xm+s0qxu3ePyCA9gqiNnhwa2OxXwy3hlGj4jfUjY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iIwwmpy/glyMDqLe4cNIuVY7bOQcmG2bVw3wE7sy10R9qy4KiNpmfZannNd4kIRL/pcxMJPt0W/F7RFVZ5Z4syiggWaT3YevtiO04cbjwNOHF/IEvFCBU/3B2IqpUZgIN/o4AIks+aQMx45BH3LKtrBrCaXl9qdYk81PkSQG5yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ip8dtK5X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ip8dtK5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF3C1F000E9;
	Mon,  3 Aug 2026 11:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785754916;
	bh=64x/cguEuLNOVnKCcn8k4c7QJjuBrIviG3INAvYcKPQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ip8dtK5XyRUeDI5KHn3xgHVVaOHMbJgcVSNUzynC3Hl1zawRkGzMUg0tFAFuBcyQs
	 PrsntE+EhnF1C1Ec3Ek+eMpykbJzzrrOaO/GswI79GyZgqGquiA/QfjkaGVZuJyu+B
	 So0vE8f7lTfo3z4e7B+oBN/bomC+oIF+H2APjJ/4VDmYMEANKGwkfDMfqSBNHzWKSI
	 LCJEu9JWSnPhAOBba6mgBCqfXg6RxRyCGhtqTsPw1fg8M5FUBl7+X5GcuSvp4R+1Pz
	 1MH2P9NF8nfOrRn6Jx5xJNCoKLnMoQ+Zott7QlJ8PzCaPua1bpvpoFbz+j9CSyJIBw
	 uxoNAeBghmJrA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 17/20] KVM: arm64: Extend pKVM page ownership selftests
 to cover guest block split
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260803100904.3563942-18-vdonnefort@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-18-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 11:01:55 +0000
Message-Id: <20260803110156.3BF3C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] __pkvm_host_split_guest fails to roll back host stage-2 metadata m=
utations if the subsequent guest stage-2 split fails, permanently desynchro=
nizing EL2 metadata.
- [High] __pkvm_host_split_guest does not verify that the guest page is exc=
lusively owned before splitting, allowing the host to crash EL2.
--

--- Patch [17]: [PATCH 17/20] KVM: arm64: Extend pKVM page ownership selfte=
sts to cover guest block split ---
commit 44307942b6acd5f1f5aeff005f1df6122f7a4e1e
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Extend pKVM page ownership selftests to cover guest block split

This commit extends the pKVM page ownership selftests to cover the split
of a guest stage-2 block. It also adds tests for the per-page reclaim of
that same block.

> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/n=
vhe/mem_protect.c
> index 71ebd1856cb0c..e22a7991f8ec7 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -2070,6 +2070,38 @@ int __pkvm_ownership_selftest(u64 pfn, u64 nr_page=
s, u64 pgtable_pfn,
>  	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, nr_pa=
ges, vcpu);
>  	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, nr_pag=
es, vcpu, prot);
> =20
> +	if (size =3D=3D PMD_SIZE) {
> +		/* [gfn, gfn + nr_pages) was poisoned. Skip it */
> +		gfn +=3D nr_pages;
> +
> +		selftest_state.host =3D PKVM_NOPAGE;
> +		selftest_state.guest[1] =3D PKVM_PAGE_OWNED;
> +		assert_transition_res(0,	__pkvm_host_donate_guest, pfn, gfn, nr_pages,=
 vcpu);
> +		assert_transition_res(0,	__pkvm_host_split_guest, gfn, nr_pages, vcpu);

[Severity: High]
Is a rollback missing in __pkvm_host_split_guest() if the guest stage-2 spl=
it
fails?

Looking at __pkvm_host_split_guest(), if kvm_pgtable_stage2_split() fails
(e.g., due to -ENOMEM from an empty memcache), the function returns without
undoing the host_mmu.pgt mutation performed by host_stage2_split_gfn_meta():

    ret =3D host_stage2_split_gfn_meta(phys, ipa, size, vm);
    if (ret)
        goto unlock;

    ret =3D kvm_pgtable_stage2_split(&vm->pgt, ipa, size, mc);

    unlock:

This would leave the host tracking split into PAGE_SIZE annotations while t=
he
guest stage-2 retains an unsplit PMD block.

Since host_stage2_split_gfn_meta() fails if the host block is already split,
any future attempt to split the block would fail with -EINVAL, permanently
desynchronizing EL2 metadata.

[Severity: High]
Can a guest page that is not exclusively owned be split by
__pkvm_host_split_guest()?

If the host issues the __pkvm_host_split_guest HVC for a guest page that is
currently shared with the host (guest PTE state is PKVM_PAGE_SHARED_OWNED):

    ret =3D get_valid_guest_pte(vm, ipa, size, &pte, &phys);
    if (ret)
        goto unlock;

    ret =3D host_stage2_split_gfn_meta(phys, ipa, size, vm);

get_valid_guest_pte() only verifies that the PTE is valid, so it succeeds
without checking the actual ownership state.

Then, host_stage2_split_gfn_meta() reads the host stage-2 leaf PTE (which is
valid because the page is shared and ID mapped) and passes it to
host_stage2_decode_gfn_meta().

Could this trigger WARN_ON(kvm_pte_valid(pte)), crashing the hypervisor and
allowing the host to take down EL2?

> +
> +		assert_transition_res(-E2BIG, __pkvm_host_split_guest, gfn, nr_pages, =
vcpu);
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803100904.3563=
942-1-vdonnefort@google.com?part=3D17

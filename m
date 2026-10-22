Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792650650;
	b=MjKp9C/UTnbcIsYiraiEiTWCsXicJb3JF/lJLWRyqNsyhncWX4H36IzFTaPKBNsyETHv
	 cTMrWeKXeo1/w8r5D5osEfJ3CL4L0mnYmPvPFk6vEnWmTuymLCQi7QMnhunEHnrxxdqgy
	 wiueY0jE8vCHmT7vStYBe5Y6GM9CcovvqI6Pl8s4d7Hzv14YVkDyJAX5SgqOiZCkuMABf
	 kO4EIrWKIP95LI3uOa3Lx8f2bGKvE/mwJ6Xo+TAdK3M7ohzQzsvUX2OmPpM6wgNbg3rdO
	 Nrw/jOgF5T15DaQ6AuspVF8/SJxt/I0cDtlELMrNlsJxWwQz6UGHLdZiNHGKNjptTmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792650650;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GE58JakduYDn+ctLNsuwPapnuXvCLRfp38EJPuY8zh8=;
	b=QL0DDakGxyNXG14gGeBJECk9zWTo9z0C5D/XReAGx9fqKrFeP5EydA1tvMFoMSy2+HYT
	 ImJ6oZf4PjDfu/dQynwDoBxOQvRXVCWULtY3ju/1WRKGIkmjYXrxw3bfPTKAgdN2AEOIx
	 xeBxKJo4PGVhpW4MMM1u/+mLL3yZhshEqOkysVq6n/MG4WSwafMQ9s/BcKEXHkIV2374n
	 +3eOjAORHkIhkhzJgyhn8kSeBf7lNe27YlXFmlT+GYQb6I3vryDQf97z9EyFknykn9yv8
	 d71tGHjADfAWlEUtpwcPqQ/grswA8+euxI7KwJHG8slHQj7AYGv/DCSXc8oiCU0AkbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BVUBsy4W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AC0606A319;
	Thu, 22 Oct 2026 06:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BVUBsy4W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1888F1F000C1;
	Thu, 22 Oct 2026 06:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792650650;
	bh=GE58JakduYDn+ctLNsuwPapnuXvCLRfp38EJPuY8zh8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BVUBsy4WkEA5D5/B+y2a1Oe7sZpilEUQKtnoMJKMwk/jEwdraTm7cjNEvScdAaMw1
	 T7MELsNIxrsk2YLjx0SSY6yJFevAHp9nTM43ffJ3YtRilFLJkJ9DMnY4tEKArZTAMj
	 1vLaf7AhtyV30biC3JR0CSOXBdWiIrC4D2HkwDsFDel43dtUFnJo0GF7XopNuwZyIq
	 jmlNC/3qMIN5HV+Uk+hG1E3tqkE6LSE2mE4SV7tM94DNkKHIHT1SMcygGCCsbu7akY
	 ozekdBsxykFaMlg/wPk+gyQqBz2dKzimQJ3VAwgrqumlPzmC4ED02CWXEbKJyUY7C3
	 GPhXb4WO0xp+A==
Message-ID: <sashiko-outbox-181096@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: selftests: Test VNCR translation
 invalidation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Itaru Kitayama" <itaru.kitayama@fujitsu.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261022-b4-vncr-mapping-test-v1-1-e9ad54d506be@fujitsu.com>
References: <20261022-b4-vncr-mapping-test-v1-1-e9ad54d506be@fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 06:30:49 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] KVM: arm64: selftests: inverted page_mask in prepare_memory()
--

commit 0e10db3329f0ad09596d72a6be111f7048817b36
Author: Itaru Kitayama <itaru.kitayama@fujitsu.com>

KVM: arm64: selftests: Test VNCR translation invalidation

This commit adds a standalone arm64 kvm selftest that remaps the backing
page for vncr_el2 across stage-1 page-table updates and tlb invalidations
to verify that redirected register accesses reach the updated backing page.

> diff --git a/tools/testing/selftests/kvm/arm64/nv_vncr_tlbi_test.c b/tool=
s/testing/selftests/kvm/arm64/nv_vncr_tlbi_test.c
> new file mode 100644
> index 0000000000000..93219d036de6d
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/arm64/nv_vncr_tlbi_test.c
[ ... ]
> +/* Add a guest virtual alias for an existing guest physical page. */
> +static u64 map_alias(struct kvm_vm *vm, u64 gpa)
> +{
> +	u64 va =3D vm_unused_gva_gap(vm, vm->page_size,
> +				  KVM_UTIL_MIN_VADDR);
> +
> +	virt_map(vm, va, gpa, 1);
> +	return va;
> +}
> +
> +static void prepare_memory(struct kvm_vm *vm)
> +{
> +	u64 a =3D vm_alloc_page(vm);
> +	u64 b =3D vm_alloc_page(vm);
> +	u64 page_mask =3D ~((u64)vm->page_size - 1);
> +	u64 stack =3D vm_alloc_pages(vm, DEFAULT_STACK_PGS);
> +	u64 ptep_gpa, ptep_alias;
> +	u64 *ptep;
> +
> +	cfg.slot_a =3D (u64 *)(a + VNCR_TPIDR_OFFSET);
> +	cfg.slot_b =3D (u64 *)(b + VNCR_TPIDR_OFFSET);
> +	cfg.l2_sp =3D stack + DEFAULT_STACK_PGS * vm->page_size;
> +
> +	/* Initially, the separate VNCR virtual address maps page A. */
> +	cfg.vncr_va =3D map_alias(vm, addr_gva2gpa(vm, a));
> +
> +	ptep =3D virt_get_pte_hva(vm, cfg.vncr_va);
> +	cfg.pte_a =3D *ptep;
> +	cfg.pte_b =3D *virt_get_pte_hva(vm, b);
> +
> +	TEST_ASSERT(cfg.pte_a !=3D cfg.pte_b,
> +		    "Backing pages must have different descriptors");
> +	TEST_ASSERT((cfg.pte_a & (PTE_VALID | PTE_TYPE_PAGE)) =3D=3D
> +		    (PTE_VALID | PTE_TYPE_PAGE),
> +		    "VNCR mapping must use a leaf page descriptor");
> +
> +	/*
> +	 * Map the page containing the descriptor into L1, so L1 can
> +	 * perform its own page-table update and architectural TLBI.
> +	 */
> +	ptep_gpa =3D addr_hva2gpa(vm, ptep);
> +	ptep_alias =3D map_alias(vm, ptep_gpa & ~page_mask);
> +	cfg.vncr_ptep =3D (u64 *)(ptep_alias + (ptep_gpa & page_mask));

[Severity: Medium]
Are page_mask and ~page_mask inverted when mapping ptep_gpa and computing
cfg.vncr_ptep in prepare_memory()?

Since page_mask is initialized to ~((u64)vm->page_size - 1), it holds the
upper page-frame mask while ~page_mask holds the intra-page offset mask.

Passing ptep_gpa & ~page_mask to map_alias() supplies the intra-page byte
offset of ptep_gpa rather than the page-aligned guest physical address,
which trips the alignment assertion in map_alias() -> virt_map() ->
virt_pg_map() -> _virt_pg_map():

tools/testing/selftests/kvm/lib/arm64/processor.c:_virt_pg_map() {
    ...
	TEST_ASSERT((gpa % vm->page_size) =3D=3D 0,
		    "Physical address not on page boundary,\n"
		    "  gpa: 0x%lx vm->page_size: 0x%x", gpa, vm->page_size);
    ...
}

Similarly, adding (ptep_gpa & page_mask) to ptep_alias adds the page-frame
base address rather than the intra-page offset, leaving cfg.vncr_ptep
pointing to an unmapped guest virtual address when remap_vncr() writes to
*cfg.vncr_ptep.

Should this pass ptep_gpa & page_mask to map_alias() and add ptep_gpa &
~page_mask to ptep_alias?

> +
> +	sync_global_to_guest(vm, cfg);
> +}
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022-b4-vncr-ma=
pping-test-v1-1-e9ad54d506be@fujitsu.com?part=3D1

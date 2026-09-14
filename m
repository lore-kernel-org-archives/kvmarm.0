Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B90485CC3
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 13:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789390914; cv=none; b=tR56zcDEWXJBx8JvOcGc36ihqiQXM+3Di+zQ4U9diNnXpmq6HqpA7g5M68wH356xsfck+Q+ptyVpglfAPXxQl5awneZ2lg1DNxnEVUPKod0QteDvWWAS70+Pnwo2j3gYt1we+57/nYgRzSjK+ydZf/H1n3FNWktpeMYLKd3BaYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789390914; c=relaxed/simple;
	bh=HXihBFKuM+TeMCltIocLboIkz4NjuAng8WGxVVTl9xg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ffxy+Bg9eeMEA1YdmUNYwvAHzTp15DLOttii8xIjL0eGDHUOF4aDmR6VGiKbCirlOgGqb0Jj0DLaOkQbYFynpN46/OgTEhgFsqav7pcpIFlUeRbsFbGqTk0k9TyqVVVwNb2qCN1Zbf6AT5xvdkUVLgs109zjnE4x29oAJEuoDcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XyOYvktl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XyOYvktl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D5F1F000FF;
	Mon, 14 Sep 2026 13:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789390913;
	bh=w53SMl5H/sqwd5sswNVNY/ask4zw/X5pfRz5qy8sjpg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XyOYvktl2Q/nkAaPz2XSyVAGFBKPeischCG93I59TCXbowCbezhIteSBGfsRnkc/d
	 pZezkjjp5iVfDJ/WuHO3kOW2LT0EbM0V34yhPK8rpicl/HKInsXghm+nadclety1on
	 N66WIrBj/icGqKeRdzx470lCtRBw0+we0i0Ybd0J+3RK5vRWbHgUG0m6S3At1ZNplu
	 21o8gRBcs7oRb9GFY/OZkf6T5Itfa9UzpIo9kjr5NjeiYwOXkYtyJT0K8L7zpIuKZ5
	 9dlrSjXK0E3SnsZvym0lcXuvcrDSsj8jlhTof+4aR/97c8VT2df4yZVkQo8UsWVMA3
	 YdxrYHct+wJFw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 03/18] KVM: arm64: Pin the host vCPU before adjusting
 its PC under pKVM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260914113338.159227-4-fuad.tabba@linux.dev>
References: <20260914113338.159227-1-fuad.tabba@linux.dev>
 <20260914113338.159227-4-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 13:01:52 +0000
Message-Id: <20260914130152.F0D5F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Unmapped host `kvm_s2_mmu` pointer dereference in EL2 TLB flus=
h handlers panics the hypervisor before the first KVM_RUN.
--

commit 201c7baf4784bec3cde62591e1662c2fd50608dc
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Pin the host vCPU before adjusting its PC under pKVM

This commit fixes a hypervisor panic in pKVM caused by dereferencing an
unmapped host vCPU before its first KVM_RUN. It introduces temporary pinning
of the host vCPU around __kvm_adjust_pc() when no hyp vCPU is loaded.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index b6bfe502bcd04..52a65b13b3810 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -546,8 +546,25 @@ static void handle___pkvm_host_mkyoung_guest(struct =
kvm_cpu_context *host_ctxt)
>  static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
>  {
>  	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
> +	struct pkvm_hyp_vcpu *hyp_vcpu;
> +	struct kvm_vcpu *host_vcpu;
> +
> +	host_vcpu =3D __get_host_hyp_vcpus(vcpu, &hyp_vcpu);
> +	if (host_vcpu) {
> +		__kvm_adjust_pc(host_vcpu);
> +		return;
> +	}
> +
> +	/*
> +	 * With no hyp vCPU loaded for it, the host vCPU may be unpinned,
> +	 * and so unmapped at EL2: its first run pins it.
> +	 */
> +	host_vcpu =3D kern_hyp_va(vcpu);
> +	if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1))
> +		return;
> =20
> -	__kvm_adjust_pc(kern_hyp_va(vcpu));
> +	__kvm_adjust_pc(host_vcpu);
> +	hyp_unpin_shared_mem(host_vcpu, host_vcpu + 1);
>  }

[Severity: Critical]
This is a pre-existing issue, but does this same vulnerability apply to the
TLB flush handlers in this file?

If a userspace process creates a VM and a memory slot, and then immediately
deletes it via KVM_SET_USER_MEMORY_REGION with a zero memory size before
the first KVM_RUN, this triggers kvm_arch_flush_shadow_memslot().

This unconditionally calls kvm_tlb_flush_vmid_range(), which issues an HVC
call that ends up in handle___kvm_tlb_flush_vmid_range():

arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___kvm_tlb_flush_vmid_range() {
	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
	DECLARE_REG(phys_addr_t, start, host_ctxt, 2);
	DECLARE_REG(unsigned long, pages, host_ctxt, 3);

	__kvm_tlb_flush_vmid_range(kern_hyp_va(mmu), start, pages);
}

Since the kvm struct (containing kvm_s2_mmu) is not pinned until
pkvm_create_hyp_vm() runs during the first KVM_RUN, passing kern_hyp_va(mmu)
without pinning it first might cause a data abort at EL2.

The unmapped pointer is eventually dereferenced in enter_vmid_context():

arch/arm64/kvm/hyp/nvhe/tlb.c:enter_vmid_context() {
	...
	__load_stage2(mmu);
	...
}

arch/arm64/kvm/hyp/nvhe/tlb.c:__load_stage2() {
	write_sysreg(mmu->vtcr, vtcr_el2);
	...
}

Since this is the exact same sequence described in the commit message (a ho=
st
pointer unmapped at EL2 being dereferenced before the first run), should we
also pin the mmu pointer around these TLB flush operations?

> =20
>  static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_c=
txt)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914113338.1592=
27-1-fuad.tabba@linux.dev?part=3D3

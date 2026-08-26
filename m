Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F743515F3;
	Wed, 26 Aug 2026 23:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787786546; cv=none; b=MtbG3ab6npGbV1nfHCBHMP5S7iokiTYo61asmy34sBwaF0AFdl8iOlkjH5tzMAgQ+KAUQp2oNpiHkXT+MzB7V3q6Jwz35yqcE0uX2qU1aLHVUZ0ichbNwMlrD1JjaP9+fmaV9h/3MjWkxopYtU+zW+ga5YzR+Xsboxvh6W3Ps7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787786546; c=relaxed/simple;
	bh=Oyc3zaTHlqjl77igWL48/52gchGq6M+X1+Hf3kqWgXE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=goO+xzUUQ/I1TxproTQY5zFCM70vfEA/q6a6jR+a5W8Rc+6yOX6ZLPTXgo811KhRR081rONd/FmvWhrIjXx9t/ZcMSYzje5e/VqFNENkPLYMV9g+WjrBhGY/8hO4BPDkpNBDLS/+WBhMscPeqv6MP3ogrLtuYM99RwudFFN/F1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XC5zHhSs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XC5zHhSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782021F000E9;
	Wed, 26 Aug 2026 23:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787786544;
	bh=X8MfiArkN/KQLtWeeRhEu2rkXo/YmtdjcLEjU60rSXI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XC5zHhSsZ54FWpdcLN4jZMuUUnXcpvTor0aCqgiCwu/RgcWHtI/G8gYVYrwcyq6YQ
	 sdYcGDjX99Be4PzvVX3GsZyZbWFIYC9uAvhiJgUtQXgFtx4Hj1N985bHpFTVo4qxMQ
	 e+7ruR6oEwCiOwWp5+JPXKpQSnjEQw6vJSTgi2b4JxUr1zxLbmtuvaVqxPHOxr6nqx
	 pCLD4A4oQghqEF2lS2m7dgg0wo22jhj039hQLEab5paeyyv5BVpJqRUA1ZFF8O2Uyc
	 rzgcrzPifyDB9z9qkG6QgDQ7JKxOXKIdfcdvfZvKUHsOolB6w0xBjnq/pKSMgrsnb4
	 35SMo5u8DHVRQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 02/20] KVM: selftests: Bump the minimum GPA for page
 tables to 0x200000
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260826230511.972824-3-seanjc@google.com>
References: <20260826230511.972824-1-seanjc@google.com>
 <20260826230511.972824-3-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 23:22:24 +0000
Message-Id: <20260826232224.782021F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Bumping the minimum page table GPA to 0x200000 causes the guest pa=
ge tables to overlap with hardcoded VGIC redistributor addresses on ARM64, =
and drastically reduces available memory in memslot 0 leading to resource e=
xhaustion.
--

commit bc2cd59874dd84e95239e4f7e4f0e21c3c8f7507
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Bump the minimum GPA for page tables to 0x200000

Bump the selftests minimum GPA for page tables to 0x200000 so LoongArch
can use vm_alloc_page_table() natively instead of an open coded equivalent.

> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testi=
ng/selftests/kvm/include/kvm_util.h
> index 5a7a455b53875..70906a0d1003c 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -175,7 +175,7 @@ static inline struct userspace_mem_region *vm_get_mem=
_region(struct kvm_vm *vm,
> =20
>  /* Minimum allocated guest virtual and physical addresses */
>  #define KVM_UTIL_MIN_VADDR		0x2000
> -#define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
> +#define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x200000

[Severity: High]
Does bumping the minimum GPA to 0x200000 cause the guest page tables to ove=
rlap
with the VGIC redistributor on ARM64?

In tools/testing/selftests/kvm/arm64/vgic_init.c:subtest_v3_redist_regions(=
),
the redistributor is hardcoded to be placed at the same address:

    addr =3D REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 0);
    kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
                        KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);

Because KVM maps the redistributor over memory, wouldn't the hardware MMU's
stage-1 page table walk attempt to read page table entries from an emulated=
 IO
region?

This seems like it would cause a stage-2 fault that KVM cannot handle for a
stage-1 page table walk, leading to an infinite exception loop.

Additionally, does starting allocations at 0x200000 severely reduce the
available memory in memslot 0?

In tools/testing/selftests/kvm/lib/kvm_util.c:vm_nr_pages_required(), memsl=
ot 0
is sized to be just slightly larger than 2MB:

    nr_pages =3D 512;
   =20
    /* Account for the per-vCPU stacks on behalf of the test. */
    nr_pages +=3D nr_runnable_vcpus * DEFAULT_STACK_PGS;

It seems like this leaves only a few pages for page tables. If a test has
multiple vCPUs, wouldn't it exhaust this tiny pool and trigger the abort in
tools/testing/selftests/kvm/lib/kvm_util.c:____vm_phy_pages_alloc()?

    enomem:
        fprintf(stderr, "No guest physical page available, min_gpa: 0x%lx "
                "page_size: 0x%x memslot: %u\n",
                min_gpa, vm->page_size, memslot);
        fputs("---- vm dump ----\n", stderr);
        vm_dump(stderr, vm, 2);
        abort();

> =20
>  #define DEFAULT_GUEST_STACK_VADDR_MIN	0xab6000
>  #define DEFAULT_STACK_PGS		5

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260826230511.9728=
24-1-seanjc@google.com?part=3D2

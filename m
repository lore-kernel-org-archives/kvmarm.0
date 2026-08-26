Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7866136A03F;
	Wed, 26 Aug 2026 23:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787786324; cv=none; b=tsasRK8rA5cAt/+mFL48YRR8CKjw4xDKKAU/uZPJWtJ9L65UGzGdgyOp9N1a+g7iqVQ1DZGX0PQ0ODxBRMlpqeb30QUaFK4hZsmgvzyglC3YNhOuD8qK03M3fUrXvMdJqCefXdN2y+PPVNt/ckig6EuxDVhreAJLkbsqU7TVvLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787786324; c=relaxed/simple;
	bh=zs/jLRrxALImadcdQTRtLm6EvhGO/rwBjPZvTGrQInY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gWUM5RcKYmP3M3tH1uFThaJVUqMl6Mf7/3HcDi/LMbJQHHY7reGA/9p2+sQrKx1HVuNm7sb0eC44yd4doemsobVPuX/U3RdMQ9SkGJyJoY0SHSdxF1zFtxpO6PFw6mUujGXvz90e3BRMffoKQv6iBXpLybkUN+qD+NSwkrr/CWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jhSkH4jE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jhSkH4jE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF381F000E9;
	Wed, 26 Aug 2026 23:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787786323;
	bh=NADnjcFglcNCCMc+InwbqcJxWYJRmAoiV/ZhFwiyFn0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jhSkH4jErBr4XvhWtFtnYECQxvs3P32rffqFkyfRB+cafqvLYrVqUsMAI6Ae7z+yU
	 xEv9k9Vvx43PJ5hoN2ojjmrxRbRuqB3S0VLCQQX2UrlDseklRmlW1t91dVMQokW+MR
	 aU9EAQMH8Cb0ZbrBqL/tJGR2KxELgJJQTpuS+bGc/3XjH6ENY2U5aCmFkzOIRNIFcp
	 z/75guJk0X0OkDKGDeYxUjP/9RfzeFE8/dXr0pIN6rv4CWdfq45kfFkqqsnXbK3O4V
	 PxWCXABLySs/GKCZ4aD8Obg46g0u8WadyRDmG9V59HW8pM91mWyGwJFwq1YeK6oZRo
	 +9jz8la5hoUaw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 20/20] KVM: selftests: Add arch hook to force page
 tables to be naturally aligned
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260826230511.972824-21-seanjc@google.com>
References: <20260826230511.972824-1-seanjc@google.com>
 <20260826230511.972824-21-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 23:18:42 +0000
Message-Id: <20260826231842.ADF381F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The physical page allocator uses the ALIGN() macro with nr_pages=
 as the alignment, which miscalculates physical addresses if nr_pages is no=
t a power of two.
--

commit e164bd04c5d3f08c13c51c2171eea3a520c79ec4
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Add arch hook to force page tables to be naturally aligned

This commit adds an arch hook to communicate to the core physical page
allocator that page table allocations need to be naturally aligned. The hook
will be used for upcoming PowerPC support, which has MMU tables that are
larger than the guest base page size.

> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
[ ... ]
> @@ -2110,6 +2116,7 @@ gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_=
t nr_pages,
>  		break;
>  	case MEM_REGION_PT:
>  		min_gpa =3D KVM_GUEST_PAGE_TABLE_MIN_PADDR;
> +		naturally_aligned =3D kvm_arch_needs_naturally_aligned_page_tables();
>  		break;
>  	case MEM_REGION_TEST_EXTRA:
>  		min_gpa =3D region->region.guest_phys_addr;
> @@ -2120,7 +2127,7 @@ gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_=
t nr_pages,
>  	}
> =20
>  	return ____vm_phy_pages_alloc(vm, nr_pages, min_gpa, vm->memslots[type],
> -				      protected, false);
> +				      protected, naturally_aligned);
>  }

[Severity: Medium]
When naturally_aligned is set to true here, is it guaranteed that nr_pages=
=20
will always be a power of two?

Looking at ____vm_phy_pages_alloc(), the nr_pages parameter is used directly
as the alignment value:

____vm_phy_pages_alloc() {
        size_t alignment =3D naturally_aligned ? nr_pages : 1;
        ...
        base =3D ALIGN(base, alignment);
        ...
}

The ALIGN(x, a) macro in the kernel is implemented using bitwise operations
((x + (a - 1)) & ~(a - 1)), which inherently require the alignment
parameter to be a strictly power-of-two value. If a test requests a
non-power-of-two number of pages for page table memory, this causes a
bitwise truncation that results in an incorrectly calculated physical
address.

Because there is no TEST_ASSERT enforcing that nr_pages is a power of two
when naturally_aligned is requested, could this lead to silent memory
overlaps and guest data corruption? Should we enforce that nr_pages is a
power of two, or round the alignment up?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260826230511.9728=
24-1-seanjc@google.com?part=3D20

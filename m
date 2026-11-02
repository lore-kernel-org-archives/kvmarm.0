Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793633856;
	b=BCXFdmhOW/oXAqPwuB9C2UmXX2AXobm0b6QGu3oYWVulJiSU0aX+R/wnrCGMmjJc544e
	 LlunOPI83WgovVjsmUMuef7cUayl9mTEsKXA62UNJvqHl7iwuL9vAI2pRif1QlWKNeYQ7
	 kEYiPB4AZq4+uecCEDyxkbCJ/qBcjQOowVorcOfF7EvyWR6F9L88pXwqBZWOoGta42pGe
	 WQyn/PZGLlK8f343zinh9N2YyrWm/cxzKIlS/CXFD+oG5vR/RbVO+b1+v8EakX6XN8yEg
	 n2p1ZaO4rODH49t7/0PhnWQz+8o1LDUjSb2UteCzjAt2ahYX65krDdN5dUse2qXMd/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793633856;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vq8Jkl0nekFnNp5l7od8z4hsttA48/j4aZwu0QX4oxg=;
	b=nOTHighSxaJpf+8rFeb+9fPe2lCjMACcilZG9E5Gdfo+cKY6K5xvFxqAnONwDcifYfzf
	 kWNjI/+GXAdo/w3ooXU0uc6PHz5H/qyYS9oPK1hKghM61NCal6YYmoUV77xozgJkwuTG2
	 KDG31USrvndsLVnvVAw7bgcDq9wTvI0jctD9YV0+tx/0mSqur8qM7YePFWab0Fb091esJ
	 TOsLyhcYLGWrawfMPrPNFA8qSCRJXWu2M9mSxcxadxcmFns9EcccNOajBbLQ8p8HMlhe1
	 qY+ueoIZ6eNJrKlPKMUFQHFiBlFP4MfPlvaB+CNZdVhOJ6D0KXG0LADiP8uq+JyVmVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kbA++yJ4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F94160EDEC3;
	Mon,  2 Nov 2026 15:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kbA++yJ4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBF11F01579;
	Mon,  2 Nov 2026 15:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633855;
	bh=vq8Jkl0nekFnNp5l7od8z4hsttA48/j4aZwu0QX4oxg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kbA++yJ4en6wC6cO939k7VBCvx3vR4V8W9fX8HezXW3dTuT9dpozPxMoEP3kutu2c
	 rTOIydgMS+zOvffJTXHNxhtAwCI6YZ6JFd0ghMyGjnPLgC03MMYFR/PFcUyM3KZhOC
	 n7YonUgrM8el+fnoQKLT2xHi76foH/sdqByPtH7dGNO40q8HHEoCHUA8kCMmfSSNpk
	 CulLQ6lYNtgmuhJdTRyoP537/yKdd9UxGt8xnctwIg9G2ox4JXfoVw/7aaP5opR/3j
	 adhnwDgn9cTcHsqc9YDCRI93Xgm/CIXYQISRfIxxrefqcK3qXkh3iUbmLF77bThxLa
	 cFRUOsgfbj6eg==
Message-ID: <sashiko-outbox-193686@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 08/11] KVM: arm64: CCA: Add Realm RTT mapping and
 invalidation helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261102141304.126883-9-steven.price@arm.com>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-9-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 15:37:34 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] KVM: arm64: uninitialized next_addr in realm_unmap_private_range()
- [High] KVM: arm64: broken address alignment and recursion in realm_fold_r=
tt_level()
- [Medium] KVM: arm64: page accounting after free_page() in free_rtt()
--

commit cc0b24728b73f60b1dd39eb4cc60fe5eb12322c6
Author: Steven Price <steven.price@arm.com>

KVM: arm64: CCA: Add Realm RTT mapping and invalidation helpers

This commit adds Realm Management Interface (RMI) Realm Translation Table
(RTT) creation, folding, and unmap helpers needed for CCA Realm stage-2
memory operations.

> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index f190143b33ba5..1066f767f85d9 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -34,6 +34,83 @@ static int get_start_level(struct realm *realm)

[ ... ]

> +static phys_addr_t alloc_delegated_granule(struct kvm_mmu_memory_cache *=
mc)
> +{
> +	phys_addr_t phys;
> +	void *virt;
> +
> +	if (mc) {
> +		virt =3D kvm_mmu_memory_cache_alloc(mc);
> +	} else {
> +		virt =3D (void *)__get_free_page(GFP_ATOMIC | __GFP_ZERO |
> +					       __GFP_ACCOUNT);
> +	}
> +
> +	if (!virt)
> +		return PHYS_ADDR_MAX;
> +
> +	phys =3D virt_to_phys(virt);
> +	if (rmi_delegate_page(phys)) {
> +		free_page((unsigned long)virt);
> +		return PHYS_ADDR_MAX;
> +	}
> +
> +	return phys;
> +}
> +
> +static phys_addr_t alloc_rtt(struct kvm_mmu_memory_cache *mc)
> +{
> +	phys_addr_t phys =3D alloc_delegated_granule(mc);
> +
> +	if (phys !=3D PHYS_ADDR_MAX)
> +		kvm_account_pgtable_pages(phys_to_virt(phys), 1);
> +
> +	return phys;
> +}
> +
>  static void free_rtt(phys_addr_t phys)
>  {
>  	if (rmi_free_delegated_page(phys))
> @@ -42,6 +119,32 @@ static void free_rtt(phys_addr_t phys)
>  	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
>  }

[Severity: Medium]
Does free_rtt() leak the NR_SECONDARY_PAGETABLE counter in the memory cgroup
lruvec (or touch a reallocated page) by calling kvm_account_pgtable_pages()
after rmi_free_delegated_page()?

In alloc_rtt(), RTT pages are allocated via alloc_delegated_granule() with
__GFP_ACCOUNT and accounted with kvm_account_pgtable_pages(..., 1). However,
when free_rtt() frees an RTT, rmi_free_delegated_page() already calls
free_page() before returning:

drivers/firmware/arm_rmm/rmi.c:rmi_free_delegated_page() {
	if (WARN_ON_ONCE(rmi_undelegate_page(phys))) {
		/* Undelegate failed: leak the page */
		return -EBUSY;
	}

	free_page((unsigned long)phys_to_virt(phys));

	return 0;
}

Because free_page() uncharges the page and clears page->memcg_data (and
returns the page to the allocator where another CPU can immediately
reallocate it), the subsequent kvm_account_pgtable_pages(phys_to_virt(phys),
-1) in free_rtt() operates on a freed page whose memcg association has been
cleared.

[ ... ]

> @@ -161,6 +301,64 @@ static int realm_tear_down_rtt_range(struct realm *r=
ealm,
>  					 start, end);
>  }
> =20
> +/*
> + * Returns 0 on successful fold, a negative value on error, a positive v=
alue if
> + * we were not able to fold all tables at this level.
> + */
> +static int realm_fold_rtt_level(struct realm *realm, int level,
> +				unsigned long start, unsigned long end)
> +{
> +	int not_folded =3D 0;
> +	ssize_t map_size;
> +	unsigned long addr, next_addr;
> +
> +	if (WARN_ON(level > KVM_PGTABLE_LAST_LEVEL))
> +		return -EINVAL;
> +
> +	map_size =3D rmi_rtt_level_mapsize(level - 1);
> +
> +	for (addr =3D start; addr < end; addr =3D next_addr) {
> +		phys_addr_t rtt_granule;
> +		long ret;
> +		unsigned long align_addr =3D ALIGN(addr, map_size);
> +
> +		next_addr =3D ALIGN(addr + 1, map_size);
> +
> +		ret =3D realm_rtt_fold(realm, align_addr, level, &rtt_granule);
> +		if (ret < 0)
> +			return ret;
> +
> +		switch (RMI_RESULT_STATUS(ret)) {
> +		case RMI_SUCCESS:\
> +			free_rtt(rtt_granule);
> +			break;
> +		case RMI_ERROR_RTT:
> +			if (level =3D=3D KVM_PGTABLE_LAST_LEVEL ||
> +			    RMI_RESULT_DATA_LEVEL(ret) < level) {
> +				not_folded++;
> +				break;
> +			}
> +			/* Recurse a level deeper */
> +			ret =3D realm_fold_rtt_level(realm,
> +						   level + 1,
> +						   addr,
> +						   next_addr);
> +			if (ret < 0) {
> +				return ret;
> +			} else if (ret =3D=3D 0) {
> +				/* Try again at this level */
> +				next_addr =3D addr;
> +			}
> +			break;
> +		default:
> +			WARN_ON(1);
> +			return -ENXIO;
> +		}
> +	}
> +
> +	return not_folded;
> +}

[Severity: High]
In realm_fold_rtt_level(), align_addr is computed using ALIGN(addr, map_siz=
e)
before calling realm_rtt_fold(realm, align_addr, level, &rtt_granule).

When addr is not aligned to map_size, ALIGN(addr, map_size) rounds addr up
to the next RTT boundary (equal to next_addr), defeating the ALIGN_DOWN()
inside realm_rtt_fold(). As a result, realm_rtt_fold() folds the next RTT
instead of the RTT covering addr, and if addr lies in the final map_size
block below BIT(realm->ia_bits), align_addr rounds up to BIT(realm->ia_bits=
),
which is out of bounds for rmi_rtt_fold() and triggers the default WARN_ON(=
1)
path.

Additionally, in the RMI_ERROR_RTT case:
1. The recursive call passes next_addr instead of min(next_addr, end),
   scanning up to a full parent map_size beyond end while holding
   kvm->mmu_lock for write.
2. When the recursive call returns a positive value (some child tables were
   not folded), not_folded is not incremented at the current level. If this
   level returns 0 to its caller, the caller sees ret =3D=3D 0, sets
   next_addr =3D addr to retry, and can loop indefinitely.
3. Conversely, when recursing to level + 1 across [addr, next_addr), any
   entry at level that is already a leaf entry (such as UNASSIGNED) has no
   table at level + 1, so rmi_rtt_fold() returns RMI_ERROR_RTT with
   RMI_RESULT_DATA_LEVEL(ret) < level + 1 and increments not_folded,
   preventing the parent table at level from being retried and folded even =
if
   all of its child RTTs were folded. And if ret =3D=3D 0 is returned when =
the
   table at level still cannot be folded (because entries in [addr, next_ad=
dr)
   are non-homogeneous or align_addr targeted the next block), setting
   next_addr =3D addr will retry and recurse on the same range in an infini=
te
   loop.

Should realm_fold_rtt_level() pass addr directly to realm_rtt_fold() (which
already aligns down to map_size), clamp the recursive end to
min(next_addr, end), and avoid retrying in a loop when the parent table
itself cannot be folded?

> @@ -196,6 +394,154 @@ int kvm_realm_teardown_stage2(struct kvm *kvm)

[ ... ]

> +static void realm_unmap_private_range(struct kvm *kvm,
> +				      unsigned long start,
> +				      unsigned long end,
> +				      bool may_block)
> +{
> +	struct realm *realm =3D &kvm->arch.realm;
> +	unsigned long rd =3D virt_to_phys(realm->rd);
> +	unsigned long next_addr, addr;
> +	long ret;
> +
> +	for (addr =3D start; addr < end; addr =3D next_addr) {
> +		unsigned long out_range;
> +		unsigned long flags =3D RMI_ADDR_TYPE_SINGLE;
> +		/* TODO: Optimise using RMI_ADDR_TYPE_LIST */
> +
> +retry:
> +		ret =3D rmi_rtt_data_unmap(rd, addr, end, flags, 0,
> +					 &next_addr, &out_range, NULL);
> +		if (WARN_ON(ret < 0))
> +			return;
> +
> +		if (RMI_RESULT_STATUS(ret) =3D=3D RMI_ERROR_RTT) {
> +			phys_addr_t rtt;
> +
> +			if (next_addr > addr)
> +				continue; /* UNASSIGNED */
> +
> +			rtt =3D alloc_rtt(NULL);
> +			if (WARN_ON(rtt =3D=3D PHYS_ADDR_MAX))
> +				return;
> +			ret =3D realm_rtt_create(realm, addr,
> +					       RMI_RESULT_DATA_LEVEL(ret) + 1, rtt);
> +			if (WARN_ON(ret)) {
> +				free_rtt(rtt);
> +				return;
> +			}
> +			goto retry;
> +		} else if (WARN_ON(ret)) {
> +			continue;
> +		}

[Severity: High]
What happens in realm_unmap_private_range() when rmi_rtt_data_unmap() retur=
ns
RMI_ERROR_RTT or another non-zero status?

Looking at rmi_rtt_data_unmap() in include/linux/arm-rmi-cmds.h:

	ret =3D rmi_sro_execute(&regs);

	if (ret !=3D RMI_SUCCESS)
		return ret;

	if (out_top)
		*out_top =3D regs.a1;

*out_top (&next_addr) is only written when ret =3D=3D RMI_SUCCESS.

When rmi_rtt_data_unmap() returns RMI_ERROR_RTT on the first iteration
(addr =3D=3D start), next_addr is uninitialized on the stack when evaluated=
 by:

	if (next_addr > addr)
		continue; /* UNASSIGNED */

If the uninitialized stack value happens to be greater than start, the loop
advances addr to that garbage address and skips unmapping the range.

If next_addr <=3D addr on the first iteration (or on any subsequent iterati=
on
where addr =3D=3D next_addr from the loop header), next_addr > addr is fals=
e even
when the entry is UNASSIGNED. The code then allocates RTTs and calls
realm_rtt_create(realm, addr, RMI_RESULT_DATA_LEVEL(ret) + 1, rtt) in a ret=
ry
loop until RMI_RESULT_DATA_LEVEL(ret) reaches KVM_PGTABLE_LAST_LEVEL (3),
where it attempts to create an RTT at level 4, hits WARN_ON(ret), and retur=
ns
early without unmapping the remaining range.

Similarly, in the else if (WARN_ON(ret)) continue; branch, next_addr was not
updated by rmi_rtt_data_unmap(), so continuing either jumps to uninitialized
stack memory on the first iteration or repeats the same addr in an infinite
loop while holding kvm->mmu_lock for write.

Should this handle RMI_ERROR_RTT in the same way as
realm_unmap_shared_range(), using find_map_level(realm, addr, end) and
advancing next_addr by rmi_rtt_level_mapsize(err_level) when err_level >=3D
level?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102141304.1268=
83-1-steven.price@arm.com?part=3D8

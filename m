Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794425670;
	b=CUYDI8P+tt0y37jrfnJ9vEFUD8RL7gmhJTlMhEujqiH6t3xUbfqnaESTxc9vBLmtp+kF
	 zqgLcjH/pymZWRWxw36y6Tid7ll1GiN2EaKKFWvqdgi7MthUHJzfEmc1ctxnU7yLHQmA1
	 UPdYPdDiyg/iRX9q3zN2W0C/o0MfmFSXkFC7WoJYOaeUWF8/l2fzShyRAVwAn/GoukMGj
	 8X1TJf9qBVSLMYPZOcCH6kHxlWGjZMFauknVyjo+DP9yHy7qb6ZfOzPtbGSxC2/caqYyY
	 RUXWzl5hBhpo6lCEg+QdVJZQLXsimCZNWmNMDLoayYv8qEkGe8h/eW3cZag0C3u3jAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794425670;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=K9m23hK/EnozQmXKlDxT3RA/MHdtsoUlcNLoP6vEL3M=;
	b=XrSw6WMc+3Mbc476EmcrVbqWPCnl9zXPmbJwowO/wClTpo4cyB7+GkNMJqX+0nwha1J1
	 mdw/zRqgocefKAgIGAQW1ncvEz+FvqPugj5itn126t8t0edDZ9oxtqdQkqGeAmVWgq8lk
	 sIidxmo950b2wiKaHzlit1ftoFkaKQCgw1EoUiblKYHwr0TbwSqkbITZQg5oN9sadv0LD
	 7hFuVo1mc4GjA8cXtBpWA4E19+NY9fkni1maFBvEhgP23dWR6ylAwrwskK80Y9U77qdlB
	 tTNZJ3UQc6WADXxFtYFKIq4mh84KfYTzOREHhXp0GbtOFfMtlm04+jucTxOZkFLJp8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V9lhPerH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A43606A32E;
	Wed, 11 Nov 2026 19:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V9lhPerH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9EB1F00A05;
	Wed, 11 Nov 2026 19:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794425669;
	bh=K9m23hK/EnozQmXKlDxT3RA/MHdtsoUlcNLoP6vEL3M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V9lhPerHavbiFnrLz/DM7yHYa8zMi7YgkLJA6b2Adylq/oPy8oN/e4lbt2A6dnMd4
	 I04VFYIn6jlUWKdB4tzP0AutoXwVnNiwA+FPLktlRfuE4kEN30jkwfZfkh7ctkTciZ
	 ubPYRHMMb71Ie4PlVX72LTnrWXZzoN14zlBHA7904Pz9CAzTWeDSnK/hpqANUWHzQb
	 L/XnTgPIpwb0zRYkON23mNwD01+DrLAvKj1fMBrUe8SRKHgVoTaiKfC1E/WKxeEqIS
	 eegLMCgVQW4LyCqTixiiXIQfIqWDsqshhowxUZO+l0JNIDeQu4TZxfB8wNN/n+Axso
	 aIv1rwT8jyMFA==
Message-ID: <sashiko-outbox-209568@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 11/12] KVM: arm64: CCA: Support runtime faulting of
 memory
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261111145758.217946-12-steven.price@arm.com>
References: <20261111145758.217946-1-steven.price@arm.com>
 <20261111145758.217946-12-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 19:34:28 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 6 potential
issues to consider:
- [Medium] KVM: arm64: KVM_CAP_PRE_FAULT_MEMORY advertised for Realm VMs
- [Medium] KVM: arm64: cca: user-triggerable WARN_ON and retry bug in
  realm_map_protected()
- [Medium] KVM: arm64: cca: bound block level in addr_range_desc() by
  start level
- [Low] KVM: arm64: unhandled exec fault on shared Realm IPA in
  gmem_abort() and user_mem_abort()
- [Low] KVM: arm64: dead code and missing memory fault exit in
  kvm_vm_mem_abort()
- [Low] KVM: arm64: unreachable dead code in kvm_fault_is_gmem_abort()
--

commit 7a04ef54472b7db03df4200b280f4db2cc49ed58
Author: Steven Price <steven.price@arm.com>

KVM: arm64: CCA: Support runtime faulting of memory

This commit adds stage-2 runtime fault handling for Realm VMs, mapping
private guest_memfd pages into the protected IPA range via the RMM and
mapping shared guest_memfd or normal memslot pages into the unprotected
IPA range.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index e550360fc94d0..b6c61d7890c89 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c

[ ... ]

> @@ -1846,6 +1882,16 @@ static int gmem_abort(const struct kvm_s2_fault_de=
sc *s2fd,
>  		goto out_unlock;
>  	}
> =20
> +	switch (kvm->arch.vm_flavor) {
> +	case VM_REALM:
> +		prot &=3D ~KVM_PGTABLE_PROT_X;
> +		ret =3D realm_map_ipa(kvm, s2fd->fault_ipa, s2vi.pfn,
> +				    PAGE_SIZE, prot, memcache);
> +		goto out_unlock;
> +	default:
> +		break;
> +	}

[Severity: Low]
This question rests on an architecture detail that this review could not
confirm from the kernel source: can a Realm guest instruction fetch from an
unprotected (shared) IPA cause the RMM to exit to the host with a stage-2
instruction abort (ESR_ELx_EC_IABT_LOW) that reaches
kvm_handle_guest_abort()?

If the answer is yes, unprotected Realm mappings cannot grant execute
permission because RMI_RTT_UNPROT_MAP only encodes RMI_S2AP_DIRECT_READ and
RMI_S2AP_DIRECT_WRITE, yet neither gmem_abort() nor user_mem_abort() checks
kvm_s2_fault_is_exec(s2fd) on a shared IPA to return -ENOEXEC (so
kvm_handle_guest_abort() can inject an instruction abort via
kvm_inject_sea_iabt()).  Instead, realm_map_unprotected() installs a
non-executable mapping and returns 0, and on subsequent instruction
permission faults at that IPA, unmaps and remaps the page with the same
non-executable permissions in an endless fault loop.

[ ... ]

> @@ -2340,13 +2391,40 @@ static int user_mem_abort(const struct kvm_s2_fau=
lt_desc *s2fd,
>  	return kvm_s2_fault_map(s2fd, &s2vi, prot, memcache, result);
>  }
> =20
> +static bool private_ipa_fault(struct kvm *kvm, phys_addr_t fault_ipa)
> +{
> +	return kvm_vm_is_realm(kvm) &&
> +		kvm_realm_is_private_address(&kvm->arch.realm, fault_ipa);
> +}
> +
> +/* Decide if an abort should be handled by the gmem */
> +static bool kvm_fault_is_gmem_abort(struct kvm *kvm,
> +				    const struct kvm_s2_fault_desc *s2fd)
> +{
> +	if (!kvm_slot_has_gmem(s2fd->memslot))
> +		return false;
> +	if (kvm_memslot_is_gmem_only(s2fd->memslot))
> +		return true;
> +	/*
> +	 * For Realms, all private faults must be backed by GMEM.
> +	 * TODO: Handle Trusted device private memory mappings.
> +	 */
> +	if (private_ipa_fault(kvm, s2fd->fault_ipa))
> +		return true;
> +	return false;
> +}

[Severity: Low]
Is the private_ipa_fault() check in kvm_fault_is_gmem_abort() reachable?

On arm64, include/linux/kvm_host.h defines gmem_in_place_conversion as true
because kvm_arch_has_private_mem is defined without
CONFIG_KVM_PRIVATE_MEMATTR_VM, so kvm_gmem_prepare_memory_region() sets
KVM_MEMSLOT_GMEM_ONLY on every guest_memfd-backed memslot:

virt/kvm/guest_memfd.c:kvm_gmem_prepare_memory_region() {
    ...
	if (gmem_in_place_conversion || kvm_gmem_supports_mmap(inode))
		slot->flags |=3D KVM_MEMSLOT_GMEM_ONLY;
    ...
}

Once kvm_slot_has_gmem(s2fd->memslot) is true,
kvm_memslot_is_gmem_only(s2fd->memslot) always returns true, making the rest
of kvm_fault_is_gmem_abort() unreachable and the helper equivalent to
kvm_slot_has_gmem(s2fd->memslot).

> +
>  static int kvm_vm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>  {
>  	VM_WARN_ON_ONCE(kvm_s2_fault_is_perm(s2fd) &&
>  			!esr_abt_is_write_fault(s2fd->esr) &&
>  			!kvm_s2_fault_is_exec(s2fd));
> =20
> -	if (kvm_slot_has_gmem(s2fd->memslot))
> +	if (private_ipa_fault(s2fd->vcpu->kvm, s2fd->fault_ipa) &&
> +	    !kvm_slot_has_gmem(s2fd->memslot))
> +		return -EINVAL;
> +
> +	if (kvm_fault_is_gmem_abort(s2fd->vcpu->kvm, s2fd))
>  		return gmem_abort(s2fd, NULL);
>  	else
>  		return user_mem_abort(s2fd, NULL);

[Severity: Low]
When a Realm guest faults on the private IPA alias of a non-guest_memfd
memslot, should kvm_vm_mem_abort() call kvm_prepare_memory_fault_exit() and
return -EFAULT instead of returning -EINVAL?

Returning -EINVAL leaves vcpu->run->exit_reason unpopulated and causes
KVM_RUN to fail with EINVAL rather than reporting KVM_EXIT_MEMORY_FAULT
(with KVM_MEMORY_EXIT_FLAG_PRIVATE) to userspace, and as noted above,
kvm_fault_is_gmem_abort() is also redundant with kvm_slot_has_gmem() on
arm64.

[ ... ]

> @@ -3156,7 +3235,7 @@ pre_fault_bytes_consumed(gpa_t gpa, unsigned long g=
ranule_size,
> =20
>  int kvm_arch_pre_fault_allowed(struct kvm_vcpu *vcpu)
>  {
> -	if (is_protected_kvm_enabled())
> +	if (is_protected_kvm_enabled() || kvm_vm_is_realm(vcpu->kvm))
>  		return -EOPNOTSUPP;
>  	if (!kvm_vcpu_initialized(vcpu))
>  		return -ENOEXEC;

[Severity: Medium]
Should kvm_vm_ioctl_check_extension() also gate KVM_CAP_PRE_FAULT_MEMORY on
!kvm_vm_is_realm(kvm)?

kvm_arch_pre_fault_allowed() rejects KVM_PRE_FAULT_MEMORY on Realm VMs with
-EOPNOTSUPP, but kvm_vm_ioctl_check_extension() in arch/arm64/kvm/arm.c
still advertises KVM_CAP_PRE_FAULT_MEMORY as supported when queried on a
Realm VM file descriptor.

> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 5aa34d68de595..682ed7005d579 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -551,6 +551,241 @@ void kvm_realm_unmap_range_filter(struct kvm *kvm, =
unsigned long start,
>  		realm_unmap_private_range(kvm, start, end, may_block);
>  }
> =20
> +static unsigned long addr_range_desc(unsigned long ipa, unsigned long ph=
ys,
> +				     unsigned long size, unsigned long state)
> +{
> +	unsigned long count =3D 1;
> +	unsigned long out;
> +	int rmi_size;
> +
> +	for (rmi_size =3D KVM_PGTABLE_LAST_LEVEL; rmi_size >=3D 0; rmi_size--) {
> +		unsigned long entry_size =3D rmi_addr_block_size_to_bytes(rmi_size);
> +
> +		if (size >=3D entry_size && IS_ALIGNED(ipa, entry_size) &&
> +		    IS_ALIGNED(phys, entry_size))
> +			break;
> +	}

[Severity: Medium]
Can addr_range_desc() select a block level above the Realm's RTT start leve=
l?

When a Realm VM is created with a 32..34-bit IPA range on 4KB pages,
get_start_level(realm) is 2 (concatenated level-2 root RTTs).  If the guest
faults on a 1GB-aligned shared memslot backed by a 1GB hugetlbfs VMA,
kvm_s2_resolve_vma_size() sets vma_pagesize to PUD_SIZE (1GB) and
addr_range_desc() picks rmi_size =3D 2 (RTT level 1).  In
realm_map_unprotected(), req_level is then 1, which is above the root RTT
level 2, causing rmi_rtt_unprot_map() to fail until retries are exhausted
and terminating the fault with -ENXIO.

> +
> +	if (rmi_size =3D=3D 0) {
> +		/*
> +		 * Stop at the next block boundary so that a later iteration can
> +		 * use a larger mapping when both addresses are aligned.
> +		 */
> +		count =3D MIN(size >> PAGE_SHIFT, PTRS_PER_PTE - 1);
> +		count =3D min(count, (PMD_SIZE - (ipa & (PMD_SIZE - 1))) >> PAGE_SHIFT=
);
> +		count =3D min(count, (PMD_SIZE - (phys & (PMD_SIZE - 1))) >> PAGE_SHIF=
T);
> +	}
> +
> +	WARN_ON(phys & ~PAGE_MASK);
> +
> +	out =3D FIELD_PREP(RMI_ADDR_RANGE_BLOCK_SIZE_MASK, rmi_size) |
> +	      FIELD_PREP(RMI_ADDR_RANGE_COUNT_MASK, count) |
> +	      FIELD_PREP(RMI_ADDR_RANGE_STATE_MASK, state);
> +	out |=3D phys & PAGE_MASK;
> +
> +	return out;
> +}
> +
> +static int realm_map_protected(struct kvm *kvm,
> +			       unsigned long ipa,
> +			       kvm_pfn_t pfn,
> +			       unsigned long map_size,
> +			       struct kvm_mmu_memory_cache *memcache)
> +{

[ ... ]

> +	while (ipa < ipa_top) {
> +		unsigned long flags =3D RMI_ADDR_TYPE_SINGLE;
> +		unsigned long range_desc =3D addr_range_desc(ipa, phys, ipa_top - ipa,
> +							   RMI_OP_MEM_DELEGATED);
> +		unsigned long out_top;
> +
> +		ret =3D rmi_rtt_data_map(rd, ipa, ipa_top, flags, range_desc,
> +				       &out_top);
> +		if (ret < 0)
> +			goto err_undelegate;
> +
> +		if (RMI_RESULT_STATUS(ret) =3D=3D RMI_ERROR_RTT) {
> +			/* Create missing RTTs and retry */
> +			int level =3D RMI_RESULT_DATA_LEVEL(ret);
> +
> +			if (WARN_ON(level >=3D KVM_PGTABLE_LAST_LEVEL))
> +				goto err_undelegate;
> +			ret =3D realm_create_rtt_levels(realm, ipa, level,
> +						      level + 1,
> +						      memcache);
> +			if (ret)
> +				goto err_undelegate;
> +
> +			continue;
> +		}
> +
> +		if (WARN_ON(ret))
> +			goto err_undelegate;

[Severity: Medium]
Can userspace or a Realm guest trigger WARN_ON(level >=3D
KVM_PGTABLE_LAST_LEVEL) and WARN_ON(ret) in realm_map_protected()?

If userspace punches a hole in guest_memfd on an already-mapped protected
page, realm_unmap_private_range() unmaps the page via rmi_rtt_data_unmap()
(leaving the level-3 RTT entry in the DESTROYED state) and undelegates the
folio while the guest_memfd range remains private.  When a vCPU faults on
that GPA again, gmem_abort() allocates a fresh undelegated folio and
realm_map_protected() delegates it, but rmi_rtt_data_map() fails with
RMI_ERROR_RTT at level 3 (or if the guest has not initialized RIPAS to RAM),
hitting WARN_ON(level >=3D KVM_PGTABLE_LAST_LEVEL).  Similarly, any non-RTT
status such as RMI_BLOCKED hits WARN_ON(ret).

In addition, unlike realm_map_unprotected(), realm_map_protected() passes
ipa_top instead of call_top to rmi_rtt_data_map(), checks
KVM_PGTABLE_LAST_LEVEL and passes level + 1 instead of req_level to
realm_create_rtt_levels(), and does not bound retries.  If map_size >
PAGE_SIZE is used, addr_range_desc() can describe a sub-range smaller than
ipa_top - ipa (failing with RMI_ERROR_INPUT) or a block mapping where a
child RTT at level + 1 already exists, causing realm_create_rtt_levels() to
return 0 on RMI_ERROR_RTT and spin forever under write_lock(&kvm->mmu_lock).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111145758.2179=
46-1-steven.price@arm.com?part=3D11

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794850307;
	b=FT7JtU8W8luwe4kZuJBYQBDnbZwC4EvFBVkL7TTD9Jgt8nHc7kZfJ/WSS++DPXS5A1+w
	 NCGh8caV4AO2OU4byrjksWKbv0MRP3ARF5HOlUtkjvvK6helb/AikSHFWN+dM8e/vWkSz
	 eppAjakGCHLfhKpaUeiKr9ipeGLsf4Okt0ZzJuWBptWn4f76m9BYP80574xnY0dY2Hto6
	 9N56S1WNMy6ulLp9qADrTOKd+ViTR0FRZMO5zUol3HNJwiUA8W9SqBw/dblubCNQIJkT8
	 xoYoN9i7m94H5yJ3Ar6m4n07x0HRA9YPhfVxo/oqghKMZDw+7wXFk80RQ5EXDQAbg0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794850307;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Hm64xLHNibckADV1peCrsacIKe9H5aSr0f1d+XzjCzQ=;
	b=buuuRWP2mzut8SedBkRlTEUZj1Hij1ZFY4Jp8TRDaXyWZYjmroAlJCPCPi6poJ7XOqN5
	 0ZkUhBO91GWZDKzIZUXbdL8bmp+Ty1YL6PMaI2rftTOKP6eSU7mX+Gx7axPbWZyJPwhh2
	 eEAIuce3C1pUOIo8iRXh38hU1p3wc+RgvAa7hKMvbb9yIvZCNQDb/T+pbAvk7m3E2nXUk
	 LOg59vwQ1ccXktwRV89I+V0c6JWHUp/cYrG8V4u4yEKgwUiZjvaAlGn8AFPeB4ku+iJvm
	 GGpN3G1C6khq1aIpHxpR4hP46y80YoLj6RGLGFlsOyJtHV9ANp4TC0fGpf3U6cw/HhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bbLi9RNJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4153F606A32F;
	Mon, 16 Nov 2026 17:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bbLi9RNJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907671F000C4;
	Mon, 16 Nov 2026 17:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794850306;
	bh=Hm64xLHNibckADV1peCrsacIKe9H5aSr0f1d+XzjCzQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bbLi9RNJUuydZ+xDpiu4l2NnQCKDcMmTX0ejvQaNiL+rIW23Oavq82+yqexf+CMTv
	 7ZVyTdVbSJram3xv7Fkqf/gwXbxfbmW0aZ10NaiMcFCUiRRkXhucJObawr+5hgYAbe
	 EOfe5G2wJJF+ZmFMKjqD8LhdDolw4tU2Mvhxqf5fjnZXS25yupIQ67vg/WCLkrMyWd
	 lxTy/Sebh1oPHsw9/WpyCN8npvBz/6pLqg+POyhnV7rTQIpjKWh9lGVpqwY7bztbGj
	 1Bulu+b83UnmMgKGqzyGQ4dkMtOnE/zAw2gphc8tbWyQQWS+zUQsfeLP1DqAVAAqMR
	 jBAgvAU5SeIXg==
Message-ID: <sashiko-outbox-217436@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 09/11] KVM: arm64: CCA: Support runtime faulting of
 memory
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261116164358.142785-10-steven.price@arm.com>
References: <20261116164358.142785-1-steven.price@arm.com>
 <20261116164358.142785-10-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 17:31:46 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] KVM: arm64: KVM_CAP_PRE_FAULT_MEMORY advertised for Realm VMs
- [Medium] KVM: arm64: missing unmap on partial failure in
  realm_map_unprotected()
- [Low] KVM: arm64: unhandled exec fault on shared Realm IPA in
  gmem_abort() and user_mem_abort()
--

commit 5a0919ef6adc946a1afb4f6ad7cf84e5573597f3
Author: Steven Price <steven.price@arm.com>

KVM: arm64: CCA: Support runtime faulting of memory

This commit adds runtime stage-2 fault handling for Realm VMs, delegating
and mapping private guest_memfd pages in the protected IPA region and
mapping shared pages in the unprotected IPA region via the RMM.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 0db3c293fdd52..9b371159be92c 100644
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
> +
[ ... ]
> @@ -2242,12 +2289,15 @@ static int kvm_s2_fault_map(const struct kvm_s2_f=
ault_desc *s2fd,
>  	if (!perm_fault_granule && !s2vi->map_non_cacheable && kvm_has_mte(kvm))
>  		sanitise_mte_tags(kvm, pfn, mapping_size);
> =20
> -	/*
> -	 * Under the premise of getting a FSC_PERM fault, we just need to relax
> -	 * permissions only if mapping_size equals perm_fault_granule. Otherwis=
e,
> -	 * kvm_pgtable_stage2_map() should be called to change block size.
> -	 */
> -	if (mapping_size =3D=3D perm_fault_granule) {
> +	if (kvm_vm_is_realm(kvm)) {
> +		ret =3D realm_map_ipa(kvm, s2fd->fault_ipa, pfn, mapping_size,
> +				    prot, memcache);

[Severity: Low]
This question rests on an architecture detail that could not be confirmed
from the kernel source: can a Realm guest instruction fetch from an
unprotected (shared) IPA exit to the host as a stage-2 instruction abort
that reaches kvm_handle_guest_abort()?

If so, unprotected RTT mappings only encode RMI_S2AP_DIRECT_READ and
RMI_S2AP_DIRECT_WRITE and cannot grant execute permission, but neither
gmem_abort() nor user_mem_abort() rejects kvm_s2_fault_is_exec(s2fd) with
-ENOEXEC to inject an instruction abort.  Instead, realm_map_unprotected()
installs a non-executable mapping, and on subsequent instruction permission
faults at the same IPA where level >=3D req_level, unmaps and remaps the pa=
ge
with the same non-executable permissions and returns 0 in an endless fault
loop.

[ ... ]

> @@ -3155,7 +3217,7 @@ pre_fault_bytes_consumed(gpa_t gpa, unsigned long g=
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
Should kvm_vm_ioctl_check_extension() also report 0 for
KVM_CAP_PRE_FAULT_MEMORY when kvm && kvm_vm_is_realm(kvm)?

Currently kvm_vm_ioctl_check_extension() only gates capabilities on
is_protected_kvm_enabled() and otherwise unconditionally sets r =3D 1 for
KVM_CAP_PRE_FAULT_MEMORY, advertising the capability on a Realm VM file
descriptor even though KVM_PRE_FAULT_MEMORY always fails here with
-EOPNOTSUPP.

> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 838f95c201ada..4cacb9fe000f4 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
[ ... ]
> +static int realm_map_unprotected(struct kvm *kvm,
> +				 unsigned long ipa,
> +				 kvm_pfn_t pfn,
> +				 unsigned long size,
> +				 enum kvm_pgtable_prot prot,
> +				 struct kvm_mmu_memory_cache *memcache)
> +{
[ ... ]
> +	while (ipa < ipa_top) {
> +		unsigned long range_desc =3D addr_range_desc(realm, ipa, phys,
> +							   ipa_top - ipa,
> +							   RMI_OP_MEM_UNDELEGATED);
> +		unsigned long call_top =3D ipa + RMI_ADDR_RANGE_COUNT(range_desc) *
> +			rmi_addr_block_size_to_bytes(RMI_ADDR_RANGE_BLOCK_SIZE(range_desc));
> +		unsigned long out_top;
> +
> +		ret =3D rmi_rtt_unprot_map(rd, ipa, call_top, flags, range_desc,
> +					 &out_top);
> +		if (ret < 0)
> +			return ret;
> +
> +		if (ret) {
> +			/* Create missing RTTs and retry */
> +			int level =3D RMI_RESULT_DATA_LEVEL(ret);
> +			int req_level =3D KVM_PGTABLE_LAST_LEVEL -
> +				RMI_ADDR_RANGE_BLOCK_SIZE(range_desc);
> +
> +			if (RMI_RESULT_STATUS(ret) !=3D RMI_ERROR_RTT ||
> +			    ++retries > KVM_PGTABLE_LAST_LEVEL + 2)
> +				return -ENXIO;
> +
> +			/* Replace an existing mapping to update its permissions. */
> +			if (level >=3D req_level) {
> +				realm_unmap_shared_range(kvm, ipa, ipa_top, false,
> +							 memcache);
> +				continue;
> +			}
> +
> +			ret =3D realm_create_rtt_levels(realm, ipa, level,
> +						      req_level,
> +						      memcache);
> +			if (ret)
> +				return ret;
> +
> +			continue;
> +		}
> +
> +		/* Retry the fault after releasing mmu_lock to service the IRQ. */
> +		if (out_top =3D=3D ipa)
> +			return -EAGAIN;
> +		if (WARN_ON_ONCE(out_top < ipa || out_top > call_top))
> +			return -ENXIO;
> +
> +		phys +=3D out_top - ipa;
> +		ipa =3D out_top;
> +		retries =3D 0;
> +	}

[Severity: Medium]
Can a multi-iteration call to realm_map_unprotected() leave a writable
prefix mapped when a later iteration fails or returns -EAGAIN?

For a Realm with a 32- to 34-bit IPA space on 4KB pages, get_start_level()
is 2, so addr_range_desc() caps rmi_size at 1 (PMD_SIZE).  When a shared
memslot is backed by a 1GB hugetlbfs VMA, kvm_s2_fault_map() passes
mapping_size =3D PUD_SIZE and this loop runs across multiple 2MB iterations.
If an iteration after the first is interrupted (out_top =3D=3D ipa) or hits=
 an
error, realm_map_unprotected() returns non-zero without unmapping the
already-installed prefix (unlike realm_map_protected()).  kvm_s2_fault_map()
then passes !!ret (unused =3D true) to kvm_release_faultin_page() and skips
mark_page_dirty_in_slot(), so if the faulting IPA lies in the mapped prefix,
the guest can write to the page without marking the host folio dirty.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116164358.1427=
85-1-steven.price@arm.com?part=3D9

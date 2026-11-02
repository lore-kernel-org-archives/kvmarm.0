Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793629820;
	b=hnTeC+G489azlSeW7L93Hg99K1jOAVM9UHGXEQlELYPlm8V9fM23e+AMpalAbgXMv+P7
	 FCqnK8TwrjU3OU1SuaF10xRWQmQiBn5a40w0S7/mQLoTwazkWLNgtCBDHnHqoy/gF08/T
	 39Mu+Mb0Ofubvo47wdZcplNMesfhTGZVxz0n9vCwYCE0pPcxlJVfV6TcoVeDoxAkfAjYm
	 FX7ruUN5TR3FB5NLQAHA30Hi571H/WYhNShXX3ie0lyKlg0JDDfXH9sYgvzzuSWRrXf9M
	 6VcG5a/r/huAKaXwyBNgbVnpxdanX+mnBBvFijbQmxfKejMWylvoZ7e2n5eXLFudJIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793629820;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=IAwTGmEn4+E645f2RaNayW8NYkiS2vD6urhgC0twxhQ=;
	b=yVwu3VgKt+zWlUYVFXjklvsAPm/vrNSXHa7b8NPMFR0UIg7rQYQeCOA8iofIF5Jm3U3P
	 P2jFb1DlnAKgiBuXMIuyeYKUuY4DtQ6LiIAZBNZhWU4ARsUSQC8lB5MH3FtRM+jeovEsS
	 ls+yY5MXCQmhVjRe0Sg0uv3kusdulPYZjeUV6zEVnuzYi6qrKMCNaSHdvZjAYTwtuqo/m
	 TsWeTXWXja/F7Y7dhwOGfg0cBRY7XS0y/GNnizClbDD3K2yeNY9eHX8L9vDyHpKFKHl0o
	 FFUuYtcpcVr7Oz1m2plFZmI5wM55TqAtRkKlgG78aFLO+MXZYYjgJka05XDVzHWpBFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M9HHfd4R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB9D60716EF;
	Mon,  2 Nov 2026 14:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M9HHfd4R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53411F00A1F;
	Mon,  2 Nov 2026 14:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629819;
	bh=IAwTGmEn4+E645f2RaNayW8NYkiS2vD6urhgC0twxhQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M9HHfd4RCe3AAOrQbSQCUwDs5WdjsNMqgMbGKMeBNsT/NzetivNK0Vpq6QmdwSgtg
	 IkHOHz20d1+AxWfyuGx38Tu4ib6W5u7r12sqlDbLIGfgWO7nvEwWCmlSBfPtUOgcOO
	 xvkVFsctWhgnVqfvheiPCqcKB18d5cGTwcxdnhmquaYA2fg9l9dd8ns++Q2yF01+oM
	 b6tyzQh3ru4RFBTamqh5Rg1GJiBjwlCQjJMWfZUM+7sS0gVTSKSq915/yNFHBPKuHc
	 410oTO9xzupIAQYD1SN6PRA32j2X//P9Qdr1qBplSeaeh4b6G1oE6ggeeoCpey/PhU
	 2avWmvdVDv31g==
Message-ID: <sashiko-outbox-193575@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 02/11] KVM: arm64: CCA: Introduce Realms
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261102141304.126883-3-steven.price@arm.com>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-3-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 14:30:19 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] KVM: arm64: premature kvm_arch_has_private_mem() breaks gmem check=
s and caps
- [Low] KVM: arm64: duplicate kvm_arm_vcpu_finalize() declarations in kvm_h=
ost.h
--

commit d7e08ee0dbb02a4cf114f13c026edc843145fe6e
Author: Suzuki K Poulose <suzuki.poulose@arm.com>

KVM: arm64: CCA: Introduce Realms

This commit adds foundational infrastructure for Arm CCA Realm VMs,
including the VM_REALM flavor, a static key for RMI availability,
per-VM Realm state tracking in struct kvm_arch, and initial feature and
memslot checks.

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index ccd2dc8f73c3a..7d0222047ca1e 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
[ ... ]
> @@ -1572,30 +1584,43 @@ struct kvm *kvm_arch_alloc_vm(void);
[ ... ]
> +#define kvm_vm_is_realm(kvm)		((kvm)->arch.vm_flavor =3D=3D VM_REALM)
> +#define vcpu_is_rec(vcpu)		kvm_vm_is_realm((vcpu)->kvm)
> =20
>  #define kvm_vm_hyp_is_distrusting(kvm)	((kvm)->arch.vm_flavor >=3D __VM_=
DISTRUSTING_HYP)
> =20
> -#endif	/* __KVM_NVHE_HYPERVISOR__ */
> +#define kvm_arch_has_private_mem(kvm) kvm_vm_is_realm(kvm)

[Severity: High]
Does defining kvm_arch_has_private_mem(kvm) here cause a regression in
guest_memfd memslot validation and capability reporting across arm64?

Because CONFIG_KVM_PRIVATE_MEMATTR_VM is not selected on arm64, defining
kvm_arch_has_private_mem activates the preprocessor branch in
include/linux/kvm_host.h that sets gmem_in_place_conversion to true at
compile time:

include/linux/kvm_host.h:
    #elif defined kvm_arch_has_private_mem
    #define gmem_in_place_conversion true
    #define kvm_is_private_gfn kvm_gmem_is_private_gfn

With gmem_in_place_conversion unconditionally true,
kvm_gmem_prepare_memory_region() in virt/kvm/guest_memfd.c sets
KVM_MEMSLOT_GMEM_ONLY on every guest_memfd memslot even when
GUEST_MEMFD_FLAG_MMAP is not set:

virt/kvm/guest_memfd.c:kvm_gmem_prepare_memory_region() {
    ...
    if (gmem_in_place_conversion || kvm_gmem_supports_mmap(inode))
        slot->flags |=3D KVM_MEMSLOT_GMEM_ONLY;
}

As a result, the check in kvm_arch_prepare_memory_region() in
arch/arm64/kvm/mmu.c that rejects non-mappable guest_memfd memslots:

arch/arm64/kvm/mmu.c:kvm_arch_prepare_memory_region() {
    ...
    if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
        return -EINVAL;
}

is bypassed for non-Realm VMs, allowing userspace to bind a private
guest_memfd created with flags =3D=3D 0 via KVM_SET_USER_MEMORY_REGION2 and
fault those pages into non-Realm stage-2 page tables through gmem_abort().

In addition, when userspace queries
KVM_CHECK_EXTENSION(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES) on the /dev/kvm
fd (where kvm is NULL), kvm_vm_ioctl_check_extension_generic() in
virt/kvm/kvm_main.c calls kvm_supports_private_mem(NULL):

virt/kvm/kvm_main.c:kvm_supports_private_mem() {
    return !kvm || kvm_arch_has_private_mem(kvm);
}

virt/kvm/kvm_main.c:kvm_vm_ioctl_check_extension_generic() {
    ...
    case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
        if (!gmem_in_place_conversion || !kvm_supports_private_mem(kvm))
            return 0;

        return KVM_MEMORY_ATTRIBUTE_PRIVATE;
}

This advertises KVM_MEMORY_ATTRIBUTE_PRIVATE on all arm64 hosts even when
KVM_MODE_RMM is not active and while kvm_gmem_set_attributes() in
virt/kvm/guest_memfd.c rejects KVM_SET_MEMORY_ATTRIBUTES2 with -EINVAL on
every creatable VM.

> +
> +int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
> +bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);

[Severity: Low]
This isn't a bug, but commit df6a70516adec8 already moved the declarations
of kvm_arm_vcpu_finalize() and kvm_arm_vcpu_is_finalized() earlier in
arch/arm64/include/asm/kvm_host.h right below VCPU_PKVM_FINALIZED:

arch/arm64/include/asm/kvm_host.h:
    #define VCPU_PKVM_FINALIZED	__vcpu_single_flag(cflags, BIT(2))

    int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
    bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);

Can these duplicate declarations be dropped?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102141304.1268=
83-1-steven.price@arm.com?part=3D2

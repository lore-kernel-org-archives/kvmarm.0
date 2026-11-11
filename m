Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794423268;
	b=ekYYVzjSj9zSKlZV1DHatD84x75cL4vDE+Y6CHbTRSWK/KHyJUF2GB+/lYvYoXIALDEA
	 Cvbr9PVNYjnmRePX7o0e7VxflW9Ibz3O0xqh/bbhyoloADxR25YnsF2qDvNd03nSln6h3
	 D4Lxd9HFsbfrAyy4lr1EMknLXODQoKG9PEMLJ9FrE4duejpV24XlgZzGDqedvFlYmqR3E
	 LQms6sjGE/DBeiB9IvQ1H2rzjL6PW30IE8Rw4Ydo/RrQ7VuHr4VO1aOhKj1zsc0G1N8ja
	 S21EK1m0hBA4qd94rdSNCbcviVE6X0i9qvplDqiPc8ck57tuN6yXj/k/wOYrqqmLmEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794423268;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=y/lxbkPjuA9mMVZrgSYLRKEVN/vFVr8kx1/RT/U4RdQ=;
	b=GwAmcva7J4icTuLrCpK32pqm4ISKCE7kbWA+da5UZDZUCHapBstkg36nbDOpnfmgbfS0
	 LIzn5GUi+eUUHIS58cPqOslKbLglQkyrDk/FhW6Z2tuVkynwtATreqips/lSYMQ8Uo6tA
	 K+bKECUQJSKtahgl3tIlbWLzhJNQ2Dv4tRalL+wPk+z6JB6/Sj5KgzAPiE8WQCNjNKffp
	 bcOS0x4F6HcxdluGcEu4lrIWMQkUikaeV0YloXCINKvEvrWd8yunksMtPNYdPh3T2iWJH
	 QhP8rtPwePFiq7JQ6GVlm4rBOidn5ij/laxqJ858d5Yj8AAfcWK5wNOyZ7c7A2qahLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i6Ct7c+j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70849606A324;
	Wed, 11 Nov 2026 18:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i6Ct7c+j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B0A1F00A07;
	Wed, 11 Nov 2026 18:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794423268;
	bh=y/lxbkPjuA9mMVZrgSYLRKEVN/vFVr8kx1/RT/U4RdQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i6Ct7c+j9eRyQGcHypz4uzQze0Fg8ZeBCWiXLShHUO4WF1+XKPcNMFWdHeszAvLrc
	 XfpzBWVefq+jUbwrWgfZMsIuLMPvkPNwewHwMfNuSMlad3ROjpE1EZeZzUAlEcJHpE
	 2DKB9g8Se7eVWNiZCeqjjymMpw0mkSzE1YBuI+Csmbdr4RDo/b24RPmqK49o5XIi/4
	 5FbiigFsK03OtxtkaPMMC8SK6pN3/1pglXWyA9CQm+FSpsgchVpx9lbY3xKC7zoQYm
	 F4Kk8viQ6xVat8G/LNNTwwOxQu/tY2vxPYL1RPTzg2kxU9t66qNjDxn0aqUXnLrhRN
	 oezIVslgQqg0A==
Message-ID: <sashiko-outbox-209506@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 10/12] KVM: arm64: CCA: Prevent memslot modifications
 after Realm creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261111145758.217946-11-steven.price@arm.com>
References: <20261111145758.217946-1-steven.price@arm.com>
 <20261111145758.217946-11-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 18:54:27 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] KVM: arm64: non-Realm VMs bypass guest_memfd mmap and private
  memory checks
- [Low] KVM: arm64: stale memslot invalidation claim and missing macro
  in commit log
--

commit 72b617a00596c14c4599f4a8b9b980bcb6c02644
Author: Suzuki K Poulose <suzuki.poulose@arm.com>

> KVM: arm64: CCA: Prevent memslot modifications after Realm creation
>
> Once the Realm is created, prevent any changes to guest_memfd backed
> memslots, as the private memory is provided by slots backed by gmem.
> This will also be validated when we handle a fault for Realm Stage2 (in
> a later commit).
>
> Require Realm memslots to lie in the lower half of the IPA space, as the
> upper, shared half aliases the lower, protected half.
>
> A rejected deletion can already have invalidated the memslot before
> the prepare hook rejects it. Keep private mappings intact in this
> case.
>
> Additionally, similar to pKVM, we do not support dirty logging or
> read-only memslots.
>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>

[Severity: Low]
Is the paragraph about a rejected deletion invalidating the memslot
before the prepare hook rejects it left over from an earlier version?
This patch rejects guest_memfd memslot changes in
kvm_arch_validate_memory_region(), which commit "KVM: Allow architectures
to reject memslot changes before invalidation" runs before
kvm_invalidate_memslot().

Also, the commit message does not mention defining
kvm_arch_has_private_mem(kvm) for Realm VMs.

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index d672d87ffe620..a82b18a3e4e5d 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1612,6 +1612,8 @@ struct kvm *kvm_arch_alloc_vm(void);
> =20
>  #define kvm_vm_hyp_is_distrusting(kvm)	((kvm)->arch.vm_flavor >=3D __VM_=
DISTRUSTING_HYP)
> =20
> +#define kvm_arch_has_private_mem(kvm) kvm_vm_is_realm(kvm)

[Severity: Medium]
Does defining kvm_arch_has_private_mem(kvm) as kvm_vm_is_realm(kvm) cause
non-Realm VMs to bypass guest_memfd mmap and private memory checks?

Because kvm_arch_has_private_mem is defined, include/linux/kvm_host.h
sets gmem_in_place_conversion to true for all arm64 VMs, so
kvm_gmem_prepare_memory_region() sets KVM_MEMSLOT_GMEM_ONLY on every
guest_memfd memslot even without GUEST_MEMFD_FLAG_MMAP.

However, commit "KVM: arm64: guest_memfd: Check mmap support when
preparing memslot" gated the !kvm_gmem_slot_supports_mmap(new) check in
kvm_arch_prepare_memory_region() on kvm_arch_has_private_mem(kvm), and
commit "KVM: arm64: CCA: Support runtime faulting of memory" likewise
gates the kvm_gmem_is_private_gfn() check in gmem_abort() on
kvm_arch_has_private_mem(kvm). As a result, a non-Realm VM can bind a
guest_memfd created without GUEST_MEMFD_FLAG_MMAP or
GUEST_MEMFD_FLAG_INIT_SHARED and fault pages marked
KVM_MEMORY_ATTRIBUTE_PRIVATE into its shared stage-2 page tables.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111145758.2179=
46-1-steven.price@arm.com?part=3D10

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794414602;
	b=eHAqO920Iol4MeJGlG42LdH4grZWg1Cik+cJPKwW5Fp5dReH5Bh+0PXCbT+Re3Qi1COn
	 3Sm1nvxic+KV4+sQ57RjziiKSpNh49tkYgPWAn4TppIW2OUyU/bmaB8lupKJszUD8Q/h2
	 xqpVcjBAQPXmmLlKGZAZnjX4bfXGWnKuAlLfa185688kC0gUzqdsiqIvTz2GK+85g5rWR
	 FYDS9JEjsxUtwBXQSesC/zGcQ+97ZVBlLLfbROzX2PU0Wsok/bLyZpz5fLHCOyoOD3F3i
	 SwnHT2nHg+uHKIvMuGCk1yV2dW0jQPCDiQBqiCEDeDlScjuoEQeXBkDsyqgSp/IYeSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794414602;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=OTgmmvmFoFwlCxssmfqD6UcdBcRA0ZDfykReKIVhCIY=;
	b=I62O5J/N1dSihVwTksDixx5Rh8kpnslKc2c/r24eRwjdqQ4wBOuYZ/zO9eiwg1c8Eknz
	 IvB+uzEtdli7NBXzX3Oh4JHabt86IekzjSPYZNaPIHiASEsx5wpDJ+/Ba1lxmzsEg5wF8
	 xXKTPmPySAwp83A1n7FWpznpIGwP5rJJvBR4Q2xmJZ/4SNZfNI2DV1TqIA9uh7V8Y/dVz
	 5oUPvwItFwS8fxe5jXa92W8cIAseYdTkRbi/XmSr3216PPHO+/r3xfxr/G4ZkYFofUZm2
	 3vUuzFuBzRkG1XIZYWiyx0S+C3l4LXE3SQCIaflJ8UL7iBpHB3WFdrVLPnojnsYyFfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NHVCSdOu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D84606A334;
	Wed, 11 Nov 2026 16:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NHVCSdOu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226741F00A05;
	Wed, 11 Nov 2026 16:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794414602;
	bh=OTgmmvmFoFwlCxssmfqD6UcdBcRA0ZDfykReKIVhCIY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NHVCSdOu4lEREh1wFivmxZVUbjU/BKRrn2jlJgK1c9meBq66cEph+GYI0YfrIsflR
	 uDlQc00b0kGZpLsp3oAcKobK6lSEfBHh3Gf3FY0glUCbs3i2Xkofcppbu7iaaHD3K2
	 vLTszxZQbDjaXfOwqx7NT4exBy8GxV+pz2fS/vSaSwz4Mq2IPHK8uujWmba73XxCTz
	 sYOeYjyKj2+s5Gt+1PcNjidBtgR63uGAp1APZIFpKX3Of4iiI5x/mg5ejlHZ2kJ5wC
	 vpzgeCJZrQ082+i2zGIjjECQN9TftPR8e7y1bkjk19G7ySyd/F5IMzrUcpdPV8OzAK
	 jr5ZFHExSWYXw==
Message-ID: <sashiko-outbox-209288@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/12] KVM: arm64: guest_memfd: Check mmap support
 when preparing memslot
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261111145758.217946-3-steven.price@arm.com>
References: <20261111145758.217946-1-steven.price@arm.com>
 <20261111145758.217946-3-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 16:30:01 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] KVM: arm64: mmap check bypassed in
  kvm_arch_prepare_memory_region()
--

commit 30a76d4c8b8b8454f9d59879df7f0b5de9a2cdbb
Author: Steven Price <steven.price@arm.com>

KVM: arm64: guest_memfd: Check mmap support when preparing memslot

This commit adds kvm_gmem_slot_supports_mmap() and updates
kvm_arch_prepare_memory_region() to check whether the guest_memfd backing
file supports mmap rather than checking kvm_memslot_is_gmem_only().

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1db10d8d6db73..a146f6cde3d02 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2839,10 +2839,11 @@ int kvm_arch_prepare_memory_region(struct kvm *kv=
m,
>  		return -EFAULT;
> =20
>  	/*
> -	 * Only support guest_memfd backed memslots with mappable memory, since
> -	 * there aren't any CoCo VMs that support only private memory on arm64.
> +	 * Protected VMs currently require guest_memfd backed memslots with
> +	 * mappable memory to support shared mappings.
>  	 */
> -	if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
> +	if (kvm_arch_has_private_mem(kvm) && kvm_slot_has_gmem(new) &&
> +	    !kvm_gmem_slot_supports_mmap(new))
>  		return -EINVAL;

[Severity: Medium]
Does gating this check on kvm_arch_has_private_mem(kvm) cause a
regression that allows binding non-mappable guest_memfds to non-Realm VMs
on arm64?

At this commit kvm_arch_has_private_mem(kvm) resolves to the stub in
include/linux/kvm_host.h that unconditionally returns false, and even
after commit "KVM: arm64: CCA: Prevent memslot modifications after Realm
creation" defines it as kvm_vm_is_realm(kvm), it remains false for all
non-Realm VMs.

Userspace can then create a guest_memfd without GUEST_MEMFD_FLAG_MMAP and
bind it to a normal VM via KVM_SET_USER_MEMORY_REGION2.  Stage-2 faults
in kvm_vm_mem_abort() -> gmem_abort() will fault those unmappable pages
into the guest while HVA-based KVM accesses via slot->userspace_addr
(such as kvm_read_guest() and kvm_write_guest()) access unrelated VMA
memory.  Dropping the kvm_arch_has_private_mem(kvm) condition here would
preserve the requirement across all arm64 VMs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111145758.2179=
46-1-steven.price@arm.com?part=3D2

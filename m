Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E478741DEE7
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 20:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786133831; cv=none; b=NF5OrKcWph/orthHGG5TrLfne7WLNnVnBSq0/bs03C7Wg+1mrunVptbaytrSx/9nDjGxPzTcy7LjcCxDhUMTlwyMv1AOtYemDk0mcnZCe1KcdnPkToOZofRy3wKX99VUwOFcsRifCFydcxkOonBXiTyl/mg67LIlolHsH0uw18E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786133831; c=relaxed/simple;
	bh=SkXci6yx15Z19Y/VSNHRmQhlX1JCHsH6R914OhahPaM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JukIryYndXLlX7QwkKjXmGcZ7RQM2qqFH54rm/YU3/9B71doygPMEQ7UVYTvBAM+0sbW2WxBiPliIRGcShqJUMsBi6wTzeLmtWKI3rDWljiX7NnlfuaS3CuOPPF8w3Ab/MYxdEHfRxfnxSz7frCdqMjAMOf80LpirU90OYgQvgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ObV3xypy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ObV3xypy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548941F000E9;
	Fri,  7 Aug 2026 20:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786133829;
	bh=MJjGlGt+Q2AhmWo9NHIuRnINLCCvpWy5KncFFr2tnus=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ObV3xypyNm4W1OpqU6g4IZAmmgO5qJDSrdfgp2cNs+oB1RImyPpDRrdOa4RdwnMyC
	 u4t+bzaWUfXdJQnjo4GRuz+kj5JECNl+/12rg+8pnqezOj8Rw/Z93aie8fWdIY1WcE
	 /eKtut0/gjBjETHE3go4/0oa2mGvJVljx4djQpOOraH7P8YSI8rMl7nd3CUf1psk+1
	 Q5QdqxdDz1aX6fPt0woW0VhyQbdMe9urA7fCZu/F8Gb5zB1XePqgwkVGnqSCMWGX6g
	 7kfmoqnrao96/2IYbJG+cRzGVHxQt96Wg9cbqxKVNrtBlJf9Hl6EBkRzMNEbk/T3lw
	 XBWghXD0VPRog==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] KVM: arm64: nv: Keep the shadow S2 MMUs at fixed
 addresses
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karl Mehltretter" <kmehltretter@gmail.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260807195940.12642-1-kmehltretter@gmail.com>
References: <20260807195940.12642-1-kmehltretter@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 20:17:08 +0000
Message-Id: <20260807201709.548941F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] The `kvm->arch.nested_mmus` array is leaked if VM creation fails=
 after `kvm_arch_init_vm()` completes successfully.

Pre-existing issues:
- [High] If `kvm->arch.nested_mmus_size` is 0 or `nested_mmus` is freed, a =
nested stage-2 fault causes a host kernel panic in `get_s2_mmu_nested()` du=
e to a race condition with `kvm_arch_flush_shadow_all()`.
--

--- Patch [1]: [PATCH v4] KVM: arm64: nv: Keep the shadow S2 MMUs at fixed =
addresses ---
commit 46aa9c715387bbae64560eea52655690ecd90bb6
Author: Karl Mehltretter <kmehltretter@gmail.com>
Subject: KVM: arm64: nv: Keep the shadow S2 MMUs at fixed addresses

This commit turns nested_mmus into a pointer table allocated once during VM
creation. The MMUs are allocated separately as VCPUs are initialized to keep
their addresses stable, fixing a slab-use-after-free issue.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index fb54f6dad995c..3c9b5c5b02d1f 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -43,11 +43,18 @@ struct vncr_tlb {
>   */
>  #define S2_MMU_PER_VCPU		2
> =20
> -void kvm_init_nested(struct kvm *kvm)
> +int kvm_init_nested(struct kvm *kvm)
>  {
> -	kvm->arch.nested_mmus =3D NULL;
> +	kvm->arch.nested_mmus =3D kvcalloc(KVM_MAX_VCPUS * S2_MMU_PER_VCPU,
> +					 sizeof(*kvm->arch.nested_mmus),
> +					 GFP_KERNEL_ACCOUNT);
> +	if (!kvm->arch.nested_mmus)
> +		return -ENOMEM;
> +

[Severity: Medium]
Does this allocation leak if VM creation fails later in the process?

During kvm_create_vm(), kvm_arch_init_vm() calls kvm_init_nested() which
allocates kvm->arch.nested_mmus. If a subsequent initialization step in
kvm_create_vm() fails (e.g., hardware_enable_all() or
kvm_init_mmu_notifier()), the error path bypasses mmu_notifier_unregister()
and directly calls kvm_arch_destroy_vm().

Since kvm_arch_destroy_vm() on ARM64 does not free kvm->arch.nested_mmus,
could the array be permanently leaked on those error paths?

[ ... ]

> @@ -1272,10 +1279,10 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  	int i;
> =20
>  	for (i =3D 0; i < kvm->arch.nested_mmus_size; i++) {
> -		struct kvm_s2_mmu *mmu =3D &kvm->arch.nested_mmus[i];
> +		struct kvm_s2_mmu *mmu =3D kvm->arch.nested_mmus[i];
> =20
>  		if (!WARN_ON(atomic_read(&mmu->refcnt)))
> -			kvm_free_stage2_pgd(mmu);
> +			free_nested_s2_mmu(mmu);
>  	}
>  	kvfree(kvm->arch.nested_mmus);
>  	kvm->arch.nested_mmus =3D NULL;

[Severity: High]
This is a pre-existing issue, but does this function have a race
condition with VCPU threads?

When a KVM process is killed, exit_mm() invokes mmu_notifier_release(), whi=
ch
calls kvm_arch_flush_shadow_all(). This function frees kvm->arch.nested_mmus
and sets nested_mmus_size =3D 0 without acquiring mmu_lock.

Since file descriptors are not closed until later, VCPU threads might still=
 be
executing. If a VCPU thread calls vcpu_load() -> kvm_vcpu_load_hw_mmu() ->
get_s2_mmu_nested(), it acquires mmu_lock but not the SRCU lock. It can read
the concurrently modified nested_mmus_size as 0, skip the lookup loop, and
execute BUG_ON(atomic_read(&s2_mmu->refcnt)) on an uninitialized or NULL
pointer.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807195940.1264=
2-1-kmehltretter@gmail.com?part=3D1

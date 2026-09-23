Received: from mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9F6568FD3
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 19:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790192050; cv=none; b=GFHbVkrr5yLnSSoeMrqUV7Dxidgu5PT0WBhCy1PTWPefbmkRt8buKjmqS8Iu/Z+QQ15dbQ2cj94rDVwRosUYHbNeGarLg67mmTWoquOXWFt9jZYm2o6o4gmpIQBPc28d05d5S3gz3ax76QCxbLroDhe43493G5Vx746oJhMO6X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790192050; c=relaxed/simple;
	bh=+aq11w9shYPq4zRWGEb/sLRXl3paxePhW5w8CIQV7Bk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dOSL9FC57DEGgZICW5evXMWLct2hj2ZSwsg2zBxpub6FQOeiU7AXr754ElpQb8yhikJc8RUNcawVPPFTJlHT1dZ+ngBKbs7D2tUvZLs3XLj18HKZu0HIa0W+ebYNBJpLOpuvzrayoV5JlOsF31RtOEO5rADwdcS/Xg/ZfFHZ1Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ITB1c5DB; arc=none smtp.client-ip=95.215.58.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ITB1c5DB"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=+aq11w9shYPq4zRWGEb/sLRXl3paxePhW5w8CIQV7Bk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790192043; v=1; x=1790796843;
 b=ITB1c5DBxX4Y+6ZMcZu+uNB5pBBV2hhDytiij2i1LeNqbefUY8bU6ZtqR4vUScSyJkZm+wn0
 A5IG0/MLfhOC1MpkQ4AoPygp7VMpqAVRaJS0jo5r3qyHUhHdKxnXXLDYO81lJ0awI+VfhGaL9Yv
 nHNyy6b/e5nYRqSDHaEowh3c=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 08081c11a388f6fa;
	Wed, 23 Sep 2026 19:34:03 +0000
X-Mizu-Trace-ID: 08081c11a388f6fa
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b83c1421ecso112e87.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 12:33:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBykM4sFqpbpXqOgQqx/uxgDE695qdUhk8EFsOguqBb8RcULbvJUPDkknEoNV14rSxFbxsS9g7M=@lists.linux.dev
X-Gm-Message-State: AFuF++kd6P3BBcb2ESGk6CJBltAOfXPWzpIcysB6U29Zvj5GMlH3QXFY
	Ci4AYrM1or6NQaRKIW9Yvth1DQwchtJyLplkFz5pPbF8Dn9Lj7fY1GgAm6L1dSy4DLw9N+d3tK9
	Vh/uT58EqlzSMPeD6Z0SavWwp4P7X3T9fUNHUIUON
X-Received: by 2002:a05:6512:a91:b0:5b8:d04b:a1be with SMTP id
 2adb3069b0e04-5b8dd9f0c4dmr53371e87.2.1790192038462; Wed, 23 Sep 2026
 12:33:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260922130821.1666713-1-vdonnefort@google.com> <20260922130821.1666713-3-vdonnefort@google.com>
In-Reply-To: <20260922130821.1666713-3-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 23 Sep 2026 20:33:22 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyAwtJX-HxUwHMuFZ8nz8kiA2WC5rx5emAoNenw9NtMuQ@mail.gmail.com>
X-Gm-Features: AclHuK_0VJOxyCQDV004MitEiWHW22At2KrjZ62zt5jnhslznvDqQJ_apl4Vfkw
Message-ID: <CA+EHjTyAwtJX-HxUwHMuFZ8nz8kiA2WC5rx5emAoNenw9NtMuQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/6] KVM: arm64: Pass kvm_s2_fault_desc to fault_supports_stage2_huge_mapping()
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 22 Sept 2026 at 14:08, 'Vincent Donnefort' via kernel-team
<kernel-team@android.com> wrote:
>
> Pass the fault descriptor to fault_supports_stage2_huge_mapping() instead
> of passing memslot and hva separately so it can access other s2fd
> members such as vcpu.
>
> No functional change intended.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/mmu.c | 39 +++++++++++++++++++--------------------
>  1 file changed, 19 insertions(+), 20 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9ba86450fe4a..9dfaf4f277b5 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1353,12 +1353,21 @@ static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
>         send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
>  }
>
> -static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
> -                                              unsigned long hva,
> +struct kvm_s2_fault_desc {
> +       struct kvm_vcpu         *vcpu;
> +       phys_addr_t             fault_ipa;
> +       struct kvm_s2_trans     *nested;
> +       struct kvm_memory_slot  *memslot;
> +       unsigned long           hva;
> +};
> +
> +static bool fault_supports_stage2_huge_mapping(const struct kvm_s2_fault_desc *s2fd,
>                                                unsigned long map_size)
>  {
> -       gpa_t gpa_start;
> +       struct kvm_memory_slot *memslot = s2fd->memslot;
> +       unsigned long hva = s2fd->hva;
>         hva_t uaddr_start, uaddr_end;
> +       gpa_t gpa_start;
>         size_t size;
>
>         /* The memslot and the VMA are guaranteed to be aligned to PAGE_SIZE */
> @@ -1427,9 +1436,9 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
>   * Returns the size of the mapping.
>   */
>  static long
> -transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
> -                           unsigned long hva, kvm_pfn_t *pfnp, gfn_t *gfnp)
> +transparent_hugepage_adjust(const struct kvm_s2_fault_desc *s2fd, kvm_pfn_t *pfnp, gfn_t *gfnp)
>  {
> +       struct kvm *kvm = s2fd->vcpu->kvm;
>         kvm_pfn_t pfn = *pfnp;
>         gfn_t gfn = *gfnp;
>
> @@ -1438,8 +1447,8 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
>          * sure that the HVA and IPA are sufficiently aligned and that the
>          * block map is contained within the memslot.
>          */
> -       if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
> -               int sz = get_user_mapping_size(kvm, hva);
> +       if (fault_supports_stage2_huge_mapping(s2fd, PMD_SIZE)) {
> +               int sz = get_user_mapping_size(kvm, s2fd->hva);
>
>                 if (sz < 0)
>                         return sz;
> @@ -1597,14 +1606,6 @@ static enum kvm_pgtable_prot adjust_nested_exec_perms(struct kvm *kvm,
>         return prot;
>  }
>
> -struct kvm_s2_fault_desc {
> -       struct kvm_vcpu         *vcpu;
> -       phys_addr_t             fault_ipa;
> -       struct kvm_s2_trans     *nested;
> -       struct kvm_memory_slot  *memslot;
> -       unsigned long           hva;
> -};
> -
>  static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>  {
>         bool write_fault, exec_fault;
> @@ -1791,7 +1792,7 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
>         switch (vma_shift) {
>  #ifndef __PAGETABLE_PMD_FOLDED
>         case PUD_SHIFT:
> -               if (fault_supports_stage2_huge_mapping(s2fd->memslot, s2fd->hva, PUD_SIZE))
> +               if (fault_supports_stage2_huge_mapping(s2fd, PUD_SIZE))
>                         break;
>                 fallthrough;
>  #endif
> @@ -1799,7 +1800,7 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
>                 vma_shift = PMD_SHIFT;
>                 fallthrough;
>         case PMD_SHIFT:
> -               if (fault_supports_stage2_huge_mapping(s2fd->memslot, s2fd->hva, PMD_SIZE))
> +               if (fault_supports_stage2_huge_mapping(s2fd, PMD_SIZE))
>                         break;
>                 fallthrough;
>         case CONT_PTE_SHIFT:
> @@ -2049,9 +2050,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>                 if (perm_fault_granule > PAGE_SIZE) {
>                         mapping_size = perm_fault_granule;
>                 } else {
> -                       mapping_size = transparent_hugepage_adjust(kvm, s2fd->memslot,
> -                                                                  s2fd->hva, &pfn,
> -                                                                  &gfn);
> +                       mapping_size = transparent_hugepage_adjust(s2fd, &pfn, &gfn);
>                         if (mapping_size < 0) {
>                                 ret = mapping_size;
>                                 goto out_unlock;
> --
> 2.55.0.1082.g2b9226bbc0-goog
>
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>

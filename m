Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C3E3DCD9B
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 14:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773757540; cv=pass; b=AcrgU16Shmf9HQ48qnOwBlwhuH8y5tc6J7IQyypqqTqIL+OvSJN++YtFPfrOyPtUUWzrET+ad08xeprZLNWHfIB5KY8zQ6L10HRfICfLN1VY9hdLtMs8+FsH3WHLji7RDCLFwL85TYjNFEKQWXvWUeUhHa61CT5MkKlgfALpLeA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773757540; c=relaxed/simple;
	bh=FDsIpA6Ig3GRK8KP/TF5czMTHIJULTVV4QVAArv8eEU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lFyQ9j5ePZTsNUN8j7yGchjoMz+wANs126zCPfXzN7pZopBNNdDg8yeCe/uUuxZoAPvj7g1DedM3AZAgQD11rTTSsYY3DKDtOit7hPwU9cm9NbXW34WhOUV5kFp3Co8WrJx0WgLb59IYdVj9U8GSRs1e6qX/TKDCy6VNpE9gW9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R+YgxTTk; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R+YgxTTk"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5091ed02c54so453991cf.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 07:25:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773757538; cv=none;
        d=google.com; s=arc-20240605;
        b=DX14756l46UspqFaOB+byjXUpJcO2y310Kf/ut0qPXKTSUj5O3Cvro3DJ5LdrtuEmn
         rZt1EjUuB+gqDRPofCwMSCwgfQVjRCe/LPDzdlQw3mQYoGCQ9wsyJu7mtsLCzmdxBJ/A
         4DBk11W1A+M8nTgu+T8usso1niv/BDTnmQka8TYQWGRTf819rUJ3W3Ye1RMwiggEejsL
         YhmqiuW3cPN5+XKulE+uCBdUSER4VB+bnCnB7+lDbki4RCkT5k/VT/R6xwOM8ds/bDg5
         dJBsHFDq+7/UUIk5VRRUmutFJr2l7LipPzTbDTgxvoIDrw6B8TVqa1hLKzOaSX1HKcVQ
         4//A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=RDgXPQFxNwyLbF7UxodwiAipSXFBQ9HY2PjQ5y6FI3s=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=YJikvhLYnzuRMcrXDTFq+q+SaTT04h+knZsjMHdqRpkqMJ0CPUXxd+oVNdgtgODh67
         DPFQfoBY2YDgAYDhyE+PAS7jmy7Ty4Nvsy+fpJfAfrEgV6+xargINtTDrP/DEETpaTNB
         Ama/ZZ92HPYdcga5n25EEkiGwzPpEiNHJbB9Iqvxw72iAu8osJcmsLcC4lveBiMjpBUi
         oXZiHyV1oicQoBfiB0tw3tSiVre9lfPHkUXTXlPdffrJ08ZOfj7/n7lrezTP9LLGRtiX
         o5dV0jbsfA/SPLJjPcIGP8lDfj2z2udMP2CvftjIOBAqSHlFKlfeTgn+z8Q8W5v0iZxJ
         oIIA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773757538; x=1774362338; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RDgXPQFxNwyLbF7UxodwiAipSXFBQ9HY2PjQ5y6FI3s=;
        b=R+YgxTTk0V17qdCCkHxPubE80/YWXoWfTS8b7Rh4f1AcwoOLvV2qjjg15r8rEc+mJh
         LuM475PLQZ4DFPGv79+QmxeIXP+UYL1wP1bisoDLxOVxpy/7V4eZ3wN+6DnLD5h62OG6
         xQhfX6KEqhdAEmsqz9DjzJ8L5ELO/5/o/KfwFybQGHLWaRKSnDo4Sun/wsbltU6jvLu3
         aNg4/1JwRH8ljcs5VDF/quXBZHGlTFMCS1L+U367THOTgfrihkS5P8j118ot/IqK84IV
         9LDnrVnX7oKgMVMRRinX+Knz0y6MDlnKrmEEX+58/IdXyndZgaHSQ2jwfQ66fRmZjm6Q
         +Cag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773757538; x=1774362338;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RDgXPQFxNwyLbF7UxodwiAipSXFBQ9HY2PjQ5y6FI3s=;
        b=RMMCBL97dzTshh+4PnLoR5Hc8Nv5l55j0e4wtk1d6TE5oLZieC16/gqTo3Hi/8iOhE
         oyOcEGewzSIgE/iRyc818EwFlD5cb/+4ErzGwSQrzM1jWEQhL5tlPJUXGmHtPdQ0tmcv
         1VYrx9c2Dc+exQXG02qQGPSgbB49Cgs0kFNVV8dUX55IFu8s7Bi6YCyi712HPIOwF88v
         NyA6v8d1buTgULLBk7txK9bkGcYDl5pcqY4rtLHXXHaAIhqFNDupVxte9OlLfW0Rtjmx
         UAbTkBrNRx/bhgMH4aStl43jOvxoo70Zcm8kgtJkfzTmrUNjQkkqPyP7V4GWzQa/Geln
         z3HQ==
X-Gm-Message-State: AOJu0YyO0LcXzBQs/ZE4FkJvEj1ObvLQNof5d6wqMeOucnAyJB7DV8VG
	XASYpWNWFxIFL8rq15rURUfuO2+iD0upQ1JhR4H1x4IaeTKYJOQdJahDhnkoxTGmRsao09pdEhr
	0St6hdzb/S99IFES42KdCoYRKD7HzYzkmrmlC4kWk
X-Gm-Gg: ATEYQzxiGaSik7XVe0Waa6Tt6Jeyy85n1tCFM7gNW6mAxByXo9QD9yRWiagbvXsIsoF
	wKaO7KTxgW6b7x7b3DUTLFKFpZsqVrIz5Hi1DAVhRFK1H17qE7LcIsYdRcNT0rHKMerCAROcd7U
	KIqoScBrxJGaN8Um0cTLenT+L4OUFkyIKjRTkfu32HSoj88kD/6a4Eo7+PZfzpocIxQqV7zjMjl
	1YV91dWeEDkU1rVcwC2SEkj6CNejCNP9CXV6xnmW/NHsCIPrDVJBagMFZE+mWpUt50qZ4UTME3U
	H9gC9smxILOqZD003l5V+WjNaqIm2hkz7A1Fcsz2lfIgeXE=
X-Received: by 2002:ac8:5e12:0:b0:4f3:54eb:f26e with SMTP id
 d75a77b69052e-5099ac78738mr13659191cf.1.1773757537772; Tue, 17 Mar 2026
 07:25:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org> <20260316175451.1866175-13-maz@kernel.org>
In-Reply-To: <20260316175451.1866175-13-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 14:24:59 +0000
X-Gm-Features: AaiRm53KaKAYPLiiykSZkaQGEnrJnLw55L58DrfKhGoM2E5oJXLDC8vITPX0HY0
Message-ID: <CA+EHjTw2XkbM83YTE1fRaPMdLZt_nxZcYkfdNag2F16Z=1kXfg@mail.gmail.com>
Subject: Re: [PATCH 12/17] KVM: arm64: Move kvm_s2_fault.{pfn,page} to kvm_s2_vma_info
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Mar 2026 at 17:55, Marc Zyngier <maz@kernel.org> wrote:
>
> Continue restricting the visibility/mutability of some attributes
> by moving kvm_s2_fault.{pfn,page} to kvm_s2_vma_info.
>
> This is a pretty mechanical change.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/mmu.c | 30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 3cfb8f2a6d186..ccdc9398e4ce2 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1714,6 +1714,8 @@ struct kvm_s2_fault_vma_info {
>         unsigned long   mmu_seq;
>         long            vma_pagesize;
>         vm_flags_t      vm_flags;
> +       struct page     *page;
> +       kvm_pfn_t       pfn;
>         gfn_t           gfn;
>         bool            mte_allowed;
>         bool            is_vma_cacheable;
> @@ -1722,10 +1724,8 @@ struct kvm_s2_fault_vma_info {
>
>  struct kvm_s2_fault {
>         bool s2_force_noncacheable;
> -       kvm_pfn_t pfn;
>         bool force_pte;
>         enum kvm_pgtable_prot prot;
> -       struct page *page;
>  };
>
>  static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
> @@ -1799,11 +1799,11 @@ static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
>         if (ret)
>                 return ret;
>
> -       fault->pfn = __kvm_faultin_pfn(s2fd->memslot, get_canonical_gfn(s2fd, s2vi),
> -                                      kvm_is_write_fault(s2fd->vcpu) ? FOLL_WRITE : 0,
> -                                      &s2vi->map_writable, &fault->page);
> -       if (unlikely(is_error_noslot_pfn(fault->pfn))) {
> -               if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
> +       s2vi->pfn = __kvm_faultin_pfn(s2fd->memslot, get_canonical_gfn(s2fd, s2vi),
> +                                     kvm_is_write_fault(s2fd->vcpu) ? FOLL_WRITE : 0,
> +                                     &s2vi->map_writable, &s2vi->page);
> +       if (unlikely(is_error_noslot_pfn(s2vi->pfn))) {
> +               if (s2vi->pfn == KVM_PFN_ERR_HWPOISON) {
>                         kvm_send_hwpoison_signal(s2fd->hva, __ffs(s2vi->vma_pagesize));
>                         return 0;
>                 }
> @@ -1824,7 +1824,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>          * Check if this is non-struct page memory PFN, and cannot support
>          * CMOs. It could potentially be unsafe to access as cacheable.
>          */
> -       if (s2vi->vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(fault->pfn)) {
> +       if (s2vi->vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(s2vi->pfn)) {
>                 if (s2vi->is_vma_cacheable) {
>                         /*
>                          * Whilst the VMA owner expects cacheable mapping to this
> @@ -1912,6 +1912,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>         struct kvm_pgtable *pgt;
>         long perm_fault_granule;
>         long mapping_size;
> +       kvm_pfn_t pfn;
>         gfn_t gfn;
>         int ret;
>
> @@ -1924,10 +1925,11 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>         perm_fault_granule = (kvm_s2_fault_is_perm(s2fd) ?
>                               kvm_vcpu_trap_get_perm_fault_granule(s2fd->vcpu) : 0);
>         mapping_size = s2vi->vma_pagesize;
> +       pfn = s2vi->pfn;
>         gfn = s2vi->gfn;
>
>         /*
> -        * If we are not forced to use fault->page mapping, check if we are
> +        * If we are not forced to use page mapping, check if we are
>          * backed by a THP and thus use block mapping if possible.
>          */
>         if (mapping_size == PAGE_SIZE &&
> @@ -1936,7 +1938,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>                         mapping_size = perm_fault_granule;
>                 } else {
>                         mapping_size = transparent_hugepage_adjust(kvm, s2fd->memslot,
> -                                                                  s2fd->hva, &fault->pfn,
> +                                                                  s2fd->hva, &pfn,
>                                                                    &gfn);
>                         if (mapping_size < 0) {
>                                 ret = mapping_size;
> @@ -1946,7 +1948,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>         }
>
>         if (!perm_fault_granule && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
> -               sanitise_mte_tags(kvm, fault->pfn, mapping_size);
> +               sanitise_mte_tags(kvm, pfn, mapping_size);
>
>         /*
>          * Under the premise of getting a FSC_PERM fault, we just need to relax
> @@ -1963,12 +1965,12 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>                                                                  fault->prot, flags);
>         } else {
>                 ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(gfn), mapping_size,
> -                                                        __pfn_to_phys(fault->pfn), fault->prot,
> +                                                        __pfn_to_phys(pfn), fault->prot,
>                                                          memcache, flags);
>         }
>
>  out_unlock:
> -       kvm_release_faultin_page(kvm, fault->page, !!ret, writable);
> +       kvm_release_faultin_page(kvm, s2vi->page, !!ret, writable);
>         kvm_fault_unlock(kvm);
>
>         /* Mark the page dirty only if the fault is handled successfully */
> @@ -2017,7 +2019,7 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>
>         ret = kvm_s2_fault_compute_prot(s2fd, &fault, &s2vi);
>         if (ret) {
> -               kvm_release_page_unused(fault.page);
> +               kvm_release_page_unused(s2vi.page);
>                 return ret;
>         }
>
> --
> 2.47.3
>
>

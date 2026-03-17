Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1D0330648
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 09:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773740376; cv=pass; b=CNVWLYHIeLAxmlZ0zI7AJcT/SlcPSsM5jbiGnIpzGy1Ljc2/THEQVoX64+Bq1FByuVUm4M8e5kMhfVDqZIsrr/LG2hc4vHTUafk1194e5whEly12PpTt0y85HAQycugnNtuoT+q38tsL+5MEt/YLX+ipD5S85olLxlZysXfya98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773740376; c=relaxed/simple;
	bh=NmEWj53uBRTRD3rmTBUblDiOcLhr9FvWoYZY5y5uIpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aAQnKBzQbFZxTGGxFwcSvCjZfkL5SGaP3SEL7HJ9EA5D1JHXcRZVoK8kCAC21apM6CsMvF6AVlq3hbJoyJLPl2SD0EUyX53ezMZfjj3tcrZANY11c65lk6owWpYRc9rDZpTERtzeosZ67EoV2R3mFx3aHWTaJjhiZ1Pbmn/6lSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H4MYka4n; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H4MYka4n"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-509062d829dso379551cf.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 02:39:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773740374; cv=none;
        d=google.com; s=arc-20240605;
        b=dYS/BRC0qVBKniiI4Aa2C8B655AfiBW+cKbyAQmYOFiivcqy7bJL2o5/vk23VotYBg
         JVRVY661cv9om8lzkjPBEBmpfdqxE6Pj/Ogjg1Zt/fvKMCdHlyLuKiPEfAZ1oYveMqf7
         P0CWv5YuiFjgfxYzrIkYpTnJbRf8nTmhBGV86d2FVOw7fs2MWQUMWU/rrgn8VVo3yin/
         A9QLBWwJXGwVgWwlvaZrF+1jJ8BJ0yR1983amo+vkOYfyp3DJKHNDTV7zrrXJFoxbsLW
         iyVvdR5UPmr2makWdMvyxHDvWbU/gpdSnujmq1hqgdegLkWKDMK3TUkwdO1IuMeLnPpO
         QlaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=nl8+CRYT4AqYzj6TfeAkgV0uZq+82OmQ6U8LucFBjLc=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=Ll0AoFGf7M8R3bvzAqK+ogAOp0fuwyuOQrUDrZXOgdz5wtzGZhH4Kw8hJyT9xQ87tW
         9cuwSWggCEO84E1ZaX6Mm9HqGWVd4pRBPeeIg4UxVIIijKsrh2demp9XQLC/JVJJopyZ
         5vNKmdZ0EIGxkWAph0/VJOp0kyDeuL7lwRAtopjN3AXHG/P0V09BWqfj3WVJ2/uRnyp/
         ybYsFG2NRSlZMekiAe4CtRjbB3ETZZaQNk9OCfQbdchEu+Pc8T4Hj6n5bAKbdqIfoLWZ
         xQGq1YVP9PMvfnuz80UaWnqNvmhezeInLw5FvyZv04N2kNP1vltwCFLF9f6bKy7e9XIJ
         cSQw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773740374; x=1774345174; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nl8+CRYT4AqYzj6TfeAkgV0uZq+82OmQ6U8LucFBjLc=;
        b=H4MYka4nzissVUJwqnhs2NhC6QZTZscqPkgKEZPd5PAPAdr7zFdsHz9691W/1E1FQM
         kB+s/cftAhYdJ5Z+2TD06qdg6zD7/Na+FU4TmzcE1GHHNsfpYHhlkxz4U1S9HLe9lwQa
         x6A4mklsztKokW/N+k0/r3ZHDrXlLBBU60Nw6cDYxiGLXGGquD0grB2HhCQhgARsiyKO
         v346UJzZQ5TPIiCBog7+yajU5+bzCy56rZwU6q6b+mp4TkLdYrmuPrnGE4KSOPb+sFkw
         LUY7fvzrDfvNN6YaN44rjOmvsb1qOWzEN2dRg0bhGjMuxWH5Qd6V8EoiS4bSk8a3wvi3
         CLaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773740374; x=1774345174;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nl8+CRYT4AqYzj6TfeAkgV0uZq+82OmQ6U8LucFBjLc=;
        b=RUXDQ+Yx1zgsUzjeoEXTYi8QXnOj6ThKFikYpVgOoxwjrrkLEBcUGakP4IMt3/AtJr
         GA45OGZuOdAvk2lvdm6TSMr+yE0mMJGSyJmVKwD2PrLhq58bbkbqASz0/rxJibHryixk
         0I49z94lC1sF21wl0o15icvSfrYxHt0eRxfYHoOjorMTWgQAcIFXsKwAh9Nq767oSsaZ
         aNHwNdt5YRaIdCOOMY3EceR0gayMcsbP8/9PbLQQukPZFIrjIpZPUfv1Ox99n+jGP1fe
         vDai015MJsz98I4Lh3ZJ4dtSARimMBRWZw6kNLX1qhxG5ywGfIUwL3xDv2aaysBWS4n3
         Xt8A==
X-Gm-Message-State: AOJu0YxXS0DASgWg1wgWMHCMeaIYgdQsfQtl0jqE9vDwdcvcabSptUvg
	w+QdITEJ1oBM859HuaUq1TABl37IpV6HLW+YTpWOsZZrp6gtQ7NNdn9cFuLXMoJaMtkldCssFzy
	mWZCtYnLPDwGBdMM36ZoUWsHcmJ1sIKPLsAife21r
X-Gm-Gg: ATEYQzwbgMhnuDX0aMAZ6Y0iallWUwEznCuST3uv6zJDyBF+UJjp6Wdb7+0AUoibA8l
	SM6juaWWLkQqaWcti4HHoHoocZwe2fCF9U1nizxxw3VZhhDcxZhvZOqm/vDCXywfen+3y4ySy8l
	Kya5fdLioy81GkfImfwSuSgexzL91tl1V6Mc8pys9xorYHEj/c+HGoP6PC2tEW9ZY3x/i1gg3ja
	mwnuuLj3yw2ubXqSVIrI5vkLdNE78Xqc2XNKn1SAG9oZXR4a0HxjAiOB5y64Fxyt6QEj0312la0
	waGZl9L3ItFp29vqSySSaczmgpI5F7r3EfzWafh3EqM90O0=
X-Received: by 2002:a05:622a:4c9:b0:507:35b2:6b9 with SMTP id
 d75a77b69052e-5099ae2ae24mr10556781cf.7.1773740373177; Tue, 17 Mar 2026
 02:39:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org> <20260316175451.1866175-3-maz@kernel.org>
In-Reply-To: <20260316175451.1866175-3-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 09:38:55 +0000
X-Gm-Features: AaiRm50ulOtZPjDdImqlxYz51RCxyAEIHQJXJIULb8YzYDGnqaOlaLRa9XRiilY
Message-ID: <CA+EHjTwC_TNj9Ggb7P3z+EwJ0cp6eS=NCx0NqDa1=E4FWP50ow@mail.gmail.com>
Subject: Re: [PATCH 02/17] KVM: arm64: Make fault_ipa immutable
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Mar 2026 at 17:55, Marc Zyngier <maz@kernel.org> wrote:
>
> Updating fault_ipa is conceptually annoying, as it changes something
> that is a property of the fault itself.
>
> Stop doing so and instead use fault->gfn as the sole piece of state
> that can be used to represent the faulting IPA.
>
> At the same time, introduce get_canonical_gfn() for the couple of case
> we're we are concerned with the memslot-related IPA and not the faulting
> one.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/mmu.c | 38 ++++++++++++++++++++++++++------------
>  1 file changed, 26 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index fe8f8057cf412..ab8a269d4366d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1400,10 +1400,10 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
>   */
>  static long
>  transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
> -                           unsigned long hva, kvm_pfn_t *pfnp,
> -                           phys_addr_t *ipap)
> +                           unsigned long hva, kvm_pfn_t *pfnp, gfn_t *gfnp)
>  {
>         kvm_pfn_t pfn = *pfnp;
> +       gfn_t gfn = *gfnp;
>
>         /*
>          * Make sure the adjustment is done only for THP pages. Also make
> @@ -1419,7 +1419,8 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
>                 if (sz < PMD_SIZE)
>                         return PAGE_SIZE;
>
> -               *ipap &= PMD_MASK;
> +               gfn &= ~(PTRS_PER_PMD - 1);
> +               *gfnp = gfn;
>                 pfn &= ~(PTRS_PER_PMD - 1);
>                 *pfnp = pfn;
>
> @@ -1735,7 +1736,6 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
>  {
>         struct vm_area_struct *vma;
>         struct kvm *kvm = fault->vcpu->kvm;
> -       phys_addr_t ipa;
>
>         mmap_read_lock(current->mm);
>         vma = vma_lookup(current->mm, fault->hva);
> @@ -1753,9 +1753,7 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
>          * mapping size to ensure we find the right PFN and lay down the
>          * mapping in the right place.
>          */
> -       fault->fault_ipa = ALIGN_DOWN(fault->fault_ipa, fault->vma_pagesize);
> -       ipa = fault->nested ? kvm_s2_trans_output(fault->nested) : fault->fault_ipa;
> -       fault->gfn = ALIGN_DOWN(ipa, fault->vma_pagesize) >> PAGE_SHIFT;
> +       fault->gfn = ALIGN_DOWN(fault->fault_ipa, fault->vma_pagesize) >> PAGE_SHIFT;
>
>         fault->mte_allowed = kvm_vma_mte_allowed(vma);
>
> @@ -1777,6 +1775,17 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
>         return 0;
>  }
>
> +static gfn_t get_canonical_gfn(struct kvm_s2_fault *fault)
> +{
> +       phys_addr_t ipa;
> +
> +       if (!fault->nested)
> +               return fault->gfn;
> +
> +       ipa = kvm_s2_trans_output(fault->nested);
> +       return ALIGN_DOWN(ipa, fault->vma_pagesize) >> PAGE_SHIFT;
> +}
> +
>  static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
>  {
>         int ret;
> @@ -1785,7 +1794,7 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
>         if (ret)
>                 return ret;
>
> -       fault->pfn = __kvm_faultin_pfn(fault->memslot, fault->gfn,
> +       fault->pfn = __kvm_faultin_pfn(fault->memslot, get_canonical_gfn(fault),
>                                        fault->write_fault ? FOLL_WRITE : 0,
>                                        &fault->writable, &fault->page);
>         if (unlikely(is_error_noslot_pfn(fault->pfn))) {
> @@ -1885,6 +1894,11 @@ static int kvm_s2_fault_compute_prot(struct kvm_s2_fault *fault)
>         return 0;
>  }
>
> +static phys_addr_t get_ipa(const struct kvm_s2_fault *fault)
> +{
> +       return gfn_to_gpa(fault->gfn);
> +}
> +
>  static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
>  {
>         struct kvm *kvm = fault->vcpu->kvm;
> @@ -1909,7 +1923,7 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
>                 } else {
>                         fault->vma_pagesize = transparent_hugepage_adjust(kvm, fault->memslot,
>                                                                           fault->hva, &fault->pfn,
> -                                                                         &fault->fault_ipa);
> +                                                                         &fault->gfn);
>
>                         if (fault->vma_pagesize < 0) {
>                                 ret = fault->vma_pagesize;
> @@ -1932,10 +1946,10 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
>                  * PTE, which will be preserved.
>                  */
>                 fault->prot &= ~KVM_NV_GUEST_MAP_SZ;
> -               ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault->fault_ipa,
> +               ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, get_ipa(fault),
>                                                                  fault->prot, flags);
>         } else {
> -               ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault->fault_ipa, fault->vma_pagesize,
> +               ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, get_ipa(fault), fault->vma_pagesize,
>                                                          __pfn_to_phys(fault->pfn), fault->prot,
>                                                          memcache, flags);
>         }
> @@ -1946,7 +1960,7 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
>
>         /* Mark the fault->page dirty only if the fault is handled successfully */
>         if (fault->writable && !ret)
> -               mark_page_dirty_in_slot(kvm, fault->memslot, fault->gfn);
> +               mark_page_dirty_in_slot(kvm, fault->memslot, get_canonical_gfn(fault));
>
>         if (ret != -EAGAIN)
>                 return ret;
> --
> 2.47.3
>

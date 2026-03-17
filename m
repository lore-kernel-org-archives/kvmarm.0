Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2DD344040
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 15:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773762109; cv=pass; b=t3R2QRglDc/VNuL438bjm5ADaly2IOebtxm785ehWj2WbnW9Qn78OeB90p9YJA8/TKDpmbNC4u7+7GqG/0yRsFVew0Sa5LsoUQpfgEyNsQr56pCbpT6+6PHLcXGTwvTGMTe0+p94bqBgdSKF9noVLw9Vs4OlEBZdQOupAO2VXrk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773762109; c=relaxed/simple;
	bh=QIxT1g26xxgnVmb6qOnWnCns3ZxAr08Vr/5blKZW9gc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jcJNLlWQFNejGldSGGVsb+wLIO2gPH99rEdmifCSMLgUdQ2UTOhZBG3680v99MzayOfDQcnGMowfijjyGvJ7tYYJxAbaPbKToZJllq007DPDBBl1jRsZu3D4sVS4Tb/88StMt3iiP0BnwTVe81yQLK0iKxv72Vq5jiJW7ZK3s2o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ly6zjyiH; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ly6zjyiH"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-509062d829dso603231cf.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 08:41:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773762107; cv=none;
        d=google.com; s=arc-20240605;
        b=P2NuXRa8DOr9wXKb2O9clW9z8yjiHZ5oBFf1NopIHqU6fyThI7m1XY68vSi2M5BGCC
         Hid37OiepIvVRKF/CwCSaFx/MTf1MWm5N2iSKVcguFlgPXMAvS6YF9y75eaV1q3DVFTz
         6dqRJHDavTHM85c1Yoqw18l3oAHY4fnoDDXnNx/bRARxlydaRNcyC4fiMZnCRS+XnqlR
         ePzYCT1+ZqEgtWh/g02O9atkJMN9DJPvNpEXBKuka4DG8T2NfxLwuLga1d3m+Ch8re0z
         bJOqQYVXqNP9f7rfrs1FjnChxK/1XV8lk9V7BoW++EI03JK8fpHBwy/Cb6NL5oG6I4hK
         ADnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=kXLm03NaY5p75qdptgVFDNEv7G3SzFx2yMPW/l+UZLE=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=RMqXTpf2ynL5Z+hJgR3h/xjz+fM6e/QrEwdyJEtWVB/BWGxBHXbqfAuDNwnV6cOYAA
         Je2URYZcgmZJ5ACA7iU/VjK/RhxyCpxjSG0U0n+vs5wBeIiXOXrx9gnn+P1QI7N53B8R
         IryCiYfuU4f3KFCdAzSkEixxp0JKwwmyZhq64briaDaLZMXbCfJ1VfVtCuxhX12TenLW
         i1DBkQZCAWAzivKjWddLDJNtB/QyzXG6iTiFHrE9Fd6tPgR2jE4XIvOE8gyUFpbesAd2
         PMLFBrgMsnystxqevP2Acd63RiMETtAQKiyK8/nKF2JvHt1hj9iHKW4V8DLvtgS5lcxr
         H+Vg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773762107; x=1774366907; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kXLm03NaY5p75qdptgVFDNEv7G3SzFx2yMPW/l+UZLE=;
        b=Ly6zjyiHmVgQNF97ASp73j0hWJggJHpP6MviXKyk4OvIozVjWEwGlhgg/Aa1bXGBwp
         4aJ5YiN+7RZE/CaNnNC/fPjoUevCUbP/qe6FYMsXqK0E1h4ImCm351awbl+Mg/ChTehO
         3nUZ4KW4n3vzfI00UEoO+8ZbZeBL8D/ucI1sJBj1/mphb13OrJKB3rhXSZJloRvFLyHL
         dXhZn9Q93MEfYTrODvTWZLtkGvQK157iksR8stQPNX4bPS8U8ZNGUUCKStLuBvgbF2Th
         ccNo6yV1cv/audeKMGQa2tUHAesjTfkqS8lkXf7+hGIIUzxL/MlXUQL+h8PpaK8quOo0
         BQRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773762107; x=1774366907;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kXLm03NaY5p75qdptgVFDNEv7G3SzFx2yMPW/l+UZLE=;
        b=oVctzLNsZjsl16G+WCxuzdjE0HNjfojjJadvwxqWsJBGF4muQ91GUhFZvyAS1FIIV2
         v53U7Rc0NKzmdBLegtM6cQAC4IsuMiF5gsREeRwSW252SYS42+4CN82Uj0rmDvmldwY4
         4S48S0V1C4GwAM9pnWLokRYqO7Q1pwi3fqeM/o4LY9dSG9NcRZ2gge+Mfy5Jw/O7cTU+
         7WM0Dec3cwTOS5zRI7z8hRIc0dLZ7GIAt6ngiH1PowmjBV1pDq7CuYGeXP9UBNAlPr5b
         ahS18295EGNR6/j1kJtDexYI0cqjNpO6LfzTOOvVLTs9Kq0mPojDc3cqGk5eb7lM901f
         U7GA==
X-Gm-Message-State: AOJu0YwhFNkne2ens4Ht7giq9aGiG50fq7IxZFrsRuHEDJdFNpAxdqMJ
	/ACHwd801EKA+3ohJLZQw1qOKB2sZ82mFiLr6GZbTV0sMXBxH3i3bUgNN0Pm5sWG+csQAp5W1c9
	l5sbXhO2zQLRr2tR3VMVwXkGu8kqJnlrBn9Lu9Ma/v29moJS4IdqJEvfU
X-Gm-Gg: ATEYQzx9tXgofGWoCyfje45NzoT5bLxD3+CsWvvigVt5S1ZwsGdj+5OSSTbrI2wgWc1
	RDVkNxUuZqI1bGBmiA06zn2aGKkT67qh2ePPYK2rR+P4owx7zCCpavq9kGH3a9G7eRlR4v/m0xL
	NN1UzxtWtkTgnhHTiUxGNhbWDaZkuSVtUqKEDyvYNC0Mr0gRZxth1F46EKdFIhhkLiEc6qsh2+C
	AyV9e8IVsgDbTDCpBE9r0fNT4cxZL+W7/TkI6oKAyumTaO5zS+Clyjij6bAcUGL8LHG9fW/I61z
	nENFAyelp0RMejewjhfmj1A7jqMZmo+THNfN
X-Received: by 2002:a05:622a:1987:b0:509:1c2c:866 with SMTP id
 d75a77b69052e-5099ae2a4ccmr15436131cf.11.1773762105375; Tue, 17 Mar 2026
 08:41:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org> <20260316175451.1866175-15-maz@kernel.org>
In-Reply-To: <20260316175451.1866175-15-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 15:41:06 +0000
X-Gm-Features: AaiRm5280nFVi9VVGMV9I5qqtqhUNzi2m_pJsphpi_PzXiuG8fQT2oFQsOr0Voo
Message-ID: <CA+EHjTwxKxpUg06J9tRqz=v1M2vGh=xUKijKNtxn0PMYcn9PiA@mail.gmail.com>
Subject: Re: [PATCH 14/17] KVM: arm64: Move device mapping management into kvm_s2_fault_pin_pfn()
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Mar 2026 at 17:55, Marc Zyngier <maz@kernel.org> wrote:
>
> Attributes computed for devices are computed very late in the fault
> handling process, meanning they are mutable for that long.
>
> Introduce both 'device' and 'map_non_cacheable' attributes to the
> vma_info structure, allowing that information to be set in stone
> earlier, in kvm_s2_fault_pin_pfn().
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/mmu.c | 52 ++++++++++++++++++++++++--------------------
>  1 file changed, 29 insertions(+), 23 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index ac4bfcc33aeb1..97cb3585eba03 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1656,9 +1656,11 @@ struct kvm_s2_fault_vma_info {
>         struct page     *page;
>         kvm_pfn_t       pfn;
>         gfn_t           gfn;
> +       bool            device;
>         bool            mte_allowed;
>         bool            is_vma_cacheable;
>         bool            map_writable;
> +       bool            map_non_cacheable;
>  };
>
>  static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
> @@ -1728,7 +1730,6 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
>  }
>
>  struct kvm_s2_fault {
> -       bool s2_force_noncacheable;
>         enum kvm_pgtable_prot prot;
>  };
>
> @@ -1738,7 +1739,6 @@ static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
>  }
>
>  static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
> -                                    struct kvm_s2_fault *fault,
>                                      struct kvm_s2_fault_vma_info *s2vi)
>  {
>         struct vm_area_struct *vma;
> @@ -1794,12 +1794,11 @@ static gfn_t get_canonical_gfn(const struct kvm_s2_fault_desc *s2fd,
>  }
>
>  static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
> -                               struct kvm_s2_fault *fault,
>                                 struct kvm_s2_fault_vma_info *s2vi)
>  {
>         int ret;
>
> -       ret = kvm_s2_fault_get_vma_info(s2fd, fault, s2vi);
> +       ret = kvm_s2_fault_get_vma_info(s2fd, s2vi);
>         if (ret)
>                 return ret;
>
> @@ -1814,16 +1813,6 @@ static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
>                 return -EFAULT;
>         }
>
> -       return 1;
> -}
> -
> -static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
> -                                    struct kvm_s2_fault *fault,
> -                                    const struct kvm_s2_fault_vma_info *s2vi)
> -{
> -       struct kvm *kvm = s2fd->vcpu->kvm;
> -       bool writable = s2vi->map_writable;
> -
>         /*
>          * Check if this is non-struct page memory PFN, and cannot support
>          * CMOs. It could potentially be unsafe to access as cacheable.
> @@ -1842,8 +1831,10 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>                          * S2FWB and CACHE DIC are mandatory to avoid the need for
>                          * cache maintenance.
>                          */
> -                       if (!kvm_supports_cacheable_pfnmap())
> +                       if (!kvm_supports_cacheable_pfnmap()) {
> +                               kvm_release_faultin_page(s2fd->vcpu->kvm, s2vi->page, true, false);
>                                 return -EFAULT;
> +                       }
>                 } else {
>                         /*
>                          * If the page was identified as device early by looking at
> @@ -1855,9 +1846,24 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>                          * In both cases, we don't let transparent_hugepage_adjust()
>                          * change things at the last minute.
>                          */
> -                       fault->s2_force_noncacheable = true;
> +                       s2vi->map_non_cacheable = true;
>                 }
> -       } else if (memslot_is_logging(s2fd->memslot) && !kvm_is_write_fault(s2fd->vcpu)) {
> +
> +               s2vi->device = true;
> +       }
> +
> +       return 1;
> +}
> +
> +static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
> +                                    struct kvm_s2_fault *fault,
> +                                    const struct kvm_s2_fault_vma_info *s2vi)
> +{
> +       struct kvm *kvm = s2fd->vcpu->kvm;
> +       bool writable = s2vi->map_writable;
> +
> +       if (!s2vi->device && memslot_is_logging(s2fd->memslot) &&
> +           !kvm_is_write_fault(s2fd->vcpu)) {
>                 /*
>                  * Only actually map the page as writable if this was a write
>                  * fault.
> @@ -1865,7 +1871,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>                 writable = false;
>         }
>
> -       if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu) && fault->s2_force_noncacheable)
> +       if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu) && s2vi->map_non_cacheable)
>                 return -ENOEXEC;
>
>         /*
> @@ -1888,7 +1894,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>         if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu))
>                 fault->prot |= KVM_PGTABLE_PROT_X;
>
> -       if (fault->s2_force_noncacheable)
> +       if (s2vi->map_non_cacheable)
>                 fault->prot |= (s2vi->vm_flags & VM_ALLOW_ANY_UNCACHED) ?
>                                KVM_PGTABLE_PROT_NORMAL_NC : KVM_PGTABLE_PROT_DEVICE;
>         else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
> @@ -1897,7 +1903,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>         if (s2fd->nested)
>                 adjust_nested_exec_perms(kvm, s2fd->nested, &fault->prot);
>
> -       if (!kvm_s2_fault_is_perm(s2fd) && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
> +       if (!kvm_s2_fault_is_perm(s2fd) && !s2vi->map_non_cacheable && kvm_has_mte(kvm)) {
>                 /* Check the VMM hasn't introduced a new disallowed VMA */
>                 if (!s2vi->mte_allowed)
>                         return -EFAULT;
> @@ -1937,7 +1943,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>          * backed by a THP and thus use block mapping if possible.
>          */
>         if (mapping_size == PAGE_SIZE &&
> -           !(s2vi->max_map_size == PAGE_SIZE || fault->s2_force_noncacheable)) {
> +           !(s2vi->max_map_size == PAGE_SIZE || s2vi->map_non_cacheable)) {
>                 if (perm_fault_granule > PAGE_SIZE) {
>                         mapping_size = perm_fault_granule;
>                 } else {
> @@ -1951,7 +1957,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>                 }
>         }
>
> -       if (!perm_fault_granule && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
> +       if (!perm_fault_granule && !s2vi->map_non_cacheable && kvm_has_mte(kvm))
>                 sanitise_mte_tags(kvm, pfn, mapping_size);
>
>         /*
> @@ -2016,7 +2022,7 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>          * Let's check if we will get back a huge fault->page backed by hugetlbfs, or
>          * get block mapping for device MMIO region.
>          */
> -       ret = kvm_s2_fault_pin_pfn(s2fd, &fault, &s2vi);
> +       ret = kvm_s2_fault_pin_pfn(s2fd, &s2vi);
>         if (ret != 1)
>                 return ret;
>
> --
> 2.47.3
>

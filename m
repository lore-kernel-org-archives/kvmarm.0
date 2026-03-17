Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4EE3A6EE9
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773745527; cv=pass; b=JGh6DDT+FYB74GrDo0yiH5d8Dq6/VV98NcwzzUiLumh49/zISTSU6NbKd2CTckSqAINrQIDtRIuuXeW3PTm1aAa0VmYTDSvwcuosIKEdjRIBCRnTqEZeYiu1m9MpNXTXoSXudj/ZM8pB3oTErwW6ufJ5hNniWfiDGqObcVhyXmA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773745527; c=relaxed/simple;
	bh=2irVs3SNlBrrcbsOQ/WvXHx0eAf65gYNXRxrSiVR2xk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z542roYmvQQGAuRcaWgtz2HgzMFZphyrDNA70JkoKqj7x/dd7Eie1HcZQoVfaF13riPTzKEAAgbkkLSI3YR48kfWkM3yV5+LAqLF7C0SfXLd5niupqc1R+DyftIs/V6kFiNH0nzkL3wCEyV5rEAnr/e5c3MoQ2DPmXF6aS+0dV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=shmsOxZS; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="shmsOxZS"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50906a98ffeso552441cf.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 04:05:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773745525; cv=none;
        d=google.com; s=arc-20240605;
        b=VASQWPOLKwYadWiAZib0mG/rAYGaahG7+zJja1pbBwhABQpsf9qe/eRONV3AopuDtS
         jrIZOuYGR9PZQSNFUNRJMUOCcb6OfIFwh+faf+hdBkXqGaNwi/2BJo66IsLk2TsWYwIO
         IpvNx5zkwCFYtZoP8YlvOcQ4o9hv4JxYZ72tNlQi2VtSY+YZ4QyPpVDoUMT2V6R78H2l
         euOh6PQzfJfH+XTsF+Ye08GituuHO+Mkl5/RTFc4eIfbK/Z6mtQpgLNpDRoipUcoVRFj
         NKMAuNRr35eXfbrqQDTTweSSp2Hdy1ghZGiSWLUEOD6pcnbmrL/NNe7aoi1XIMHdorK3
         i1iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/WKdprvW6adU6RgFVo+d3KCZoQm+Cn1qvOXuG+NZlR0=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=l2Wm3URvpdwkjMehqZxr3tO1CqDT452nWMKPXHeeasQsobz19MNmqI+/dKgaNbtt1D
         Qpo7Bnr91XxnsXfUDV+NsnCWyL5D4YnXTHCRvhYSgFf7PW35GnjifCa5Ar3C6MUGzrI3
         uqf2uR5sOnidSeJxGEkmsEp3YCbJa7GRrt3KC3bpf09uoT9mP4o9oC8uCJhCBn+5HuHm
         ni7I5vOgeHcDdGMbBKDxgcC3ey7bsb1p4nFc44toPrpbuIZtQSZuVpaBpDbEnKMEuiui
         ZpinBlVVAZ30PxHqr8Gw6ye70gNRgpP1Wk+9aBtiHFpgMIm2QFsjvldtJP9SRy5pFsf7
         UQrA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773745525; x=1774350325; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/WKdprvW6adU6RgFVo+d3KCZoQm+Cn1qvOXuG+NZlR0=;
        b=shmsOxZSK70dnsQasCJNzoapIEyOyd/Lb7Fh8gEm4/HipW3a11r2vyJd7QkrpO7vAx
         +AEOzOhIa20wgufAhdpLtaeoV9Nn1/ZCnlqDoseD01WlaZ5l9AmEqqb2wJsk9ceSxTu8
         +AaZREG2Fsxd9Sr0VUrjg6YYeDKHkdO4hxhyVFFjLm4bBUfRg94yv0GgL6pr8RvDHN+P
         ATngw6XyYhwTyynImLU/ukLhbxNzZTpq6cmlYxDAYMJfRKRsu4Zbgl3+bgekv2+EQgjV
         K2HNA1aUwxTKstRf68vj1WU2pPXWdRdZETs8tzNBdeQKV/Q9BFrQd15wADR1bQwWWXRP
         jXnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773745525; x=1774350325;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/WKdprvW6adU6RgFVo+d3KCZoQm+Cn1qvOXuG+NZlR0=;
        b=SXbVJLsBYvxWYDWyq5uqCnou0FYgewdOoQRwRBel/vR+vUnjTPsYPQBoL/bzmLZf74
         9YJtSDIGtxLjHLzFY1rlRcGzQVnnIfa3+tkVEDu2HZvOdSnAkr1bIlH8ja3mYZEqyuzV
         SqqkpcNB39UOEO83L5K1iLn6VqkxYpJc0dKlKpb0IqHBu382rlEENNMmIcDcAoPnshG/
         Oy1EfIk37BCL8GgHeGJgSStalXZb5zEnE9hyfoVzc0JyFQfYiJrE7jbBnQf9x8+7473a
         WtKE9/prFEU2FIklyxr9aDdLijIsbolissZP28wFacTZ541uAbddV/Itm749OwRNIlwU
         NlUw==
X-Gm-Message-State: AOJu0Yzq9J+LD6ojCwHc3+MIBpmMmBfjnpx2NduP0UvO+Wfhy5M5NHC7
	hJFXUs8ywg/EzA96EmC74jT8aZVeITqSbStcgtnCwHvDYZ92rSRrShh3u3AJYdAy8pIjGjSIXij
	qtacCtMMp1H3GqBcjAGN0xapRcH+rE96zcqBB+fvBGPI3kwd7rI4OMqXCMqY=
X-Gm-Gg: ATEYQzwydpkGrIBuWP11KMDbjluPVyD983ymLg09Kasd7BhcyPn7lCh95/erqkCF5vU
	24xb3tlJFLUrte4ZTK7tZ/1nXpbwex5MRm2wvoSMmhI+3lRWXf/7zVBHh+P3E5J1wm4c768H6yi
	QpXHlSlP9AQ04mApyxzhoxxjC9ZiEM18EZxzp+19BYUpmq5GXHAjtPBSxom9ghDxjkqsGylalej
	k/4TG3DE6TkCRhcDVlx3XpJ+kRMCIv723jyJG4qOs7UkwOZQayP5tF+qO68amFtwKwekX2f4yUu
	lkGeiK2ugghZOYZr88KWo2vfxakz5Bd7Kk7o
X-Received: by 2002:a05:622a:1905:b0:4ff:bfd9:dd31 with SMTP id
 d75a77b69052e-5099ae32a3amr11048511cf.5.1773745524297; Tue, 17 Mar 2026
 04:05:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org> <20260316175451.1866175-6-maz@kernel.org>
In-Reply-To: <20260316175451.1866175-6-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 11:04:47 +0000
X-Gm-Features: AaiRm52BrqjoXTcX4p8Zz17WuQuzN8NXXt28Rw0tRU6bXjzxR_z_iFz7YXzu9e4
Message-ID: <CA+EHjTwmHKCqeHCzjhRj6sXu+ahtO69spFEmegUTzwxbH5=QVA@mail.gmail.com>
Subject: Re: [PATCH 05/17] KVM: arm64: Constrain fault_granule to kvm_s2_fault_map()
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Mar 2026 at 17:55, Marc Zyngier <maz@kernel.org> wrote:
>
> The notion of fault_granule is specific to kvm_s2_fault_map(), and
> is unused anywhere else.
>
> Move this variable locally, removing it from kvm_s2_fault.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
> ---
>  arch/arm64/kvm/mmu.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1b32f2e6c3e61..12c2f0aeaae4c 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1724,7 +1724,6 @@ struct kvm_s2_fault {
>         bool logging_active;
>         bool force_pte;
>         long vma_pagesize;
> -       long fault_granule;
>         enum kvm_pgtable_prot prot;
>         struct page *page;
>         vm_flags_t vm_flags;
> @@ -1908,9 +1907,9 @@ static phys_addr_t get_ipa(const struct kvm_s2_fault *fault)
>  static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>                             struct kvm_s2_fault *fault, void *memcache)
>  {
> -       bool fault_is_perm = kvm_s2_fault_is_perm(s2fd);
>         struct kvm *kvm = s2fd->vcpu->kvm;
>         struct kvm_pgtable *pgt;
> +       long perm_fault_granule;
>         int ret;
>         enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
>
> @@ -1920,14 +1919,17 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>         if (mmu_invalidate_retry(kvm, fault->mmu_seq))
>                 goto out_unlock;
>
> +       perm_fault_granule = (kvm_s2_fault_is_perm(s2fd) ?
> +                             kvm_vcpu_trap_get_perm_fault_granule(s2fd->vcpu) : 0);
> +
>         /*
>          * If we are not forced to use fault->page mapping, check if we are
>          * backed by a THP and thus use block mapping if possible.
>          */
>         if (fault->vma_pagesize == PAGE_SIZE &&
>             !(fault->force_pte || fault->s2_force_noncacheable)) {
> -               if (fault_is_perm && fault->fault_granule > PAGE_SIZE) {
> -                       fault->vma_pagesize = fault->fault_granule;
> +               if (perm_fault_granule > PAGE_SIZE) {
> +                       fault->vma_pagesize = perm_fault_granule;
>                 } else {
>                         fault->vma_pagesize = transparent_hugepage_adjust(kvm, s2fd->memslot,
>                                                                           s2fd->hva, &fault->pfn,
> @@ -1940,15 +1942,15 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>                 }
>         }
>
> -       if (!fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
> +       if (!perm_fault_granule && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
>                 sanitise_mte_tags(kvm, fault->pfn, fault->vma_pagesize);
>
>         /*
>          * Under the premise of getting a FSC_PERM fault, we just need to relax
> -        * permissions only if fault->vma_pagesize equals fault->fault_granule. Otherwise,
> +        * permissions only if vma_pagesize equals perm_fault_granule. Otherwise,
>          * kvm_pgtable_stage2_map() should be called to change block size.
>          */
> -       if (fault_is_perm && fault->vma_pagesize == fault->fault_granule) {
> +       if (fault->vma_pagesize == perm_fault_granule) {
>                 /*
>                  * Drop the SW bits in favour of those stored in the
>                  * PTE, which will be preserved.
> @@ -1984,7 +1986,6 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>                 .logging_active = logging_active,
>                 .force_pte = logging_active,
>                 .prot = KVM_PGTABLE_PROT_R,
> -               .fault_granule = perm_fault ? kvm_vcpu_trap_get_perm_fault_granule(s2fd->vcpu) : 0,
>                 .write_fault = write_fault,
>                 .exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu),
>                 .topup_memcache = !perm_fault || (logging_active && write_fault),
> --
> 2.47.3
>

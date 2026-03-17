Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C9835C195
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 09:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773739370; cv=pass; b=YiNHJcj43dPxLgyIgRn/Z+OZHIcH2h4ptMGWASNiC4GgYPBwG4N+ozq7sIt8PVUrAnwyCxCp610r6OOnIThc6ihius66AgTC2viVuonjjNxCXfQSwQkg/qPXJ4ef2ANSRCNMcdOPv0to4gTJ93N9kg+zx9Cgi1wsXebJPq/1dcg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773739370; c=relaxed/simple;
	bh=2jA7Qi0M29gmCAImT+RlfChtJmHWyNoUHY6cVa7s2RI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PY0arOZpPABOoVdwOGiycj0vywHCbqI7YrAi67LfvDFeQyEiUVz0mYK80g/3Wm6AkxknZep1BM42P0ZitTWUbmkZS+zCvvgJ6ZgETn5YyhiYEAFofOoCxEi+V7BHpOcYIq9XJqjA7LkzVU7MWGe2GDtqsa9i8xLeQA7FhuYeT2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eAqM+6rh; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eAqM+6rh"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-509069a7a7fso447631cf.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 02:22:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773739367; cv=none;
        d=google.com; s=arc-20240605;
        b=L2SpjIaGj5aRIG4SLvsvBOG6CPkr1X9SkEpNyvcn/0S0UaP1f+iHDGe+V8aHToxquL
         h1ODpdqcxT+FhYzcq+aOXUPbl0hLkWRS+FOUhe3Nq5km9NaPg2fG8x/RvF2ocJcRDwbj
         RB09Yja/Vgon2ovt+HlsY1gIeSEOKYxcw00ap96lof6aPT8piY4JsLlg0RDswwR4AiVu
         YR+ZnBJUyNWM2PHNF0q35P/o+JNBIjsGehX5HNhED8TeOe5vuy3SQVvvWHki50e1szZG
         gPkisebw+UI+QtkBCZ4QUG6xV90MNaxqsjHBn1iC4l5Y1pH/wDGRWLz4sDNpR79Bk2uz
         1yvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Mf/9giwzKIydxXGiboXiv6gCzPB39R05aoyKnuoj2ko=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=Dvwis0X+kGfJim8MGcLrtKvq3GRlZixpShMaJrmK/dXP/eAZSyUjiyvC1FndGe7+Ab
         17XxBQZy+wslib4oBWdysRspV6ZiZxchzuduibi6dP7C+LCBkzWTl8VkbT7nwe/fLXlW
         f3MmHphJjQNFkJfv/pD2mDHiigw1FEoB0xXmqS4Zy27iemvEFiK4CNJNQ7rGP8mntYAQ
         VWR3BmaWwiPvSBntRp1efKMblvkvBbRAE9enikYjStY3HIcnTTTi0b36nl2yQ28Hk6Ci
         Y4uRflwEXa7o02WacSTzGBhhOqhHCtexe701iBcUQFmF48h1pO8TufrcXRyU1108n9mk
         UyUw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773739367; x=1774344167; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Mf/9giwzKIydxXGiboXiv6gCzPB39R05aoyKnuoj2ko=;
        b=eAqM+6rhVUavU4BAH9vFxHr0lfwgTWLz82FbJbRvvbNrIjbHAskouZS7RxIoWkVdDc
         3JmBBK4e1W7bz4pURzgClnI75dd7u8rBa8uD6UwKD6Hvj5FDr1HrS3x26Fgi7d3vkgVq
         z9XQzB5aUu+uCBq9+8H7pQjsZZUFj1eqsJasq3QrbArMivTLxitJ+uS0yJ7U6qvEfZzv
         nFLZGIgHBtpjwwPe5s/jx00qRKtMBfCsmTZ9QwvFDqwv7or68j4570VvuYlbvYBW5M9r
         IPGvy6LVs4O+UdxxCWFbddcg9VTP37PB6PkbGtsz3fWTkZbepznj4JT4+HZMuqWVA2mN
         QJQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773739367; x=1774344167;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mf/9giwzKIydxXGiboXiv6gCzPB39R05aoyKnuoj2ko=;
        b=d9WkxGLl2ExKJBSJ2kEHaodUUSnfQQ+VRpR3gX+if2v65Oi9I0MotvZoTgTNmVfqW7
         3MePbJOKSxC3I15wCakSViWCQ5kwMTkZYQeXh5htEAq8X6IDvLzF06DGxQvV73Owqj8j
         jsg+hSBjRr15iBbzb56YHvh6MSxZ1bPGqHa5ao4GINDDtziAEiXTp7d3huWBNohpJtMk
         QEeLCsKrnvkuM3WhcArwZQ+c7ZNciTGJJE306LCGmlwfJjH0hJC99P5FrFnz/FUrSGma
         ZHOjHqyhVVIKyclRxT/NMIuaVoj0T0pzHIrvfYKpMMGOjVWskAq7Gtdaj4HpcTII+Qoc
         Nylg==
X-Gm-Message-State: AOJu0YzpM6WOn+jm1SwOZywqFnXU0V0k3ncVdF7CL9qeutRrwjb2Oual
	uV8S22RkGDbLSbneyD+EpUtGNujLE9HROtj2xOGNRvFWuErn37AulUz60vZNdcY1QX1rXziCDnE
	bLdXRVgRIbU9+yyI/RoX6LCr4VR1n8oXdQCtv7Hrw
X-Gm-Gg: ATEYQzxBUxDT4rELOHd2EXpX4/jZf0lMwze2P062sIB+OqtpYlc5E3RIpM38a/SQkYi
	2waq6zZCcAZyHgwFQ9/eXjfMGkEiDztE+0hDcx8oEQodqqZSAAdH7bKpfdNdonwBWAiJgSd185h
	Nv3djwOtzN2Os9lSSoCxsSgCBX31tNashtOVp4XYQ8SaNKJ7gfVfoSwkd/HCNa///6Rd4sbc3jd
	M3mgrYCjptKxMtBEcrEc0T5uPMHppXiRclmLfAru86n8/KMSJF2Tn3vH30keTC3NI3I8VshjkCV
	WVjjW9HctDrGvlrrh0xt0wF9/I6K7b+hi7GY
X-Received: by 2002:a05:622a:1987:b0:509:1c2c:866 with SMTP id
 d75a77b69052e-5099ae2a4ccmr10103971cf.11.1773739367111; Tue, 17 Mar 2026
 02:22:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org> <20260316175451.1866175-2-maz@kernel.org>
In-Reply-To: <20260316175451.1866175-2-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 09:22:09 +0000
X-Gm-Features: AaiRm520Hrh5Ypw764LiCNNkyKgzWy3z6aTOtfYZcmCicvIDTF_qmCHiaIPTc1s
Message-ID: <CA+EHjTwqQ_0Tj8jq8hDnhJTT18abrkL5OqJukpZr24vNk5Zo1A@mail.gmail.com>
Subject: Re: [PATCH 01/17] KVM: arm64: Kill fault->ipa
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Mar 2026 at 17:55, Marc Zyngier <maz@kernel.org> wrote:
>
> fault->ipa, in a nested contest, represents the output of the guest's
> S2 translation for the fault->fault_ipa input, and is equal to
> fault->fault_ipa otherwise,
>
> Given that this is readily available from kvm_s2_trans_output(),
> drop fault->ipa and directly compute fault->gfn instead, which
> is really what we want.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/mmu.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 5542a50dc8a65..fe8f8057cf412 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1643,7 +1643,7 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
>                                      unsigned long hva,
>                                      struct kvm_memory_slot *memslot,
>                                      struct kvm_s2_trans *nested,
> -                                    bool *force_pte, phys_addr_t *ipa)
> +                                    bool *force_pte)
>  {
>         short vma_shift;
>
> @@ -1681,8 +1681,6 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
>
>                 max_map_size = *force_pte ? PAGE_SIZE : PUD_SIZE;
>
> -               *ipa = kvm_s2_trans_output(nested);
> -
>                 /*
>                  * If we're about to create a shadow stage 2 entry, then we
>                  * can only create a block mapping if the guest stage 2 page
> @@ -1722,7 +1720,6 @@ struct kvm_s2_fault {
>         bool is_vma_cacheable;
>         bool s2_force_noncacheable;
>         unsigned long mmu_seq;
> -       phys_addr_t ipa;
>         gfn_t gfn;
>         kvm_pfn_t pfn;
>         bool logging_active;
> @@ -1738,6 +1735,7 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
>  {
>         struct vm_area_struct *vma;
>         struct kvm *kvm = fault->vcpu->kvm;
> +       phys_addr_t ipa;
>
>         mmap_read_lock(current->mm);
>         vma = vma_lookup(current->mm, fault->hva);
> @@ -1748,8 +1746,7 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
>         }
>
>         fault->vma_pagesize = 1UL << kvm_s2_resolve_vma_size(vma, fault->hva, fault->memslot,
> -                                                            fault->nested, &fault->force_pte,
> -                                                            &fault->ipa);
> +                                                            fault->nested, &fault->force_pte);
>
>         /*
>          * Both the canonical IPA and fault IPA must be aligned to the
> @@ -1757,9 +1754,9 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
>          * mapping in the right place.
>          */
>         fault->fault_ipa = ALIGN_DOWN(fault->fault_ipa, fault->vma_pagesize);
> -       fault->ipa = ALIGN_DOWN(fault->ipa, fault->vma_pagesize);
> +       ipa = fault->nested ? kvm_s2_trans_output(fault->nested) : fault->fault_ipa;
> +       fault->gfn = ALIGN_DOWN(ipa, fault->vma_pagesize) >> PAGE_SHIFT;
>
> -       fault->gfn = fault->ipa >> PAGE_SHIFT;
>         fault->mte_allowed = kvm_vma_mte_allowed(vma);
>
>         fault->vm_flags = vma->vm_flags;
> @@ -1970,7 +1967,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                 .memslot = memslot,
>                 .hva = hva,
>                 .fault_is_perm = fault_is_perm,
> -               .ipa = fault_ipa,
>                 .logging_active = logging_active,
>                 .force_pte = logging_active,
>                 .prot = KVM_PGTABLE_PROT_R,
> --
> 2.47.3
>

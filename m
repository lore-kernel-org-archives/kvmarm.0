Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C704C78F39
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 12:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773233442; cv=pass; b=aP9ZK07OPLcV7GJVZtqH7GBQb7QPrrjHRdBBNIpdyeHEbdreXsyIZ6WNYMOMg/7G14q4noamNWkYxLHBpNsthIy3BvDspyQBKrhQ/JoteltAryVK6iezsrLE9Z47yFB3E3s4JZn/w5uFM0PbXOYmcEmQ1qRt3NsbVmdhdFVkz2w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773233442; c=relaxed/simple;
	bh=eQ3Yvb/8+DN/bXkMqzEgl6YVFXfWUD7sGyfSQXgZC78=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dF1m+kejwYR/xq24woQy7aWoC1bchpkKsfmzySV3q4wJe225H9TzPU8xoJC/aZnr2QanE4hlLE27Ry8ibwNPHo9l0LGX57JFy54VgB4jju3qhrqRyEXpQP3ZbuOs53ESvPhbwhbj5tn52W1o/lilA+N9RAEL4iHN5CAlPlqOqG4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sye7jGKa; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sye7jGKa"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-509062d829dso474381cf.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 05:50:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773233440; cv=none;
        d=google.com; s=arc-20240605;
        b=S930X+zwQd+c6gpK9vd5o0wk6hr7wXAWIxu16uMHKGDWhDkI75HlXEPBC/w5oZVX2p
         a7+2MdfUz85sM+B/a3OXKtd5b/yd+A0LIK41mHGXYORI1fcYYEMaBkqe7JhviaygGGfS
         ISpSiIYEmTO6EmRQu77z0L3opkN9V7P8Lmn7Eawt14HZ0kEMbT+eljA7Riq0TqN4j0iA
         Hml/im44qJNDKOIYeX7OL9ZiXZLSiGUJmv1ooVlhOHjBrcv/z3D/+PlfC6ghmR7UrFxC
         bRbJvjzLkywjrlIuXaUWv1W1h3+y1e/b8nT9/I7n0fpLAtuGg2UmpCM3nWphJycJi0pD
         1kTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=qxN2TuBJpKCWoW6nl/QePmQRR2LS3Y0rV9eV5GatiMo=;
        fh=Jxzwzg3laewSUvCA2a09gOOd6H1o1mMdzeS5XgaaAVk=;
        b=llObKMJ1+JaFRttVfzm0yVCtthsZ4OJwdFolN1PjMesVc8hWJiUOTi51QOk6YBlkng
         71hOwooIIO4JrXNOtD0ggzyNgjFRbA3Nrqt1zAT/WAN8cPy5tvDwya+vy9Rb7GxYxkCk
         f234PF4bUM5GmVOIezD45M0KPlEdrk7DHJv0WMIDvR7nEPPIG5IeIfKJJg+caQ9cVc04
         QgfPfuH6ZnZcR/KWKYiN0Br2Kp2GzbQilEKEKvCYCKyWj1fQ4BcANBUl45sCfIJvWM5G
         gRyFUSl74jwHnyC9rX7+MAOGmLTrESHxJ+SIcYc/ri8BBrIlaYyjnii7r5e9cqLREaVb
         qdlQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773233440; x=1773838240; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qxN2TuBJpKCWoW6nl/QePmQRR2LS3Y0rV9eV5GatiMo=;
        b=Sye7jGKaPvOhbm+HcFWDhWxQU+Lcsxa5JyjEcqPR3jtutFzhSkDpX0qK3eAVtoPYwQ
         IY9gTk6y848klGbiRaxldxdOF4+sUlYawZgol91BgbxyzVuRdMQHzH413vD0FEzduWPr
         4tmPHSHBM5qB+Vy3+OedURUdL8+EJVtCSBcLjhKmlyZg8V74QYyTA4ZdC4F2kC86Jeet
         GWnLcy1DHd3qVbiFCUUsV34HB71sIlhxTcH3DcG3gYl4HDkGAh5pT47gf/EIciPD7v7i
         2IW94t21H/2TRKP+gvUHExjp6aBlGR8RI3Tg7BetJBwj/ODJIab/NTS+UVP6Y4NcUB2W
         bjUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773233440; x=1773838240;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qxN2TuBJpKCWoW6nl/QePmQRR2LS3Y0rV9eV5GatiMo=;
        b=D7s/MltpcWREWz+jS/1QdoipimuO/W8YPs5ypvJY3H7Hu49KXoPx3ysZjLeb6EA2Hq
         FJyE3iLbjyMTqQlgz0hkkfeRWjPzYEHWfEhe/xz0BrucfOgIsCNF3mFn/cYuGu0GyI/f
         +CXWgPEtZw66x9geTquqX8ZPDN4nDfP8nyfCKYib6WGWN52N8ZoG5RI6jJpKlbHAUggt
         v94NjAUeV4mjF+Wpm4upJkUphjh5BJpzMGNzFTFcV9gvdsmQLv0G7OyCZiHpyV/TX2vx
         NgERTZ8jbVDpflLd5lkzOu3EGOVHskQfOXtZhRhsn4yWx7V9BIF2uLp+3WzZS3ZoCzRU
         tdUg==
X-Gm-Message-State: AOJu0YzKneSnxjv8+tAE1u4gsDFqZQaBLDZ3om3IP4AlTF3wkPptQlzJ
	T7sz10QW/8uyrxFftcERe2n5HYE/U0GT5xpd446LBrjFaB8Cfj6JTYG90R8gBEPJuTv00NsiDHm
	AmbfDwBlPS3tdkMp8pCkWZR3w7eUbSHnTg3BlpxAi
X-Gm-Gg: ATEYQzy/Gqb4rUin7rLP3qQCZuZTRRbL8drZIZk7iSkoXUWSSjI+yyuV5Xg0izRHPzn
	yZkKpMjFzQS7XDUFtkeZUScL3GsvLu72s8xmnsn+foPdTOvwP8MavEgUrhYyLMrdqVW3z0ukz+I
	L/SS5lDG5hfCjbaXPUhVa0XbJ4b+v+P32xqXjDB6+il88rIZPJ/V3OsN13epVaoVQxeIrGAXjer
	FeDxZBqwFOibdn6zHRcjJvYQROJrvuHF0Y0TSQYvcfpxulGtRpgVfNdk7R6U79DSe/wUHmmRVxV
	cB3tpfP/enNVsnFEEVyjCjT2+CwkpS92KmnRng==
X-Received: by 2002:a05:622a:1350:b0:508:fd42:fd05 with SMTP id
 d75a77b69052e-50939a71860mr10578861cf.15.1773233439313; Wed, 11 Mar 2026
 05:50:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260305144351.17071-1-will@kernel.org> <20260305144351.17071-8-will@kernel.org>
In-Reply-To: <20260305144351.17071-8-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Mar 2026 12:50:01 +0000
X-Gm-Features: AaiRm51sTqxrySh9KC3XT21S-_vQhCPKCeyE6B5vcg193qR82nHh14nvlAF10uY
Message-ID: <CA+EHjTxRNVTGM67RfwaVmPUkPmtqhyn5cA8jqKBrUgos9Sp65Q@mail.gmail.com>
Subject: Re: [PATCH v3 07/36] KVM: arm64: Ignore MMU notifier callbacks for
 protected VMs
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Mar 2026 at 14:44, Will Deacon <will@kernel.org> wrote:
>
> In preparation for supporting the donation of pinned pages to protected
> VMs, return early from the MMU notifiers when called for a protected VM,
> as the necessary hypercalls are exposed only for non-protected guests.
>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/mmu.c  |  9 ++++++---
>  arch/arm64/kvm/pkvm.c | 19 ++++++++++++++++++-
>  2 files changed, 24 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index ec2eee857208..43632c69adaf 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -340,6 +340,9 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>  void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
>                             u64 size, bool may_block)
>  {
> +       if (kvm_vm_is_protected(kvm_s2_mmu_to_kvm(mmu)))
> +               return;
> +
>         __unmap_stage2_range(mmu, start, size, may_block);
>  }
>
> @@ -2219,7 +2222,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>
>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
> -       if (!kvm->arch.mmu.pgt)
> +       if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
>                 return false;
>
>         __unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
> @@ -2234,7 +2237,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
>         u64 size = (range->end - range->start) << PAGE_SHIFT;
>
> -       if (!kvm->arch.mmu.pgt)
> +       if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
>                 return false;
>
>         return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
> @@ -2250,7 +2253,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
>         u64 size = (range->end - range->start) << PAGE_SHIFT;
>
> -       if (!kvm->arch.mmu.pgt)
> +       if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
>                 return false;
>
>         return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 42f6e50825ac..20d50abb3b94 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -407,7 +407,12 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>
>  int pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  {
> -       lockdep_assert_held_write(&kvm_s2_mmu_to_kvm(pgt->mmu)->mmu_lock);
> +       struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
> +
> +       if (WARN_ON(kvm_vm_is_protected(kvm)))
> +               return -EPERM;
> +
> +       lockdep_assert_held_write(&kvm->mmu_lock);
>
>         return __pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
>  }
> @@ -419,6 +424,9 @@ int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
>         struct pkvm_mapping *mapping;
>         int ret = 0;
>
> +       if (WARN_ON(kvm_vm_is_protected(kvm)))
> +               return -EPERM;
> +
>         lockdep_assert_held(&kvm->mmu_lock);
>         for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
>                 ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn,
> @@ -450,6 +458,9 @@ bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64
>         struct pkvm_mapping *mapping;
>         bool young = false;
>
> +       if (WARN_ON(kvm_vm_is_protected(kvm)))
> +               return -EPERM;
> +
>         lockdep_assert_held(&kvm->mmu_lock);
>         for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
>                 young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest, handle, mapping->gfn,
> @@ -461,12 +472,18 @@ bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64
>  int pkvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr, enum kvm_pgtable_prot prot,
>                                     enum kvm_pgtable_walk_flags flags)
>  {
> +       if (WARN_ON(kvm_vm_is_protected(kvm_s2_mmu_to_kvm(pgt->mmu))))
> +               return -EPERM;
> +
>         return kvm_call_hyp_nvhe(__pkvm_host_relax_perms_guest, addr >> PAGE_SHIFT, prot);
>  }
>
>  void pkvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
>                                  enum kvm_pgtable_walk_flags flags)
>  {
> +       if (WARN_ON(kvm_vm_is_protected(kvm_s2_mmu_to_kvm(pgt->mmu))))
> +               return;
> +
>         WARN_ON(kvm_call_hyp_nvhe(__pkvm_host_mkyoung_guest, addr >> PAGE_SHIFT));
>  }
>
> --
> 2.53.0.473.g4a7958ca14-goog
>

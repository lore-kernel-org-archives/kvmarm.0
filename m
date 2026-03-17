Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46A93F165E
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 16:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765979; cv=pass; b=oOtb6wg1VwQsE1kkmWqJaBdqN0hnxBJdvQQUbiy6Hw06hnGacXeNGzdZfajx7Hp9xdbmhr8xHhJprN+7qmXoxy8eYZrD1RQQjidRosF2ttsG8DD9xtjsfwYVBLIK+Cx8d3gEm7rjBAJg5dolzS1X6sb2id0RdYO2JvPaJEqjkEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765979; c=relaxed/simple;
	bh=D7cCHaAoFnJ3LI0E5aGRziK+Dr2DfDus7d20pcVxraE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JtQGHcljx8zSw8yRoBNEDtzgitCLPwsFFatW4JaQxPUVgvhtBzxv0gNfHa5dnEk3GQ4hbJJJmFvR5ctmvL9mH86/TL5Om9XCz56OoFCb5QomT79f+CQX8lqGRp50viU1rrnHD0i5ZFYHvvmHKCCI6X5exd6Mh/C7KZEjZZF5ATE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=txlS4WQT; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="txlS4WQT"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-509062d829dso657121cf.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 09:46:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773765973; cv=none;
        d=google.com; s=arc-20240605;
        b=U9twjRdOFARh3lDfdPFdFHhEo4KtVtFEEeEnOCewRYulPiO8ky9aM127WzxFL0HVnG
         MzUA2YmYxtr9m69jUU082PXaUeRAjqAgCpgy/l5GJDL9n9ZgkN7t4VCOOtYNVaJ4wbeQ
         TK7CY+GRGRPJZAGTLV6Gxu2gkhrIi3gqbZGTdRhVpNrFk0uiJ3Nob2Z0i0StzoZO661p
         N9d11Fx105uTBbNkRyhiT3+ks2kFAdOin7ALFuSRJdnJXgwi5BI8vANmazGew4DNtYMW
         2O0Dgb+CpNj0kAzP00ztD51tF8/C5tNUyFZBhfX0aBrKZeIFAKOdRG63TSnGF0HKmLlJ
         hKrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=56JhFUvPim0I8UWBjC9j9wiB/+QEOjM1sZN9Bz2BVWE=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=O2CqJxqdWOtdLerjkDgY6K0UhKEc9oTydQieEK8Yo9fiyInbZL48mc/8l18uLRz/ER
         yeTFuDS6y+H0zOqRFs9xL5j4oBSHp13vGUkcEetQBnbo1OeLOpkxJe/0fNMViayUPJxo
         7RiTYRPsoJAx78Z8JKvM8E5sYdUq/cDifBC/l1Ia4P5WSKHx5JpufOSHm14ryw6cXs8U
         Zkg0VE4wAVPrHKSsqP8Rxb8Dx6wlfNxIhQnnZLjhILWcXVz3QZjlrl00Ux/ud31uN35Z
         mSZAleGvJ804SDuW0nCLSlbjbvzr8aYGvN06uPauRSS/TVToZzDDoMpNjuO5Gy5i7eeG
         QGVA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773765973; x=1774370773; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=56JhFUvPim0I8UWBjC9j9wiB/+QEOjM1sZN9Bz2BVWE=;
        b=txlS4WQTyD1qjnI1mS4z/KnoQfab1aKxluhUDDr7KKhUCHEyvJogAnj6ew+aTE+6MM
         XZ8xW9j+/ZItthnnsVHmGhcVU3qjJQ4/JdvVV9BUn8zQh6tPsxGD7pL8UJy0kqf/u1IL
         532/DVh8s+mHoj4P9pi+tJmZ0nqgY5qLow5WUkz/UX7kVgEyBzzZPchk3vHyQUaTnR2B
         VDe+IqC7IlgJyPYm+yLxh06ULPFWfU9Kmyg5qkgHz5XT/2G8ua70iA5xitsPksUeX8Ll
         JfVv+yyrkqgjq/46+C7JZJass5cE1OBkrFd265rVt77Xgjrq+yStfehUG6faaKjrT90L
         XEeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773765973; x=1774370773;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=56JhFUvPim0I8UWBjC9j9wiB/+QEOjM1sZN9Bz2BVWE=;
        b=Sh4lZnj4QKrazzAtx2N5xip1zDdfvPiD6P1XEILIuMBKOYkyOdVL+4XdGnijOlLDC6
         cW/jtE5Ilui09gdHEYsnNHGrgjL5r6230X64ShWt5IjyzaVOC4/tGlXcTjrL7oOKUYGY
         LEkS9ShgMUIQIJRBGNt9U1M0gL+hSr+03gxfxKqR3nN1Mc1fQALSmysx1c4d9EKdil6e
         0rkV3zfI0fnQSa+ah3x6XQbt3kB4RSAF+uMxb1DQu5eel/NN4JHks9twyUmdYmG3SRTo
         g/7rEhUyWX74Db0CJQvTL55Q3sju9u8PxlAvPX7UxwuATWHFUZHKoXpGSGKcKnweDFg8
         O5zQ==
X-Gm-Message-State: AOJu0YwnLfu1NdCDMinDbBe7Zx+fLNtdEYQntwcEg9DQXUx3a5RUmreH
	Rk64bWfV8Aei0ACLxP/HsrhNkHG0CAtzdE2Gi80C54Eqf9fPaDsVL+/gThATfbLNourF9ndR39e
	4FQus9gPo9RkFbfZZ+cUF7gzr0qfKCZY4f72vAaxd
X-Gm-Gg: ATEYQzxzKM2UVhB6L5F5Pc/Vo1HQY0BnPBrUnOkbFRNyEuedFjJZoCBghE3g5x6W2xY
	KRCljxSOWIELeAEUGmp+pVYqqeWvk2xInO9nFu9pHlOBhvTK4tKAe7JZ2cHKdu2n0rrhpQkCh/h
	NBVeatiQMABXdXDVPoUul0RP2UIty6hBMf9L9BpG5fmpXb7xux3mqEdOw+MBmvkzYWekRSl9+zs
	5ZwYOohgA8RR8tQCOYfXTOwwISNT4WnXg6vClQUn5mfYoS6Gykt7nsyWBTnoVIoL86KcsI/1p2k
	djvXLAq12KjOPZQanBNwYMvkgRCLNT4Tda8H
X-Received: by 2002:ac8:5a50:0:b0:509:25d8:9991 with SMTP id
 d75a77b69052e-50998d8a826mr18135281cf.16.1773765971977; Tue, 17 Mar 2026
 09:46:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org> <20260316175451.1866175-17-maz@kernel.org>
In-Reply-To: <20260316175451.1866175-17-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 16:45:34 +0000
X-Gm-Features: AaiRm50QV38tMVTJx5jeQhSTqhe674956DZz173j0zE_uw_tZBeVRrZc57e2Bak
Message-ID: <CA+EHjTy4n+FWqsqHk3jJP5J5VfgaVMXvYCPnPATG7FynYzEg2A@mail.gmail.com>
Subject: Re: [PATCH 16/17] KVM: arm64: Simplify integration of adjust_nested_*_perms()
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Mar 2026 at 17:55, Marc Zyngier <maz@kernel.org> wrote:
>
> Instead of passing pointers to adjust_nested_*_perms(), allow
> them to return a new set of permissions.
>
> With some careful moving around so that the canonical permissions
> are computed before the nested ones are applied, we end-up with
> a bit less code, and something a bit more readable.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/mmu.c | 62 +++++++++++++++++++-------------------------
>  1 file changed, 27 insertions(+), 35 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9b5df70807875..18cf7e6ba786d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1544,32 +1544,34 @@ static int prepare_mmu_memcache(struct kvm_vcpu *vcpu, bool topup_memcache,
>   * TLB invalidation from the guest and used to limit the invalidation scope if a
>   * TTL hint or a range isn't provided.
>   */
> -static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
> -                                     enum kvm_pgtable_prot *prot,
> -                                     bool *writable)
> +static enum kvm_pgtable_prot adjust_nested_fault_perms(struct kvm_s2_trans *nested,
> +                                                      enum kvm_pgtable_prot prot)
>  {
> -       *writable &= kvm_s2_trans_writable(nested);
> +       if (!kvm_s2_trans_writable(nested))
> +               prot &= ~KVM_PGTABLE_PROT_W;
>         if (!kvm_s2_trans_readable(nested))
> -               *prot &= ~KVM_PGTABLE_PROT_R;
> +               prot &= ~KVM_PGTABLE_PROT_R;
>
> -       *prot |= kvm_encode_nested_level(nested);
> +       return prot | kvm_encode_nested_level(nested);
>  }
>
> -static void adjust_nested_exec_perms(struct kvm *kvm,
> -                                    struct kvm_s2_trans *nested,
> -                                    enum kvm_pgtable_prot *prot)
> +static enum kvm_pgtable_prot adjust_nested_exec_perms(struct kvm *kvm,
> +                                                     struct kvm_s2_trans *nested,
> +                                                     enum kvm_pgtable_prot prot)
>  {
>         if (!kvm_s2_trans_exec_el0(kvm, nested))
> -               *prot &= ~KVM_PGTABLE_PROT_UX;
> +               prot &= ~KVM_PGTABLE_PROT_UX;
>         if (!kvm_s2_trans_exec_el1(kvm, nested))
> -               *prot &= ~KVM_PGTABLE_PROT_PX;
> +               prot &= ~KVM_PGTABLE_PROT_PX;
> +
> +       return prot;
>  }
>
>  static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                       struct kvm_s2_trans *nested,
>                       struct kvm_memory_slot *memslot, bool is_perm)
>  {
> -       bool write_fault, exec_fault, writable;
> +       bool write_fault, exec_fault;
>         enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>         struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> @@ -1606,19 +1608,17 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                 return ret;
>         }
>
> -       writable = !(memslot->flags & KVM_MEM_READONLY);
> +       if (!(memslot->flags & KVM_MEM_READONLY))
> +               prot |= KVM_PGTABLE_PROT_W;
>
>         if (nested)
> -               adjust_nested_fault_perms(nested, &prot, &writable);
> -
> -       if (writable)
> -               prot |= KVM_PGTABLE_PROT_W;
> +               prot = adjust_nested_fault_perms(nested, prot);
>
>         if (exec_fault || cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
>                 prot |= KVM_PGTABLE_PROT_X;
>
>         if (nested)
> -               adjust_nested_exec_perms(kvm, nested, &prot);
> +               prot = adjust_nested_exec_perms(kvm, nested, prot);
>
>         kvm_fault_lock(kvm);
>         if (mmu_invalidate_retry(kvm, mmu_seq)) {
> @@ -1631,10 +1631,10 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                                                  memcache, flags);
>
>  out_unlock:
> -       kvm_release_faultin_page(kvm, page, !!ret, writable);
> +       kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
>         kvm_fault_unlock(kvm);
>
> -       if (writable && !ret)
> +       if ((prot & KVM_PGTABLE_PROT_W) && !ret)
>                 mark_page_dirty_in_slot(kvm, memslot, gfn);
>
>         return ret != -EAGAIN ? ret : 0;
> @@ -1856,16 +1856,6 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>                                      enum kvm_pgtable_prot *prot)
>  {
>         struct kvm *kvm = s2fd->vcpu->kvm;
> -       bool writable = s2vi->map_writable;
> -
> -       if (!s2vi->device && memslot_is_logging(s2fd->memslot) &&
> -           !kvm_is_write_fault(s2fd->vcpu)) {
> -               /*
> -                * Only actually map the page as writable if this was a write
> -                * fault.
> -                */
> -               writable = false;
> -       }
>
>         if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu) && s2vi->map_non_cacheable)
>                 return -ENOEXEC;
> @@ -1883,12 +1873,14 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>
>         *prot = KVM_PGTABLE_PROT_R;
>
> -       if (s2fd->nested)
> -               adjust_nested_fault_perms(s2fd->nested, prot, &writable);
> -
> -       if (writable)
> +       if (s2vi->map_writable && (s2vi->device ||
> +                                  !memslot_is_logging(s2fd->memslot) ||
> +                                  kvm_is_write_fault(s2fd->vcpu)))
>                 *prot |= KVM_PGTABLE_PROT_W;
>
> +       if (s2fd->nested)
> +               *prot = adjust_nested_fault_perms(s2fd->nested, *prot);
> +
>         if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu))
>                 *prot |= KVM_PGTABLE_PROT_X;
>
> @@ -1899,7 +1891,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>                 *prot |= KVM_PGTABLE_PROT_X;
>
>         if (s2fd->nested)
> -               adjust_nested_exec_perms(kvm, s2fd->nested, prot);
> +               *prot = adjust_nested_exec_perms(kvm, s2fd->nested, *prot);
>
>         if (!kvm_s2_fault_is_perm(s2fd) && !s2vi->map_non_cacheable && kvm_has_mte(kvm)) {
>                 /* Check the VMM hasn't introduced a new disallowed VMA */
> --
> 2.47.3
>
>

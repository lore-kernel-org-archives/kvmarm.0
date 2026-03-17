Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8796337CD53
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 17:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773770333; cv=pass; b=gk6PaeA7ELT/aWDpUVWvAtMh20v5UoI0q5OfTxMyRgmztzNookw43pFuL7wvlrdjwZa8F/hmQQl7tj42DZnmH4sAwEjV3BemkLFo0/jmGyK3nW2tLoId/TstZga2pv1VfhRhBwvU7N5dFvUHocF1YveejmN6142WfPkYRC6QPL0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773770333; c=relaxed/simple;
	bh=J4a/HpArJV8Qm264+2a9pItSuTx9l/4dvQp9Yx3NhMk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kw6SLXF7Zjhx8G4QhAQhaVV9UwypuDFu7W1uo4mxYAMhJJ1szyJ5zEuK1guLBe44eMH9TxEvgyIV7Z9eLkKWwgXuyK7wKp6h9k4c5HTx1XEjn7Y256Ffj6Yd/PGwNt0qTfZkmJs8Qn+APbzVJzsi/NAamjlfVD3FVCO+xClVA1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BFd1DcCe; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BFd1DcCe"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5091ed02c54so68241cf.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 10:58:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773770331; cv=none;
        d=google.com; s=arc-20240605;
        b=jAquZj3UdOVoYA4z47lRKhUsyyFaHctwcnNrZiTLBs6sCJzykF1fFDu2AysmmLvVaK
         jdNt8DzoyHq9fIdh9mv8dFPQdHcIObmVcfLWPxUN72D0XZiWgBWfZhnQcgIiELyGEgCx
         qK9q6wtLo1nDnGTnX1nxa+t2kE5BDHb19MDPqxEzPp3e3m1/GbeRqMFlFPhAkkfdgLPb
         R+i3kn+Cibw6ktHCQStCoLkZ3xUR6laJOr/Lv4poLIhPG10S9IzZipUB0g+9PJUDjjt7
         qxSoUbnjGTc6rpblbd5u99hxFp2tOjv4KORabqwHaUJmHlSbRtNln8SPT6XDezaSuQc+
         uA7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=7ZGIidB3+Lw1LqPi8seN9lXbzXkHYjqC3r50E+WnL6o=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=iLm3L4ilnKpZFAgC35zcWSwj+ZosHWPlOPZfhcNEUgdExrIlRSt+R2EMXlw6tMxQJN
         mMa+BGV1o0ego5L0PNX6WVOxqu0R4zjSzPK2obiMf6RjtuT4moI9mhB7JIdih740RaV8
         Pf8a62hEurzCMjPpSamT/yAhNQ+wTHCs3RSVhVnUxx5PPQu2IS9xG174vgiuEkZC0HGq
         uYRSsX2COyW1zD75m4uZRzs5CFqbzvWWkNNPugmXLwGqem6OYx6VJ4XJDyj/V4DfN/OG
         yjsU6viEyNCpKc4QDYHG+4FWOGAjjJOXg+7GkOKOtmSR7U3SZj7E0LZ8CZ0IYHn7kyv4
         hQdw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773770331; x=1774375131; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7ZGIidB3+Lw1LqPi8seN9lXbzXkHYjqC3r50E+WnL6o=;
        b=BFd1DcCeykDqTq8dMSLLa6LJ2h4ygjTizvNsNR7fmg32Z9sJOd8Ay4Cob0S0hG0Uz+
         TWdfnAmVARq8SxM8xNWyDPopt9EhIqCO3op5tlg+jA0kkAq+ScJeFQuvTcpX8+7ZKZSO
         W5SRs46nm0rIQSozETS3ctUOEFfX+GwavCKgQ97Lua4ehIwEQJqLvGUWF0cDUSK3THXp
         KYG67vM4ipsXoLb7h3zgYKy+MKkoCGPIfuoo769WVtprVmZOKN41XgGD1uja2WHQ5yw7
         kSU1RGIhapeGK9faA6Y9sbhQm5hChx6pp+mRQE+vQ7L5YSbcatVAnWPOvY7AOmYBzy/c
         YEog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773770331; x=1774375131;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ZGIidB3+Lw1LqPi8seN9lXbzXkHYjqC3r50E+WnL6o=;
        b=AYOxtgxEQwy4t7X0JxqLLWf5CKSa5RqBmFcXLqx5aMqfuRZUjLO0BHYPCeGy84TW6y
         DGvoBmfGlBVUGNvuw1/Df7hg4HkVWIvNNxTl2hD+z67e4QeKdNS1/K5DqM9cbRLfNl3U
         5stPwEymn0tXZslI+U4/xDaqu852K6AZGEhzcLun/Zw30kZqEqG3EKsUxN7DlfC1wZS+
         u4l9qaQGx7khAM5/AQ+42vyot6QAHJw5afC3pifT/Gc1hkmKiXD/X1HVxiry8XE3g7jl
         9a16QOv6Ry8yJnOQKAYJH2+TDI1ladhtpARHW1Cja7EKA2y0XgsbAuvRwN73hYtdicMB
         3R7A==
X-Gm-Message-State: AOJu0Ywikx2myEkIXA9woA627siAVpqSk9Vde5CFc+3e/RmMw0O/5Oqr
	+eNo4uD450VWRor5J39Zom/FmgKRc5TrY58O/pl8hS1nYkxaQBZrICI+rWRG5nD/Epoq7PHu37w
	a99/qHnOGkjrs8SBHuAYT5iHLg94WX0ZHUOhiS2of
X-Gm-Gg: ATEYQzwbt+VM5lOKf3N+QV0GTlNvd64zh+vGbrFDekn5yOdJZaL/IA5cfgKDLYQE3C2
	HF1Dymsg/OaNOGTfWeDrMNqeOyR120MJnvT+H6rLTm2nXC5L0/UHa2exhry5wjhCk5HK0U9t+HS
	IQOeXl0DygHRDzc0onbHQJYvUzZJwHqe6wd6+jw4BBYI4LwE0KgTPpQ0Uyxtt0klnFZILnOhKHy
	QDzSl8TJxoGjx+gduhGqQkK81Ly4z4e0Hrt5ojmm7/PqyDZXbsUO4O6M7iZylpvybTTFxp/Yf15
	k4ftoGuW
X-Received: by 2002:ac8:5a44:0:b0:509:25c5:42b4 with SMTP id
 d75a77b69052e-50b148ee552mr819161cf.13.1773770330682; Tue, 17 Mar 2026
 10:58:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org> <20260316175451.1866175-18-maz@kernel.org>
In-Reply-To: <20260316175451.1866175-18-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 17:58:13 +0000
X-Gm-Features: AaiRm50jbtPseSvl2K70b49jlHPLFzhgUyMQfCMq-WaA1eYcMyCloNR5cbTnnlY
Message-ID: <CA+EHjTxf5BF7LZ1VaKqpa5N+WaZ8ZFFWvxQLxzKeBgY-_E1cQQ@mail.gmail.com>
Subject: Re: [PATCH 17/17] KVM: arm64: Convert gmem_abort() to struct kvm_s2_fault_desc
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Mar 2026 at 17:55, Marc Zyngier <maz@kernel.org> wrote:
>
> Having fully converted user_mem_abort() to kvm_s2_fault_desc and
> co, convert gmem_abort() to it as well. The change is obviously
> much simpler.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/mmu.c | 57 +++++++++++++++++++++-----------------------
>  1 file changed, 27 insertions(+), 30 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 18cf7e6ba786d..e14b8b7287192 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1567,33 +1567,39 @@ static enum kvm_pgtable_prot adjust_nested_exec_perms(struct kvm *kvm,
>         return prot;
>  }
>
> -static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> -                     struct kvm_s2_trans *nested,
> -                     struct kvm_memory_slot *memslot, bool is_perm)
> +struct kvm_s2_fault_desc {
> +       struct kvm_vcpu         *vcpu;
> +       phys_addr_t             fault_ipa;
> +       struct kvm_s2_trans     *nested;
> +       struct kvm_memory_slot  *memslot;
> +       unsigned long           hva;
> +};
> +
> +static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>  {
>         bool write_fault, exec_fault;
>         enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> -       struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> +       struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
>         unsigned long mmu_seq;
>         struct page *page;
> -       struct kvm *kvm = vcpu->kvm;
> +       struct kvm *kvm = s2fd->vcpu->kvm;
>         void *memcache;
>         kvm_pfn_t pfn;
>         gfn_t gfn;
>         int ret;
>
> -       ret = prepare_mmu_memcache(vcpu, true, &memcache);
> +       ret = prepare_mmu_memcache(s2fd->vcpu, true, &memcache);
>         if (ret)
>                 return ret;
>
> -       if (nested)
> -               gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
> +       if (s2fd->nested)
> +               gfn = kvm_s2_trans_output(s2fd->nested) >> PAGE_SHIFT;
>         else
> -               gfn = fault_ipa >> PAGE_SHIFT;
> +               gfn = s2fd->fault_ipa >> PAGE_SHIFT;
>
> -       write_fault = kvm_is_write_fault(vcpu);
> -       exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> +       write_fault = kvm_is_write_fault(s2fd->vcpu);
> +       exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu);
>
>         VM_WARN_ON_ONCE(write_fault && exec_fault);
>
> @@ -1601,24 +1607,24 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         /* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
>         smp_rmb();
>
> -       ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
> +       ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, &page, NULL);
>         if (ret) {
> -               kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
> +               kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
>                                               write_fault, exec_fault, false);
>                 return ret;
>         }
>
> -       if (!(memslot->flags & KVM_MEM_READONLY))
> +       if (!(s2fd->memslot->flags & KVM_MEM_READONLY))
>                 prot |= KVM_PGTABLE_PROT_W;
>
> -       if (nested)
> -               prot = adjust_nested_fault_perms(nested, prot);
> +       if (s2fd->nested)
> +               prot = adjust_nested_fault_perms(s2fd->nested, prot);
>
>         if (exec_fault || cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
>                 prot |= KVM_PGTABLE_PROT_X;
>
> -       if (nested)
> -               prot = adjust_nested_exec_perms(kvm, nested, prot);
> +       if (s2fd->nested)
> +               prot = adjust_nested_exec_perms(kvm, s2fd->nested, prot);
>
>         kvm_fault_lock(kvm);
>         if (mmu_invalidate_retry(kvm, mmu_seq)) {
> @@ -1626,7 +1632,7 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                 goto out_unlock;
>         }
>
> -       ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, PAGE_SIZE,
> +       ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
>                                                  __pfn_to_phys(pfn), prot,
>                                                  memcache, flags);
>
> @@ -1635,19 +1641,11 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         kvm_fault_unlock(kvm);
>
>         if ((prot & KVM_PGTABLE_PROT_W) && !ret)
> -               mark_page_dirty_in_slot(kvm, memslot, gfn);
> +               mark_page_dirty_in_slot(kvm, s2fd->memslot, gfn);
>
>         return ret != -EAGAIN ? ret : 0;
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
>  struct kvm_s2_fault_vma_info {
>         unsigned long   mmu_seq;
>         long            vma_pagesize;
> @@ -2296,8 +2294,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>         };
>
>         if (kvm_slot_has_gmem(memslot))
> -               ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
> -                                esr_fsc_is_permission_fault(esr));
> +               ret = gmem_abort(&s2fd);
>         else
>                 ret = user_mem_abort(&s2fd);
>
> --
> 2.47.3
>

Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D49A3C8721
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 10:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773224618; cv=pass; b=W1lw+fuX//PM77uO8taquEzdyJcs8WBtXc/U/Puh00oW9bCiKt8FYK3kv4tga2RYmRBLhjuzyIb+P6Rl4Kh4tkCMkqoX0sclUqUb4UKAGpN/ZiZL/a2PM7BWuLP94YFJOEBqrxW0xp3VUtx2fzVwOBuxePA3uQ5VLS2bt3CjwBk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773224618; c=relaxed/simple;
	bh=VniXpK2aiKyWZVqxqzJ5X0KEnwOMGLPMtyB1HOVv4zw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PT/5gcdlNPp0ABez7hDP1WkoDdn7uuh0y2mBIDAVZHWXguybXbUIPZ+KQwh+PmFTkPakE3tBLVWZJPRhMyxsAVf4z/NyZd8i9xckmcyS8wcPI5+0fnUcnpL91egEvyK0k9yHp0XqxAb+mqT41NbJo5sEjsJxfiii1KSN0XLE0ns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4JdDKu29; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4JdDKu29"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5091ed02c54so404131cf.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 03:23:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773224616; cv=none;
        d=google.com; s=arc-20240605;
        b=F6rW+FW/6ftyIYpYNZ1l8HmoeffBVQADdtJi7ftH2p0TzulL8/VB/9elyLjEO22oSi
         9B72Za1OZ//kbj9X1bUkP6G9sogXEetIwGRIdrXEG7qvFxYiwP9SvvTQMz8o2ewmHzzs
         M9yiq9gRhRncBIoGhDKmvBXihYL/hAfkqyM0eLHmlnJYjRaCt0mMMQRpWKmCzE+/gVBD
         l4zuZxo6Xu9uM2o6MDjcVX/5Eu0BzZl20YF3Pg4tlVZF2AodXLgGd4trVhroxsINwiMt
         dR82oXKhLGzCZ4FW6jcnz2nxaYie81aUgJQCHcwzLdBBREwhLN70jzsxPiPiS6FaZjLF
         jwtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Znk/o3FTTjA1o6iiBb0OLOctvOKJgNWplDqjz3yVrX4=;
        fh=Jxzwzg3laewSUvCA2a09gOOd6H1o1mMdzeS5XgaaAVk=;
        b=jxVmYNpT4xplnF5exMJC7/5a8H+xaDDemasV0tyFj0htK07XVKnqJEs0gip/Eic7sq
         tzsliDnxwWA6JIsrgtFXlna+3vhbOZ+IJd+q+rQBwP2ZRXrsTkBrmYKT6ptZ3ItlrmfS
         2hLbnx126aPZDtL+kY3vky/hviZRN6AeTjRB9e2+Y0xfX/uQbTeuFy5VUKaki/SG9iuS
         M16MrIwH/TRM+aq/Z/HcQx82eOPVj/wfkpmGVwA2737rCHxzleBTFl4N5GRBBhzun7tG
         G/RYes/UgdRqz6HLsLWinAXrWT55tcPg6U0P1CKoxvF2KtVR1c1GI9TM+WTkPjbOUft5
         zG7A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773224616; x=1773829416; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Znk/o3FTTjA1o6iiBb0OLOctvOKJgNWplDqjz3yVrX4=;
        b=4JdDKu295di4sj+LSjYD2fFn5cbncK6SPHYakLH5PWZd3ve4ZLhCG/fxTfJWohSpVQ
         e6/5jxy6F7gKw0ixpIi+i12gQNusJjWemNyu6GHaHpsQcY/pcnKXuhoNGW+0CfjVGOLJ
         3ER0ek7u2J70zz4f23X4efyjZh3eSUdYqsUjY/03oil9O060TaVUIYERg0/BX7PlX+K0
         QvjK1axg1lzut8e4tSOI1mSeiJx2UJtFD/zTru/YxyDtBRaaEybvHzunRTPnlb86ClIB
         thvukWIbY/R7lTPKmScavxBm3VRaKo5G0H60xJoMZoCT+4TS9Vnud61y6MSxZRHvCm/S
         QL2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773224616; x=1773829416;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Znk/o3FTTjA1o6iiBb0OLOctvOKJgNWplDqjz3yVrX4=;
        b=ezs3FqkyYnqyKGnXwt8ehagqUyUwcKj8FMn12DJ+KTa1ehvy3qbDPFEaNqbWz/eteX
         1Nhk+y0UgwbOpjxPrOlqdxBLzJrQNN4fFs0t7Ge7bbvcqdN5/YdRLIEssfyPe9XE5lO7
         qLCSN3Jn0llWaLTf7n+bHkXm23Lym+fslPOm6WVIxDSmEfa5aaJYEBRcH4nxDxtnvg42
         +wG/EkwJCWY+41EpUTylSeqoh9JV9LuxBxb4NKuhxCTenV41DHeQuo/ia5Bovj7Fumvw
         K+fqWoT8ey9IUf2vOU6JoXmO8pv5OZHk89XkONyYSnApDH3LvKxWVH1eHJ9lB0cKONFa
         KHtA==
X-Gm-Message-State: AOJu0Yztn56XUSpz90i2QPmDzAmKNwsbLwhnW3tbeGf4M9NsuVEm4u04
	Io/eACkJH4BmtM1Jlxac0EtqeGtxu4kSWTmEmSgA4GPEqUM7wlOGXsls75/8AE5zSL4PDNO7iEd
	Ox+n7PZFYTAfOx8TG+bw4DTmJtbIQzrcrmIUX4Kz5
X-Gm-Gg: ATEYQzwHX6yRUpLOiG2+NPovODgtDpfyksN/P3GP5oqSGR+7OZbu9TeqqDt2g0d83OV
	nCuYd+vIZTwWyggmZB5wkMlDGwuXDf7P/mCGHhz2ILEnKKCJcuSk+pj83G5r8RHYvHxX4AJrfA2
	NTVrGTy+6zOKzLyMX1v6ADg5WCWNY1Dk+wwf4Mli+t6p/a49lyEGpxoCnR88pCJcjCqI/Saeo8t
	U0iGp0gtAYhkIPke3v1mll304KvAdiSKllpK6BZ+SjYkdgeOE2qoQ/O4C3tjTRxRNc6XAYy63wa
	jqEGznn4A8ucvK8gnyRCJ3INo19H+HbeqboDyg==
X-Received: by 2002:a05:622a:14cb:b0:509:1eca:6d24 with SMTP id
 d75a77b69052e-5093818c817mr10979211cf.2.1773224615864; Wed, 11 Mar 2026
 03:23:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260305144351.17071-1-will@kernel.org> <20260305144351.17071-14-will@kernel.org>
In-Reply-To: <20260305144351.17071-14-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Mar 2026 10:22:58 +0000
X-Gm-Features: AaiRm51nPsb7tNbmy2Jyecx_WTDjL9A5ByE7o_zgvxGOIXmo2XmEdSMXGPWCjcc
Message-ID: <CA+EHjTzCzgMRF7uirWtd7GjXqjTvUf8sootS5yzj2nfQxMZMVg@mail.gmail.com>
Subject: Re: [PATCH v3 13/36] KVM: arm64: Handle aborts from protected VMs
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
> Introduce a new abort handler for resolving stage-2 page faults from
> protected VMs by pinning and donating anonymous memory. This is
> considerably simpler than the infamous user_mem_abort() as we only have
> to deal with translation faults at the pte level.
>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
> ---
>  arch/arm64/kvm/mmu.c | 89 ++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 81 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9d183df0b0ac..4e64528d86a6 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1642,6 +1642,74 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         return ret != -EAGAIN ? ret : 0;
>  }
>
> +static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> +               struct kvm_memory_slot *memslot, unsigned long hva)
> +{
> +       unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
> +       struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> +       struct mm_struct *mm = current->mm;
> +       struct kvm *kvm = vcpu->kvm;
> +       void *hyp_memcache;
> +       struct page *page;
> +       int ret;
> +
> +       ret = prepare_mmu_memcache(vcpu, true, &hyp_memcache);
> +       if (ret)
> +               return -ENOMEM;
> +
> +       ret = account_locked_vm(mm, 1, true);
> +       if (ret)
> +               return ret;
> +
> +       mmap_read_lock(mm);
> +       ret = pin_user_pages(hva, 1, flags, &page);
> +       mmap_read_unlock(mm);
> +
> +       if (ret == -EHWPOISON) {
> +               kvm_send_hwpoison_signal(hva, PAGE_SHIFT);
> +               ret = 0;
> +               goto dec_account;
> +       } else if (ret != 1) {
> +               ret = -EFAULT;
> +               goto dec_account;
> +       } else if (!folio_test_swapbacked(page_folio(page))) {
> +               /*
> +                * We really can't deal with page-cache pages returned by GUP
> +                * because (a) we may trigger writeback of a page for which we
> +                * no longer have access and (b) page_mkclean() won't find the
> +                * stage-2 mapping in the rmap so we can get out-of-whack with
> +                * the filesystem when marking the page dirty during unpinning
> +                * (see cc5095747edf ("ext4: don't BUG if someone dirty pages
> +                * without asking ext4 first")).
> +                *
> +                * Ideally we'd just restrict ourselves to anonymous pages, but
> +                * we also want to allow memfd (i.e. shmem) pages, so check for
> +                * pages backed by swap in the knowledge that the GUP pin will
> +                * prevent try_to_unmap() from succeeding.
> +                */
> +               ret = -EIO;
> +               goto unpin;
> +       }
> +
> +       write_lock(&kvm->mmu_lock);
> +       ret = pkvm_pgtable_stage2_map(pgt, fault_ipa, PAGE_SIZE,
> +                                     page_to_phys(page), KVM_PGTABLE_PROT_RWX,
> +                                     hyp_memcache, 0);
> +       write_unlock(&kvm->mmu_lock);
> +       if (ret) {
> +               if (ret == -EAGAIN)
> +                       ret = 0;
> +               goto unpin;
> +       }
> +
> +       return 0;
> +unpin:
> +       unpin_user_pages(&page, 1);
> +dec_account:
> +       account_locked_vm(mm, 1, false);
> +       return ret;
> +}
> +
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                           struct kvm_s2_trans *nested,
>                           struct kvm_memory_slot *memslot, unsigned long hva,
> @@ -2201,15 +2269,20 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>                 goto out_unlock;
>         }
>
> -       VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
> -                       !write_fault && !kvm_vcpu_trap_is_exec_fault(vcpu));
> +       if (kvm_vm_is_protected(vcpu->kvm)) {
> +               ret = pkvm_mem_abort(vcpu, fault_ipa, memslot, hva);
> +       } else {
> +               VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
> +                               !write_fault &&
> +                               !kvm_vcpu_trap_is_exec_fault(vcpu));
>
> -       if (kvm_slot_has_gmem(memslot))
> -               ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
> -                                esr_fsc_is_permission_fault(esr));
> -       else
> -               ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> -                                    esr_fsc_is_permission_fault(esr));
> +               if (kvm_slot_has_gmem(memslot))
> +                       ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
> +                                        esr_fsc_is_permission_fault(esr));
> +               else
> +                       ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> +                                            esr_fsc_is_permission_fault(esr));
> +       }
>         if (ret == 0)
>                 ret = 1;
>  out:
> --
> 2.53.0.473.g4a7958ca14-goog
>

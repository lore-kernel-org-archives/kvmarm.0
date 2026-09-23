Received: from mta0.migadu.com (out-197.mta0.migadu.com [91.218.175.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2627B568FD9
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 19:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790192366; cv=none; b=EwNAEWunrtjU0YHzw4lReqrTQUzfbqrdqNszRuO6cjKk030//CuV9Gyyc9lsdiIs41R+r7vjKwvIt+0ODDJIU1K3HdK3gHCxRbCINc2MiRD9TU+AnzyYktpcKekY1LB3gITSFd1TaD+GuaAhXUEsk9SXqbwooQE3zUWkhw5MwOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790192366; c=relaxed/simple;
	bh=HcEVCm7J07mW25PyHEIzQI7mWJneYzDJXYLjvDY/cSg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A9svxN46JHDbCoK6fXV7dQY5q5GGdvI6EM+6uYDsL3R5NjXeTu7+2CrEhrYN7E01sa0nx96vn7JZKu4SweSAxbeYts+B9GfZIpzkbdT8ByEMoiTh8KEiBsI+hNZMqyFo8UGAyENMnelatCm2eebAFasLVGNGoAr6eB0CqAIt6FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kLe4uZ4j; arc=none smtp.client-ip=91.218.175.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kLe4uZ4j"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=HcEVCm7J07mW25PyHEIzQI7mWJneYzDJXYLjvDY/cSg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790192361; v=1; x=1790797161;
 b=kLe4uZ4jqVNk9u1DbxKhgrCdXEYGCcMpPMyZhtApnYXy5fqvdq/QFgkO9LmGBAL1usbXsa2e
 nBYAhVO91o7RbZAbAkNLX6Fxp6O125ak7KSfidc2TAPfIc6r4iqII6w6Ys7OCNsnvqn585zpIQY
 h6xfGKLqAQLdp6uhBOYGRXOo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 3d04c75052b241f0;
	Wed, 23 Sep 2026 19:39:21 +0000
X-Mizu-Trace-ID: 3d04c75052b241f0
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5b8c42da963so2320e87.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 12:39:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzO/XsOcYpE/JeXIYw6Gjo+YtL4Asxi6lYwkLfgZkZ5lC8AwKlQDSp6nMIW5hDR49vx44FZcco=@lists.linux.dev
X-Gm-Message-State: AFuF++nKI4/nxqdugb70A6tBXwPz132Lpi4fON5O+q8p0y++sEBnCn/7
	l8lf2mIl8cC7Omd3CY3gMqYHY9C9/bqj8GASc9x5EA1yPeL24tm1BF7Rv/YRccunr7+k0NrYqEb
	8qeQHcmEsQdM2HQr+7LvcR/DbqKE5nCybrzmN8AtS
X-Received: by 2002:a05:6512:b23:b0:5b4:9dba:7403 with SMTP id
 2adb3069b0e04-5b8de5db629mr43994e87.13.1790192355078; Wed, 23 Sep 2026
 12:39:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260922130821.1666713-1-vdonnefort@google.com> <20260922130821.1666713-4-vdonnefort@google.com>
In-Reply-To: <20260922130821.1666713-4-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 23 Sep 2026 20:38:38 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw6VJr9do3=S9yoHoAwFe7LQFUV1iTFqzzBZXcb12_0LA@mail.gmail.com>
X-Gm-Features: AclHuK-nljR5CfJ4sg1KRiiyGWOOUzMiszja47ySxMb79yFhQ355YotVV0O1BPY
Message-ID: <CA+EHjTw6VJr9do3=S9yoHoAwFe7LQFUV1iTFqzzBZXcb12_0LA@mail.gmail.com>
Subject: Re: [PATCH v1 3/6] KVM: arm64: Move pkvm_mem_abort()
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
> Move pkvm_mem_abort() below kvm_s2_fault_get_vma_info() so it can
> resolve stage-2 fault VMA metadata without forward declarations.
>
> No functional change intended.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/mmu.c | 138 +++++++++++++++++++++----------------------
>  1 file changed, 69 insertions(+), 69 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9dfaf4f277b5..242f63066252 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1706,75 +1706,6 @@ struct kvm_s2_fault_vma_info {
>         bool            map_non_cacheable;
>  };
>
> -static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
> -{
> -       unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
> -       struct kvm_vcpu *vcpu = s2fd->vcpu;
> -       struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> -       struct mm_struct *mm = current->mm;
> -       struct kvm *kvm = vcpu->kvm;
> -       void *hyp_memcache;
> -       struct page *page;
> -       int ret;
> -
> -       hyp_memcache = get_mmu_memcache(vcpu);
> -       ret = topup_mmu_memcache(vcpu, hyp_memcache);
> -       if (ret)
> -               return -ENOMEM;
> -
> -       ret = account_locked_vm(mm, 1, true);
> -       if (ret)
> -               return ret;
> -
> -       mmap_read_lock(mm);
> -       ret = pin_user_pages(s2fd->hva, 1, flags, &page);
> -       mmap_read_unlock(mm);
> -
> -       if (ret == -EHWPOISON) {
> -               kvm_send_hwpoison_signal(s2fd->hva, PAGE_SHIFT);
> -               ret = 0;
> -               goto dec_account;
> -       } else if (ret != 1) {
> -               ret = -EFAULT;
> -               goto dec_account;
> -       } else if (!folio_test_swapbacked(page_folio(page))) {
> -               /*
> -                * We really can't deal with page-cache pages returned by GUP
> -                * because (a) we may trigger writeback of a page for which we
> -                * no longer have access and (b) page_mkclean() won't find the
> -                * stage-2 mapping in the rmap so we can get out-of-whack with
> -                * the filesystem when marking the page dirty during unpinning
> -                * (see cc5095747edf ("ext4: don't BUG if someone dirty pages
> -                * without asking ext4 first")).
> -                *
> -                * Ideally we'd just restrict ourselves to anonymous pages, but
> -                * we also want to allow memfd (i.e. shmem) pages, so check for
> -                * pages backed by swap in the knowledge that the GUP pin will
> -                * prevent try_to_unmap() from succeeding.
> -                */
> -               ret = -EIO;
> -               goto unpin;
> -       }
> -
> -       write_lock(&kvm->mmu_lock);
> -       ret = pkvm_pgtable_stage2_map(pgt, s2fd->fault_ipa, PAGE_SIZE,
> -                                     page_to_phys(page), KVM_PGTABLE_PROT_RWX,
> -                                     hyp_memcache, 0);
> -       write_unlock(&kvm->mmu_lock);
> -       if (ret) {
> -               if (ret == -EAGAIN)
> -                       ret = 0;
> -               goto unpin;
> -       }
> -
> -       return 0;
> -unpin:
> -       unpin_user_pages(&page, 1);
> -dec_account:
> -       account_locked_vm(mm, 1, false);
> -       return ret;
> -}
> -
>  static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
>                                      struct kvm_s2_fault_vma_info *s2vi,
>                                      struct vm_area_struct *vma)
> @@ -2235,6 +2166,75 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
>         return 0;
>  }
>
> +static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
> +{
> +       unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
> +       struct kvm_vcpu *vcpu = s2fd->vcpu;
> +       struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> +       struct mm_struct *mm = current->mm;
> +       struct kvm *kvm = vcpu->kvm;
> +       void *hyp_memcache;
> +       struct page *page;
> +       int ret;
> +
> +       hyp_memcache = get_mmu_memcache(vcpu);
> +       ret = topup_mmu_memcache(vcpu, hyp_memcache);
> +       if (ret)
> +               return -ENOMEM;
> +
> +       ret = account_locked_vm(mm, 1, true);
> +       if (ret)
> +               return ret;
> +
> +       mmap_read_lock(mm);
> +       ret = pin_user_pages(s2fd->hva, 1, flags, &page);
> +       mmap_read_unlock(mm);
> +
> +       if (ret == -EHWPOISON) {
> +               kvm_send_hwpoison_signal(s2fd->hva, PAGE_SHIFT);
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
> +       ret = pkvm_pgtable_stage2_map(pgt, s2fd->fault_ipa, PAGE_SIZE,
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
>  /**
>   * kvm_handle_guest_abort - handles all 2nd stage aborts
>   * @vcpu:      the VCPU pointer
> --
> 2.55.0.1082.g2b9226bbc0-goog
>
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>

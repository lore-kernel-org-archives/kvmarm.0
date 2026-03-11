Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CBD3C9EF8
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 10:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773224709; cv=pass; b=DmiyawCj8xVYKfev6n4dZEWuoWTPrG0rGXqCflszkmvxGatQN9r8E13JVoKLhbsYrR498tgSGqwI3sTyVRR4Jgz0x1TiFC1kA+yqI5EXsB4rOE4nYJITCtB7gLMqrsXaC3Ex3/SwaGMIarNIXsGRRk7wo/ermPuPNwzWnuyXpeI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773224709; c=relaxed/simple;
	bh=CKTkOMIFtbddXQCTKzYVtHgeJeHxZRulbVviTlZ0tQo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fVDVQnM+iqLqOQGpgaHFYADsGw5Sem8S4MxDxe850qABMz5ZOku6zbdX/aSygvXffr28f47tGYiRpItMVzhztB7QKh5k7plYMD49IPa5a+SOUh33WczWwH/FDY2vjNjhX9L8VTmd5/4N4hCzPYrCDgD6pPop2DYyM5CAcrUHyC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lzfMr/VU; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lzfMr/VU"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50906a98ffeso521871cf.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 03:25:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773224707; cv=none;
        d=google.com; s=arc-20240605;
        b=URSGynqHECBkLWtHTg/+BxNgjmYwV+XkVlh7OKeLLcjtxsGaLXQP+XiGJ7gQQRT7A2
         7vFhPR0as9Qt3qcDxWdEt0TKlahda763y6qZBAKGBeDkdZpuhNmovErO2YmxICqmrzpx
         jzAgRBoW4Ym4yXXyCrp8YoAsr+S2GmaldiYzB9EOhKbRO1xGOfYujy6rBED65i46dGRl
         v04sNb+MMVVnl+jpaPf3fcf+xwyXqkHQue/Ujt9m35eObRI9GIY5VXd1QRmwg+nzgkI4
         gF7JcEUe64Ey58KnTBhELQZ1af7YJwiTC9FfU6DO7FaVsu46lGFEDowmBl0XDBRhXptV
         99HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bX+mY2WVrmnpJpn2taxiXuV/3B4F/EocZyWSHgahxE8=;
        fh=OsVEnhpHfDtKQejlv1Bgs/tZPAfr3IJ2Ck5WUUi92Sc=;
        b=ZVry5jAE22yWmkUX6AwAotgwGVeU2yFpWVFwDWhzwQyvAEbvzqtgd3+U17m3ODphXY
         6cQsHF3KITtJRyKtkHhNoYCHF47DBY62LT/fvT7o3L3nMh0sEiM4iaJacMAOzVqb4hja
         5N4dHEOi9cjOqFzxxTEY8ybqPtjNVexbyn/+CBfUmk3bIr7EOj1+EXTAcuIsKNcfG/B1
         49BC26hpoF17DgGh7aIFxoGHfd6wSuj7R9tImMowcuj7jlvmzW8T+UVBKGJh0qgUHZPg
         qoOxR6gFVsOUfFc7h87yop7QEWqPTCCUeAOa/LvYq/vgdQp8xumddeYEhz05BkNj7PNM
         zsKw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773224707; x=1773829507; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bX+mY2WVrmnpJpn2taxiXuV/3B4F/EocZyWSHgahxE8=;
        b=lzfMr/VUALRTydrJ+tdA5YRcGJzfAfkYJrTHyIk97frsR1foyDwHAaXDpnOw6FmEND
         eneN45Kc94vISpAqFVTMjAyZC7B3frM8TUCXffVvRSUpEu0yb3/WAwhx3Cf4FiR2QoHf
         neVruEm6j/NrvpV/H93u5uCAHrM1+FbQ65yabAkKbR613GJeRTarGM5PJJI+Mjw3ZzDS
         fTuOJSdCp/I2woyNYPNWczPnZUsx5yxNWqr27PXsWx/IzLtOdbnW/kGqoWRb5xu4i3O2
         GwEhqLGWtJaTwqnVaolOUguQUhDH3XxTWSUvVI3419mgDl28okMOXVjSoOyXdWFTYjp1
         Mziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773224707; x=1773829507;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bX+mY2WVrmnpJpn2taxiXuV/3B4F/EocZyWSHgahxE8=;
        b=EGVEGAOZq4TB5K3g9t7YDJd/lNRqJRuFsBu0LiD8Crlk9nXSytoxP+Z08NCB/HeSPq
         4bkGAEAHLJYQ7HYdkqNUR8ss9nkctYQuYNG8PwfmDOIcZviaAEKTrKEYoBiUWYr8iI9+
         85yRqDkPgfNY7d1UCZqvgC0B12oGQoJjHEQ38ugcoccwZEq3s7+C+E8eTDpY1a/m6maC
         JMDMvXdUOq2eHWI0WA8P7NNPIG5qDbhduQZB1VPS5Q1xVRRG49lek8Vb5Isiddri8nDN
         8Hsy2qJHLbuAChs0Gx5MYM/wPoeFYTmC9BHp3jNqmGi5x8ED5aj7K2y3e8OnGQq/jNYA
         PTgA==
X-Gm-Message-State: AOJu0YymDDPnOhdWbuqWzYxbe9XKI6/fSnrvniDicFp8SOrPvxKzl/AQ
	mmpSTK3XYMjbUq2ES/5+fBiZwHx1ufHA7qFyUin2yV2RayyRH1VRad/3B61ghBgKIcTDsxsD0VI
	6mjUUDM3AnbG4LdrwKOc2jkXGYBm9JbDzblNhQZQz
X-Gm-Gg: ATEYQzxxVZ2dXSXK9OX5sowisOH7f63saYkRzQTKVJxxFLUNqy/5orNxodjpfWU27EL
	d4e3QpuDk86MvNdLXbSqFCx8Q9HMhhFwLsui4Zi/H1xuTiuRwZAJKEGRTg04orowI4NQ6FhGcx1
	/SK8SHQVw2EXs/HSBXQvLpV2eEIPrP4/SmGIJHVEqQwsQNbfx3cieEcnVrzxENaFpPb9MrN83w1
	ZrAnRFmdJbklVAkpNb6byU63tDPkmJaDuVKecWM52V7pWyviLysY0zea7XUrxy5KcY/sYj7W7la
	KSN0dFxnQQFeso8om7PzQHig6L5UsIf6gzDtRA==
X-Received: by 2002:a05:622a:11d5:b0:509:174d:3224 with SMTP id
 d75a77b69052e-50939a12f0amr9025571cf.11.1773224706917; Wed, 11 Mar 2026
 03:25:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260119124629.2563-1-will@kernel.org> <20260119124629.2563-15-will@kernel.org>
In-Reply-To: <20260119124629.2563-15-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Mar 2026 10:24:30 +0000
X-Gm-Features: AaiRm53g6mmzRXB6NETrMopC8OxkyI8MPN0iN1tfTmOqJxXbfxGb6_DHFLuJIms
Message-ID: <CA+EHjTzst-FLQ=6Zn=ERDHpeKWd=3w3WeAhZ9PUEjqw5a1vPtA@mail.gmail.com>
Subject: Re: [PATCH v2 14/35] KVM: arm64: Handle aborts from protected VMs
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 19 Jan 2026 at 12:47, Will Deacon <will@kernel.org> wrote:
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
> index a23a4b7f108c..b21a5bf3d104 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1641,6 +1641,74 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
> @@ -2190,15 +2258,20 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
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
> 2.52.0.457.g6b5491de43-goog
>

Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F753E314D
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 13:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368899; cv=pass; b=bFUDggJssmkuAMsnCvOb1lEyajXMyJ6aMzvLwWJScM0ftyTfJfugp003TcN11BvSJXcXXRRSM73NJVU1vbly+WIcc6fdoncm7xoXsBy1RhvYLGJfTBW+LMWRa8tiNfP1CV6tPvX4waWDNIcN2q9qC05XRhFJevgRYS0Vk6ht3zk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368899; c=relaxed/simple;
	bh=0ZVuzQZZopICdGagT60nslEsYNgCXJd3sO0beIAcSL8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=crSkOR7LK/VJeWNygs92z8RRAm9212UjrI0qtnBpRD54zmGxow9STnnn2fJ+pyWFIch60Ir5x9nh1+ASKKYfO5gyQ1xWRo2Mnx9/vtIBQOXmkaXlB/CTP1TKWl68CfclV+gMJ8UNbTq0b8J51gwlHUzQ+K1e7+zgPtb1n0zlrFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IXcG9wtc; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IXcG9wtc"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-50e61648f10so25411cf.1
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 06:08:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779368897; cv=none;
        d=google.com; s=arc-20240605;
        b=YStxXuUgRyVKt0O7TPB0AR7PfQyLno2IrkCTr5wpDQ4svm/67RMl6TNt75y26Z74Pt
         Me/xnXdFceOU6zifc4Owfw2Cm1PjH0CVl0RVhjkeLJ5LS+Akl/reqHkEkwdHE+B1wNUH
         3RaKXPQUSFyQzoioONMdWCbICTi0csyUgBbo3rwEtR8SX7lCn6XXGu5jI3mU5aOJScGd
         4LlWj/Gc511bNjsCdSM3TxaqkBfm4S1D5UFj5Zb7seldAY/94+sM+oukpTQaiYlLCdgr
         XHqPJEekobe/dPSiV0tFN0KXZ17ApwSyYxhiPuwue/V0LspsQw2SXst1E5BR8XAjezDO
         lkgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=7qcoIhRMp2hHtmr4CvB3pe37gaux5p82rVkRQn7hzrE=;
        fh=p68w9XXOi995xF1QH8a4+dSkKE1M9U+S5g4M2Sjx2VU=;
        b=aL2b8ZP+mJD1bbG/qBBQDzAivVIb/RKatnCNqfOWTNimtANXNKHJ/fYHKu8oqJAH0a
         xdAv1MEsHorA128mM1rahMXee3OmO8hEblhxcncckmkIYUmj21VGi7QkV4srQSTIaXjl
         nWoDfD6c2nEyhkpyFEAbLFCVbcOmKfN3kyJLrqIlQUJfdERVHOb55U9gYwF1GmJnGDIL
         7qrR4JmHBeTLVZvkOeGVqUku6beoB3U8+e0O0FiXQUtjpwdEFVYvEhdRVxLbf0Md9j11
         SvfCSITS3FIs2GAApJNzMfgc9+3D5pDpOB6DvnRS6M+CksU/0DUxRcPNLBueG9VfxCIa
         nOJQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779368897; x=1779973697; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7qcoIhRMp2hHtmr4CvB3pe37gaux5p82rVkRQn7hzrE=;
        b=IXcG9wtcgy+twgy8ai7B3ggXALYeOYmfGUGTmVOE1wi0VEYmb+iOThmTmyBCTCjbni
         c8N5fdfgbJDIP95zHRlx2UW5Ll0eRLfMkNyD4tLmMVvZbMWF9Ascez4uikTf/2vu/6xq
         kinAsCGO5LMz0SDCCFDk4SohGe7imAp/dLWpD/XBLAyKyv+G24XAXi2+tsOwx9T/JiKA
         OrP3BC4J0vbI8F16VaO3kloWH68dcGTA1sZzHCWMJpgmki5JxA2UNTHY96Kku2BRWZmn
         DOlVoymp0rI+tisKvluPbud6t/G0SdQtEm6nBTZPO30eNlTIXhiBhNpLktdBYXONBiUf
         SmoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779368897; x=1779973697;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7qcoIhRMp2hHtmr4CvB3pe37gaux5p82rVkRQn7hzrE=;
        b=FsUZ24QWZArs7XQrI4OOCEv07zWNguweNk52xo0lng9I1JyFOrB1bnCZjkRdWHfefj
         CS8IEzRjGNv5j6j3JXkxKyyxyFwLMrRXNiOYIQqa3WrnN7IFQav6tIVoNaA2J/lY7dvN
         92w+rcte8FISyeiVzR/o47bmhqhXUEVvHmhbnouNLRXHMxw3UXKj64DeMC+nf3uvyH1X
         lgxCncADsaL3gxpAlxKOOsnhVna72WCzsBAg23pfHuRSmOFDZVZ6WjlDeP96szOzX7fR
         Sze2W2qBodC440FNw3NgLSsaRIs1hAd8ceMNvd11MduPpywhqqN9jz9o0dd8wbXMv2qe
         aaaQ==
X-Forwarded-Encrypted: i=1; AFNElJ8hRQYy4/v/UHvCGsI8py/u95JTuoVWuH8iMwIfPavqD5gEuzVRCHqXVwFIU4sELUY3hxIwalg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyqpTOglOwGGejFPHd9D489Gl5qPJOQ+EwPCMHk14vsWuPWRLx3
	Fcf/TLatQpbS2eXR12FixYrlFvleCCfV+gSC1S4c9nszeC7dkGE69nACcBTFVNgMB0Efkd69a2y
	HoEPA/0wVdLxEBNLX5bts2sM+94KvImsZXp39Rx3OKgY+EbfBy+Gi9Dz+
X-Gm-Gg: Acq92OE56IH6tZdBU8fJ4W3v4fJS5hdX9AtwFDO1/bHWyq0q7Ds8w9JrpUMuc7Srtlb
	wFqn5+3uSfLrANDKlTu5JiMxYSoF1/WhRkvwp1dFEG1Z5s8u8396HtsTih1XVUIJ1n2vU3ICVj1
	DgM4FHn7iW1R4Ku3qOwxtMvajLpLf5Sgn0uUupZIyj+dwFlwlEUoVZ/YtTVxJBU6qR6QqG/eJoD
	WI9b5pAduAfKPFBNYef86ZtYX+4NSVZIYMALMJmL/EcheYLuH5XGNa2wWzmfxpN/XJBEeeGPOV/
	352ZZqhIlPrRdLgstZE=
X-Received: by 2002:a05:622a:5147:b0:509:15b6:f6a0 with SMTP id
 d75a77b69052e-516c533a032mr9305501cf.6.1779368896993; Thu, 21 May 2026
 06:08:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260521102149.804874-1-vdonnefort@google.com> <20260521102149.804874-3-vdonnefort@google.com>
In-Reply-To: <20260521102149.804874-3-vdonnefort@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 May 2026 14:07:38 +0100
X-Gm-Features: AVHnY4IwdyJUF6N7KOmOm8J65aeDnjPa9uIN8Ouuh7oIvNZjx6QliKAb-K6hl-A
Message-ID: <CA+EHjTzq_Nvfwzyz6GOLkkLUaLijS6BoM9XOqMEwxtGguqqmHQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: Fix __pkvm_init_vm error path
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 21 May 2026 at 11:22, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> In the unlikely case where insert_vm_table_entry fails, __pkvm_init_vm
> release the memory donated by the host for the PGD, but as the stage-2
> is still set-up the hypervisor keeps a refcount on those pages,
> effectively leaking the references.
>
> Fix the rollback with the newly added kvm_guest_destroy_stage2().
>
> Fixes: 256b4668cd89 ("KVM: arm64: Introduce separate hypercalls for pKVM VM reservation and initialization")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 3cbfae0e3dda..4f2b871199cb 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -56,6 +56,7 @@ int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot p
>  int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id);
>  int kvm_host_prepare_stage2(void *pgt_pool_base);
>  int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd);
> +void kvm_guest_destroy_stage2(struct pkvm_hyp_vm *vm);
>  void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
>
>  int hyp_pin_shared_mem(void *from, void *to);
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 89eb20d4fee4..42b0b648f32f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -306,16 +306,21 @@ int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
>         return 0;
>  }
>
> +void kvm_guest_destroy_stage2(struct pkvm_hyp_vm *vm)
> +{
> +       guest_lock_component(vm);
> +       kvm_pgtable_stage2_destroy(&vm->pgt);
> +       vm->kvm.arch.mmu.pgd_phys = 0ULL;
> +       guest_unlock_component(vm);
> +}
> +
>  void reclaim_pgtable_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc)
>  {
>         struct hyp_page *page;
>         void *addr;
>
>         /* Dump all pgtable pages in the hyp_pool */
> -       guest_lock_component(vm);
> -       kvm_pgtable_stage2_destroy(&vm->pgt);
> -       vm->kvm.arch.mmu.pgd_phys = 0ULL;
> -       guest_unlock_component(vm);
> +       kvm_guest_destroy_stage2(vm);
>
>         /* Drain the hyp_pool into the memcache */
>         addr = hyp_alloc_pages(&vm->pool, 0);
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index eb1c10120f9f..3b2c4fbc34d8 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -853,10 +853,12 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
>         /* Must be called last since this publishes the VM. */
>         ret = insert_vm_table_entry(handle, hyp_vm);
>         if (ret)
> -               goto err_remove_mappings;
> +               goto err_destroy_stage2;
>
>         return 0;
>
> +err_destroy_stage2:
> +       kvm_guest_destroy_stage2(hyp_vm);
>  err_remove_mappings:
>         unmap_donated_memory(hyp_vm, vm_size);
>         unmap_donated_memory(pgd, pgd_size);
> --
> 2.54.0.746.g67dd491aae-goog
>

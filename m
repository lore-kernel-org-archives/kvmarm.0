Received: from mta0.migadu.com (out-140.mta0.migadu.com [91.218.175.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B10490BEE
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 17:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788285578; cv=none; b=mmpcdOMMkhZs8R/XNbdcXsyYi8K7GHJpH2qz/ABIkqUBB/NZcSSPaImOfs+gWm9VYUU5P+Nw2J5KnaDtcCFjgB4Y2od3MY7Mpq26OV5IFnF9si66cokNT+MB531mtigA3R2TBVT9nbs8Uy4vtTpdVmTZeuOTQG7DnIwpzkz+n1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788285578; c=relaxed/simple;
	bh=ghnI0dVMC0i09WYEQnlrUTKjsQ0zQIt9bBoCJHAIec4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZOqwLfUL+wHUox3LnVqa87V3XT1NL7aE8vuG24N7JNJrSnQCR5Ydg3rYYhhSbXmCCxD26DAFF4753v+Ii1tX20RJBjvY9066A9Qa3/YoNQQHHQHCDhKOzhkay/G+8EBVVQ75XdBPQIzU9U30UreBRmxUKup0PQUPjny+IDhVZ+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cH5KorLu; arc=none smtp.client-ip=91.218.175.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cH5KorLu"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ghnI0dVMC0i09WYEQnlrUTKjsQ0zQIt9bBoCJHAIec4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788285573; v=1; x=1788890373;
 b=cH5KorLuTa1bXLcyPJsy5jQYojkgmndZp65q5PIyz0tx6nJJr2t8jDOKSPUMRGhVkhVEOhfE
 QcLD5SZVnznbzuWJWK8Si/5M2W9/XoykKmRuSe/kdH8dm1dBuvLieOgtQWj/llrX9nKz4BYZUC4
 /fYT7yJIhq1xAMajXav9hBZY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9c2656a5b5262ebd;
	Tue, 01 Sep 2026 17:59:23 +0000
X-Mizu-Trace-ID: 9c2656a5b5262ebd
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5b2a8173142so539e87.1
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 10:59:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByCPA7d71ydxzV/bVj+lyUDnmiSfWW6rShpfJ6e2m6DcGRAsfdp4WzvP0nR2OrgZ9tfq7u7Qhw=@lists.linux.dev
X-Gm-Message-State: AFuF++nPswdc0+d94tWn7jPIXyShRI1di+q11mdZEBkRSRyRtsMscRQX
	fjUHc2x7xswg6luNhgijlDsaILATiYnt+DygNMutcDxySDH7rTp9krGBim82gckXuHOmTdnIoqW
	+pCdLEqWqnoV8hEj5rPUs9OZQWlD5jv3eNLd5dB5G
X-Received: by 2002:a05:6512:3baa:b0:5ae:cf5f:4a88 with SMTP id
 2adb3069b0e04-5b606b981f9mr11520e87.8.1788285561687; Tue, 01 Sep 2026
 10:59:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260901080941.997769-1-vdonnefort@google.com> <20260901080941.997769-16-vdonnefort@google.com>
In-Reply-To: <20260901080941.997769-16-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 1 Sep 2026 18:59:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx=dtrHxQ0npOo3aoaL0OtyXC8xcUuny6fVJzuQ1MXhXg@mail.gmail.com>
X-Gm-Features: AcwNN1WhPfiAtNZ-tbSiIqWiFtTbvqkjpgty2nafMUH-0LV6wNwKR0dVIOQ6iCE
Message-ID: <CA+EHjTx=dtrHxQ0npOo3aoaL0OtyXC8xcUuny6fVJzuQ1MXhXg@mail.gmail.com>
Subject: Re: [PATCH v5 15/18] KVM: arm64: Rename vCPU pkvm_memcache to stage2_mc
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 1 Sept 2026 at 09:10, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> With the introduction of the pKVM hyp allocator, the memcache for vCPUs
> is now only used for carrying pages dedicated to the stage-2 page tables.
> Rename pkvm_memcache to stage2_mc to reflect its purpose.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Cheers,
/fuad


>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index fe5364b507f9..7aaa139ac89b 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -939,7 +939,7 @@ struct kvm_vcpu_arch {
>         struct kvm_mmu_memory_cache mmu_page_cache;
>
>         /* Pages to top-up the pKVM/EL2 guest pool */
> -       struct kvm_hyp_memcache pkvm_memcache;
> +       struct kvm_hyp_memcache stage2_mc;
>
>         /* Virtual SError ESR to restore when HCR_EL2.VSE is set */
>         u64 vsesr_el2;
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 09ae5431ce58..fa77abf8cff6 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -591,7 +591,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>         if (!is_protected_kvm_enabled())
>                 kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
>         else
> -               free_hyp_memcache(&vcpu->arch.pkvm_memcache);
> +               free_hyp_memcache(&vcpu->arch.stage2_mc);
>         kvm_timer_vcpu_terminate(vcpu);
>         kvm_pmu_vcpu_destroy(vcpu);
>         kvm_vgic_vcpu_destroy(vcpu);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index bc54f477c147..fc3a624b0c4c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -407,9 +407,9 @@ static int pkvm_refill_memcache(struct pkvm_hyp_vcpu *hyp_vcpu)
>  {
>         struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
>
> -       return refill_memcache(&hyp_vcpu->vcpu.arch.pkvm_memcache,
> -                              host_vcpu->arch.pkvm_memcache.nr_pages,
> -                              &host_vcpu->arch.pkvm_memcache);
> +       return refill_memcache(&hyp_vcpu->vcpu.arch.stage2_mc,
> +                              host_vcpu->arch.stage2_mc.nr_pages,
> +                              &host_vcpu->arch.stage2_mc);
>  }
>
>  static void handle___pkvm_host_donate_guest(struct kvm_cpu_context *host_ctxt)
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 39aa8911f62c..dadd48431036 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -1023,7 +1023,7 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
>         ret = 0;
>         WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
>                                        pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_OWNED),
> -                                      &vcpu->vcpu.arch.pkvm_memcache, 0));
> +                                      &vcpu->vcpu.arch.stage2_mc, 0));
>         WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORROWED));
>  unlock:
>         guest_unlock_component(vm);
> @@ -1058,7 +1058,7 @@ int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
>                                                       PKVM_ID_GUEST, meta));
>         WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
>                                        pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_OWNED),
> -                                      &vcpu->vcpu.arch.pkvm_memcache, 0));
> +                                      &vcpu->vcpu.arch.stage2_mc, 0));
>  unlock:
>         guest_unlock_component(vm);
>         host_unlock_component();
> @@ -1422,7 +1422,7 @@ static int __guest_check_pgtable_memcache(struct pkvm_hyp_vcpu *vcpu)
>  {
>         struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
>
> -       if (vcpu->vcpu.arch.pkvm_memcache.nr_pages < kvm_mmu_cache_min_pages(vm->pgt.mmu))
> +       if (vcpu->vcpu.arch.stage2_mc.nr_pages < kvm_mmu_cache_min_pages(vm->pgt.mmu))
>                 return -ENOMEM;
>
>         return 0;
> @@ -1456,7 +1456,7 @@ int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
>                                                       PKVM_ID_GUEST, meta));
>         WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
>                                        pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_OWNED),
> -                                      &vcpu->vcpu.arch.pkvm_memcache, 0));
> +                                      &vcpu->vcpu.arch.stage2_mc, 0));
>
>  unlock:
>         guest_unlock_component(vm);
> @@ -1527,7 +1527,7 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu
>
>         WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, size, phys,
>                                        pkvm_mkstate(prot, PKVM_PAGE_SHARED_BORROWED),
> -                                      &vcpu->vcpu.arch.pkvm_memcache, 0));
> +                                      &vcpu->vcpu.arch.stage2_mc, 0));
>
>  unlock:
>         guest_unlock_component(vm);
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index ee2060aa1131..8a8b694ca00f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -760,7 +760,7 @@ struct pkvm_hyp_vcpu *init_selftest_vm(void *virt)
>                         continue;
>                 p[i].refcount = 1;
>                 if (seeded < min_pages) {
> -                       push_hyp_memcache(&selftest_vcpu.vcpu.arch.pkvm_memcache,
> +                       push_hyp_memcache(&selftest_vcpu.vcpu.arch.stage2_mc,
>                                           hyp_page_to_virt(&p[i]), hyp_virt_to_phys);
>                         seeded++;
>                 } else {
> @@ -1002,7 +1002,7 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
>                 if (!hyp_vcpu)
>                         continue;
>
> -               vcpu_mc = &hyp_vcpu->vcpu.arch.pkvm_memcache;
> +               vcpu_mc = &hyp_vcpu->vcpu.arch.stage2_mc;
>
>                 while (vcpu_mc->nr_pages) {
>                         void *addr = pop_hyp_memcache(vcpu_mc, hyp_phys_to_virt);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 3163502cc7d2..afde0894ab15 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1553,7 +1553,7 @@ static void *get_mmu_memcache(struct kvm_vcpu *vcpu)
>         if (!is_protected_kvm_enabled())
>                 return &vcpu->arch.mmu_page_cache;
>         else
> -               return &vcpu->arch.pkvm_memcache;
> +               return &vcpu->arch.stage2_mc;
>  }
>
>  static int topup_mmu_memcache(struct kvm_vcpu *vcpu, void *memcache)
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 36e677e51f7d..83e18c0e30b5 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -182,7 +182,7 @@ static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
>         pkvm_handle_t handle = vcpu->kvm->arch.pkvm.handle;
>         int ret;
>
> -       init_hyp_stage2_memcache(&vcpu->arch.pkvm_memcache);
> +       init_hyp_stage2_memcache(&vcpu->arch.stage2_mc);
>
>         ret = pkvm_call_hyp_req(__pkvm_init_vcpu, handle, vcpu);
>         if (!ret)
> --
> 2.55.0.897.gb25b4bd76c-goog
>

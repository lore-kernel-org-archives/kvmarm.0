Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9337723BCF7
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 04:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816835; cv=none; b=seixDVG9tE1FAzCoAL8bjirskazUmvJYBN8vUusVgesvHzuvjc3eXuueLkIxYVamG/f9gW5hXwr+tPb3LSNtfKOa+kNvMc04coB1oCU/tw9UNLvBtpleiep1dQ8fju0Dmk9/xfKWx4ZdWZFkcuBhGV6mp0XayVgSrmD8h2qh3mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816835; c=relaxed/simple;
	bh=NTcBDqSOqZyDofNkPrY+Dk7jMKpsJG+qzzXqSRDINI8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=loN7VZRewMR9dzGw/MkpbxavjxEzggLgRwKSE8PUoyr278r8ds6qQzXBO6fyrU2UrCtPLWmKRNlMR545/XuuJQPLBN+lVx7kbNSmj4zfWKopVdHaQ3F4BsVpeadldDzHpNfwTAuDMuDNXIsz5ljsX2blwSwW2HjjKRK3G+2GWs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=avLl6gr4; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="avLl6gr4"
X-Forwarded-Encrypted: i=1; AHgh+RrwuJGNqP+3EmyKtTNsM5QfYs127xsTvFCOjSeSaAMLTYvJpYOkbQ3bRvyKxs+Z5zjDSFBm5ok=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785782132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TverFBSwY7MtpYT35sNPQk4g4Kr+oiSA90dPP0U4w/M=;
	b=avLl6gr4kdIGIZ7QMMy4mQjlIlyYkOHB/w0dXR2adj4/ed0k7u71jVYj8mwhRD4CLV87TU
	bvPjeRYRnQd5SK31khXCfGi/S2XzUhZ+6lrQB+HjcRT58A3cvwxm5Ii+Ey+EmTxbonicFg
	732Wnj0MXtZLLmUCpwRFH/5vTH1cpX0=
X-Gm-Message-State: AOJu0YwsCcCNyVHmyo/uOo5CaCocsHxl9oFv2O+Jov9Pl5C4KhW3gV8Y
	TGv2KSMmp55rat7zA7kmbypgnqQZmEITLw0wCTI9MKeY4maJk3t/BRCKx3Ym0J2bXgm/zog0//Y
	jiDp4qXmg0O5LuANhc5tbpvBo2QFW7+uqYvcekbeF
X-Received: by 2002:a05:622a:5914:b0:517:5e32:2d14 with SMTP id
 d75a77b69052e-52cd4fbbf92mr1330831cf.10.1785782130203; Mon, 03 Aug 2026
 11:35:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260803124220.332248-1-fuad.tabba@linux.dev> <20260803124220.332248-11-fuad.tabba@linux.dev>
 <86qzkfaxp9.wl-maz@kernel.org>
In-Reply-To: <86qzkfaxp9.wl-maz@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 3 Aug 2026 19:34:52 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw1=xCPugZrmQ3nj1ddvCZ=vcZT3=KO_FMHB1USUTu7kA@mail.gmail.com>
X-Gm-Features: AUfX_mzt1I-nWoB71I22HAPLuIRo3_4lIfQ2cr-FZF11IecwevWTzcB4PKY0l4U
Message-ID: <CA+EHjTw1=xCPugZrmQ3nj1ddvCZ=vcZT3=KO_FMHB1USUTu7kA@mail.gmail.com>
Subject: Re: [PATCH v2 10/11] KVM: arm64: nVHE: Check hypercall handlers
 against the declared ABI
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, 
	rostedt@goodmis.org, mhiramat@kernel.org, alexandru.elisei@arm.com, 
	vdonnefort@google.com, joey.gouly@arm.com, seiden@linux.ibm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com, 
	ardb@kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 3 Aug 2026 at 19:03, Marc Zyngier <maz@kernel.org> wrote:
...
>
> I've also dropped this with the following hacks. The set_cpu_reg()
> stuff isn't brilliant, and requires a single word type. But I find the
> overall scheme less invasive.
>
> WDYT?

Works, and hyp-main.nvhe.o comes out byte identical. I did look for a
way to dispatch on void without the type table, but _Generic doesn't
take an incomplete type and __builtin_choose_expr type-checks both
arms on gcc and clang, so I don't think there's a better option.

One nit: the declaration in kvm_hcall.h still says "unsigned long"
while the definition now says "ulong". Could we make both ulong?

I'm happy to respin with both of these, or would you like to fold them in?

Cheers,
/fuad




>
>         M.
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index f8ea1661b3166..0d5fa6432461d 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -39,6 +39,12 @@ DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
>                 ,, cpu_reg(host_ctxt, 3),, cpu_reg(host_ctxt, 4)        \
>                 ,, cpu_reg(host_ctxt, 5),, cpu_reg(host_ctxt, 6))
>
> +#define set_cpu_reg_ulong(ctxt, r, v)  { cpu_reg(ctxt, r) = v; }
> +#define set_cpu_reg_u64(ctxt, r, v)    { cpu_reg(ctxt, r) = v; }
> +#define set_cpu_reg_int(ctxt, r, v)    { cpu_reg(ctxt, r) = v; }
> +#define set_cpu_reg_void(ctxt, r, v)   { v; }
> +#define set_cpu_reg(ctxt, r, t, v)     set_cpu_reg_##t(ctxt, r, v)
> +
>  #define DEFINE_KVM_HOST_HCALL(ret, name, ...)                          \
>         static kvm_host_hcall_sig_##name __do_##name;                   \
>         static __always_inline                                          \
> @@ -48,39 +54,18 @@ DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
>         }                                                               \
>         static void handle_##name(struct kvm_cpu_context *host_ctxt)    \
>         {                                                               \
> -               cpu_reg(host_ctxt, 1) = __se_##name(KVM_HOST_HCALL_REGS(__VA_ARGS__)); \
> +               set_cpu_reg(host_ctxt, 1, ret, __se_##name(KVM_HOST_HCALL_REGS(__VA_ARGS__))); \
>         }                                                               \
>         static ret __do_##name(__KVM_HCALL_MAP(__KVM_HCALL_DECL, __VA_ARGS__))
>
> -#define DEFINE_KVM_HOST_HCALL_VOID(name, ...)                          \
> -       static kvm_host_hcall_sig_##name __do_##name;                   \
> -       static __always_inline                                          \
> -       void __se_##name(__KVM_HCALL_MAP(__KVM_HCALL_LONG, __VA_ARGS__)) \
> -       {                                                               \
> -               __do_##name(__KVM_HCALL_MAP(__KVM_HCALL_CAST, __VA_ARGS__)); \
> -       }                                                               \
> -       static void handle_##name(struct kvm_cpu_context *host_ctxt)    \
> -       {                                                               \
> -               __se_##name(KVM_HOST_HCALL_REGS(__VA_ARGS__));          \
> -       }                                                               \
> -       static void __do_##name(__KVM_HCALL_MAP(__KVM_HCALL_DECL, __VA_ARGS__))
> -
>  #define DEFINE_KVM_HOST_HCALL0(ret, name)                              \
>         static kvm_host_hcall_sig_##name __do_##name;                   \
>         static void handle_##name(struct kvm_cpu_context *host_ctxt)    \
>         {                                                               \
> -               cpu_reg(host_ctxt, 1) = __do_##name();                  \
> +               set_cpu_reg(host_ctxt, 1, ret, __do_##name());          \
>         }                                                               \
>         static ret __do_##name(void)
>
> -#define DEFINE_KVM_HOST_HCALL0_VOID(name)                              \
> -       static kvm_host_hcall_sig_##name __do_##name;                   \
> -       static void handle_##name(struct kvm_cpu_context *host_ctxt)    \
> -       {                                                               \
> -               __do_##name();                                          \
> -       }                                                               \
> -       static void __do_##name(void)
> -
>  /* Number of implemented GICv3 LRs. Used by flush_hyp_vcpu(). */
>  unsigned int hyp_gicv3_nr_lr;
>
> @@ -242,7 +227,7 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
>                 host_cpu_if->vgic_lr[i] = hyp_cpu_if->vgic_lr[i];
>  }
>
> -DEFINE_KVM_HOST_HCALL_VOID(__pkvm_vcpu_load,
> +DEFINE_KVM_HOST_HCALL(void, __pkvm_vcpu_load,
>         pkvm_handle_t, handle, unsigned int, vcpu_idx, u64, hcr_el2)
>  {
>         struct pkvm_hyp_vcpu *hyp_vcpu;
> @@ -261,7 +246,7 @@ DEFINE_KVM_HOST_HCALL_VOID(__pkvm_vcpu_load,
>         }
>  }
>
> -DEFINE_KVM_HOST_HCALL0_VOID(__pkvm_vcpu_put)
> +DEFINE_KVM_HOST_HCALL0(void, __pkvm_vcpu_put)
>  {
>         struct pkvm_hyp_vcpu *hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
>
> @@ -421,42 +406,42 @@ DEFINE_KVM_HOST_HCALL(int, __pkvm_host_mkyoung_guest,
>         return __pkvm_host_mkyoung_guest(gfn, hyp_vcpu);
>  }
>
> -DEFINE_KVM_HOST_HCALL_VOID(__kvm_adjust_pc,
> +DEFINE_KVM_HOST_HCALL(void, __kvm_adjust_pc,
>         struct kvm_vcpu __kern *, vcpu)
>  {
>         __kvm_adjust_pc(kern_hyp_va_host(vcpu));
>  }
>
> -DEFINE_KVM_HOST_HCALL0_VOID(__kvm_flush_vm_context)
> +DEFINE_KVM_HOST_HCALL0(void, __kvm_flush_vm_context)
>  {
>         __kvm_flush_vm_context();
>  }
>
> -DEFINE_KVM_HOST_HCALL_VOID(__kvm_tlb_flush_vmid_ipa,
> +DEFINE_KVM_HOST_HCALL(void, __kvm_tlb_flush_vmid_ipa,
>         struct kvm_s2_mmu __kern *, mmu, phys_addr_t, ipa, int, level)
>  {
>         __kvm_tlb_flush_vmid_ipa(kern_hyp_va_host(mmu), ipa, level);
>  }
>
> -DEFINE_KVM_HOST_HCALL_VOID(__kvm_tlb_flush_vmid_ipa_nsh,
> +DEFINE_KVM_HOST_HCALL(void, __kvm_tlb_flush_vmid_ipa_nsh,
>         struct kvm_s2_mmu __kern *, mmu, phys_addr_t, ipa, int, level)
>  {
>         __kvm_tlb_flush_vmid_ipa_nsh(kern_hyp_va_host(mmu), ipa, level);
>  }
>
> -DEFINE_KVM_HOST_HCALL_VOID(__kvm_tlb_flush_vmid_range,
> +DEFINE_KVM_HOST_HCALL(void, __kvm_tlb_flush_vmid_range,
>         struct kvm_s2_mmu __kern *, mmu, phys_addr_t, start, unsigned long, pages)
>  {
>         __kvm_tlb_flush_vmid_range(kern_hyp_va_host(mmu), start, pages);
>  }
>
> -DEFINE_KVM_HOST_HCALL_VOID(__kvm_tlb_flush_vmid,
> +DEFINE_KVM_HOST_HCALL(void, __kvm_tlb_flush_vmid,
>         struct kvm_s2_mmu __kern *, mmu)
>  {
>         __kvm_tlb_flush_vmid(kern_hyp_va_host(mmu));
>  }
>
> -DEFINE_KVM_HOST_HCALL_VOID(__pkvm_tlb_flush_vmid,
> +DEFINE_KVM_HOST_HCALL(void, __pkvm_tlb_flush_vmid,
>         pkvm_handle_t, handle)
>  {
>         struct pkvm_hyp_vm *hyp_vm = get_np_pkvm_hyp_vm(handle);
> @@ -468,19 +453,19 @@ DEFINE_KVM_HOST_HCALL_VOID(__pkvm_tlb_flush_vmid,
>         put_pkvm_hyp_vm(hyp_vm);
>  }
>
> -DEFINE_KVM_HOST_HCALL_VOID(__kvm_flush_cpu_context,
> +DEFINE_KVM_HOST_HCALL(void, __kvm_flush_cpu_context,
>         struct kvm_s2_mmu __kern *, mmu)
>  {
>         __kvm_flush_cpu_context(kern_hyp_va_host(mmu));
>  }
>
> -DEFINE_KVM_HOST_HCALL_VOID(__kvm_timer_set_cntvoff,
> +DEFINE_KVM_HOST_HCALL(void, __kvm_timer_set_cntvoff,
>         u64, cntvoff)
>  {
>         __kvm_timer_set_cntvoff(cntvoff);
>  }
>
> -DEFINE_KVM_HOST_HCALL0_VOID(__kvm_enable_ssbs)
> +DEFINE_KVM_HOST_HCALL0(void, __kvm_enable_ssbs)
>  {
>         u64 tmp;
>
> @@ -494,18 +479,18 @@ DEFINE_KVM_HOST_HCALL0(u64, __vgic_v3_get_gic_config)
>         return __vgic_v3_get_gic_config();
>  }
>
> -DEFINE_KVM_HOST_HCALL0_VOID(__vgic_v3_init_lrs)
> +DEFINE_KVM_HOST_HCALL0(void, __vgic_v3_init_lrs)
>  {
>         __vgic_v3_init_lrs();
>  }
>
> -DEFINE_KVM_HOST_HCALL_VOID(__vgic_v3_save_aprs,
> +DEFINE_KVM_HOST_HCALL(void, __vgic_v3_save_aprs,
>         struct vgic_v3_cpu_if __kern *, cpu_if)
>  {
>         __vgic_v3_save_aprs(kern_hyp_va_host(cpu_if));
>  }
>
> -DEFINE_KVM_HOST_HCALL_VOID(__vgic_v3_restore_vmcr_aprs,
> +DEFINE_KVM_HOST_HCALL(void, __vgic_v3_restore_vmcr_aprs,
>         struct vgic_v3_cpu_if __kern *, cpu_if)
>  {
>         __vgic_v3_restore_vmcr_aprs(kern_hyp_va_host(cpu_if));
> @@ -541,7 +526,7 @@ DEFINE_KVM_HOST_HCALL(int, __pkvm_host_unshare_hyp,
>         return __pkvm_host_unshare_hyp(pfn);
>  }
>
> -DEFINE_KVM_HOST_HCALL(unsigned long, __pkvm_create_private_mapping,
> +DEFINE_KVM_HOST_HCALL(ulong, __pkvm_create_private_mapping,
>         phys_addr_t, phys, size_t, size, u64, prot)
>  {
>         /*
> @@ -554,7 +539,7 @@ DEFINE_KVM_HOST_HCALL(unsigned long, __pkvm_create_private_mapping,
>          * Instead pass the allocation address as the return value (or return
>          * ERR_PTR() on failure).
>          */
> -       unsigned long haddr;
> +       ulong haddr;
>         int err = __pkvm_create_private_mapping(phys, size, prot, &haddr);
>
>         if (err)
> @@ -573,7 +558,7 @@ DEFINE_KVM_HOST_HCALL0(int, __pkvm_reserve_vm)
>         return __pkvm_reserve_vm();
>  }
>
> -DEFINE_KVM_HOST_HCALL_VOID(__pkvm_unreserve_vm,
> +DEFINE_KVM_HOST_HCALL(void, __pkvm_unreserve_vm,
>         pkvm_handle_t, handle)
>  {
>         __pkvm_unreserve_vm(handle);
> @@ -630,7 +615,7 @@ DEFINE_KVM_HOST_HCALL(int, __tracing_load,
>         return __tracing_load(desc_hva, desc_size);
>  }
>
> -DEFINE_KVM_HOST_HCALL0_VOID(__tracing_unload)
> +DEFINE_KVM_HOST_HCALL0(void, __tracing_unload)
>  {
>         __tracing_unload();
>  }
> @@ -647,7 +632,7 @@ DEFINE_KVM_HOST_HCALL(int, __tracing_swap_reader,
>         return __tracing_swap_reader(cpu);
>  }
>
> -DEFINE_KVM_HOST_HCALL_VOID(__tracing_update_clock,
> +DEFINE_KVM_HOST_HCALL(void, __tracing_update_clock,
>         u32, mult, u32, shift, u64, epoch_ns, u64, epoch_cyc)
>  {
>         __tracing_update_clock(mult, shift, epoch_ns, epoch_cyc);
> @@ -665,19 +650,19 @@ DEFINE_KVM_HOST_HCALL(int, __tracing_enable_event,
>         return __tracing_enable_event(id, enable);
>  }
>
> -DEFINE_KVM_HOST_HCALL_VOID(__tracing_write_event,
> +DEFINE_KVM_HOST_HCALL(void, __tracing_write_event,
>         u64, id)
>  {
>         trace_selftest(id);
>  }
>
> -DEFINE_KVM_HOST_HCALL_VOID(__vgic_v5_save_apr,
> +DEFINE_KVM_HOST_HCALL(void, __vgic_v5_save_apr,
>         struct vgic_v5_cpu_if __kern *, cpu_if)
>  {
>         __vgic_v5_save_apr(kern_hyp_va_host(cpu_if));
>  }
>
> -DEFINE_KVM_HOST_HCALL_VOID(__vgic_v5_restore_vmcr_apr,
> +DEFINE_KVM_HOST_HCALL(void, __vgic_v5_restore_vmcr_apr,
>         struct vgic_v5_cpu_if __kern *, cpu_if)
>  {
>         __vgic_v5_restore_vmcr_apr(kern_hyp_va_host(cpu_if));
>
> --
> Without deviation from the norm, progress is not possible.

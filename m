Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAC1148314
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 08:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734425877; cv=none; b=q+RGD5zuif8k0QIhSME6U+PZqkwtcnbtP+KL/9ZF8L75S9wbw6NueigDi8c4ogc7bGuT98UGyVCg+iVWOhJevGeoQSaTGYiQSwy9X3qW20Dvyjk/WSn0gQ/afCbYCd3iW9Fp+M7IDta8zHiOB5SXWbSUyi5ZkGsJ4D2HQJp/Z6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734425877; c=relaxed/simple;
	bh=KSNgjhFPDqRZpu7/UdXMTYonkVgq2dG2a6Kv/xslTxE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ODwABH6kQtc7fGzSDqimd1CX1pyBOEbPJvfiyn+NyXDn8FaWawgPprsmWEVfDdgvtGNuIcycLTGyQ0mLukD6WMJpJntijXSvpLVcgmJ82HJDtYtlvkD6j5br3/GRAVVLa6Q2v4AnOWhKg71KYBoLI5q+trv18kJPMYq2hDlqo9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lCU3gWyO; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lCU3gWyO"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-435b0df5dbdso39705e9.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 00:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734425874; x=1735030674; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A9mGOwcKJkPD0/hT208rpyXS4+JWLUF2rILHUVjXzsc=;
        b=lCU3gWyOP+Ig40m5tC6GnUMPYqjjxpeRT773eK5x12uKEI4XIPN1rKuFueQ67fk8sf
         I9yIM2J/ZrKo0hiwfDbaaBSuKDA12QJgsXlOX94IW9qB9ShK1SJvbB244DsIHUl0jtGI
         3bXfxmwi6nGLRGqiWg0SC/p1bQ0BwkjG02xq3sLTatW/g7bj0xAg9PpYgLeLLS5i1sS1
         7AXlf2z3A9UZFBvCpxAkrGeI34wjpsJMu5RnLL/kIS3i1MGwUp80iKEmcbCS1/5IVc1n
         7m8N807wqvY9ZWi3mq16OkI8KywAKKkKlZ4AUoqffTMoiqizbxohSk2g2A+UXkurI/IA
         zsqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734425874; x=1735030674;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A9mGOwcKJkPD0/hT208rpyXS4+JWLUF2rILHUVjXzsc=;
        b=cRIodot/X38QUSavy+bV2ZF2oyS3u7+hhC3hvHsDBD6wrZSw0K48vQFLapI7hwrj+Z
         sS5uhtryN16Z1WjFcGutqxIvgcK1+4DiAJzhcqkEetz99zzTYgxBK+Ju3uauuOJVndA0
         wanOOVATyJWrZLnNEX/RYd/wlvk5eRF/gjqR6R/3kJocG/jbu4N5g0mwSjUVT0ZkZCqh
         /7WZ2gppw3D1HD3CS0kG37N/rVlLmZICfl28neXp0d8kqNti0n091cBA2U96rnHi2L8y
         FjQrYV0HJtWP2zHkEpH0Np4clVtFVrkVtDspi3NS6K9RZDtSY7yqh2NwBBJ+G4+6RSff
         3g6w==
X-Forwarded-Encrypted: i=1; AJvYcCWMsGL6h+uqlS5fWrYEdTu45REzHlQ2L2M17IhbLEZt2B2+5Sta2SFgxB4ZWxWNotkqXvwS4rc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6pCWsi3+tOUE2XnUXA813UFxffZcj7EeAgK4eQqfwIv7Pxmlj
	noQ7eTAgNUM5Ms2yoPZ3Y9XvnOIWWjdyM5sHCRG7hoFEHUqu/0NjOoabHobcJEw1HrwtY+ovPIh
	QT0r756n4q8dCaz7Y6y9Fw33SWOevGPqLJCL+
X-Gm-Gg: ASbGncvPfrBR6U1I3PgfDBJJV+jDUcPa3XYfb+7D1HJGDamKDC0LY6jQR6n2EO5aIWa
	xV2Y1o4cT7PESesQXsHLhbsw/hUBvEaxcrexQFoWLXBI/YTiFVDEYjDEf1LRYQ/57wJ4=
X-Google-Smtp-Source: AGHT+IEYjt67uUTelKuWfZAZMUFcRBjP36zX3A1L63lz75C+g/NuQwlwiqMKzdVpK/gkc3nId/dg69M2v0a1+rqPXqA=
X-Received: by 2002:a7b:cd88:0:b0:434:c967:e4b5 with SMTP id
 5b1f17b1804b1-4364ad490dbmr705545e9.1.1734425874443; Tue, 17 Dec 2024
 00:57:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com> <20241216175803.2716565-13-qperret@google.com>
In-Reply-To: <20241216175803.2716565-13-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Dec 2024 08:57:17 +0000
Message-ID: <CA+EHjTy-tzmmu0vNCkK_J614FG1QVO79WSfzV78hQRYqGhP7EQ@mail.gmail.com>
Subject: Re: [PATCH v3 12/18] KVM: arm64: Introduce __pkvm_host_relax_guest_perms()
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Dec 2024 at 17:58, Quentin Perret <qperret@google.com> wrote:
>
> Introduce a new hypercall allowing the host to relax the stage-2
> permissions of mappings in a non-protected guest page-table. It will be
> used later once we start allowing RO memslots and dirty logging.
>
> Signed-off-by: Quentin Perret <qperret@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/include/asm/kvm_asm.h              |  1 +
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 20 ++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 23 +++++++++++++++++++
>  4 files changed, 45 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 0b6c4d325134..66ee8542dcc9 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -67,6 +67,7 @@ enum __kvm_host_smccc_func {
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_host_relax_perms_guest,
>         __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
>         __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
>         __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index e528a42ed60e..a308dcd3b5b8 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -41,6 +41,7 @@ int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
>  int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
>  int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
>  int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
> +int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
>
>  bool addr_is_memory(phys_addr_t phys);
>  int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 3c3a27c985a2..287e4ee93ef2 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -264,6 +264,25 @@ static void handle___pkvm_host_unshare_guest(struct kvm_cpu_context *host_ctxt)
>         cpu_reg(host_ctxt, 1) =  ret;
>  }
>
> +static void handle___pkvm_host_relax_perms_guest(struct kvm_cpu_context *host_ctxt)
> +{
> +       DECLARE_REG(u64, gfn, host_ctxt, 1);
> +       DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 2);
> +       struct pkvm_hyp_vcpu *hyp_vcpu;
> +       int ret = -EINVAL;
> +
> +       if (!is_protected_kvm_enabled())
> +               goto out;
> +
> +       hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
> +       if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> +               goto out;
> +
> +       ret = __pkvm_host_relax_perms_guest(gfn, hyp_vcpu, prot);
> +out:
> +       cpu_reg(host_ctxt, 1) = ret;
> +}
> +
>  static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
>  {
>         DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
> @@ -475,6 +494,7 @@ static const hcall_t host_hcall[] = {
>         HANDLE_FUNC(__pkvm_host_unshare_hyp),
>         HANDLE_FUNC(__pkvm_host_share_guest),
>         HANDLE_FUNC(__pkvm_host_unshare_guest),
> +       HANDLE_FUNC(__pkvm_host_relax_perms_guest),
>         HANDLE_FUNC(__kvm_adjust_pc),
>         HANDLE_FUNC(__kvm_vcpu_run),
>         HANDLE_FUNC(__kvm_flush_vm_context),
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 30243b7922f1..aa8e0408aebb 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -1488,3 +1488,26 @@ int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *vm)
>
>         return ret;
>  }
> +
> +int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot)
> +{
> +       struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
> +       u64 ipa = hyp_pfn_to_phys(gfn);
> +       u64 phys;
> +       int ret;
> +
> +       if (prot & ~KVM_PGTABLE_PROT_RWX)
> +               return -EINVAL;
> +
> +       host_lock_component();
> +       guest_lock_component(vm);
> +
> +       ret = __check_host_shared_guest(vm, &phys, ipa);
> +       if (!ret)
> +               ret = kvm_pgtable_stage2_relax_perms(&vm->pgt, ipa, prot, 0);
> +
> +       guest_unlock_component(vm);
> +       host_unlock_component();
> +
> +       return ret;
> +}
> --
> 2.47.1.613.gc27f4b7a9f-goog
>

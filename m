Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09B223DE87
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 15:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733843683; cv=none; b=KV5vlvGJAtFQEMMdrfFR9oQOpZ2tb6rE33+q5+vYGG8XIt/nfFtw/+adgVbT26p4XcB0txmNgcxpeZzyRMnDqUcTdM/5nLe81/hBVqs1zV/vN8awzxYg7bx5B9bS9irKy1QgZb6IKxcIk6dv0AQ47OhzjjxcfPQHnVbAeZQ2/Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733843683; c=relaxed/simple;
	bh=7zo20DDr3e1Vl7Jg/vFQRSFliSYtKFd3w6KZiwM6lhA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jEOA9oN7nNJk7eYbbFKvHmBK4SMM5hbVmdBt7q/K1n/nYeyGQ0ftxTHbRG6zVCRUHGYgCFRfxNY8uetoAj7V2UCosMvA5EMWHw4jdT11EUempd3lszbOZTU1QWuICJYI5la9lnlpMi+diQ5itx5KJmh1YF7tMiTTUtRgSHP4/AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wd8QUNnB; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wd8QUNnB"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-434fa6bf6e4so43835e9.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 07:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733843680; x=1734448480; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aGp4xmxqvFNS4aKzzUdEFGSpZc9CuS65nIZ2CXfL9DI=;
        b=wd8QUNnB3C3LEhVnXb2+nlFPS6AfXvbQmZkR6iWHJElE/6IZRHYbOkJDhpCnIb9/Rq
         zumeqssxZiiSpnHchhh4OxEXNVBDVlixeAoti3xYV3qJbbrSK1Ryk1R4wOp7ZtG2Vv1d
         Z//qP24sXEfGtomOqlDWOygh06juXqae1qG48bpS6siJ7Fc39Q9jukgPHhQhAGE1KiJ3
         rUcxGgjEp2ujKu9d6Fi/KLdC7oOY/zrSAQ3sEODpQimSI36LADOXw4P3XQ32KV3xC7T4
         kbNpf6Uais7pLjrdJbcYTbch9gl2cr9pc1mu8NMbXJJUtIZKH0QU1XCL3mKNg/blwqeQ
         e/pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733843680; x=1734448480;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aGp4xmxqvFNS4aKzzUdEFGSpZc9CuS65nIZ2CXfL9DI=;
        b=TGkzTvuIZyxrJtihCuouRVwzlg6GvWCfehRha4daOrS43tX8vLGIRi30csI0/imqsW
         KT2M+c68/17CWeJSdssnDI04ViLZR8l6KaSJ9n27Rgi2r+ItRXLIcLsRw1SO0FtO8wet
         n//DRUHOZLBQcgCxLsTOyc5OZy2QAYm29FZiqfHAd5/dlHRJ743P0dzOPoGycQODNPj7
         VgGZ/q+RAOHQPiio+q+JhjpO5V5dk46Llyomu2pt7jmxWisyr7rZUFBTCCcAOfDEj3YT
         Kbj1XPxVXzUwFrWi4x69yVgmPnye8ydpK5yRlmXQQ8879+a1hTUb8ezvr70O3A/A94DG
         B5mg==
X-Forwarded-Encrypted: i=1; AJvYcCXevAH/OSJk3O5aJwq6Z0V5ZQO9xjVDo4hkPDDIRB6DKUMJg0v3X0CQKQB3+4Zbtjjr1iwj7Y8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzjMdE6hVwkTxMtfGfBctv0ZdbDWEoME6h4w87kBAId7lqf23yz
	Ljeee5A7IW4i+ScYF6UY5NBt/Eb5j2qhI1a2eC4IVKW14/PKuNUSOkiAu70b2mhYkRpWEhzcB9K
	yUzykca7Re3aBkDUtWM1uZJwQRnyzFNYPseOo
X-Gm-Gg: ASbGncsvWmzKUHB0a4vhsxMm/LwJHn35fbSuM/qqQ24CZ2HhGIJKJY8+u8fUg+uCMxk
	0ty0aDJaMObigtGTke/QMSmd28PtKInxhmb91ChnEAQOL0qTeXDki/gSF98ZFoRp2
X-Google-Smtp-Source: AGHT+IExtEJYbzPbhtvTj138hbJaUMAGq3rsSDYLbkcmP/S+jYpwTOuL2FE8QW/DEJ3y6pie8o3bjxV+CMjjg3V8Q7Q=
X-Received: by 2002:a05:600c:6b06:b0:434:9e1d:44ef with SMTP id
 5b1f17b1804b1-43539dd9773mr1230565e9.7.1733843680024; Tue, 10 Dec 2024
 07:14:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com> <20241203103735.2267589-16-qperret@google.com>
In-Reply-To: <20241203103735.2267589-16-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 Dec 2024 15:14:03 +0000
Message-ID: <CA+EHjTzOjwNyUkS5_zSUiAbiCauLKKgkKU6TM_-+Wsh9A0FdRQ@mail.gmail.com>
Subject: Re: [PATCH v2 15/18] KVM: arm64: Introduce __pkvm_host_mkyoung_guest()
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Quentin,

On Tue, 3 Dec 2024 at 10:38, Quentin Perret <qperret@google.com> wrote:
>
> Plumb the kvm_pgtable_stage2_mkyoung() callback into pKVM for
> non-protected guests. It will be called later from the fault handling
> path.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h              |  1 +
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 19 ++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 20 +++++++++++++++++++
>  4 files changed, 41 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index cb676017d591..6178e12a0dbc 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -70,6 +70,7 @@ enum __kvm_host_smccc_func {
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_relax_guest_perms,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_wrprotect_guest,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_test_clear_young_guest,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_host_mkyoung_guest,
>         __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
>         __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
>         __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 554ce31882e6..3ae0c3ecff48 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -44,6 +44,7 @@ int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
>  int __pkvm_host_relax_guest_perms(u64 gfn, enum kvm_pgtable_prot prot, struct pkvm_hyp_vcpu *vcpu);
>  int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
>  int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *vm);
> +int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu);
>
>  bool addr_is_memory(phys_addr_t phys);
>  int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 67cb6e284180..de0012a75827 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -333,6 +333,24 @@ static void handle___pkvm_host_test_clear_young_guest(struct kvm_cpu_context *ho
>         cpu_reg(host_ctxt, 1) = ret;
>  }
>
> +static void handle___pkvm_host_mkyoung_guest(struct kvm_cpu_context *host_ctxt)
> +{
> +       DECLARE_REG(u64, gfn, host_ctxt, 1);
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
> +       ret = __pkvm_host_mkyoung_guest(gfn, hyp_vcpu);
> +out:
> +       cpu_reg(host_ctxt, 1) =  ret;
> +}
> +
>  static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
>  {
>         DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
> @@ -547,6 +565,7 @@ static const hcall_t host_hcall[] = {
>         HANDLE_FUNC(__pkvm_host_relax_guest_perms),
>         HANDLE_FUNC(__pkvm_host_wrprotect_guest),
>         HANDLE_FUNC(__pkvm_host_test_clear_young_guest),
> +       HANDLE_FUNC(__pkvm_host_mkyoung_guest),
>         HANDLE_FUNC(__kvm_adjust_pc),
>         HANDLE_FUNC(__kvm_vcpu_run),
>         HANDLE_FUNC(__kvm_flush_vm_context),
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 0e064a7ed7c4..7605bd7f80b5 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -1541,3 +1541,23 @@ int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *
>
>         return ret;
>  }
> +
> +int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu)
> +{
> +       struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
> +       u64 ipa = hyp_pfn_to_phys(gfn);
> +       u64 phys;
> +       int ret;
> +
> +       host_lock_component();
> +       guest_lock_component(vm);
> +
> +       ret = __check_host_unshare_guest(vm, &phys, ipa);

While I'm bikeshedding some more, does the name
__check_host_unshare_guest() make sense? Should it be something like
__check_host_changeperm_guest(), or something along those lines? (feel
free to ignore this :) )

Thanks,
/fuad

> +       if (!ret)
> +               kvm_pgtable_stage2_mkyoung(&vm->pgt, ipa, 0);
> +
> +       guest_unlock_component(vm);
> +       host_unlock_component();
> +
> +       return ret;
> +}
> --
> 2.47.0.338.g60cca15819-goog
>

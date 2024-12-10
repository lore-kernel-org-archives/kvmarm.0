Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A12F1AA1E5
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 14:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733841712; cv=none; b=Uv62x4rku9VOd/QVV+J5f00GDHHPHcm/Sxabq7xN5Z/NDdBx1Nv0i9tLzfUGhsqixLimReOq2TM2cRiUT5oHJTSRZYmpeiPhwgQ/NUfbOvzOWxzq+uuUgLiPWlWWKI+1k5T4vaKn5Q2dYtiJ5a6TSPI2mziRCYlOcqPXLkOuAb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733841712; c=relaxed/simple;
	bh=AcrbO+SuNtKLVmDZhBaiYjMz2KfvE/P3okFUvZ7PtwA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JOEq0aQ2ewX1HVej2HdxAabXlfpz9Pod524jXyM+D0sWTnaHkATso4S1FXjLLDGL7tEqpbJ0zyVHRYeVqBTy5g2B8jQWhIaFEw97hJzQF7qrRBfjU3BZpCap8VMGKHoYTBljzGts/YUBbj3a6zHDEK4aXsC+K+q0JWCstF/lGkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=No+Jgpl5; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="No+Jgpl5"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-435b0df5dbdso38515e9.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 06:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733841709; x=1734446509; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5fIIWMp7qjjozw0r8pKMUPB5DziYW5td3dF2oKjVLsg=;
        b=No+Jgpl52cVShZ3Oxs9HnOFQqK9fl1Ucby0hO9GBls1B7L3L5rZxGh0cg1jEMtaexy
         Af5aZYPiqvPdAOWupxgvQryFsgMSE3GKzTuw631IqpBTwRBhbTFKUBcEGvSqxKt4kFxY
         92XKYo1tr+zUlpOlUYZ89XzAt3LVcQg4dqjBz5JQo+it7fmO9p8+s8xaiRilV4QJ81v7
         j0BydI+HmMMpRjQCgq/vj2cKcBpXV3/eRAz3K7sTGHxH7TOnJv6gnLztP7TvEDSpNh6R
         Dfpfi72TuSIuYUMkGD2DExlkbVnueYDyjHmAWuVziKdcLzlPDd1NM2trmIozPWQlycXq
         TZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733841709; x=1734446509;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5fIIWMp7qjjozw0r8pKMUPB5DziYW5td3dF2oKjVLsg=;
        b=EbaIat/fx71VSaR9cI8RraG9wgqHKIZhr7DkP5RAMxEAgcQ911h5swFMSOoGYnxtKw
         ESDUfc+d9NCKOrb0NW6Y5hfjzKM/MsuIcqiM43gK+rkrOU+7m+liOWn7lh2mFA4D3Cy8
         gQ2XWyZ8Uqf5LyT6I7ItTVVoNiVVm28mfGJgRwR/vFbmuS5DlWhAvsCd/kEf7af2TYhU
         5+kKAaOoFx5v/vYEDGdF7J/RVfKrjhHlImz3uET2JkSGcxosL+W6jMukc/qQInG2wXfo
         PwOWLZlrJOSJlkyXqBmlWv8CWInqDz+ymOGgWDNyldXCgeUo0j17v/bqr3nwznmtccAx
         VUfw==
X-Forwarded-Encrypted: i=1; AJvYcCVBweRKv//T0rFFX6OXe0Qs6LAZVdTwU/BpBKzL/J6AoP3rrA1Q7gdl8R/hP55eqn72Jx4MaKI=@lists.linux.dev
X-Gm-Message-State: AOJu0YynySYjclQGAJo2WbLlm1SnTgafu3llSS/q8Sm3oXI8kbWsV+De
	Sr32vstfCf7YgW9eU+QCfvItcMVxdgAE/ikbnQux9+k3pVKO3ZM7xHIZW//cKAlQRJItmVIKGgm
	6Fy2NTu7Zo2iuiAXw9JJ2nn8Ai26TVL165Twy
X-Gm-Gg: ASbGncsIjEvCcahsK/dVlKsGBMq0bLP9g5NkK/KMaRSvO2rDUC8PNkJo+g2eLGaCpvM
	Mizy5eJ8qHetqgPqRGlNX1DomqI0TVqipWQI0O5kK7JZ+DPBJyYeJ0/jRPQrD+GgL
X-Google-Smtp-Source: AGHT+IGt3oMRotBPgAwrwV/rrRSOvtwIdVWe57J7beeBt9bYDDljWajSERju3lMmJnq6Z9ZrG8XVFNSEZ9oxYokNtW0=
X-Received: by 2002:a05:600c:350b:b0:435:921b:3535 with SMTP id
 5b1f17b1804b1-435921b360amr969545e9.3.1733841708454; Tue, 10 Dec 2024
 06:41:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com> <20241203103735.2267589-12-qperret@google.com>
In-Reply-To: <20241203103735.2267589-12-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 Dec 2024 14:41:12 +0000
Message-ID: <CA+EHjTw48LTFt=sKtPwS1rmA=ma6Sj9O-D=17FXoMybqZ7+g5g@mail.gmail.com>
Subject: Re: [PATCH v2 11/18] KVM: arm64: Introduce __pkvm_host_unshare_guest()
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
> In preparation for letting the host unmap pages from non-protected
> guests, introduce a new hypercall implementing the host-unshare-guest
> transition.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h              |  1 +
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  5 ++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 24 +++++++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 67 +++++++++++++++++++
>  5 files changed, 98 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 449337f5b2a3..0b6c4d325134 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -66,6 +66,7 @@ enum __kvm_host_smccc_func {
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
>         __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
>         __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
>         __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index a7976e50f556..e528a42ed60e 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -40,6 +40,7 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
>  int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
>  int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
>  int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
> +int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);

The parameters of share_guest and unshare_guest are quite different. I
think that the unshare makes more sense, that it uses the hyp_vm as
opposed to the hyp_vcpu. Still, I think that one of the two should
change.

>  bool addr_is_memory(phys_addr_t phys);
>  int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> index be52c5b15e21..5dfc9ece9aa5 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> @@ -64,6 +64,11 @@ static inline bool pkvm_hyp_vcpu_is_protected(struct pkvm_hyp_vcpu *hyp_vcpu)
>         return vcpu_is_protected(&hyp_vcpu->vcpu);
>  }
>
> +static inline bool pkvm_hyp_vm_is_protected(struct pkvm_hyp_vm *hyp_vm)
> +{
> +       return kvm_vm_is_protected(&hyp_vm->kvm);
> +}
> +
>  void pkvm_hyp_vm_table_init(void *tbl);
>
>  int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index d659462fbf5d..04a9053ae1d5 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -244,6 +244,29 @@ static void handle___pkvm_host_share_guest(struct kvm_cpu_context *host_ctxt)
>         cpu_reg(host_ctxt, 1) =  ret;
>  }
>
> +static void handle___pkvm_host_unshare_guest(struct kvm_cpu_context *host_ctxt)
> +{
> +       DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
> +       DECLARE_REG(u64, gfn, host_ctxt, 2);
> +       struct pkvm_hyp_vm *hyp_vm;
> +       int ret = -EINVAL;
> +
> +       if (!is_protected_kvm_enabled())
> +               goto out;
> +
> +       hyp_vm = get_pkvm_hyp_vm(handle);
> +       if (!hyp_vm)
> +               goto out;
> +       if (pkvm_hyp_vm_is_protected(hyp_vm))
> +               goto put_hyp_vm;

bikeshedding: is -EINVAL the best return value, or might -EPERM be
better if the VM is protected?

> +
> +       ret = __pkvm_host_unshare_guest(gfn, hyp_vm);
> +put_hyp_vm:
> +       put_pkvm_hyp_vm(hyp_vm);
> +out:
> +       cpu_reg(host_ctxt, 1) =  ret;
> +}
> +
>  static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
>  {
>         DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
> @@ -454,6 +477,7 @@ static const hcall_t host_hcall[] = {
>         HANDLE_FUNC(__pkvm_host_share_hyp),
>         HANDLE_FUNC(__pkvm_host_unshare_hyp),
>         HANDLE_FUNC(__pkvm_host_share_guest),
> +       HANDLE_FUNC(__pkvm_host_unshare_guest),
>         HANDLE_FUNC(__kvm_adjust_pc),
>         HANDLE_FUNC(__kvm_vcpu_run),
>         HANDLE_FUNC(__kvm_flush_vm_context),
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index a69d7212b64c..aa27a3e42e5e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -1413,3 +1413,70 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu,
>
>         return ret;
>  }
> +
> +static int __check_host_unshare_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ipa)

nit: sometimes (in this and other patches) you use vm to refer to
pkvm_hyp_vm, and other times you use hyp_vm. Makes grepping/searching
a bit more tricky.

Cheers,
/fuad


> +{
> +       enum pkvm_page_state state;
> +       struct hyp_page *page;
> +       kvm_pte_t pte;
> +       u64 phys;
> +       s8 level;
> +       int ret;
> +
> +       ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
> +       if (ret)
> +               return ret;
> +       if (level != KVM_PGTABLE_LAST_LEVEL)
> +               return -E2BIG;
> +       if (!kvm_pte_valid(pte))
> +               return -ENOENT;
> +
> +       state = guest_get_page_state(pte, ipa);
> +       if (state != PKVM_PAGE_SHARED_BORROWED)
> +               return -EPERM;
> +
> +       phys = kvm_pte_to_phys(pte);
> +       ret = range_is_allowed_memory(phys, phys + PAGE_SIZE);
> +       if (WARN_ON(ret))
> +               return ret;
> +
> +       page = hyp_phys_to_page(phys);
> +       if (page->host_state != PKVM_PAGE_SHARED_OWNED)
> +               return -EPERM;
> +       if (WARN_ON(!page->host_share_guest_count))
> +               return -EINVAL;
> +
> +       *__phys = phys;
> +
> +       return 0;
> +}
> +
> +int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm)
> +{
> +       u64 ipa = hyp_pfn_to_phys(gfn);
> +       struct hyp_page *page;
> +       u64 phys;
> +       int ret;
> +
> +       host_lock_component();
> +       guest_lock_component(hyp_vm);
> +
> +       ret = __check_host_unshare_guest(hyp_vm, &phys, ipa);
> +       if (ret)
> +               goto unlock;
> +
> +       ret = kvm_pgtable_stage2_unmap(&hyp_vm->pgt, ipa, PAGE_SIZE);
> +       if (ret)
> +               goto unlock;
> +
> +       page = hyp_phys_to_page(phys);
> +       page->host_share_guest_count--;
> +       if (!page->host_share_guest_count)
> +               WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_OWNED));
> +
> +unlock:
> +       guest_unlock_component(hyp_vm);
> +       host_unlock_component();
> +
> +       return ret;
> +}
> --
> 2.47.0.338.g60cca15819-goog
>

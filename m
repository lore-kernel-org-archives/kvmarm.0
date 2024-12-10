Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897B523DE87
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 15:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733843553; cv=none; b=Nbp1IeNROD7I5guaLsOlG+vUVLw5V5sXxqf7Lum6miZ7W6A+268bFDY3WEHh4QKGivQ3zEalIMtiqt+a6rN6HAFsIOCuAq3lDTaFV8+KlGZOmmnTDsJvs1HOk7PjNEutqE5xG7P4NN3U5BKlWa9YngqJZgPYMy2ZGl6oybBm0WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733843553; c=relaxed/simple;
	bh=zNUIMA0r+arxv7Jhqh9dwlo/rMZuYJV4lXPbAwZ6K68=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l2ufIjlYSesswMYpNS7MuxQTNwzpPuENxK+v2tls6anXFW0jMLnGtm4Djj7kL1SLQAbsq69IWyDQAvYdWabdWJ4WsVV9EUcOSN6lqBiTuSWMsAKlvHAkF+yeXs+L2l5Vct1daP6KFhJ5v1USMb4z9BETILw8k5BkCWsp7CrQeQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xYsBQq7Q; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xYsBQq7Q"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-435b0df5dbdso40775e9.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 07:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733843550; x=1734448350; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PMyTiyNfmKdhDjVhUzsIJIaEqQor0TbKt2tHvDNxOCE=;
        b=xYsBQq7QEJYnopBiZacrr6kfaGmA7zeUQnpg4//k1c9n7+QXTRnGfFZksfWtQm4fqb
         zZzj/V+5+RMMdjL72OdfsI3bOXOajlVHbLBhI+SiyXoDy1hlBMNXHXOtwE4kPPiDMEp2
         +/nuAIlSagvMdxtKrRqhMS/HUsYg9fRwURjoL6gszLw8zlrKWJ5T/tqMRpbREKwcYow9
         l4JAAqkUpa7oGzQOLjFM9TyWVijTLAb0AdwALHBAt2513Qw/CAq70vHBqOq+n3AAoUkK
         IfmnK6wMQEcDuIm/M0zhaLAB8HVaF67agRWwK8inif9lZMAULtMKA2am2AbCWiEBOjMQ
         mIow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733843550; x=1734448350;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PMyTiyNfmKdhDjVhUzsIJIaEqQor0TbKt2tHvDNxOCE=;
        b=n8rGagVZXmPR/94iT//Hk0Yf3qJ2l7JU2vpoJu34FEwTlb0d0tr7ws9P1y1PFCjbpo
         xJC66uPENHjRukrS1HQQxIzN5MdRpHCnujIbZuwc+wK/hwpiGyPIGY6vZu5gMCDGCRCn
         k2Iwpwe5j00S6zZswwlGNq8GBzEjNbCwxs2a1hYoOe9oUsvfGKWwjVDsvEJ2oNrCWMXC
         I/3cV5S57/zByrgTxc3TT1gxOlte7SOtOj2wOuL939KAEnDwlQBBalxFXfUnSebARAyR
         g3geHHCCWmmw1G3XsKmygIQOKNcpWlJh+oIAeCY0TkNu1J2JJAIH3w00CTRo8xSyAQpW
         mx9w==
X-Forwarded-Encrypted: i=1; AJvYcCVgfC4I9Gjq8n+Kri8pXU2kjaRgW2rvIkEMJ3AzGhvt8vNji7RxOg17YKmNOpXNHvVp6j/Me9s=@lists.linux.dev
X-Gm-Message-State: AOJu0YxBf5Buh+BcmQR2ftMVTq+VR8QDbGKrPnbftUerLeeKtGGfp11g
	1hggJiI5EHng84YuHFjmNZgBMGf3nIqCFrVKnjOMKVypHY3ckah+hVPLAtMe7y9QlDvTg4UGEKw
	8Q0ChajUrRFRl/KWMPIGZBXfH+wwwegpmDnN4
X-Gm-Gg: ASbGncu7uFDBW9tBhoOL0f7HLlTutMdu2pIIoPTmxuAlXyiOzW4qBSypOiggPDQnv2r
	EaS2aY3tVqBM5+nDUsOIKuOrPgZzLCYytaboM9WQ+bG97M4aF4PG4Xsmzx23/VVdX
X-Google-Smtp-Source: AGHT+IFHeRD8jtlR7tKAgJUTx/0YJEujzi94LrDfE3Tbouy+VcFbttMaIzZI3qcxqGjKUaoNiPtT/88hZA1vV3f/nHA=
X-Received: by 2002:a05:600c:4907:b0:434:f7fc:1b18 with SMTP id
 5b1f17b1804b1-435028ac13amr1349455e9.4.1733843549772; Tue, 10 Dec 2024
 07:12:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com> <20241203103735.2267589-15-qperret@google.com>
In-Reply-To: <20241203103735.2267589-15-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 Dec 2024 15:11:53 +0000
Message-ID: <CA+EHjTwV2mXOXMF7u+pVaSqvJ2c-iPGMxPBhrj7oZrm+oaAi3A@mail.gmail.com>
Subject: Re: [PATCH v2 14/18] KVM: arm64: Introduce __pkvm_host_test_clear_young_guest()
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
> Plumb the kvm_stage2_test_clear_young() callback into pKVM for
> non-protected guest. It will be later be called from MMU notifiers.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h              |  1 +
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 25 +++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 19 ++++++++++++++
>  4 files changed, 46 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 4d7d20ea03df..cb676017d591 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -69,6 +69,7 @@ enum __kvm_host_smccc_func {
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_relax_guest_perms,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_wrprotect_guest,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_host_test_clear_young_guest,
>         __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
>         __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
>         __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 8658b5932473..554ce31882e6 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -43,6 +43,7 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum k
>  int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
>  int __pkvm_host_relax_guest_perms(u64 gfn, enum kvm_pgtable_prot prot, struct pkvm_hyp_vcpu *vcpu);
>  int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
> +int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *vm);

While I'm piling on the function names/parameters, some functions have
_guest as a postfix at the end (e.g., this one), others have it in the
middle (__pkvm_host_relax_guest_perms). I guess
__pkvm_host_relax_guest_perms is the odd one out. Could you rename it?

Cheers,
/fuad


>  bool addr_is_memory(phys_addr_t phys);
>  int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 3feaf2119e51..67cb6e284180 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -309,6 +309,30 @@ static void handle___pkvm_host_wrprotect_guest(struct kvm_cpu_context *host_ctxt
>         cpu_reg(host_ctxt, 1) = ret;
>  }
>
> +static void handle___pkvm_host_test_clear_young_guest(struct kvm_cpu_context *host_ctxt)
> +{
> +       DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
> +       DECLARE_REG(u64, gfn, host_ctxt, 2);
> +       DECLARE_REG(bool, mkold, host_ctxt, 3);
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
> +
> +       ret = __pkvm_host_test_clear_young_guest(gfn, mkold, hyp_vm);
> +put_hyp_vm:
> +       put_pkvm_hyp_vm(hyp_vm);
> +out:
> +       cpu_reg(host_ctxt, 1) = ret;
> +}
> +
>  static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
>  {
>         DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
> @@ -522,6 +546,7 @@ static const hcall_t host_hcall[] = {
>         HANDLE_FUNC(__pkvm_host_unshare_guest),
>         HANDLE_FUNC(__pkvm_host_relax_guest_perms),
>         HANDLE_FUNC(__pkvm_host_wrprotect_guest),
> +       HANDLE_FUNC(__pkvm_host_test_clear_young_guest),
>         HANDLE_FUNC(__kvm_adjust_pc),
>         HANDLE_FUNC(__kvm_vcpu_run),
>         HANDLE_FUNC(__kvm_flush_vm_context),
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 89312d7cde2a..0e064a7ed7c4 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -1522,3 +1522,22 @@ int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *vm)
>
>         return ret;
>  }
> +
> +int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *vm)
> +{
> +       u64 ipa = hyp_pfn_to_phys(gfn);
> +       u64 phys;
> +       int ret;
> +
> +       host_lock_component();
> +       guest_lock_component(vm);
> +
> +       ret = __check_host_unshare_guest(vm, &phys, ipa);
> +       if (!ret)
> +               ret = kvm_pgtable_stage2_test_clear_young(&vm->pgt, ipa, PAGE_SIZE, mkold);
> +
> +       guest_unlock_component(vm);
> +       host_unlock_component();
> +
> +       return ret;
> +}
> --
> 2.47.0.338.g60cca15819-goog
>

Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322DF1BC073
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 15:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733844223; cv=none; b=fwDy9pYiivGf74UedaV/nsrgW9Um3FdwjTP2UWAPArknfD1hYdLlYuKldouQb0DWgFXODsYBPAuCaz6HN+OKUzoMllsXRk+A2KHxPdFndnSj8r0+Eg/RH/citfCTpCXom/28Ag9ggGGcjlGQamoCi1SnMBO+Gr2a07X9lLGU4dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733844223; c=relaxed/simple;
	bh=Rmzl1NvQCsnYvdgeH7kzozFaaGGwMxy9wsWQ5HjV6V0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HoWGauxAIvrW2cwyyyT92r317J0cCMDxn34eAfTddwRg2RTHW3IgPKBb66rArwdhScg1YDGjMf0JUDRDBCsi8AIHfjFgk8HgQqdgniYBf+BEtnPE0jCC0sVR1wWuN6sPJRMVifpHGi1/dV0vfOQNam5FDtth9tTzqBiq1EDTDlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LHpMfTca; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LHpMfTca"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-434f150e9b5so45605e9.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 07:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733844219; x=1734449019; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0FGmDG/56UxrJQSDRbh5h6XtcOYvVsfsQlg9xr0FPYs=;
        b=LHpMfTcatgLmz2Fa7WwZIyuECUvPOghu5RiieDHIhxZDkbjNwZCkfVO+9LLPKR8GOY
         T/LvVlr9Gl7m+r2Ex///28092BsU/71RSenOTz8cHux7Z5nJfyyIkgEBPNPW9vdV/n0a
         ArrnTeVi7dcKZ1kDjvFNnJtebxQ3NB6KYasq2TO4vuhIZ8eI6VahOmGscbBLh2PycG22
         gsxCtLequkNzoprXnXTqkaVEtq0ZYjH+8jd3MlW8E2H7AgdZCtrL3bvaOnLD2tdHrgvT
         x/zgS8MZ7KqLbcwwuaDbThGXkBUu1Cdi6QZi/j8lfWqz1YuIZHk6OMKwHxuBVn9iLq9o
         iXGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733844219; x=1734449019;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0FGmDG/56UxrJQSDRbh5h6XtcOYvVsfsQlg9xr0FPYs=;
        b=ce3P6AFWSQFjAtuGXKRlceSGxJYCiIgLwBidfq9k9znaT1j2n+PhI9Ps7EWsfmbf2K
         rIVPfy1Lr7Tkf6fxjp+N5cZ3EXvA7RJs5Rgy4gT+C5aAH31jr0bFCVXE0DtLjIFjtXqU
         Jkwn21UqlJMKfTYxIY8n85x44dV62UxwG7hqi0cVGQgT9LXbtVlEZ91At2BtWWXSXkuz
         f1Dc1tXA+Ggn1HpvUXUjAjiUgZgohEdgRpoG3rAa5fXeMV/CEw0KOstWM9iOmnsmdQb7
         M1yjiYNzfFE24mO0I0VgjKom4K8loTdZUXB1LyQcbqjM1W1borXUA97bOp1IqxMJAj+w
         qKaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJzAJW1pqO0S9NaVy+KylCtjcJAVB3nelHoGQYgHwcCVuDN9m7pBqb+FYW7rPu8hqfW/L0ZjQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyDCyTQL4WfHbUiF6mP/zNIh7V7qbipQVuiQA3U3wawW8cjq6i3
	NxvCBDkF30f9p0kal7faK3rOJoS71RxNp5Br3wdoST3nPYRogqiDWN3n3jvyKAMHu55dbhCQgqc
	M51wxhEvgCKEZRoKDdSH/T6xGnh+eQGgLODfi
X-Gm-Gg: ASbGncs05DpB3Zif4WxOBomFMeVXRwVcoG2dl+5d3ruxwp6cBUeL1JYvOKJmn1CHqNK
	2LP5mEEiAq0l5TaNGdLIICHrq+4DpyluU5sLctcaYIbor2+UBe1oJ9iOkPMGZFmhO
X-Google-Smtp-Source: AGHT+IFj7W2A21RB271zIBxfODIG5QjupA4LpBwsV5eHpgstVb386fYaxm2Qzwdq67LZ1kRn3fUqgoJOaB0IFBrg8ho=
X-Received: by 2002:a05:600c:3b15:b0:42c:9e35:cde6 with SMTP id
 5b1f17b1804b1-435027477c0mr1476295e9.2.1733844219282; Tue, 10 Dec 2024
 07:23:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com> <20241203103735.2267589-17-qperret@google.com>
In-Reply-To: <20241203103735.2267589-17-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 Dec 2024 15:23:02 +0000
Message-ID: <CA+EHjTw_e_q5TFkgxvVDKxwj-C5S0Hd1OfVO4_FitrB8_J2Rpw@mail.gmail.com>
Subject: Re: [PATCH v2 16/18] KVM: arm64: Introduce __pkvm_tlb_flush_vmid()
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
> Introduce a new hypercall to flush the TLBs of non-protected guests. The
> host kernel will be responsible for issuing this hypercall after changing
> stage-2 permissions using the __pkvm_host_relax_guest_perms() or
> __pkvm_host_wrprotect_guest() paths. This is left under the host's
> responsibility for performance reasons.
>
> Note however that the TLB maintenance for all *unmap* operations still
> remains entirely under the hypervisor's responsibility for security
> reasons -- an unmapped page may be donated to another entity, so a stale
> TLB entry could be used to leak private data.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h   |  1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 17 +++++++++++++++++
>  2 files changed, 18 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 6178e12a0dbc..df6237d0459c 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -87,6 +87,7 @@ enum __kvm_host_smccc_func {
>         __KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
>         __KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
>         __KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
>  };
>
>  #define DECLARE_KVM_VHE_SYM(sym)       extern char sym[]
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index de0012a75827..219d7fb850ec 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -398,6 +398,22 @@ static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
>         __kvm_tlb_flush_vmid(kern_hyp_va(mmu));
>  }
>
> +static void handle___pkvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
> +{
> +       DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
> +       struct pkvm_hyp_vm *hyp_vm;
> +
> +       if (!is_protected_kvm_enabled())
> +               return;
> +
> +       hyp_vm = get_pkvm_hyp_vm(handle);
> +       if (!hyp_vm)
> +               return;
> +
> +       __kvm_tlb_flush_vmid(&hyp_vm->kvm.arch.mmu);
> +       put_pkvm_hyp_vm(hyp_vm);
> +}

Since this is practically the same as kvm_tlb_flush_vmid(), does it
make sense to modify that instead (handle___kvm_tlb_flush_vmid()) to
do the right thing depending on whether pkvm is enabled? Thinking as
well for the future in case we want to support the rest of the
kvm_tlb_flush_vmid_*().

Cheers,
/fuad

> +
>  static void handle___kvm_flush_cpu_context(struct kvm_cpu_context *host_ctxt)
>  {
>         DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> @@ -582,6 +598,7 @@ static const hcall_t host_hcall[] = {
>         HANDLE_FUNC(__pkvm_teardown_vm),
>         HANDLE_FUNC(__pkvm_vcpu_load),
>         HANDLE_FUNC(__pkvm_vcpu_put),
> +       HANDLE_FUNC(__pkvm_tlb_flush_vmid),
>  };
>
>  static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
> --
> 2.47.0.338.g60cca15819-goog
>

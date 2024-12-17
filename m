Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30B7148314
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 08:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734425840; cv=none; b=YXHg/OUawdmQC/pRkad/NcAPhz+LPr1trGpBLBf0sMxSt62dlH+yQs25mX9vE0xI8q6iX5T+UC2jwKpm6enfXT5d46wpClxm9NfjgDfr410gCwbWzQi1p10fKXrRU3UVF/Pse6y5Ng5LtHGcTVyS+zpuUzl84x6RDjelRxGCPS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734425840; c=relaxed/simple;
	bh=3zTH0kNwccqauNcOYiqmZapk3cM6L6wlTZmZU5/8f2o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kdfbKXTDo7bV9h/1UDo1uJwt1lmGIS0NNi9sMnQs8FUvicbabQuYUDxSpJWSAtsR3f+B9Jqw8dx2H7xDiOmJzhXoA6sg8Wa0PJDUyp+Uj2HI+NHin2JZmX/QZskEwbjKLtUHZ6k/DTt8IA/SclVyoAeRoS9kUJqpfbYijEhChPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s9YZVGgG; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s9YZVGgG"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4361d5730caso27615e9.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 00:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734425837; x=1735030637; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2tNKY/TlgAJZwECcpDjiOAux1C82BMpjuzg6Q/icr8Q=;
        b=s9YZVGgG+aI07Q9b/OaqTPRSWVqlSx+3WCgnwglPzVbgy3acq+uWuO2PReIdkqsOmJ
         PUrKhLn73rVy3L0dp94PTy800pawwSBVNIsWnzBEWDV9BNK9NjI8R5mTMwcSMqcd0eyB
         7y0ji3k21Z4Wh/YFNrTIe9y+UQNAejOdfiZRKfXdCstGMZCnGWDiNKg9/kQ2c78bWWZk
         mtucHFmzUdUZr6j1G5DPn7Xa4pzh4BlAR3cluwjm5Z+E7N3kooZkK7U5FOUdWmds2Eu0
         B7u34VoHxVGExnhepDmdUbyQ9myxC+ovikKdBUQb7Sa7JGK/TTvykjTAcrcSO9RLb9qf
         /YGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734425837; x=1735030637;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2tNKY/TlgAJZwECcpDjiOAux1C82BMpjuzg6Q/icr8Q=;
        b=Q7Mov0NTJJvGpC9S4DmATczdzfe258pVdC1NVMqI7HSF/QVy3Rgj0D7aaBY7fa5pVa
         QROTc2i7Kw/v4Hz2z1KP6+4GJAP1OUWQUtvVMnxAv53FCgGQ+GiUyw5nvEYuQHzLw27u
         LEpWq/X5Myr8AoWH4ePxAGnu8xnCkH8oI9aEc1cpb6cyVIZKc9uQR+QaWC86BAHDO6xH
         t9x7BYpZje8H8a1weF4AfA7Y4q+YVXJdJJaViDj5TqX9XnVCMR04Jhn8zZMUoGBhy+Bk
         bao8+xpe3bhY82c8SJ5TmmgC5FJIpbLWXZ4GirYHSITRdKa4hHErtk2pnnsak7aUbCPg
         1Uiw==
X-Forwarded-Encrypted: i=1; AJvYcCULtpAWcimKHma0dk3nKRqvGCloZf/jnGowW6YljM5a3Yh0UBGS5JOxFw+0AxdqwuOken3HOWE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwebB9Zq8r/c6j2fRS8QB/R0jl+6HIkjtkazlZIbIDLi5aNpZj9
	7QTrSCKv3Xu1RIJdz5Wn6aJGQCWUdGvMCVjYI6efxE/MKBXMp61xLZIwNR9/1EI7h/Mc07tLKyq
	R7QWmGB18qZ/4+hCwXO+V8cAubljvsfYGW/sr
X-Gm-Gg: ASbGncs5+OHGZDBRXre9l4lVRH4h5ra8Y2MLCxl6vHLd0BvRaIQMgDiIdqSTx/ulXJr
	wLkKlJkIwoosFvGRF/i1YFA7mBhGdxZj29lbz2HjIxjJBJYxBMR71rynnpRtIJ43VRVA=
X-Google-Smtp-Source: AGHT+IHJFBzVsqBQ7C3d6yTsi/odA0JGrwK8w33gD0CPcudIBQqs7CYLPRRKl7DNZ+C9Q8RUdpCE/xYn1+Tolw0ZG1g=
X-Received: by 2002:a05:600c:258:b0:434:a0fd:95d9 with SMTP id
 5b1f17b1804b1-4364ad50a2bmr719945e9.5.1734425837197; Tue, 17 Dec 2024
 00:57:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com> <20241216175803.2716565-14-qperret@google.com>
In-Reply-To: <20241216175803.2716565-14-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Dec 2024 08:56:40 +0000
Message-ID: <CA+EHjTzMOOkcX7GRtUZNDT5cbH5uXbu1ATgAhRq5DZV_Ev5=sw@mail.gmail.com>
Subject: Re: [PATCH v3 13/18] KVM: arm64: Introduce __pkvm_host_wrprotect_guest()
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
> Introduce a new hypercall to remove the write permission from a
> non-protected guest stage-2 mapping. This will be used for e.g. enabling
> dirty logging.
>
> Signed-off-by: Quentin Perret <qperret@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/include/asm/kvm_asm.h              |  1 +
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 21 +++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 19 +++++++++++++++++
>  4 files changed, 42 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 66ee8542dcc9..8663a588cf34 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -68,6 +68,7 @@ enum __kvm_host_smccc_func {
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_relax_perms_guest,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_host_wrprotect_guest,
>         __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
>         __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
>         __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index a308dcd3b5b8..fc9fdd5b0a52 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -42,6 +42,7 @@ int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
>  int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
>  int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
>  int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
> +int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
>
>  bool addr_is_memory(phys_addr_t phys);
>  int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 287e4ee93ef2..98d317735107 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -283,6 +283,26 @@ static void handle___pkvm_host_relax_perms_guest(struct kvm_cpu_context *host_ct
>         cpu_reg(host_ctxt, 1) = ret;
>  }
>
> +static void handle___pkvm_host_wrprotect_guest(struct kvm_cpu_context *host_ctxt)
> +{
> +       DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
> +       DECLARE_REG(u64, gfn, host_ctxt, 2);
> +       struct pkvm_hyp_vm *hyp_vm;
> +       int ret = -EINVAL;
> +
> +       if (!is_protected_kvm_enabled())
> +               goto out;
> +
> +       hyp_vm = get_np_pkvm_hyp_vm(handle);
> +       if (!hyp_vm)
> +               goto out;
> +
> +       ret = __pkvm_host_wrprotect_guest(gfn, hyp_vm);
> +       put_pkvm_hyp_vm(hyp_vm);
> +out:
> +       cpu_reg(host_ctxt, 1) = ret;
> +}
> +
>  static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
>  {
>         DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
> @@ -495,6 +515,7 @@ static const hcall_t host_hcall[] = {
>         HANDLE_FUNC(__pkvm_host_share_guest),
>         HANDLE_FUNC(__pkvm_host_unshare_guest),
>         HANDLE_FUNC(__pkvm_host_relax_perms_guest),
> +       HANDLE_FUNC(__pkvm_host_wrprotect_guest),
>         HANDLE_FUNC(__kvm_adjust_pc),
>         HANDLE_FUNC(__kvm_vcpu_run),
>         HANDLE_FUNC(__kvm_flush_vm_context),
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index aa8e0408aebb..94e4251b5077 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -1511,3 +1511,22 @@ int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_
>
>         return ret;
>  }
> +
> +int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *vm)
> +{
> +       u64 ipa = hyp_pfn_to_phys(gfn);
> +       u64 phys;
> +       int ret;
> +
> +       host_lock_component();
> +       guest_lock_component(vm);
> +
> +       ret = __check_host_shared_guest(vm, &phys, ipa);
> +       if (!ret)
> +               ret = kvm_pgtable_stage2_wrprotect(&vm->pgt, ipa, PAGE_SIZE);
> +
> +       guest_unlock_component(vm);
> +       host_unlock_component();
> +
> +       return ret;
> +}
> --
> 2.47.1.613.gc27f4b7a9f-goog
>

Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA2B19B5B4
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 08:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734425896; cv=none; b=XB1uv8o1Lmfbxuy4akruErQALw91r4xWbdWnJwNbFB9SgL+bmh1YeEEEGuBx4bONCUSYSXDvdq+dEGdq2NBzTn2aJR3FyBec5Gc1pi6//AYmOUo3dSUxrSUeiI+qRzh2BvLW/MUYg2ylCfCRyLQgZ60QGDexbdWjAXMIALsnxdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734425896; c=relaxed/simple;
	bh=5ei2u8waFHNXln0kfNmWVKqhewKVjoULHXhJF6AJVXM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tp5VxUU6MUF0WySFjS3byY/OpIlUN+SID7Zs/1ah4mi4kfGAMQ/xdm9oDzb2hfkRitfUFWCEy5C2GAg2AlWUDOMK6Wp4MbSZWQzXQpsmJbWKv3eFuLGlp8TjIgKbjMuKQrY7QB/MyLyQxwqL4Lkpz1fJLbPe2qb4hI2DmgOzox0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vrOJHEdc; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vrOJHEdc"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4361d5730caso27715e9.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 00:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734425893; x=1735030693; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zi9Cb0JXIv6qknzxniEvO9UIstkZaMDWbi894gneAi8=;
        b=vrOJHEdcBf60ZEQEvZcqMcvplwi+XM6kVl+Wk3zlXgrx/460NYwkR2iiyZhzj8kFbd
         FwMHxPz42BQBJ+izJ6zmpVmZZACTqcqYbuliGRnt76nTjESu+HbSU8swt2iLBiDfqpxw
         jfDdjZPISA3UGicCibYjG+BnLvDGsC8MpZ6Xz8LHVWB9azTmNI8alV1zV7PVz3XvWnx8
         hEGTlgG9BP/V2CzES6ruRk29/M/M7gvwgr+9ier2qQl+ECK/CmJ83a1UwacLCCoHTiYc
         z+OWyhiFu8daLJ8Qr6adDNLCgpXDti25ydjXaAggeSqYA7ldrhbEvNLv+TvefdFBYYbc
         NG4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734425893; x=1735030693;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zi9Cb0JXIv6qknzxniEvO9UIstkZaMDWbi894gneAi8=;
        b=GbUbhUPLxzdwQkNZTGxQT7PlHQRbVzxhzbjB1gp8VaPD+6ooUR8U1sFB1pWF57fM8e
         xHl+B5y92pxLYWUXQK3hBze5sTYiVaATGYKdW1xwUZ5OPCEJ2+t3QYqq2WICree9lOE4
         JvfxGCUNsGwfX9wmw7pgkfNBkhVpBhiFRw4wwYu1+9lNFEobmIcN2BjSFMj1Hk2xdoVO
         VPAd3QZxt/wqUZNNu813v7aeqfw7OEEiGmtQ+hZ5NtI5usqUNdKzmNS477wN3xTlkhmu
         VNy97LxMhEcPEhMchgBxng1vCTFHKcSeNap39v0ly0d10aBBUDCSZRHfhzvglxrupZI1
         dz9A==
X-Forwarded-Encrypted: i=1; AJvYcCVXOHOhCVs03GA1SY7aYIBdyaFaGUV03XxNIsLbuiiiDpyWPF59sLpXghuSubVBSyr7DcCFsk0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxXEwh6oYDJ0Q+dCZwoNEODl2GA67um44eyQsUe4526jKFfBALL
	CpSsJxiGgyL+AxWWE/TuJqFkkJw0bZIXsST1hBLSzMJaMnMAIGNSWE5mOpPtDKhQFB53pXkNSAa
	WZmvTyeOpMpNNPaWsWAw9FBJpnq1kn4i9MQLQPLQGmrOjIAk1kL5Q
X-Gm-Gg: ASbGncuzGuroQkIBK29TcjS9OUosDtHhxKP+gHtpw33vFrHfWBMSrO/Gx9iTOFtBc2I
	MQUoUNb/Y1cy+Wod+IUph3kqmJ+eXUMMAwechibqR/ySSgfXbv5pzjKy49yNRuE2H/+s=
X-Google-Smtp-Source: AGHT+IH6cdmhYpwRWiZB/ZV5vSi18IhtigKu9D+VojiJ+Wuao7fHQY46QuAyKXvWoaUnPqjxiHSCHKPg3eD4TVHISuM=
X-Received: by 2002:a7b:ce88:0:b0:436:186e:13a6 with SMTP id
 5b1f17b1804b1-436492cf51dmr1049705e9.6.1734425892536; Tue, 17 Dec 2024
 00:58:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com> <20241216175803.2716565-15-qperret@google.com>
In-Reply-To: <20241216175803.2716565-15-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Dec 2024 08:57:36 +0000
Message-ID: <CA+EHjTz0sC4idnRMLjVoOcbyZ3kTXM3+hkPHdo=V1XZ3aJ6BbQ@mail.gmail.com>
Subject: Re: [PATCH v3 14/18] KVM: arm64: Introduce __pkvm_host_test_clear_young_guest()
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
> Plumb the kvm_stage2_test_clear_young() callback into pKVM for
> non-protected guest. It will be later be called from MMU notifiers.
>
> Signed-off-by: Quentin Perret <qperret@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/include/asm/kvm_asm.h              |  1 +
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 22 +++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 19 ++++++++++++++++
>  4 files changed, 43 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 8663a588cf34..4f97155d6323 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -69,6 +69,7 @@ enum __kvm_host_smccc_func {
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_relax_perms_guest,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_wrprotect_guest,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_host_test_clear_young_guest,
>         __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
>         __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
>         __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index fc9fdd5b0a52..b3aaad150b3e 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -43,6 +43,7 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum k
>  int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
>  int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
>  int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
> +int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *vm);
>
>  bool addr_is_memory(phys_addr_t phys);
>  int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 98d317735107..616e172a9c48 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -303,6 +303,27 @@ static void handle___pkvm_host_wrprotect_guest(struct kvm_cpu_context *host_ctxt
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
> +       hyp_vm = get_np_pkvm_hyp_vm(handle);
> +       if (!hyp_vm)
> +               goto out;
> +
> +       ret = __pkvm_host_test_clear_young_guest(gfn, mkold, hyp_vm);
> +       put_pkvm_hyp_vm(hyp_vm);
> +out:
> +       cpu_reg(host_ctxt, 1) = ret;
> +}
> +
>  static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
>  {
>         DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
> @@ -516,6 +537,7 @@ static const hcall_t host_hcall[] = {
>         HANDLE_FUNC(__pkvm_host_unshare_guest),
>         HANDLE_FUNC(__pkvm_host_relax_perms_guest),
>         HANDLE_FUNC(__pkvm_host_wrprotect_guest),
> +       HANDLE_FUNC(__pkvm_host_test_clear_young_guest),
>         HANDLE_FUNC(__kvm_adjust_pc),
>         HANDLE_FUNC(__kvm_vcpu_run),
>         HANDLE_FUNC(__kvm_flush_vm_context),
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 94e4251b5077..0e42c3baaf4b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -1530,3 +1530,22 @@ int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *vm)
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
> +       ret = __check_host_shared_guest(vm, &phys, ipa);
> +       if (!ret)
> +               ret = kvm_pgtable_stage2_test_clear_young(&vm->pgt, ipa, PAGE_SIZE, mkold);
> +
> +       guest_unlock_component(vm);
> +       host_unlock_component();
> +
> +       return ret;
> +}
> --
> 2.47.1.613.gc27f4b7a9f-goog
>

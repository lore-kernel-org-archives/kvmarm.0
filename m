Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4303F1DC04A
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 09:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734426098; cv=none; b=KVWHuA74cRoloSZ+GuEp3hrVKx0ye8yEHMkGDZkU3ci4uF4MPHg4Ipk+vCTG9nnkA+aywzlWbCyXF75nylpOd5fNgIH5Wqw08XxOAVgrckhwIXW6J/bddk/yKKTA6s77PIGyNRjzEzXDgtWlUWlOxOAT9AOBZqMehIXJI55AzrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734426098; c=relaxed/simple;
	bh=ZTkuH4/9gDLlJyFVKfPGevHfOfBFDw5yEJuU0XqdH9w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DeKGRpfwQ54WLH9SKxUn62apQ3OBxm3aqgKdpVIkkIJBhGR+IcdyC1KWski+5yzHFQBAx8HAtvAB/9zHaG4lR1POIS4gNzrZQM4feb8IQgVW/v7D6Snyji5Rby/1/8UzvZEko9a3kqcNsb50jYaosxRbmaAnfI6V/osmLuhnxcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pe57uFDt; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pe57uFDt"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43622893c3cso27605e9.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 01:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734426095; x=1735030895; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Bpai75X11LMfvePNjrqzhIaWJn/QBSdWg0KnRrx/c7Y=;
        b=Pe57uFDtGviKFV3XODwNmDF4fM1K0bLxvua/Wp4uzP3vS4kJrWPWEGa73HeEV8lAmO
         sE0A7rO1EaZ915K0jud3Tk55GQynquS1uiji3qwpJmSJUTv02zb+Zn8H0WtOvgdG4Neb
         qvq8Qc5qulA/73xOic+YbCQKpktmx5LjZ6jVXV5GdXlk4jRv1ZO8P+BDpE6E7oB/bkh6
         /eU+Vo4FCyZKQHyeHBz/jxa4MdJyWtcO3qMF6BasNj6KZoJ+CeSrVOhLLKzkpPmif2GW
         uWcu6x1xtsDD1iZAJGtsi9cn/Enyh0pyljROYUxRHn+/leq2LPhFzTSCDLL6HJ6uKCHt
         RMSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734426095; x=1735030895;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bpai75X11LMfvePNjrqzhIaWJn/QBSdWg0KnRrx/c7Y=;
        b=qNRE6Y8EwgTRj7HjPhFs3HtyMKUgtKTffcEZBSk3866lir3PAhoJ6UGr/XRhqWahyx
         BetyGNeKMbwLiwzho+amgw5CDLRzXT0iKxzKfgTsO1eASWy7PygJ6zRJtW87ow5PnLcE
         HcyxMemsDmjODLln8WQ8kD6YGJ/s9qAU+3bq/98RausdN5u8HbmdITf4lBgG4ZLfGE7R
         Db71rB9aO9gyByvmTE+c9Jv9bACQ/97+PsAhEG8ZN2FHv9AHxHJPrd99kxq9770aDUob
         TzRJSZ+oKqgOT9lckUvzfViVu0HJrQ3pK7SrCQ/p9eTZh1a16O27FXcBrqZT9Wo6Jxq7
         8dgA==
X-Forwarded-Encrypted: i=1; AJvYcCX/Ky5WPcWoKeehWxzApACxKiHPk/mMqbWZWIv2PP6gXi08Gk9CdnYrBMrWZFcN4Ih78msL0+o=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxz4OwBpodLtzkY8D7iS5Z3mYNvGEOmxIVVIylJx78C1qiMREwe
	Lcjkht4Qwaa9NxCgrwCcc8+maa8r2MW2uREi3OcN78JCSjQWwKTREcplcvjpVBto9ZfdXAE95iE
	SuYfPS3UBMP/12IQWW42pAeAplWO176IWxDvu
X-Gm-Gg: ASbGncsYNd3loNi9UYhg4f/FK31KRhXnJPjEX6NKhC1AsBPFWbR0jhddJ2m8DnQlqCc
	3fhht5NQmQ9bv7BkpsuiIAIQmoFLRbJ1LHgYOiRyr4iaNupa6B53FRGPfq1oStniXcq0=
X-Google-Smtp-Source: AGHT+IEQQFJCYIi7D2fpMZdC3EviO5hPxfEuwAdpwMV205YFizbZuxpptBGEW5SdOPdDWzDZGDlz+zHkfEB6EtA0CpQ=
X-Received: by 2002:a7b:c057:0:b0:436:1868:b29f with SMTP id
 5b1f17b1804b1-436492e7bd8mr1053605e9.6.1734426095446; Tue, 17 Dec 2024
 01:01:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com> <20241216175803.2716565-17-qperret@google.com>
In-Reply-To: <20241216175803.2716565-17-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Dec 2024 09:00:58 +0000
Message-ID: <CA+EHjTw7X5fOY+1yLmGdqYbUDCOVCPfmJf--q8dBj3XLzPicBQ@mail.gmail.com>
Subject: Re: [PATCH v3 16/18] KVM: arm64: Introduce __pkvm_tlb_flush_vmid()
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

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/include/asm/kvm_asm.h   |  1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 17 +++++++++++++++++
>  2 files changed, 18 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index a3b07db2776c..002088c6e297 100644
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
> index 32c4627b5b5b..130f5f23bcb5 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -389,6 +389,22 @@ static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
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
> +       hyp_vm = get_np_pkvm_hyp_vm(handle);
> +       if (!hyp_vm)
> +               return;
> +
> +       __kvm_tlb_flush_vmid(&hyp_vm->kvm.arch.mmu);
> +       put_pkvm_hyp_vm(hyp_vm);
> +}
> +
>  static void handle___kvm_flush_cpu_context(struct kvm_cpu_context *host_ctxt)
>  {
>         DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> @@ -573,6 +589,7 @@ static const hcall_t host_hcall[] = {
>         HANDLE_FUNC(__pkvm_teardown_vm),
>         HANDLE_FUNC(__pkvm_vcpu_load),
>         HANDLE_FUNC(__pkvm_vcpu_put),
> +       HANDLE_FUNC(__pkvm_tlb_flush_vmid),
>  };
>
>  static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
> --
> 2.47.1.613.gc27f4b7a9f-goog
>

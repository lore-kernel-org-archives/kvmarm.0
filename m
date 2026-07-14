Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F858429018
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 19:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784057375; cv=none; b=Cd/EJIzr6/JBd2bVYiTB/+sQgR1i6KOoR0SMEbLN4huGisS7M18sRpEreN9NYrOydTTeHDzVn69STv/rE6F7ygHjSM14d3K1+BLKx7+HpRduJKovQsvAmxgy3dvEdQscwEfceil6FBXUrAQlCLq5IrzVro+Mg/0+mCVt5czQ+2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784057375; c=relaxed/simple;
	bh=U3LEbZEW6wje713amqnkBn7446YqBvqY3fh6yHF4uLg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o7a9qn22rCAwFzW5ykLIne3044UTkJhxIsNGuJOpyGAVsk1/RIqLRHZOOgCGOM9WrYSpgb4Yyn9Mu7o5awaI3OWc2eEpBImJHbCT7RMercf83AJfFbxePaQcEWl4s6l0vCtyIMv79D7v1L3rc0QR6ry66UV7C9WX0YWc4Ga9i30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rwKjmpaQ; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rwKjmpaQ"
X-Forwarded-Encrypted: i=1; AHgh+Rolw5afuSc7aakkOanYgH8Fm//EkPD1cVZctTVagElh1XYDKttB+z+9vEJhCrSZYy1O1q8NQ1k=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784057368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bpo1KyKMKhYFTRlb2RJOsA+e3kYhuJvTU2iJ2xMLWY4=;
	b=rwKjmpaQTsDhpaiJ/yYZ6lgDpabtN+SYuLxzlIoqNSWM+xcxUyzY0fY2cIJt/WtBSzbhCc
	m2zIwqfs2JKjp0pjf/rZjDQ5TmluLe87q/7aqyhdY9MMelkFP3WihcMpT5wX01qm4GmlIP
	5GQlrvc6MGKiy40cOBmSruaEDqBmbEU=
X-Gm-Message-State: AOJu0YxDyrML5xTAE90LGAoDu67XgRsP+JiysFXfXcft+wlQtQs5+9Gy
	4QplWe5UPQ2o9Rxq/iMGpGvuQCtgcNVIOSEHaqqpn5Rr86KwAxhU+u991uOYAfBYIqztaIbK5+G
	3es4MQt3rXtWYb+H5xDYHJsDdVecQ+AjCf926lGpS
X-Received: by 2002:a05:622a:aa05:20b0:51c:ca9:3d15 with SMTP id
 d75a77b69052e-51d7bd1f5b6mr14380171cf.12.1784057359790; Tue, 14 Jul 2026
 12:29:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com> <20260706175415.2604046-7-vdonnefort@google.com>
In-Reply-To: <20260706175415.2604046-7-vdonnefort@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 14 Jul 2026 20:28:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx8V-O0Wtx6dG-CD_-HwNeECPCm23oYVPYoUqEUsTZbhw@mail.gmail.com>
X-Gm-Features: AUfX_myZ-YiTTw-qVayx9SV-DJZQwLurb-jwih9cVUkLEzNDshARHSP1AE-9t7E
Message-ID: <CA+EHjTx8V-O0Wtx6dG-CD_-HwNeECPCm23oYVPYoUqEUsTZbhw@mail.gmail.com>
Subject: Re: [PATCH v2 06/18] KVM: arm64: Add topup interface for the pKVM
 heap allocator
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> Introduce a host HVC interface and a host side helper to allow refilling
> the pKVM heap allocator.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 043495f7fc78..681b7bf8ac08 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -114,6 +114,7 @@ enum __kvm_host_smccc_func {
>         __KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
>         __KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
>         __KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_hyp_topup,
>
>         MARKER(__KVM_HOST_SMCCC_FUNC_MAX)
>  };
> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> index 74fedd9c5ff0..870f7870bb62 100644
> --- a/arch/arm64/include/asm/kvm_pkvm.h
> +++ b/arch/arm64/include/asm/kvm_pkvm.h
> @@ -17,6 +17,10 @@
>
>  #define HYP_MEMBLOCK_REGIONS 128
>
> +enum pkvm_topup_id {
> +       PKVM_TOPUP_HYP_ALLOC,
> +};
> +
>  int pkvm_init_host_vm(struct kvm *kvm, unsigned long type);
>  int pkvm_create_hyp_vm(struct kvm *kvm);
>  bool pkvm_hyp_vm_is_created(struct kvm *kvm);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index d3c69de698f4..e270a974fa37 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -15,6 +15,7 @@
>  #include <asm/kvm_hypevents.h>
>  #include <asm/kvm_mmu.h>
>
> +#include <nvhe/alloc.h>
>  #include <nvhe/ffa.h>
>  #include <nvhe/mem_protect.h>
>  #include <nvhe/mm.h>
> @@ -632,6 +633,30 @@ static void handle___pkvm_finalize_teardown_vm(struct kvm_cpu_context *host_ctxt
>         cpu_reg(host_ctxt, 1) = __pkvm_finalize_teardown_vm(handle);
>  }
>
> +static void handle___pkvm_hyp_topup(struct kvm_cpu_context *host_ctxt)

Sashiko caught this. Suggest moving just this helper to patch 8
alongside its caller.

Cheers,
/fuad

> +{
> +       DECLARE_REG(enum pkvm_topup_id, id, host_ctxt, 1);
> +       DECLARE_REG(phys_addr_t, head, host_ctxt, 2);
> +       DECLARE_REG(unsigned long, nr_pages, host_ctxt, 3);
> +       struct kvm_hyp_memcache host_mc = {
> +               .head = head,
> +               .nr_pages = nr_pages,
> +       };
> +       int ret;
> +
> +       switch (id) {
> +       case PKVM_TOPUP_HYP_ALLOC:
> +               ret = hyp_alloc_topup(&host_mc);
> +               break;
> +       default:
> +               ret = -EINVAL;
> +       }
> +
> +       cpu_reg(host_ctxt, 1) = ret;
> +       cpu_reg(host_ctxt, 2) = host_mc.head;
> +       cpu_reg(host_ctxt, 3) = host_mc.nr_pages;
> +}
> +
>  static void handle___tracing_load(struct kvm_cpu_context *host_ctxt)
>  {
>         DECLARE_REG(unsigned long, desc_hva, host_ctxt, 1);
> @@ -762,6 +787,7 @@ static const hcall_t host_hcall[] = {
>         HANDLE_FUNC(__pkvm_vcpu_load),
>         HANDLE_FUNC(__pkvm_vcpu_put),
>         HANDLE_FUNC(__pkvm_tlb_flush_vmid),
> +       HANDLE_FUNC(__pkvm_hyp_topup),
>  };
>
>  static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 8324a6a1bc48..e2c8714e8ccc 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -85,6 +85,33 @@ void __init kvm_hyp_reserve(void)
>                  hyp_mem_base);
>  }
>
> +static int pkvm_hyp_topup(enum pkvm_topup_id id, unsigned long nr_pages)
> +{
> +       struct kvm_hyp_memcache mc;
> +       struct arm_smccc_res res;
> +       int ret;
> +
> +       init_hyp_memcache(&mc);
> +       ret = topup_hyp_memcache(&mc, nr_pages);
> +       if (ret)
> +               goto err;
> +
> +       arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(__pkvm_hyp_topup), id, mc.head,
> +                         mc.nr_pages, &res);
> +       if (WARN_ON_ONCE(res.a0 != SMCCC_RET_SUCCESS)) {
> +               ret = -EINVAL;
> +               goto err;
> +       }
> +
> +       ret = res.a1;
> +       mc.head = res.a2;
> +       mc.nr_pages = res.a3;
> +
> +err:
> +       free_hyp_memcache(&mc);
> +       return ret;
> +}
> +
>  static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
>  {
>         if (pkvm_hyp_vm_is_created(kvm)) {
> --
> 2.55.0.rc2.803.g1fd1e6609c-goog
>

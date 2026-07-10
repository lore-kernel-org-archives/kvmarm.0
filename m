Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4E136728C
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 16:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783700265; cv=none; b=kasz5seduohNn/6/SnPs2GU0akXJQNK6UdHG5Pr/iwvFx2JqB+n/Tx4WCyT8YaCwfprlfNyFSYXvndDHk/tu9rUnj0dDSV1chtnUVcryCKQnr9D6DGHhyZZ9xhFmEGa+H56ZKMVbqbz93sMk5GVBbImz1F8PHFaBA+RSslS62V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783700265; c=relaxed/simple;
	bh=owaUiQCKwhLk5DxVCpjYmtFnThoJ3PmJZ1sU/pLxi1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jR5+unCqfTWQtQnzdIM8vbrXVjYGbBkW7oYpkuI7aOhfTwq2L/VffSyu8gbZA3yGEM/lUCKVTtEDfPE/WZM4ceP2teVv9DwJdt3uxPCb73pzrGGCumol/+CYLMHDE5v8lIccd5qQlwHwzfPQkvWtbGRGvHT3NPsCdvAu1oO4t9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fga8S6qs; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fga8S6qs"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-493f25d47dcso8799575e9.1
        for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 09:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783700258; x=1784305058; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=36epyzeQ57987BAo//5mNX8OTT88iDUdRaI6qY+H3cE=;
        b=fga8S6qsS3/6aAHNzJBmzpuS+qx+kOxXNb7K2CDvgUpAClmqxgMDYdHd0wWXpBJKHf
         p6KgglsgoNT0Ouc8zM7C8nDlnoIxkoLu6xWJ2KfB5N4rDDIsP01FOpDxRsEMa+uAnacN
         2c5XqfA5gMG6A6qeE88TP/7zcpnaRcCD0TasTxIoP6l/qvLOfM1/bR7ORzaULpB1mumB
         fyHu20owJSTwBaQCfs2+7ysFY7WBXIPCB9Rl0HniM4NFEWQlBgaVTzIFVXZ30OkUMt3H
         0xHEM3HpJXpK8afAWqRJICF1ZWbc303vB9z/O5Ucjq/GptjiAPIrU5BAImYXy87rF1mF
         Bteg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783700258; x=1784305058;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=36epyzeQ57987BAo//5mNX8OTT88iDUdRaI6qY+H3cE=;
        b=Ntr9G6ZLqnCQZA0O8ZyToanXeaPVHabgcEYnUo2lyeoQFZC5pHpAKwEi9BNwa2lQ4g
         8WmQtsgBRvPxdlr0AFa9r7oiN3Jen57y875JhfSQC4YVoB+ltSyK3TwcjGm/+Ij5OTEP
         5QjfD7Z16wZYPrDFQizclKCoGdYhwuT35Rxcy46UAhhnEjRrOxiSu7fkTOJa60doKfwm
         B2+0yuXg4veM5PN3V9jk97jV5ZkDTUdS7uzBhdec8arAabuCeeIwGPJUFuVitvYQN7ln
         vR7Q/q84uchZ2HCXnumZCR47Q+IhoWVCGSnfD0+0mlaQbFD2EWuUsdBYjEMuDTQ4MCbJ
         adwg==
X-Forwarded-Encrypted: i=1; AHgh+RpYD6yp1v20WGJz/OlQFapvAwiyiTNrzX5CpSsmR4FG/7KXrQfnmZ54EV7mGbSVcVbejFWtpaQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxa2QvODikX/PtRo0ad5Hd6lRWGbNZ5bRVk8kax/MEJ1wFTjWmN
	NwnvRQ6Y9SFEGiyl1bXEHTo4CfAfbsiDuH25mGbt02HMhdtaZJO82OJqiDAwnHbw0Q==
X-Gm-Gg: AfdE7ckj6XTlQd9k5phw2nG9hzn/Z0P1eobnlae1/qMdkKy6x+m0rHvgjSz0Var/J2p
	lHzLRyXYcj3a9QA82NcQV0HF5ydpWn4j9WwiXW+Sza980v3ZKZUf2jSvzEHYRSXPHp3XfozYxC3
	DbpEOu07ifSgtQ0HlSlt/ZC5Igr5gMzYcCpehC9xPZOIwz4u1KU5extFpNlmk+fmAk4EDyJ/ag/
	ZGBeCVFizzmVCvuTKODjabDflkw9tC8IOLVBx329+4lhErv4pFH43kYlQxlMz7Agnvm5+0bGPsR
	nCX918/tpuRQz10tyqvf8g25FAIlgutf7CSilEkXCP8VQ1S2GoM5jh5fHOZRsV6eaxkm0YoJd3i
	yfyBc+ahOLzvOqfnmGDGSv+zbtzxcCkMwpQC1jEBzBtXAKa2fAPJ8tHh3pMuezr4110iHiyFVQD
	HepZSIdCQQaxcmWJ67Qsv2MOKnUtq1KEFb7vAUD03QgmHh++EGBRI=
X-Received: by 2002:a05:600c:3496:b0:493:bc4a:c6b4 with SMTP id 5b1f17b1804b1-493f7499191mr13922845e9.38.1783700257980;
        Fri, 10 Jul 2026 09:17:37 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6f3dcdsm143760685e9.3.2026.07.10.09.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 09:17:36 -0700 (PDT)
Date: Fri, 10 Jul 2026 17:17:32 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	jgg@ziepe.ca, mark.rutland@arm.com, qperret@google.com,
	tabba@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 07/25] KVM: arm64: iommu: Introduce IOMMU driver
 infrastructure
Message-ID: <alEbHFbmr_PvY6ZB@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-8-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260501111928.259252-8-smostafa@google.com>

On Fri, May 01, 2026 at 11:19:09AM +0000, Mostafa Saleh wrote:
> To establish DMA isolation, KVM needs an IOMMU driver which provides
> ops implemented at EL2.
> 
> Only one driver can be used and is registered with
> kvm_iommu_register_driver() by passing pointer to the ops.
> 
> This must be called before module_init() which is the point KVM
> initializes.

Everywhere s/KVM/pKVM/ as this can be registered only if pKVM is enabled.

> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h       |  5 +++++
>  arch/arm64/kvm/Makefile                 |  2 +-
>  arch/arm64/kvm/hyp/include/nvhe/iommu.h | 13 +++++++++++++
>  arch/arm64/kvm/hyp/nvhe/Makefile        |  3 ++-
>  arch/arm64/kvm/hyp/nvhe/iommu/iommu.c   | 20 +++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/setup.c         |  5 +++++
>  arch/arm64/kvm/iommu.c                  | 26 +++++++++++++++++++++++++
>  7 files changed, 72 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/iommu.h
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
>  create mode 100644 arch/arm64/kvm/iommu.c
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 851f6171751c..52898d2a3ec6 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1733,4 +1733,9 @@ static __always_inline enum fgt_group_id __fgt_reg_to_group_id(enum vcpu_sysreg
>  
>  long kvm_get_cap_for_kvm_ioctl(unsigned int ioctl, long *ext);
>  
> +#ifndef __KVM_NVHE_HYPERVISOR__

I think it's not necessary, a lot of things aren't guarded for
__KVM_NVHE_HYPERVISOR__.

> +struct kvm_iommu_ops;

Perhaps we can keep this private to hyp code by just using (void *) here?

> +int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops);
> +#endif
> +
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 59612d2f277c..0ddef54f7434 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -24,7 +24,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>  	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
>  	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
>  	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
> -	 vgic/vgic-v5.o
> +	 vgic/vgic-v5.o iommu.o

alphabetical order.

>  
>  kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
>  kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
> new file mode 100644
> index 000000000000..1ac70cc28a9e
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __ARM64_KVM_NVHE_IOMMU_H__
> +#define __ARM64_KVM_NVHE_IOMMU_H__
> +
> +#include <asm/kvm_host.h>
> +
> +struct kvm_iommu_ops {
> +	int (*init)(void);
> +};
> +
> +int kvm_iommu_init(void);
> +
> +#endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index 89d0533921f9..606c0e1b7bd0 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -24,7 +24,8 @@ CFLAGS_switch.nvhe.o += -Wno-override-init
>  
>  hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
>  	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
> -	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
> +	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o \
> +	 iommu/iommu.o
>  hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
>  	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o clock.o
>  hyp-obj-y += ../../../kernel/smccc-call.o
> diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
> new file mode 100644
> index 000000000000..406c8fb9b3b9
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
> @@ -0,0 +1,20 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * IOMMU operations for pKVM
> + *
> + * Copyright (C) 2022 Linaro Ltd.
> + */
> +#include <nvhe/iommu.h>
> +
> +/* Only one set of ops supported */
> +struct kvm_iommu_ops *kvm_iommu_ops;
> +
> +

Empty line.

> +int kvm_iommu_init(void)
> +{
> +	/* Keep DMA isolation optional. */
> +	if (!kvm_iommu_ops || !kvm_iommu_ops->init)
> +		return 0;

The absence of the SME workaround on affected systems breaks pKVM init. So
perhaps the IOMMU should do the same? (see pkvm_check_sme_dvmsync_fw_call())

> +
> +	return kvm_iommu_ops->init();
> +}
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index 8041f6e80cd1..1f6b221db9a0 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -14,6 +14,7 @@
>  #include <nvhe/early_alloc.h>
>  #include <nvhe/ffa.h>
>  #include <nvhe/gfp.h>
> +#include <nvhe/iommu.h>
>  #include <nvhe/memory.h>
>  #include <nvhe/mem_protect.h>
>  #include <nvhe/mm.h>
> @@ -329,6 +330,10 @@ void __noreturn __pkvm_init_finalise(void)
>  	if (ret)
>  		goto out;
>  
> +	ret = kvm_iommu_init();
> +	if (ret)
> +		goto out;
> +
>  	ret = hyp_ffa_init(ffa_proxy_pages);
>  	if (ret)
>  		goto out;
> diff --git a/arch/arm64/kvm/iommu.c b/arch/arm64/kvm/iommu.c
> new file mode 100644
> index 000000000000..f247384fa193
> --- /dev/null
> +++ b/arch/arm64/kvm/iommu.c
> @@ -0,0 +1,26 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2025 Google LLC
> + * Author: Mostafa Saleh <smostafa@google.com>
> + */
> +
> +#include <linux/kvm_host.h>
> +
> +extern struct kvm_iommu_ops *kvm_nvhe_sym(kvm_iommu_ops);
> +
> +static DEFINE_MUTEX(kvm_iommu_reg_lock);

could be moved directly into the only user: kvm_iommu_register_driver

> +
> +int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops)

__init ?

> +{
> +	guard(mutex)(&kvm_iommu_reg_lock);
> +
> +	/* Only protected KVM before de-privilege. */

Don't think that comment brings much information, looking at the line below.

> +	if (!is_protected_kvm_enabled() || is_kvm_arm_initialised())
> +		return -EINVAL;

-EPERM?

> +
> +	if (kvm_nvhe_sym(kvm_iommu_ops))
> +		return -EBUSY;
> +
> +	kvm_nvhe_sym(kvm_iommu_ops) = hyp_ops;
> +	return 0;
> +}
> -- 
> 2.54.0.545.g6539524ca2-goog
> 

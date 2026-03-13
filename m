Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EA53148A6
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 09:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773395924; cv=pass; b=EzjatxH28nFqrffxNUxtWv5ZsYSZQaHS2TobaRSCroTXDH5xo+AMVItHU/Dn73dqsUeSRLLomnXYdZJnnYTW7tVVTaPHC6vU3s4QTZJX+i5m0eFPkO4n4XiqEHge94HExAZw/g8DuzJssbOsQjF5yoIUSKFaY0nQ0TWCOa+TsrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773395924; c=relaxed/simple;
	bh=w7Miz+dEsZq4kZxIBpEdN4ALdVqqnv0yKfFCWKLBelo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZQ9UJaBTw4s3Fr8+Qlh4HqJzxvtkDFlBQRampwuvmMjvy/ZGiB2A2e7crRtKUG+GdyqjiiXL0cirMQB/U5sGrR/260Y/fUePqeWA3gpl7snikmkS4b6x0GkWX/Ro4+DTd+CsQ6l4H9MaWpJ5afSemMDI5GOdqc15HAYpdQA0bho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R5f0ojbT; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R5f0ojbT"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5091ed02c54so323391cf.1
        for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 02:58:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773395921; cv=none;
        d=google.com; s=arc-20240605;
        b=j0z/x7+7iivwubPphpFyekEZ6GWLAR+EkOMOeR/UfgSzyOtINKAjY4fTqoeTrqqd1Q
         upz51SM4A2gUCH//eWa0NxcecD0xmcqzPCvDnadmaWzY8UpzLdso9EvIWQli3OTX8GLU
         lq8FPB5wBZ3tobGlPjJxf1AJtgurhzO0u9+RNXNgV5yuHTjSfqqPzZpEFGhR6AP8xMHv
         0+tXzW48CYL3B7FoyCbqWtgSUHNdFl84qXv0v6QjNtBhq2aq8Q9hEB0MMnh3D9PDcoSs
         hzdsn5vygAfkZLfCQvaR6c4tztLG+PwvV6CNp7bQJ4dOoqDXjEFg7eQsJ3m8ABm+d01y
         wXCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5Zi9Teres6TyTinVCJu3uRJepi8Sum75aWEQVAXIcW0=;
        fh=4zLTdpaFcx6htt8/SUw5Pcr8GQMi1z7i6OhSj3CECUw=;
        b=JsbBQAx4v/g76S9OPcgAHjKZ6kR5Hd6u4jErzD3fzoGlScRZAqFdjcvysiSe6/qV7f
         VbNDFYUm6LGklpURSaLT1ovwzbxeskn3jxJAYEzjQJNbJUArGD6eNCHDkIpW2vIPHk/S
         WRkkhjf6Atz1rnUbrjVMaAI4TghQvSnxJNhvEy3EeuGL2InKuRU0sft1wBjkl1ExlAlK
         icoul/lFb8EFilCZvoqpRsiMZUkuCnEf67WEV8onrYe8Q05e6Fa9KUeqv+qzpt3AYh3A
         xVWAw6mwjPZEDRjVtKCFgJtrM88vbQfecJXle3vPWjF7bfeUgHFyWbsd8anURKy2bV/D
         aucg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773395921; x=1774000721; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5Zi9Teres6TyTinVCJu3uRJepi8Sum75aWEQVAXIcW0=;
        b=R5f0ojbTv1mV5oOaLA5HNA2fvRmqrsmi1h4cJKU2sk+YpyB/G35olVWHPxqwd3VX0Y
         OlVcrBNLOd/nb28W5d605sfpYJK4tYFhwYUfksQnBrRbR7GMAXWJbAmNQD7EFh8gMvjY
         onVZXgcnbNh3SPTGSLE/GROJNf6sYfcsncF5zpzqnxsXUTHVCcbAs3z3BlplVpzhKvYg
         KOR7rAcmzG+v5ajuSDITjCgEF2AGuqoTlZsyagneMcbLjqTimqtCwWigru3rwLk8ewrU
         9Nx5NlKU/xhVJH8jh8biSJY0AeiKGh/rJghUAGZJ3xva4yiP1OgnnIIby4LdZ16rb0bH
         Fe0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773395921; x=1774000721;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Zi9Teres6TyTinVCJu3uRJepi8Sum75aWEQVAXIcW0=;
        b=bTZIxmhv3OnkgQQpM5ocGmJk1PEwghL/WY7HOmsolzfjnyArVTMTKT95zPmJeARHHA
         5NoOAEQ9Wvs0IflGyFZPx6olXkBZ6yFonfeReWGgTPG58Xz+6SP6QGVu8HCnfiYo56FF
         aM0dsYZ/11dMxJ/06RaQRMxVtuZLHfMdnIcMZDMCFT5KF+vu5eDJyoh50166KbeyAZgZ
         7aCC/g7gFaSQkr8yxt+FG42h/fsa3Hx0moD19aJbatalYPS9qK9RYVqZ7lDuh17fl4yL
         xh9VRHNnF/zN0phl0oEndTXirkmdsySw+Wj3xpLymwT8H+JyecMrUCQmOzWbHf1g/20O
         oAOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAPanzmtCK7qcGgxYCGuq+EhPgxAV0Ki6oLvu2kI3f1S13CZGvYl3U/G8OknJ6rViq+SGMHyo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzWi+KAjwfg8itXSKsEGKGaXjh7fNjgxy7I8gilCnIxJ3PX1dUo
	VmuVvw6LoOIW2wGiUjSt82mcvk3bu41XwW/Gd2yvCDWYtwhUML3yN9skIO6lbEKPYGqCybr70V0
	5ym/wTPmkcz+750Y+ggl7sqU3EaOXwiabfiQYtM7z
X-Gm-Gg: ATEYQzwsxyUBP3loq1vO6rMYpUdwMr0xS8GxAaMd9RIeEpM6U263EuvWXyoNOqCT/bi
	eOIZLUgMqLxDKqQc2bgOa/pwYz6oOjS7upw9OsxvWqo8KQcMr+qWGKEHxaDxOWQ88qeP7EaR/8+
	2Z7m9Igdojiu1vNu7hPAhxYQ3XbxkT6IgSXNveWPnNvie3h4AwH61XFIgCFu8/+9kL0gOr1jGSv
	k15YQey9mLazlZT3DHuUmlKTTn9ApmoMKFOHsl7GAKQvqdL6xbDhVWvoiEMlcibtLoobkPqERlL
	9x6umkv3
X-Received: by 2002:ac8:5ac8:0:b0:509:371:f2ab with SMTP id
 d75a77b69052e-5095851ed70mr5086341cf.16.1773395920808; Fri, 13 Mar 2026
 02:58:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com> <20260310124933.830025-5-sebastianene@google.com>
In-Reply-To: <20260310124933.830025-5-sebastianene@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 13 Mar 2026 09:58:04 +0000
X-Gm-Features: AaiRm51S-lJNKL8bzKDy45ZPYAUg9APbPHuSXLIrmBlxQacQriUWkT4k6Q18few
Message-ID: <CA+EHjTy9uG4OOw10OoX45A6Bxnb1PssB9mDdSa=H42Ho0AtQRw@mail.gmail.com>
Subject: Re: [PATCH 04/14] KVM: arm64: Mediate host access to GIC/ITS MMIO via unmapping
To: Sebastian Ene <sebastianene@google.com>
Cc: alexandru.elisei@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, catalin.marinas@arm.com, dbrazdil@google.com, 
	joey.gouly@arm.com, kees@kernel.org, mark.rutland@arm.com, maz@kernel.org, 
	oupton@kernel.org, perlarsen@google.com, qperret@google.com, 
	rananta@google.com, smostafa@google.com, suzuki.poulose@arm.com, 
	tglx@kernel.org, vdonnefort@google.com, bgrzesik@google.com, will@kernel.org, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hi Sebastian,

On Tue, 10 Mar 2026 at 12:49, Sebastian Ene <sebastianene@google.com> wrote:
>
> Unmap the ITS MMIO region from the host address space to enforce
> hypervisor mediation.
> Identify the ITS base address from the device tree and store it in a
> protected region. A callback is registered to handle host accesses to
> this region; currently, the handler simply forwards all MMIO requests
> to the physical hardware. This provides the infrastructure for future
> hardware state validation without changing current behavior.
>
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/include/asm/kvm_pkvm.h     |  2 ++
>  arch/arm64/kvm/hyp/nvhe/Makefile      |  3 ++-
>  arch/arm64/kvm/hyp/nvhe/its_emulate.c | 23 ++++++++++++++++
>  arch/arm64/kvm/pkvm.c                 | 38 +++++++++++++++++++++++++++
>  4 files changed, 65 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/its_emulate.c
>
> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> index 5321ced2f50a..ef00c1bf7d00 100644
> --- a/arch/arm64/include/asm/kvm_pkvm.h
> +++ b/arch/arm64/include/asm/kvm_pkvm.h
> @@ -32,6 +32,8 @@ struct pkvm_protected_reg {
>
>  extern struct pkvm_protected_reg kvm_nvhe_sym(pkvm_protected_regs)[];
>  extern unsigned int kvm_nvhe_sym(num_protected_reg);
> +extern void kvm_nvhe_sym(pkvm_handle_forward_req)(struct pkvm_protected_reg *region, u64 offset,
> +                                                 bool write, u64 *reg, u8 reg_size);
>
>  int pkvm_init_host_vm(struct kvm *kvm);
>  int pkvm_create_hyp_vm(struct kvm *kvm);
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index a244ec25f8c5..eb43269fbac2 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -24,7 +24,8 @@ CFLAGS_switch.nvhe.o += -Wno-override-init
>
>  hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
>          hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
> -        cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
> +        cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o \
> +        its_emulate.o
>  hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
>          ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
>  hyp-obj-y += ../../../kernel/smccc-call.o
> diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> new file mode 100644
> index 000000000000..0eecbb011898
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> @@ -0,0 +1,23 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <asm/kvm_pkvm.h>
> +#include <nvhe/mem_protect.h>
> +
> +
> +void pkvm_handle_forward_req(struct pkvm_protected_reg *region, u64 offset, bool write,
> +                            u64 *reg, u8 reg_size)
> +{
> +       void __iomem *addr = __hyp_va((region->start_pfn << PAGE_SHIFT) + offset);

Better use the macros to do this:
+       void __iomem *addr = __hyp_va(PFN_PHYS(region->start_pfn) + offset);

Also, considering all the potential issues with hyp_va, it might be
better to store the virtual address in pkvm_protected_regs (void
__iomem *base_va) assigned to the MMIO region at the time it was
successfully mapped into EL2, rather than recalculating it on the fly.

> +
> +       if (reg_size == sizeof(u32)) {
> +               if (!write)
> +                       *reg = readl_relaxed(addr);
> +               else
> +                       writel_relaxed(*reg, addr);
> +       } else if (reg_size == sizeof(u64)) {
> +               if (!write)
> +                       *reg = readq_relaxed(addr);
> +               else
> +                       writeq_relaxed(*reg, addr);
> +       }

The spec permits 8-bit, 16-bit, 32-bit, and 64-bit accesses depending
on the specific register. This only checks for sizeof(u32) and
sizeof(u64). You should either handle them, or you intentionally
wanted to block 8-bit/16-bit accesses, then you must explicitly inject
a synchronous abort back to the host.

Also, I think that using `readl_relaxed` and `writel_relaxed` is
technically correct for pure passthrough, as it assumes the host
driver issued the necessary barriers before triggering the trap.
However, with memory barriers I am always a bit wary, and I'd rather
we check with someone to confirm whether this is ok, i.e., Will
Deacon.

> +}
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index d7a0f69a9982..a766be6de735 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -11,6 +11,9 @@
>  #include <asm/kvm_mmu.h>
>  #include <linux/memblock.h>
>  #include <linux/mutex.h>
> +#include <linux/of_address.h>
> +#include <linux/of_reserved_mem.h>
> +#include <linux/platform_device.h>
>
>  #include <asm/kvm_pkvm.h>
>
> @@ -18,6 +21,7 @@
>
>  DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
>
> +static struct pkvm_protected_reg *pkvm_protected_regs = kvm_nvhe_sym(pkvm_protected_regs);
>  static struct memblock_region *hyp_memory = kvm_nvhe_sym(hyp_memory);
>  static unsigned int *hyp_memblock_nr_ptr = &kvm_nvhe_sym(hyp_memblock_nr);
>
> @@ -39,6 +43,34 @@ static int __init register_memblock_regions(void)
>         return 0;
>  }
>
> +static int __init register_protected_regions(void)
> +{
> +       int i = 0, ret;
> +       struct device_node *np;
> +       struct resource res;

Prefer reverse Christmas tree declaration order.

> +
> +       for_each_compatible_node(np, NULL, "arm,gic-v3-its") {
> +               ret = of_address_to_resource(np, i, &res);
> +               if (ret)
> +                       return ret;
> +
> +               if (i >= PKVM_PROTECTED_REGS_NUM)
> +                       return -ENOMEM;
> +
> +               if (!PAGE_ALIGNED(res.start) || !PAGE_ALIGNED(resource_size(&res)))
> +                       return -EINVAL;
> +
> +               pkvm_protected_regs[i].start_pfn = res.start >> PAGE_SHIFT;

and this:
... PHYS_PFN(res.start);


> +               pkvm_protected_regs[i].num_pages = resource_size(&res) >> PAGE_SHIFT;

and this:
... PFN_DOWN(resource_size(&res));

Cheers,
/fuad

> +               pkvm_protected_regs[i].cb = lm_alias(&kvm_nvhe_sym(pkvm_handle_forward_req));
> +               i++;
> +       }
> +
> +       kvm_nvhe_sym(num_protected_reg) = i;
> +
> +       return 0;
> +}
> +
>  void __init kvm_hyp_reserve(void)
>  {
>         u64 hyp_mem_pages = 0;
> @@ -57,6 +89,12 @@ void __init kvm_hyp_reserve(void)
>                 return;
>         }
>
> +       ret = register_protected_regions();
> +       if (ret) {
> +               kvm_err("Failed to register protected reg: %d\n", ret);
> +               return;
> +       }
> +
>         hyp_mem_pages += hyp_s1_pgtable_pages();
>         hyp_mem_pages += host_s2_pgtable_pages();
>         hyp_mem_pages += hyp_vm_table_pages();
> --
> 2.53.0.473.g4a7958ca14-goog
>

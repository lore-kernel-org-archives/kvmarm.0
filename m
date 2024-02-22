Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3737E14D434
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 15:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708615029; cv=none; b=YCiFJdTsBiq7bm05p3j1WkrZ0P/b9U7RiPdZHTkdiKyGYv7JrFFGz2Nv1DWLW6mSpUJC8+rp9KpVZl5mSYw7YadAXthimwDbcSJRX9UlrjjBqL+pKhtGAm6lRk6GcJIL//8Av9u/ajmcQwYREUI9OPYVh2oA2IRpyAmG/a5Gz9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708615029; c=relaxed/simple;
	bh=jE1smbilwwuUTxlOGPI8u4Pvc86xtJjVhfwWSrbdnNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P2OMPj3yGWXtR+TYr/s5ebEag7J9Yg/mnT7igCYbD2xeTzz0YuLKwyK+o846R3MNMuAK+Q2ky3mkWHiuLFb24ymmSyn8IoHpOKzzdKfHv5CG9vvt0ASjC05MZytZbcFnrLQHVafVAt9R67/TN4kdeiB1mW8ae4bGtAkaFdLgwL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iak4weff; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iak4weff"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-410acf9e776so59365e9.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 07:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708615025; x=1709219825; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m+iF9o/NZzsGZGtwVZGeQKMH65Ee8z6fiQn4IwAd3ZA=;
        b=iak4weff8eLXDgEEmysDQLSXh20lx7/UzbtBsj/i4BxZZwLoA/bP2jdnBaAX164GcL
         upxjiozLIXcZc7O4CxbdKgjFsDq4CDZQcxEOt22YvWDsMiFLaNj9JmXs0HRgeXXM+T55
         WWK/6RH0L6yGQrlEPAtbct8OUUMnMK8O413BtkiGcIvRhle7+NMK2x8dkRMkgKIY3lco
         08jq3XWPYodG5LoWBauXFKjBdNCSLs/cNm1D1IN+L0F8B3oVUsroeyuKagFJBN5fjlfF
         NaQ6zVskWjMRMntEUwldAAQ8dxJzaXPT/HFcOYlzUHgt0aTepeN/k2UObWa9Z2bCkIkA
         kmIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708615025; x=1709219825;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m+iF9o/NZzsGZGtwVZGeQKMH65Ee8z6fiQn4IwAd3ZA=;
        b=ageAhhfOkzdqwRnBD6uzBbKBxId86wgSTX22wW1yUoilPVrrPkoNaBpUVKUdlhGzon
         p/ykEM3dKdBsFEUMo/Qm8QbjedFJmG/PfsUywKEwasuHEJZpxatT3pC4uuqzwy9OkfkI
         HXPnho4Z79B5GVFg52uo5gI0rI8d6J1OuvdnA1HCprTd+gL+BVgDXBiwVxGVz2onpQwe
         LvnMP4ppQt0T41Ds/ZvIpbPlZLUmDXfU9YgjeUxYESfuH/zWGxtZb+41ryEzu7hL16G3
         NojHqYYCgRQoZ8KgwFbpAxhYQAb5ZC6GAJZfDFvXzS25IO3wgsVlKugxB0AKwJch5/ys
         otsw==
X-Gm-Message-State: AOJu0YyDuoJ6LYVgYARiu8jJoFQznDMnKOuwHXjZl7CtrtWKa7tlLd36
	4mlQ3FJX3m7rdmREZq2tiS0KyOkju3VTaEJXcz5K4KkkoEapi1TO5ii/FTe6tw==
X-Google-Smtp-Source: AGHT+IEV5jG6AiN4BwmXoTQnJIhm9yCBOIr4zqeXzJCp6J7wpxLmYTEmrmtGvEUPUAGTbpyh0WG1lQ==
X-Received: by 2002:a05:600c:4e11:b0:412:8f47:d872 with SMTP id b17-20020a05600c4e1100b004128f47d872mr22221wmq.1.1708615025452;
        Thu, 22 Feb 2024 07:17:05 -0800 (PST)
Received: from google.com (161.126.77.34.bc.googleusercontent.com. [34.77.126.161])
        by smtp.gmail.com with ESMTPSA id je11-20020a05600c1f8b00b0040fdf5e6d40sm22277768wmb.20.2024.02.22.07.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 07:17:04 -0800 (PST)
Date: Thu, 22 Feb 2024 15:17:02 +0000
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, gshan@redhat.com, james.morse@arm.com,
	mark.rutland@arm.com, maz@kernel.org, oliver.upton@linux.dev,
	rananta@google.com, ricarkol@google.com, ryan.roberts@arm.com,
	shahuang@redhat.com, suzuki.poulose@arm.com, will@kernel.org,
	yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com,
	vdonnefort@google.com
Subject: Re: [PATCH v6 4/6] KVM: arm64: Register ptdump with debugfs on guest
 creation
Message-ID: <ZddlbkG9j8UjhaWs@google.com>
References: <20240220151035.327199-1-sebastianene@google.com>
 <20240220151035.327199-5-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220151035.327199-5-sebastianene@google.com>

On Tue, Feb 20, 2024 at 03:10:33PM +0000, Sebastian Ene wrote:
> While arch/*/mem/ptdump handles the kernel pagetable dumping code,
> introduce KVM/ptdump which shows the guest stage-2 pagetables. The
> separation is necessary because most of the definitions from the
> stage-2 pagetable reside in the KVM path and we will be invoking
> functionality **specific** to KVM.
> 
> When a guest is created, register a new file entry under the guest
> debugfs dir which allows userspace to show the contents of the guest
> stage-2 pagetables when accessed.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/Kconfig      | 13 ++++++
>  arch/arm64/kvm/Makefile     |  1 +
>  arch/arm64/kvm/debug.c      |  8 ++++
>  arch/arm64/kvm/kvm_ptdump.h | 20 +++++++++
>  arch/arm64/kvm/ptdump.c     | 88 +++++++++++++++++++++++++++++++++++++
>  5 files changed, 130 insertions(+)
>  create mode 100644 arch/arm64/kvm/kvm_ptdump.h
>  create mode 100644 arch/arm64/kvm/ptdump.c
> 
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 27ca89b628a0..83ca07d16cf4 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -67,4 +67,17 @@ config PROTECTED_NVHE_STACKTRACE
>  
>  	  If unsure, or not using protected nVHE (pKVM), say N.
>  
> +config PTDUMP_STAGE2_DEBUGFS
> +       bool "Present the stage-2 pagetables to debugfs"
> +       depends on PTDUMP_DEBUGFS && KVM
> +       default n
> +       help
> +         Say Y here if you want to show the stage-2 kernel pagetables
> +         layout in a debugfs file. This information is only useful for kernel developers
> +         who are working in architecture specific areas of the kernel.
> +         It is probably not a good idea to enable this feature in a production
> +         kernel.
> +
> +         If in doubt, say N.
> +
>  endif # VIRTUALIZATION
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index c0c050e53157..190eac17538c 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -23,6 +23,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>  	 vgic/vgic-its.o vgic/vgic-debug.o
>  
>  kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
> +kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
>  
>  always-y := hyp_constants.h hyp-constants.s
>  
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index 8725291cb00a..ff97af2c0513 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -14,6 +14,8 @@
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_emulate.h>
>  
> +#include <kvm_ptdump.h>
> +
>  #include "trace.h"
>  
>  /* These are the bits of MDSCR_EL1 we may manipulate */
> @@ -342,3 +344,9 @@ void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu)
>  	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_SPE);
>  	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_TRBE);
>  }
> +
> +int kvm_arch_create_vm_debugfs(struct kvm *kvm)
> +{
> +	kvm_ptdump_guest_register(kvm);
> +	return 0;
> +}
> diff --git a/arch/arm64/kvm/kvm_ptdump.h b/arch/arm64/kvm/kvm_ptdump.h
> new file mode 100644
> index 000000000000..5e8a655605f1
> --- /dev/null
> +++ b/arch/arm64/kvm/kvm_ptdump.h
> @@ -0,0 +1,20 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) Google, 2023
> + * Author: Sebastian Ene <sebastianene@google.com>
> + */
> +
> +#ifndef __KVM_PTDUMP_H
> +#define __KVM_PTDUMP_H
> +
> +#include <linux/kvm_host.h>
> +#include <asm/ptdump.h>
> +
> +
> +#ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
> +void kvm_ptdump_guest_register(struct kvm *kvm);
> +#else
> +static inline void kvm_ptdump_guest_register(struct kvm *kvm) {}
> +#endif /* CONFIG_PTDUMP_STAGE2_DEBUGFS */
> +
> +#endif /* __KVM_PTDUMP_H */
> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> new file mode 100644
> index 000000000000..9b04c24bb9be
> --- /dev/null
> +++ b/arch/arm64/kvm/ptdump.c
> @@ -0,0 +1,88 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Debug helper used to dump the stage-2 pagetables of the system and their
> + * associated permissions.
> + *
> + * Copyright (C) Google, 2023
> + * Author: Sebastian Ene <sebastianene@google.com>
> + */
> +#include <linux/debugfs.h>
> +#include <linux/kvm_host.h>
> +#include <linux/seq_file.h>
> +
> +#include <asm/kvm_pgtable.h>
> +#include <kvm_ptdump.h>
> +
> +
> +static int kvm_ptdump_visitor(const struct kvm_pgtable_visit_ctx *ctx,
> +			      enum kvm_pgtable_walk_flags visit)
> +{
> +	struct pg_state *st = ctx->arg;
> +	struct ptdump_state *pt_st = &st->ptdump;
> +
> +	note_page(pt_st, ctx->addr, ctx->level, ctx->old);
> +	return 0;
> +}
> +
> +static int kvm_ptdump_show_common(struct seq_file *m,
> +				  struct kvm_pgtable *pgtable,
> +				  struct pg_state *parser_state)
> +{
> +	struct kvm_pgtable_walker walker = (struct kvm_pgtable_walker) {
> +		.cb     = kvm_ptdump_visitor,
> +		.arg	= parser_state,
> +		.flags	= KVM_PGTABLE_WALK_LEAF,
> +	};
> +
> +	return kvm_pgtable_walk(pgtable, 0, BIT(pgtable->ia_bits), &walker);
> +}
> +
> +static int kvm_ptdump_guest_show(struct seq_file *m, void *)
							^
FIXME: Here I need to specify an argument name as building with clang
complaints about this.

> +{
> +	struct kvm *kvm = m->private;
> +	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
> +	struct pg_state parser_state = {0};
> +	int ret;
> +
> +	write_lock(&kvm->mmu_lock);
> +	ret = kvm_ptdump_show_common(m, mmu->pgt, &parser_state);
> +	write_unlock(&kvm->mmu_lock);
> +
> +	return ret;
> +}
> +
> +static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
> +{
> +	struct kvm *kvm = m->i_private;
> +	int ret;
> +
> +	if (!kvm_get_kvm_safe(kvm))
> +		return -ENOENT;
> +
> +	ret = single_open(file, kvm_ptdump_guest_show, m->i_private);
> +	if (ret < 0)
> +		kvm_put_kvm(kvm);
> +
> +	return ret;
> +}
> +
> +static int kvm_ptdump_guest_close(struct inode *m, struct file *file)
> +{
> +	struct kvm *kvm = m->i_private;
> +
> +	kvm_put_kvm(kvm);
> +	return single_release(m, file);
> +}
> +
> +static const struct file_operations kvm_ptdump_guest_fops = {
> +	.open		= kvm_ptdump_guest_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= kvm_ptdump_guest_close,
> +};
> +
> +void kvm_ptdump_guest_register(struct kvm *kvm)
> +{
> +	debugfs_create_file("stage2_page_tables", 0400, kvm->debugfs_dentry,
> +			    kvm, &kvm_ptdump_guest_fops);
> +}
> -- 
> 2.44.0.rc0.258.g7320e95886-goog
> 

Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBFA314B9A
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 10:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774349976; cv=none; b=rMpftLheb4r1JPS1ATJ3mSFRqDnv1AejwbyZUee8HV2if9S04nSmCDxxSIiHmKNfIHWQXVzVzK21ASnaCIKTImlGkne/zajr7pVQhH/fKZipnvv/1a78LdGuJL8zbFN3gE1+AvT0HbFVSs6tJQHv46J6MME+ZS0N8p/tg+ZDii4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774349976; c=relaxed/simple;
	bh=ijRt4IEBu6jXu2/b33PE62kMhyCMwsYCQrgcWKAXaZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lFnE6FPX9BXwogWhn/UJ05U18ACND5G7l4XGx5oLXa5y3htkscqU5zpi851v524VaKohggdazIDWHizdjSYgjbvZaudVzN8vBvUsJmcpfb2cbMEGHZTLWF4HXL8nK2wRAggRWs0swh5l1mw+Uu8i6hV41pIUxzf3ckVfrjfbfHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J+7CDTta; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J+7CDTta"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso43154245e9.3
        for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 03:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774349974; x=1774954774; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Hm6FcIelYRzr6kqaVU6QkNylXodkfysOhFYlFmBd98=;
        b=J+7CDTtagtirRw6Wrqmuw2GZdRh/fuLgSOzSDAeFOuPbyqfLZbthGLvhiXmdtydenT
         Rqi8tYvfcLbgj1QTTpUHb2O3riboi2KgnOEhnhxYJFlZ0LEVyL/c1ByapexsEJjiSTIH
         J9ZFRNQ6UtPpzsLzjfKXpay0cPiiwCOJOolO0I5QA+OEAJSf7j/WhVq2sOXBUHZ5s81j
         RJMmIDKy2VF/rIxCK7YS81WeIcY/ViAY1BXeG1iuVjniz3jZfCMvSwhD/Hld1EPj3reA
         tT2snrkb6Zj1bth+L2LJnDohJJIEnhq2ulf/gpYMFngZE+ZRAxnrlMJakHiz7T0nuSvv
         T0FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774349974; x=1774954774;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Hm6FcIelYRzr6kqaVU6QkNylXodkfysOhFYlFmBd98=;
        b=COotVnHQaspNll3xAlA9RKh/1D4oYCx5XHy0bYX7Q7+WyPMnMjV8JrEiXO8p0Q/QUL
         kwNxlMLfZxeqxGpyTyWXV56PhBN/Ue/yKRTAt4vdWb3MyHBXhgrR5inH4DuWneljq3T2
         RuYjR4vF8//ocCOF9jKZoXjmtMzgLHzLwej4jrVoPQ7MKJXSwkj+yROflBtkfP4COh5a
         kIWrKMsTtqO5TBBBVHpWkBBbGZcYJE1kYuaUsc17qB1wQWIr6wRsvMg9N/KLkL4sxdq2
         0N8UheqhxXB9rZgl+XKL78OH06ofxPyo3LtjD6BPBZvUQKlpW71k9zKhUK3gIjpQlKYn
         VRUA==
X-Forwarded-Encrypted: i=1; AJvYcCULb/4YytXlNiivLTcYP//OKLs3jckWviys22+v74GJRG9FqhuqLwi0ztlgLftHIdMPK38PFAs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzsmxlQQdZO2r6gtkcGo3YSzyOhvp35FJ6mDLEC01FXiO0Pivc1
	yuFfLzRRGRqsqLhNFSkWy/8HgWGe6cYQki2LK1Ja6X2iZygrjff41bQ4Pj1TnBrvaMypddXpjLw
	Pq1b/t9lQ
X-Gm-Gg: ATEYQzynnA+e/it0YoXk5wmMRmRqHvhcdnrao6DCQsUMLCicHrPI7vFlMioY5i9AoZa
	fVAgi8Z3S1vToV/yf52/+PPJqvtymgLylyny0Fk3ZN915Q8MfREvLs7rIDMDP17ycgXg1PRJiKB
	Lkho7ySiI5zJ8r8wly4osPfOvjULgV0zPSAUcz+lg7s0dCLgtSbhM9I0dTeydQaNCbMycnCh7ZE
	0aLH1q9mNNmxL5QL57rAzJ1u88Ze8K/MMd0ize8GPJPZi8iEB4reMVmuH9js10NeaNobG5Zdq5X
	gVqJGnZotdt7AcPJm8ivx5LoTnl7BoCFdgCyQ9NchcdiPLLkTjmqAEfDzt+t1QSHl9oT8x1IGYR
	JPBZU6HDEAHVU6TDw4YiMfGB0zh5+6BNihX0/wSvK9W+MQBqaUtThUVQytz1ezq4aIHz9bZpoNm
	MOPb3J3FuZtGb97Sfc9keH1e3D+vA2atqY7WqL/e3XlWOEM1fsH3zioC+JPKOYNbC8B6s=
X-Received: by 2002:a05:600c:1f86:b0:485:17a7:b9c7 with SMTP id 5b1f17b1804b1-486fedb551dmr229517615e9.10.1774349973232;
        Tue, 24 Mar 2026 03:59:33 -0700 (PDT)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4871102369fsm24686505e9.6.2026.03.24.03.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 03:59:32 -0700 (PDT)
Date: Tue, 24 Mar 2026 10:59:29 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: alexandru.elisei@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, catalin.marinas@arm.com,
	dbrazdil@google.com, joey.gouly@arm.com, kees@kernel.org,
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org,
	perlarsen@google.com, qperret@google.com, rananta@google.com,
	smostafa@google.com, suzuki.poulose@arm.com, tabba@google.com,
	tglx@kernel.org, bgrzesik@google.com, will@kernel.org,
	yuzenghui@huawei.com
Subject: Re: [PATCH 03/14] KVM: arm64: Support host MMIO trap handlers for
 unmapped devices
Message-ID: <acJukVJzZJEoPEyE@google.com>
References: <20260310124933.830025-1-sebastianene@google.com>
 <20260310124933.830025-4-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310124933.830025-4-sebastianene@google.com>

On Tue, Mar 10, 2026 at 12:49:22PM +0000, Sebastian Ene wrote:
> Introduce a mechanism to register callbacks for MMIO accesses to regions
> unmapped from the host Stage-2 page tables.
> 
> This infrastructure allows the hypervisor to intercept host accesses to
> protected or emulated devices. When a Stage-2 fault occurs on a
> registered device region, the hypervisor will invoke the associated
> callback to emulate the access.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h      |  3 ++
>  arch/arm64/include/asm/kvm_pkvm.h     |  6 ++++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 41 +++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/setup.c       |  3 ++
>  4 files changed, 53 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 3f9233b5a130..8fe1e80ab3f4 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -304,6 +304,9 @@
>  
>  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>  #define HPFAR_MASK	(~UL(0xf))
> +
> +#define FAR_MASK	GENMASK_ULL(11, 0)
> +
>  /*
>   * We have
>   *	PAR	[PA_Shift - 1	: 12] = PA	[PA_Shift - 1 : 12]
> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> index 48ec7d519399..5321ced2f50a 100644
> --- a/arch/arm64/include/asm/kvm_pkvm.h
> +++ b/arch/arm64/include/asm/kvm_pkvm.h
> @@ -19,9 +19,15 @@
>  
>  #define PKVM_PROTECTED_REGS_NUM	8
>  
> +struct pkvm_protected_reg;
> +
> +typedef void (pkvm_emulate_handler)(struct pkvm_protected_reg *region, u64 offset, bool write,
> +				    u64 *reg, u8 reg_size);
> +
>  struct pkvm_protected_reg {
>  	u64 start_pfn;
>  	size_t num_pages;
> +	pkvm_emulate_handler *cb;
>  };
>  
>  extern struct pkvm_protected_reg kvm_nvhe_sym(pkvm_protected_regs)[];
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 7c125836b533..f405d2fbd88f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -13,6 +13,7 @@
>  #include <asm/stage2_pgtable.h>
>  
>  #include <hyp/fault.h>
> +#include <hyp/adjust_pc.h>
>  
>  #include <nvhe/gfp.h>
>  #include <nvhe/memory.h>
> @@ -608,6 +609,41 @@ static int host_stage2_idmap(u64 addr)
>  	return ret;
>  }
>  
> +static bool handle_host_mmio_trap(struct kvm_cpu_context *host_ctxt, u64 esr, u64 addr)
> +{
> +	u64 offset, reg_value = 0, start, end;
> +	u8 reg_size, reg_index;
> +	bool write;
> +	int i;
> +
> +	for (i = 0; i < num_protected_reg; i++) {

This is potentially slow for a fast path. As this is an array, we could sort it
and do a binary search, just like find_mem_range?

> +		start = pkvm_protected_regs[i].start_pfn << PAGE_SHIFT;
> +		end = start + (pkvm_protected_regs[i].num_pages << PAGE_SHIFT);
> +
> +		if (start > addr || addr > end)
> +			continue;
> +
> +		reg_size = BIT((esr & ESR_ELx_SAS) >> ESR_ELx_SAS_SHIFT);
> +		reg_index = (esr & ESR_ELx_SRT_MASK) >> ESR_ELx_SRT_SHIFT;
> +		write = (esr & ESR_ELx_WNR) == ESR_ELx_WNR;
> +		offset = addr - start;
> +
> +		if (write)
> +			reg_value = host_ctxt->regs.regs[reg_index];
> +
> +		pkvm_protected_regs[i].cb(&pkvm_protected_regs[i], offset, write,
> +					  &reg_value, reg_size);
> +
> +		if (!write)
> +			host_ctxt->regs.regs[reg_index] = reg_value;
> +
> +		kvm_skip_host_instr();
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
>  void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
>  {
>  	struct kvm_vcpu_fault_info fault;
> @@ -630,6 +666,11 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
>  	 */
>  	BUG_ON(!(fault.hpfar_el2 & HPFAR_EL2_NS));
>  	addr = FIELD_GET(HPFAR_EL2_FIPA, fault.hpfar_el2) << 12;
> +	addr |= fault.far_el2 & FAR_MASK;
> +
> +	if (ESR_ELx_EC(esr) == ESR_ELx_EC_DABT_LOW && !addr_is_memory(addr) &&
> +	    handle_host_mmio_trap(host_ctxt, esr, addr))
> +		return;
>  
>  	ret = host_stage2_idmap(addr);
>  	BUG_ON(ret && ret != -EAGAIN);
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index ad5b96085e1b..f91dfebe9980 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -296,6 +296,9 @@ static int unmap_protected_regions(void)
>  			if (ret)
>  				goto err_setup;
>  		}
> +
> +		if (reg->cb)
> +			reg->cb = kern_hyp_va(reg->cb);
>  	}
>  
>  	return 0;
> -- 
> 2.53.0.473.g4a7958ca14-goog
> 

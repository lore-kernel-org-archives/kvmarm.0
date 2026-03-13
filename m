Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571492DECD3
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 09:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773394326; cv=pass; b=q3bKXsMy/utk5GKi+ySV383QliQo1jnrYghVyFdMLK0993sxDjqN2oxoJuhz5cgTNcoqqQhzI09hmhrbXhPRdQ92rmqvvzQFX08IuNJYfRHUay8D0YIT+OXL6xygbuk4eIjfF2fTyBsubkJA+MsL5WwXocMzAOzesyM3/FMfdiw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773394326; c=relaxed/simple;
	bh=LQf2QA/BSWJizXKvAd8/HyhQI4p1EMcNKWkvU7rKsrE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qg7ZHYl8FHaepzAYvXIH08Wory8QUcLD8jvkPLnFLo8ePrcv7mjmBOC9WxzF8GpgvuY9fj4JQCeZ7CU+7IveR7bR2GobdGQt3GZAfHRMv+lLFB7yKOcIGAkraHOL2fjyOWaKN/oYYWuQWpudrIrQbLGOZVnXDwiXmy1DryrPfgQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y/QXkFr4; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y/QXkFr4"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-509069a7a7fso409641cf.0
        for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 02:32:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773394324; cv=none;
        d=google.com; s=arc-20240605;
        b=Pp6YjOklVQHgwy09EXUjcpvcMF67vFefk4ajRiaoFg57AUV7AYuMSOscfg7eikU5Vf
         fpBf67JhlxSe703kk2kzGDwDzFhkYmMvZYowmOrZ0lPdBk+NJFO3Xbb5wM97DEt6nXD6
         cp16ZB1iGAUbbMB2QoQ/FErzoMT3Y+N4RoJFdmmdr7WSF7Xjkl9AkUokj6PTdCpS6pD2
         YYlQJZ/1ZKspxO0VDP01bIAWZJcOrUhH5eJQc7n4X5sjg8z7boyEo/Uh94cCmAIzImG1
         CNSLa4fvGvYHldZw04wx8r5RB6y+67WPU5TdsMdaGQ075f7pcprHdxTeqQ32/pXkJvsP
         x2vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UOSC1f3aHBzCl3KK3hWG1+INGM76umo/dTgcpAX5870=;
        fh=jWN2LjK4DYUlNWdcdZH1SVz+LeBOuNTb3FqQBllqf10=;
        b=j//VOMIupspX8n+hggWJ4/dhL2o1md290V75FW5vj6w9fTDU2JQ3gAzTm2Qe9jabhD
         VPDR8+Uc3/3u4yavfQCxW2s51TiajCcB0c8uQXqTX0MCLOAzIASgTVaahWoXSwu7sRkJ
         6vtmgHGvCLSsdcwC1Vva+4kHRHvnKHkp0TtzaJG4fLGG6DVY7vF/ZGfL33NlUXmUrbzd
         VQOoAbdPKYloNBX/7RLOijsqNIAB22oCiSXOSo5ApykTb+vom/hR/b9UglZd/jGunZQG
         2l+BexDZUZaAq+dqfn/1FA5ih5G0PalXbJBGl+/peFbrX0y69l9vzVzS4PUkNgBDxJST
         QvFw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773394324; x=1773999124; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UOSC1f3aHBzCl3KK3hWG1+INGM76umo/dTgcpAX5870=;
        b=Y/QXkFr4F1KuzqRnTmTWvO5mTJiOw46xeKyq+sZ5Xq2dldPHsQL9tClN6cwqdH/n+A
         6agHFyKf8McqfW0ijQ60+66u0ZoMKeRnhBEmIiHDnBFvq/7/8ykrramMX3vmI2+CBuVj
         bU+QJlm4n809rLS2j21fe2H3SQX8MW6+CMAdbJI1W99NmUm6RF+PlAHpSIPKAJVHWQ0J
         0dE7vA0mtRS42ZJOvqidC2K2n8RxHpDc70qRnXnFEE81Lm3A/Yv9D5POAuoCpT8HXAIb
         s3txf+iBprp/OxGE1NCTJ52ngADE91sJQAhTLLJ7pXdkqUb7vN3LRQpTeqYYg0K8etlq
         rFZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773394324; x=1773999124;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UOSC1f3aHBzCl3KK3hWG1+INGM76umo/dTgcpAX5870=;
        b=nS02hJa0yTejQvVS5tvwGFlbu7jXXXYD5bH2Cc9l/Int2g2d6ZQPrgan9i038ZC2AQ
         JkTqsaCW0WKiz6qBMuN70bEZStJu4nyR9Le8S5HZ6zbwNKD7nOtYneBHqjrDu+wYTqHn
         74nBSbZqP8cLDr+o9w4emb1pkzVA5hiFVj5cBxBVBz/gzmc0sjgMpNq5uMOxKqzcqAHL
         ssEjYFhKum0StO8tf6eSNJ7B9A86YNri26X2+wm8UKilsNWB9ADym2tn9L/totfLNVEC
         Nx/fdbvs+QefNd7rdIAJzOoIjHw7tdsUx5azFEOvEoAsjiuTKODIjFop0mwhuEkGoX6b
         SE9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUqulWtB6CaTtChStIGhZjsi5m5w1EzXqqSlGl94iuMUNd/xgQlsKXxqDvIH6HWlkWYLz21ykQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxKs7hER6tibLWtCxeQ4QKxqZTcL04T+jriMZ6AfQfxQ1w9kNAH
	mKhKuGedu5067gmdXi4ri2H/uj8dxWaQPD1foA1vhjPGJfAwyw+2f1VAjUfsLytcLGGBtMeJoAD
	ir8VRlrbiyDdMCA9bXQCuBIo+DerhW0YGFlIYeNbRpHwRS6ERJt4Hia7ZpXU=
X-Gm-Gg: ATEYQzzQiy8m3nqmb/UT3SnAas+PZbzW/GS8XfMhGRJ9TytQ9hw5npnf2mK7wwbUg3f
	PqV932ACaQ6GVvjhO9bHtWCxYtdmQkublLOkk7QMM8KNqSRd7bo+X+FkQdxy+3HcaYfi3zcI8wS
	mXba4gKpcSmYonUiXwPInbpg6E+MAh35d4cELenPwBXqyp5c+MUWM4Sepq+SI9YRUlvfA8WN8FF
	EJB6aosF9Cd9UW7waZKJl9ghLNatGEM9DR3zTbJa+NWTvOLdIvkV6LQleJazr85sGVQ9N3gaIP3
	sWpdBEVw
X-Received: by 2002:a05:622a:58c:b0:506:9852:75ec with SMTP id
 d75a77b69052e-50959e1d20cmr8802451cf.9.1773394323400; Fri, 13 Mar 2026
 02:32:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com> <20260310124933.830025-4-sebastianene@google.com>
In-Reply-To: <20260310124933.830025-4-sebastianene@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 13 Mar 2026 09:31:26 +0000
X-Gm-Features: AaiRm52JQRQHUrF8B2xDdFYmIZIopGCFBBCbq9bfvHcEIXMaU79zPtGVGBpWS1U
Message-ID: <CA+EHjTysM_02QHLOwKAnAA-uOFwC2GKezaMxyHyt365j8FR_ig@mail.gmail.com>
Subject: Re: [PATCH 03/14] KVM: arm64: Support host MMIO trap handlers for
 unmapped devices
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
>  #define HPFAR_MASK     (~UL(0xf))
> +
> +#define FAR_MASK       GENMASK_ULL(11, 0)
> +
>  /*
>   * We have
>   *     PAR     [PA_Shift - 1   : 12] = PA      [PA_Shift - 1 : 12]
> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> index 48ec7d519399..5321ced2f50a 100644
> --- a/arch/arm64/include/asm/kvm_pkvm.h
> +++ b/arch/arm64/include/asm/kvm_pkvm.h
> @@ -19,9 +19,15 @@
>
>  #define PKVM_PROTECTED_REGS_NUM        8
>
> +struct pkvm_protected_reg;
> +
> +typedef void (pkvm_emulate_handler)(struct pkvm_protected_reg *region, u64 offset, bool write,
> +                                   u64 *reg, u8 reg_size);
> +
>  struct pkvm_protected_reg {
>         u64 start_pfn;
>         size_t num_pages;
> +       pkvm_emulate_handler *cb;
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

Please sort includes alphabetically.

>
>  #include <nvhe/gfp.h>
>  #include <nvhe/memory.h>
> @@ -608,6 +609,41 @@ static int host_stage2_idmap(u64 addr)
>         return ret;
>  }
>
> +static bool handle_host_mmio_trap(struct kvm_cpu_context *host_ctxt, u64 esr, u64 addr)
> +{
> +       u64 offset, reg_value = 0, start, end;
> +       u8 reg_size, reg_index;
> +       bool write;
> +       int i;

What do you plan to do if there is no valid syndrome, i.e.,
ESR_EL2.ISV == 0? I am still reviewing, so maybe this is solved in a
future patch, or maybe you know that, in practice, all instructions
would have a valid syndrome. Regardless of which it is, you should
definitely add the following check to _this_ patch (or reconsider the
approach if it is possible to get legit accesses with ESR_EL2.ISV ==
0):

+      if (!(esr & ESR_ELx_ISV))
+              return false;

> +
> +       for (i = 0; i < num_protected_reg; i++) {
> +               start = pkvm_protected_regs[i].start_pfn << PAGE_SHIFT;
> +               end = start + (pkvm_protected_regs[i].num_pages << PAGE_SHIFT);
> +
> +               if (start > addr || addr > end)

Because end is calculated by adding the size, it represents the first
byte after the region, so this should be:
+               if (start > addr || addr >= end)
> +                       continue;

You also need to make sure that the entire access fits within the
protected region, to avoid a malicious or misaligned cross-boundary
access, i.e.:

+                if (addr + reg_size > end)
+                        return false;


> +               reg_size = BIT((esr & ESR_ELx_SAS) >> ESR_ELx_SAS_SHIFT);
> +               reg_index = (esr & ESR_ELx_SRT_MASK) >> ESR_ELx_SRT_SHIFT;
> +               write = (esr & ESR_ELx_WNR) == ESR_ELx_WNR;
> +               offset = addr - start;
> +
> +               if (write)
> +                       reg_value = host_ctxt->regs.regs[reg_index];

You need to handle the zero register (index 31) for writes, e.g.:
+                       reg_value = (reg_index == 31) ? 0 :
host_ctxt->regs.regs[reg_index];

> +
> +               pkvm_protected_regs[i].cb(&pkvm_protected_regs[i], offset, write,
> +                                         &reg_value, reg_size);
> +
> +               if (!write)
> +                       host_ctxt->regs.regs[reg_index] = reg_value;

and for reads:
+               if (!write & reg_index != 31)

Cheers,
/fuad

> +
> +               kvm_skip_host_instr();
> +               return true;
> +       }
> +
> +       return false;
> +}
> +
>  void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
>  {
>         struct kvm_vcpu_fault_info fault;
> @@ -630,6 +666,11 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
>          */
>         BUG_ON(!(fault.hpfar_el2 & HPFAR_EL2_NS));
>         addr = FIELD_GET(HPFAR_EL2_FIPA, fault.hpfar_el2) << 12;
> +       addr |= fault.far_el2 & FAR_MASK;
> +
> +       if (ESR_ELx_EC(esr) == ESR_ELx_EC_DABT_LOW && !addr_is_memory(addr) &&
> +           handle_host_mmio_trap(host_ctxt, esr, addr))
> +               return;
>
>         ret = host_stage2_idmap(addr);
>         BUG_ON(ret && ret != -EAGAIN);
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index ad5b96085e1b..f91dfebe9980 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -296,6 +296,9 @@ static int unmap_protected_regions(void)
>                         if (ret)
>                                 goto err_setup;
>                 }
> +
> +               if (reg->cb)
> +                       reg->cb = kern_hyp_va(reg->cb);
>         }
>
>         return 0;
> --
> 2.53.0.473.g4a7958ca14-goog
>

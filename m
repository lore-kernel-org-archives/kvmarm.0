Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831D3386C16
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 19:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773342357; cv=pass; b=Y3zH9JzJD7jtFLI+JgRD8thC8pfJPIjdnWHCd9Psw4xu1kWcsVFUc3+p+sMy+QulMfJaQEUk+T8TaADRSkyL1Gz1uWQKRzU1R7NDLjl0bfK/cUl2hm8WkvqLmSa0dEVtwmmM3gI+C4hpmci3BNQVLEBArPXLVc3uN12ROxrheWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773342357; c=relaxed/simple;
	bh=gBlMmEahncwFgLLdviWqI7n5S57ta1PfjxX3UmBN19Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kz/r6uwor5Dnj4puLzySyZJKb6U5rzGmwsTq5I+1eozwDbi5a+5U06CG0U3ChnuKBUArAkF5OlsoqaySjXwZVtAw/mHJR1nlMQhnV+JwOjsIVGL3Ugl+XzZ1hW9kDHkgwTFZY51N7TW5kVkH9VEuCvW4Q7OQWkrtU095AMds6lE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uZCBGijR; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uZCBGijR"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5091ed02c54so98761cf.1
        for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 12:05:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773342355; cv=none;
        d=google.com; s=arc-20240605;
        b=H5nJNhHCfIdPYfC3xUEEoR4G36S2vcp/PnZcxwGKu4IvdZns5j+Nse4KHpdlDUtyNW
         CUneflmrzNFvO/XUFYpZmN33wlQoXyqZPpYzwBpPxTiMIcpu3n4Q82FdHzkxEu82nLZn
         cUoAgIusiH1SQzf8eSJU71dBlnvWk2q/z7f0WE2OeUeXvLSmZnWJ8GmnSnhrU7yjFH48
         K+P1zZjdoxYJHNB7ffV8TnA5EqxOOhGCMea+2p2vTXBZAXc0SdoW2kn/7Z6KGWdkx7xu
         Tsy/FImLknNjkW+hsoD6CcDyRDrMvMwru/K1dp+pW+ajJqW+PKkeAHz6FtKaB0kvlu34
         TH/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=U6+OtjaK5kpQwDsWtWbZL7QFm/NMyVy7mbGZ1ghV8IA=;
        fh=JKYiQWFITgTs70lxYG2QhT5ZK7veQmjiNh5FSHpckYU=;
        b=etnnNsARlv9kk9ty/fcLQSoqiS9EExkivaKb0YvCO9Z0wHwPTkvJv3Hb5wOSSi8kHH
         /dUH/47d5oX+slJpHWc1nugWIFrRSS31NX9b3mMkKX0KArJH82qlasmMyVfymmQZnjto
         7IMbM0+TvGvgY8/Q9diy5NPEBGtLwL9kcBr/gPqdBhYrxZ9CauBAxwGFpV4lQfuNYNex
         Z0uaaKWGXgNiQBCxIRVjOVCiIod8c+7aOkBlrt4pkDUPq749iDtVRe7aQ8imWvl4pChl
         WPbO0Gk9kpscHo096f9viCpZ5fAfOqU1XP5HLRdYa5ugf9xtyYLvvs7BJs+IhJ18dXzg
         WldQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773342355; x=1773947155; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=U6+OtjaK5kpQwDsWtWbZL7QFm/NMyVy7mbGZ1ghV8IA=;
        b=uZCBGijRUbrVKrB5h+7FJ2H9jmmOOLAxh35PYBhBQU5ug4Rx9PDqFReSyWCooMalh8
         bEDn9Mhd8Ig1WDxWdjsHgXqscR8AsMNT2x+jxBbNLG4ilMKKuvC+8pePp5RCKf4alhXz
         X/fryWR8GZi0wjEWPwc1kl8PYAmcx3J6gfSf5oIvgC9WY7A+lyGk/RTLl0RQDdV5EYRi
         hTY46Wg9RXcZ0i9F1iDYuAoa3WOVTGQNCEY9Lval2D9qZ6xQ7PblamSjaKLCBRnuAdjd
         ycoNFrC6NdJZFVjyqSMXSytxd6RxXtmJBxU9FAbUHpmB8ea245FOSj/x2gOk4XE6Nzrl
         JkQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773342355; x=1773947155;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U6+OtjaK5kpQwDsWtWbZL7QFm/NMyVy7mbGZ1ghV8IA=;
        b=s++iL5k91li9Ur+MDTsy7PAlzwTIOPyM5qbZmzOzgMUXWSgJKqOikV2nkJ4xd0yaJP
         Fa/wJOynNF6k2AjomIXLmkHvrMrDM78KEySr0WO1ynj0sDNagho/n2Y9VOZ2LpRFbgGn
         Rfg4aFqwUJ4d/1g3UiaYhRgzEQn67K7J70qmdkkXIuFTeqvmWcLFtgOtTGlH7Vh2W/qG
         1tMMFHEAG5aMepklmXcPR1P7dImg2Bxq9PtHUMZC8trrO96LNk9Kvp+x1fghlWgIG/ik
         twWkfLb45Lgx8cduvO7hTkqeQPNbDoeqoFpN5IUQgsUMGcAg/MIAIxzStMTf8FyrpS8Z
         XyOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMyioXz2HJhcvAChJocWAoLvlMAveGPUCDbkckUH3NlgchzbvYTzxVtw9yuoM+6yzO0DDPp3I=@lists.linux.dev
X-Gm-Message-State: AOJu0YyQjgxGgoFnPbSCk12RbdWplH/G1m5PGbPRTAfW3z6razmI/wy2
	6lpra2G6VvGwj2yCrxEIbrowm2WS3wGH0rzoXL+DUF68O02OjoLuAZ/UU75Qz3fPnfOjp4Qa3k4
	nRNmNy9GQFynpM7CfNf4ANVZNFk6tSeO6iT3AKyDH
X-Gm-Gg: ATEYQzw4Aic8bGgU0WWh4h2Q5soe6SYo16hmM02GvpBZ/yd3f3EcoUTDZLr2XJIgESD
	ndDw3fVfn50ZmjvqP3a6nkHd271eCeZvwyDpoT6oeToRdPh9EQVcql8dyyb/iIx76Pa3BaYyWXo
	HKY8pSH7yJrfqjFV8f/HPTPQBs8jjiL3U+J5m9MJwg4TZ1BAlkzvPXN2xXb1HXAaFBPdQP6X2oQ
	PrHjd6jwjtBnoqgWU+AMKBxN/xj41LLoJ4lunp4WEkx++umIEK0awNo31cUeZWymhFaPeDexgqF
	4ft/b8xC
X-Received: by 2002:ac8:570e:0:b0:509:21ff:cd49 with SMTP id
 d75a77b69052e-509583f2b67mr2191931cf.4.1773342354514; Thu, 12 Mar 2026
 12:05:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com> <20260310124933.830025-3-sebastianene@google.com>
In-Reply-To: <20260310124933.830025-3-sebastianene@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 12 Mar 2026 19:05:16 +0000
X-Gm-Features: AaiRm50KV_wpisOqPhBXIc_wURyzMu0dLQv8LiQKoIvYnfkELQ5oUW5aGq7nCAA
Message-ID: <CA+EHjTwDkgF5GV-k_VZ_nXbmUmwrAXaQJ5sFsk2tgr8LL3j4DA@mail.gmail.com>
Subject: Re: [PATCH 02/14] KVM: arm64: Track host-unmapped MMIO regions in a
 static array
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
> Introduce a registry to track protected MMIO regions that are unmapped
> from the host stage-2 page tables. These regions are stored in a
> fixed-size array and their ownership is donated to the hypervisor during
> initialization to ensure host-exclusion and persistent tracking.
>
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/include/asm/kvm_pkvm.h     | 10 ++++++++++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c |  3 +++
>  arch/arm64/kvm/hyp/nvhe/setup.c       | 25 +++++++++++++++++++++++++
>  3 files changed, 38 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> index 757076ad4ec9..48ec7d519399 100644
> --- a/arch/arm64/include/asm/kvm_pkvm.h
> +++ b/arch/arm64/include/asm/kvm_pkvm.h
> @@ -17,6 +17,16 @@
>
>  #define HYP_MEMBLOCK_REGIONS 128
>
> +#define PKVM_PROTECTED_REGS_NUM        8
> +
> +struct pkvm_protected_reg {
> +       u64 start_pfn;
> +       size_t num_pages;
> +};
> +
> +extern struct pkvm_protected_reg kvm_nvhe_sym(pkvm_protected_regs)[];
> +extern unsigned int kvm_nvhe_sym(num_protected_reg);
> +
>  int pkvm_init_host_vm(struct kvm *kvm);
>  int pkvm_create_hyp_vm(struct kvm *kvm);
>  bool pkvm_hyp_vm_is_created(struct kvm *kvm);
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 0808367c52e5..7c125836b533 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -23,6 +23,9 @@
>
>  struct host_mmu host_mmu;
>
> +struct pkvm_protected_reg pkvm_protected_regs[PKVM_PROTECTED_REGS_NUM];
> +unsigned int num_protected_reg;
> +
>  static struct hyp_pool host_s2_pool;
>
>  static DEFINE_PER_CPU(struct pkvm_hyp_vm *, __current_vm);
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index 90bd014e952f..ad5b96085e1b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -284,6 +284,27 @@ static int fix_hyp_pgtable_refcnt(void)
>                                 &walker);
>  }
>
> +static int unmap_protected_regions(void)

I think the name of this function is confusing. It's not really
unmapping, it's donating the regions to hyp. Maybe
donate_protected_regions() or claim_protected_mmio_regions to reflect
that we are doing an ownership transfer?

> +{
> +       struct pkvm_protected_reg *reg;
> +       int i, ret, j = 0;

Please don't interleave the iterators with ret. Moreover, you can
define ret inside the loop below. Also, you don't need to initialze j.

> +
> +       for (i = 0; i < num_protected_reg; i++) {
> +               reg = &pkvm_protected_regs[i];
> +               for (j = 0; j < reg->num_pages; j++) {
> +                       ret = __pkvm_host_donate_hyp_mmio(reg->start_pfn + j);
> +                       if (ret)
> +                               goto err_setup;
> +               }
> +       }
> +
> +       return 0;
> +err_setup:
> +       for (j = j - 1; j >= 0; j--)
> +               __pkvm_hyp_donate_host_mmio(reg->start_pfn + j);

This rolls back the regions only for the latest `i` iteration, not all
the `i` iterations.

How about (not tested):

+    err_setup:
+       while (j--)
+           __pkvm_hyp_donate_host_mmio(reg->start_pfn + j);
+
+       while (i--) {
+           reg = &pkvm_protected_regs[i];
+           for (j = reg->num_pages - 1; j >= 0; j--)
+               __pkvm_hyp_donate_host_mmio(reg->start_pfn + j);
+       }

Thanks,
/fuad


> +       return ret;
> +}
> +
>  void __noreturn __pkvm_init_finalise(void)
>  {
>         struct kvm_cpu_context *host_ctxt = host_data_ptr(host_ctxt);
> @@ -324,6 +345,10 @@ void __noreturn __pkvm_init_finalise(void)
>         if (ret)
>                 goto out;
>
> +       ret = unmap_protected_regions();
> +       if (ret)
> +               goto out;
> +
>         ret = hyp_ffa_init(ffa_proxy_pages);
>         if (ret)
>                 goto out;
> --
> 2.53.0.473.g4a7958ca14-goog
>

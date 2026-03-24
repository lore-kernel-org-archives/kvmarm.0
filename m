Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00873E4C6A
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 10:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774349215; cv=none; b=jr/6FTNjuVB81eNGra2sBApozzHpd4E8eOL2aR/P/vxctRfMdLylCW1HNeqbWMz5c6hEFfxk6tPhH4El9WXMrYyFqanYY96LZlVtcjBP5AunN9dhRFhFEdqLPcVqrhaPO9glnvE2J6zTJW+nQnfBL6XVBGPUI8iut704uAKIZm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774349215; c=relaxed/simple;
	bh=fDCPfsGGlRnXeQiX7R1jXhS0JbRqxvUojvf0IB9Ne3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fe8gAv8byIUqwh9cBAcJwJQCbLNJtkZdB7UFlE2iKHUjAGqP1LMpArTcAvaiK6NdbsVJhSbd1GvI9A/KQLIwTJzXN3xglXwtm6mDgLGz1JKZPkrSuVN97z845+7/F8JNKy7vOZAA3pFVyEVcfOovMjVO/D5RLd4wB82J1Eqwqc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zh71q/vk; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zh71q/vk"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-486fb112c09so33955585e9.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 03:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774349209; x=1774954009; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BKbHXwptAaylPyPSr2r0cX4M87RTkTutiI0UCXtAsRA=;
        b=Zh71q/vkbDs7rUOCQQJSs7uWnxIz/FFEacUr8hinn6MeRMn8/ipx/MrU3KfhmHJKL5
         aekWRYMa+s08kL4eiEJEaRc7qh+PPGjmKClVW5l8zRzSz69H6LywF/wNfhB5UmdLFKst
         79gJ5QALUIsm5cuFSVsV6U44KYIvGTlK/sCzd8NGJW7PFav5lcipbxbI4GFBOCUhDzhG
         IVp5RsMKS0frHbEbLOTC2z3kqYeiSEFipSRrWSDpdz8g1UTukX9ZlZhZSD/oM49wAeEd
         Z685WTpKeX0TTZa3okRD8tlkN+BoFKoQ2u3aRf0lLkdGMxi+yqGZAaF2JXE+qAAKkcfX
         wsqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774349209; x=1774954009;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BKbHXwptAaylPyPSr2r0cX4M87RTkTutiI0UCXtAsRA=;
        b=otWVHw5QM8SX89ABbAvYMFJYo/tcYn021yy2czZ+9vrfagSAS0xsoTrNfewSdKgzYg
         3v46ukH7Vb1CBI5nNIT3cOQ72sTHCu7Rx4My46F/m1T4KbODvzAb6fHPWvOOY5siIrxi
         zMbbDGFTiGJp5iwlBB5yskkBPjhV9hLfXy8bzW/VpN5rMa8ggpcm45o43q2rE1cXpnYE
         ROWZNl/UY4oXnaEo6LFO8XuOaieCs+eofjHYi7C+0xVHDf4oxMo3oFuUWm8d6gnwBHRS
         CCESU9GdsESkzBZSXv2OiO+mXY2X3hOkZQhp99FChaikyHVOxElDvqoMxdIhccK6BmH8
         AWbQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9O8IYb7w9r4RRfFPzun1EVSwjwI2OaBMLzM/nlLUKLS+MtmKaMPSSZFgYBtAbjsslA0o4fQQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzw15m+fLh0t+5aJ34tkTLsjAzx/iaW5p47ixP6JNm7iaVcjLJf
	PDc41cqjvKGPt57ybSYJRaeMDH7YXitIbBpokjh85rFwP3hdbrLPhIWRViB+Lt+ghA==
X-Gm-Gg: ATEYQzwk3vYUavK+TO35pc5Fxndp4vSrl2X2+YT6/zB4rn4RtvSCL6TawhsNm0SSgho
	lbURFMjlY8kZNKn3YSYwfYXL7ybB8T8yUzDftBTE1b8VRBISO+xaDZFhX8RpKi32k/6hloiamK3
	gamp53VoCjdPus4aVWfshOviNfzePU40+H1EQ5B2B5h98knn5Q8BNoTEM958/xpAIIFnW1fU95V
	vX74AYCb1yC8g6tmK0ERw11+WtA2082Puk0GGjtbz+FpPcsGyUYZJoLGlk/PvkOCJqKkw9iplJS
	tzMwxRVfFw7NQ7LRVuf+irTdweNqruFl9gbKdzDKODpWJrbM3Ggov62duyfmNORqDdj/7O5P/Rt
	ANGj7HDA4bI31AzDj/U/WYU8EV+shCoVR0osmOO9FE7zfsRA40tC0UNy4+Sp4hbzbUdTeU6hGC6
	0eQPSbUibwhsLQPGzKjdpW/oKd1gNOlv5UP8U7jWI8D4jis6g7cYWtgHTd+W0ib9dFWsA=
X-Received: by 2002:a05:600c:698e:b0:486:f4d2:eac6 with SMTP id 5b1f17b1804b1-486fedd80c9mr200145585e9.13.1774349208987;
        Tue, 24 Mar 2026 03:46:48 -0700 (PDT)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-487116c0c13sm81982145e9.7.2026.03.24.03.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 03:46:48 -0700 (PDT)
Date: Tue, 24 Mar 2026 10:46:45 +0000
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
Subject: Re: [PATCH 02/14] KVM: arm64: Track host-unmapped MMIO regions in a
 static array
Message-ID: <acJrldyUBXgbvWw4@google.com>
References: <20260310124933.830025-1-sebastianene@google.com>
 <20260310124933.830025-3-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310124933.830025-3-sebastianene@google.com>

On Tue, Mar 10, 2026 at 12:49:21PM +0000, Sebastian Ene wrote:
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
> +#define PKVM_PROTECTED_REGS_NUM	8
> +
> +struct pkvm_protected_reg {
> +	u64 start_pfn; 
> +	size_t num_pages; 

nit: "u64 pfn, u64 nr_pages" to align with everywhere else.

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
>  				&walker);
>  }
>  
> +static int unmap_protected_regions(void)
> +{
> +	struct pkvm_protected_reg *reg;
> +	int i, ret, j = 0;
> +
> +	for (i = 0; i < num_protected_reg; i++) {
> +		reg = &pkvm_protected_regs[i];
> +		for (j = 0; j < reg->num_pages; j++) {
> +			ret = __pkvm_host_donate_hyp_mmio(reg->start_pfn + j);

If this is to make this static at boot, we don't even need __pkvm_host_donate_hyp_mmio()

We can just map the region early enough in the hypervisor pkvm_create_mappings()
in recreate_hyp_mappings() and then let fix_host_ownership() do the host
stage2 unmapping.

> +			if (ret)
> +				goto err_setup;
> +		}
> +	}
> +
> +	return 0;
> +err_setup:
> +	for (j = j - 1; j >= 0; j--)
> +		__pkvm_hyp_donate_host_mmio(reg->start_pfn + j);
> +	return ret;
> +}
> +
>  void __noreturn __pkvm_init_finalise(void)
>  {
>  	struct kvm_cpu_context *host_ctxt = host_data_ptr(host_ctxt);
> @@ -324,6 +345,10 @@ void __noreturn __pkvm_init_finalise(void)
>  	if (ret)
>  		goto out;
>  
> +	ret = unmap_protected_regions();
> +	if (ret)
> +		goto out;
> +
>  	ret = hyp_ffa_init(ffa_proxy_pages);
>  	if (ret)
>  		goto out;
> -- 
> 2.53.0.473.g4a7958ca14-goog
> 

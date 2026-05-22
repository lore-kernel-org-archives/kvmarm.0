Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CB928F948
	for <kvmarm@lists.linux.dev>; Fri, 22 May 2026 06:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779432832; cv=pass; b=oJufOtEFpY96H7gfCqZiADOvn3LVLQ4ggCxKhxKNRYOKbMhrsH+HYXE41Xi7GQbD6XBUB/bjJEF7R0B91yOAWV3SDIB3+LO91/BxxPyuIWEi5yRxZlo8ewn24jzfP9vqsHdC+4G1FHFBvmiMMrhCTBu+ZsQvfrXhIEcl74R54u4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779432832; c=relaxed/simple;
	bh=zVgnnWPG4brHuXd0XtR1WlXf27kG6Om6K0QKocfSaa8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HQHV10GRW36XSW36ycBuoIj9Cg6dnrKz/+flUaKNSr9CjlMluMsDOFcJ7vsIkkksWe5S67Hon1jhZM0eRtK1qYYMq9XrdHKG/jJkUs8c8VKuaehU/MX0wnSQns2gtmF76ltL5yARfmzwOAT20WXeh2DR2te4klDA4Ign+UXA8mk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mANcyoEe; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mANcyoEe"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-516d6009380so7781cf.0
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 23:53:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779432830; cv=none;
        d=google.com; s=arc-20240605;
        b=cXhy3kh5YG3AYP4jekPmdHtJmlZijBNAbwAs5EDKoSMEb7cActIo0p1HN5UZ45WqDg
         KPbsoQTDudFNkQGjMuh2c9xKp6ao6zLDzYFGO/PTCH6L27A/tGtKLZKdGNU0Y8vr4Ip7
         6rZjulC1A8++D1U1V7lqd00Pqg9VfMeMFm/EP/SX0fH712KF08qnPZIFb42SgFI0rEWr
         z6t3FqsbNHg3AauEC+HLfvZddg05eYSNEnGsReB/v0OidweaZdJ1U5RbfCqx8IDo0XJ6
         C6ZbSCVWh3cd9ooOBx8xwuH1blGDfyOr+S8AnTxpz5Xb/IfUXviLMmrlX/8ASziiCtxp
         zZpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=IQhHJfh4HJHIRKBbZ8MGHnuBEnB4lEtnjbMx9SjY/+8=;
        fh=EubMT37TfQ46ac9wc9+NPP2AFz7d4D1T7bbazxhvmDI=;
        b=DeNXvr08slIl/2Rg3RZB56riXUwK12Fa/5N6Cc33yEZswpgYh05BR6eEjvveRXdYj1
         Fk+koP49rdqCdkFfevk5hqVlIxOSaSAaxhIDDq9uA30fhA9HnK9sq9DgDpGvsKY4tPp9
         /f6GsSiF+/msF1UCV58Ue/K4ZEDGkk44mUGOg3VPzbrDRq16uayCq50QfhToAvr54HiJ
         kmmyg0QE/WrXr/8aioKkkYsbqheFyCQTDPds3WPwlhdI6h+27rVIEKLTWgv/4SA7SZy9
         BixqvvSRoifir9DZfOjyREbcDyMYGePxz7JkBCpUO7HDiBcr/BF9NIr7kOYz9bIOULJN
         FriQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779432830; x=1780037630; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IQhHJfh4HJHIRKBbZ8MGHnuBEnB4lEtnjbMx9SjY/+8=;
        b=mANcyoEeXFd0R2FFDxN+lv3ICtY3nko9wxSfjF/OglKp6Xp36UPFu9PFh86yTM8gLJ
         8S5oSssXgJhZlto+igGXYLuT3FhHSY17iby4yX43RkCnHRDCRLdeYHhYg34DHjkcPOXi
         Tj1OBye9p8PeqOVW3HZ9IQIuiP38IOZvS9e/jDeSDQDlDUqjPHNppjlMoc5Od1u/cpP9
         +K4p7tT9hiCvlQAzcCabWm+J76ZoWrfRgycHUiNqf6iHaAAl4m89mP3RLwNZ4sr3wkLP
         5yPcAb4TH16e2Yl09HbbZx7A6J7GE0hqfMAv7dWJVFgMjs5Q6V5ixrrMULCNtDN22cOj
         vfSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779432830; x=1780037630;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IQhHJfh4HJHIRKBbZ8MGHnuBEnB4lEtnjbMx9SjY/+8=;
        b=nauSjtZS8FvPSDA8Hc2q3v5wfAC/8ydcV7zhdbMcLQUuGiFwpQoL/pP+b1hl7qtpKn
         Y1JiUbx2ByghA0iKRQvplcMJPK6C8JLtH85Hexzvmqo418lnGZVeAjdWYTvFU/7WP0Mq
         D2uOgI0VS+MjBIMF2yHcL/QuGOU2u/yE7rbizGTuUOz/Dw2eEbg7otz20jn6YVEeZOwc
         EMisW+C1YIAs+fZ7PgnRaUYqqsLt/vFB1exjbDYAkUar8P056KU4Pu5rIoSl2Hmy+Oyd
         HMjivmh1U8Ac9ekZSPMy09640+ySNCc3kRvWyxB9P/Hz0sViHxgmGdyK38MoG+bPBFTp
         kTHw==
X-Forwarded-Encrypted: i=1; AFNElJ9Ye7DTzqJF1OOzqJzpFzlWyaudOhulp/LD/3FwbJkUjvdaaoGM9MeUSJTsYHnP0oZh0Cr0NK4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyo8KE/JvsyECUE/5Zl4YG9pEvv7LNqgRmtqhxt6PXDQFgl8Bdc
	aN58iIThoOE7a0eZHxRD7EZjdEUbrZ+113ll7hAYRnRqx6qjvG6wQErQd5kkRsob50rQPAHfWUh
	fLBXtLfA4jeBqRYSvVCjfYgtvxeVnJTNTcxByi25quMF00VkJFvaa9U+kUOs=
X-Gm-Gg: Acq92OEfCieHGDqbLVf2xks440CA+TzmVfWGbNLcEWVxoDKdMb1KNOsMEbZFT4zGhM6
	3wxwQeBHK35qFVBgeuIUE8yE2d5gmyWnmmJLV7lPTrVgwRpoqRqA2JtgHfmEtHCkXtYFqWWjecp
	qNLOHnqjy+HCBFcf4sC9XIilh5+dF9XAeL7iKQUrf6HpPSxziR9Jre+X5/DiNCCfCysrltVmEv1
	QDOE5Vb5aehbyFaVykneu9vAUmKcCGEAGTmpqPljkW72AcbNUgHODiMq4JDysF+ueI40BrOPQTn
	YeNwW9yuNA1O9LguL5g=
X-Received: by 2002:ac8:6653:0:b0:50f:ce97:3b84 with SMTP id
 d75a77b69052e-516d659cc80mr4717571cf.6.1779432829433; Thu, 21 May 2026
 23:53:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260521143626.1005660-1-vdonnefort@google.com> <20260521143626.1005660-2-vdonnefort@google.com>
In-Reply-To: <20260521143626.1005660-2-vdonnefort@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 22 May 2026 07:53:12 +0100
X-Gm-Features: AVHnY4Jv0EaljAyykPK_pB_vGkQ6vnQXEaJLoJjK1X2jGl3KFbAvDrfSZMVFdPk
Message-ID: <CA+EHjTykWtsRtHhz5epMU_qrG85nc2CJWGX=nv-X6kH3VGXe6A@mail.gmail.com>
Subject: Re: [RESEND v3 1/3] KVM: arm64: Reset page order in pKVM hyp_pool
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 21 May 2026 at 15:36, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> When a VM fails to initialise after its stage-2 hyp_pool has been
> initialised, that stage-2 must be torn down entirely. This requires
> resetting both the refcount and the order of its pages back to 0.
>
> Currently, reclaim_pgtable_pages() implicitly resets the page order by
> allocating the entire pool with order-0 granularity. However, in the VM
> initialisation error path, the addresses of the donated memory (the PGD)
> are already known, making it unnecessary to iterate over all pages in
> the pool.
>
> Since the vmemmap page order is a hyp_pool-specific field, leaving a
> non-zero order on hyp_pool destruction is harmless until another pool
> attempts to admit the page. Instead of resetting this field during
> destruction, reset it during pool initialization in hyp_pool_init().
>
> For 'external' pages, we can't trust the order either as they bypass
> hyp_pool_init(). Since we never coalesce them, enforce order-0 to ensure
> safe insertion into the pool.
>
> This leaves no vmemmap order users outside of hyp_pool.
>
> Fixes: 256b4668cd89 ("KVM: arm64: Introduce separate hypercalls for pKVM VM reservation and initialization")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 25f04629014e..fa447d400b71 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -217,7 +217,6 @@ static void *guest_s2_zalloc_page(void *mc)
>         memset(addr, 0, PAGE_SIZE);
>         p = hyp_virt_to_page(addr);
>         p->refcount = 1;
> -       p->order = 0;
>
>         return addr;
>  }
> @@ -322,7 +321,6 @@ void reclaim_pgtable_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc)
>         while (addr) {
>                 page = hyp_virt_to_page(addr);
>                 page->refcount = 0;
> -               page->order = 0;
>                 push_hyp_memcache(mc, addr, hyp_virt_to_phys);
>                 WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(addr), 1));
>                 addr = hyp_alloc_pages(&vm->pool, 0);
> diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> index a1eb27a1a747..57f86aa0f82f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> +++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> @@ -94,13 +94,22 @@ static void __hyp_attach_page(struct hyp_pool *pool,
>                               struct hyp_page *p)
>  {
>         phys_addr_t phys = hyp_page_to_phys(p);
> -       u8 order = p->order;
>         struct hyp_page *buddy;
> +       bool coalesce = true;
> +       u8 order = p->order;
>
> -       memset(hyp_page_to_virt(p), 0, PAGE_SIZE << p->order);
> +       /*
> +        * 'external' pages are never coalesced and their ->order field
> +        * untrusted as they bypass hyp_pool_init(). Enforce order-0.
> +        */
> +       if (phys < pool->range_start || phys >= pool->range_end) {
> +               order = 0;
> +               coalesce = false;
> +       }
> +
> +       memset(hyp_page_to_virt(p), 0, PAGE_SIZE << order);
>
> -       /* Skip coalescing for 'external' pages being freed into the pool. */
> -       if (phys < pool->range_start || phys >= pool->range_end)
> +       if (!coalesce)
>                 goto insert;
>
>         /*
> @@ -237,8 +246,10 @@ int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
>
>         /* Init the vmemmap portion */
>         p = hyp_phys_to_page(phys);
> -       for (i = 0; i < nr_pages; i++)
> +       for (i = 0; i < nr_pages; i++) {
>                 hyp_set_page_refcounted(&p[i]);
> +               p[i].order = 0;
> +       }
>
>         /* Attach the unused pages to the buddy tree */
>         for (i = reserved_pages; i < nr_pages; i++)
> --
> 2.54.0.746.g67dd491aae-goog
>

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 419C2C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Mar 2022 11:52:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EAEB49ED9;
	Wed,  9 Mar 2022 06:52:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BCQ2URj3wzmN; Wed,  9 Mar 2022 06:52:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77F2B49EE3;
	Wed,  9 Mar 2022 06:52:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECE7340597
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Mar 2022 15:21:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S9aMOX9cDffU for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Mar 2022 15:21:41 -0500 (EST)
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com
 [209.85.161.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B855D40453
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Mar 2022 15:21:41 -0500 (EST)
Received: by mail-oo1-f52.google.com with SMTP id
 h16-20020a4a6f10000000b00320507b9ccfso350504ooc.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Mar 2022 12:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=mime-version:in-reply-to:references:from:user-agent:date:message-id
 :subject:to:cc;
 bh=BVV59R1x/3zhBVnVWK6j4y0iat0LkIDDXlTtlhGa9CY=;
 b=lczPPxNy5R21bIe/J5VnIJ82n/HdZ51itN67PDK3dFFcZNEcl/9RrkIuEYhsC36C3g
 qQk2NsFOqKIGWMY1eCMWE6sJZpxOWyJCWCvi/k7rbaHNsf9EE9MzW4opqLPCCDtyexdd
 fwr+NlWKn7wteWokK2Sh7UnE4ODwU+UJmsiNE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:in-reply-to:references:from
 :user-agent:date:message-id:subject:to:cc;
 bh=BVV59R1x/3zhBVnVWK6j4y0iat0LkIDDXlTtlhGa9CY=;
 b=q5TQBOl6xm/6OgoEAlQdMN8z7CoUujEI5pNgc1gXlYFNCyMVDJq/Yb74YCwand8mdo
 QnDyzjk/OcEqnV/JgKTCn86zM0oVkQGYtAWgFNy3gtC+OoeuKwTmHXUNJAh7qTS1VNnd
 3KEEf9Nt2rvfFU+E6Q6hRsLW7TTTEzIFi0BoeRUWKMUl57LOo97VEYt+Ii1JogGu3Tjc
 hyKrXkTzClmUI0l1z/fFEUZAFKzHNcgd8gH5PL2I/ndHa7XdqZnWnVKmZomsG14RFXDV
 42bb0MRWNDyahzdyn4PhroLF4L+xIM5Dy4G2x/rcmTkpLatEimKI05QBvaXjLoPN8Ldw
 tahA==
X-Gm-Message-State: AOAM531+nmvssUQee6kVeeFk1wLj93vYoBJON5A5se4sTDbzs7XY8uwh
 C4sJJorl8XLjZAFByx/j4+/wmmUuDwlIbP4u1WpFlw==
X-Google-Smtp-Source: ABdhPJxYmuzkDSk5/9wnEE3vKsXmU2qpGFnLanLvP0kVx44q4gaJgGHUxdsVe+bSUC49eFC3IKpOiY0Mkly8Ik45/Ss=
X-Received: by 2002:a05:6870:d250:b0:da:b3f:3211 with SMTP id
 h16-20020a056870d25000b000da0b3f3211mr3461463oac.193.1646770901112; Tue, 08
 Mar 2022 12:21:41 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 8 Mar 2022 12:21:40 -0800
MIME-Version: 1.0
In-Reply-To: <20220307184935.1704614-2-kaleshsingh@google.com>
References: <20220307184935.1704614-1-kaleshsingh@google.com>
 <20220307184935.1704614-2-kaleshsingh@google.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 8 Mar 2022 12:21:40 -0800
Message-ID: <CAE-0n52LmVRkrSNN=eJf+TYYnmesVjFv99nnetYvRWshm82rOg@mail.gmail.com>
Subject: Re: [PATCH v5 1/8] KVM: arm64: Introduce hyp_alloc_private_va_range()
To: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Wed, 09 Mar 2022 06:52:31 -0500
Cc: kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
 will@kernel.org, Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, surenb@google.com,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Quoting Kalesh Singh (2022-03-07 10:48:59)
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index bc2aba953299..ccb2847ee2f4 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -457,22 +457,17 @@ int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
>         return 0;
>  }
>
> -static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
> -                                       unsigned long *haddr,
> -                                       enum kvm_pgtable_prot prot)
> +
> +/**
> + * hyp_alloc_private_va_range - Allocates a private VA range.
> + * @size:      The size of the VA range to reserve.
> + *
> + * The private VA range is allocated below io_map_base and
> + * aligned based on the order of @size.

Add what it returns?

Return: Start address of allocated VA range or some error value... (I don't
understand this part).

It may also be a good idea to write out what VA is in the description:

The private virtual address (VA) range is allocated below io_map_base

> + */
> +unsigned long hyp_alloc_private_va_range(size_t size)
>  {
>         unsigned long base;
> -       int ret = 0;
> -
> -       if (!kvm_host_owns_hyp_mappings()) {
> -               base = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
> -                                        phys_addr, size, prot);
> -               if (IS_ERR_OR_NULL((void *)base))
> -                       return PTR_ERR((void *)base);
> -               *haddr = base;
> -
> -               return 0;
> -       }
>
>         mutex_lock(&kvm_hyp_pgd_mutex);
>
> @@ -484,29 +479,53 @@ static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
>          *
>          * The allocated size is always a multiple of PAGE_SIZE.
>          */
> -       size = PAGE_ALIGN(size + offset_in_page(phys_addr));
> -       base = io_map_base - size;
> +       base = io_map_base - PAGE_ALIGN(size);
> +
> +       /* Align the allocation based on the order of its size */
> +       base = ALIGN_DOWN(base, PAGE_SIZE << get_order(size));
>
>         /*
>          * Verify that BIT(VA_BITS - 1) hasn't been flipped by
>          * allocating the new area, as it would indicate we've
>          * overflowed the idmap/IO address range.
>          */
> -       if ((base ^ io_map_base) & BIT(VA_BITS - 1))
> -               ret = -ENOMEM;
> +       if (!base || (base ^ io_map_base) & BIT(VA_BITS - 1))
> +               base = (unsigned long)ERR_PTR(-ENOMEM);

It looks odd to use an error pointer casted to unsigned long to return
from an address allocation function. Why not pass a pointer for base
like the function was written before and return an int from this
function with 0 for success and negative error value? Otherwise some
sort of define should made like DMA_MAPPING_ERROR and that can be used
to indicate to the caller that the allocation failed, or a simple zero
may work?

>         else
>                 io_map_base = base;
>
>         mutex_unlock(&kvm_hyp_pgd_mutex);
>
> -       if (ret)
> -               goto out;
> +       return base;
> +}
> +
> +static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
> +                                       unsigned long *haddr,
> +                                       enum kvm_pgtable_prot prot)
> +{
> +       unsigned long addr;
> +       int ret = 0;
> +
> +       if (!kvm_host_owns_hyp_mappings()) {
> +               addr = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
> +                                        phys_addr, size, prot);
> +               if (IS_ERR((void *)addr))

IS_ERR_VALUE()?

> +                       return PTR_ERR((void *)addr);
> +               *haddr = addr;
> +
> +               return 0;
> +       }
> +
> +       size += offset_in_page(phys_addr);
> +       addr = hyp_alloc_private_va_range(size);
> +       if (IS_ERR((void *)addr))

IS_ERR_VALUE()?

> +               return PTR_ERR((void *)addr);
>
> -       ret = __create_hyp_mappings(base, size, phys_addr, prot);
> +       ret = __create_hyp_mappings(addr, size, phys_addr, prot);
>         if (ret)
>                 goto out;
>
> -       *haddr = base + offset_in_page(phys_addr);
> +       *haddr = addr + offset_in_page(phys_addr);
>  out:
>         return ret;

Would be simpler to remove the goto, or return early.

	if (!ret)
		*haddr = addr + offset_in_page(phys_addr);

	return ret;

>  }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

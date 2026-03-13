Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE5738F644
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 11:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773401207; cv=pass; b=GkleYa3K32jrcYbJlVzBdsTbwk2vSYIzgpjtrsIYtzfqGXH2KU+IBWCplzBac4FrlT7OEWOhauOJYD2wCIAR++df5eIi+tQWQ+p3eksPol06Xj2MVYbGM0rgazzFyVeCpL9K2mEp7lf15zPdegbgmaxT9J7hV6LWSkyR/onLjok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773401207; c=relaxed/simple;
	bh=V6DXWvGeEADJtFlKIjTEeryleA8xREk2ln5w8UNwwe4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U3dL1g67+B4sntpczNjBcS3XbI/OuVL0D0fiFrqVu2mJllxSUMO5D1ENF5pJbTURCZnyOSKmx4IVneE64F0qIElllj+oBOZscLz2gnRX751lJ8xAZMCdBfFXDJxGHvGY3qliNt/Nah8AfMogI0QDCmK92EPOJWRQ03ZlHok6l70=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HCHN4YvZ; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HCHN4YvZ"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-509069a7a7fso447901cf.0
        for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 04:26:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773401202; cv=none;
        d=google.com; s=arc-20240605;
        b=lfwaMskxmkLduIRXLO/A5OmyDNkl9EBqUV+JMqoZMZ8TqY081lLFXkVn4b759O6zlE
         52zeEKzyI2aKgONxUlY4dCHWevwl9DTOJN98mG3RUZeWa5nuVAGtuNByJteha5lhGOPH
         xK/qGhCHHlekmwokHuGNG9ZL2sL+eu+FdxsJfhHUslowAU2z/4/oRbrwTE0XiOCVXcHD
         wtL+5opwtfYleG4cxj5aQTolmHNuYBf9QKbGW9e1DJfephtoL7NwLZP3R33S551Fx6o8
         mnNumo1gmY8dM4/0NXjVpd4sXx2BN4dDvhQv+0eMdf3nnhkqipdBRNaE3twCzEY87ihg
         LETQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=93a/ajUY9KbCyirHzQgJDIOJSm9GrnXAw6vYkTmjc4U=;
        fh=hZOYidE3HOuo1JsBVV7TUrurHrO/boLsuyT08kd+pl8=;
        b=OhFRADe3i3b1yk5ZhseZrFtc3mWLWRVIU2+zdp40yBOc6jafdK9E90ErFGItSB2rDg
         eWWz4/xoZLSpBrhCdN0UZwKztqoP8hNR+j4W4HHBVArSRBFB47TUjzS2Js7uSXoNJnRI
         tPhbwsbDLDXkkSLX6KUF2lrixKFq1mbamIDrTN3g4CZRehgLKN3MiCE4Ip8ux2W0n14o
         oglq4bBj6sM5dEG1rdRN82vixKVLJ1xx7ZXnjW2OFpAdyxFIIcho3yFq0Y94g2+xA6i9
         egnnkcK7gmrWynwP05rtjxAlSnvH6Now/Hcd6Fa4g/M2jGJt3niJIGGQlN8cCtlCQ6KW
         2Rpw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773401202; x=1774006002; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=93a/ajUY9KbCyirHzQgJDIOJSm9GrnXAw6vYkTmjc4U=;
        b=HCHN4YvZzV0qTovEfZFnQpa96oj9Up5m+/feiROHg2B0u8vevLevqtBqrh0b4VlYDG
         x4WI7i0UPYt0Crs9RlK8JLCiKeI9vJab0v8TjN7xvPTS3juL44oWFL97eGOHu9i7YZop
         wooydHTgvVStutX1MOjRMmEAF10WQHR8UKUOIsnCgiDzkrR/bR0gkwq9o2MPP0shxbiA
         dTxpP9mOmnIvrmb0Mc/Kv7voMq+aG2/+IJKtfZ4L6HdU/BlIo973aThum5nSlEvdfseS
         QZDVguSzWlibdCfP/dGgrniHtTcEDm22EPgJqv1Cm//ltuef+Vk+dUcJSYycfaKjoUF4
         x6cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773401202; x=1774006002;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=93a/ajUY9KbCyirHzQgJDIOJSm9GrnXAw6vYkTmjc4U=;
        b=IkcyTKRIj4fOD0hURNc5Q/BgyvS3uT1gW3OKq59eJ2mLg8MekeC8juMh4odpXpqmz1
         Tl82aWxEfyIZD/ckb2L6CsytOYbefTBfP3jyXmbSAdvMfDKMOThavjfL5fmw2SbeSt0g
         MLKjMEvcA9xeEWr2e47C/W+y5wPDeCiwu3baWnmYIHs7lPMPKQpbGER/nNZPS+0ZvYtQ
         4q1/mbsWr2x0loq4cnIohZKycvHxL8JRyWfoENmTLeTMY/0pszGp3+QkmpB3grO+zOjZ
         jYUh303Ipv+OMemBEyX+jsY0KDmxDkt0StI19ATU2adPQAIcCg4y9p7UF2IQEUeRHcHl
         N7PQ==
X-Forwarded-Encrypted: i=1; AJvYcCWm3EVzodsWj1AKwCgNKdsnkagTo4AfG2zhGDTvDt9MoIlb73zCXtKD9QWov3a46mMvOOTsTbA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyg+x+0EaFP39TJuaPFUMDhUjwfsDbxV0Ruzi+/HMa8tR5l+lAv
	cN18mn6+ZjkREfgNtOTTvX3qz557YZDZahr8glEySgkUTpN7TXrYkPUJePGGY4bpKT1yrP1FLYY
	mW4BzfkyaZFek6s3qxUuFdCKBEdLHwOOwHntKJm1e
X-Gm-Gg: ATEYQzxRc3F/mInLQMJoJ59gNso8co36o/OqCpgyi2nKD12GD5zaxpaoS4+Dsi42wTo
	Hjk0s6dWniFe3hDFC+vqoapeblqJRL7e7PJtZJtHSJrd9DXv10+GncwKyHqlbxhPHCmr07OkzND
	8UxiTqs4xkVaoHfD6ak0KGfwt8Y38NFDz+8WKXLoZ/s7pMtIHTWHiqO5MtpZciYVtARbC5jkpj2
	/MpjygIIpGg+OYwUVNzf+NoNrhNdDb3da1r3hHlJJVysM4taspOgGqn+3j/tmcGA4KGFC3uj+qz
	remLti53
X-Received: by 2002:a05:622a:1822:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-50958057fe8mr13018241cf.0.1773401201953; Fri, 13 Mar 2026
 04:26:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com> <20260310124933.830025-6-sebastianene@google.com>
In-Reply-To: <20260310124933.830025-6-sebastianene@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 13 Mar 2026 11:26:04 +0000
X-Gm-Features: AaiRm506PS2M6bHbNrexfaTVBhu4tRgY-VGbOWRtgRNjBqF-Kzvj9PkDoZSeW40
Message-ID: <CA+EHjTyG-rUp1M_4a=adBwqhAJ=JuHL5GaLmMBSi5o1ycaSu3A@mail.gmail.com>
Subject: Re: [PATCH 05/14] irqchip/gic-v3-its: Prepare shadow structures for
 KVM host deprivilege
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
> Expose two helper functions to support emulated ITS in the hypervisor.
> These allow the KVM layer to notify the driver when hypervisor
> initialization is complete.
> The caller is expected to use the functions as follows:
> 1. its_start_deprivilege(): Acquire the ITS locks.
> 2. on_each_cpu(_kvm_host_prot_finalize, ...): Finalizes pKVM init
> 3. its_end_deprivilege(): Shadow the ITS structures, invoke the KVM
>    callback, and release locks.
> Specifically, this shadows the ITS command queue and the 1st level
> indirect tables. These shadow buffers will be used by the driver after
> host deprivilege, while the hypervisor unmaps and takes ownership of the
> original structures.

Just a note again on preferring not to use the "shadow" terminology. I
thought about it a bit more, since these are not at the host, perhaps
"proxy" is a better term, to convey that the host is writing to a
middle-man buffer.

Another term is "staging," which is common in DMA: the host "stages"
the commands here, and EL2 "commits" them to the hardware.

>
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  drivers/irqchip/irq-gic-v3-its.c   | 165 +++++++++++++++++++++++++++--
>  include/linux/irqchip/arm-gic-v3.h |  24 +++++
>  2 files changed, 178 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 291d7668cc8d..278dbc56f962 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -78,17 +78,6 @@ struct its_collection {
>         u16                     col_id;
>  };
>
> -/*
> - * The ITS_BASER structure - contains memory information, cached
> - * value of BASER register configuration and ITS page size.
> - */
> -struct its_baser {
> -       void            *base;
> -       u64             val;
> -       u32             order;
> -       u32             psz;
> -};
> -
>  struct its_device;
>
>  /*
> @@ -5232,6 +5221,160 @@ static int __init its_compute_its_list_map(struct its_node *its)
>         return its_number;
>  }
>
> +static void its_free_shadow_tables(struct its_shadow_tables *shadow)
> +{
> +       int i;
> +
> +       if (shadow->cmd_shadow)
> +               its_free_pages(shadow->cmd_shadow, get_order(ITS_CMD_QUEUE_SZ));
> +
> +       for (i = 0; i < GITS_BASER_NR_REGS; i++) {
> +               if (!shadow->tables[i].shadow)
> +                       continue;
> +
> +               its_free_pages(shadow->tables[i].shadow, 0);
> +       }
> +
> +       its_free_pages(shadow, 0);
> +}
> +
> +static struct its_shadow_tables *its_get_shadow_tables(struct its_node *its)
> +{
> +       void *page;
> +       struct its_shadow_tables *shadow;
> +       int i;

Prefer RCT declarations.

> +
> +       page = its_alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO, 0);

This is called with the raw_spin_lock_irqsave held, and GFP_KERNEL can
sleep. You have one of two options, either use GFP_ATOMIC, but that's
more likely to fail. The alternative is to move this to
its_start_deprivilege(), before any lock is held.

> +       if (!page)
> +               return NULL;
> +
> +       shadow = (void *)page_address(page);
> +       page = its_alloc_pages_node(its->numa_node,
> +                                   GFP_KERNEL | __GFP_ZERO,
> +                                   get_order(ITS_CMD_QUEUE_SZ));
> +       if (!page)
> +               goto err_alloc_shadow;
> +
> +       shadow->cmd_shadow = page_address(page);
> +       shadow->cmdq_len = ITS_CMD_QUEUE_SZ;
> +       shadow->cmd_original = its->cmd_base;
> +
> +       memcpy(shadow->tables, its->tables, sizeof(struct its_baser) * GITS_BASER_NR_REGS);
> +
> +       for (i = 0; i < GITS_BASER_NR_REGS; i++) {
> +               if (!(shadow->tables[i].val & GITS_BASER_VALID))
> +                       continue;
> +
> +               if (!(shadow->tables[i].val & GITS_BASER_INDIRECT))
> +                       continue;
> +
> +               page = its_alloc_pages_node(its->numa_node,
> +                                           GFP_KERNEL | __GFP_ZERO,
> +                                           shadow->tables[i].order);
> +               if (!page)
> +                       goto err_alloc_shadow;
> +
> +               shadow->tables[i].shadow = page_address(page);
> +
> +               memcpy(shadow->tables[i].shadow, shadow->tables[i].base,
> +                      PAGE_ORDER_TO_SIZE(shadow->tables[i].order));
> +       }
> +
> +       return shadow;
> +
> +err_alloc_shadow:
> +       its_free_shadow_tables(shadow);
> +       return NULL;
> +}
> +
> +void *its_start_depriviledge(void)

Typo here and elsewhere in this patch:

s/depriviledge/deprivilege/g

This is particularly important because it also appears in exported
symbols as well (later in this patch).

> +{
> +       struct its_node *its;
> +       int num_nodes = 0, i = 0;
> +       unsigned long *flags;

RCT declaration order, and please untagle them, i.e., don't declare
the num_nodes and the iterator in the same line.

> +
> +       raw_spin_lock(&its_lock);
> +       list_for_each_entry(its, &its_nodes, entry) {
> +               num_nodes++;
> +       }
> +
> +       flags = kzalloc(num_nodes * sizeof(unsigned long), GFP_KERNEL_ACCOUNT);

Same as the other allocation. This can sleep. I think that for this as
well, it's better to move it before lock acquisition. Even if you use
a different allocator, it's still better to keep the critical section
short.

> +       if (!flags) {
> +               raw_spin_unlock(&its_lock);
> +               return NULL;
> +       }
> +
> +       list_for_each_entry(its, &its_nodes, entry) {
> +               raw_spin_lock_irqsave(&its->lock, flags[i++]);
> +       }
> +
> +       return flags;
> +}
> +EXPORT_SYMBOL_GPL(its_start_depriviledge);
> +
> +static int its_switch_to_shadow_locked(struct its_node *its, its_init_emulate init_emulate_cb)
> +{
> +       struct its_shadow_tables *hyp_shadow, shadow;
> +       int i, ret;
> +       u64 baser, baser_phys;
> +
> +       hyp_shadow = its_get_shadow_tables(its);
> +       if (!hyp_shadow)
> +               return -ENOMEM;
> +
> +       memcpy(&shadow, hyp_shadow, sizeof(shadow));
> +       ret = init_emulate_cb(its->phys_base, hyp_shadow);

You are performing this callback with the lock held and local
interrupts disabled. The hvc call is byitself expensive, especially
since it's going to do stage-2 manipulations.

You should decouple the synchronous pointer swapping (which must be
locked) from the hypervisor notification (which can be done outside
the lock). Instead of executing the callback inside the critical
section, its_end_deprivilege should:
- Lock everything.
- Perform the pointer swaps in the host driver structures.
- Save the hyp_shadow pointers to a temporary array.
- Unlock everything.
- Loop through the temporary array and call the KVM cb to notify EL2.

You should probably split this patch into two. The first patch would
implement the freeze/unfreeze locking mechanism, and the second would
swap the driver's internal memory pointers to the shadow structures,
and invoke the KVM callback to lock down the real hardware.

Cheers,
/fuad

> +       if (ret) {
> +               its_free_shadow_tables(hyp_shadow);
> +               return ret;
> +       }
> +
> +       /* Switch the driver command queue to use the shadow and save the original */
> +       its->cmd_write = (its->cmd_write - its->cmd_base) +
> +               (struct its_cmd_block *)shadow.cmd_shadow;
> +       its->cmd_base = shadow.cmd_shadow;
> +
> +       /* Shadow the first level of the indirect tables */
> +       for (i = 0; i < GITS_BASER_NR_REGS; i++) {
> +               baser = shadow.tables[i].val;
> +
> +               if (!shadow.tables[i].shadow)
> +                       continue;
> +
> +               baser_phys = virt_to_phys(shadow.tables[i].shadow);
> +               if (IS_ENABLED(CONFIG_ARM64_64K_PAGES) && (baser_phys >> 48))
> +                       baser_phys = GITS_BASER_PHYS_52_to_48(baser_phys);
> +
> +               its->tables[i].val &= ~GENMASK(47, 12);
> +               its->tables[i].val |= baser_phys;
> +               its->tables[i].base = shadow.tables[i].shadow;
> +       }
> +
> +       return 0;
> +}
> +
> +int its_end_depriviledge(int ret_pkvm_finalize, unsigned long *flags, its_init_emulate cb)
> +{
> +       struct its_node *its;
> +       int i = 0, ret = 0;
> +
> +       if (!flags || !cb)
> +               return -EINVAL;
> +
> +       list_for_each_entry(its, &its_nodes, entry) {
> +               if (!ret_pkvm_finalize && !ret)
> +                       ret = its_switch_to_shadow_locked(its, cb);
> +
> +               raw_spin_unlock_irqrestore(&its->lock, flags[i++]);
> +       }
> +
> +       kfree(flags);
> +       raw_spin_unlock(&its_lock);
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(its_end_depriviledge);
> +
>  static int __init its_probe_one(struct its_node *its)
>  {
>         u64 baser, tmp;
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 0225121f3013..40457a4375d4 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -657,6 +657,30 @@ static inline bool gic_enable_sre(void)
>         return !!(val & ICC_SRE_EL1_SRE);
>  }
>
> +/*
> + * The ITS_BASER structure - contains memory information, cached
> + * value of BASER register configuration and ITS page size.
> + */
> +struct its_baser {
> +       void            *base;
> +       void            *shadow;
> +       u64             val;
> +       u32             order;
> +       u32             psz;
> +};
> +
> +struct its_shadow_tables {
> +       struct its_baser        tables[GITS_BASER_NR_REGS];
> +       void                    *cmd_shadow;
> +       void                    *cmd_original;
> +       size_t                  cmdq_len;
> +};
> +
> +typedef int (*its_init_emulate)(phys_addr_t its_phys_base, struct its_shadow_tables *shadow);
> +
> +void *its_start_depriviledge(void);
> +int its_end_depriviledge(int ret, unsigned long *flags, its_init_emulate cb);
> +
>  #endif
>
>  #endif
> --
> 2.53.0.473.g4a7958ca14-goog
>

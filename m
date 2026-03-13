Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E37427B4F7
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 13:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773407457; cv=pass; b=Kp33mOXRS+djtkVYaMyriM8uhdQQsasUUzOieMWnkSEXpW1AUWYkzD66vSjVylEUuC4x73hrcHwxiQARGgi/LwbCYGvX+fRY2XWvnutbbpamDLa7gCEjd9yRxIc+dbF0MgnOc6vSu8aL8Gn02QXWnBzYnscv48ta7mMVz7xTfEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773407457; c=relaxed/simple;
	bh=BnjSPGFnRKRAkLq39cS6giGT0/tYWhc5mQC0dJ9sTnk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WJkzM4MO92l6Tb5kXmxtKElSomLHJmNJfxIVFqVZVfz+1nngwzDzpBxiHOIEKDXvYyNuIXoj6bBf8/AJ7scMp40naVfXXHGet67CYipOFJzbggeijtBOv/ZBTxHSkt3e4k33H1uofk4fNiYvietVB+ZA7F0JWa8az66R9Pq6nGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DZQx6k8y; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DZQx6k8y"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50906a98ffeso536371cf.0
        for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 06:10:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773407454; cv=none;
        d=google.com; s=arc-20240605;
        b=ekHQhAUGsoD/rBJT+Jfxs7xkrRlrNWpBGHFPULLgN5UdRI+sA3iNHcr6UtHniR2FSC
         GnP407jhO5K3PI50rPBU0RMeXCD5aCni4DMGmZhNEECdrPtZ8GOt251un+VEBws6I1SP
         /NUsYBikXUCn/A0igDpOgOuUO4e4usFcSkjbOVjzT4pyrQWA6jkpSwIlKoblh3wGJWwp
         PeQAtVmwIB7nrPtLGS8q7BOVW8mD15fHIcQz1ydhBTr3AHfRBvUc8btPPNkdqbJEkZZa
         klfmiwDpMA1DHu625Cmar2Qs8nGForYUm7+ZadSj1Fxd1j95WFQzbSx9okLSKXdSTO3g
         sE4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=k2824ihBrNFYuwpLFQ3XBkstk4E3T4O896zITIcBZAI=;
        fh=y5BJcUVtXd7sVMp5/GEZpJ5BFBR/ZGhL1hX33rHf6jo=;
        b=GrzysnhSaqH2aip4wPyDtAc7MO7cjkNB2ibXUxhGcBFxz+E2a9CxQ2b+2HEjQ+Pq7s
         OTfB3UcgmWG7VEWmum7G87qOyexXZU3N7EDPjFjXwQ6/RKGL7jop/6NzszHYtsYmJHgk
         5I2FGvnllNdDlkDINIsLHwAg4aQc362yoWgVKeDbHPS5OUHQE7AGHGTcJbL5+EICOwTO
         C1HY1hsvoI9i881bTLUe6pq4Cj7luLBHJwQKuHhkMRHQkhZ5tHHJDo9c+D/T7/ohying
         qBrrhD6bCkr1EXQe9dZ27Nd9jCO7OXsa23lkeupdmkD5bS9aTi/sp8LQdRr+ef45I05B
         BOow==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773407454; x=1774012254; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k2824ihBrNFYuwpLFQ3XBkstk4E3T4O896zITIcBZAI=;
        b=DZQx6k8y/bmo3oFQZTn1+WGgXDoFAUaSk7OYJY/nq9z0hNAWVj5GVRzW95Vw1PrKVP
         Ebq1TwqIWrbJP+Kt0Q4teW1caTATXt6pBguuouhmuDZSnJnD2lJSV28Yj+YZ0YBZPB7K
         nKjmb3jMU6H0nxaBBLi9STFAeJC0ySfCs8Zdx+M6OfofialJPZsviRp9+WTfk3QqSDVw
         X6rGwmoSKY0DfOpn+gSFI/pOlcIP6UrebatwpqCRCg7HM6KpVC8X0dUKOl1q8fS8HInp
         ZdvkvDAOM6mdTPlLxr9PAzx3MuSUalS1t7up1YqoS8ba1kjVl5L58F3AIJ0EJ9F4p+Sf
         4maQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773407454; x=1774012254;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k2824ihBrNFYuwpLFQ3XBkstk4E3T4O896zITIcBZAI=;
        b=ktAZF8RyPULeYvU9ZV5s4ETzAsPeE1XWkrqhgfA/m52Tsg8tq9TkaFqjtc4TTRtsXu
         evEMed7HkPecpMCjzPN0Rx9cySU5zSdttxGY8xxTM2LH3pEvVfPHaN7ykFSWm2D89s7r
         bkUUgL40SiqahV48Kt7XD2OHVDJloSFVhpwJV/B9YfPr3ApYISCUF/3kX7jlNZs/G9by
         KWPXoxEdKoGq7SEYO4MD3npRme7X1CgZD5MfQkZD8OEITSAclLmn1EiYI0zYqf9xXp4s
         R5n1NBAuQcPv7Xa7LML8bwZ+zUonjTkW9kPz8fXAHJi8g01v9luZ4zrNX206CabK+NjT
         JMTg==
X-Forwarded-Encrypted: i=1; AJvYcCXgFfHJwdgMV9ESh4kF02BTO3rRiPixfxMGo8BKwypeyxXpIoous5kgf8Vit6wqCRKs9+2ycPw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzHOiDMgYqkhc/vSgjlrHSUvMowusFWgMkiGLGqDthDpadAVg5S
	eX+rELubg5KE52aIXXCwwzwKhqmIvIuf0Z0tFmmf/M2QHiJplhLswzypwZpRpdxuKuSYhzdaQwU
	B702ptO1WfGZ8PPzgM8X4UF8yWjQNwXoyGfTTPBdq
X-Gm-Gg: ATEYQzwvB52bl9+Y2PU1KfFA07B5CUoO7PaNlzKy7iQB1kdZEtn5jKm4FufZAaSVyEn
	PNeCcOIAWbd6G9KnxlHatc6uMWBzdw9hJuvr2Zf4Q+M+i/bTr1y3a6gyYoNThFt9N7+rY1YBuih
	wZY1iRhzxKQJSmzwhnc8OONMUEqz9g58PyPcgtV6Vfv4UTcl/v7uLvCK1FymmW69i1REIEKyuOx
	gQclx/1cz5c83DmoOqs1xaHJN1G5XbknRu4181keUtSknO+CJa50RjW5bax2XGV39ThnhA+Z7tJ
	Tn2zYeRa
X-Received: by 2002:a05:622a:302:b0:4f3:54eb:f26e with SMTP id
 d75a77b69052e-50959d3390bmr8753721cf.1.1773407453607; Fri, 13 Mar 2026
 06:10:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com>
 <20260310124933.830025-6-sebastianene@google.com> <CA+EHjTyG-rUp1M_4a=adBwqhAJ=JuHL5GaLmMBSi5o1ycaSu3A@mail.gmail.com>
In-Reply-To: <CA+EHjTyG-rUp1M_4a=adBwqhAJ=JuHL5GaLmMBSi5o1ycaSu3A@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 13 Mar 2026 13:10:16 +0000
X-Gm-Features: AaiRm52ag_W_RZsir3EPL3s97XPPa2qdUtGLF9Hm3giVrEtDIbzHstdygFaONQg
Message-ID: <CA+EHjTx-Cs4VGB-K9pk5gss5j3Qjif4HAqqSdzP5TUzbjbc1EQ@mail.gmail.com>
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

On Fri, 13 Mar 2026 at 11:26, Fuad Tabba <tabba@google.com> wrote:
>
> Hi Sebastian,
>
> On Tue, 10 Mar 2026 at 12:49, Sebastian Ene <sebastianene@google.com> wrote:
> >
> > Expose two helper functions to support emulated ITS in the hypervisor.
> > These allow the KVM layer to notify the driver when hypervisor
> > initialization is complete.
> > The caller is expected to use the functions as follows:
> > 1. its_start_deprivilege(): Acquire the ITS locks.
> > 2. on_each_cpu(_kvm_host_prot_finalize, ...): Finalizes pKVM init
> > 3. its_end_deprivilege(): Shadow the ITS structures, invoke the KVM
> >    callback, and release locks.
> > Specifically, this shadows the ITS command queue and the 1st level
> > indirect tables. These shadow buffers will be used by the driver after
> > host deprivilege, while the hypervisor unmaps and takes ownership of the
> > original structures.
>
> Just a note again on preferring not to use the "shadow" terminology. I
> thought about it a bit more, since these are not at the host, perhaps
> "proxy" is a better term, to convey that the host is writing to a
> middle-man buffer.

I meant to say that, since these are not at the "hypervisor", or since
they *are* allocated in host.....

>
> Another term is "staging," which is common in DMA: the host "stages"
> the commands here, and EL2 "commits" them to the hardware.
>
> >
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  drivers/irqchip/irq-gic-v3-its.c   | 165 +++++++++++++++++++++++++++--
> >  include/linux/irqchip/arm-gic-v3.h |  24 +++++
> >  2 files changed, 178 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> > index 291d7668cc8d..278dbc56f962 100644
> > --- a/drivers/irqchip/irq-gic-v3-its.c
> > +++ b/drivers/irqchip/irq-gic-v3-its.c
> > @@ -78,17 +78,6 @@ struct its_collection {
> >         u16                     col_id;
> >  };
> >
> > -/*
> > - * The ITS_BASER structure - contains memory information, cached
> > - * value of BASER register configuration and ITS page size.
> > - */
> > -struct its_baser {
> > -       void            *base;
> > -       u64             val;
> > -       u32             order;
> > -       u32             psz;
> > -};
> > -
> >  struct its_device;
> >
> >  /*
> > @@ -5232,6 +5221,160 @@ static int __init its_compute_its_list_map(struct its_node *its)
> >         return its_number;
> >  }
> >
> > +static void its_free_shadow_tables(struct its_shadow_tables *shadow)
> > +{
> > +       int i;
> > +
> > +       if (shadow->cmd_shadow)
> > +               its_free_pages(shadow->cmd_shadow, get_order(ITS_CMD_QUEUE_SZ));
> > +
> > +       for (i = 0; i < GITS_BASER_NR_REGS; i++) {
> > +               if (!shadow->tables[i].shadow)
> > +                       continue;
> > +
> > +               its_free_pages(shadow->tables[i].shadow, 0);
> > +       }
> > +
> > +       its_free_pages(shadow, 0);
> > +}
> > +
> > +static struct its_shadow_tables *its_get_shadow_tables(struct its_node *its)
> > +{
> > +       void *page;
> > +       struct its_shadow_tables *shadow;
> > +       int i;
>
> Prefer RCT declarations.
>
> > +
> > +       page = its_alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO, 0);
>
> This is called with the raw_spin_lock_irqsave held, and GFP_KERNEL can
> sleep. You have one of two options, either use GFP_ATOMIC, but that's
> more likely to fail. The alternative is to move this to
> its_start_deprivilege(), before any lock is held.
>
> > +       if (!page)
> > +               return NULL;
> > +
> > +       shadow = (void *)page_address(page);
> > +       page = its_alloc_pages_node(its->numa_node,
> > +                                   GFP_KERNEL | __GFP_ZERO,
> > +                                   get_order(ITS_CMD_QUEUE_SZ));
> > +       if (!page)
> > +               goto err_alloc_shadow;
> > +
> > +       shadow->cmd_shadow = page_address(page);
> > +       shadow->cmdq_len = ITS_CMD_QUEUE_SZ;
> > +       shadow->cmd_original = its->cmd_base;
> > +
> > +       memcpy(shadow->tables, its->tables, sizeof(struct its_baser) * GITS_BASER_NR_REGS);
> > +
> > +       for (i = 0; i < GITS_BASER_NR_REGS; i++) {
> > +               if (!(shadow->tables[i].val & GITS_BASER_VALID))
> > +                       continue;
> > +
> > +               if (!(shadow->tables[i].val & GITS_BASER_INDIRECT))
> > +                       continue;
> > +
> > +               page = its_alloc_pages_node(its->numa_node,
> > +                                           GFP_KERNEL | __GFP_ZERO,
> > +                                           shadow->tables[i].order);
> > +               if (!page)
> > +                       goto err_alloc_shadow;
> > +
> > +               shadow->tables[i].shadow = page_address(page);
> > +
> > +               memcpy(shadow->tables[i].shadow, shadow->tables[i].base,
> > +                      PAGE_ORDER_TO_SIZE(shadow->tables[i].order));
> > +       }
> > +
> > +       return shadow;
> > +
> > +err_alloc_shadow:
> > +       its_free_shadow_tables(shadow);
> > +       return NULL;
> > +}
> > +
> > +void *its_start_depriviledge(void)
>
> Typo here and elsewhere in this patch:
>
> s/depriviledge/deprivilege/g
>
> This is particularly important because it also appears in exported
> symbols as well (later in this patch).
>
> > +{
> > +       struct its_node *its;
> > +       int num_nodes = 0, i = 0;
> > +       unsigned long *flags;
>
> RCT declaration order, and please untagle them, i.e., don't declare
> the num_nodes and the iterator in the same line.
>
> > +
> > +       raw_spin_lock(&its_lock);
> > +       list_for_each_entry(its, &its_nodes, entry) {
> > +               num_nodes++;
> > +       }
> > +
> > +       flags = kzalloc(num_nodes * sizeof(unsigned long), GFP_KERNEL_ACCOUNT);
>
> Same as the other allocation. This can sleep. I think that for this as
> well, it's better to move it before lock acquisition. Even if you use
> a different allocator, it's still better to keep the critical section
> short.
>
> > +       if (!flags) {
> > +               raw_spin_unlock(&its_lock);
> > +               return NULL;
> > +       }
> > +
> > +       list_for_each_entry(its, &its_nodes, entry) {
> > +               raw_spin_lock_irqsave(&its->lock, flags[i++]);
> > +       }
> > +
> > +       return flags;
> > +}
> > +EXPORT_SYMBOL_GPL(its_start_depriviledge);
> > +
> > +static int its_switch_to_shadow_locked(struct its_node *its, its_init_emulate init_emulate_cb)
> > +{
> > +       struct its_shadow_tables *hyp_shadow, shadow;
> > +       int i, ret;
> > +       u64 baser, baser_phys;
> > +
> > +       hyp_shadow = its_get_shadow_tables(its);
> > +       if (!hyp_shadow)
> > +               return -ENOMEM;
> > +
> > +       memcpy(&shadow, hyp_shadow, sizeof(shadow));
> > +       ret = init_emulate_cb(its->phys_base, hyp_shadow);
>
> You are performing this callback with the lock held and local
> interrupts disabled. The hvc call is byitself expensive, especially
> since it's going to do stage-2 manipulations.
>
> You should decouple the synchronous pointer swapping (which must be
> locked) from the hypervisor notification (which can be done outside
> the lock). Instead of executing the callback inside the critical
> section, its_end_deprivilege should:
> - Lock everything.
> - Perform the pointer swaps in the host driver structures.
> - Save the hyp_shadow pointers to a temporary array.
> - Unlock everything.
> - Loop through the temporary array and call the KVM cb to notify EL2.
>
> You should probably split this patch into two. The first patch would
> implement the freeze/unfreeze locking mechanism, and the second would
> swap the driver's internal memory pointers to the shadow structures,
> and invoke the KVM callback to lock down the real hardware.
>
> Cheers,
> /fuad
>
> > +       if (ret) {
> > +               its_free_shadow_tables(hyp_shadow);
> > +               return ret;
> > +       }
> > +
> > +       /* Switch the driver command queue to use the shadow and save the original */
> > +       its->cmd_write = (its->cmd_write - its->cmd_base) +
> > +               (struct its_cmd_block *)shadow.cmd_shadow;
> > +       its->cmd_base = shadow.cmd_shadow;
> > +
> > +       /* Shadow the first level of the indirect tables */
> > +       for (i = 0; i < GITS_BASER_NR_REGS; i++) {
> > +               baser = shadow.tables[i].val;
> > +
> > +               if (!shadow.tables[i].shadow)
> > +                       continue;
> > +
> > +               baser_phys = virt_to_phys(shadow.tables[i].shadow);
> > +               if (IS_ENABLED(CONFIG_ARM64_64K_PAGES) && (baser_phys >> 48))
> > +                       baser_phys = GITS_BASER_PHYS_52_to_48(baser_phys);
> > +
> > +               its->tables[i].val &= ~GENMASK(47, 12);
> > +               its->tables[i].val |= baser_phys;
> > +               its->tables[i].base = shadow.tables[i].shadow;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +int its_end_depriviledge(int ret_pkvm_finalize, unsigned long *flags, its_init_emulate cb)
> > +{
> > +       struct its_node *its;
> > +       int i = 0, ret = 0;
> > +
> > +       if (!flags || !cb)
> > +               return -EINVAL;
> > +
> > +       list_for_each_entry(its, &its_nodes, entry) {
> > +               if (!ret_pkvm_finalize && !ret)
> > +                       ret = its_switch_to_shadow_locked(its, cb);
> > +
> > +               raw_spin_unlock_irqrestore(&its->lock, flags[i++]);
> > +       }
> > +
> > +       kfree(flags);
> > +       raw_spin_unlock(&its_lock);
> > +
> > +       return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(its_end_depriviledge);
> > +
> >  static int __init its_probe_one(struct its_node *its)
> >  {
> >         u64 baser, tmp;
> > diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> > index 0225121f3013..40457a4375d4 100644
> > --- a/include/linux/irqchip/arm-gic-v3.h
> > +++ b/include/linux/irqchip/arm-gic-v3.h
> > @@ -657,6 +657,30 @@ static inline bool gic_enable_sre(void)
> >         return !!(val & ICC_SRE_EL1_SRE);
> >  }
> >
> > +/*
> > + * The ITS_BASER structure - contains memory information, cached
> > + * value of BASER register configuration and ITS page size.
> > + */
> > +struct its_baser {
> > +       void            *base;
> > +       void            *shadow;
> > +       u64             val;
> > +       u32             order;
> > +       u32             psz;
> > +};
> > +
> > +struct its_shadow_tables {
> > +       struct its_baser        tables[GITS_BASER_NR_REGS];
> > +       void                    *cmd_shadow;
> > +       void                    *cmd_original;
> > +       size_t                  cmdq_len;
> > +};
> > +
> > +typedef int (*its_init_emulate)(phys_addr_t its_phys_base, struct its_shadow_tables *shadow);
> > +
> > +void *its_start_depriviledge(void);
> > +int its_end_depriviledge(int ret, unsigned long *flags, its_init_emulate cb);
> > +
> >  #endif
> >
> >  #endif
> > --
> > 2.53.0.473.g4a7958ca14-goog
> >

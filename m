Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0E236829D
	for <kvmarm@lists.linux.dev>; Fri, 20 Mar 2026 15:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774019492; cv=none; b=bWTpxaXlbrEYcM83B6Ooq+8fvQWJtIuwDPvdC1bcdqIYD3AuVxFfuI6pNuJ+aFKz1SScO/bbdjFVsSug69D3eFndYrz4mkfnBDppIQ6OuI6mWp0AfuRiI4lQtnDopO8NaprfvMX2zMpZSMKxxC9KSZyXtTHWSEyxhaIliaMi/b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774019492; c=relaxed/simple;
	bh=j/WbqEa6GR3y2mTCugQOrFHZnZvN8+sLN4HawXV3F8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P4HDghNB981O6RqYsL5IDMKp7qK0kGjsFufNAG5CK4SM36WWS6VnHNto9vfuxWl6G1U/DKgqD1cKOZobYeIiFAIHLVmUat86K1+SDt8cMUKqe6t98MROU+60egXn2yzORHKjkThbaMPq7QUXr7ppbZSrRjfx7y3lVIpl6+XBA2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=adEglZ0X; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="adEglZ0X"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-661ce258878so11312a12.0
        for <kvmarm@lists.linux.dev>; Fri, 20 Mar 2026 08:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774019489; x=1774624289; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n+6917AKy85ED59+Qx+OnszYcZiLLVdHxeZpo7ufA5w=;
        b=adEglZ0XoJxyim8CQsjAz+AJ+Zz56bGfz8dramFEyZrMLSPV4WJZXbYazQxGLpHX0M
         VjV1iov2B5fYAGGPu+HEJY0tHEKZ6Bq2eZSRIzP/guS5JJnqKgh3PQ8oi8XN1qqpJw82
         JF4pIJKDMQXmU4yu4ZzMvnFQjFd8KdZNgru2albL63Vk+EilAjkXKhZ87gQ5hwCpYn1y
         vZbEDloJCRGyt+quQMLoq9Myj17XKuYrF27dx4DmVi85vkXj7sMWUend7Zb89ydkqkMP
         O8sXnlRsCbrjAun69QJBq/G1/FYK3KQhuxgK7aO2dP7rpKDYxSSiGKtygFHP/648JdhZ
         jtNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774019489; x=1774624289;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n+6917AKy85ED59+Qx+OnszYcZiLLVdHxeZpo7ufA5w=;
        b=k6n6mlqd5RcYvgNyPMiuhiewuMCBtBAx8IflMMsAA0PNkVwteUxYV2DXTSikisgPhm
         pB8h3gOTkCfGt/ElAJggfikAZOivtZbpqgVC0KQs9IBLbzl+8SQQkuCerd9KHJuyafeH
         KJqsyeQaPgT/+xV4T6PzpmjntANi4WmNUhu1v0CCcdEHyJhrVaoUT3BAbUu4yY23O7Co
         T+xEYkKRk18BV0ch10qv+Cri8Tzdrf7H1tXA//jdmbNPOg6cGu5KGX+zd6S6Nq5Z7FpI
         l+SpOH7qPbVKvUp4O9UHk5KYQTVCEVCDvbGMkM9IY2JTTrbLhXvjgSTAOqdfa06QxBg/
         3LoA==
X-Forwarded-Encrypted: i=1; AJvYcCX4njRvA3wuSzvTyw02daI/hLZE7Cs41/VsNDNL4zmxZvRzU1EJLPRQBiltwab4tObUZ1nf07w=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyz3Jb8tR6+VCu+V+JvLUbAi1H9DaKbJ+b51ILkSzuDk/wvHRy8
	OAYOEBxWOzoK3R396XrR+AwntCajS2yneOuGZuiS6S0/3axWPJv6WzkOplsuiYKlmw==
X-Gm-Gg: ATEYQzyU1lpg2YAkiT9GJQrENwDhmjKLCDuPdJL93lFYgm4HDC/FIAAiIgDDLr5I6cx
	uoC8vJdBpf9NgFlP9LppGNdQhbGlguDDrjyq2aZTbVLl6tvl0PnYptMXO2KmwrNmdkWzrCenBQ7
	MsZUHQfp6eiEkrofxYhElOmFxwpo7tDykQ68wIuAP3zA46a/kXw5u6cOIF5/3CrbGPAwA9ub84L
	rQh1F8tYDdTzbOgM0ZDlQyRd/zIy1HU3Qr+25a70/Q5iyoeZmEzRtgohe1cXXIUQu+UehtQFAsd
	tmt2wajBs/e3ZWxqY2rozXNzsJgMsfiV5TO2ejVvWEzHx6hDoOeT4UdwMr6xKORqW4uuV+nKc58
	HDItq+vqTZIbmoXfUtb5drrlnV29Yaafq/I9kWovpS01ez0BHhT3b4WRnf4CsYRENub6+MPXGZ0
	80NysdJkyhOSGJTNxrJn97rjsNH116xlM9/sT+TLrGDE82xjWOXPg8WAM/ivRxhPrwrY0=
X-Received: by 2002:aa7:c145:0:b0:665:17ce:4acb with SMTP id 4fb4d7f45d1cf-668cf308958mr49011a12.4.1774019488260;
        Fri, 20 Mar 2026 08:11:28 -0700 (PDT)
Received: from google.com (209.13.205.35.bc.googleusercontent.com. [35.205.13.209])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48700658441sm74243705e9.4.2026.03.20.08.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 08:11:27 -0700 (PDT)
Date: Fri, 20 Mar 2026 15:11:24 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: alexandru.elisei@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, catalin.marinas@arm.com,
	dbrazdil@google.com, joey.gouly@arm.com, kees@kernel.org,
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org,
	perlarsen@google.com, qperret@google.com, rananta@google.com,
	smostafa@google.com, suzuki.poulose@arm.com, tglx@kernel.org,
	vdonnefort@google.com, bgrzesik@google.com, will@kernel.org,
	yuzenghui@huawei.com
Subject: Re: [PATCH 05/14] irqchip/gic-v3-its: Prepare shadow structures for
 KVM host deprivilege
Message-ID: <ab1jnHvmIeh0PExw@google.com>
References: <20260310124933.830025-1-sebastianene@google.com>
 <20260310124933.830025-6-sebastianene@google.com>
 <CA+EHjTyG-rUp1M_4a=adBwqhAJ=JuHL5GaLmMBSi5o1ycaSu3A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTyG-rUp1M_4a=adBwqhAJ=JuHL5GaLmMBSi5o1ycaSu3A@mail.gmail.com>

On Fri, Mar 13, 2026 at 11:26:04AM +0000, Fuad Tabba wrote:

Hi Fuad,

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
> 
> Another term is "staging," which is common in DMA: the host "stages"
> the commands here, and EL2 "commits" them to the hardware.

Sure, happy to use one of the two indicated ones.

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

Thanks, I will try to move the allocation before the lock.

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

Ack, will fix this.

> > +{
> > +       struct its_node *its;
> > +       int num_nodes = 0, i = 0;
> > +       unsigned long *flags;
> 
> RCT declaration order, and please untagle them, i.e., don't declare
> the num_nodes and the iterator in the same line.
>

Ack,

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

I am afraid you can't do that because you can have dropped commands &
timeouts between these two steps. The driver might put commands in the
swapped queue and they will timeout.

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

Thanks,
Sebastian

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

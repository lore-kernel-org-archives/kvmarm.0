Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73CA3EE1E8
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 14:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774363044; cv=pass; b=D9F05yABGSI4KVnpr85nAilLIQg31ue4NGDT79HxWJgVN7hTvs4nH4pObxqM0KgiwicTZ81BPWBuaZjO27zhuDEMleR1gG2Eu+EusixJm/H7fiDxpYElJqlqPokk9iu+cQVhy1jN4IMNZvhqMbEUJBowLtQ+mqOfDLohPCvBC5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774363044; c=relaxed/simple;
	bh=IKqARYrKtFp5PaI7KSkYhwwj/tY6YMW3RhSGQm0Dby0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UCCbmGPdN5LfciVXnc2Q5OiLVEUrmuRJlzOfs/UAnHsCHfdl5q+MDJZ+3iq9JEEtoPTxiZB7hLAfbQ0AV16j35tf1orl55fyxpypfAxxkxw+4FITOcfAhgyc07AOpVoTRLSsNyA/WDWkA68HXtlUzpEhveZwsUXXd+4JU9BOroU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F3vwbjR0; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F3vwbjR0"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-509062d829dso585761cf.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 07:37:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774363042; cv=none;
        d=google.com; s=arc-20240605;
        b=BItbC3+ZDTHlagcPo2hGSqespd1dZVM2gfYOHM8AzLkk98PX39wykhdKmcgVXJqFRx
         +911UbY2PwWZSzuEPRSQa9kWl0hdX+CjzezBRNMT3t9jTVM7vLE7abDtJNPXhli6ViPU
         2vNiJl1vhNG3h1k6R4yGsDTQhC5YPLTWhXXeoTfdwaUZS3QLjkalLXz+U5bRQxvg6SJs
         MBBA9Mjc4tjWWOV4iEgO65QBxzCZpzVwgL+58BsD0SWkQW93V9AKSyC9Z/qv0trYUj1t
         ZGX6GRNW5oXvj3QlYvmedqUyFRSBiCv0ywMVcUVZ++4t5q65QjXyw83Y/fCDjNfzVw/Z
         H21g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ot/g66ED1b3E4j/YAPW1gMfq9DWygqkYzjEZrylBGUs=;
        fh=3RSaEYDXKWMDveWLH9Ek/wOyglNW514Wmv6cQce4gWM=;
        b=Rn4jWlP18UCHi0POt2wnFSGwUEtCTX+IDDzEmxi3AblPwfTTHblbqwcELmX398UXDl
         rk973+/TPUVqPl+mAJ9yqTbDvj/pnHrvQT+0fgRP954aS3XeeBslkksJDWqO9NPGOLQC
         YwbH+nubL++0OPwVLnbKKUmOTp1KhBDo+CjW6D17n6hRPZYSF1DAmsE47aIgl11jrUUZ
         CLevoaKG3avZt7Xqa0CtTA8kCNK1qcSGjDLB9VNSyKWhJ3MwGhETfeyDiSUknlvUVU+1
         WQg8ztuTWur+1+5uhWsICk33AiVArMRdm67euUwpZf6RJtoV5VCaU37GJ+2npzUUrKhP
         0Ltg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774363042; x=1774967842; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ot/g66ED1b3E4j/YAPW1gMfq9DWygqkYzjEZrylBGUs=;
        b=F3vwbjR0J+GlQnZq3nu6jgpkCMO2z4OFG0tw7HeFGLW3dx2opv48Ai/AekepcFEuBY
         /dJ8x9bbWfrfNFd7Khq4CjDLc5qXQPjWB7xJMOaBOrka+HLXl5hU3JX5cZrTl8xb0z7z
         5X+XBfzXnDXC3y7fKLTWJpLgmFr0rsOdtkT8mRxjLst9gDFVhj4rx9vDSlg3JR1Fiyel
         0FDaY/6rncT/rRWU0jGjjwDoZJ53sXupphOtA65hZKVjtlVyTUzZfzPqAt8dctsHizOy
         jWtXf61KTyZ7yUNmdzBGHgPK77OEQ+ZxRlLi4RED+iwChMLKhjxZhu53d2Fqgji490a/
         MFrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774363042; x=1774967842;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ot/g66ED1b3E4j/YAPW1gMfq9DWygqkYzjEZrylBGUs=;
        b=Q3Uprxz6XfELOBOOF5HSEiph9pCKfkSJhbcdIMuj9ajiwqDFamfQmckF5htdcESeFp
         /FUe4XwPS/BKRBbEFamuPdSwvzd6jaNUtlJlO3g5uMNKogZPeBd70/XOQ2xeCx1T+nB8
         mIItkCnY7e7+KR7Wzk8sTnSVfZehfhCzQx+4AxrUaxYBIZpoafwJlbAjl6szCyQanVer
         2hRIRmaJymikIqRapNlV/REenjgLka1AX6/OTzB28fCN+6gDP5a3roxVtICSPL5eqq2f
         fP9LsiY2zpQ64MLYQlvW+Hq3f+BeyBzCSWsKrXYZL6+ISLajxp5CMOvRgP9p1+heuW+1
         W0Rg==
X-Forwarded-Encrypted: i=1; AJvYcCUOX1uStwoysbtTDC6RA/ntP2lnddagBg/xtKOIScthSywfXYqRwkzUiq9RaNarOxpvA9aWVyE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwFdQxWzb9o4Q4z7fxSgk01pfyy0NJLVCvTzQavo1KsnT59HprG
	l76SyM6AT8vV3FJ6+vKypSdIHBXSvl3JaGVqBnTWu7Cm0UVr83K4Vae+EtOrVU2wcAkBSuLqsZs
	qbV1C1t25dO62NNsGTlb01Q6sUt+bVMoe0irx1CjV
X-Gm-Gg: ATEYQzwZb3n+6zBmyBoZiRoY64WiEvCHKCqhT7ED7342ITAHn34Ccykkz2D4vzwvB7+
	klYK+F8+UqcPFB8VqCwwRbGAp5lHeAMpg6lihy4k+JndH4EF5+1+ZojPbO8llWms5x8YcU3UeB+
	x+yKfYK9LA7egPBogpyIEYGhXCKmovW/PhqZ0qt/mBD7grIMqteZuEEGayoZd9BN2TpkB2okhX3
	pK/wnMgeBJa63lWRf6hVKy3bvwofAibb5I5RS3O9b5Uz5uId9LhzoXPV1uv2Zh6lGYJvZrGLyPy
	CRgFEO9DglTaOKXNu2dQvOdRQDcnidvSTHbM
X-Received: by 2002:a05:622a:20a:b0:4ed:8103:8c37 with SMTP id
 d75a77b69052e-50b6fb96461mr15215721cf.12.1774363041055; Tue, 24 Mar 2026
 07:37:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com>
 <20260310124933.830025-6-sebastianene@google.com> <CA+EHjTyG-rUp1M_4a=adBwqhAJ=JuHL5GaLmMBSi5o1ycaSu3A@mail.gmail.com>
 <ab1jnHvmIeh0PExw@google.com>
In-Reply-To: <ab1jnHvmIeh0PExw@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 24 Mar 2026 14:36:43 +0000
X-Gm-Features: AQROBzDy-GT9f8lanLVQaWs787bpI3GrHwllCWBkC0bZltTZW20kHdI-Z7YOLIg
Message-ID: <CA+EHjTwW_tUghZnqJcR5LByX4fPpdocGnM5FFA=4+CfPWpXOrA@mail.gmail.com>
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

Hi Seb,

<snip>

> > You should decouple the synchronous pointer swapping (which must be
> > locked) from the hypervisor notification (which can be done outside
> > the lock). Instead of executing the callback inside the critical
> > section, its_end_deprivilege should:
> > - Lock everything.
> > - Perform the pointer swaps in the host driver structures.
> > - Save the hyp_shadow pointers to a temporary array.
> > - Unlock everything.
>
> I am afraid you can't do that because you can have dropped commands &
> timeouts between these two steps. The driver might put commands in the
> swapped queue and they will timeout.

You're right, that won't work. Simply releasing the lock between the
pointer swap and the hypercall (HVC) isn't safe for two reasons:
- Timeouts (your point): If we swap the pointers to the new shadow
queue and drop the lock, another CPU might immediately try to queue a
command. It will trap to EL2 (cwriter_write), but because the HVC
hasn't finished initializing the hypervisor's internal state
(region->priv), EL2 will
drop the MMIO write. The host will then spin in
its_wait_for_range_completion waiting for the hardware to process a
command it never saw, resulting in a timeout.
- Stage-2 Aborts: Conversely, if we try to run the HVC before swapping
the pointers, the HVC will actively unmap (donate) the original
queue's memory to EL2. If the host is not locked and tries to write to
the old queue during this window, it will trigger a Stage-2 Data Abort
and boom!

We must pause host command submission to the affected ITS while the
HVC is running. That said, I still don't think it's acceptable to do
what you propose in this patch. This holds the raw_spin_lock_irqsave
for way too long, keeping local interrupts disabled while performing
slow hypercalls for the entire system.

I had a bit of a think, and I have two ideas, one is an improvement,
but not a full solution. It's simple though, and it might be enough
for now and I am more confident that it works. The second one is a
better solution I think, assuming it works and I haven't missed
anything :)

Option A: Granular Locking (Per-ITS Lock & HVC)

In this patch its_start_depriviledge effectively locks *all* ITS nodes
in the system simultaneously. Then, its_end_depriviledge calls the HVC
for every single ITS sequentially, while the CPU is still holding all
the locks with interrupts globally disabled. This makes this critical
section very long. Making it shorter is pretty straightforward i
think...

Instead of trying to decouple the pointer swap from the HVC, we can
start by reducing the scope of the lock. We remove the global locking
in its_start_depriviledge. Inside its_end_depriviledge, we process one
ITS at a time:
1. Disable local interrupts and lock one specific ITS
(raw_spin_lock_irqsave(&its->lock)).
2. Perform the pointer swap AND the HVC for this specific ITS.
3. Unlock and re-enable local interrupts (raw_spin_unlock_irqrestore).
4. Move to the next ITS in the list.

This should be simple to implement. It guarantees zero dropped
commands and zero aborts because the swap and HVC remain atomic.
However, the CPU executing the deprivilege still holds a raw spinlock
during a hypercall, but the duration is reduced to a single ITS node
rather than the entire thing.

Option B: Software Quiescence (Driver-Level Pausing)
To make it so that the HVC runs outside of an atomic context (with
local interrupts enabled), maybe we can teach the ITS driver to
voluntarily pause command submission without holding the raw spinlock.

I was thinking that we introduce a new state flag, e.g.,
is_vmm_migrating, to struct its_node. Every ITS command goes through
the BUILD_SINGLE_CMD_FUNC macro. We modify this macro so that if a CPU
tries to send a command and sees this flag is true, it temporarily
drops the lock, re-enables its interrupts, spins (cpu_relax()), and
retries.

The deprivilege sequence per ITS then becomes:
1. Lock: Acquire its->lock.
2. Swap & Pause: Swap the pointers to the shadow queue and set
its->is_vmm_migrating = true.
3. Unlock: Drop its->lock and re-enable interrupts. (Any other CPU
trying to send a command to this ITS will now safely spin and wait).
4. The HVC: Execute the slow hypercall safely outside of atomic context.
5. Resume: Re-acquire its->lock, set its->is_vmm_migrating = false,
and drop the lock. (This wakes up any spinning CPUs, and they
immediately send their commands to the newly registered shadow queue).

The HVC runs safely with local interrupts enabled, guaranteeing that
no commands are dropped or sent to unmapped memory. If a hardware
interrupt fires on another CPU that requires sending an ITS command
exactly while the HVC is running, that CPU will be forced to spin.
However, this is no worse than aquiring locks, where that CPU would
have been spinning waiting for the raw spinlock anyway.

What do you think?

If you like, I could hack something and we could discuss it some more.

Cheers,
/fuad


>
> > - Loop through the temporary array and call the KVM cb to notify EL2.
> >
> > You should probably split this patch into two. The first patch would
> > implement the freeze/unfreeze locking mechanism, and the second would
> > swap the driver's internal memory pointers to the shadow structures,
> > and invoke the KVM callback to lock down the real hardware.
> >
> > Cheers,
> > /fuad
> >
>
> Thanks,
> Sebastian
>
> > > +       if (ret) {
> > > +               its_free_shadow_tables(hyp_shadow);
> > > +               return ret;
> > > +       }
> > > +
> > > +       /* Switch the driver command queue to use the shadow and save the original */
> > > +       its->cmd_write = (its->cmd_write - its->cmd_base) +
> > > +               (struct its_cmd_block *)shadow.cmd_shadow;
> > > +       its->cmd_base = shadow.cmd_shadow;
> > > +
> > > +       /* Shadow the first level of the indirect tables */
> > > +       for (i = 0; i < GITS_BASER_NR_REGS; i++) {
> > > +               baser = shadow.tables[i].val;
> > > +
> > > +               if (!shadow.tables[i].shadow)
> > > +                       continue;
> > > +
> > > +               baser_phys = virt_to_phys(shadow.tables[i].shadow);
> > > +               if (IS_ENABLED(CONFIG_ARM64_64K_PAGES) && (baser_phys >> 48))
> > > +                       baser_phys = GITS_BASER_PHYS_52_to_48(baser_phys);
> > > +
> > > +               its->tables[i].val &= ~GENMASK(47, 12);
> > > +               its->tables[i].val |= baser_phys;
> > > +               its->tables[i].base = shadow.tables[i].shadow;
> > > +       }
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +int its_end_depriviledge(int ret_pkvm_finalize, unsigned long *flags, its_init_emulate cb)
> > > +{
> > > +       struct its_node *its;
> > > +       int i = 0, ret = 0;
> > > +
> > > +       if (!flags || !cb)
> > > +               return -EINVAL;
> > > +
> > > +       list_for_each_entry(its, &its_nodes, entry) {
> > > +               if (!ret_pkvm_finalize && !ret)
> > > +                       ret = its_switch_to_shadow_locked(its, cb);
> > > +
> > > +               raw_spin_unlock_irqrestore(&its->lock, flags[i++]);
> > > +       }
> > > +
> > > +       kfree(flags);
> > > +       raw_spin_unlock(&its_lock);
> > > +
> > > +       return ret;
> > > +}
> > > +EXPORT_SYMBOL_GPL(its_end_depriviledge);
> > > +
> > >  static int __init its_probe_one(struct its_node *its)
> > >  {
> > >         u64 baser, tmp;
> > > diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> > > index 0225121f3013..40457a4375d4 100644
> > > --- a/include/linux/irqchip/arm-gic-v3.h
> > > +++ b/include/linux/irqchip/arm-gic-v3.h
> > > @@ -657,6 +657,30 @@ static inline bool gic_enable_sre(void)
> > >         return !!(val & ICC_SRE_EL1_SRE);
> > >  }
> > >
> > > +/*
> > > + * The ITS_BASER structure - contains memory information, cached
> > > + * value of BASER register configuration and ITS page size.
> > > + */
> > > +struct its_baser {
> > > +       void            *base;
> > > +       void            *shadow;
> > > +       u64             val;
> > > +       u32             order;
> > > +       u32             psz;
> > > +};
> > > +
> > > +struct its_shadow_tables {
> > > +       struct its_baser        tables[GITS_BASER_NR_REGS];
> > > +       void                    *cmd_shadow;
> > > +       void                    *cmd_original;
> > > +       size_t                  cmdq_len;
> > > +};
> > > +
> > > +typedef int (*its_init_emulate)(phys_addr_t its_phys_base, struct its_shadow_tables *shadow);
> > > +
> > > +void *its_start_depriviledge(void);
> > > +int its_end_depriviledge(int ret, unsigned long *flags, its_init_emulate cb);
> > > +
> > >  #endif
> > >
> > >  #endif
> > > --
> > > 2.53.0.473.g4a7958ca14-goog
> > >

Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2F74F68BA;
	Mon, 19 Oct 2026 13:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792416982; cv=none; b=CiPFfRPukIwbMrHAua072gk+nv756debEy15qieBVH/cLD4WFwCjQqF/FvfxrCjGRsmDWoo0NwYUoE1g5IzLIn0Kqp48nCYpoEAYq/hY0zZhT++WcvTwmtsYdRAMPfaoV+WWh9JXXEG/4lRR5MpvGL9j5/Il0WHxgqcDVd4xBio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792416982; c=relaxed/simple;
	bh=KE+do/TBjY7vm9rIgC20yyacq0P4rxEoP1N4rypshpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZeIPjGwEAohrOBrp4Us9m5HAXLdZVCRyhvPLYWD58tSWtS4xH4uQ562GY7cRWTp7m7OOapc1oqBGqeQfRrvBi8mJyjdherBQPJDIEL06pfkocfc9QWd638+pFZ0eDBD4K2O7n1JUqfwvO2gZBzBvBp9tp9589jd2u19TNPqHfRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=I8jfGeNZ; arc=none smtp.client-ip=207.54.90.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="I8jfGeNZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1792416981; x=1823952981;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KE+do/TBjY7vm9rIgC20yyacq0P4rxEoP1N4rypshpY=;
  b=I8jfGeNZr6bv9FW2U+UDPEGucczkGkjL3H7R2VyfXDmKBJyvW/2KRHQf
   kEeLmI9jAvnyMeXFmUla8279RvooGuTRH/9ejqDCDV6EJy6AqwkOfl6JU
   gmm5uM0FWGzBMlziFQQfs5XceJ0Mr5dRyhI/piyCj+om7suOiF+gyAGvl
   tvAptftgW4xc4HMWwrolPbVKJK81j01N7yBh7sqEdaNZElFCFHBymg5my
   /O1176c/bCRxrwKhxeQfD72h/O+1dwutYXGsy/Vk8EbCuoPUIEiYOrTU6
   prfewJrMWkZJKMDKcI6J8GR7tsKqBmlxIDgkT3PLqq/WQVPWcVDGQkDhP
   Q==;
X-CSE-ConnectionGUID: MF4IYJroSrumKtJ4ApyMkg==
X-CSE-MsgGUID: w6uQv8HsQriqawROnPT9wA==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="258693774"
X-IronPort-AV: E=Sophos;i="6.27,167,1786978800"; 
   d="scan'208";a="258693774"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 22:36:14 +0900
Received: from az2nlsmgm4.fujitsu.com (unknown [10.150.26.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 50E2C42A327;
	Mon, 19 Oct 2026 13:36:13 +0000 (UTC)
Received: from az2nlsmom3.fujitsu.com (unknown [10.150.26.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm4.fujitsu.com (Postfix) with ESMTPS id 029171000863;
	Mon, 19 Oct 2026 13:36:13 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.8.51.148])
	by az2nlsmom3.fujitsu.com (Postfix) with SMTP id E63AB101A437;
	Mon, 19 Oct 2026 13:36:09 +0000 (UTC)
Date: Mon, 19 Oct 2026 22:36:08 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: sashiko-reviews@lists.linux.dev
Cc: Tomohiro Misono <misono.tomohiro@fujitsu.com>, 
	linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 4/4] irqchip/gicv3: Add workaround for FUJITSU-MONAKA
 erratum E#030003
Message-ID: <atYTTBlzr5J4G_iR@FCCLS0092175.localdomain>
References: <20261016-monaka-fix-for-upstream-v2-0-fc7ede7f9f48@fujitsu.com>
 <20261016-monaka-fix-for-upstream-v2-4-fc7ede7f9f48@fujitsu.com>
 <sashiko-outbox-174127@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-174127@kernel.org>

On 10/16 10:12, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] irqchip/gic-v3: IPI via GICR_ISPENDR0 targets sleeping redistributor
> - [High] irqchip/gicv3: missing NULL check on rd_base causes IPI sender crash
> --
> 
> commit 98989a1fb6fe6471377f9b9c4a24e0097c1639a3
> Author: Kohei Enju <enju.kohei@fujitsu.com>
> 
> irqchip/gicv3: Add workaround for FUJITSU-MONAKA erratum E#030003
> 
> This patch works around a FUJITSU-MONAKA erratum where SGIs are lost if an
> SGI generation races with CPU interface processing. It addresses the issue
> by bypassing the affected system registers and directly writing to the target
> CPU's GICR_ISPENDR0 over MMIO.
> 
> > diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> > --- a/drivers/irqchip/irq-gic-v3.c
> > +++ b/drivers/irqchip/irq-gic-v3.c
> [ ... ]
> > @@ -1386,6 +1391,17 @@ static void gic_ipi_send_mask(struct irq_data *d, const struct cpumask *mask)
> >  	 */
> >  	dsb(ishst);
> >  
> > +	if (static_branch_unlikely(&gic_fujitsu_030003_erratum)) {
> > +		for_each_cpu(cpu, mask) {
> > +			void __iomem *base = gic_data_rdist_sgi_base_cpu(cpu);
> 
> [Severity: High]
> Could this cause a fatal page fault on the CPU sending the IPI if the target
> CPU failed to initialize its redistributor?

I believe the described path is unreachable.

> 
> If a secondary CPU fails to initialize its GIC redistributor due to a buggy
> ACPI MADT or missing DT entry, rd_base remains NULL. 

Yes, rd_base can remain NULL if the firmware description is broken.


> However, the CPU can
> still come online because gic_starting_cpu() returns 0 on failure.

Actually, the CPU cannot come online. Although gic_starting_cpu()
returns zero, arm64 calls ipi_setup() before set_cpu_online().
ipi_setup() enables the per-CPU SGIs, which reaches:

secondary_start_kernel()
  notify_cpu_starting()
    gic_starting_cpu()
  ipi_setup()
    enable_percpu_irq()
      irq_percpu_enable()
        gic_unmask_irq()
          gic_poke_irq()
  set_cpu_online()

Since rd_base is NULL, gic_poke_irq() attempts to access GICR_ISENABLER0
through an invalid redistributor base (NULL + 0x10100), causing a fault
on the secondary CPU before it is marked online.

> 
> When another CPU later broadcasts an IPI, this workaround will derive base
> from a NULL rd_base, resulting in an unmapped address (0x10000). The sender
> CPU will then crash when attempting the writel_relaxed().
> 
> Should we validate that the target CPU actually has an initialized
> redistributor base before bypassing the architected SGI system registers?

I don't think an additional check is necessary here. Existing GICv3 code
already relies on rd_base being valid for every online CPU. 

Moreover, there is no safe fallback for this workaround: using the
normal system register write can trigger the erratum, while dropping the
IPI would leave the target CPU unable to make forward progress.

> 
> > +
> > +			writel_relaxed(BIT(d->hwirq), base + GICR_ISPENDR0);
> 
> [Severity: High]
> Is it safe to write to a target CPU's GICR_ISPENDR0 directly over MMIO when
> that CPU might be in deep idle?

This seems false-positive to me, same as v1:
  https://lore.kernel.org/all/asYsHLoeNtc-sESV@FCCLS0092175.localdomain/

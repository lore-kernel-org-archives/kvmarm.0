Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26F53C13E9;
	Mon, 10 Aug 2026 11:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786362316; cv=none; b=GtYGORxZ/nBFZoy/7Bmmw/K276nh2foFOJGdTGULkw+o7m/CMq3yrN+OZwBgjOoyPsgIna7fjverea/hta7368Ccq1qN6lb04ZcURJppDVZCBTpcDiwB5fgwmNq82vIi3H5mOISdgAOwC3O8biRaVn8S6RImmRf85kuR+1vMiRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786362316; c=relaxed/simple;
	bh=EpK3Mc0c/SYcXBl1Qb1gQ1g1B5inqcMO5/cWifyLcY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MU077XmFlrCvf+Nlfl666hU7aWCzwPZJs/OuU/Cg+nXoq5U3b/szxNxkUWr9v7mMHBrI6pz3sZY1BdmByHzFwaOADkAbi4HCgJWju452tA1a438ed1Ghc8y64NMR4s7KiynmWfewjd0hjc0lt5Gs6n65MMIEz1oj/PAMFHV/Hmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FBSPezM5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FBSPezM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726781F000E9;
	Mon, 10 Aug 2026 11:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786362315;
	bh=vUe1f3pgujs6K1MoZm7uuHtbuihLqP7ejVyvgiIgEAM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FBSPezM5AdYZ+abrnIzGMUjIDKcHNcKCD9H3Nac2Uybl9tVYtXFwqbFl9pL6dUYBD
	 KXkvY0n1pqUpZQoDGJ6ziPOPQ5kCkua58Gal6PCWWOy0HU3AocvadilAA4T4K46Ezu
	 YMc8qr4HA6WUgvgcNL2iP40WB4u3EZnLNC+LEJ/czijgdSNl1veadJFO/GIT4Be9X0
	 7OM6cdd92YG8Z6vTjVpacwBvlazkfHkY4ls8Wmi7LACqeT1+gMmTeyzO921RWQOfl9
	 ZScHYNxO0Lqn3t5++XkqGVdkt4uCo07TrsTylxUJzhf0KSnRddDrSgQgQy1ZEgLzBv
	 ShwZrD8Z3HtFQ==
Date: Mon, 10 Aug 2026 13:45:11 +0200
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 2/5] irqchip/gic-v5: Clear per-CPU IRS data on teardown
Message-ID: <anm5x_e2HTzJAXMD@red-moon>
References: <20260810102652.758719-1-sascha.bischoff@arm.com>
 <20260810102652.758719-3-sascha.bischoff@arm.com>
 <20260810104747.E5CE71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260810104747.E5CE71F000E9@smtp.kernel.org>

On Mon, Aug 10, 2026 at 10:47:47AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] Unconditional call to irq_domain_remove() with a potentially NULL pointer in gicv5_free_lpi_domain() during error teardown causes a fatal kernel panic.
> - [High] Missing release of requested memory regions on initialization error paths and module removal results in a permanent physical memory leak.
> - [High] The ACPI MADT generic interrupt parser does not validate if get_logical_index() successfully found a logical CPU index, leading to out-of-bounds memory access.
> - [High] Using smp_processor_id() in preemptible context triggers a BUG and can lead to stale per-CPU data access.
> - [High] The GICv5 IRS hardware is left enabled on initialization error and teardown paths.

Looking into those.

Thanks,
Lorenzo

> --
> 
> --- Patch [2]: [PATCH 2/5] irqchip/gic-v5: Clear per-CPU IRS data on teardown ---
> commit 280b220e4ca7867e34828e36c13d55683f188fae
> Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
> 
> irqchip/gic-v5: Clear per-CPU IRS data on teardown
> 
> IRS affinity setup publishes an IRS pointer and IAFFID state before
> the remaining IRS initialization can fail. This commit adds a teardown
> function to clear the published state to prevent CPUs from being associated
> with freed memory on initialization failure and module removal.
> 
> Link: https://sashiko.dev/#/patchset/20260724104819.1296803-1-sascha.bischoff@arm.com?part=2
> 
> > diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-irs.c
> > index f3fce0b1e25d9..67940ea9e39b7 100644
> > --- a/drivers/irqchip/irq-gic-v5-irs.c
> > +++ b/drivers/irqchip/irq-gic-v5-irs.c
> 
> [ ... ]
> 
> > @@ -773,6 +786,7 @@ static int __init gicv5_irs_of_init(struct device_node *node)
> >  	return ret;
> >  
> >  out_iomem:
> > +	gicv5_irs_clear_affinity(irs_data);
> >  	iounmap(irs_base);
> 
> [Severity: High]
> This is a pre-existing issue, but should the IRS hardware be explicitly
> disabled before we unmap the registers?
> 
> The error and teardown paths call iounmap(irs_base) and free the structures,
> but there doesn't seem to be a step to clear GICV5_IRS_CR0_IRSEN. Does this
> abandon active DMA-capable hardware?
> 
> [Severity: High]
> This is a pre-existing issue, but are we missing a call to
> release_mem_region() on these teardown paths?
> 
> The setup path uses of_io_request_and_map() which internally requests a
> memory region, but the cleanup paths only call iounmap(). Does this leave the
> physical memory permanently stranded in the iomem tree?
> 
> >  out_err:
> >  	kfree(irs_data);
> > @@ -787,6 +801,7 @@ void __init gicv5_irs_remove(void)
> >  	struct gicv5_irs_chip_data *irs_data, *tmp_data;
> >  
> >  	gicv5_free_lpi_domain();
> 
> [Severity: High]
> This is a pre-existing issue, but does gicv5_free_lpi_domain() safely handle
> a NULL domain?
> 
> Looking at drivers/irqchip/irq-gic-v5.c:gicv5_free_lpi_domain(), it
> unconditionally calls irq_domain_remove(gicv5_global_data.lpi_domain). If
> initialization fails early leaving lpi_domain uninitialized, could this
> trigger a kernel panic during teardown?
> 
> >  	gicv5_deinit_lpis();
> >  
> >  	list_for_each_entry_safe(irs_data, tmp_data, &irs_nodes, entry) {
> > +		gicv5_irs_clear_affinity(irs_data);
> >  		iounmap(irs_data->irs_base);
> >  		list_del(&irs_data->entry);
> >  		kfree(irs_data);
> 
> [ ... ]
> 
> [Severity: High]
> This is a pre-existing issue, but does gic_acpi_parse_iaffid() validate the
> return value of get_logical_index()?
> 
> drivers/irqchip/irq-gic-v5-irs.c:gic_acpi_parse_iaffid() {
>     ...
>     cpu = get_logical_index(gicc->arm_mpidr);
>     ...
> }
> 
> If get_logical_index() fails and returns a negative error code, could this
> lead to out-of-bounds memory corruption when cpu is used as an array index?
> 
> [Severity: High]
> This is a pre-existing issue, but is it safe to use smp_processor_id() in
> gicv5_irs_iste_alloc()?
> 
> drivers/irqchip/irq-gic-v5-irs.c:gicv5_irs_iste_alloc() {
>     ...
>     irs_data = per_cpu(per_cpu_irs_data, smp_processor_id());
>     ...
> }
> 
> Since this function executes in a sleepable context bound by GFP_KERNEL
> constraints, could using smp_processor_id() without preemption disabled
> trigger a BUG splat or lead to stale per-CPU data access?
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260810102652.758719-1-sascha.bischoff@arm.com?part=2

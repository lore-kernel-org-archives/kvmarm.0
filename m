Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9988039BFEC;
	Mon, 10 Aug 2026 10:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786358869; cv=none; b=IJAHVhWAy7r5Y7DnFBFtCnOE9uYb4plr32O7vzJ/qOTbVAb+v2WoM2sqdk6FnOSa6LvNDRQgWtVdv5Cb7vl3r5imk2HD+4/4r1T30Dhi07x72htxEyeMfd27xVeG3INbEFhu6lcNOO12xdOewp4X/Brcy7BYQIWA6jJtQm200kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786358869; c=relaxed/simple;
	bh=ktGkTr1jjC/VbLwzCuxECS3+XvvQqCyQuimYtPrsIOc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Gm96TwZoQw5w3gbRA0GFatjoB2EZPPiJYCVm7IZ7nYNTrbEp/COboloJWpFkak1yr+vOJnJVnrLZ7GqBMVQelytsDo1RfoNKaIoDRJUPzD6D6Hh3/YMgd53mRD8vYuIqpspZvqEdYh3pGkz0F2eMMP+E82IHUXPy77mUyUnsIFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MauKF5k7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MauKF5k7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CE71F000E9;
	Mon, 10 Aug 2026 10:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786358868;
	bh=6cItwXmcnlfdwAe5QeHFKYMQIlzZYOEu2Dc93ob66D4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MauKF5k7D+GuUScahWl1HSaTvnFpE/8H9V+RZMzdexwB2wfstVOqB7/mI8xeXGscZ
	 QwV11RnE7wM1cQ/DZB3jNZ2kEXIueJpXOyKOFOUWk2bqGS+TOZY/hAih98IjxUFfUy
	 2clnUxsf5p89dKo0uYmdPjMjMw4Y1ru3WrgsdCDXX5Ve4kehXahQb2N8sFE7eoVtPZ
	 w4aqviLe9dKTvnP8RO4HEo+R6/V7DfHirBnY4VbNCciQlpOl+c+zEIvxrVU1mOMrE7
	 xt+rqJz6VqaJ4xYNPxNHvqYhTUhFVcSFxxm+2VZEfK90q7RFpPfrXLboOqzyf1badD
	 6+ieXiCfUasxQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/5] irqchip/gic-v5: Clear per-CPU IRS data on teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260810102652.758719-3-sascha.bischoff@arm.com>
References: <20260810102652.758719-1-sascha.bischoff@arm.com>
 <20260810102652.758719-3-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 10 Aug 2026 10:47:47 +0000
Message-Id: <20260810104747.E5CE71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unconditional call to irq_domain_remove() with a potentially NULL =
pointer in gicv5_free_lpi_domain() during error teardown causes a fatal ker=
nel panic.
- [High] Missing release of requested memory regions on initialization erro=
r paths and module removal results in a permanent physical memory leak.
- [High] The ACPI MADT generic interrupt parser does not validate if get_lo=
gical_index() successfully found a logical CPU index, leading to out-of-bou=
nds memory access.
- [High] Using smp_processor_id() in preemptible context triggers a BUG and=
 can lead to stale per-CPU data access.
- [High] The GICv5 IRS hardware is left enabled on initialization error and=
 teardown paths.
--

--- Patch [2]: [PATCH 2/5] irqchip/gic-v5: Clear per-CPU IRS data on teardo=
wn ---
commit 280b220e4ca7867e34828e36c13d55683f188fae
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

irqchip/gic-v5: Clear per-CPU IRS data on teardown

IRS affinity setup publishes an IRS pointer and IAFFID state before
the remaining IRS initialization can fail. This commit adds a teardown
function to clear the published state to prevent CPUs from being associated
with freed memory on initialization failure and module removal.

Link: https://sashiko.dev/#/patchset/20260724104819.1296803-1-sascha.bischo=
ff@arm.com?part=3D2

> diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v=
5-irs.c
> index f3fce0b1e25d9..67940ea9e39b7 100644
> --- a/drivers/irqchip/irq-gic-v5-irs.c
> +++ b/drivers/irqchip/irq-gic-v5-irs.c

[ ... ]

> @@ -773,6 +786,7 @@ static int __init gicv5_irs_of_init(struct device_nod=
e *node)
>  	return ret;
> =20
>  out_iomem:
> +	gicv5_irs_clear_affinity(irs_data);
>  	iounmap(irs_base);

[Severity: High]
This is a pre-existing issue, but should the IRS hardware be explicitly
disabled before we unmap the registers?

The error and teardown paths call iounmap(irs_base) and free the structures,
but there doesn't seem to be a step to clear GICV5_IRS_CR0_IRSEN. Does this
abandon active DMA-capable hardware?

[Severity: High]
This is a pre-existing issue, but are we missing a call to
release_mem_region() on these teardown paths?

The setup path uses of_io_request_and_map() which internally requests a
memory region, but the cleanup paths only call iounmap(). Does this leave t=
he
physical memory permanently stranded in the iomem tree?

>  out_err:
>  	kfree(irs_data);
> @@ -787,6 +801,7 @@ void __init gicv5_irs_remove(void)
>  	struct gicv5_irs_chip_data *irs_data, *tmp_data;
> =20
>  	gicv5_free_lpi_domain();

[Severity: High]
This is a pre-existing issue, but does gicv5_free_lpi_domain() safely handle
a NULL domain?

Looking at drivers/irqchip/irq-gic-v5.c:gicv5_free_lpi_domain(), it
unconditionally calls irq_domain_remove(gicv5_global_data.lpi_domain). If
initialization fails early leaving lpi_domain uninitialized, could this
trigger a kernel panic during teardown?

>  	gicv5_deinit_lpis();
> =20
>  	list_for_each_entry_safe(irs_data, tmp_data, &irs_nodes, entry) {
> +		gicv5_irs_clear_affinity(irs_data);
>  		iounmap(irs_data->irs_base);
>  		list_del(&irs_data->entry);
>  		kfree(irs_data);

[ ... ]

[Severity: High]
This is a pre-existing issue, but does gic_acpi_parse_iaffid() validate the
return value of get_logical_index()?

drivers/irqchip/irq-gic-v5-irs.c:gic_acpi_parse_iaffid() {
    ...
    cpu =3D get_logical_index(gicc->arm_mpidr);
    ...
}

If get_logical_index() fails and returns a negative error code, could this
lead to out-of-bounds memory corruption when cpu is used as an array index?

[Severity: High]
This is a pre-existing issue, but is it safe to use smp_processor_id() in
gicv5_irs_iste_alloc()?

drivers/irqchip/irq-gic-v5-irs.c:gicv5_irs_iste_alloc() {
    ...
    irs_data =3D per_cpu(per_cpu_irs_data, smp_processor_id());
    ...
}

Since this function executes in a sleepable context bound by GFP_KERNEL
constraints, could using smp_processor_id() without preemption disabled
trigger a BUG splat or lead to stale per-CPU data access?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260810102652.7587=
19-1-sascha.bischoff@arm.com?part=3D2

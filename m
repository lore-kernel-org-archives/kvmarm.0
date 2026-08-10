Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E6D3C1966;
	Mon, 10 Aug 2026 11:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786361784; cv=none; b=Jvjtn3TGNdXiDVFjnr33yUcPnwRcqRNSocWyVAC4LIc76j3inZiz9UwjHorrGxmhRmg/Y35gq/n1n2WHU36fISTa4atZIvporxhSoFJNdf4D7zgwqWgAD3LoD3M+z3U0UqTD8kUU1kV8kBpMQ7Me/ySPKiijZNXD3//haN4XNs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786361784; c=relaxed/simple;
	bh=OWxBuZpOkN7fcqjzy2VzDvH1uaoL+6TDuKM9WxqSmBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JLyBIH5Ihdof91jeozobxnLea2uyaDLhLWERQyrfGM1YO5gpq0rCQWIRLjbmtPvT0D/eYB4C2fVgEl6sZjD0Y6YLHTWGAbrqHICsmSe+aotUMfIfo+5A+kKFopmhW71LbtmNLC2HQtbJnXX1LtOq19+PSPb/APiO5rAmIx3oXUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Aa5izIM6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aa5izIM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89E11F000E9;
	Mon, 10 Aug 2026 11:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786361783;
	bh=WRKK4z+x45IWP0hIqC6+DM+wz3tna9hF8aQoj6Ri1T4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Aa5izIM6VIgu27KQmRZnjVjU4Wg85NXtu3BKTMGn1dYtChL9YDyhSfUjZjKeWBF1+
	 4Sq+870GQ8kPGYWO29hkeQdI1jDgCSQ24lnop9enazZKIac7ASeCt+0tcWI4jfWHjm
	 y31WfhEvi5d9mxVkR2nX17Q9DJt27o9IidC4Vc3qCr2xCYoLT9D84vpPU73WO8VgYu
	 gMTWggE0hKNnTA/TXrGO13c5y8FOtgEVaoZAX4W9ZMXbDlgHO2GCIQdxkoZpIv/uUz
	 Pa+1jx0q/2R6SjBL4pH/VQqg66KcDBw+bpF8cW2pwr/LsiF2MQ49+lvE6zqkh0kvnt
	 h8R9c1rHnVBRg==
Date: Mon, 10 Aug 2026 13:36:18 +0200
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>
Subject: Re: [PATCH 2/5] irqchip/gic-v5: Clear per-CPU IRS data on teardown
Message-ID: <anm3snqnGHcqUogW@red-moon>
References: <20260810102652.758719-1-sascha.bischoff@arm.com>
 <20260810102652.758719-3-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810102652.758719-3-sascha.bischoff@arm.com>

On Mon, Aug 10, 2026 at 10:28:07AM +0000, Sascha Bischoff wrote:
> IRS affinity setup publishes an IRS pointer and IAFFID state in the
> per-CPU data before the remaining IRS initialization can fail. The
> error path then frees the IRS data without clearing that published
> state, leaving CPUs associated with freed memory.
> 
> On initialization failure and normal IRS teardown, clear the per-CPU
> IRS association by removing the stale pointer to irs_data. Also clear
> the per-CPU IAFFID state for any CPUs that were tied to the IRS before
> it was freed.
> 
> Fixes: 5cb1b6dab2de ("irqchip/gic-v5: Add GICv5 IRS/SPI support")
> Fixes: 35866efa52fe ("irqchip/gic-v5: Add ACPI IRS probing")
> Link: https://sashiko.dev/#/patchset/20260724104819.1296803-1-sascha.bischoff@arm.com?part=2
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  drivers/irqchip/irq-gic-v5-irs.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)

Thank you Sascha, a minor comment below otherwise:

Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>

> diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-irs.c
> index f3fce0b1e25d9..67940ea9e39b7 100644
> --- a/drivers/irqchip/irq-gic-v5-irs.c
> +++ b/drivers/irqchip/irq-gic-v5-irs.c
> @@ -651,6 +651,19 @@ static int __init gicv5_irs_of_init_affinity(struct device_node *node,
>  	return ret;
>  }
>  
> +static void __init gicv5_irs_clear_affinity(struct gicv5_irs_chip_data *irs_data)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		if (per_cpu(per_cpu_irs_data, cpu) == irs_data) {
> +			per_cpu(cpu_iaffid, cpu).iaffid = 0;

As long we set valid to false this is not necessarily needed, 0 is a valid
value.

Thanks,
Lorenzo

> +			per_cpu(cpu_iaffid, cpu).valid = false;
> +			per_cpu(per_cpu_irs_data, cpu) = NULL;
> +		}
> +	}
> +}
> +
>  static void irs_setup_pri_bits(u32 idr1)
>  {
>  	switch (FIELD_GET(GICV5_IRS_IDR1_PRIORITY_BITS, idr1)) {
> @@ -773,6 +786,7 @@ static int __init gicv5_irs_of_init(struct device_node *node)
>  	return ret;
>  
>  out_iomem:
> +	gicv5_irs_clear_affinity(irs_data);
>  	iounmap(irs_base);
>  out_err:
>  	kfree(irs_data);
> @@ -787,6 +801,7 @@ void __init gicv5_irs_remove(void)
>  	gicv5_deinit_lpis();
>  
>  	list_for_each_entry_safe(irs_data, tmp_data, &irs_nodes, entry) {
> +		gicv5_irs_clear_affinity(irs_data);
>  		iounmap(irs_data->irs_base);
>  		list_del(&irs_data->entry);
>  		kfree(irs_data);
> @@ -951,6 +966,7 @@ static int __init gic_acpi_parse_madt_irs(union acpi_subtable_headers *header,
>  	return 0;
>  
>  out_map:
> +	gicv5_irs_clear_affinity(irs_data);
>  	iounmap(irs_base);
>  out_release:
>  	release_mem_region(r->start, resource_size(r));
> -- 
> 2.34.1

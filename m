Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794701850;
	b=eeKjpN+Vwi3qf0Op6vo8t5LbnQHcTZH511QMjzsd8vh2v+Xn1wdB41t2qDyUxebPBLp0
	 eR0gTy1VXu79ck7rOga/VSQe0B0m6ih0yIYlmamaaMZua2W7XV5boLmjT4bWYmbgrfeH+
	 H5GcGRBO5EcY6iSyg+4b1F/9TMTAX8VXgfl4CywQ8KlpjNZTFmZpNCH4zTuuCuqDHFqxw
	 IroD0QkF4SfykOYk6PjHOyvqCVj2TwTHo1fxtj8nmV8CS08VYTy+8Knw0cDF7ySUZoUow
	 gCfpecTtyLe8dZkMXLf5Ru82mIFAw0kQGSBf25fG8EmBbSesXmVwN/zgn06swM6nQYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794701850;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=kHIIHcLqTbRuwWpPuK1atPf48K3n1KHOK4sFy1WmaxY=;
	b=GMz0+bGE3LL6kkwdwl1M+BfOV3Lgq2GIhklrVORD2xsb+7kVhwjAyqDDa98DmPrNxc/3
	 ihNUpI2seXybP3ZvuoHiiS67uhBZxtuhZTfdkMLQUoqgDly2+8dPaZ/B3ExgYVrBoyNiR
	 Z2xcRQpvtxAhMhzdkTdAEfpUkTyfnbPerT5ApOMwTBafOODrezu6b+PWSGEEojHV7npJi
	 RHwdAr+B03BujJHD9TBOp+T+Ch/rYZATM1TABuKDVASYqGE6YQTiKVq6h1GBcd9SqvInq
	 UlLK/PO/DxzmwuQ7OQI2lE8GGAMuyN8kJ9vwf8ARLYDZh8gvVAzGjmqr7bo4dR75Fhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="l/hFXcNe";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50E16606A327
	for <kvmarm@lists.linux.dev>; Sun, 15 Nov 2026 00:17:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50E16606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=l/hFXcNe
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E3CD7143D;
	Sat, 14 Nov 2026 16:17:23 -0800 (PST)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F3B413F673;
	Sat, 14 Nov 2026 16:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794701846; bh=kxN6iZQ2hHfg8DYo4csM3MJfm3vVSM5qRDmT3A1+2W0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l/hFXcNe8QEyaDd4jcOXCx55+lmgETEBj2/kKhVTD/bva2xXH7EwHo8zRK5h90eqp
	 jJcOmEZd/XnSZJLLNtqOgJugnslkeGoAEaYuygjR++Klc0hNPsBLLrQB3BxFZ3x2YO
	 xGITULcfZFoG+tqE/7EeWQhAcExE2i200ZhG2uig=
Date: Sun, 15 Nov 2026 00:17:19 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Sascha Bischoff <sascha.bischoff@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, peter.maydell@linaro.org, 
	lpieralisi@kernel.org, timothy.hayes@arm.com, fuad.tabba@linux.dev
Subject: Re: [PATCH v2 11/16] irqchip/gic-v5: Enable direct injection in ITS
Message-ID: <jjok7alo24golbl53cpyo2j7ypnm57eheoz2cimsizied6l5ru@nt2wy2klyoiq>
References: <20261102194454.4086911-1-sascha.bischoff@arm.com>
 <20261102194454.4086911-12-sascha.bischoff@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102194454.4086911-12-sascha.bischoff@arm.com>

On Mon, Nov 02, 2026 at 07:44:49PM +0000, Sascha Bischoff wrote:
> Allow KVM to replace a host ITTE with a virtual translation that
> directly injects an interrupt into a guest. Add an irq_chip callback to
> install and remove the virtual translation, and disable lazy masking
> while the interrupt is forwarded. The KVM caller is added later.
> 
> The ITS writes the ITTE before invalidating its cache. If invalidation
> times out, hardware may still use the virtual translation even though
> setup failed. Allow disable to restore the host ITTE when the forwarded
> flag is clear, and retain retryable state if restoration also times
> out. Keep lazy masking disabled until the host mapping is restored.
> 
> Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  drivers/irqchip/irq-gic-v5-its.c   | 141 +++++++++++++++++++++++++++++
>  include/linux/irqchip/arm-gic-v5.h |   8 ++
>  2 files changed, 149 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic-v5-its.c b/drivers/irqchip/irq-gic-v5-its.c
> index 28e39b065de0e..d91f4ea1ef440 100644
> --- a/drivers/irqchip/irq-gic-v5-its.c
> +++ b/drivers/irqchip/irq-gic-v5-its.c
> @@ -61,6 +61,48 @@ static void its_writeq_relaxed(struct gicv5_its_chip_data *its_node, const u64 v
>  	writeq_relaxed(val, its_node->its_base + reg_offset);
>  }
>  

[...]

> +
>  static const struct irq_chip gicv5_its_irq_chip = {
>  	.name			= "GICv5-ITS-MSI",
>  	.irq_mask		= irq_chip_mask_parent,

We should also update gicv5_its_irq_chip.irq_mask/irq_unmask to consider
direct injected vLPIs right?

Thanks,
Wei-Lin Chang

> @@ -732,6 +870,9 @@ static const struct irq_chip gicv5_its_irq_chip = {
>  	.irq_get_irqchip_state	= irq_chip_get_parent_state,
>  	.irq_set_irqchip_state	= irq_chip_set_parent_state,
>  	.irq_compose_msi_msg	= gicv5_its_compose_msi_msg,
> +#ifdef CONFIG_KVM
> +	.irq_set_vcpu_affinity	= gicv5_its_set_vcpu_affinity,
> +#endif /* CONFIG_KVM */
>  };
>  

[...]

Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534D03D5673
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 09:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787649034; cv=none; b=Qc2LldKhDJcarXuaUMC+2uP4wsShsauqUH5eVIB1synyVtalj5M0ORmKRwg26g+0qc1sFiqV5J2q6vUZfWfT2JKWkk0JQgiScFVkjPlI3r4pmzO30TF+3BwtU6YtvM9FR5g5KRS59XnWinNgG3HVugAJl5XOyyYs4enDrWmkw3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787649034; c=relaxed/simple;
	bh=NplPu39Y/kIANYfc1RelOQIFPmpuf0hQyc+vxgOVbO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YAFmKveSIp+IvLEgNOx+uhYt/reCNpdQ6BxsM4heaGGiEPrVrqbOXCVpper5rvUiIah26bW4KHfl6zyUiYoXRdiyb+eVJdN9yY23OC8uBmFMU1RhCZACNAsqlq71xXeDww6samQrz8//AL/v/omCyHshWSi6/kjUaHChnTVfsBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=xNqmxTZi; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="xNqmxTZi"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787649024; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=cobYJEGb3W53QP2W2mYmmoOXuHeQdtagqN0geH2RpLc=;
	b=xNqmxTZiVEbLT04HCD5U5upClW9ZRUMHhLl4E6noisGpdVYuRBpM6sGOyySnxorbLki1ucmQ24Nd0Z6kEeP6+mJM0DM1nb9Ub0pYrevSUJT78GSd/ORd55kft5ZhydLS+9z/ox1UgFemK13atrfsQTUC5NnsA615MLmTkmVb0yc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X9dP6.j_1787649022;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X9dP6.j_1787649022 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 25 Aug 2026 17:10:23 +0800
Date: Tue, 25 Aug 2026 17:10:22 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Eric Auger <eauger@redhat.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Sascha Bischoff <Sascha.Bischoff@arm.com>, Sebastian Ene <sebastianene@google.com>, 
	Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] irqchip/gic-v4: Unwind what its_alloc_vcpu_irqs()
 allocated on failure
Message-ID: <newqqvl3kuyv3tzlmg5gvt6j2bqf4htk4rwotawrhfud4fv3dr@pcd3uodxdsbj>
References: <20260824074245.710955-1-fuad.tabba@linux.dev>
 <20260824074245.710955-3-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824074245.710955-3-fuad.tabba@linux.dev>

On Mon, Aug 24, 2026 at 08:42:43AM +0800, Fuad Tabba wrote:
> A failure in the its_alloc_vcpu_sgis() loop leaves behind both the SGI
> domains created for the vPEs below the failing index and the vPE irqs
> allocated before the loop, since irq_domain_remove() frees neither. Each
> leaked vPE takes its ITS state with it, a vpe_id and an LPI pending
> table.
>
> Free both from a second label before the existing unwind. With the
> freed pointers now cleared, its_free_sgi_irqs() can skip a vPE with no
> SGI domain and be reused there. The check has to precede the lookup:
> irq_find_mapping(NULL, 0) falls back to irq_default_domain, and the
> live irq it returns would then be freed.

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>
> Fixes: 6d31b6ff985d ("irqchip/gic-v4.1: Add VSGI allocation/teardown")
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  drivers/irqchip/irq-gic-v4.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
> index 754839e409f88..f707a3cb281aa 100644
> --- a/drivers/irqchip/irq-gic-v4.c
> +++ b/drivers/irqchip/irq-gic-v4.c
> @@ -159,6 +159,8 @@ static int its_alloc_vcpu_sgis(struct its_vpe *vpe, int idx)
>  	return -ENOMEM;
>  }
>
> +static void its_free_sgi_irqs(struct its_vm *vm);
> +
>  int its_alloc_vcpu_irqs(struct its_vm *vm)
>  {
>  	int vpe_base_irq, i;
> @@ -189,11 +191,14 @@ int its_alloc_vcpu_irqs(struct its_vm *vm)
>  		vm->vpes[i]->irq = vpe_base_irq + i;
>  		ret = its_alloc_vcpu_sgis(vm->vpes[i], i);
>  		if (ret)
> -			goto err;
> +			goto err_free_irqs;
>  	}
>
>  	return 0;
>
> +err_free_irqs:
> +	its_free_sgi_irqs(vm);
> +	irq_domain_free_irqs(vpe_base_irq, vm->nr_vpes);
>  err:
>  	if (vm->domain) {
>  		irq_domain_remove(vm->domain);
> @@ -215,8 +220,13 @@ static void its_free_sgi_irqs(struct its_vm *vm)
>  		return;
>
>  	for (i = 0; i < vm->nr_vpes; i++) {
> -		unsigned int irq = irq_find_mapping(vm->vpes[i]->sgi_domain, 0);
> +		unsigned int irq;
>
> +		/* irq_find_mapping() falls back to the default domain on NULL. */
> +		if (!vm->vpes[i]->sgi_domain)
> +			continue;
> +
> +		irq = irq_find_mapping(vm->vpes[i]->sgi_domain, 0);
>  		if (WARN_ON(!irq))
>  			continue;
>
> --
> 2.39.5
>

Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCF13E6DD0
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 08:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787647987; cv=none; b=XMVQo5kBtIkjR4rnWPjc8TPr64OCPAlWwsWRjAbH9AXsaIo6UlUwhCdmk9bsa9KL3qbK2g6cuUUBkPaZnoZG264GR6VghTpzmih0ZHb4yTkHZU7NXa2/Xq+iozq8l2Wf1EieLmwvjxgwAQCr+zhH0T0u5javUx0WX5jPDQiWnGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787647987; c=relaxed/simple;
	bh=bWrQce9rvAu96EnDNBTLB9QIBF8ljEVuT331p2FtHZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EVpq9rMcp40lkVw4zNpzNbB3sw3Eg5fKGMr6abmYP4ckR0BjbeYaYldP1WqMIQV48Q0ESY6KyabwthVf6hE0dGAT2LmqOjE9UvKXgeO4WDJ6aqwwheCbXODpWOD3fZ5CzjnZTOBmKefbdeIl9pvJk6nmY0oiK2b5o3PYEjVtnXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Gh+kEiHj; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Gh+kEiHj"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787647975; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=b1/3sxKWMwZmvXn0ohFtsHlyP5vLtleCRLjspTUH1BM=;
	b=Gh+kEiHjRcP+LN+9tPVHuLSH+zYZ1eRTG1nRd75GmzDUqfmbQ7jNAPiBrBYNxGcJOAnDk66oz3Gy+VmNB+zy5u6XpLFdXCa0maZNoB/wF2rezfw63mhnEyT9wBcFTP2F1Z3RHwFQI7k4ulIr3Oe4vwKdsqqNiPszb23SEz9IuCw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R461e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X9dJUmE_1787647973;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X9dJUmE_1787647973 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 25 Aug 2026 16:52:53 +0800
Date: Tue, 25 Aug 2026 16:52:51 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Eric Auger <eauger@redhat.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Sascha Bischoff <Sascha.Bischoff@arm.com>, Sebastian Ene <sebastianene@google.com>, 
	Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] irqchip/gic-v4: Clear the domain and fwnode
 pointers after freeing them
Message-ID: <xsuxicnwpzpogl7wlh7atdjw75irdd54oytivalf223jfdbfmz@36tvycw2qt6y>
References: <20260824074245.710955-1-fuad.tabba@linux.dev>
 <20260824074245.710955-2-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824074245.710955-2-fuad.tabba@linux.dev>

On Mon, Aug 24, 2026 at 08:42:42AM +0800, Fuad Tabba wrote:
> The GICv4 allocation and teardown paths free their irq domains and
> fwnodes but leave the pointers set, and the allocation error paths test
> those pointers before removing them. struct its_vm and struct its_vpe
> are embedded in KVM's per-VM and per-vCPU state, so nothing re-zeroes
> them between two attempts, and an error path taken after an earlier one
> already freed the domain calls irq_domain_remove() on freed memory.

Hi Tabba,

Real nice finding!

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>
> Reaching this takes two allocation failures, one to leave the stale
> pointer behind and one to send the next attempt down the error path.
>
> Fixes: 7de5c0af9c7c ("irqchip/gic-v4: Add per-VM VPE domain creation")
> Fixes: 6d31b6ff985d ("irqchip/gic-v4.1: Add VSGI allocation/teardown")
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  drivers/irqchip/irq-gic-v4.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
> index 8455b4a5fbb0d..754839e409f88 100644
> --- a/drivers/irqchip/irq-gic-v4.c
> +++ b/drivers/irqchip/irq-gic-v4.c
> @@ -147,10 +147,14 @@ static int its_alloc_vcpu_sgis(struct its_vpe *vpe, int idx)
>  	return 0;
>
>  err:
> -	if (vpe->sgi_domain)
> +	if (vpe->sgi_domain) {
>  		irq_domain_remove(vpe->sgi_domain);
> -	if (vpe->fwnode)
> +		vpe->sgi_domain = NULL;
> +	}
> +	if (vpe->fwnode) {
>  		irq_domain_free_fwnode(vpe->fwnode);
> +		vpe->fwnode = NULL;
> +	}
>  	kfree(name);
>  	return -ENOMEM;
>  }
> @@ -191,10 +195,14 @@ int its_alloc_vcpu_irqs(struct its_vm *vm)
>  	return 0;
>
>  err:
> -	if (vm->domain)
> +	if (vm->domain) {
>  		irq_domain_remove(vm->domain);
> -	if (vm->fwnode)
> +		vm->domain = NULL;
> +	}
> +	if (vm->fwnode) {
>  		irq_domain_free_fwnode(vm->fwnode);
> +		vm->fwnode = NULL;
> +	}
>
>  	return -ENOMEM;
>  }
> @@ -215,6 +223,8 @@ static void its_free_sgi_irqs(struct its_vm *vm)
>  		irq_domain_free_irqs(irq, 16);
>  		irq_domain_remove(vm->vpes[i]->sgi_domain);
>  		irq_domain_free_fwnode(vm->vpes[i]->fwnode);
> +		vm->vpes[i]->sgi_domain = NULL;
> +		vm->vpes[i]->fwnode = NULL;
>  	}
>  }
>
> @@ -224,6 +234,8 @@ void its_free_vcpu_irqs(struct its_vm *vm)
>  	irq_domain_free_irqs(vm->vpes[0]->irq, vm->nr_vpes);
>  	irq_domain_remove(vm->domain);
>  	irq_domain_free_fwnode(vm->fwnode);
> +	vm->domain = NULL;
> +	vm->fwnode = NULL;
>  }
>
>  static int its_send_vpe_cmd(struct its_vpe *vpe, struct its_cmd_info *info)
> --
> 2.39.5
>

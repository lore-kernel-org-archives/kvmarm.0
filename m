Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D7980046
	for <kvmarm@lists.linux.dev>; Fri, 19 Jul 2024 09:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721382131; cv=none; b=jYDEXIMVQIZy4Bcc6ZO1PF0yuFmaWUyKmwHTzsG9gaRuC263hj+9wzV8hhQFLa4UmOfgLzwnhaXuHWxX6nWpCDBYPYm5TuazmVEZXlQTjgkGyZzgc2vnwR3B1UGQzBhtBMBnTVZ4pigZ2/+/afmAACA7XdAWx8SKUnVI395n7Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721382131; c=relaxed/simple;
	bh=qGopGABQSOZ4WINzP7qpGeg325G03koAFu5o3JX1uP8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=G5+/BL+4B4an/EHBrU0bmrR7jDfsp2VUFx76AyvDy7txwAA0kjIfI3/BCzG3NvYn1Z6qdWqx71bEJ0pUWzCRp548158gsWSWDCLeAvDV4LtW1SWGSTZJHwtyqT2vu0CX0p6M7Ko9L6jIYXZI/UMYF6TqHASk9tiUo3nl2mFAfLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WQPjf1ZT0zQmGy;
	Fri, 19 Jul 2024 17:37:58 +0800 (CST)
Received: from kwepemd200012.china.huawei.com (unknown [7.221.188.145])
	by mail.maildlp.com (Postfix) with ESMTPS id D4E9418007C;
	Fri, 19 Jul 2024 17:42:03 +0800 (CST)
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemd200012.china.huawei.com (7.221.188.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 19 Jul 2024 17:42:03 +0800
Message-ID: <2c9489cc-d276-7c52-5d52-7f234fdc726e@hisilicon.com>
Date: Fri, 19 Jul 2024 17:42:02 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 3/3] irqchip/gic-v4: Make sure a VPE is locked when VMAPP
 is issued
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Nianyao Tang
	<tangnianyao@huawei.com>
References: <20240705093155.871070-1-maz@kernel.org>
 <20240705093155.871070-4-maz@kernel.org>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <20240705093155.871070-4-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemd200012.china.huawei.com (7.221.188.145)

On 2024/7/5 17:31, Marc Zyngier wrote:
> In order to make sure that vpe->col_idx is correctly sampled
> when a VMAPP command is issued, we must hold the lock for the
> VPE. This is now possible since the introduction of the per-VM
> vmapp_lock, which can be taken before vpe_lock in the locking
> order.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  drivers/irqchip/irq-gic-v3-its.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index b52d60097cad5..951ec140bcea2 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -1810,7 +1810,9 @@ static void its_map_vm(struct its_node *its, struct its_vm *vm)
>  		for (i = 0; i < vm->nr_vpes; i++) {
>  			struct its_vpe *vpe = vm->vpes[i];
>  
> -			its_send_vmapp(its, vpe, true);
> +			scoped_guard(raw_spinlock, &vpe->vpe_lock)
> +				its_send_vmapp(its, vpe, true);
> +
>  			its_send_vinvall(its, vpe);
>  		}
>  	}
> @@ -1827,8 +1829,10 @@ static void its_unmap_vm(struct its_node *its, struct its_vm *vm)
>  	if (!--vm->vlpi_count[its->list_nr]) {
>  		int i;
>  
> -		for (i = 0; i < vm->nr_vpes; i++)
> +		for (i = 0; i < vm->nr_vpes; i++) {
> +			guard(raw_spinlock)(&vm->vpes[i]->vpe_lock);
>  			its_send_vmapp(its, vm->vpes[i], false);
> +		}
>  	}
>  }
>  

Hi Marc,

It looks like there is ABBA deadlock after applying this series:

In its_map_vm: vmapp_lock -> vpe_lock
In its_vpe_set_affinity: vpe_to_cpuid_lock(vpe_lock) -> its_send_vmovp(vmapp_lock)

Any idea about this?

Best,
Zhou

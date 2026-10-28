Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793206385;
	b=cnsfDT2Mjhooe/k5SSeeR83z8Mnh9N7wA0ERbX+k2QyFbQJeOnVhXYt/Wk5qgOAhwV0O
	 xLk/Ftdvmx7MEJzkNHBwCZNh3RIgqDHkU55SFiEcz76jiXlBBuKRRzQW6YYh9LhS5ND9L
	 20uJOxdgysxEPHgQ4BicMQzenVL3+x5sOEosMxz1mC2ewMJCdzbp1x7BvXHT2Qt5Rnthq
	 cyY6J3ITGzkVFIV3fEf9lwtjw68cAveLbQxaUHrAHh6YT0Ifw1ygE4KIsW5N/dnldr7Tx
	 PrtJl70Cm2+CxfP0B/7x/PY78XkHNWygIM/CbDK8jqsAWxQ026+sD8fnc/K2WsR29pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793206385;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=YSDSgjpQLJHyewcbdkRbRSJusGm4cUM3Dgl9o9009Ec=;
	b=UUSFT2gM/kopE4RXjs0meK8FrOXfzF1R2qz1kai2z6E2/53QSedisL8DZI0m0tEyAwXx
	 dqsiduzsu3O/10qd9nWyQKstLGfwgOXRunDCH2cPZDD3zSTAei7LJnscP13BcmxDTfH7F
	 EzDh1+sa+kTEQ2GKXnIN6c63zCyJgydbA92MDW+tETsagzjtUwOuRoiqlNIBqv2KhYlGz
	 iycUEFHQEtCxM8orcp554NvkTl9qzsexI0JF+rpXvN4rbXn5myTDD8hBcy9lkRTQPpZ4K
	 OwWf/mkujr59c7QNl2p8BBINZ+SjrcojYzlLNCnOCbZR+LL7adMZsuas/HTwqo8sUEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Jet83GLP;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6709606A31A
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 16:53:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6709606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Jet83GLP
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 049651756;
	Wed, 28 Oct 2026 09:52:54 -0700 (PDT)
Received: from [10.57.16.117] (unknown [10.57.16.117])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1A7D13F59E;
	Wed, 28 Oct 2026 09:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793206377; bh=vJ+LPeiA2zykY87kypyN7HwDrT7gAk57eYzbxdUxVq4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Jet83GLPCj8+yixKuGbe68KlDg4d2iybThkNYU9F6Ea5jitw0eidM9kZcZqQi/3CI
	 wH8bTu5nposSzApqJwqyOjNNTxMt89rNL8giOw0LyOem6IL6V38coDJrAtDRYej3Vj
	 cEYZJPrASJc4Y8RsPiHVO6F6RpxaKrrqmcgFFO1U=
Message-ID: <69288872-2576-4697-a62d-87ab2bcedd49@arm.com>
Date: Wed, 28 Oct 2026 16:52:53 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v7 12/28] KVM: arm64: Add SPE VCPU device attribute to
 set the interrupt number
Content-Language: en-GB
To: Alexandru Elisei <alexandru.elisei@arm.com>, maz@kernel.org,
 oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com,
 seiden@linux.ibm.com, yuzenghui@huawei.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org,
 catalin.marinas@arm.com, james.clark@linaro.org
Cc: Sudeep Holla <sudeep.holla@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-13-alexandru.elisei@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260903160623.315525-13-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/09/2026 17:06, Alexandru Elisei wrote:
> From: Sudeep Holla <sudeep.holla@arm.com>
> 
> Add KVM_ARM_VCPU_SPE_CTRL(KVM_ARM_VCPU_SPE_IRQ) to allow the user to set
> the interrupt number for the buffer management interrupt.
> 
> [ Alexandru E: Split from "KVM: arm64: Add a new VCPU device control group
>                 for SPE" ]
> 
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---

...

> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index fe45ad4c703a..dd5f80318ba4 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
> @@ -59,17 +59,99 @@ bool kvm_supports_spe(void)
>   	return !list_empty(&spe_pmus);
>   }
>   

...

>   int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>   {
> +	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	if (!vcpu_has_spe(vcpu))
> +		return -ENODEV;
> +
> +	switch (attr->attr) {
> +	case KVM_ARM_VCPU_SPE_IRQ: {
> +		int __user *uaddr = (int __user *)(long)attr->addr;
> +		int irq;
> +
> +		if (!irqchip_in_kernel(kvm))
> +			return -EINVAL;
> +
> +		if (!vcpu_spe->irq_num)
> +			return -ENXIO;
> +
> +		irq = vcpu_spe->irq_num;
> +		if (put_user(irq, uaddr))
> +			return -EFAULT;
> +
> +		return 0;
> +	}
> +	}
> +
>   	return -ENXIO;
>   }
>   
>   int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>   {
> +	if (!vcpu_has_spe(vcpu))
> +		return -ENODEV;
> +
> +	switch(attr->attr) {
> +	case KVM_ARM_VCPU_SPE_IRQ:
> +		return 0;

Should we gate this too on irqchip_in_kernel(vcpu->kvm) ? Otherwise
we would advertise to the userspace that it has the SPE_IRQ, but
would return -EINVAL when we try get_attr if the irqchip is not
in kernel.

Also, do we need to mandate the ordering of the SPE configuration on
VGIC ?

Cheers
Suzuki


> +	}
> +
>   	return -ENXIO;
>   }


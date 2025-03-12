Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2630A1ADC6C
	for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 21:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741813730; cv=none; b=PmMsxlwbjLYl2VuRkyT1Wq9O9Tg/7U9L9TlNZU7WxjZHW4c/pDn073GIWKsPZs9tngr0jD76gOfqQoAkBh044PQ6cuFJa1YKXKWbdjtk0S5mgk8v7xFsfqG9YvgRb6L0l+mRgdJAlvbxnVN3puVEc08GCb0WZXceNzhQYOgnKbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741813730; c=relaxed/simple;
	bh=UV8ok8xOKBsTBleA309I9YH/mcu4G6OoiYnJkErtEc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kIoYeEtaWeDkYM18VcMayhFx1UNggV6pvxV7t17vD06c4RUSOuaBrws7FVfuCKL6G3Xm/KzPjmRRlibHW/MIaCyiviDpRPjb+ha1mkMPc7FmOtD0/KDT+TQmQ/xbO/PK3shxfKOpgOByHD6NsUcRtvs9SUpMgrkFqkqScAwZGss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tXAIgqwO; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tXAIgqwO"
Date: Wed, 12 Mar 2025 14:08:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741813717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nketLiJPdF1cG5+xhffp3E+xo58pUFnxytm5pkfSk9c=;
	b=tXAIgqwOxyhkyQX9b3ctNlNNWv6ooqSGxQgRaPhObowdsl5KRSSHxy8AxV/U0HPzt8f+Wl
	hqYXrgYCNtu9QnGy0iXJBJ1JAvF1grz9I/e6QgQ42M5CHiv38XbprKCHUOKoaWnSie8fzP
	rEzD/JEgYy9tovZ0eU+shdnFwXGOv+E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Andrew Jones <drjones@redhat.com>,
	Shannon Zhao <shannon.zhao@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, devel@daynix.com
Subject: Re: [PATCH v3 2/6] KVM: arm64: PMU: Assume PMU presence in pmu-emul.c
Message-ID: <Z9H3yuv96gBPty76@linux.dev>
References: <20250312-pmc-v3-0-0411cab5dc3d@daynix.com>
 <20250312-pmc-v3-2-0411cab5dc3d@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312-pmc-v3-2-0411cab5dc3d@daynix.com>
X-Migadu-Flow: FLOW_OUT

Hi Akihiko,

On Wed, Mar 12, 2025 at 08:55:56PM +0900, Akihiko Odaki wrote:

[...]

> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 962f985977c2..fc09eec3fd94 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -951,6 +951,10 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
>  
>  	switch (attr->group) {
>  	case KVM_ARM_VCPU_PMU_V3_CTRL:
> +		if (!kvm_vcpu_has_pmu(vcpu)) {
> +			ret = -ENODEV;
> +			break;
> +		}
>  		mutex_lock(&vcpu->kvm->arch.config_lock);
>  		ret = kvm_arm_pmu_v3_set_attr(vcpu, attr);
>  		mutex_unlock(&vcpu->kvm->arch.config_lock);
> @@ -976,6 +980,10 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
>  
>  	switch (attr->group) {
>  	case KVM_ARM_VCPU_PMU_V3_CTRL:
> +		if (!kvm_vcpu_has_pmu(vcpu)) {
> +			ret = -ENODEV;
> +			break;
> +		}
>  		ret = kvm_arm_pmu_v3_get_attr(vcpu, attr);
>  		break;
>  	case KVM_ARM_VCPU_TIMER_CTRL:
> @@ -999,6 +1007,10 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>  
>  	switch (attr->group) {
>  	case KVM_ARM_VCPU_PMU_V3_CTRL:
> +		if (!kvm_vcpu_has_pmu(vcpu)) {
> +			ret = -ENXIO;
> +			break;
> +		}
>  		ret = kvm_arm_pmu_v3_has_attr(vcpu, attr);
>  		break;
>  	case KVM_ARM_VCPU_TIMER_CTRL:

I agree with you for the most part on this patch, but I prefer we keep
the kvm_vcpu_has_pmu() with the ioctl implemementations rather than the
spot at which we demux the ioctl.

Thanks,
Oliver

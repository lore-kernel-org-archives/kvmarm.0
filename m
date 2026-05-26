Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E49813ACA5D
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 13:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779802899; cv=none; b=ds4SRb1HiEz4MAfZA1SRolMLQnEGiDumiMLbAZtKvhM/MC7YSYS7Oou3H8a6qpJr8wFNCgGB/5XYZEw/rqgRZkzMYLPoV8FbN2I+eCK3OLHxhphTwTBqcjsj4igJhF+Wi+MvwdNDWs0FnZIVzFKKY+runn8vd3AUOYNRUgE9Zow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779802899; c=relaxed/simple;
	bh=zovRuUMtML0sEnA6OEq5GlsauZ6Wk0t5c37ktbnESOE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=opvXBvf6WoBIyY7m8inC8anV8+BIwB/T0pQeqMrjJsNH7R84xv0/ACcC3dGgiO28dAHeg8vD4fy4bYWgwNcIt6PJkTs5fE9Me6oGHVOZ5dVYStZaQA167wvbSvtbeTb4saM51+B2Pj/5p6UwHtf98M5jnE+xggagr55CQZfWRD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Fd+j7S0D; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Fd+j7S0D"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34B25169C;
	Tue, 26 May 2026 06:41:32 -0700 (PDT)
Received: from [10.1.28.159] (e121487-lin.cambridge.arm.com [10.1.28.159])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DBF83F7D8;
	Tue, 26 May 2026 06:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779802897; bh=zovRuUMtML0sEnA6OEq5GlsauZ6Wk0t5c37ktbnESOE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Fd+j7S0DnwqIIR3oGp8IZBXpKBXuqYiDZ1+02zrvCb+PwUuoqdUJ11xfpGDIu6whV
	 YygeT/jiUDhO5CZnY2G9WmxNTUN1Bwj6am3so7Crxw4ciDM/TtrW9hmY30MmQRxPcu
	 Q16Fzxl4N0kha+sU0F1RMPpx8hWrqafsxlVOzAs0=
Message-ID: <b87810db-a221-46c1-abf1-a0444fc8bd02@arm.com>
Date: Tue, 26 May 2026 14:41:33 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 29/39] KVM: arm64: gic-v5: Support SPI injection
To: Sascha Bischoff <Sascha.Bischoff@arm.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
 Timothy Hayes <Timothy.Hayes@arm.com>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
 <20260521144846.1899475-30-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20260521144846.1899475-30-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Sascha,

On 5/21/26 15:59, Sascha Bischoff wrote:
>  	/* SPIs */
> -	if (intid >= VGIC_NR_PRIVATE_IRQS &&
> -	    intid < (kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)) {
> -		intid = array_index_nospec(intid, kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS);
> -		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
> +	if (__irq_is_spi(type, intid)) {
> +		switch (type) {
> +		case KVM_DEV_TYPE_ARM_VGIC_V5:
> +			intid = vgic_v5_get_hwirq_id(intid);
> +
> +			if (intid >= kvm->arch.vgic.nr_spis)
> +				return NULL;
> +
> +			intid = array_index_nospec(intid, kvm->arch.vgic.nr_spis);
> +			return &kvm->arch.vgic.spis[intid];
> +		default:
> +			u32 max_intid = kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
> +
> +			if (intid < max_intid) {
> +				intid = array_index_nospec(intid, max_intid);
> +				return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
> +			}
> +		}
>  	}

Just quick update to save everybody's time. That hunk causes my build fail with:

arch/arm64/kvm/vgic/vgic.c: In function 'vgic_get_irq':
arch/arm64/kvm/vgic/vgic.c:103:4: error: a label can only be part of a statement and a declaration is not a statement
  103 |    u32 max_intid = kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
      |    ^~~
make[4]: *** [scripts/Makefile.build:289: arch/arm64/kvm/vgic/vgic.o] Error 1
make[3]: *** [scripts/Makefile.build:548: arch/arm64/kvm] Error 2
make[2]: *** [scripts/Makefile.build:548: arch/arm64] Error 2

Obvious fix-up would be wrap default case into curly braces.

Cheers
Vladimir


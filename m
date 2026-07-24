Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67ECF2F7EF2
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 06:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784873732; cv=none; b=ddUNwSIlvM9xsiGD6aJ5dt0TtQ+KqL3R90kPl9AUUeyt9m0Mvi/5kK9hV/ltDgnHAAWM1MGmmLU4MSdM6+/rrZbdmbiaT8Lu4EyGWNOr6MIGXpg6V2imLzKEP2dB0XJc3SOn2dYTvfvsNvCUAxblcw2aXgsOubKXefKN+ZcjC+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784873732; c=relaxed/simple;
	bh=yAP6ty4uMEnDK6vUaHnRa+ibJVNZodNJWTfkw1TH+Vg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PcD/L3Xt25nohkGeRdIqAp50XV1c5WomBZLJ5Iht4+A5OiUuAxJlNggXYnQTBYROpbsjwVmFfrA97rnTBNT10Acvftj9uMVrk7LZUC7DELpBba5w6ctVsHKMJy/WEslORpsptD0gypUtrqtnWVLiZuF6lCz/x181rTlESWMec1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=HMczlaeT; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="HMczlaeT"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784873726; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=aDp6QAQVBbqcbjhun7HZkm4ce/Tk1AAMzwD4Ki2+UTk=;
	b=HMczlaeTNOm1gs01DoIXVVl/aF4i2xZwHmZ+iaeVBAMNO3s5/bju38nfnvRKX01qjfWiG9U4yAuDCNsPE9trjXiYeZb57HtEKsPO4AxH51KuZtUpMQ/26+84YRjwg49B8eGkMkh3jAQ2vjdVjqhpZz6kYCOmQstX0nplSZ2E1j8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X7iEB63_1784873724;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X7iEB63_1784873724 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Jul 2026 14:15:24 +0800
Date: Fri, 24 Jul 2026 14:15:23 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 19/28] KVM: arm64: Make HCR_EL2 a non-VNCR register
Message-ID: <eq54itdtb62ubzkapzrqxbnv7nkwfzhxehkuvy4nm5st5525kx@2rxzly5g3mjs>
References: <20260722074234.3330999-1-maz@kernel.org>
 <20260722074234.3330999-20-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722074234.3330999-20-maz@kernel.org>

On Wed, Jul 22, 2026 at 08:42:25AM +0800, Marc Zyngier wrote:
> FEAT_NV3 makes a fundamental change to the architecture, by moving
> guest-initiated HCR_EL2 accesses to the NVHCR_EL2 register. As the
> names suggests, this is HCR_EL2 for a NV guest.
>
> But where do NVHCR_EL2 accesses from a guest go? The are redirected
> to the VNCR page, right where HCR_EL2 is stored in the NV2 case.
> Does it hurt? Good. There's more coming.
>
> The challenge here is to make KVM work seamlessly, without rewriting
> everything. Which implies that things such as __vcpu_sys_reg(HCR_EL2)
> must work, no matter the underlying NV implementation.
>
> A simple way to deal with it is to move HCR_EL2's canonical storage
> outside of VNCR for the vast majority of the KVM code, and only have
> a copy at entry/exit times. Given that we don't really support NV3
> yet, this is pretty simple.
>
> In the process, advertise NVHCR_EL2 as the register that now holds
> offset 0x78 in the VNCR page.
>
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h     | 3 ++-
>  arch/arm64/include/asm/vncr_mapping.h | 2 +-
>  arch/arm64/kvm/hyp/vhe/switch.c       | 9 +++++++++
>  3 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index bae2c4f92ef5c..2648c8a717ba0 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -543,6 +543,7 @@ enum vcpu_sysreg {
>  	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
>  	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
>  	ZCR_EL2,	/* SVE Control Register (EL2) */
> +	HCR_EL2,	/* Hypervisor Control Register */
>
>  	/* Any VNCR-capable reg goes after this point */
>  	MARKER(__VNCR_START__),
> @@ -571,7 +572,7 @@ enum vcpu_sysreg {
>  	VNCR(TFSR_EL1),	/* Tag Fault Status Register (EL1) */
>  	VNCR(VPIDR_EL2),/* Virtualization Processor ID Register */
>  	VNCR(VMPIDR_EL2),/* Virtualization Multiprocessor ID Register */
> -	VNCR(HCR_EL2),	/* Hypervisor Configuration Register */
> +	VNCR(NVHCR_EL2),/* NV Hypervisor Configuration Register */
>  	VNCR(HSTR_EL2),	/* Hypervisor System Trap Register */
>  	VNCR(VTTBR_EL2),/* Virtualization Translation Table Base Register */
>  	VNCR(VTCR_EL2),	/* Virtualization Translation Control Register */
> diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
> index 14366d35ce82f..9e8a49fa8b638 100644
> --- a/arch/arm64/include/asm/vncr_mapping.h
> +++ b/arch/arm64/include/asm/vncr_mapping.h
> @@ -11,7 +11,7 @@
>  #define VNCR_VTCR_EL2           0x040
>  #define VNCR_VMPIDR_EL2         0x050
>  #define VNCR_CNTVOFF_EL2        0x060
> -#define VNCR_HCR_EL2            0x078
> +#define VNCR_NVHCR_EL2          0x078
>  #define VNCR_HSTR_EL2           0x080
>  #define VNCR_VPIDR_EL2          0x088
>  #define VNCR_TPIDR_EL2          0x090
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 53af19212895d..e5a51dc3cbe5e 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -70,6 +70,9 @@ static u64 __compute_hcr(struct kvm_vcpu *vcpu)
>  		if (!vcpu_el2_e2h_is_set(vcpu))
>  			hcr |= HCR_NV1;
>
> +		/* Publish the guest's view of HCR_EL2 to the HW */
> +		__vcpu_assign_sys_reg(vcpu, NVHCR_EL2, __vcpu_sys_reg(vcpu, HCR_EL2));
> +
>  		/*
>  		 * Nothing in HCR_EL2 should impact running in hypervisor
>  		 * context, apart from bits we have defined as RESx (E2H,
> @@ -549,6 +552,7 @@ static void fixup_nv_guest_exit(struct kvm_vcpu *vcpu)
>  	 */
>  	if (unlikely(host_data_test_flag(VCPU_IN_HYP_CONTEXT))) {
>  		u64 mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
> +		u64 hcr;
>
>  		switch (mode) {
>  		case PSR_MODE_EL1t:
> @@ -561,6 +565,11 @@ static void fixup_nv_guest_exit(struct kvm_vcpu *vcpu)
>
>  		*vcpu_cpsr(vcpu) &= ~(PSR_MODE_MASK | PSR_MODE32_BIT);
>  		*vcpu_cpsr(vcpu) |= mode;
> +
> +		/* Publish the latest HCR_EL2 to the emulation */
> +		hcr = __vcpu_sys_reg(vcpu, NVHCR_EL2);
> +
> +		__vcpu_assign_sys_reg(vcpu, HCR_EL2, hcr);

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>  	}
>
>  	/* Apply extreme paranoia! */
> --
> 2.47.3

Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC8931AF24
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 08:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784882446; cv=none; b=DLPwN8gxCCDY0yPoD03MK7iQTntBExLuZEfHE0qZkT7HbaYb4OxqwQdS2298HKnk3ZWw1o/PvjkNWDTaW87cSg3/Tp+RsXc7edb7LanpXZKVAXtvmPxLpn6AumQ4Q2pSGNgaxazDFGepHSWHZfjnIfO/VspHkWixNJj49XB3cb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784882446; c=relaxed/simple;
	bh=P4MH6DtFxUb788hAKigozvp2fXBiU/xoanJ6KjnelOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TQL/GmMlcITh8IOxDbdL9xP7biBaKJVMC8fMtivzmaCGUJVqaJECHP1Kz0CLIdL0x+Y95lFPt7Le7CkCiQfeix4jfmrCQ85NdxCVzZy87wGX09HHr7ZmsZ4othoAXDGrktv6Nsh9x6/mlDPHgO6dFoO6ByrMZuQW0SQklxvUT5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=crJfkJCU; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="crJfkJCU"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784882440; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=ZF0iQLfzAvBUCWBc6u2tYLj3HbiOY3Ow4lnc9zCLabE=;
	b=crJfkJCU1mk82tjdR/O3d5YqSVhzznXdN2ArVISZX9sOAxWmXkoRNjID1QIkE6n2eJV/pe6WNLbbs8lVwa2WxW4HcI6eRdnjA1t888th1k7i3WdbFjfKC0Jy3E2VqzkRGy2EcTXpe8ZmhDCNVZDzJwx+JCNDK42fbVDpah3WqMU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X7ia0lT_1784882439;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X7ia0lT_1784882439 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Jul 2026 16:40:39 +0800
Date: Fri, 24 Jul 2026 16:40:38 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 24/28] KVM: arm64: Engage NV3 ERET trap elision
Message-ID: <n2ora3retqaoki3u5ovoqwvh4iqzsziqmybzxid7mylcoua2fc@xlhyqzhwh4cl>
References: <20260722074234.3330999-1-maz@kernel.org>
 <20260722074234.3330999-25-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722074234.3330999-25-maz@kernel.org>

On Wed, Jul 22, 2026 at 08:42:30AM +0800, Marc Zyngier wrote:
> When running on NV3 HW, always engage ERET trap elision when running
> the L1 context, as there is no benefit in not doing so.
>
> An L1 can itself engage trap elision by setting its own view of
> HCRX_EL2.NVTGE==1, which will subsequently be honored.
>
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 10 ++++++++++
>  arch/arm64/kvm/hyp/vhe/switch.c      |  4 ++++
>  2 files changed, 14 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index c562d8171d5e1..b32870a5e1236 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -706,6 +706,16 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
>
>  		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V))
>  			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
> +
> +		/*
> +		 * NV3 is a host-specific extension, and we always use it
> +		 * when present and that the guest uses NV. It may be be
> +		 * hidden from the guest though.
> +		 */
> +		if (cpus_have_final_cap(ARM64_HAS_NV3) &&
> +		    vcpu_has_nv(vcpu) && vcpu_el2_e2h_is_set(vcpu)) {
> +			vcpu->arch.hcrx_el2 |= HCRX_EL2_NVTGE;
> +		}
>  	}
>  }
>  #endif /* __ARM64_KVM_EMULATE_H__ */
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index cbda9e087db39..4ed745bdde418 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -345,6 +345,10 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	u64 esr = kvm_vcpu_get_esr(vcpu);
>  	u64 spsr, elr, mode;
>
> +	/* With NV3, the fast path is handled in HW */
> +	if (cpus_have_final_cap(ARM64_HAS_NV3) && vcpu_el2_e2h_is_set(vcpu))
> +		return false;
> +

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>  	/*
>  	 * Going through the whole put/load motions is a waste of time
>  	 * if this is a VHE guest hypervisor returning to its own
> --
> 2.47.3

Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABC6524C
	for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 12:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692619968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ECXndoZvyamApppBKPzFOUWu2BynJjW97KIWX+GR6Jk=;
	b=T8bOtpcIkw94fwnQlpDsBlyaftltdqwVOkE7089IVNe4KUDV2ezJ3vZinv+PFhnNonypfO
	Ms4/iEmIHyTaI+Ppsu2Ev5yAK0vwFXGy4eGQ2j7oDvnvw0nqo94nZ4dWXKADRIPMiWc+ws
	IAeapsjKeOwcTzaBbLgWOHb6AbnS5a8=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-zCEQrhucPDyA_RbRGWlFQA-1; Mon, 21 Aug 2023 08:12:47 -0400
X-MC-Unique: zCEQrhucPDyA_RbRGWlFQA-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-67d0eacdf97so666275b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 05:12:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692619966; x=1693224766;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ECXndoZvyamApppBKPzFOUWu2BynJjW97KIWX+GR6Jk=;
        b=VfV33X6v9qjQNlbNY0zkOBAOlxwi1auk413UlsXPpiIf1I9TIxjCNkihhznK/xV7l8
         CcgFy2HunJtITMsrEcSQdQ06aXC1vSeAgX2DMDKRhtI8yKcaqVJn0bvDL/2JK0WN9ZRH
         /fY8akykAgi5csWgqhV3A+u3HMpDmBGH7RxY5bc4tuqmghKbek4h2pnENI4iixFVKfgd
         Cve27yOT6Mev07S+/eRdz609GJwZuv/Q2dM+PPkvCxH78Pg9zEfcZVH88VCEVbWkO47Z
         BJHgexGHfyNDRYp+XBtAurEHfhSeNtmMxF55UaEydwfZLe2vEUGf8jcYMr6cOUtuhJFT
         Autw==
X-Gm-Message-State: AOJu0YxwRbbKJBK1+bmvUuc6QPjLDyAbcqDATyXT5NeXq6wGGiLqAgL/
	VL+iAqRxPCDWl7PAIbe0mZX62UgorVqTUiq0ueX8KmRl/LYnzAfIOQZDv/gJIFEHef209Cs7LTq
	wBABM/gzbFObvdty5
X-Received: by 2002:a05:6a00:1f89:b0:68a:33fc:a091 with SMTP id bg9-20020a056a001f8900b0068a33fca091mr5833938pfb.3.1692619965772;
        Mon, 21 Aug 2023 05:12:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFvw1hhG3XW7vCKln+lTK3xY6Su93VvprY9gNYjCOP5faDv3G1wVKA6bGu165soGXVLu5is+g==
X-Received: by 2002:a05:6a00:1f89:b0:68a:33fc:a091 with SMTP id bg9-20020a056a001f8900b0068a33fca091mr5833910pfb.3.1692619965352;
        Mon, 21 Aug 2023 05:12:45 -0700 (PDT)
Received: from [10.72.112.73] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j20-20020a62e914000000b00688c733fe92sm5982354pfh.215.2023.08.21.05.12.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Aug 2023 05:12:44 -0700 (PDT)
Message-ID: <6dc460d2-c7fb-e299-b0a3-55b43de31555@redhat.com>
Date: Mon, 21 Aug 2023 20:12:39 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v5 08/12] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
To: Raghavendra Rao Ananta <rananta@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Jing Zhang <jingzhangos@google.com>,
 Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20230817003029.3073210-1-rananta@google.com>
 <20230817003029.3073210-9-rananta@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230817003029.3073210-9-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Raghavendra,

On 8/17/23 08:30, Raghavendra Rao Ananta wrote:
> From: Reiji Watanabe <reijiw@google.com>
> 
> KVM does not yet support userspace modifying PMCR_EL0.N (With
> the previous patch, KVM ignores what is written by upserspace).
> Add support userspace limiting PMCR_EL0.N.
> 
> Disallow userspace to set PMCR_EL0.N to a value that is greater
> than the host value (KVM_SET_ONE_REG will fail), as KVM doesn't
> support more event counters than the host HW implements.
> Although this is an ABI change, this change only affects
> userspace setting PMCR_EL0.N to a larger value than the host.
> As accesses to unadvertised event counters indices is CONSTRAINED
> UNPREDICTABLE behavior, and PMCR_EL0.N was reset to the host value
> on every vCPU reset before this series, I can't think of any
> use case where a user space would do that.
> 
> Also, ignore writes to read-only bits that are cleared on vCPU reset,
> and RES{0,1} bits (including writable bits that KVM doesn't support
> yet), as those bits shouldn't be modified (at least with
> the current KVM).
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>   arch/arm64/include/asm/kvm_host.h |  3 ++
>   arch/arm64/kvm/pmu-emul.c         |  1 +
>   arch/arm64/kvm/sys_regs.c         | 49 +++++++++++++++++++++++++++++--
>   3 files changed, 51 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 0f2dbbe8f6a7e..c15ec365283d1 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -259,6 +259,9 @@ struct kvm_arch {
>   	/* PMCR_EL0.N value for the guest */
>   	u8 pmcr_n;
>   
> +	/* Limit value of PMCR_EL0.N for the guest */
> +	u8 pmcr_n_limit;
> +
>   	/* Hypercall features firmware registers' descriptor */
>   	struct kvm_smccc_features smccc_feat;
>   	struct maple_tree smccc_filter;
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index ce7de6bbdc967..39ad56a71ad20 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -896,6 +896,7 @@ int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
>   	 * while the latter does not.
>   	 */
>   	kvm->arch.pmcr_n = arm_pmu->num_events - 1;
> +	kvm->arch.pmcr_n_limit = arm_pmu->num_events - 1;
>   
>   	return 0;
>   }
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 2075901356c5b..c01d62afa7db4 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1086,6 +1086,51 @@ static int get_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
>   	return 0;
>   }
>   
> +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +		    u64 val)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	u64 new_n, mutable_mask;
> +	int ret = 0;
> +
> +	new_n = FIELD_GET(ARMV8_PMU_PMCR_N, val);
> +
> +	mutex_lock(&kvm->arch.config_lock);
> +	if (unlikely(new_n != kvm->arch.pmcr_n)) {
> +		/*
> +		 * The vCPU can't have more counters than the PMU
> +		 * hardware implements.
> +		 */
> +		if (new_n <= kvm->arch.pmcr_n_limit)
> +			kvm->arch.pmcr_n = new_n;
> +		else
> +			ret = -EINVAL;
> +	}

Since we have set the default value of pmcr_n, if we want to set a new 
pmcr_n, shouldn't it be a different value?

So how about change the checking to:

if (likely(new_n <= kvm->arch.pmcr_n_limit)
	kvm->arch.pmcr_n = new_n;
else
	ret = -EINVAL;

what do you think?

> +	mutex_unlock(&kvm->arch.config_lock);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Ignore writes to RES0 bits, read only bits that are cleared on
> +	 * vCPU reset, and writable bits that KVM doesn't support yet.
> +	 * (i.e. only PMCR.N and bits [7:0] are mutable from userspace)
> +	 * The LP bit is RES0 when FEAT_PMUv3p5 is not supported on the vCPU.
> +	 * But, we leave the bit as it is here, as the vCPU's PMUver might
> +	 * be changed later (NOTE: the bit will be cleared on first vCPU run
> +	 * if necessary).
> +	 */
> +	mutable_mask = (ARMV8_PMU_PMCR_MASK | ARMV8_PMU_PMCR_N);
> +	val &= mutable_mask;
> +	val |= (__vcpu_sys_reg(vcpu, r->reg) & ~mutable_mask);
> +
> +	/* The LC bit is RES1 when AArch32 is not supported */
> +	if (!kvm_supports_32bit_el0())
> +		val |= ARMV8_PMU_PMCR_LC;
> +
> +	__vcpu_sys_reg(vcpu, r->reg) = val;
> +	return 0;
> +}
> +
>   /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
>   #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
>   	{ SYS_DESC(SYS_DBGBVRn_EL1(n)),					\
> @@ -2147,8 +2192,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>   	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
>   	{ SYS_DESC(SYS_SVCR), undef_access },
>   
> -	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr,
> -	  .reset = reset_pmcr, .reg = PMCR_EL0, .get_user = get_pmcr },
> +	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
> +	  .reg = PMCR_EL0, .get_user = get_pmcr, .set_user = set_pmcr },

A little confusing, since the PMU_SYS_REG() defines the default 
visibility which is pmu_visibility can return REG_HIDDEN, the set_user 
to pmcr will be blocked, how can it being set?

Maybe I lose some details.

Thanks,
Shaoqin

>   	{ PMU_SYS_REG(PMCNTENSET_EL0),
>   	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
>   	{ PMU_SYS_REG(PMCNTENCLR_EL0),

-- 
Shaoqin


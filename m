Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE33B6FA2
	for <kvmarm@lists.linux.dev>; Tue, 22 Aug 2023 10:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692698758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ljh8mgcq2yx3L1h9FQGeznUQ1rxHUXwLkH1HroGp6xY=;
	b=Fc3sghnPB+cOCrzZiRoA3OvA9RoJSJWKlx+2N7ly6F9aoZJcKpVmGIJipFkd0MSiheegHR
	lW8UL/Pz4gO8ElRU6ilmKyunld336sbvOZTkcpPjl0Yj18zJ8O4d3u/9aryMQA/7ec1Bj7
	Now8FSjGyMLAHtyRdszSY7+rwyfjEsA=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-571-q59TA34ZOP2a61sq4sI9pg-1; Tue, 22 Aug 2023 06:05:57 -0400
X-MC-Unique: q59TA34ZOP2a61sq4sI9pg-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1c06de43310so3385885ad.1
        for <kvmarm@lists.linux.dev>; Tue, 22 Aug 2023 03:05:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692698754; x=1693303554;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ljh8mgcq2yx3L1h9FQGeznUQ1rxHUXwLkH1HroGp6xY=;
        b=bVkaf76vlSZ0KJfdg92p+uneJ1HEAdCRGndO4RsuhBE2GXk6/cSeMSrz6w+ekvJ3nN
         VEQ+mWCcAw+OxXPZcm1VN2DiBEGFcdpVwpF/6O7eAKyP/yyo7f0QqHn9+4T96K+uUxPq
         d4zwgabXP5ZQ4PnAqz6/JdXkF/yqF6Z6i+P87MgTeMSScfyjAOwlPwr4wMsQZ4jgTcaS
         +nZpE8l9RWOkqdphf+JuOOckn3maBIc1zwkHfTS6pckpmBmaQRXMg1z+tapG1GZ00XNl
         /A294LM4KrHFLpbUUBkV3aYzI0jcDbOPlTMNlKEDGV9GjDUyLSfyd0zhmZMHg0tEHi0g
         JnHQ==
X-Gm-Message-State: AOJu0Yy/Hqlt46uTUvnT+uXaTk/Yd/t9Lffc2h2u3yyLO26dKhrg43gv
	dwxNIEb+5As5zNIyA0x2ojHRrkGQ5eguPttjlIqQDK/jQF4SDvWg8EOWQnRywrA8oQqp3St0I2L
	8Q1MrmssUx+SCB2u1
X-Received: by 2002:a17:902:cecc:b0:1b3:ec39:f42c with SMTP id d12-20020a170902cecc00b001b3ec39f42cmr10623695plg.5.1692698754300;
        Tue, 22 Aug 2023 03:05:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEBhn68XouwWIaKc08runbGqmfjkKyK5I3i4ktoUZ68HemKWF8GXSCA5juwTjuCj2HbOAuLAA==
X-Received: by 2002:a17:902:cecc:b0:1b3:ec39:f42c with SMTP id d12-20020a170902cecc00b001b3ec39f42cmr10623682plg.5.1692698753973;
        Tue, 22 Aug 2023 03:05:53 -0700 (PDT)
Received: from [10.72.112.73] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q4-20020a170902bd8400b001b9f032bb3dsm8603671pls.3.2023.08.22.03.05.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Aug 2023 03:05:52 -0700 (PDT)
Message-ID: <1c6c07af-f6d0-89a6-1b7d-164ca100ac88@redhat.com>
Date: Tue, 22 Aug 2023 18:05:47 +0800
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
> +	mutex_unlock(&kvm->arch.config_lock);

Another thing I am just wonder is that should we block any modification 
to the pmcr_n after vm start to run? Like add one more checking 
kvm_vm_has_ran_once() at the beginning of the set_pmcr() function.

Thanks,
Shaoqin

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
>   	{ PMU_SYS_REG(PMCNTENSET_EL0),
>   	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
>   	{ PMU_SYS_REG(PMCNTENCLR_EL0),

-- 
Shaoqin


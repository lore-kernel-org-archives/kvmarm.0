Return-Path: <SRS0=tngP=VU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E3AC7618E
	for <kvmarm@archiver.kernel.org>; Tue, 23 Jul 2019 08:17:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 43C0E20449
	for <kvmarm@archiver.kernel.org>; Tue, 23 Jul 2019 08:17:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 43C0E20449
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF46F4A521;
	Tue, 23 Jul 2019 04:17:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PRMfZ1taP-bh; Tue, 23 Jul 2019 04:17:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22DEC4A552;
	Tue, 23 Jul 2019 04:17:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 712F14A542
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jul 2019 04:17:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y8g3Ax1iCLJM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Jul 2019 04:17:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 780974A521
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jul 2019 04:17:14 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF7CD344;
 Tue, 23 Jul 2019 01:17:13 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F2393F71F;
 Tue, 23 Jul 2019 01:17:12 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: arm/arm64: Introduce kvm_pmu_vcpu_init() to setup
 PMU counter idx
To: Zenghui Yu <yuzenghui@huawei.com>, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
References: <1563437710-30756-1-git-send-email-yuzenghui@huawei.com>
From: Julien Thierry <julien.thierry@arm.com>
Message-ID: <f3f6f9a9-9735-e253-7b5b-3ccf97619a16@arm.com>
Date: Tue, 23 Jul 2019 09:17:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1563437710-30756-1-git-send-email-yuzenghui@huawei.com>
Content-Language: en-US
Cc: marc.zyngier@arm.com, linux-kernel@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Zenghui,

On 18/07/2019 09:15, Zenghui Yu wrote:
> We use "pmc->idx" and the "chained" bitmap to determine if the pmc is
> chained, in kvm_pmu_pmc_is_chained().  But idx might be uninitialized
> (and random) when we doing this decision, through a KVM_ARM_VCPU_INIT
> ioctl -> kvm_pmu_vcpu_reset(). And the test_bit() against this random
> idx will potentially hit a KASAN BUG [1].
> 
> In general, idx is the static property of a PMU counter that is not
> expected to be modified across resets, as suggested by Julien.  It
> looks more reasonable if we can setup the PMU counter idx for a vcpu
> in its creation time. Introduce a new function - kvm_pmu_vcpu_init()
> for this basic setup. Oh, and the KASAN BUG will get fixed this way.
> 
> [1] https://www.spinics.net/lists/kvm-arm/msg36700.html
> 
> Fixes: 80f393a23be6 ("KVM: arm/arm64: Support chained PMU counters")
> Suggested-by: Andrew Murray <andrew.murray@arm.com>
> Suggested-by: Julien Thierry <julien.thierry@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
> 
> Changes since v1:
>  - Introduce kvm_pmu_vcpu_init() in vcpu's creation time, move the
>    assignment of pmc->idx into it.
>  - Thus change the subject. The old one is "KVM: arm/arm64: Assign
>    pmc->idx before kvm_pmu_stop_counter()".
> 
> Julien, I haven't collected your Acked-by into this version. If you're
> still happy with the change, please Ack again. Thanks!
> 

Thanks for making the change. This looks good to me:

Acked-by: Julien Thierry <julien.thierry@arm.com>

Thanks,

Julien

>  include/kvm/arm_pmu.h |  2 ++
>  virt/kvm/arm/arm.c    |  2 ++
>  virt/kvm/arm/pmu.c    | 18 +++++++++++++++---
>  3 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 16c769a..6db0304 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -34,6 +34,7 @@ struct kvm_pmu {
>  u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
>  void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
>  u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
> +void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu);
>  void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu);
>  void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu);
>  void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val);
> @@ -71,6 +72,7 @@ static inline u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
>  {
>  	return 0;
>  }
> +static inline void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val) {}
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index f645c0f..c704fa6 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -340,6 +340,8 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>  	/* Set up the timer */
>  	kvm_timer_vcpu_init(vcpu);
>  
> +	kvm_pmu_vcpu_init(vcpu);
> +
>  	kvm_arm_reset_debug_ptr(vcpu);
>  
>  	return kvm_vgic_vcpu_init(vcpu);
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 3dd8238..362a018 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -215,6 +215,20 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>  }
>  
>  /**
> + * kvm_pmu_vcpu_init - assign pmu counter idx for cpu
> + * @vcpu: The vcpu pointer
> + *
> + */
> +void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +
> +	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
> +		pmu->pmc[i].idx = i;
> +}
> +
> +/**
>   * kvm_pmu_vcpu_reset - reset pmu state for cpu
>   * @vcpu: The vcpu pointer
>   *
> @@ -224,10 +238,8 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
>  	int i;
>  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>  
> -	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
> +	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
>  		kvm_pmu_stop_counter(vcpu, &pmu->pmc[i]);
> -		pmu->pmc[i].idx = i;
> -	}
>  
>  	bitmap_zero(vcpu->arch.pmu.chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
>  }
> 

-- 
Julien Thierry
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

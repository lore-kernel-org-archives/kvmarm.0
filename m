Return-Path: <SRS0=5+eb=MG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E62C07E9A
	for <kvmarm@archiver.kernel.org>; Wed, 14 Jul 2021 16:11:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F3053613C0
	for <kvmarm@archiver.kernel.org>; Wed, 14 Jul 2021 16:11:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3053613C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CA924B08C;
	Wed, 14 Jul 2021 12:11:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y1EoAw8f5WpT; Wed, 14 Jul 2021 12:11:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09C754A4FC;
	Wed, 14 Jul 2021 12:11:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C8484A4FC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Jul 2021 12:11:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UeK0NcDqmxS2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Jul 2021 12:11:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 334144A19F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Jul 2021 12:11:01 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B666D6E;
 Wed, 14 Jul 2021 09:11:00 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 206BC3F7D8;
 Wed, 14 Jul 2021 09:10:57 -0700 (PDT)
Subject: Re: [PATCH 2/3] KVM: arm64: Drop unnecessary masking of PMU registers
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210713135900.1473057-1-maz@kernel.org>
 <20210713135900.1473057-3-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <e67684f9-e5df-072c-b6ac-f5adecfeb260@arm.com>
Date: Wed, 14 Jul 2021 17:12:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713135900.1473057-3-maz@kernel.org>
Content-Language: en-US
Cc: kernel-team@android.com, Robin Murphy <robin.murphy@arm.com>
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

Hi Marc,

On 7/13/21 2:58 PM, Marc Zyngier wrote:
> We always sanitise our PMU sysreg on the write side, so there
> is no need to do it on the read side as well.
>
> Drop the unnecessary masking.

Checked for all the remaining uses of kvm_pmu_valid_counter_mask in sys_regs.c and
in pmu-emul.c, and nothing stands out:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 3 +--
>  arch/arm64/kvm/sys_regs.c | 6 +++---
>  2 files changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index f33825c995cb..fae4e95b586c 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -373,7 +373,6 @@ static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
>  		reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
>  		reg &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
>  		reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
> -		reg &= kvm_pmu_valid_counter_mask(vcpu);
>  	}
>  
>  	return reg;
> @@ -569,7 +568,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
>  
>  	if (val & ARMV8_PMU_PMCR_E) {
>  		kvm_pmu_enable_counter_mask(vcpu,
> -		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask);
> +		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
>  	} else {
>  		kvm_pmu_disable_counter_mask(vcpu, mask);
>  	}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 95ccb8f45409..7ead93a8d67f 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -883,7 +883,7 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  			kvm_pmu_disable_counter_mask(vcpu, val);
>  		}
>  	} else {
> -		p->regval = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
> +		p->regval = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
>  	}
>  
>  	return true;
> @@ -907,7 +907,7 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  			/* accessing PMINTENCLR_EL1 */
>  			__vcpu_sys_reg(vcpu, PMINTENSET_EL1) &= ~val;
>  	} else {
> -		p->regval = __vcpu_sys_reg(vcpu, PMINTENSET_EL1) & mask;
> +		p->regval = __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
>  	}
>  
>  	return true;
> @@ -929,7 +929,7 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  			/* accessing PMOVSCLR_EL0 */
>  			__vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= ~(p->regval & mask);
>  	} else {
> -		p->regval = __vcpu_sys_reg(vcpu, PMOVSSET_EL0) & mask;
> +		p->regval = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
>  	}
>  
>  	return true;
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=Gv/P=VF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D23CDC606C2
	for <kvmarm@archiver.kernel.org>; Mon,  8 Jul 2019 15:31:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6419B21738
	for <kvmarm@archiver.kernel.org>; Mon,  8 Jul 2019 15:31:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6419B21738
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE2DB4A542;
	Mon,  8 Jul 2019 11:31:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CY3IXzY3+Ek8; Mon,  8 Jul 2019 11:31:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F96E4A532;
	Mon,  8 Jul 2019 11:31:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C02634A534
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jul 2019 11:31:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g86paxhEr9PF for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jul 2019 11:31:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 168754A532
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jul 2019 11:31:02 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AC959360;
 Mon,  8 Jul 2019 08:31:01 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C57723F59C;
 Mon,  8 Jul 2019 08:30:59 -0700 (PDT)
Date: Mon, 8 Jul 2019 16:30:57 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Julien Thierry <julien.thierry@arm.com>,
 Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 7/9] arm/arm64: kvm: pmu: Make overflow handler NMI safe
Message-ID: <20190708153057.GC36116@lakrids.cambridge.arm.com>
References: <1562596377-33196-1-git-send-email-julien.thierry@arm.com>
 <1562596377-33196-8-git-send-email-julien.thierry@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1562596377-33196-8-git-send-email-julien.thierry@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Cc: peterz@infradead.org, liwei391@huawei.com, will.deacon@arm.com,
 acme@kernel.org, alexander.shishkin@linux.intel.com, mingo@redhat.com,
 namhyung@kernel.org, jolsa@redhat.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Marc, I assume that you will take a look at this from the KVM side. :)

On Mon, Jul 08, 2019 at 03:32:55PM +0100, Julien Thierry wrote:
> When using an NMI for the PMU interrupt, taking any lock migh cause a
> deadlock. The current PMU overflow handler in KVM takes takes locks when
> trying to wake up a vcpu.
> 
> When overflow handler is called by an NMI, defer the vcpu waking in an
> irq_work queue.
> 
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Suzuki K Pouloze <suzuki.poulose@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
>  include/kvm/arm_pmu.h |  1 +
>  virt/kvm/arm/pmu.c    | 25 ++++++++++++++++++++++++-
>  2 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 16c769a..8202ed7 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -27,6 +27,7 @@ struct kvm_pmu {
>  	bool ready;
>  	bool created;
>  	bool irq_level;
> +	struct irq_work overflow_work;
>  };
> 
>  #define kvm_arm_pmu_v3_ready(v)		((v)->arch.pmu.ready)
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 3dd8238..63f358e 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -421,6 +421,22 @@ void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu)
>  }
> 
>  /**
> + * When perf interrupt is an NMI, we cannot safely notify the vcpu corresponding
> + * to the even.

Nit: s/even/event/

Thanks,
Mark.

> + * This is why we need a callback to do it once outside of the NMI context.
> + */
> +static void kvm_pmu_perf_overflow_notify_vcpu(struct irq_work *work)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_pmu *pmu;
> +
> +	pmu = container_of(work, struct kvm_pmu, overflow_work);
> +	vcpu = kvm_pmc_to_vcpu(&pmu->pmc[0]);
> +
> +	kvm_vcpu_kick(vcpu);
> +}
> +
> +/**
>   * When the perf event overflows, set the overflow status and inform the vcpu.
>   */
>  static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
> @@ -435,7 +451,11 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
> 
>  	if (kvm_pmu_overflow_status(vcpu)) {
>  		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
> -		kvm_vcpu_kick(vcpu);
> +
> +		if (!in_nmi())
> +			kvm_vcpu_kick(vcpu);
> +		else
> +			irq_work_queue(&vcpu->arch.pmu.overflow_work);
>  	}
>  }
> 
> @@ -706,6 +726,9 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
>  			return ret;
>  	}
> 
> +	init_irq_work(&vcpu->arch.pmu.overflow_work,
> +		      kvm_pmu_perf_overflow_notify_vcpu);
> +
>  	vcpu->arch.pmu.created = true;
>  	return 0;
>  }
> --
> 1.9.1
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

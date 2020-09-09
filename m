Return-Path: <SRS0=Sq8/=CS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B41C10DAA
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 17:14:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EC73B21919
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 17:14:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LyCTlaBo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC73B21919
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 219FF4B2C7;
	Wed,  9 Sep 2020 13:14:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DmKE1ugKG4DX; Wed,  9 Sep 2020 13:14:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDFB14B375;
	Wed,  9 Sep 2020 13:14:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 141514B36A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 13:14:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l5WPy7hP5j6j for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2020 13:14:38 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F235D4B2C7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 13:14:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599671677;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=rMR60tcDoXO9K50xEszi4aUwon86WuC1gxtUvojZvdU=;
 b=LyCTlaBoIeDP1fE/1m8HkIZSZwka+Ajm1+huCfUGaEZghruWm/xGfOeOwDFHcuCixvtWG9
 tHsKD0zbrUJ8Np47bDm2GZG18SGApn1ipVnILKiw2OZ5CrbyL8hAnnmvb+T6pZVlUjIMS2
 7dxgtn8ToIMk/xc8hra7gmdnIVPuDA0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-czylzb4sNfWf3kVGBQE8zw-1; Wed, 09 Sep 2020 13:14:33 -0400
X-MC-Unique: czylzb4sNfWf3kVGBQE8zw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3CFE805EE8;
 Wed,  9 Sep 2020 17:14:31 +0000 (UTC)
Received: from [10.36.115.123] (ovpn-115-123.ams2.redhat.com [10.36.115.123])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A88F9838B0;
 Wed,  9 Sep 2020 17:14:27 +0000 (UTC)
Subject: Re: [PATCH v3 3/5] KVM: arm64: Add PMU event filtering infrastructure
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20200908075830.1161921-1-maz@kernel.org>
 <20200908075830.1161921-4-maz@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <85e5a904-b1be-5fd5-e420-3b9da3fdde54@redhat.com>
Date: Wed, 9 Sep 2020 19:14:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200908075830.1161921-4-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: kernel-team@android.com, graf@amazon.com,
 Robin Murphy <robin.murphy@arm.com>
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

On 9/8/20 9:58 AM, Marc Zyngier wrote:
> It can be desirable to expose a PMU to a guest, and yet not want the
> guest to be able to count some of the implemented events (because this
> would give information on shared resources, for example.
> 
> For this, let's extend the PMUv3 device API, and offer a way to setup a
> bitmap of the allowed events (the default being no bitmap, and thus no
> filtering).
> 
> Userspace can thus allow/deny ranges of event. The default policy
> depends on the "polarity" of the first filter setup (default deny if the
> filter allows events, and default allow if the filter denies events).
> This allows to setup exactly what is allowed for a given guest.
> 
> Note that although the ioctl is per-vcpu, the map of allowed events is
> global to the VM (it can be setup from any vcpu until the vcpu PMU is
> initialized).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  5 +++
>  arch/arm64/include/uapi/asm/kvm.h | 16 +++++++
>  arch/arm64/kvm/arm.c              |  2 +
>  arch/arm64/kvm/pmu-emul.c         | 70 ++++++++++++++++++++++++++++---
>  4 files changed, 87 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 6cd60be69c28..1e64260b7e2b 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -111,6 +111,11 @@ struct kvm_arch {
>  	 */
>  	bool return_nisv_io_abort_to_user;
>  
> +	/*
> +	 * VM-wide PMU filter, implemented as a bitmap and big enough for
> +	 * up to 2^10 events (ARMv8.0) or 2^16 events (ARMv8.1+).
> +	 */
> +	unsigned long *pmu_filter;
>  	unsigned int pmuver;
>  };
>  
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index ba85bb23f060..7b1511d6ce44 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -159,6 +159,21 @@ struct kvm_sync_regs {
>  struct kvm_arch_memory_slot {
>  };
>  
> +/*
> + * PMU filter structure. Describe a range of events with a particular
> + * action. To be used with KVM_ARM_VCPU_PMU_V3_FILTER.
> + */
> +struct kvm_pmu_event_filter {
> +	__u16	base_event;
> +	__u16	nevents;
> +
> +#define KVM_PMU_EVENT_ALLOW	0
> +#define KVM_PMU_EVENT_DENY	1
> +
> +	__u8	action;
> +	__u8	pad[3];
> +};
> +
>  /* for KVM_GET/SET_VCPU_EVENTS */
>  struct kvm_vcpu_events {
>  	struct {
> @@ -329,6 +344,7 @@ struct kvm_vcpu_events {
>  #define KVM_ARM_VCPU_PMU_V3_CTRL	0
>  #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
>  #define   KVM_ARM_VCPU_PMU_V3_INIT	1
> +#define   KVM_ARM_VCPU_PMU_V3_FILTER	2
>  #define KVM_ARM_VCPU_TIMER_CTRL		1
>  #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
>  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 691d21e4c717..0f11d0009c17 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -145,6 +145,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  {
>  	int i;
>  
> +	bitmap_free(kvm->arch.pmu_filter);
> +
>  	kvm_vgic_destroy(kvm);
>  
>  	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 8a5f65763814..67a731bafbc9 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -30,6 +30,7 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
>  	case 6:			/* ARMv8.5 */
>  		return GENMASK(15, 0);
>  	default:		/* Shouldn't be there, just for sanity */
> +		WARN_ONCE(1, "Unknown PMU version %d\n", kvm->arch.pmuver);
rather belongs to previous patch
>  		return 0;
>  	}
>  }
> @@ -592,11 +593,21 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>  	data = __vcpu_sys_reg(vcpu, reg);
>  
>  	kvm_pmu_stop_counter(vcpu, pmc);
> -	eventsel = data & kvm_pmu_event_mask(vcpu->kvm);;
> +	if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> +		eventsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
So from a filter pov the cycle counter is assimilated to the event
counter CPU_CYCLES event (0x11). I see there are some differences
between PMCCNTR and 0x11 counting (wrt PMCR, ...) though. Shouldn't we
mention the cycle counter is getting filtered as well
> +	else
> +		eventsel = data & kvm_pmu_event_mask(vcpu->kvm);
> +
> +	/* Software increment event doesn't need to be backed by a perf event */
> +	if (eventsel == ARMV8_PMUV3_PERFCTR_SW_INCR)
> +		return;
>  
> -	/* Software increment event does't need to be backed by a perf event */
> -	if (eventsel == ARMV8_PMUV3_PERFCTR_SW_INCR &&
> -	    pmc->idx != ARMV8_PMU_CYCLE_IDX)
> +	/*
> +	 * If we have a filter in place and that the event isn't allowed, do
> +	 * not install a perf event either.
> +	 */
> +	if (vcpu->kvm->arch.pmu_filter &&
> +	    !test_bit(eventsel, vcpu->kvm->arch.pmu_filter))
>  		return;
>  
>  	memset(&attr, 0, sizeof(struct perf_event_attr));
> @@ -608,8 +619,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>  	attr.exclude_kernel = data & ARMV8_PMU_EXCLUDE_EL1 ? 1 : 0;
>  	attr.exclude_hv = 1; /* Don't count EL2 events */
>  	attr.exclude_host = 1; /* Don't count host events */
> -	attr.config = (pmc->idx == ARMV8_PMU_CYCLE_IDX) ?
> -		ARMV8_PMUV3_PERFCTR_CPU_CYCLES : eventsel;
> +	attr.config = eventsel;
>  
>  	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
>  
> @@ -892,6 +902,53 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  		vcpu->arch.pmu.irq_num = irq;
>  		return 0;
>  	}
> +	case KVM_ARM_VCPU_PMU_V3_FILTER: {
> +		struct kvm_pmu_event_filter __user *uaddr;
> +		struct kvm_pmu_event_filter filter;
> +		int nr_events;
> +
> +		nr_events = kvm_pmu_event_mask(vcpu->kvm) + 1;
> +
> +		uaddr = (struct kvm_pmu_event_filter __user *)(long)attr->addr;
> +
> +		if (copy_from_user(&filter, uaddr, sizeof(filter)))
> +			return -EFAULT;
> +
> +		if (((u32)filter.base_event + filter.nevents) > nr_events ||
> +		    (filter.action != KVM_PMU_EVENT_ALLOW &&
> +		     filter.action != KVM_PMU_EVENT_DENY))
> +			return -EINVAL;
> +
> +		mutex_lock(&vcpu->kvm->lock);
> +
> +		if (!vcpu->kvm->arch.pmu_filter) {
> +			vcpu->kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL);
> +			if (!vcpu->kvm->arch.pmu_filter) {
> +				mutex_unlock(&vcpu->kvm->lock);
> +				return -ENOMEM;
> +			}
> +
> +			/*
> +			 * The default depends on the first applied filter.
> +			 * If it allows events, the default is to deny.
> +			 * Conversely, if the first filter denies a set of
> +			 * events, the default is to allow.
> +			 */
> +			if (filter.action == KVM_PMU_EVENT_ALLOW)
> +				bitmap_zero(vcpu->kvm->arch.pmu_filter, nr_events);
> +			else
> +				bitmap_fill(vcpu->kvm->arch.pmu_filter, nr_events);
> +		}
> +
> +		if (filter.action == KVM_PMU_EVENT_ALLOW)
> +			bitmap_set(vcpu->kvm->arch.pmu_filter, filter.base_event, filter.nevents);
> +		else
> +			bitmap_clear(vcpu->kvm->arch.pmu_filter, filter.base_event, filter.nevents);
> +
> +		mutex_unlock(&vcpu->kvm->lock);
> +
> +		return 0;
> +	}
>  	case KVM_ARM_VCPU_PMU_V3_INIT:
>  		return kvm_arm_pmu_v3_init(vcpu);
>  	}
> @@ -928,6 +985,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  	switch (attr->attr) {
>  	case KVM_ARM_VCPU_PMU_V3_IRQ:
>  	case KVM_ARM_VCPU_PMU_V3_INIT:
> +	case KVM_ARM_VCPU_PMU_V3_FILTER:
>  		if (kvm_arm_support_pmu_v3() &&
>  		    test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
>  			return 0;
> 
Thanks

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

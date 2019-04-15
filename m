Return-Path: <SRS0=r5x+=SR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95AA0C10F0E
	for <kvmarm@archiver.kernel.org>; Mon, 15 Apr 2019 13:43:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2198420833
	for <kvmarm@archiver.kernel.org>; Mon, 15 Apr 2019 13:43:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2198420833
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 887964A486;
	Mon, 15 Apr 2019 09:43:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2iRbh4UdaIE2; Mon, 15 Apr 2019 09:43:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 598AE4A4D4;
	Mon, 15 Apr 2019 09:43:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B45E34A486
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 09:43:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3orfk39a38za for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Apr 2019 09:43:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B7984A484
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 09:43:40 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A106B374;
 Mon, 15 Apr 2019 06:43:39 -0700 (PDT)
Received: from [10.1.196.93] (en101.cambridge.arm.com [10.1.196.93])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0C8F23F68F;
 Mon, 15 Apr 2019 06:43:37 -0700 (PDT)
Subject: Re: [PATCH v13 6/8] arm64: KVM: Enable VHE support for :G/:H perf
 event modifiers
To: andrew.murray@arm.com, christoffer.dall@arm.com, marc.zyngier@arm.com,
 catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com
References: <20190409192217.23459-1-andrew.murray@arm.com>
 <20190409192217.23459-7-andrew.murray@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <2bbd0c72-3f51-f942-d6a2-478db940445f@arm.com>
Date: Mon, 15 Apr 2019 14:43:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190409192217.23459-7-andrew.murray@arm.com>
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190415134336.ZWxd1SSY-dvZ6e60PmJ-PBStcKj2gZQGOuoLG84liD0@z>



On 09/04/2019 20:22, Andrew Murray wrote:
> With VHE different exception levels are used between the host (EL2) and
> guest (EL1) with a shared exception level for userpace (EL0). We can take
> advantage of this and use the PMU's exception level filtering to avoid
> enabling/disabling counters in the world-switch code. Instead we just

s/Instead// ?

> modify the counter type to include or exclude EL0 at vcpu_{load,put} time.


> 
> We also ensure that trapped PMU system register writes do not re-enable
> EL0 when reconfiguring the backing perf events.
> 
> This approach completely avoids blackout windows seen with !VHE.
> 
> Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> Acked-by: Will Deacon <will.deacon@arm.com>

....

> +/*
> + * On VHE ensure that only guest events have EL0 counting enabled
> + */
> +void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_cpu_context *host_ctxt;
> +	struct kvm_host_data *host;
> +	u32 events_guest, events_host;
> +
> +	if (!has_vhe())
> +		return;
> +
> +	host_ctxt = vcpu->arch.host_cpu_context;
> +	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
> +	events_guest = host->pmu_events.events_guest;
> +	events_host = host->pmu_events.events_host;
> +
> +	kvm_vcpu_pmu_enable_el0(events_guest);
> +	kvm_vcpu_pmu_disable_el0(events_host);
> +}
> +
> +/*
> + * On VHE ensure that only guest host have EL0 counting enabled

nit: s/guest/host/host events/

> + */
> +void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_cpu_context *host_ctxt;
> +	struct kvm_host_data *host;
> +	u32 events_guest, events_host;
> +
> +	if (!has_vhe())
> +		return;
> +
> +	host_ctxt = vcpu->arch.host_cpu_context;
> +	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
> +	events_guest = host->pmu_events.events_guest;
> +	events_host = host->pmu_events.events_host;
> +
> +	kvm_vcpu_pmu_enable_el0(events_host);
> +	kvm_vcpu_pmu_disable_el0(events_guest);
> +}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 539feecda5b8..c7fa47ad2387 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -695,6 +695,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>   		val |= p->regval & ARMV8_PMU_PMCR_MASK;
>   		__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
>   		kvm_pmu_handle_pmcr(vcpu, val);
> +		kvm_vcpu_pmu_restore_guest(vcpu);

nit: I am not sure if we need to do this for PMCR accesses ? Unless
we have modified some changes to the events (e.g, like the two instances
below). Or am I missing something here ?

Otherwise:

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

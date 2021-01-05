Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A5FDC433E6
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 16:25:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C715B22C9F
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 16:25:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C715B22C9F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D9E74B30B;
	Tue,  5 Jan 2021 11:25:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P1uXDSV9QVAn; Tue,  5 Jan 2021 11:25:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 365CC4B2F0;
	Tue,  5 Jan 2021 11:25:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82D8C4B2F0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 11:25:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6LDZ07iSKNku for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 11:25:27 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 423B64B24B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 11:25:27 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 18A2422C9E;
 Tue,  5 Jan 2021 16:25:26 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kwp99-005T3T-Ts; Tue, 05 Jan 2021 16:25:24 +0000
MIME-Version: 1.0
Date: Tue, 05 Jan 2021 16:25:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] KVM: arm64: Replace KVM_ARM_PMU with HW_PERF_EVENTS
In-Reply-To: <fd094578-0b7d-57be-6f68-a55aca39e961@arm.com>
References: <20210104172723.2014324-1-maz@kernel.org>
 <fd094578-0b7d-57be-6f68-a55aca39e961@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <6444e331b4e0eacdae43cfde3ad05d43@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Alex,

On 2021-01-05 15:49, Alexandru Elisei wrote:
> Hi Marc,
> 
> On 1/4/21 5:27 PM, Marc Zyngier wrote:
>> KVM_ARM_PMU only existed for the benefit of 32bit ARM hosts,
>> and makes no sense now that we are 64bit only. Get rid of it.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/kvm/Kconfig  | 8 --------
>>  arch/arm64/kvm/Makefile | 2 +-
>>  include/kvm/arm_pmu.h   | 2 +-
>>  3 files changed, 2 insertions(+), 10 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>> index 043756db8f6e..3964acf5451e 100644
>> --- a/arch/arm64/kvm/Kconfig
>> +++ b/arch/arm64/kvm/Kconfig
>> @@ -49,14 +49,6 @@ if KVM
>> 
>>  source "virt/kvm/Kconfig"
>> 
>> -config KVM_ARM_PMU
>> -	bool "Virtual Performance Monitoring Unit (PMU) support"
>> -	depends on HW_PERF_EVENTS
>> -	default y
>> -	help
>> -	  Adds support for a virtual Performance Monitoring Unit (PMU) in
>> -	  virtual machines.
>> -
>>  endif # KVM
>> 
>>  endif # VIRTUALIZATION
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index 60fd181df624..13b017284bf9 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -24,4 +24,4 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o 
>> $(KVM)/eventfd.o \
>>  	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
>>  	 vgic/vgic-its.o vgic/vgic-debug.o
>> 
>> -kvm-$(CONFIG_KVM_ARM_PMU)  += pmu-emul.o
>> +kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o
>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>> index fc85f50fa0e9..8dcb3e1477bc 100644
>> --- a/include/kvm/arm_pmu.h
>> +++ b/include/kvm/arm_pmu.h
>> @@ -13,7 +13,7 @@
>>  #define ARMV8_PMU_CYCLE_IDX		(ARMV8_PMU_MAX_COUNTERS - 1)
>>  #define ARMV8_PMU_MAX_COUNTER_PAIRS	((ARMV8_PMU_MAX_COUNTERS + 1) >> 
>> 1)
>> 
>> -#ifdef CONFIG_KVM_ARM_PMU
>> +#ifdef CONFIG_HW_PERF_EVENTS
>> 
>>  struct kvm_pmc {
>>  	u8 idx;	/* index into the pmu->pmc array */
> 
> I grep'ed for KVM_ARM_PMU in the Linux sources, this patch takes care 
> of all its
> occurrences.
> 
> A few things popped into my mind when I saw the patch.
> 
> 1. Replacing KVM_ARM_PMU with CONFIG_HW_PERF_EVENTS means it's not 
> possible
> anymore for the host to have perf support while KVM does not support 
> emulating a
> PMU. In this scenario, functions which would have been empty functions 
> if
> KVM_ARM_PMU was still around (I only found kvm_pmu_flush_hwstate() and
> kvm_pmu_sync_hwstate() on the KVM_RUN path) will now be called and 
> return early
> after kvm_vcpu_has_pmu() returns 0. The overhead looks negligible to 
> me, and I
> don't think this configuration was common (especially since the default 
> was y).

I don't think this is either common nor useful. If the kernel supports
the PMU, then finding a PMU enables all the uses of the PMU, including
for guests. And userspace is still in control of what it exposes to
the guest. Yes, it's a tiny more overhead (one extra load) on the
exit/entry path. Should we care? I don't think so.

> 2. I did a grep for the files that include arm_pmu.h, and all the files 
> were in
> arch/arm64. I suppose arm_pmu.h exists in include/kvm instead of
> arch/arm64/include/asm because it was shared with KVM/arm when it was 
> still
> around, right? Or is there another reason for that?

No, that's basically the only reason. That was the easy landing spot
for anything shared (including things like GIC, timers and co).
I'm not sure it is worth the move, TBH...

> [1] https://www.spinics.net/lists/kvm-arm/msg44184.html

Yuo, and that's the reason I posted this patch. I have a couple more
that I'll post by the end of the day.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

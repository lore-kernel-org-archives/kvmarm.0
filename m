Return-Path: <SRS0=NVHA=GO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9CAAC433E6
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jan 2021 13:20:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2AB77207D0
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jan 2021 13:20:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AB77207D0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BC0D4B2E0;
	Mon, 11 Jan 2021 08:20:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id re2lwD0unpMb; Mon, 11 Jan 2021 08:20:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38BE64B2FA;
	Mon, 11 Jan 2021 08:20:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94AE24B2E0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 08:20:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J2o4XhuarZUv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Jan 2021 08:20:11 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4BA454B2D7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 08:20:11 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 249B2206CD;
 Mon, 11 Jan 2021 13:20:10 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kyx7A-006gC4-1X; Mon, 11 Jan 2021 13:20:08 +0000
MIME-Version: 1.0
Date: Mon, 11 Jan 2021 13:20:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Workaround firmware wrongly advertising
 GICv2-on-v3 compatibility
In-Reply-To: <5d5fc9f960d54049bbfc88341b511a3e@huawei.com>
References: <20210108171216.2310188-1-maz@kernel.org>
 <20210108171216.2310188-3-maz@kernel.org>
 <5d5fc9f960d54049bbfc88341b511a3e@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <03256357b239767af6f503978224dc70@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: shameerali.kolothum.thodi@huawei.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 ardb@kernel.org, kernel-team@android.com, linuxarm@openeuler.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linuxarm@openeuler.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 Ard Biesheuvel <ardb@kernel.org>
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

On 2021-01-11 12:21, Shameerali Kolothum Thodi wrote:
> Hi Marc,
> 
>> -----Original Message-----
>> From: Marc Zyngier [mailto:maz@kernel.org]
>> Sent: 08 January 2021 17:12
>> To: linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu
>> Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
>> James Morse <james.morse@arm.com>; Julien Thierry
>> <julien.thierry.kdev@gmail.com>; Suzuki K Poulose
>> <suzuki.poulose@arm.com>; Ard Biesheuvel <ardb@kernel.org>;
>> kernel-team@android.com
>> Subject: [PATCH 2/2] KVM: arm64: Workaround firmware wrongly 
>> advertising
>> GICv2-on-v3 compatibility
>> 
>> It looks like we have broken firmware out there that wrongly 
>> advertises
>> a GICv2 compatibility interface, despite the CPUs not being able to 
>> deal
>> with it.
>> 
>> To work around this, check that the CPU initialising KVM is actually 
>> able
>> to switch to MMIO instead of system registers, and use that as a
>> precondition to enable GICv2 compatibility in KVM.
>> 
>> Note that the detection happens on a single CPU. If the firmware is
>> lying *and* that the CPUs are asymetric, all hope is lost anyway.
>> 
>> Reported-by: Shameerali Kolothum Thodi
>> <shameerali.kolothum.thodi@huawei.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 34 
>> +++++++++++++++++++++++++++++++--
>>  arch/arm64/kvm/vgic/vgic-v3.c   |  8 ++++++--
>>  2 files changed, 38 insertions(+), 4 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c
>> b/arch/arm64/kvm/hyp/vgic-v3-sr.c
>> index 005daa0c9dd7..d504499ab917 100644
>> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
>> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
>> @@ -408,11 +408,41 @@ void __vgic_v3_init_lrs(void)
>>  /*
>>   * Return the GIC CPU configuration:
>>   * - [31:0]  ICH_VTR_EL2
>> - * - [63:32] RES0
>> + * - [62:32] RES0
>> + * - [63]    MMIO (GICv2) capable
>>   */
>>  u64 __vgic_v3_get_gic_config(void)
>>  {
>> -	return read_gicreg(ICH_VTR_EL2);
>> +	u64 sre = read_gicreg(ICC_SRE_EL1);
>> +	unsigned long flags = 0;
>> +	bool v2_capable;
>> +
>> +	/*
>> +	 * To check whether we have a MMIO-based (GICv2 compatible)
>> +	 * CPU interface, we need to disable the system register
>> +	 * view. To do that safely, we have to prevent any interrupt
>> +	 * from firing (which would be deadly).
>> +	 *
>> +	 * Note that this only makes sense on VHE, as interrupts are
>> +	 * already masked for nVHE as part of the exception entry to
>> +	 * EL2.
>> +	 */
>> +	if (has_vhe())
>> +		flags = local_daif_save();
>> +
>> +	write_gicreg(0, ICC_SRE_EL1);
>> +	isb();
>> +
>> +	v2_capable = !(read_gicreg(ICC_SRE_EL1) & ICC_SRE_EL1_SRE);
>> +
>> +	write_gicreg(sre, ICC_SRE_EL1);
>> +	isb();
>> +
>> +	if (has_vhe())
>> +		local_daif_restore(flags);
>> +
>> +	return (read_gicreg(ICH_VTR_EL2) |
>> +		v2_capable ? (1ULL << 63) : 0);
>>  }
> 
> Thanks for sending this out. I had a go with this series and 
> unfortunately
> it didn't work on a system with faulty BIOS. It looks like the culprit 
> here is
> the ?: operator. There seems to be an operator precedence at play here
> and it returns,
>   vgic_v3_probe: ich_vtr_el2 0x8000000000000000
> 
> And with the below change,
> 
>         return (read_gicreg(ICH_VTR_EL2) |
> -               v2_capable ? (1ULL << 63) : 0);
> +               (v2_capable ? (1ULL << 63) : 0));

Gaahh. Well caught! Each time I use this operator, I end-up screwing
up one way or another. Thanks for the heads up, and for testing.
I'll respin the series shortly.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

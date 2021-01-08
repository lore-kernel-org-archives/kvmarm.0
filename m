Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43223C433DB
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 18:13:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 898C523A6A
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 18:13:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 898C523A6A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D228A4B450;
	Fri,  8 Jan 2021 13:13:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NMjN6Jh0ZPbW; Fri,  8 Jan 2021 13:13:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC18A4B42A;
	Fri,  8 Jan 2021 13:13:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0641C4B42A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 13:13:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KweVUmOpIewi for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 13:13:02 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D43D74B40E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 13:13:01 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 930E823A69;
 Fri,  8 Jan 2021 18:13:00 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kxwFu-0068SH-9D; Fri, 08 Jan 2021 18:12:58 +0000
MIME-Version: 1.0
Date: Fri, 08 Jan 2021 18:12:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 2/2] KVM: arm64: Workaround firmware wrongly advertising
 GICv2-on-v3 compatibility
In-Reply-To: <CAMj1kXGAQKHZ+MHggDJK9qv0bPNVr7Zb6hdzd78YfRaMUQg8yQ@mail.gmail.com>
References: <20210108171216.2310188-1-maz@kernel.org>
 <20210108171216.2310188-3-maz@kernel.org>
 <CAMj1kXGAQKHZ+MHggDJK9qv0bPNVr7Zb6hdzd78YfRaMUQg8yQ@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <72a1bea27a29d35413c193f81b7ba170@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ardb@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, shameerali.kolothum.thodi@huawei.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Android Kernel Team <kernel-team@android.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

On 2021-01-08 17:59, Ard Biesheuvel wrote:
> On Fri, 8 Jan 2021 at 18:12, Marc Zyngier <maz@kernel.org> wrote:
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
>> -       return read_gicreg(ICH_VTR_EL2);
>> +       u64 sre = read_gicreg(ICC_SRE_EL1);
>> +       unsigned long flags = 0;
>> +       bool v2_capable;
>> +
>> +       /*
>> +        * To check whether we have a MMIO-based (GICv2 compatible)
>> +        * CPU interface, we need to disable the system register
>> +        * view. To do that safely, we have to prevent any interrupt
>> +        * from firing (which would be deadly).
>> +        *
>> +        * Note that this only makes sense on VHE, as interrupts are
>> +        * already masked for nVHE as part of the exception entry to
>> +        * EL2.
>> +        */
>> +       if (has_vhe())
>> +               flags = local_daif_save();
>> +
>> +       write_gicreg(0, ICC_SRE_EL1);
>> +       isb();
>> +
>> +       v2_capable = !(read_gicreg(ICC_SRE_EL1) & ICC_SRE_EL1_SRE);
>> +
>> +       write_gicreg(sre, ICC_SRE_EL1);
>> +       isb();
>> +
>> +       if (has_vhe())
>> +               local_daif_restore(flags);
>> +
>> +       return (read_gicreg(ICH_VTR_EL2) |
>> +               v2_capable ? (1ULL << 63) : 0);
>>  }
>> 
> 
> Is it necessary to perform this check unconditionally? We only care
> about this if the firmware claims v2 compat support.

Indeed. But this is done exactly once per boot, and I see it as
a way to extract the CPU configuration more than anything else.

Extracting it *only* when we have some v2 compat info would mean
sharing that information with EL2 (in the nVHE case), and it felt
more hassle than it is worth.

Do you foresee any issue with this, other than the whole thing
being disgusting (which I wilfully admit)?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

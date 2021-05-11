Return-Path: <SRS0=u/VZ=KG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B87C433ED
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 09:13:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D3EFA61928
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 09:13:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3EFA61928
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C0134B4AF;
	Tue, 11 May 2021 05:13:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fnmr-lYByA3e; Tue, 11 May 2021 05:13:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A0AB4B499;
	Tue, 11 May 2021 05:13:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F9424B492
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 05:13:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RGzhXBsQJpoL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 May 2021 05:13:07 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14E414B41D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 05:13:07 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D04616157F;
 Tue, 11 May 2021 09:13:05 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1lgORr-000doA-Os; Tue, 11 May 2021 10:13:03 +0100
MIME-Version: 1.0
Date: Tue, 11 May 2021 10:13:03 +0100
From: Marc Zyngier <maz@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v19 7/7] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
In-Reply-To: <CAMuHMdWd5261ti-zKsroFLvWs0abaWa7G4DKefgPwFb3rEjnNw@mail.gmail.com>
References: <20210330145430.996981-1-maz@kernel.org>
 <20210330145430.996981-8-maz@kernel.org>
 <CAMuHMdWd5261ti-zKsroFLvWs0abaWa7G4DKefgPwFb3rEjnNw@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <6c522f8116f54fa6f23a2d217d966c5a@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: geert@linux-m68k.org, jianyong.wu@arm.com,
 netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
 tglx@linutronix.de, pbonzini@redhat.com, seanjc@google.com,
 richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
 suzuki.poulose@arm.com, Andre.Przywara@arm.com, steven.price@arm.com,
 lorenzo.pieralisi@arm.com, sudeep.holla@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, Steve.Capper@arm.com, justin.he@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: KVM list <kvm@vger.kernel.org>, seanjc@google.com,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, justin.he@arm.com,
 Steven Price <steven.price@arm.com>,
 Android Kernel Team <kernel-team@android.com>,
 Andre Przywara <Andre.Przywara@arm.com>,
 Richard Cochran <richardcochran@gmail.com>, Yangbo Lu <yangbo.lu@nxp.com>,
 John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 netdev <netdev@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Sudeep Holla <sudeep.holla@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
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

Hi Geert,

On 2021-05-11 10:07, Geert Uytterhoeven wrote:
> Hi Marc, Jianyong,
> 
> On Tue, Mar 30, 2021 at 4:56 PM Marc Zyngier <maz@kernel.org> wrote:
>> From: Jianyong Wu <jianyong.wu@arm.com>
>> 
>> Currently, there is no mechanism to keep time sync between guest and 
>> host
>> in arm/arm64 virtualization environment. Time in guest will drift 
>> compared
>> with host after boot up as they may both use third party time sources
>> to correct their time respectively. The time deviation will be in 
>> order
>> of milliseconds. But in some scenarios,like in cloud environment, we 
>> ask
>> for higher time precision.
>> 
>> kvm ptp clock, which chooses the host clock source as a reference
>> clock to sync time between guest and host, has been adopted by x86
>> which takes the time sync order from milliseconds to nanoseconds.
>> 
>> This patch enables kvm ptp clock for arm/arm64 and improves clock sync 
>> precision
>> significantly.
> 
>> --- a/drivers/ptp/Kconfig
>> +++ b/drivers/ptp/Kconfig
>> @@ -108,7 +108,7 @@ config PTP_1588_CLOCK_PCH
>>  config PTP_1588_CLOCK_KVM
>>         tristate "KVM virtual PTP clock"
>>         depends on PTP_1588_CLOCK
>> -       depends on KVM_GUEST && X86
>> +       depends on (KVM_GUEST && X86) || (HAVE_ARM_SMCCC_DISCOVERY && 
>> ARM_ARCH_TIMER)
> 
> Why does this not depend on KVM_GUEST on ARM?
> I.e. shouldn't the dependency be:
> 
>     KVM_GUEST && (X86 || (HAVE_ARM_SMCCC_DISCOVERY && ARM_ARCH_TIMER))
> 
> ?

arm/arm64 do not select KVM_GUEST. Any kernel can be used for a guest,
and KVM/arm64 doesn't know about this configuration symbol.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

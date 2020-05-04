Return-Path: <SRS0=W6Rg=6S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72232C3A5A9
	for <kvmarm@archiver.kernel.org>; Mon,  4 May 2020 15:27:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EE828206D9
	for <kvmarm@archiver.kernel.org>; Mon,  4 May 2020 15:27:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="HpuBheTt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE828206D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AE874B418;
	Mon,  4 May 2020 11:27:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LpM-KpkJMxZ2; Mon,  4 May 2020 11:27:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E5924B409;
	Mon,  4 May 2020 11:27:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4B6B4B3FE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2020 11:27:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sN8VXHxxoE9L for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 May 2020 11:27:12 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 714174B3F8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2020 11:27:12 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 47E78206D9;
 Mon,  4 May 2020 15:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1588606031;
 bh=5a704nw8PgboCOt3H+ZTC3Far4orgcCzt1XyP/TusLw=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=HpuBheTt04MxUh/tXL+53XWnTuItqsv0ci9bRRyVc14UbPzf2Mwc78RpPKhcRkFtP
 7aVKEy9AT7ysrTDZZz+FIs9797nYoLSjgOERxPZAiK2nYVrBIz0kq8BJ3YpEyHD0Bn
 ZN7SFRknD8g8taeFHQOeKYglIKcyBgI3RyoDlE+g=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jVczt-0095gA-Fp; Mon, 04 May 2020 16:27:09 +0100
MIME-Version: 1.0
Date: Mon, 04 May 2020 16:27:09 +0100
From: Marc Zyngier <maz@kernel.org>
To: Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v4 4/4] KVM: arm64: Clean up kvm makefiles
In-Reply-To: <20200504132648.GA65651@google.com>
References: <20200421131734.141766-1-tabba@google.com>
 <20200421131734.141766-5-tabba@google.com>
 <20200504132648.GA65651@google.com>
User-Agent: Roundcube Webmail/1.4.3
Message-ID: <654f7d7260004e4959f0d0bd31800ac2@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: qperret@google.com, tabba@google.com,
 catalin.marinas@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kvmarm@lists.cs.columbia.edu, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hi all,

On 2020-05-04 14:26, Quentin Perret wrote:
> Hi Fuad,
> 
> On Tuesday 21 Apr 2020 at 14:17:34 (+0100), Fuad Tabba wrote:
>> Consolidate references to the CONFIG_KVM configuration item to 
>> encompass
>> entire folders rather than per line.
>> 
>> Signed-off-by: Fuad Tabba <tabba@google.com>
>> ---
>>  arch/arm64/kvm/Makefile     | 40 
>> ++++++++++++-------------------------
>>  arch/arm64/kvm/hyp/Makefile | 15 ++++----------
>>  2 files changed, 17 insertions(+), 38 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index 419696e615b3..5354ca1b1bfb 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -10,30 +10,16 @@ KVM=../../../virt/kvm
>>  obj-$(CONFIG_KVM) += kvm.o
>>  obj-$(CONFIG_KVM) += hyp/
>> 
>> -kvm-$(CONFIG_KVM) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
>> -kvm-$(CONFIG_KVM) += $(KVM)/eventfd.o $(KVM)/vfio.o $(KVM)/irqchip.o
>> -kvm-$(CONFIG_KVM) += arm.o mmu.o mmio.o
>> -kvm-$(CONFIG_KVM) += psci.o perf.o
>> -kvm-$(CONFIG_KVM) += hypercalls.o
>> -kvm-$(CONFIG_KVM) += pvtime.o
>> -
>> -kvm-$(CONFIG_KVM) += inject_fault.o regmap.o va_layout.o
>> -kvm-$(CONFIG_KVM) += hyp.o hyp-init.o handle_exit.o
>> -kvm-$(CONFIG_KVM) += guest.o debug.o reset.o sys_regs.o 
>> sys_regs_generic_v8.o
>> -kvm-$(CONFIG_KVM) += vgic-sys-reg-v3.o fpsimd.o pmu.o
>> -kvm-$(CONFIG_KVM) += aarch32.o
>> -kvm-$(CONFIG_KVM) += arch_timer.o
>> -kvm-$(CONFIG_KVM_ARM_PMU)  += pmu-emul.o
>> -
>> -kvm-$(CONFIG_KVM) += vgic/vgic.o
>> -kvm-$(CONFIG_KVM) += vgic/vgic-init.o
>> -kvm-$(CONFIG_KVM) += vgic/vgic-irqfd.o
>> -kvm-$(CONFIG_KVM) += vgic/vgic-v2.o
>> -kvm-$(CONFIG_KVM) += vgic/vgic-v3.o
>> -kvm-$(CONFIG_KVM) += vgic/vgic-v4.o
>> -kvm-$(CONFIG_KVM) += vgic/vgic-mmio.o
>> -kvm-$(CONFIG_KVM) += vgic/vgic-mmio-v2.o
>> -kvm-$(CONFIG_KVM) += vgic/vgic-mmio-v3.o
>> -kvm-$(CONFIG_KVM) += vgic/vgic-kvm-device.o
>> -kvm-$(CONFIG_KVM) += vgic/vgic-its.o
>> -kvm-$(CONFIG_KVM) += vgic/vgic-debug.o
>> +kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
>> +	 $(KVM)/vfio.o $(KVM)/irqchip.o \
>> +	 arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
>> +	 inject_fault.o regmap.o va_layout.o hyp.o hyp-init.o handle_exit.o 
>> \
>> +	 guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o \
>> +	 vgic-sys-reg-v3.o fpsimd.o pmu.o pmu-emul.o \
> 
> Should we keep pmu-emul.o conditional on CONFIG_KVM_ARM_PMU?

Good point. KVM_ARM_PMU depends on HW_PERF_EVENTS, which depends
on ARM_PMU. Without the above condition being present, you can
try and build the kernel with the KVM PMU emulation, and not
the host CPU PMU. It stops building very quickly.

I guess we should clean this up now that 32 bit is gone. But
for the sake of this series, it would be better to keep the
dependency in place and sort out the PMU mess at a later stage.

Thanks,

        M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

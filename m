Return-Path: <SRS0=S3n0=D4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B5D9C4363A
	for <kvmarm@archiver.kernel.org>; Wed, 21 Oct 2020 10:05:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5AF2522249
	for <kvmarm@archiver.kernel.org>; Wed, 21 Oct 2020 10:05:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="KcdrZO3s"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5AF2522249
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 931134B539;
	Wed, 21 Oct 2020 06:05:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I0XUJ1x1Ydwx; Wed, 21 Oct 2020 06:05:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7172D4B39D;
	Wed, 21 Oct 2020 06:05:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F9B24B39D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Oct 2020 06:05:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KE7LDrUqyLbs for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Oct 2020 06:05:14 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A3B94B39F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Oct 2020 06:05:14 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9CB3621789;
 Wed, 21 Oct 2020 10:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603274712;
 bh=6+d1HKx49rb+qxFcCqiGO1Ky9hSilUJeiTZHy1ph7aU=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=KcdrZO3sGRIG7wGADBQZ+AV38Pa+pPgo6qOHooSBIulVuZ+3rFiP4UbR+WUf8UTTW
 XEGNyjvxCG9A3Ai1PBg6N5K3l3NR3sh4Gm3TK0X7FhrvxyyAZlIUnnRHM+e9Ro2Yo6
 9xpEBbrO8cfOxfElxplW/I2NPssOihI9cXmKNG1o=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kVAzW-0030Sn-FZ; Wed, 21 Oct 2020 11:05:10 +0100
MIME-Version: 1.0
Date: Wed, 21 Oct 2020 11:05:10 +0100
From: Marc Zyngier <maz@kernel.org>
To: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v6 2/2] arm64: Add workaround for Arm Cortex-A77 erratum
 1508412
In-Reply-To: <CAL_JsqL02nHO=Mk7HJeBVr69AZ449wb5PpsNuaW3+SYP4HQn8g@mail.gmail.com>
References: <20200924134853.2696503-1-robh@kernel.org>
 <20200924134853.2696503-2-robh@kernel.org>
 <CAL_JsqL02nHO=Mk7HJeBVr69AZ449wb5PpsNuaW3+SYP4HQn8g@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <84a0a7cbc28ddb5a9e421f666cb8fbb1@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: robh@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 james.morse@arm.com, suzuki.poulose@arm.com, julien.thierry.kdev@gmail.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On 2020-10-20 15:40, Rob Herring wrote:
> On Thu, Sep 24, 2020 at 8:48 AM Rob Herring <robh@kernel.org> wrote:
>> 
>> On Cortex-A77 r0p0 and r1p0, a sequence of a non-cacheable or device 
>> load
>> and a store exclusive or PAR_EL1 read can cause a deadlock.
>> 
>> The workaround requires a DMB SY before and after a PAR_EL1 register
>> read. In addition, it's possible an interrupt (doing a device read) or
>> KVM guest exit could be taken between the DMB and PAR read, so we
>> also need a DMB before returning from interrupt and before returning 
>> to
>> a guest.
>> 
>> A deadlock is still possible with the workaround as KVM guests must 
>> also
>> have the workaround. IOW, a malicious guest can deadlock an affected
>> systems.
>> 
>> This workaround also depends on a firmware counterpart to enable the 
>> h/w
>> to insert DMB SY after load and store exclusive instructions. See the
>> errata document SDEN-1152370 v10 [1] for more information.
>> 
>> [1] 
>> https://static.docs.arm.com/101992/0010/Arm_Cortex_A77_MP074_Software_Developer_Errata_Notice_v10.pdf
>> 
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: James Morse <james.morse@arm.com>
>> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
>> Cc: kvmarm@lists.cs.columbia.edu
>> Signed-off-by: Rob Herring <robh@kernel.org>
>> ---
>> v6:
>> - Do dmb on kernel_exit rather than disabling interrupts around PAR 
>> read
>> v5:
>> - Rebase on v5.9-rc3
>> - Disable interrupts around PAR reads
>> - Add DMB on return to guest
>> 
>> v4:
>> - Move read_sysreg_par out of KVM code to sysreg.h to share
>> - Also use read_sysreg_par in fault.c and kvm/sys_regs.c
>> - Use alternative f/w for dmbs around PAR read
>> - Use cpus_have_final_cap instead of cpus_have_const_cap
>> - Add note about speculation of PAR read
>> 
>> v3:
>> - Add dmbs around PAR reads in KVM code
>> - Clean-up 'work-around' and 'errata'
>> 
>> v2:
>> - Don't disable KVM, just print warning
>> ---
>>  Documentation/arm64/silicon-errata.rst     |  2 ++
>>  arch/arm64/Kconfig                         | 20 ++++++++++++++++++++
>>  arch/arm64/include/asm/cpucaps.h           |  3 ++-
>>  arch/arm64/include/asm/sysreg.h            |  9 +++++++++
>>  arch/arm64/kernel/cpu_errata.c             | 10 ++++++++++
>>  arch/arm64/kernel/entry.S                  |  3 +++
>>  arch/arm64/kvm/arm.c                       |  3 ++-
>>  arch/arm64/kvm/hyp/include/hyp/switch.h    | 21 +++++++++++++--------
>>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  2 +-
>>  arch/arm64/kvm/hyp/nvhe/switch.c           |  2 +-
>>  arch/arm64/kvm/hyp/vhe/switch.c            |  2 +-
>>  arch/arm64/kvm/sys_regs.c                  |  2 +-
>>  arch/arm64/mm/fault.c                      |  2 +-
>>  13 files changed, 66 insertions(+), 15 deletions(-)
> 
> Marc, Can I get an ack for KVM on this? Will is waiting for one before 
> applying.

Here you go:

Acked-by: Marc Zyngier <maz@kernel.org>

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=sZMl=B5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94734C433DF
	for <kvmarm@archiver.kernel.org>; Wed, 19 Aug 2020 10:39:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1994E2072D
	for <kvmarm@archiver.kernel.org>; Wed, 19 Aug 2020 10:39:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ldlYV90L"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1994E2072D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FFB94B9F5;
	Wed, 19 Aug 2020 06:39:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8nGj8Grnffzs; Wed, 19 Aug 2020 06:39:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BB694B9EC;
	Wed, 19 Aug 2020 06:39:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CEA14B9DE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2020 06:39:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qe0l7ZTe8mCY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Aug 2020 06:39:30 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D907E4B9DB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2020 06:39:29 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C2E0A207BB;
 Wed, 19 Aug 2020 10:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1597833568;
 bh=JgOkHxljjlEWKjxvXyX8OX88anY1gmQPeYvF0aYkVZY=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=ldlYV90L+TJeBv/oCYia0+kUrpDf9tyew8a2EUELuBeF80woiLZndfWQCVUdUyBSS
 N1DTigmOO7l9XxQ2dRmzjPyA+Q05Ra75uXQj9/9WSC4th8n3Yvvh4+tJly3SuzHWWR
 184F36ZpNWf0FzJZwWu5hoSC7VhKdhhGlXTYICOg=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k8LV9-004Aa2-By; Wed, 19 Aug 2020 11:39:27 +0100
MIME-Version: 1.0
Date: Wed, 19 Aug 2020 11:39:27 +0100
From: Marc Zyngier <maz@kernel.org>
To: Jianyong Wu <Jianyong.Wu@arm.com>
Subject: Re: [PATCH 47/56] KVM: arm64: timers: Move timer registers to the
 sys_regs file
In-Reply-To: <HE1PR0802MB25552F2502B47554C6B53CADF45D0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200805175700.62775-1-maz@kernel.org>
 <20200805175700.62775-48-maz@kernel.org>
 <HE1PR0802MB2555B630F149E07AF11846DEF45D0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <551eac52dcd3b19ae6db45dd6f6e168b@kernel.org>
 <HE1PR0802MB25552F2502B47554C6B53CADF45D0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.7
Message-ID: <5dd5ccf145b366e562782f117f25d880@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: Jianyong.Wu@arm.com, pbonzini@redhat.com,
 richard.peng@oppo.com, kernel-team@android.com, kvm@vger.kernel.org,
 will@kernel.org, Catalin.Marinas@arm.com, graf@amazon.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Peng Hao <richard.peng@oppo.com>, kvm@vger.kernel.org,
 kernel-team@android.com, Alexander Graf <graf@amazon.com>,
 Catalin Marinas <Catalin.Marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-08-19 11:18, Jianyong Wu wrote:
>> -----Original Message-----
>> From: Marc Zyngier <maz@kernel.org>
>> Sent: Wednesday, August 19, 2020 6:00 PM
>> To: Jianyong Wu <Jianyong.Wu@arm.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>; Peng Hao
>> <richard.peng@oppo.com>; kernel-team@android.com;
>> kvm@vger.kernel.org; Will Deacon <will@kernel.org>; Catalin Marinas
>> <Catalin.Marinas@arm.com>; Alexander Graf <graf@amazon.com>;
>> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
>> Subject: Re: [PATCH 47/56] KVM: arm64: timers: Move timer registers to 
>> the
>> sys_regs file
>> 
>> On 2020-08-19 10:24, Jianyong Wu wrote:
>> > Hi Marc,
>> >
>> > -----Original Message-----
>> > From: kvmarm-bounces@lists.cs.columbia.edu
>> > <kvmarm-bounces@lists.cs.columbia.edu> On Behalf Of Marc Zyngier
>> > Sent: Thursday, August 6, 2020 1:57 AM
>> > To: Paolo Bonzini <pbonzini@redhat.com>
>> > Cc: Peng Hao <richard.peng@oppo.com>; kernel-team@android.com;
>> > kvm@vger.kernel.org; Will Deacon <will@kernel.org>; Catalin Marinas
>> > <Catalin.Marinas@arm.com>; Alexander Graf <graf@amazon.com>;
>> > kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
>> > Subject: [PATCH 47/56] KVM: arm64: timers: Move timer registers to the
>> > sys_regs file
>> >
>> > Move the timer gsisters to the sysreg file. This will further help
>> > when they are directly changed by a nesting hypervisor in the VNCR
>> > page.
>> >
>> > This requires moving the initialisation of the timer struct so that
>> > some of the helpers (such as arch_timer_ctx_index) can work correctly
>> > at an early stage.
>> >
>> > Signed-off-by: Marc Zyngier <maz@kernel.org>
>> > ---
>> >  arch/arm64/include/asm/kvm_host.h |   6 ++
>> >  arch/arm64/kvm/arch_timer.c       | 155 +++++++++++++++++++++++-------
>> >  arch/arm64/kvm/trace_arm.h        |   8 +-
>> >  include/kvm/arm_arch_timer.h      |  11 +--
>> >  4 files changed, 136 insertions(+), 44 deletions(-)
>> >
>> > +static u64 timer_get_offset(struct arch_timer_context *ctxt) {
>> > +	struct kvm_vcpu *vcpu = ctxt->vcpu;
>> > +
>> > +	switch(arch_timer_ctx_index(ctxt)) {
>> > +	case TIMER_VTIMER:
>> > +		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
>> > +	default:
>> > +		return 0;
>> > +	}
>> > +}
>> > +
>> > Can I export this helper? As in my ptp_kvm implementation I need get
>> > VCNT offset value separately not just give me a result of VCNT.
>> 
>> Sorry, you need to give me a bit more context. What do you need the 
>> offset
>> for exactly?
> 
> Yeah,
> In my ptp_kvm implementation, I need acquire wall time and counter
> cycle in the same time in host. After get host counter cycle, I need
> subtract it by VCNT offset to obtain VCNT. See
> https://lkml.org/lkml/2020/6/19/441
> https://lkml.org/lkml/2020/6/19/441
> But now I can't get the VCNT offset easily like before using "
> vcpu_vtimer(vcpu)->cntvoff" and I can't use the helper like
> "kvm_arm_timer_read" as I need acquire the counter cycle in the same
> time with the host wall time.

I must be missing something. CNTVOFF_EL2 is now implemented as
a standard system register, and has the same visibility as any
other vcpu sysreg.

Why doesn't vcpu_read_sys_reg(vcpu, CNTVOFF_EL2) work for you?

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

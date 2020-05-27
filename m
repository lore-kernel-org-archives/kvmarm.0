Return-Path: <SRS0=MITk=7J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD3FEC433DF
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 07:37:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A36C208B8
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 07:37:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="YvrR6OuB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A36C208B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7B644B172;
	Wed, 27 May 2020 03:37:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1M5De5pYzmzz; Wed, 27 May 2020 03:37:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA31C4B19B;
	Wed, 27 May 2020 03:37:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 741674B181
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 03:37:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M2raBNa5ebas for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 May 2020 03:37:10 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4318C4B172
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 03:37:10 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1E832207CB;
 Wed, 27 May 2020 07:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590565029;
 bh=0M1mFsGDTKIzE9/6yoIC6rR97OlF6HfqERxEr8t9U4c=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=YvrR6OuBxoy9z1BVf2rExUxfPg3agb10ofmlmcyMDTTaeYIAOmn8QaXB7vdbF/Sbv
 +lYSGpYQS82+AuEAc32Sb3Ec2u2bVkqX9hEFUam+DAFG69l8iWDqGzKBW+GSHqu9kT
 StqP/6DkYMcG2bufjcuOoS4XdXvDOS+W5gGuFn3A=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jdqcd-00FdBE-0J; Wed, 27 May 2020 08:37:07 +0100
MIME-Version: 1.0
Date: Wed, 27 May 2020 08:37:06 +0100
From: Marc Zyngier <maz@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH RFCv2 7/9] kvm/arm64: Support async page fault
In-Reply-To: <e1230110-b51f-b8b8-60d9-372660c5c387@redhat.com>
References: <20200508032919.52147-1-gshan@redhat.com>
 <20200508032919.52147-8-gshan@redhat.com>
 <20200526123424.GF1363@C02TD0UTHF1T.local>
 <e1230110-b51f-b8b8-60d9-372660c5c387@redhat.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <28c74819f42306e66370ddaf88f16918@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gshan@redhat.com, mark.rutland@arm.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com,
 james.morse@arm.com, suzuki.poulose@arm.com, drjones@redhat.com,
 eric.auger@redhat.com, aarcange@redhat.com, shan.gavin@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On 2020-05-27 05:05, Gavin Shan wrote:
> Hi Mark,
> 

[...]

>>> +struct kvm_vcpu_pv_apf_data {
>>> +	__u32	reason;
>>> +	__u8	pad[60];
>>> +	__u32	enabled;
>>> +};
>> 
>> What's all the padding for?
>> 
> 
> The padding is ensure the @reason and @enabled in different cache
> line. @reason is shared by host/guest, while @enabled is almostly
> owned by guest.

So you are assuming that a cache line is at most 64 bytes.
It is actualy implementation defined, and you can probe for it
by looking at the CTR_EL0 register. There are implementations
ranging from 32 to 256 bytes in the wild, and let's not mention
broken big-little implementations here.

[...]

>>> +bool kvm_arch_can_inject_async_page_not_present(struct kvm_vcpu 
>>> *vcpu)
>>> +{
>>> +	u64 vbar, pc;
>>> +	u32 val;
>>> +	int ret;
>>> +
>>> +	if (!(vcpu->arch.apf.control_block & KVM_ASYNC_PF_ENABLED))
>>> +		return false;
>>> +
>>> +	if (vcpu->arch.apf.send_user_only && vcpu_mode_priv(vcpu))
>>> +		return false;
>>> +
>>> +	/* Pending page fault, which ins't acknowledged by guest */
>>> +	ret = kvm_async_pf_read_cache(vcpu, &val);
>>> +	if (ret || val)
>>> +		return false;
>>> +
>>> +	/*
>>> +	 * Events can't be injected through data abort because it's
>>> +	 * going to clobber ELR_EL1, which might not consued (or saved)
>>> +	 * by guest yet.
>>> +	 */
>>> +	vbar = vcpu_read_sys_reg(vcpu, VBAR_EL1);
>>> +	pc = *vcpu_pc(vcpu);
>>> +	if (pc >= vbar && pc < (vbar + vcpu->arch.apf.no_fault_inst_range))
>>> +		return false;
>> 
>> Ah, so that's when this `no_fault_inst_range` is for.
>> 
>> As-is this is not sufficient, and we'll need t be extremely careful
>> here.
>> 
>> The vectors themselves typically only have a small amount of stub 
>> code,
>> and the bulk of the non-reentrant exception entry work happens
>> elsewhere, in a mixture of assembly and C code that isn't even 
>> virtually
>> contiguous with either the vectors or itself.
>> 
>> It's possible in theory that code in modules (or perhaps in eBPF JIT'd
>> code) that isn't safe to take a fault from, so even having a 
>> contiguous
>> range controlled by the kernel isn't ideal.
>> 
>> How does this work on x86?
>> 
> 
> Yeah, here we just provide a mechanism to forbid injecting data abort. 
> The
> range is fed by guest through HVC call. So I think it's guest related 
> issue.
> You had more comments about this in PATCH[9]. I will explain a bit more 
> there.
> 
> x86 basically relies on EFLAGS[IF] flag. The async page fault can be 
> injected
> if it's on. Otherwise, it's forbidden. It's workable because exception 
> is
> special interrupt to x86 if I'm correct.
> 
>            return (vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) &&
>                   !(vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
>                         (GUEST_INTR_STATE_STI | 
> GUEST_INTR_STATE_MOV_SS));

I really wish this was relying on an architected exception delivery
mechanism that can be blocked by the guest itself (PSTATE.{I,F,A}).
Trying to guess based on the PC won't fly. But these signals are
pretty hard to multiplex with anything else. Like any form of
non-architected exception injection, I don't see a good path forward
unless we start considering something like SDEI.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

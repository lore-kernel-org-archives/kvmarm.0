Return-Path: <SRS0=nG5+=5I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1793C4332B
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 10:26:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7A0C320722
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 10:26:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="LnAxJqVa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A0C320722
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E92A4B08A;
	Mon, 23 Mar 2020 06:26:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lJ-IYd023lsB; Mon, 23 Mar 2020 06:26:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C6F34B08E;
	Mon, 23 Mar 2020 06:26:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBEE54B08A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 06:26:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 48RQ7OI0StBB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2020 06:26:21 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FD5B4A531
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 06:26:21 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5093E20722;
 Mon, 23 Mar 2020 10:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1584959180;
 bh=NWO08zud+QEAYSYzAvW2wht+J1X80itDGBXVPLZ9H8w=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=LnAxJqVaMaggHkk/M11X9dlTORZG7YKTO10E+Yhx/2Fz8UZ1mCcVrwSqSy4sJ9dSn
 12pTyKZOuwxvz6yaGtOX29vBZKZ0vRKOGFCtB2IDCDMoE4uNgQOUfo4LgLjtRbenz8
 M7dcpWn0VKQD/6rP+vXoChMCH8V+QvAIlOtsnLHs=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jGKHi-00EvNg-L5; Mon, 23 Mar 2020 10:26:18 +0000
MIME-Version: 1.0
Date: Mon, 23 Mar 2020 10:26:18 +0000
From: Marc Zyngier <maz@kernel.org>
To: Lev Aronsky <aronsky@gmail.com>
Subject: Re: [PATCH] KVM: arm64: Add support for IDSR exits to userspace
In-Reply-To: <20200323094127.GA1013@ewr1-t1.small.x86-01>
References: <20200322093650.50621-1-aronsky@gmail.com>
 <61ae80130b47dc23d00d5010eccee0b2@kernel.org>
 <20200322142010.GA3337@ewr1-t1.small.x86-01>
 <d19c6aad8de7bfa182b7872ebeec57b5@kernel.org>
 <20200323082217.GA1509@ewr1-t1.small.x86-01>
 <d2c184326523ffe5b2e700b25b07b6a8@kernel.org>
 <20200323094127.GA1013@ewr1-t1.small.x86-01>
Message-ID: <194c542d3d7941661f3042e6336f94d8@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: aronsky@gmail.com, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
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

On 2020-03-23 09:41, Lev Aronsky wrote:
> On Mon, Mar 23, 2020 at 09:07:12AM +0000, Marc Zyngier wrote:
>> On 2020-03-23 08:22, Lev Aronsky wrote:

[...]

>> > We're running it on an ARM cloud server (we were hoping to be able to
>> > use SBCs for the project, but iOS uses 16K pages for kernel mode, and we
>> > found out (the hard way) that most older/cheaper ARM cores don't support
>> > it (Cortex A76 being the first one to support it, IIRC).
>> 
>> I think there is more than just A76. A55 definitely has TGran16, as 
>> well as
>> A73, A75, A65 (I've stopped looking in the various TRMs). So 
>> definitely
>> in the realm of SBCs (I have a quad A55 on my desk, worth $70).
> 
> You're right, as usual.

Funny. My wife says otherwise... ;-)

> But A55 SBCs are apparently hard to find - most
> of the SBCs I've seen are A53/A72 (which I thought would be enough,
> until we found out about the TGran16 problem), and now that I looked 
> for
> A55-based SBCs, I couldn't find one with a big enough memory (we're
> looking at 4GB+, so that we can provide the VM at least 2GB and still
> have adequate performance).

Yeah, decent machines are hard to find :-(. Some TV boxes ship with 4GB,
but that'd be a waste a time (and money). If the Windows-ARM laptops
allowed to run EL2 code, they'd be great... I guess you're going to be
stuck with your cloud machine for a long while.

>> > > > Interestingly, EL0 access to implementation-defined registers currently
>> > > > results in an UNDEF, even though I expected it to be passed on to our
>> > > > handler (I saw this behavior with a custom system register we defined
>> > > > for direct communication with the hypervisor from a user-mode program we
>> > > > developed). I tried following the ARM documentation to figure out what
>> > > > could cause such a behavior, but so far I'm at a loss.
>> > >
>> > > Here's your answer:
>> > >
>> > > "When the value of HCR_EL2.TIDCP is 1, it is IMPLEMENTATION DEFINED
>> > > whether
>> > > any of this functionality accessed from EL0 is trapped to EL2. If it
>> > > is not,
>> > > then it is UNDEFINED, and any attempt to access it from EL0
>> > > generates an
>> > > exception that is taken to EL1."
>> > >
>> > > Also, I don't really understand how you define a custom system
>> > > register.
>> > > Unless you're writing the HW as well, of course.
>> >
>> > We are using QEMU as the hypervisor. QEMU allows for definition of
>> > arbitrary system registers (based on opc0/opc1/opc2/crm/crn), with
>> > custom read/write callback functions. We have a custom machine for
>> > iPhone emulation (you can take a look at our code at
>> > https://github.com/alephsecurity/xnu-qemu-arm64, if you're interested),
>> > so yeah - you could say we're writing the hardware, as well.
>> 
>> I'm pretty sure this wouldn't work with HW virtualization. I suspect
>> this would UNDEF directly on the CPU, leading to an exception being 
>> taken
>> at EL1 without intervention of the hypervisor. Which makes sense as 
>> you'd
>> be executing an instruction that the CPU really doesn't implement.
> 
> Yes, that seems to be what's happening. We'll have to think of a
> different mechanism for trapping access from user-mode straight to the
> hypervisor - or, alternatively, move our custom code into the kernel. I
> know it's a bit off-topic, but thank you for your advice!

One possibility would be trap accesses to a special page (magic 
device?),
but that requires cooperation from the OS kernel as well. There is 
hardly
anything else that would guarantee a trap directly from EL0 to EL2 (EL1
can always get in the way).

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

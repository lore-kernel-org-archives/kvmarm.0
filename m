Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E316AC388F9
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 16:17:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3ED4820878
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 16:17:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ief13jGr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3ED4820878
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F3644B405;
	Tue, 27 Oct 2020 12:17:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0cixfmJ6w6Zp; Tue, 27 Oct 2020 12:17:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57F3A4B3F5;
	Tue, 27 Oct 2020 12:17:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49EA04B3FC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 12:17:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TgpsmwPNBH02 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 12:17:35 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 44AEA4B3B5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 12:17:35 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B11D12074B;
 Tue, 27 Oct 2020 16:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603815453;
 bh=ts1g+L2Vn0iI0TtNwDUCHfNkNs58hX2yUbH7A6NlHHI=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=ief13jGr2sZv7X1wHpneogJel5IGfAmDhHjELJL9uqxaeXpfImnf904FW6yPw4u2Z
 WmPT4hqdD2J/79dMplhXkW2fNbSjcna+GMBnBlWX9JckSTqse4IQzduSxzsc1sHzzT
 G51zCCdKref2YErCvL19y1+8JS++z05dOg/xdijc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kXRf9-004o74-Ku; Tue, 27 Oct 2020 16:17:31 +0000
MIME-Version: 1.0
Date: Tue, 27 Oct 2020 16:17:31 +0000
From: Marc Zyngier <maz@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 03/11] KVM: arm64: Make kvm_skip_instr() and co private to
 HYP
In-Reply-To: <20201026140435.GE12454@C02TD0UTHF1T.local>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-4-maz@kernel.org>
 <20201026140435.GE12454@C02TD0UTHF1T.local>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <bde9a2a8233f3d7e96751ad3640b11b7@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com,
 will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
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

On 2020-10-26 14:04, Mark Rutland wrote:
> On Mon, Oct 26, 2020 at 01:34:42PM +0000, Marc Zyngier wrote:
>> In an effort to remove the vcpu PC manipulations from EL1 on nVHE
>> systems, move kvm_skip_instr() to be HYP-specific. EL1's intent
>> to increment PC post emulation is now signalled via a flag in the
>> vcpu structure.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> [...]
> 
>> +/*
>> + * Adjust the guest PC on entry, depending on flags provided by EL1
>> + * for the purpose of emulation (MMIO, sysreg).
>> + */
>> +static inline void __adjust_pc(struct kvm_vcpu *vcpu)
>> +{
>> +	if (vcpu->arch.flags & KVM_ARM64_INCREMENT_PC) {
>> +		kvm_skip_instr(vcpu);
>> +		vcpu->arch.flags &= ~KVM_ARM64_INCREMENT_PC;
>> +	}
>> +}
> 
> What's your plan for restricting *when* EL1 can ask for the PC to be
> adjusted?
> 
> I'm assuming that either:
> 
> 1. You have EL2 sanity-check all responses from EL1 are permitted for
>    the current state. e.g. if EL1 asks to increment the PC, EL2 must
>    check that that was a sane response for the current state.
> 
> 2. You raise the level of abstraction at the EL2/EL1 boundary, such 
> that
>    EL2 simply knows. e.g. if emulating a memory access, EL1 can either
>    provide the response or signal an abort, but doesn't choose to
>    manipulate the PC as EL2 will infer the right thing to do.
> 
> I know that either are tricky in practice, so I'm curious what your 
> view
> is. Generally option #2 is easier to fortify, but I guess we might have
> to do #1 since we also have to support unprotected VMs?

To be honest, I'm still in two minds about it, which is why I have
gone with this "middle of the road" option (moving the PC update
to EL2, but leave the control at EL1).

I guess the answer is "it depends". MMIO is easy to put in the #2 model,
while things like WFI/WFE really need #1. sysregs are yet another can of
worm.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

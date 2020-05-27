Return-Path: <SRS0=MITk=7J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8683DC433DF
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 10:04:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 09D9120B80
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 10:04:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="mdxZIF05"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 09D9120B80
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BC724B112;
	Wed, 27 May 2020 06:04:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bgm+WKx8LeEa; Wed, 27 May 2020 06:04:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7556E4B119;
	Wed, 27 May 2020 06:04:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEFEC4B1B5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 06:04:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sUz9URotTncg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 May 2020 06:04:11 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C9834B112
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 06:04:11 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6EBCA2084C;
 Wed, 27 May 2020 10:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590573850;
 bh=zSIdbYQzBzwhjrQI1hWwupDBNv6wpaxUIuCkjXojSUs=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=mdxZIF05SH6elzOSo9ZapHNOQTVJUmqp6M8R2ruYxkwZfsnML55SowgexSg4vGSjR
 9BrMXLjFGrYP0ZeSZ8q1G2q8UjOZL+OwezjpS3XZ4MXV1NuaCWhNoG73aOTLSrtsLc
 wS9UJZ2vgVazwPa9OxZQ4zUZbrOv7fmLZg4hCw9E=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jdsuu-00Ff8O-Pj; Wed, 27 May 2020 11:04:08 +0100
MIME-Version: 1.0
Date: Wed, 27 May 2020 11:04:08 +0100
From: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 10/26] KVM: arm64: Refactor vcpu_{read,write}_sys_reg
In-Reply-To: <09da829c-1640-40fe-313f-df021759fb34@arm.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-11-maz@kernel.org>
 <09da829c-1640-40fe-313f-df021759fb34@arm.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <1612302e289ba15fb0ffbfba5ea18e3b@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu,
 alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com,
 will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, Will Deacon <will@kernel.org>,
 George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>,
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

On 2020-05-26 17:28, James Morse wrote:
> Hi Marc,
> 
> On 22/04/2020 13:00, Marc Zyngier wrote:
>> Extract the direct HW accessors for later reuse.
> 
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 51db934702b64..46f218982df8c 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
> 
>> +u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
>> +{
>> +	u64 val = 0x8badf00d8badf00d;
>> +
>> +	if (!vcpu->arch.sysregs_loaded_on_cpu) {
>> +		goto memory_read;
>>  	}
>> 
>> -immediate_write:
>> +	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
>> +		return val;
>> +
>> +memory_read:
>> +	return __vcpu_sys_reg(vcpu, reg);
>> +}
> 
> 
> The goto here is a bit odd, is it just an artefact of how we got here?

That's because a lot of this changes when NV gets added to the mix,
see [1].

> Is this easier on the eye?:
> | u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
> | {
> |	u64 val = 0x8badf00d8badf00d;
> |
> |	if (vcpu->arch.sysregs_loaded_on_cpu &&
> |	    __vcpu_read_sys_reg_from_cpu(reg, &val))
> |		return val;
> |
> | 	return __vcpu_sys_reg(vcpu, reg);
> | }

Definitely. I don't mind reworking the NV branch so that the label
gets introduced there.

>> +void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
>> +{
>> +	if (!vcpu->arch.sysregs_loaded_on_cpu)
>> +		goto memory_write;
>> +
>> +	if (__vcpu_write_sys_reg_to_cpu(val, reg))
>> +		return;
>> +
>> +memory_write:
>>  	 __vcpu_sys_reg(vcpu, reg) = val;
>>  }
> 
> Again I think its clearer without the goto....
> 
> 
> Regardless:
> Reviewed-by: James Morse <james.morse@arm.com>

Thanks,

         M.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=kvm-arm64/nv-5.7-rc1-WIP&id=11f3217d39a602cbfac7d08064c8b31afb57348e
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

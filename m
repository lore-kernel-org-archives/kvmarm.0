Return-Path: <SRS0=btD/=7W=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1AD9C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  9 Jun 2020 11:48:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 488DF2068D
	for <kvmarm@archiver.kernel.org>; Tue,  9 Jun 2020 11:48:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="SJHtmjsk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 488DF2068D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E36574B328;
	Tue,  9 Jun 2020 07:48:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3kVQnhBFpStH; Tue,  9 Jun 2020 07:48:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E50454B31C;
	Tue,  9 Jun 2020 07:48:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC8B64B31C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2020 07:48:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1Da2wR-LdWTW for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jun 2020 07:48:44 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AEF604B309
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2020 07:48:44 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8E6B52068D;
 Tue,  9 Jun 2020 11:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1591703323;
 bh=jZQ4Zg8DwzAMUN+GXuZsfRY/XUjTHIpyRTgWTNdxQ6U=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=SJHtmjskzqroQWd1r6br+wTjNT4XT/FqsM/GKHQWDyjLzIrRFrVhmW0IDafmtC9Ww
 ehsbYKYgQVtTV/FweObun9JuYyHm7puwcbAMPh7GDgA5ur6YqoQ/+obEdfwg0sVJbn
 EaYlTyWJUdF7g4ky+Jz8KNOfDDuKxchuhUyVaMQk=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jickD-001ROy-Pv; Tue, 09 Jun 2020 12:48:41 +0100
MIME-Version: 1.0
Date: Tue, 09 Jun 2020 12:48:41 +0100
From: Marc Zyngier <maz@kernel.org>
To: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts
In-Reply-To: <7c173265-3f8e-51df-d700-7e3658a0e4d8@arm.com>
References: <20200609084921.1448445-1-maz@kernel.org>
 <20200609084921.1448445-2-maz@kernel.org>
 <7c173265-3f8e-51df-d700-7e3658a0e4d8@arm.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <7451e64c22d8432f998458e0343aee7f@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, james.morse@arm.com, stable@vger.kernel.org,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, stable@vger.kernel.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Robin,

On 2020-06-09 12:41, Robin Murphy wrote:
> On 2020-06-09 09:49, Marc Zyngier wrote:
>> AArch32 CP1x registers are overlayed on their AArch64 counterparts
>> in the vcpu struct. This leads to an interesting problem as they
>> are stored in their CPU-local format, and thus a CP1x register
>> doesn't "hit" the lower 32bit portion of the AArch64 register on
>> a BE host.
>> 
>> To workaround this unfortunate situation, introduce a bias trick
>> in the vcpu_cp1x() accessors which picks the correct half of the
>> 64bit register.
>> 
>> Cc: stable@vger.kernel.org
>> Reported-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>   arch/arm64/include/asm/kvm_host.h | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/arm64/include/asm/kvm_host.h 
>> b/arch/arm64/include/asm/kvm_host.h
>> index 59029e90b557..e80c0e06f235 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -404,8 +404,14 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, 
>> u64 val, int reg);
>>    * CP14 and CP15 live in the same array, as they are backed by the
>>    * same system registers.
>>    */
>> -#define vcpu_cp14(v,r)		((v)->arch.ctxt.copro[(r)])
>> -#define vcpu_cp15(v,r)		((v)->arch.ctxt.copro[(r)])
>> +#ifdef CPU_BIG_ENDIAN
> 
> Ahem... I think you're missing a "CONFIG_" there ;)

Duh! As I said, I didn't test the thing at all! ;-)

> Bonus trickery - for a 0 or 1 value you can simply use IS_ENABLED().

Beautiful! Definitely a must! :D

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

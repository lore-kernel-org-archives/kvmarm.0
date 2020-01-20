Return-Path: <SRS0=lFwt=3J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA3D3C2D0DB
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 11:14:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 638FD214AF
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 11:14:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="uJYsc9Wm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 638FD214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01E444AEF0;
	Mon, 20 Jan 2020 06:14:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ylTqWATUdl5Z; Mon, 20 Jan 2020 06:14:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 414914AEF1;
	Mon, 20 Jan 2020 06:14:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC6264AEEE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 06:14:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OaYcvldlmQkG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jan 2020 06:14:07 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7175B4AED9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 06:14:07 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2F20520674;
 Mon, 20 Jan 2020 11:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579518846;
 bh=HAHcS1egkuTL8fOWbZRIsOSuG2XkQ6V9uDzuweE93QQ=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=uJYsc9WmWttZ+T1kL7mR5Z6VCb/q84SaSkiINgfXZ6OV7rcxaibik2M43q1wTZSJQ
 TYMzZKu8bfz1hmjiv7WfQtooviE5zNFKmfR4a/aYEulIO+03vjfQ7kkxscNFiaBZ3K
 pyZvvW7e3AJuHqLg27h6GfLQHdY9Eh6XgujCHPtk=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1itV0O-000FHR-G6; Mon, 20 Jan 2020 11:14:04 +0000
MIME-Version: 1.0
Date: Mon, 20 Jan 2020 12:14:04 +0100
From: Marc Zyngier <maz@kernel.org>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH] ARM: virt: Relax arch timer version check during early
 boot
In-Reply-To: <eb889279-87f2-d674-9299-169794c285eb@arm.com>
References: <1579097798-106243-1-git-send-email-vladimir.murzin@arm.com>
 <eb889279-87f2-d674-9299-169794c285eb@arm.com>
Message-ID: <d4b8bb91f95385682f20c9dc5c6f5e50@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: vladimir.murzin@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Vladimir,

On 2020-01-20 11:46, Vladimir Murzin wrote:
> + Marc
> + kvmarm@lists.cs.columbia.edu
> 
> On 1/15/20 2:16 PM, Vladimir Murzin wrote:
>> Updates to the Generic Timer architecture allow ID_PFR1.GenTimer to
>> have values other than 0 or 1. At the moment, Linux is quite strict in
>> the way it handles this field at early boot and will not configure
>> arch timer if it doesn't find the value 1.
>> 
>> Since here use ubfx for arch timer version extraction (hyb-stub build
>> with -march=armv7-a, so it is safe)
>> 
>> To help backports (even though the code was correct at the time of 
>> writing)
>> Fixes: 8ec58be9f3ff ("ARM: virt: arch_timers: enable access to 
>> physical timers")
>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>

I'm not opposed to such a change, but it'd be good to document what 
other values
are expected here, as the current (Rev E_a) ARM ARM only mentions values 
0 and 1.

Thanks,

         M.

>> ---
>>  arch/arm/kernel/hyp-stub.S | 7 +++----
>>  1 file changed, 3 insertions(+), 4 deletions(-)
>> 
>> diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
>> index ae50203..6607fa8 100644
>> --- a/arch/arm/kernel/hyp-stub.S
>> +++ b/arch/arm/kernel/hyp-stub.S
>> @@ -146,10 +146,9 @@ ARM_BE8(orr	r7, r7, #(1 << 25))     @ HSCTLR.EE
>>  #if !defined(ZIMAGE) && defined(CONFIG_ARM_ARCH_TIMER)
>>  	@ make CNTP_* and CNTPCT accessible from PL1
>>  	mrc	p15, 0, r7, c0, c1, 1	@ ID_PFR1
>> -	lsr	r7, #16
>> -	and	r7, #0xf
>> -	cmp	r7, #1
>> -	bne	1f
>> +	ubfx	r7, r7, #16, #4
>> +	teq	r7, #0
>> +	beq	1f
>>  	mrc	p15, 4, r7, c14, c1, 0	@ CNTHCTL
>>  	orr	r7, r7, #3		@ PL1PCEN | PL1PCTEN
>>  	mcr	p15, 4, r7, c14, c1, 0	@ CNTHCTL
>> 

-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

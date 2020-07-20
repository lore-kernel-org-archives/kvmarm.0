Return-Path: <SRS0=coVF=A7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65021C433E4
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jul 2020 15:57:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DEE3820773
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jul 2020 15:57:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="DoJJ5Hy+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEE3820773
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F49A4B16F;
	Mon, 20 Jul 2020 11:57:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tz8We0eSEHQM; Mon, 20 Jul 2020 11:57:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41BEE4B153;
	Mon, 20 Jul 2020 11:57:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B60284B17C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2020 11:57:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HvOjRCPpPTpr for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jul 2020 11:57:20 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B46A54B128
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2020 11:57:20 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9D9C422CAF;
 Mon, 20 Jul 2020 15:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595260639;
 bh=DAriQR7owdGrvsEryaAww7bKzCR16RMeh3u2L9dgHzY=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=DoJJ5Hy+fCNv5OM0/c/mciIMqsqBAANp6Tc4Wd7TBKmZ0LWrdc3Yw4YrSTDFRssmi
 LHd0atIgF5B6mqVz3mbM9O7YA5Dmu4B24nwSH+Xfug4zlJ7F/h1v0lMCR+xGo9Syos
 ld/ziOT5nLUrmuhoYHVixN6OtVJqdOSZJ4gelnyU=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jxYAI-00DMyO-9U; Mon, 20 Jul 2020 16:57:18 +0100
MIME-Version: 1.0
Date: Mon, 20 Jul 2020 16:57:18 +0100
From: Marc Zyngier <maz@kernel.org>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH 07/37] KVM: arm64: Separate SError detection from VAXorcism
In-Reply-To: <20200720154021.GA2383032@google.com>
References: <20200715184438.1390996-1-ascull@google.com>
 <20200715184438.1390996-8-ascull@google.com>
 <20200720154021.GA2383032@google.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <05409a8bb0ad0165d93133c5073f3fa7@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ascull@google.com, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu
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

On 2020-07-20 16:40, Andrew Scull wrote:
> On Wed, Jul 15, 2020 at 07:44:08PM +0100, Andrew Scull wrote:
>> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S 
>> b/arch/arm64/kvm/hyp/hyp-entry.S
>> index e727bee8e110..c441aabb8ab0 100644
>> --- a/arch/arm64/kvm/hyp/hyp-entry.S
>> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
>> @@ -177,7 +177,6 @@ el2_error:
>>  	adr	x1, abort_guest_exit_end
>>  	ccmp	x0, x1, #4, ne
>>  	b.ne	__hyp_panic
>> -	mov	x0, #(1 << ARM_EXIT_WITH_SERROR_BIT)
>>  	eret
>>  	sb
> 
> Having looked at this again, I also meant to remove the hunk below. It
> used to check that the SError had actually been taken through the
> exception vector but I am removing that.
> 
> However, do I need to continue doing that check to make sure the SError
> didn't get cancelled (if that is possible) or some other architectural
> phenomenon happened that I haven't factored in to my thinking?
> 
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -210,13 +222,8 @@ abort_guest_exit_end:
> 
>          msr     daifset, #4     // Mask aborts
> 	
> -       // If the exception took place, restore the EL1 exception
> -       // context so that we can report some information.
> -       // Merge the exception code with the SError pending bit.
> -       tbz     x0, #ARM_EXIT_WITH_SERROR_BIT, 1f

You have now inverted the logic: you detect the SError before
handling it, and set the flag accordingly. Which means that:

- you always enter this function having set ARM_EXIT_WITH_SERROR_BIT
   in the error code (which isn't passed to this function).

- you always take an exception, because you *know* there is a pending
   SError. Taking the exception on a non-RAS systems consumes it.

- If there is another SError pending after that, something bad happened
   at EL2, and we'll explode later on (on return to EL1).

So I think removing this hunk is the right thing to do.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

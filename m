Return-Path: <SRS0=wQQg=6G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12209C5518B
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 15:51:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8D8AB20767
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 15:51:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="rMHmyc73"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D8AB20767
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 354624B107;
	Wed, 22 Apr 2020 11:51:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id abCAouISMW5X; Wed, 22 Apr 2020 11:50:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 413284B186;
	Wed, 22 Apr 2020 11:50:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F9A24B16D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 11:50:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ab9xr4Cp+RdO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Apr 2020 11:50:57 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2942C4B107
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 11:50:57 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EA32220767;
 Wed, 22 Apr 2020 15:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587570656;
 bh=16hEh7COz5X6gcSR+cor8Xs6XMhtSt7DiaO+McpA8Xw=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=rMHmyc73fzTojqpjdwKu0r3nS1CE3k+rX6IVaJiJbUiZ+TXDsCzHKILep59dff0sg
 SvWFQdEHeBMdmlppWgVvZ/GyPw4mATcgm+0+MxEBoaZB7sFTnyw+l4zidFrBws1vmV
 f5iORe/ZCTL9Kpe/+OHiTnCc1xLGdFlO9M+lTXiI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jRHeI-005YGi-Am; Wed, 22 Apr 2020 16:50:54 +0100
MIME-Version: 1.0
Date: Wed, 22 Apr 2020 16:50:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH] arm64/kvm: Fix duplicate tracepoint definitions after KVM
 consolidation
In-Reply-To: <20200422152249.GE676@willie-the-truck>
References: <20200421091707.16743-1-will@kernel.org>
 <20200422152249.GE676@willie-the-truck>
Message-ID: <f353b0115e16914b0f91d74246c277d1@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On 2020-04-22 16:22, Will Deacon wrote:
> On Tue, Apr 21, 2020 at 10:17:07AM +0100, Will Deacon wrote:
>> Both kvm/{arm,handle_exit}.c include trace.h and attempt to 
>> instantiate
>> the same tracepoints, resulting in failures at link-time:
>> 
>>   | aarch64-linux-gnu-ld: 
>> arch/arm64/kvm/handle_exit.o:(__tracepoints+0x30):
>>   |   multiple definition of `__tracepoint_kvm_wfx_arm64';
>>   |   arch/arm64/kvm/arm.o:(__tracepoints+0x510): first defined here
>>   | ...
>> 
>> Split trace.h into two files so that the tracepoints are only created
>> in the C files that use them.
>> 
>> Cc: Marc Zyngier <maz@kernel.org>
>> Signed-off-by: Will Deacon <will@kernel.org>
>> ---
>> 
>> Applies against kvm-arm64/welcome-home. Probably worth just folding in
>> to the only commit on that branch.
> 
> I also just noticed that you forgot to update MAINTAINERS after the 
> move,
> so you can fold in the diff below as well.

All applied, squashed and pushed out.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

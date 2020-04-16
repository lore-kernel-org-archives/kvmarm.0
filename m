Return-Path: <SRS0=0qdQ=6A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F43C3815B
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 11:10:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 21F16206E9
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 11:10:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="cgOtPelt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21F16206E9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF3E74B262;
	Thu, 16 Apr 2020 07:10:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@mg.codeaurora.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bIqWmNbZAirZ; Thu, 16 Apr 2020 07:10:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D40D24B271;
	Thu, 16 Apr 2020 07:10:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 645E04B15D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 06:26:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4RXV-EtErq70 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Apr 2020 06:26:32 -0400 (EDT)
Received: from mail26.static.mailgun.info (mail26.static.mailgun.info
 [104.130.122.26])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 137434B14C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 06:26:32 -0400 (EDT)
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org;
 q=dns/txt; 
 s=smtp; t=1587032792; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=7e7yje6Jk92q2KWOzUZdbFCXe9Taa4CbqlpJEFe/hWg=;
 b=cgOtPelt0ucsY++dcv9Nyj3975sSKWOHxCtY0PWfCpzj4uXpa26KyA71b7mjjpQ922og3tze
 wX/ZSxBmQkU6/u+FZSd1WvFcHbTW+UCnxx16OvffP9hgHj72oWzd6/O2jnmW6Na4oi9Xwm+a
 7KY6zaLxMlDJGfNQFKsJ2tnvbLo=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiM2ZhNCIsICJrdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1IiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e9832d6.7f3ea7295d50-smtp-out-n04;
 Thu, 16 Apr 2020 10:26:30 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
 id C07D0C432C2; Thu, 16 Apr 2020 10:26:29 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 (Authenticated sender: saiprakash.ranjan)
 by smtp.codeaurora.org (Postfix) with ESMTPSA id 9BE44C433F2;
 Thu, 16 Apr 2020 10:26:28 +0000 (UTC)
MIME-Version: 1.0
Date: Thu, 16 Apr 2020 15:56:28 +0530
From: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 0/8] Relax sanity checking for mismatched AArch32 EL1
In-Reply-To: <a86108a91975cacf94adc2a2101fba1b@codeaurora.org>
References: <20200414213114.2378-1-will@kernel.org>
 <a86108a91975cacf94adc2a2101fba1b@codeaurora.org>
Message-ID: <e801954c0a14bf9483c084845c18dbfd@codeaurora.org>
X-Sender: saiprakash.ranjan@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-Mailman-Approved-At: Thu, 16 Apr 2020 07:10:16 -0400
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Doug Anderson <dianders@chromium.org>,
 Catalin Marinas <catalin.marinas@arm.com>, kernel-team@android.com,
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

On 2020-04-16 14:09, Sai Prakash Ranjan wrote:
> On 2020-04-15 03:01, Will Deacon wrote:
>> Hi all,
>> 
>> For better or worse, there are SoCs in production where some, but not
>> all of the CPUs, support AArch32 at EL1 and above. Right now, that
>> results in "SANITY CHECK" warnings during boot and an unconditional
>> kernel taint.
>> 
>> This patch series tries to do a bit better: the only time we care 
>> about
>> AArch32 at EL1 is for KVM, so rather than throw our toys out of the
>> pram, we can instead just disable support for 32-bit guests on these
>> systems. In the unlikely scenario of a late CPU hotplug being the 
>> first
>> time we notice that AArch32 is not available, then we fail the hotplug
>> (right now we let the thing come online, which leads to hilarious
>> results for any pre-existing 32-bit guests).
>> 
>> Feedback welcome,
>> 
>> Will
>> 
> 
> Thanks Will, tested this series on QCOM SC7180 and SM8150 SoCs.
> 
> For the entire series,
> 
> Tested-by: saiprakash.ranjan@codeaurora.org
> 

Urgh sorry, it should be

Tested-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

-Sai
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a 
member
of Code Aurora Forum, hosted by The Linux Foundation
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

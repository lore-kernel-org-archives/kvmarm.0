Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E458C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 12:25:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 29ED920786
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 12:25:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="h9GmAFF/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29ED920786
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD3864C0FE;
	Mon, 17 Aug 2020 08:25:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nFB95dm3W6dR; Mon, 17 Aug 2020 08:25:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEF914C0EB;
	Mon, 17 Aug 2020 08:25:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DADF14C0AB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 08:25:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DObhcYbMw3qI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 08:25:08 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B003F4C070
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 08:25:08 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 99FFA20658;
 Mon, 17 Aug 2020 12:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1597667107;
 bh=RCadk8ibATBlC4OXsKfPUxVYLbnc1pQ2OO78rBZG6yc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=h9GmAFF/1R9Kaz+2nZ1gJUEdSkuolk7DrWiYGIpCxI2BkfTQ3AZlmTOWwUPSjSmQ3
 FL5bikAbznQlWFNqieMVDUj5Y54rBaOuCeSvavd2eS5oepKBLM9TD6qmCeReqgmA+d
 3H9UVjKoWqs6x1dNCWP7nfXphqkIY/UpohdzoDGY=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k7eCI-003YxY-1H; Mon, 17 Aug 2020 13:25:06 +0100
MIME-Version: 1.0
Date: Mon, 17 Aug 2020 13:25:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: yezengruan <yezengruan@huawei.com>
Subject: Re: [RFC][PATCH 0/4] arm64:kvm: teach guest sched that VCPUs can be
 preempted
In-Reply-To: <fe72592c-c721-bece-1469-95eebf931299@huawei.com>
References: <20200721041742.197354-1-sergey.senozhatsky@gmail.com>
 <20200817020310.GA1210848@jagdpanzerIV.localdomain>
 <fe72592c-c721-bece-1469-95eebf931299@huawei.com>
User-Agent: Roundcube Webmail/1.4.7
Message-ID: <cbcfb402b7fdb8a2a45b80fbb0e79f3e@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yezengruan@huawei.com, sergey.senozhatsky@gmail.com,
 will@kernel.org, joelaf@google.com, linux-kernel@vger.kernel.org,
 suleiman@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: joelaf@google.com, linux-kernel@vger.kernel.org,
 Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, suleiman@google.com,
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

On 2020-08-17 13:03, yezengruan wrote:
> On 2020/8/17 10:03, Sergey Senozhatsky wrote:
>> On (20/07/21 13:17), Sergey Senozhatsky wrote:
>>> Hello,
>>> 
>>> 	RFC
>>> 
>>> 	We noticed that in a number of cases when we wake_up_process()
>>> on arm64 guest we end up enqueuing that task on a preempted VCPU. The 
>>> culprit
>>> appears to be the fact that arm64 guests are not aware of VCPU 
>>> preemption
>>> as such, so when sched picks up an idle VCPU it always assumes that 
>>> VCPU
>>> is available:
>>> 
>>>       wake_up_process()
>>>        try_to_wake_up()
>>>         select_task_rq_fair()
>>>          available_idle_cpu()
>>>           vcpu_is_preempted()    // return false;
>>> 
>>> Which is, obviously, not the case.
>>> 
>>> This RFC patch set adds a simple vcpu_is_preempted() implementation 
>>> so
>>> that scheduler can make better decisions when it search for the idle
>>> (v)CPU.
>> Hi,
>> 
>> A gentle ping.
>> 
>> 	-ss
>> _______________________________________________
>> kvmarm mailing list
>> kvmarm@lists.cs.columbia.edu
>> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>> .
> 
> Hi Sergey,
> 
> I have a set of patches similar to yours.
> 
> https://lore.kernel.org/lkml/20191226135833.1052-1-yezengruan@huawei.com/

It really isn't the same thing at all. You are exposing PV spinlocks,
while Sergey exposes preemption to vcpus. The former is a massive,
and probably unnecessary superset of the later, which only impacts
the scheduler (it doesn't change the way locks are implemented).

You really shouldn't conflate the two (which you have done in your
series).

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

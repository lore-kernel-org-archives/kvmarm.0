Return-Path: <SRS0=saMt=KH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 982B4C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 16:18:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 88DB961C91
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 16:18:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88DB961C91
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 063AC4B3FD;
	Wed, 12 May 2021 12:18:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qi40iLpmGxch; Wed, 12 May 2021 12:18:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C821D4B48F;
	Wed, 12 May 2021 12:18:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2F634B3FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 12:18:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i3f-Ylpf0Nwr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 May 2021 12:18:46 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5ED4A4B3E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 12:18:46 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2191461C8B;
 Wed, 12 May 2021 16:18:45 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1lgrZK-000xgy-Pp; Wed, 12 May 2021 17:18:43 +0100
MIME-Version: 1.0
Date: Wed, 12 May 2021 17:18:42 +0100
From: Marc Zyngier <maz@kernel.org>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 4/5] KVM: selftests: Add exception handling support for
 aarch64
In-Reply-To: <YJv8NUtKilXPDYpY@google.com>
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-5-ricarkol@google.com>
 <87a6pcumyg.wl-maz@kernel.org> <YJBLFVoRmsehRJ1N@google.com>
 <20915a2f-d07c-2e61-3cce-ff385e98e796@redhat.com>
 <4f7f81f9-8da0-b4ef-49e2-7d87b5c23b15@huawei.com>
 <a5ad32abf4ff6f80764ee31f16a5e3fc@kernel.org> <YJv8NUtKilXPDYpY@google.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <ad3fd18571983a08952f523ad5091360@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ricarkol@google.com, yuzenghui@huawei.com,
 eric.auger@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

On 2021-05-12 17:03, Ricardo Koller wrote:
> On Wed, May 12, 2021 at 02:43:28PM +0100, Marc Zyngier wrote:
>> On 2021-05-12 13:59, Zenghui Yu wrote:
>> > Hi Eric,
>> >
>> > On 2021/5/6 20:30, Auger Eric wrote:
>> > > running the test on 5.12 I get
>> > >
>> > > ==== Test Assertion Failure ====
>> > >   aarch64/debug-exceptions.c:232: false
>> > >   pid=6477 tid=6477 errno=4 - Interrupted system call
>> > >      1	0x000000000040147b: main at debug-exceptions.c:230
>> > >      2	0x000003ff8aa60de3: ?? ??:0
>> > >      3	0x0000000000401517: _start at :?
>> > >   Failed guest assert: hw_bp_addr == PC(hw_bp) at
>> > > aarch64/debug-exceptions.c:105
>> > > 	values: 0, 0x401794
>> >
>> > FYI I can also reproduce it on my VHE box. And Drew's suggestion [*]
>> > seemed to work for me. Is the ISB a requirement of architecture?
>> 
>> Very much so. Given that there is no context synchronisation (such as
>> ERET or an interrupt) in this code, the CPU is perfectly allowed to
>> delay the system register effect as long as it can.
>> 
>>         M.
>> --
>> Jazz is not dead. It just smells funny...
> 
> Thank you very much Eric, Zenghui, Marc, and Andrew (for the ISB
> suggestion)!
> 
> As per Zenghui test, will send a V3 that includes the missing ISBs.
> Hopefully that will fix the issue for Eric as well. It's very
> interesting that the CPU seems to _always_ reorder those instructions.

I suspect that because hitting the debug registers can be a costly
operation (it mobilises a lot of resources in the CPU), there is
a strong incentive to let it slide until there is an actual mandate
to commit the resource.

It also means that SW can issue a bunch of these without too much
overhead, and only pay the cost *once*.

Your N1 CPU seems to be less aggressive on this. Implement choice,
I'd say (it probably is more aggressive than TX2 on other things).
Also, QEMU will almost always hide these problems, due to the nature
of TCG.

Thanks,

          M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

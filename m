Return-Path: <SRS0=QomF=6E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433DAC3815B
	for <kvmarm@archiver.kernel.org>; Mon, 20 Apr 2020 13:46:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C677F21473
	for <kvmarm@archiver.kernel.org>; Mon, 20 Apr 2020 13:46:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C677F21473
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2824C4B12F;
	Mon, 20 Apr 2020 09:46:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YGzD58QPqCmL; Mon, 20 Apr 2020 09:46:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0199B4B131;
	Mon, 20 Apr 2020 09:46:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E11024B12F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Apr 2020 09:46:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LtgBYRzem+DV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Apr 2020 09:46:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A7854B12B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Apr 2020 09:46:17 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A5A2F1FB;
 Mon, 20 Apr 2020 06:46:16 -0700 (PDT)
Received: from [192.168.1.84] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BFD8B3F68F;
 Mon, 20 Apr 2020 06:46:13 -0700 (PDT)
Subject: Re: [RFC PATCH] arm64: unify WORKAROUND_SPECULATIVE_AT_{NVHE,VHE}
To: Will Deacon <will@kernel.org>, Andrew Scull <ascull@google.com>
References: <20200327143941.195626-1-ascull@google.com>
 <1705907b-234c-6f56-1360-f598c8047d1d@arm.com>
 <20200403125726.GA33049@google.com> <20200417164103.GA12362@willie-the-truck>
From: Steven Price <steven.price@arm.com>
Message-ID: <40f6b8bc-3ff4-2053-f8ae-e6b5fb811573@arm.com>
Date: Mon, 20 Apr 2020 14:46:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200417164103.GA12362@willie-the-truck>
Content-Language: en-GB
Cc: "qwandor@google.com" <qwandor@google.com>, Marc Zyngier <maz@kernel.org>,
 "wedsonaf@google.com" <wedsonaf@google.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "kernel-team@android.com" <kernel-team@android.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
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

On 17/04/2020 17:41, Will Deacon wrote:
> On Fri, Apr 03, 2020 at 01:57:26PM +0100, Andrew Scull wrote:
>> On Fri, Mar 27, 2020 at 02:59:47PM +0000, Steven Price wrote:
>>> I proposed something similar a while ago[1], but Marc was concerned about
>>> the microarch detail[2] and hence I split the workaround into VHE/non-VHE.
>>>
>>> That said I'm not saying this is necessarily wrong, just that we'd need some
>>> more information on whether the non-VHE workaround is suitable for the CPUs
>>> we're currently forcing VHE on.
>>
>> We noticed that both the nVHE and VHE workarounds share the same
>> assumption that the EPDx bits are not being cached in the TLB.
>>
>> `__tlb_switch_to_guest_vhe` and `__tlb_switch_to_guest_nvhe` are both
>> setting EPDx as part of the workaround. However, neither handles the
>> possibility of a speculative AT being able to make use of a cached EPD=0
>> value in the TLB in order to allocate bad TLB entries.
>>
>> If this is correct, the microarch concern appears to have been solved
>> already. Otherwise, or if we are unsure, we should go ahead and add the
>> TLB flushes to keep this safe.
> 
> I think Andrew's right here. Can we go ahead with the original approach of
> combining the workarounds, or is there something we've missed?

As far as I know it is safe to combine the workarounds: I did post my 
own patch earlier. But I don't have the deep understanding of the 
microarch - so I accepted Marc's concerns and dropped that, and was 
simply linking up the discussions.

The assumption before was that booting a VHE capable system without VHE 
wasn't useful, so there wasn't a pressing need to unify the workarounds. 
And therefore the easiest option for me was to keep the workarounds 
separate. Since there is apparently a desire to do such a thing then 
unifying the workarounds seems reasonable.

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

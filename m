Return-Path: <SRS0=L5kI=FO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F983C4361B
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 08:45:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA57D22D58
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 08:45:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA57D22D58
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09C244B1C0;
	Thu, 10 Dec 2020 03:45:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d6ZBDavlEEGr; Thu, 10 Dec 2020 03:45:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9E484B14D;
	Thu, 10 Dec 2020 03:45:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D6804B14D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 03:45:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fk4kPtYTNQ9J for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Dec 2020 03:45:26 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A8B14B134
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 03:45:26 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 06B3422CA1;
 Thu, 10 Dec 2020 08:45:25 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1knHZi-00013B-TO; Thu, 10 Dec 2020 08:45:23 +0000
MIME-Version: 1.0
Date: Thu, 10 Dec 2020 08:45:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: Joel Fernandes <joelaf@google.com>, Quentin Perret <qperret@google.com>
Subject: Re: [RFC][PATCH 0/4] arm64:kvm: teach guest sched that VCPUs can be
 preempted
In-Reply-To: <CAJWu+ooy=r=G+AnyriQDA9_4CJqfO6hkf=c8heV8HV+yNea_PQ@mail.gmail.com>
References: <20200721041742.197354-1-sergey.senozhatsky@gmail.com>
 <20200817020310.GA1210848@jagdpanzerIV.localdomain>
 <fe72592c-c721-bece-1469-95eebf931299@huawei.com>
 <cbcfb402b7fdb8a2a45b80fbb0e79f3e@kernel.org>
 <20200911085841.GB562@jagdpanzerIV.localdomain>
 <CAJWu+oq26OK1-7Ze2pb5xpRJ-tS9wtXOdGFrYpHq+fhkyGhjkA@mail.gmail.com>
 <fdc35e25f2bc2cdfa0849a84802eafd6@kernel.org>
 <CAJWu+ooy=r=G+AnyriQDA9_4CJqfO6hkf=c8heV8HV+yNea_PQ@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <78091359dab0d8decfc452f7c5c25971@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: joelaf@google.com, qperret@google.com,
 sergey.senozhatsky@gmail.com, yezengruan@huawei.com, will@kernel.org,
 linux-kernel@vger.kernel.org, suleiman@google.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: LKML <linux-kernel@vger.kernel.org>,
 Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
 Suleiman Souhlal <suleiman@google.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, "moderated list:ARM64 PORT \(AARCH64
 ARCHITECTURE\)" <linux-arm-kernel@lists.infradead.org>
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

On 2020-12-10 01:39, Joel Fernandes wrote:

[...]

>> Quentin and I have discussed potential ways of improving guest
>> scheduling
>> on terminally broken systems (otherwise known as big-little), in the
>> form of a capacity request from the guest to the host. I'm not really
>> keen on the host exposing its own capacity, as that doesn't tell the
>> host what the guest actually needs.
> 
> I am not sure how a capacity request could work well. It seems the
> cost of a repeated hypercall could be prohibitive. In this case, a
> lighter approach might be for KVM to restrict vCPU threads to run on
> certain types of cores, and pass the capacity information to the guest
> at guest's boot time.

That seems like a very narrow use case. If you actually pin vcpus to
physical CPU classes, DT is the right place to put things, because
it is completely static. This is effectively creating a virtual
big-little, which is in my opinion a userspace job.

> This would be a one-time cost to pay. And then,
> then the guest scheduler can handle the scheduling appropriately
> without any more hypercalls. Thoughts?

Anything that is a one-off belongs to firmware configuration, IMO.

The case I'm concerned with is when vcpus are allowed to roam across
the system, and hit random physical CPUs because the host has no idea
of the workload the guest deals with (specially as the AMU counters
are either absent or unusable on any available core).

The cost of a hypercall really depends on where you terminate it.
If it is a shallow exit, that's only a few hundred cycles on any half
baked CPU. Go all the way to userspace, and the host scheduler is the
limit. But the frequency of that hypercall obviously matters too.

How often do you expect the capacity request to fire? Probably not
on each and every time slice, right?

Quentin, can you shed some light on this?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

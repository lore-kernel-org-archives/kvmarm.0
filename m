Return-Path: <SRS0=103j=YJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43DC3C4360C
	for <kvmarm@archiver.kernel.org>; Wed, 16 Oct 2019 10:23:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D203E20872
	for <kvmarm@archiver.kernel.org>; Wed, 16 Oct 2019 10:23:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D203E20872
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D3C94A9FF;
	Wed, 16 Oct 2019 06:23:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qeJ8D0H7cplJ; Wed, 16 Oct 2019 06:23:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39C1A4A9D2;
	Wed, 16 Oct 2019 06:23:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AA9F4A8F2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 06:23:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3XmQkUWWOMc9 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Oct 2019 06:23:46 -0400 (EDT)
Received: from Galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3EEE94A84C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 06:23:46 -0400 (EDT)
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
 by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
 (Exim 4.80) (envelope-from <tglx@linutronix.de>)
 id 1iKgSw-0002ga-0Y; Wed, 16 Oct 2019 12:23:38 +0200
Date: Wed, 16 Oct 2019 12:23:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
Subject: RE: [PATCH v5 3/6] timekeeping: Add clocksource to
 system_time_snapshot
In-Reply-To: <HE1PR0801MB1676EC775B7BFA5FC7E4F9D5F4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
Message-ID: <alpine.DEB.2.21.1910161218020.2046@nanos.tec.linutronix.de>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-4-jianyong.wu@arm.com>
 <9274d21c-2c43-2e0d-f086-6aaba3863603@redhat.com>
 <alpine.DEB.2.21.1910152212580.2518@nanos.tec.linutronix.de>
 <aa1ec910-b7b6-2568-4583-5fa47aac367f@redhat.com>
 <alpine.DEB.2.21.1910160914230.2518@nanos.tec.linutronix.de>
 <HE1PR0801MB1676EC775B7BFA5FC7E4F9D5F4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Cc: "Justin He \(Arm Technology China\)" <Justin.He@arm.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "maz@kernel.org" <maz@kernel.org>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>,
 "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>, Paolo Bonzini <pbonzini@redhat.com>,
 nd <nd@arm.com>, "will@kernel.org" <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Jianyong,

On Wed, 16 Oct 2019, Jianyong Wu (Arm Technology China) wrote:

Please fix your mail client not to copy the full headers into the reply.

> > On Wed, 16 Oct 2019, Paolo Bonzini wrote:
> > > On 15/10/19 22:13, Thomas Gleixner wrote:
> > That's a completely different beast, really.
> > 
> > The clocksource pointer is handed in by the caller and the core code validates
> > if the clocksource is the same as the current system clocksource and not the
> > other way round.
> > 
> > So there is no need for getting that pointer from the core code because the
> > caller knows already which clocksource needs to be active to make.the whole
> > cross device timestamp correlation work. And in that case it's the callers
> > responsibility to ensure that the pointer is valid which is the case for the
> > current use cases.
> > 
> I thinks there is something misunderstanding of my patch. See patch 4/6,
> the reason why I add clocksource is that I want to check if the current
> clocksouce is arm_arch_counter in virt/kvm/arm/psci.c and nothing to do
> with get_device_system_crosststamp.

There is no misunderstanding at all. Your patch is broken in several ways
as I explained in detail.

> So I really need a mechanism to do that check.
> 
> Thanks
> Jianyong

So just by chance I scrolled further down and found more replies from
you. Please trim the reply properly and add your 'Thanks Jianyong' to the
end of the mail.
 
> > From your other reply:
> > 
> > > Why add a global id?  ARM can add it to archdata similar to how x86
> > > has vclock_mode.  But I still think the right thing to do is to
> > > include the full system_counterval_t in the result of
> > > ktime_get_snapshot.  (More in a second, feel free to reply to the other
> > email only).
> > 
> > No, the clocksource pointer is not going to be exposed as there is no
> > guarantee that it will be still around after the call returns.
> > 
> > It's not even guaranteed to be correct when the store happens in Wu's patch
> > simply because the store is done outside of the seqcount protected region.
> 
> Yeah, all of the elements in system_time_snapshot should be captured in
> consistency. So I think the consistency will be guaranteed if the store
> ops added in the seqcount region.

Again. While it is consistent in terms of storage, it's still wrong to
expose a pointer to something which has no life time guarantee. Even if
your use case is just to compare the pointer it's a bad idea to do that
especially without any comment about the pointer validity at all.

Thanks,

	tglx
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

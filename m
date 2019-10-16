Return-Path: <SRS0=103j=YJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6450DECE588
	for <kvmarm@archiver.kernel.org>; Wed, 16 Oct 2019 07:28:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E407420872
	for <kvmarm@archiver.kernel.org>; Wed, 16 Oct 2019 07:28:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E407420872
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A4CB4A960;
	Wed, 16 Oct 2019 03:28:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KJSTPJwOrnV5; Wed, 16 Oct 2019 03:28:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30E244A9A2;
	Wed, 16 Oct 2019 03:28:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A2E84A960
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 03:28:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yn7-D3TyxmKH for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Oct 2019 03:28:39 -0400 (EDT)
Received: from Galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 356BC4A522
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 03:28:39 -0400 (EDT)
Received: from p5b06da22.dip0.t-ipconnect.de ([91.6.218.34] helo=nanos)
 by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
 (Exim 4.80) (envelope-from <tglx@linutronix.de>)
 id 1iKdjU-0007KO-Cs; Wed, 16 Oct 2019 09:28:32 +0200
Date: Wed, 16 Oct 2019 09:28:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5 3/6] timekeeping: Add clocksource to
 system_time_snapshot
In-Reply-To: <aa1ec910-b7b6-2568-4583-5fa47aac367f@redhat.com>
Message-ID: <alpine.DEB.2.21.1910160914230.2518@nanos.tec.linutronix.de>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-4-jianyong.wu@arm.com>
 <9274d21c-2c43-2e0d-f086-6aaba3863603@redhat.com>
 <alpine.DEB.2.21.1910152212580.2518@nanos.tec.linutronix.de>
 <aa1ec910-b7b6-2568-4583-5fa47aac367f@redhat.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required, ALL_TRUSTED=-1,
 SHORTCIRCUIT=-0.0001
Cc: justin.he@arm.com, kvm@vger.kernel.org, maz@kernel.org,
 richardcochran@gmail.com, Jianyong Wu <jianyong.wu@arm.com>,
 linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
 yangbo.lu@nxp.com, john.stultz@linaro.org, netdev@vger.kernel.org, nd@arm.com,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, 16 Oct 2019, Paolo Bonzini wrote:
> On 15/10/19 22:13, Thomas Gleixner wrote:
> > On Tue, 15 Oct 2019, Paolo Bonzini wrote:
> >> On 15/10/19 12:48, Jianyong Wu wrote:
> >>>  
> >>>
> >>
> >> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > 
> > You're sure about having reviewed that in detail?
> 
> I did review the patch; the void* ugliness is not in this one, and I do
> have some other qualms on that one.
> 
> > This changelog is telling absolutely nothing WHY anything outside of the
> > timekeeping core code needs access to the current clocksource. Neither does
> > it tell why it is safe to provide the pointer to random callers.
> 
> Agreed on the changelog, but the pointer to a clocksource is already
> part of the timekeeping external API via struct system_counterval_t.
> get_device_system_crosststamp for example expects a clocksource pointer
> but provides no way to get such a pointer.

That's a completely different beast, really.

The clocksource pointer is handed in by the caller and the core code
validates if the clocksource is the same as the current system clocksource
and not the other way round.

So there is no need for getting that pointer from the core code because the
caller knows already which clocksource needs to be active to make.the whole
cross device timestamp correlation work. And in that case it's the callers
responsibility to ensure that the pointer is valid which is the case for
the current use cases.

From your other reply:

> Why add a global id?  ARM can add it to archdata similar to how x86 has
> vclock_mode.  But I still think the right thing to do is to include the
> full system_counterval_t in the result of ktime_get_snapshot.  (More in
> a second, feel free to reply to the other email only).

No, the clocksource pointer is not going to be exposed as there is no
guarantee that it will be still around after the call returns.

It's not even guaranteed to be correct when the store happens in Wu's patch
simply because the store is done outside of the seqcount protected region.

Vs. arch data: arch data is an opaque struct, so you'd need to store a
pointer which has the same issue as the clocksource pointer itself.

If we want to convey information then it has to be in the generic part
of struct clocksource.

In fact we could even simplify the existing get_device_system_crosststamp()
use case by using the ID field.

Thanks,

	tglx
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

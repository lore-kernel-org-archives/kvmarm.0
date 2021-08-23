Return-Path: <SRS0=YqI3=NO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAE9DC4338F
	for <kvmarm@archiver.kernel.org>; Mon, 23 Aug 2021 21:51:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4794F610D0
	for <kvmarm@archiver.kernel.org>; Mon, 23 Aug 2021 21:51:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4794F610D0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA1E74B1F3;
	Mon, 23 Aug 2021 17:51:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sKmAWQL22hZm; Mon, 23 Aug 2021 17:51:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFF494B1F5;
	Mon, 23 Aug 2021 17:51:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B9BA4B1F3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 17:51:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I+xZYnF+c-uV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Aug 2021 17:51:51 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 74E184B1DC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 17:51:51 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 51466611CB;
 Mon, 23 Aug 2021 21:51:50 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mIHrA-006lhN-7D; Mon, 23 Aug 2021 22:51:48 +0100
MIME-Version: 1.0
Date: Mon, 23 Aug 2021 22:51:48 +0100
From: Marc Zyngier <maz@kernel.org>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH] KVM: arm64: Ratelimit error log during guest debug
 exception
In-Reply-To: <CAJHc60wLPFZ5XFwWVyex5GXr=qm7QWc2yOmkECxLh=L2QnvgWg@mail.gmail.com>
References: <20210819223406.1132426-1-rananta@google.com>
 <87sfz4qx9r.wl-maz@kernel.org>
 <CAJHc60wn7PP1zQ5EKOGQDFbZsf=d9codWTuWbtMT5AHegfbVHw@mail.gmail.com>
 <875yvzqd5d.wl-maz@kernel.org>
 <CAJHc60wLPFZ5XFwWVyex5GXr=qm7QWc2yOmkECxLh=L2QnvgWg@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <1a0dfd2bc950cb84e7344973657c6b23@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: rananta@google.com, alexandru.elisei@arm.com,
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org,
 pshier@google.com, ricarkol@google.com, oupton@google.com, reijiw@google.com,
 jingzhangos@google.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
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

On 2021-08-23 19:13, Raghavendra Rao Ananta wrote:
> On Sat, Aug 21, 2021 at 3:56 AM Marc Zyngier <maz@kernel.org> wrote:
>> 
>> On Sat, 21 Aug 2021 00:01:24 +0100,
>> Raghavendra Rao Ananta <rananta@google.com> wrote:
>> >
>> > [1  <text/plain; UTF-8 (7bit)>]
>> > On Fri, Aug 20, 2021 at 2:29 AM Marc Zyngier <maz@kernel.org> wrote:
>> > >
>> > > On Thu, 19 Aug 2021 23:34:06 +0100,
>> > > Raghavendra Rao Ananta <rananta@google.com> wrote:
>> > > >
>> > > > Potentially, the guests could trigger a debug exception that's
>> > > > outside the exception class range.
>> > >
>> > > How? All the exception classes that lead to this functions are already
>> > > handled in the switch/case statement.
>> > >
>> > I guess I didn't think this through. Landing into kvm_handle_guest_debug()
>> > itself is not possible :)
>> 
>> Exactly.
>> 
>> > > My take on this is that this code isn't reachable, and that it could
>> > > be better rewritten as:
>> > >
>> > > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
>> > > index 6f48336b1d86..ae7ec086827b 100644
>> > > --- a/arch/arm64/kvm/handle_exit.c
>> > > +++ b/arch/arm64/kvm/handle_exit.c
>> > > @@ -119,28 +119,14 @@ static int kvm_handle_guest_debug(struct kvm_vcpu
>> > *vcpu)
>> > >  {
>> > >         struct kvm_run *run = vcpu->run;
>> > >         u32 esr = kvm_vcpu_get_esr(vcpu);
>> > > -       int ret = 0;
>> > >
>> > >         run->exit_reason = KVM_EXIT_DEBUG;
>> > >         run->debug.arch.hsr = esr;
>> > >
>> > > -       switch (ESR_ELx_EC(esr)) {
>> > > -       case ESR_ELx_EC_WATCHPT_LOW:
>> > > +       if (ESR_ELx_EC(esr) ==  ESR_ELx_EC_WATCHPT_LOW)
>> > >                 run->debug.arch.far = vcpu->arch.fault.far_el2;
>> > > -               fallthrough;
>> > > -       case ESR_ELx_EC_SOFTSTP_LOW:
>> > > -       case ESR_ELx_EC_BREAKPT_LOW:
>> > > -       case ESR_ELx_EC_BKPT32:
>> > > -       case ESR_ELx_EC_BRK64:
>> > > -               break;
>> > > -       default:
>> > > -               kvm_err("%s: un-handled case esr: %#08x\n",
>> > > -                       __func__, (unsigned int) esr);
>> > > -               ret = -1;
>> > > -               break;
>> > > -       }
>> > >
>> > > -       return ret;
>> > > +       return 0;
>> > >  }
>> > >
>> > This looks better, but do you think we would be compromising on readability?
>> 
>> I don't think so. The exit handler table is, on its own, pretty
>> explicit about what we route to this handler, and the comment above
>> the function clearly states that we exit to userspace for all the
>> debug ECs.
> 
> Sounds great. I'm happy to send out a patch with you as 'Suggested-by' 
> , if you
> are okay with it.

Fire away!

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

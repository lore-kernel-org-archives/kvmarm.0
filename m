Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B19E8C352A3
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 12:54:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 38CD520675
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 12:54:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a10ghsPn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38CD520675
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF42F4AEBF;
	Tue, 11 Feb 2020 07:54:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f4m7vQgEX+L3; Tue, 11 Feb 2020 07:54:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88E2C4AE96;
	Tue, 11 Feb 2020 07:54:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A25D44A59B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 07:54:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uL5P3u4j36OQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 07:54:52 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AA774A578
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 07:54:52 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581425692;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=eErryK0HVE7jdyNx64aaPiBro0tYOzj8t3CQOtIhU+U=;
 b=a10ghsPnIHUaVAEZAuUwbb0Wzyu5eIOMHEQUayQph6uF8fBg250CW1aUrklf5Ji5wKj9Gs
 U1D6MFPLzpofeWsbCLxCRXPQ4XXgqTeOxiolfFJKLbftwy70LnDNEbylJRQSjqm77OLRqs
 sDuBBm+IZrITAn8qscB1ypSE4XXWt4M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-V33cEV-PONKehosh-FP2cw-1; Tue, 11 Feb 2020 07:54:45 -0500
X-MC-Unique: V33cEV-PONKehosh-FP2cw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6B74DB6B;
 Tue, 11 Feb 2020 12:54:43 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 94D7226FA3;
 Tue, 11 Feb 2020 12:54:42 +0000 (UTC)
Date: Tue, 11 Feb 2020 13:54:39 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvm-unit-tests] arm64: timer: Speed up gic-timer-state
 check
Message-ID: <20200211125439.pusktgsomid43axu@kamzik.brq.redhat.com>
References: <20200211123521.13637-1-drjones@redhat.com>
 <bba0ce4f-15c6-aa14-4bd8-ce6598b45fd4@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <bba0ce4f-15c6-aa14-4bd8-ce6598b45fd4@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Tue, Feb 11, 2020 at 12:49:23PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On 2/11/20 12:35 PM, Andrew Jones wrote:
> > Let's bail out of the wait loop if we see the expected state
> > to save about seven seconds of run time. Make sure we wait a
> > bit before reading the registers, though, to somewhat mitigate
> > the chance of the expected state being stale.
> >
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arm/timer.c | 17 ++++++++++-------
> >  1 file changed, 10 insertions(+), 7 deletions(-)
> >
> > diff --git a/arm/timer.c b/arm/timer.c
> > index f5cf775ce50f..c2262c112c09 100644
> > --- a/arm/timer.c
> > +++ b/arm/timer.c
> > @@ -183,7 +183,8 @@ static bool timer_pending(struct timer_info *info)
> >  		(info->read_ctl() & ARCH_TIMER_CTL_ISTATUS);
> >  }
> >  
> > -static enum gic_state gic_timer_state(struct timer_info *info)
> > +static bool gic_timer_check_state(struct timer_info *info,
> > +				  enum gic_state expected_state)
> >  {
> >  	enum gic_state state = GIC_STATE_INACTIVE;
> >  	int i;
> > @@ -191,6 +192,7 @@ static enum gic_state gic_timer_state(struct timer_info *info)
> >  
> >  	/* Wait for up to 1s for the GIC to sample the interrupt. */
> >  	for (i = 0; i < 10; i++) {
> > +		mdelay(100);
> >  		pending = readl(gic_ispendr) & (1 << PPI(info->irq));
> >  		active = readl(gic_isactiver) & (1 << PPI(info->irq));
> >  		if (!active && !pending)
> > @@ -201,10 +203,11 @@ static enum gic_state gic_timer_state(struct timer_info *info)
> >  			state = GIC_STATE_ACTIVE;
> >  		if (active && pending)
> >  			state = GIC_STATE_ACTIVE_PENDING;
> > -		mdelay(100);
> > +		if (state == expected_state)
> > +			return true;
> >  	}
> >  
> > -	return state;
> > +	return false;
> >  }
> 
> The first version I wrote looked similar. However I decided to wait the entire 1s
> because I could imagine a situation where the interrupt was pending, but if I were
> to wait a bit longer, it would have become active and pending, which is not what
> we would want. Same thing with inactive.
> 
> How about after the state matches what we expect, we wait for an extra 100ms and
> check that the state hasn't changed?

That sounds good. I'll send a v2 with that.

> 
> Also, you probably also want to lower the timeout in arm/unittests.cfg.

The timeout is fine, because if we need to loop the worst-case scenario
amount of time then we want the timeout high enough. It's not really a
goal to make the timeout just barely long enough to cover the test anyway.
If the timeout is too long, and we need it to fire, then it just means
test runners will have to wait longer for it.

Thanks,
drew

> 
> Thanks,
> Alex
> >  
> >  static bool test_cval_10msec(struct timer_info *info)
> > @@ -253,11 +256,11 @@ static void test_timer(struct timer_info *info)
> >  	/* Enable the timer, but schedule it for much later */
> >  	info->write_cval(later);
> >  	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
> > -	report(!timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
> > +	report(!timer_pending(info) && gic_timer_check_state(info, GIC_STATE_INACTIVE),
> >  			"not pending before");
> >  
> >  	info->write_cval(now - 1);
> > -	report(timer_pending(info) && gic_timer_state(info) == GIC_STATE_PENDING,
> > +	report(timer_pending(info) && gic_timer_check_state(info, GIC_STATE_PENDING),
> >  			"interrupt signal pending");
> >  
> >  	/* Disable the timer again and prepare to take interrupts */
> > @@ -265,12 +268,12 @@ static void test_timer(struct timer_info *info)
> >  	info->irq_received = false;
> >  	set_timer_irq_enabled(info, true);
> >  	report(!info->irq_received, "no interrupt when timer is disabled");
> > -	report(!timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
> > +	report(!timer_pending(info) && gic_timer_check_state(info, GIC_STATE_INACTIVE),
> >  			"interrupt signal no longer pending");
> >  
> >  	info->write_cval(now - 1);
> >  	info->write_ctl(ARCH_TIMER_CTL_ENABLE | ARCH_TIMER_CTL_IMASK);
> > -	report(timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
> > +	report(timer_pending(info) && gic_timer_check_state(info, GIC_STATE_INACTIVE),
> >  			"interrupt signal not pending");
> >  
> >  	report(test_cval_10msec(info), "latency within 10 ms");
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

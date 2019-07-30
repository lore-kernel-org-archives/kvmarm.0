Return-Path: <SRS0=XAfE=V3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC06C433FF
	for <kvmarm@archiver.kernel.org>; Tue, 30 Jul 2019 11:05:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5E82F206E0
	for <kvmarm@archiver.kernel.org>; Tue, 30 Jul 2019 11:05:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E82F206E0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C961C4A54C;
	Tue, 30 Jul 2019 07:05:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wRrL3-cvzE-k; Tue, 30 Jul 2019 07:05:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83EA34A520;
	Tue, 30 Jul 2019 07:05:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FEFF4A4FB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jul 2019 07:05:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ot7+VTbV25wh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Jul 2019 07:05:31 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CFB434A4F5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jul 2019 07:05:31 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 0CAA4335C1;
 Tue, 30 Jul 2019 11:05:31 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AE2E560922;
 Tue, 30 Jul 2019 11:05:29 +0000 (UTC)
Date: Tue, 30 Jul 2019 13:05:27 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH] arm: timer: Fix potential deadlock when
 waiting for interrupt
Message-ID: <20190730110527.houpn2oijyytdfom@kamzik.brq.redhat.com>
References: <1564392532-7692-1-git-send-email-alexandru.elisei@arm.com>
 <20190729112309.wooytkz7g6qtvvc2@kamzik.brq.redhat.com>
 <ab4d8b69-9fc2-94a0-f5a3-01fb87c3ac44@arm.com>
 <20190730101215.i3geqxzwjqwyp3bz@kamzik.brq.redhat.com>
 <e827084e-7c8c-0970-dcb0-8227d5660bff@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e827084e-7c8c-0970-dcb0-8227d5660bff@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.38]); Tue, 30 Jul 2019 11:05:31 +0000 (UTC)
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Jul 30, 2019 at 11:49:09AM +0100, Alexandru Elisei wrote:
> On 7/30/19 11:12 AM, Andrew Jones wrote:
> > On Tue, Jul 30, 2019 at 10:30:50AM +0100, Alexandru Elisei wrote:
> >> On 7/29/19 12:23 PM, Andrew Jones wrote:
> >>> On Mon, Jul 29, 2019 at 10:28:52AM +0100, Alexandru Elisei wrote:
> >>>> Commit 204e85aa9352 ("arm64: timer: a few test improvements") added =
a call
> >>>> to report_info after enabling the timer and before the wfi instructi=
on. The
> >>>> uart that printf uses is emulated by userspace and is slow, which ma=
kes it
> >>>> more likely that the timer interrupt will fire before executing the =
wfi
> >>>> instruction, which leads to a deadlock.
> >>>>
> >>>> An interrupt can wake up a CPU out of wfi, regardless of the
> >>>> PSTATE.{A, I, F} bits. Fix the deadlock by masking interrupts on the=
 CPU
> >>>> before enabling the timer and unmasking them after the wfi returns s=
o the
> >>>> CPU can execute the timer interrupt handler.
> >>>>
> >>>> Suggested-by: Marc Zyngier <marc.zyngier@arm.com>
> >>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >>>> ---
> >>>>  arm/timer.c | 2 ++
> >>>>  1 file changed, 2 insertions(+)
> >>>>
> >>>> diff --git a/arm/timer.c b/arm/timer.c
> >>>> index 6f2ad1d76ab2..f2f60192ba62 100644
> >>>> --- a/arm/timer.c
> >>>> +++ b/arm/timer.c
> >>>> @@ -242,9 +242,11 @@ static void test_timer(struct timer_info *info)
> >>>>  	/* Test TVAL and IRQ trigger */
> >>>>  	info->irq_received =3D false;
> >>>>  	info->write_tval(read_sysreg(cntfrq_el0) / 100);	/* 10 ms */
> >>>> +	local_irq_disable();
> >>>>  	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
> >>>>  	report_info("waiting for interrupt...");
> >>>>  	wfi();
> >>>> +	local_irq_enable();
> >>>>  	left =3D info->read_tval();
> >>>>  	report("interrupt received after TVAL/WFI", info->irq_received);
> >>>>  	report("timer has expired (%d)", left < 0, left);
> >>>> -- =

> >>>> 2.7.4
> >>>>
> >>> Reviewed-by: Andrew Jones <drjones@redhat.com>
> >>>
> >>> Thanks Alexandru. It now makes more sense to me that wfi wakes up on
> >>> an interrupt, even when interrupts are masked, as it's clearly to
> >>> avoid these types of races. I see we have the same type of race in
> >>> arm/gic.c. I'll try to get around to fixing that at some point, unless
> >>> somebody beats me to it :)
> >> Something like this? Tested with gicv3-ipi.
> >>
> >> diff --git a/arm/gic.c b/arm/gic.c
> >> index ed5642e74f70..f0bd5739842a 100644
> >> --- a/arm/gic.c
> >> +++ b/arm/gic.c
> >> @@ -220,12 +220,12 @@ static void ipi_enable(void)
> >> =A0#else
> >> =A0=A0=A0=A0=A0=A0=A0 install_irq_handler(EL1H_IRQ, ipi_handler);
> >> =A0#endif
> >> -=A0=A0=A0=A0=A0=A0 local_irq_enable();
> >> =A0}
> >> =A0
> >> =A0static void ipi_send(void)
> >> =A0{
> >> =A0=A0=A0=A0=A0=A0=A0 ipi_enable();
> >> +=A0=A0=A0=A0=A0=A0 local_irq_enable();
> >> =A0=A0=A0=A0=A0=A0=A0 wait_on_ready();
> >> =A0=A0=A0=A0=A0=A0=A0 ipi_test_self();
> >> =A0=A0=A0=A0=A0=A0=A0 ipi_test_smp();
> >> @@ -236,9 +236,13 @@ static void ipi_send(void)
> >> =A0static void ipi_recv(void)
> >> =A0{
> >> =A0=A0=A0=A0=A0=A0=A0 ipi_enable();
> >> +=A0=A0=A0=A0=A0=A0 local_irq_disable();
> >> =A0=A0=A0=A0=A0=A0=A0 cpumask_set_cpu(smp_processor_id(), &ready);
> >> -=A0=A0=A0=A0=A0=A0 while (1)
> >> +=A0=A0=A0=A0=A0=A0 while (1) {
> >> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 local_irq_disable();
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 wfi();
> >> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 local_irq_enable();
> >> +=A0=A0=A0=A0=A0=A0 }
> >> =A0}
> >> =A0
> >> =A0static void ipi_test(void *data __unused)
> > I'm not sure we need to worry about enabling/disabling interrupts around
> > the wfi, since we're just doing a tight loop on it. I think something l=
ike
> > this (untested), which is quite similar to your approach, should work
> >
> > diff --git a/arm/gic.c b/arm/gic.c
> > index ed5642e74f70..cdbb4134b0af 100644
> > --- a/arm/gic.c
> > +++ b/arm/gic.c
> > @@ -214,18 +214,19 @@ static void ipi_test_smp(void)
> >  =

> >  static void ipi_enable(void)
> >  {
> > +       local_irq_disable();
> >         gic_enable_defaults();
> >  #ifdef __arm__
> >         install_exception_handler(EXCPTN_IRQ, ipi_handler);
> >  #else
> >         install_irq_handler(EL1H_IRQ, ipi_handler);
> >  #endif
> > -       local_irq_enable();
> >  }
> >  =

> >  static void ipi_send(void)
> >  {
> >         ipi_enable();
> > +       local_irq_enable();
> >         wait_on_ready();
> >         ipi_test_self();
> >         ipi_test_smp();
> > @@ -237,6 +238,7 @@ static void ipi_recv(void)
> >  {
> >         ipi_enable();
> >         cpumask_set_cpu(smp_processor_id(), &ready);
> > +       local_irq_enable();
> >         while (1)
> >                 wfi();
> >  }
> >
> > What do you think?
> =

> I've been thinking about it and I think that the gic test is fine as it i=
s. The
> secondaries are already synchronized with the boot cpu via the ready mask=
, we
> don't care if the secondaries receive the IPIs before or after the wfi
> instruction, and they will end up blocked in wfi at the end of the test e=
ither
> way (because of the while(1) loop). Am I missing something?
>

You're right. Let's just leave it as is.

Thanks,
drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

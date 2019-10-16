Return-Path: <SRS0=103j=YJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED34ECE588
	for <kvmarm@archiver.kernel.org>; Wed, 16 Oct 2019 07:32:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1FD36217D6
	for <kvmarm@archiver.kernel.org>; Wed, 16 Oct 2019 07:32:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FD36217D6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A69A74A9CB;
	Wed, 16 Oct 2019 03:32:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D1ex2U5wGIKo; Wed, 16 Oct 2019 03:32:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A135C4A9A2;
	Wed, 16 Oct 2019 03:32:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75E634A98C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 03:32:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qqo-7yOGCdea for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Oct 2019 03:32:06 -0400 (EDT)
Received: from Galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 86F794A609
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 03:32:06 -0400 (EDT)
Received: from p5b06da22.dip0.t-ipconnect.de ([91.6.218.34] helo=nanos)
 by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
 (Exim 4.80) (envelope-from <tglx@linutronix.de>)
 id 1iKdmp-0007Pm-FE; Wed, 16 Oct 2019 09:31:59 +0200
Date: Wed, 16 Oct 2019 09:31:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5 4/6] psci: Add hvc call service for ptp_kvm.
In-Reply-To: <9641fbff-cfcd-4854-e0c9-0b97d44193ee@redhat.com>
Message-ID: <alpine.DEB.2.21.1910160929500.2518@nanos.tec.linutronix.de>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-5-jianyong.wu@arm.com>
 <9641fbff-cfcd-4854-e0c9-0b97d44193ee@redhat.com>
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
> On 15/10/19 12:48, Jianyong Wu wrote:
> > diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> > index 07e57a49d1e8..3597f1f27b10 100644
> > --- a/drivers/clocksource/arm_arch_timer.c
> > +++ b/drivers/clocksource/arm_arch_timer.c
> > @@ -1634,3 +1634,8 @@ static int __init arch_timer_acpi_init(struct acpi_table_header *table)
> >  }
> >  TIMER_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT, arch_timer_acpi_init);
> >  #endif
> > +
> > +bool is_arm_arch_counter(void *cs)
> > +{
> > +	return (struct clocksource *)cs == &clocksource_counter;
> > +}
> 
> As Thomas pointed out, any reason to have a void * here?
> 
> However, since he didn't like modifying the struct, here is an
> alternative idea:
> 
> 1) add a "struct clocksource*" argument to ktime_get_snapshot
> 
> 2) return -ENODEV if the argument is not NULL and is not the current
> clocksource
> 
> 3) move the implementation of the hypercall to
> drivers/clocksource/arm_arch_timer.c, so that it can call
> ktime_get_snapshot(&systime_snapshot, &clocksource_counter);

And then you implement a gazillion of those functions for every
arch/subarch which has a similar requirement. Pointless exercise.

Having the ID is trivial enough and the storage space is not really a
concern.

Thanks,

	tglx
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

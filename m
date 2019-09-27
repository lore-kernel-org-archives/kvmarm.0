Return-Path: <SRS0=2Aw4=XW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A615C4360C
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 12:55:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F0E6B217D9
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 12:55:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0E6B217D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 568044A726;
	Fri, 27 Sep 2019 08:55:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nGVsCufLBkf0; Fri, 27 Sep 2019 08:55:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AAF24A76C;
	Fri, 27 Sep 2019 08:55:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9DB94A723
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 08:55:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C5hS3eIWaizd for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Sep 2019 08:55:06 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC2844A718
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 08:55:06 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 04ADB1F58E;
 Fri, 27 Sep 2019 12:55:06 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AC7FA1001938;
 Fri, 27 Sep 2019 12:55:03 +0000 (UTC)
Date: Fri, 27 Sep 2019 14:55:01 +0200
From: Andrew Jones <drjones@redhat.com>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [kvm-unit-tests PATCH 1/6] arm: gic: check_acked: add test
 description
Message-ID: <20190927125501.4ikcg6mdrgolpeu6@kamzik.brq.redhat.com>
References: <20190927104227.253466-1-andre.przywara@arm.com>
 <20190927104227.253466-2-andre.przywara@arm.com>
 <20190927121845.wjes372uf2hhw2wz@kamzik.brq.redhat.com>
 <20190927134016.3d137629@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190927134016.3d137629@donnerap.cambridge.arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.30]); Fri, 27 Sep 2019 12:55:06 +0000 (UTC)
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Sep 27, 2019 at 01:40:16PM +0100, Andre Przywara wrote:
> On Fri, 27 Sep 2019 14:18:45 +0200
> Andrew Jones <drjones@redhat.com> wrote:
> 
> Hi,
> 
> > On Fri, Sep 27, 2019 at 11:42:22AM +0100, Andre Przywara wrote:
> > > At the moment the check_acked() IRQ helper function just prints a
> > > generic "Completed" or "Timed out" message, without given a more
> > > detailed test description.
> > > 
> > > To be able to tell the different IRQ tests apart, and also to allow
> > > re-using it more easily, add a "description" parameter string,
> > > which is prefixing the output line. This gives more information on what
> > > exactly was tested.
> > > 
> > > This also splits the variable output part of the line (duration of IRQ
> > > delivery) into a separate INFO: line, to not confuse testing frameworks.
> > > 
> > > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > > ---
> > >  arm/gic.c | 17 ++++++++++-------
> > >  1 file changed, 10 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/arm/gic.c b/arm/gic.c
> > > index ed5642e..6fd5e5e 100644
> > > --- a/arm/gic.c
> > > +++ b/arm/gic.c
> > > @@ -60,7 +60,7 @@ static void stats_reset(void)
> > >  	smp_wmb();
> > >  }
> > >  
> > > -static void check_acked(cpumask_t *mask)
> > > +static void check_acked(const char *testname, cpumask_t *mask)
> > >  {
> > >  	int missing = 0, extra = 0, unexpected = 0;
> > >  	int nr_pass, cpu, i;
> > > @@ -88,7 +88,9 @@ static void check_acked(cpumask_t *mask)
> > >  			}
> > >  		}
> > >  		if (nr_pass == nr_cpus) {
> > > -			report("Completed in %d ms", !bad, ++i * 100);
> > > +			report("%s", !bad, testname);
> > > +			if (i)
> > > +				report_info("took more than %d ms", i * 100);  
> > 
> > Any reason for dropping the '++'? Without it we don't account for the last
> > 100 ms.
> 
> Actually we expect the interrupt to either fire immediately, or to not fire at all (timeout). So the previous message of "Completed in 100 ms" was somewhat misleading, because this was just due to the mdelay(100) above, and the IRQ was most probably delivered before this delay loop even started.
> 
> I had "took less than ++i *100 ms" before (and can revert to that if you like), but then figured that filtering for the most common case (immediate delivery) is more useful.

OK, with that argument we can leave the '++' off.

Thanks,
drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

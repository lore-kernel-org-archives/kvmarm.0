Return-Path: <SRS0=2Aw4=XW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 136A9C4360C
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 12:40:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8BECD20673
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 12:40:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8BECD20673
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 051CD4A771;
	Fri, 27 Sep 2019 08:40:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a6CA7XhzPLM7; Fri, 27 Sep 2019 08:40:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A371D4A772;
	Fri, 27 Sep 2019 08:40:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EC074A770
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 08:40:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 96SwQg7cuTuf for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Sep 2019 08:40:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF3D54A70D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 08:40:19 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83C8B1000;
 Fri, 27 Sep 2019 05:40:19 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D06FF3F67D;
 Fri, 27 Sep 2019 05:40:18 -0700 (PDT)
Date: Fri, 27 Sep 2019 13:40:16 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 1/6] arm: gic: check_acked: add test
 description
Message-ID: <20190927134016.3d137629@donnerap.cambridge.arm.com>
In-Reply-To: <20190927121845.wjes372uf2hhw2wz@kamzik.brq.redhat.com>
References: <20190927104227.253466-1-andre.przywara@arm.com>
 <20190927104227.253466-2-andre.przywara@arm.com>
 <20190927121845.wjes372uf2hhw2wz@kamzik.brq.redhat.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
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

On Fri, 27 Sep 2019 14:18:45 +0200
Andrew Jones <drjones@redhat.com> wrote:

Hi,

> On Fri, Sep 27, 2019 at 11:42:22AM +0100, Andre Przywara wrote:
> > At the moment the check_acked() IRQ helper function just prints a
> > generic "Completed" or "Timed out" message, without given a more
> > detailed test description.
> > 
> > To be able to tell the different IRQ tests apart, and also to allow
> > re-using it more easily, add a "description" parameter string,
> > which is prefixing the output line. This gives more information on what
> > exactly was tested.
> > 
> > This also splits the variable output part of the line (duration of IRQ
> > delivery) into a separate INFO: line, to not confuse testing frameworks.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  arm/gic.c | 17 ++++++++++-------
> >  1 file changed, 10 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arm/gic.c b/arm/gic.c
> > index ed5642e..6fd5e5e 100644
> > --- a/arm/gic.c
> > +++ b/arm/gic.c
> > @@ -60,7 +60,7 @@ static void stats_reset(void)
> >  	smp_wmb();
> >  }
> >  
> > -static void check_acked(cpumask_t *mask)
> > +static void check_acked(const char *testname, cpumask_t *mask)
> >  {
> >  	int missing = 0, extra = 0, unexpected = 0;
> >  	int nr_pass, cpu, i;
> > @@ -88,7 +88,9 @@ static void check_acked(cpumask_t *mask)
> >  			}
> >  		}
> >  		if (nr_pass == nr_cpus) {
> > -			report("Completed in %d ms", !bad, ++i * 100);
> > +			report("%s", !bad, testname);
> > +			if (i)
> > +				report_info("took more than %d ms", i * 100);  
> 
> Any reason for dropping the '++'? Without it we don't account for the last
> 100 ms.

Actually we expect the interrupt to either fire immediately, or to not fire at all (timeout). So the previous message of "Completed in 100 ms" was somewhat misleading, because this was just due to the mdelay(100) above, and the IRQ was most probably delivered before this delay loop even started.

I had "took less than ++i *100 ms" before (and can revert to that if you like), but then figured that filtering for the most common case (immediate delivery) is more useful.

> 
> >  			return;
> >  		}
> >  	}
> > @@ -105,8 +107,9 @@ static void check_acked(cpumask_t *mask)
> >  		}
> >  	}
> >  
> > -	report("Timed-out (5s). ACKS: missing=%d extra=%d unexpected=%d",
> > -	       false, missing, extra, unexpected);
> > +	report("%s", false, testname);
> > +	report_info("Timed-out (5s). ACKS: missing=%d extra=%d unexpected=%d",
> > +		    missing, extra, unexpected);
> >  }
> >  
> >  static void check_spurious(void)
> > @@ -185,7 +188,7 @@ static void ipi_test_self(void)
> >  	cpumask_clear(&mask);
> >  	cpumask_set_cpu(smp_processor_id(), &mask);
> >  	gic->ipi.send_self();
> > -	check_acked(&mask);
> > +	check_acked("IPI to self", &mask);  
> 
> Could even do "IPI: self"
>               "IPI: directed"
>               "IPI: broadcast"
> 
> to improve parsibility

Indeed.

Thanks for having a look!

Cheers,
Andre.



> 
> >  	report_prefix_pop();
> >  }
> >  
> > @@ -200,7 +203,7 @@ static void ipi_test_smp(void)
> >  	for (i = smp_processor_id() & 1; i < nr_cpus; i += 2)
> >  		cpumask_clear_cpu(i, &mask);
> >  	gic_ipi_send_mask(IPI_IRQ, &mask);
> > -	check_acked(&mask);
> > +	check_acked("directed IPI", &mask);
> >  	report_prefix_pop();
> >  
> >  	report_prefix_push("broadcast");
> > @@ -208,7 +211,7 @@ static void ipi_test_smp(void)
> >  	cpumask_copy(&mask, &cpu_present_mask);
> >  	cpumask_clear_cpu(smp_processor_id(), &mask);
> >  	gic->ipi.send_broadcast();
> > -	check_acked(&mask);
> > +	check_acked("IPI broadcast", &mask);
> >  	report_prefix_pop();
> >  }
> >  
> > -- 
> > 2.17.1
> >  
> 
> Thanks,
> drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

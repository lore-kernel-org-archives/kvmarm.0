Return-Path: <SRS0=WrEh=O4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0426C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 18:50:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B5C260F93
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 18:50:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3B5C260F93
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EFAE4B104;
	Fri,  8 Oct 2021 14:50:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qPG5L6YQ8ktW; Fri,  8 Oct 2021 14:50:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF5F44B105;
	Fri,  8 Oct 2021 14:50:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E2FA4B0E6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 14:50:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vP6rHBy+okbw for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 14:50:18 -0400 (EDT)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6E3144B093
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 14:50:18 -0400 (EDT)
Received: by mail-pj1-f54.google.com with SMTP id
 d13-20020a17090ad3cd00b0019e746f7bd4so10035896pjw.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 11:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=0fpHrUPXlOA4fBSknvP83s+OLuwQQT7fukcrA9l/60o=;
 b=pBP5kSzEBUhhSjI4s+hr9Flwb4xtySPHX5jFps9CWgUlGPl5w2y0lvmbFzLUdoJW9F
 MxQ10BUoxO6yfwBAhfDJsBMXAvqBaRd8eV4m1+5G582aRqO/6N5xKQF1qvhK4JuklmKd
 TQgeYC3O8NF8VB6OIMHVNz0F/IiG/2HOIc7sgJA5xEnPnMy8dI3KRczGUffc1H8v+P3U
 Q+JTY32OQppDwXVR2PX3mQBMqcw9CBCSgB2jRDViWrvRcKubrLAZY3n6g4w29KNwESgF
 C6C2nH2NwwRke34cu2BjPgpKQKBs9QJPw0vlPd0WD4ibt82EiVjlQpcetxMdCTa61MCx
 9DTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=0fpHrUPXlOA4fBSknvP83s+OLuwQQT7fukcrA9l/60o=;
 b=FjFD2sbdl0oxpd/MLgztl/aIUW3hCn2tdOigt2kgEX6EeTElaWsg66EVOh8jEWVTZ+
 236h+rERcjDHaYdOLuPxuUSu6vcxpfoTuVpn+VZSY/KIMuYuiHYcy8J2Jqi1TcZPMRmR
 YOQS7RcrEEs5b9ceieXZrFGSiglkybsBsVzGTWiFul2HvNLL+2DTPCrq4clf5R0KjzN+
 xR4Du0+4oWaVbAjJqIJ1lNL3YFga+XUru6rf9aY500h3SulI+ytupy+4Idc0QhAUX5Fk
 ymE5mB2uLmsbxyijPzm/F6P6VktLf2zF1PV24DNLn+1brJJO9jGNzH5BQ+EEwxA41G5c
 bZgw==
X-Gm-Message-State: AOAM530QT+pzaoWWR6ui+uj5smD5F9McTfzfD7cOOofZjSSr7k0h0MOn
 jIX9YSvQ43kFZmndPH+uU4WxVhLek3alfg==
X-Google-Smtp-Source: ABdhPJyZJQOigiD5cwSMloJzspRTxApaIoBEilWJec15yjnQOhJRK5gGmYJsCizDmTe7k2omgRk7LQ==
X-Received: by 2002:a17:90a:353:: with SMTP id
 19mr13618303pjf.83.1633719017269; 
 Fri, 08 Oct 2021 11:50:17 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id a17sm99835pfd.54.2021.10.08.11.50.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 08 Oct 2021 11:50:16 -0700 (PDT)
Date: Fri, 8 Oct 2021 11:50:13 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: Add mmio_addr arg to arm/micro-bench
Message-ID: <YWCS5QB6QFeYeiJg@google.com>
References: <20211007183230.2637929-1-ricarkol@google.com>
 <20211008062855.3g34sxevl6w3gn6h@gator.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211008062855.3g34sxevl6w3gn6h@gator.home>
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

On Fri, Oct 08, 2021 at 08:28:55AM +0200, Andrew Jones wrote:
> On Thu, Oct 07, 2021 at 11:32:30AM -0700, Ricardo Koller wrote:
> > Add a command line arg to arm/micro-bench to set the mmio_addr to other
> > values besides the default QEMU one. Default to the QEMU value if no arg
> > is passed. Also, the <NUM> in mmio_addr=<NUM> can't be a hex.
> 
> I'll send this patch
> 
> diff --git a/lib/util.c b/lib/util.c
> index a90554138952..682ca2db09e6 100644
> --- a/lib/util.c
> +++ b/lib/util.c
> @@ -4,6 +4,7 @@
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
>  #include <libcflat.h>
> +#include <stdlib.h>
>  #include "util.h"
>  
>  int parse_keyval(char *s, long *val)
> @@ -14,6 +15,6 @@ int parse_keyval(char *s, long *val)
>         if (!p)
>                 return -1;
>  
> -       *val = atol(p+1);
> +       *val = strtol(p+1, NULL, 0);
>         return p - s;
>  }
> 
> 
> which ought to improve that.
> 

Nice! thanks, just sent a V2 that uses it.

> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arm/micro-bench.c | 33 +++++++++++++++++++++++++++------
> >  1 file changed, 27 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> > index 8e1d4ab..2c08813 100644
> > --- a/arm/micro-bench.c
> > +++ b/arm/micro-bench.c
> > @@ -19,16 +19,19 @@
> >   * This work is licensed under the terms of the GNU LGPL, version 2.
> >   */
> >  #include <libcflat.h>
> > +#include <util.h>
> >  #include <asm/gic.h>
> >  #include <asm/gic-v3-its.h>
> >  #include <asm/timer.h>
> >  
> > -#define NS_5_SECONDS (5 * 1000 * 1000 * 1000UL)
> > +#define NS_5_SECONDS		(5 * 1000 * 1000 * 1000UL)
> > +#define QEMU_MMIO_ADDR		0x0a000008
> >  
> >  static u32 cntfrq;
> >  
> >  static volatile bool irq_ready, irq_received;
> >  static int nr_ipi_received;
> > +static unsigned long mmio_addr = QEMU_MMIO_ADDR;
> >  
> >  static void *vgic_dist_base;
> >  static void (*write_eoir)(u32 irqstat);
> > @@ -278,12 +281,10 @@ static void *userspace_emulated_addr;
> >  static bool mmio_read_user_prep(void)
> >  {
> >  	/*
> > -	 * FIXME: Read device-id in virtio mmio here in order to
> > -	 * force an exit to userspace. This address needs to be
> > -	 * updated in the future if any relevant changes in QEMU
> > -	 * test-dev are made.
> 
> I think the FIXME is still relavent, even with the user given control over
> the address. The FIXME text could be improved though, because it's not
> clear what it's trying to say, which is
> 
>  /*
>   * FIXME: We need an MMIO address that we can safely read to test
>   * exits to userspace. Ideally, the test-dev would provide us this
>   * address (and one we could write to too), but until it does we
>   * use a virtio-mmio transport address. FIXME2: We should be getting
>   * this address (and the future test-dev address) from the devicetree,
>   * but so far we lazily hardcode it.
>   */
>

ACK

> > +	 * Read device-id in virtio mmio here in order to
> > +	 * force an exit to userspace.
> >  	 */
> > -	userspace_emulated_addr = (void*)ioremap(0x0a000008, sizeof(u32));
> > +	userspace_emulated_addr = (void *)ioremap(mmio_addr, sizeof(u32));
> >  	return true;
> >  }
> >  
> > @@ -378,10 +379,30 @@ static void loop_test(struct exit_test *test)
> >  		test->name, total_ns.ns, total_ns.ns_frac, avg_ns.ns, avg_ns.ns_frac);
> >  }
> >  
> > +static void parse_args(int argc, char **argv)
> > +{
> > +	int i, len;
> > +	long val;
> > +
> > +	for (i = 0; i < argc; ++i) {
>                  ^ should be 1, since we know argv[0] is prognam
> 

ACK

> > +		len = parse_keyval(argv[i], &val);
> > +		if (len == -1)
> > +			continue;
> > +
> > +		argv[i][len] = '\0';
> 
> Not nice to write to the global args, especially when we're not yet sure
> if this arg is the one we care about.
> 

ACK, fixing that.

> > +		if (strcmp(argv[i], "mmio-addr") == 0) {
> 
> Can use strncmp to avoid the not nice args write,
> 
>  strncmp(argv[i], "mmio-addr", len)
> 

ACK, will use strncmp instead.

> > +			mmio_addr = val;
> > +			report_info("found mmio_addr=0x%lx", mmio_addr);
> > +		}
> > +	}
> > +}
> > +
> >  int main(int argc, char **argv)
> >  {
> >  	int i;
> >  
> > +	parse_args(argc, argv);
> > +
> >  	if (!test_init())
> >  		return 1;
> >  
> > -- 
> > 2.33.0.882.g93a45727a2-goog
> >
> 
> Thanks,
> drew 
> 

Thanks,
Ricardo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

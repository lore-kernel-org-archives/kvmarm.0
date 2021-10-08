Return-Path: <SRS0=WrEh=O4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C2DC433EF
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 06:29:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3CBF860FF2
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 06:29:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3CBF860FF2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 882324B0E6;
	Fri,  8 Oct 2021 02:29:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ft2gFHV05YNp; Fri,  8 Oct 2021 02:29:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 232204B0ED;
	Fri,  8 Oct 2021 02:29:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C56184B0D6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 02:29:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SlZlbRkK+XvB for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 02:29:00 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89BF24B0D0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 02:29:00 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633674540;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=66bdpyzPAZfft1eFWrlXRX9Ag9oSCJ0WcnS1e0+91qA=;
 b=IsbWfz3wGI9zUWQiEL7Plf+tdjbPEmwEp8lTtTzUakn/hrIWE4gaCmk4C2NkZ1JYuKmIEL
 zO31mIdeKi027LOdHOVeTtZ7vpM/iJGjhN8hiwZGqXxsBmp4U0R0I5wMl00oCHN4yqi1dM
 pWP1el6Hm5oQLsy8y06XNZSN0seOxtc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-YW7t0enzNUGW7Kpz1MhF8A-1; Fri, 08 Oct 2021 02:28:58 -0400
X-MC-Unique: YW7t0enzNUGW7Kpz1MhF8A-1
Received: by mail-ed1-f69.google.com with SMTP id
 t28-20020a508d5c000000b003dad7fc5caeso8188981edt.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Oct 2021 23:28:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=66bdpyzPAZfft1eFWrlXRX9Ag9oSCJ0WcnS1e0+91qA=;
 b=f36rdYDr0DW2YhflzKAevzcHzqLbchl9/zYnRBeASbKuRjQl1YzUbID2BcSiSJRtY6
 PlF4W8mZW4ocB7p3YXwwklbw1ABJITlHHs6eeKWQxcmZiixzM+ocDG/fakAgHyc2hB/l
 32alT9USbqNHIKMyA+Qg3fQPsZcmYgpDNURh8aJiKT4P5BGfO2jjnh619GHUJaYIAPGX
 wvJoe0HGHgslM45cHE5ySF0kyZgIewOT1T5jQjCm7zkllOEn5IDrChS5rzp3+dy38QPg
 NWCag9P51XrS1YB8Ifiljrg1YyhCG7sTOOAhoh1BSey9YOgY/AiT2mNS/zSLuCfsMSEs
 mP4Q==
X-Gm-Message-State: AOAM530fsSFvWV4jBNOty2qptDd4IeIA/RcEj9WN2WrXxoI/RUoj3G+V
 zqMtEfU08YG8djun/lF066Hsi9Nv+UF3SeqDodBm/mx+3F65um2xAiQ4uxY4/ZbHDfNBX9srIoX
 Sxh6VYyyvBSILbhytYv1J5vhC
X-Received: by 2002:a17:906:1184:: with SMTP id
 n4mr1993364eja.87.1633674537435; 
 Thu, 07 Oct 2021 23:28:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJyExn0FhyzPo+C2Jqjvn16Uv3O8XDMg4nsVAS9tztBxtKjG/slYlHcTGscY/joHF7R/qWPA==
X-Received: by 2002:a17:906:1184:: with SMTP id
 n4mr1993350eja.87.1633674537256; 
 Thu, 07 Oct 2021 23:28:57 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id d25sm609109edt.51.2021.10.07.23.28.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 07 Oct 2021 23:28:56 -0700 (PDT)
Date: Fri, 8 Oct 2021 08:28:55 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: Add mmio_addr arg to arm/micro-bench
Message-ID: <20211008062855.3g34sxevl6w3gn6h@gator.home>
References: <20211007183230.2637929-1-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20211007183230.2637929-1-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
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

On Thu, Oct 07, 2021 at 11:32:30AM -0700, Ricardo Koller wrote:
> Add a command line arg to arm/micro-bench to set the mmio_addr to other
> values besides the default QEMU one. Default to the QEMU value if no arg
> is passed. Also, the <NUM> in mmio_addr=<NUM> can't be a hex.

I'll send this patch

diff --git a/lib/util.c b/lib/util.c
index a90554138952..682ca2db09e6 100644
--- a/lib/util.c
+++ b/lib/util.c
@@ -4,6 +4,7 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 #include <libcflat.h>
+#include <stdlib.h>
 #include "util.h"
 
 int parse_keyval(char *s, long *val)
@@ -14,6 +15,6 @@ int parse_keyval(char *s, long *val)
        if (!p)
                return -1;
 
-       *val = atol(p+1);
+       *val = strtol(p+1, NULL, 0);
        return p - s;
 }


which ought to improve that.

> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arm/micro-bench.c | 33 +++++++++++++++++++++++++++------
>  1 file changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 8e1d4ab..2c08813 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -19,16 +19,19 @@
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
>  #include <libcflat.h>
> +#include <util.h>
>  #include <asm/gic.h>
>  #include <asm/gic-v3-its.h>
>  #include <asm/timer.h>
>  
> -#define NS_5_SECONDS (5 * 1000 * 1000 * 1000UL)
> +#define NS_5_SECONDS		(5 * 1000 * 1000 * 1000UL)
> +#define QEMU_MMIO_ADDR		0x0a000008
>  
>  static u32 cntfrq;
>  
>  static volatile bool irq_ready, irq_received;
>  static int nr_ipi_received;
> +static unsigned long mmio_addr = QEMU_MMIO_ADDR;
>  
>  static void *vgic_dist_base;
>  static void (*write_eoir)(u32 irqstat);
> @@ -278,12 +281,10 @@ static void *userspace_emulated_addr;
>  static bool mmio_read_user_prep(void)
>  {
>  	/*
> -	 * FIXME: Read device-id in virtio mmio here in order to
> -	 * force an exit to userspace. This address needs to be
> -	 * updated in the future if any relevant changes in QEMU
> -	 * test-dev are made.

I think the FIXME is still relavent, even with the user given control over
the address. The FIXME text could be improved though, because it's not
clear what it's trying to say, which is

 /*
  * FIXME: We need an MMIO address that we can safely read to test
  * exits to userspace. Ideally, the test-dev would provide us this
  * address (and one we could write to too), but until it does we
  * use a virtio-mmio transport address. FIXME2: We should be getting
  * this address (and the future test-dev address) from the devicetree,
  * but so far we lazily hardcode it.
  */

> +	 * Read device-id in virtio mmio here in order to
> +	 * force an exit to userspace.
>  	 */
> -	userspace_emulated_addr = (void*)ioremap(0x0a000008, sizeof(u32));
> +	userspace_emulated_addr = (void *)ioremap(mmio_addr, sizeof(u32));
>  	return true;
>  }
>  
> @@ -378,10 +379,30 @@ static void loop_test(struct exit_test *test)
>  		test->name, total_ns.ns, total_ns.ns_frac, avg_ns.ns, avg_ns.ns_frac);
>  }
>  
> +static void parse_args(int argc, char **argv)
> +{
> +	int i, len;
> +	long val;
> +
> +	for (i = 0; i < argc; ++i) {
                 ^ should be 1, since we know argv[0] is prognam

> +		len = parse_keyval(argv[i], &val);
> +		if (len == -1)
> +			continue;
> +
> +		argv[i][len] = '\0';

Not nice to write to the global args, especially when we're not yet sure
if this arg is the one we care about.

> +		if (strcmp(argv[i], "mmio-addr") == 0) {

Can use strncmp to avoid the not nice args write,

 strncmp(argv[i], "mmio-addr", len)

> +			mmio_addr = val;
> +			report_info("found mmio_addr=0x%lx", mmio_addr);
> +		}
> +	}
> +}
> +
>  int main(int argc, char **argv)
>  {
>  	int i;
>  
> +	parse_args(argc, argv);
> +
>  	if (!test_init())
>  		return 1;
>  
> -- 
> 2.33.0.882.g93a45727a2-goog
>

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

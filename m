Return-Path: <SRS0=aM0J=O7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E5CC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 14:44:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 88E2160EB1
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 14:44:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 88E2160EB1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F14E749FB7;
	Mon, 11 Oct 2021 10:44:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3dT254wz3WmK; Mon, 11 Oct 2021 10:44:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CED9D4B0D7;
	Mon, 11 Oct 2021 10:44:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82DB84B089
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 10:44:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bp2AT5xtbSL5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Oct 2021 10:44:34 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3787249FB7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 10:44:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633963473;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=7Vj8W7APBY2fyggKtVX8y6tenS0g5ttledn1kYzTma0=;
 b=RhvqJL7pkJVx2PpAI4jaWzTCvgEioD/pcwfYR7b9woYch8FhIHIxVarTrQzLqwVSj7/yPM
 xR2w0u8k4w1WAKfXujXzX2UQC/nZXzkdastkpu22hNSTrj7zedkTNszSewz2hTfScf9zY1
 Ew40o2xT6iKEvtfD/b6boVNJZAHBKao=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-5MmgN94fMbqh8PfnkjY7GA-1; Mon, 11 Oct 2021 10:44:32 -0400
X-MC-Unique: 5MmgN94fMbqh8PfnkjY7GA-1
Received: by mail-wr1-f71.google.com with SMTP id
 r16-20020adfb1d0000000b00160bf8972ceso13472967wra.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 07:44:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=7Vj8W7APBY2fyggKtVX8y6tenS0g5ttledn1kYzTma0=;
 b=hrdY6i5q2rGiWbqr/Hh1YFiBBkZF4KroJm3DyotDpyMROZs728mT4PVFgQkXU2WEJ9
 RoAS6Fm371n9hzL7ribftgyMR4GmS2yTWeW0o+AZZ8Bs3t+kh/jRCqxeAemnscEW7dbO
 I9229r8ugISoZvN+eIk5djQ2197WghxtC0WwxB2H7KKOq9lVNo0lq76dRSZ1SwFTm700
 H3gH7tlcdo97vd/TeoEA/TYjWl99dVVx4hmGRSGOGHUom3ZNAtS+XaEYHw0wN5QfPU5y
 azcBomyheMq6XG4XRmQXL/W1pDmbM4OP+ixjzccQKjyLW0CBjPjOaFIdm9n4SnF+BTFg
 GBfw==
X-Gm-Message-State: AOAM5300JiK+8e/6hIPqdzVBt84EXcXF426dDoiwlylyUETBSNXPhc6w
 D3Xw5h1RRaLoMwtZPGvKZBBW7Nm98UkTpWEHFJJxl+rl25GCXTByElX53DvOcH76Z7+kOPsrqd3
 OE5BroTxWYtN7yzyIJVQjdCkn
X-Received: by 2002:a7b:cd90:: with SMTP id y16mr13094957wmj.146.1633963471456; 
 Mon, 11 Oct 2021 07:44:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmedNib3+ZpDnLKlxj3BpgqbufyGqCa7JQZrW0+0LhmbffbNezRzXKtVLjHQgbYRWhOqo6HA==
X-Received: by 2002:a7b:cd90:: with SMTP id y16mr13094938wmj.146.1633963471217; 
 Mon, 11 Oct 2021 07:44:31 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id k17sm7884449wrc.93.2021.10.11.07.44.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 11 Oct 2021 07:44:30 -0700 (PDT)
Date: Mon, 11 Oct 2021 16:44:29 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [kvm-unit-tests PATCH v2] arm64: Add mmio_addr arg to
 arm/micro-bench
Message-ID: <20211011144429.26hn2tpeczbffwcs@gator>
References: <20211008174022.3028983-1-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20211008174022.3028983-1-ricarkol@google.com>
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

On Fri, Oct 08, 2021 at 10:40:22AM -0700, Ricardo Koller wrote:
> Add a command line arg to arm/micro-bench to set the mmio_addr to other
> values besides the default QEMU one. Default to the QEMU value if no arg
> is passed.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arm/micro-bench.c | 36 ++++++++++++++++++++++++++++++------
>  1 file changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 8e1d4ab..c731b1d 100644
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
> @@ -278,12 +281,14 @@ static void *userspace_emulated_addr;
>  static bool mmio_read_user_prep(void)
>  {
>  	/*
> -	 * FIXME: Read device-id in virtio mmio here in order to
> -	 * force an exit to userspace. This address needs to be
> -	 * updated in the future if any relevant changes in QEMU
> -	 * test-dev are made.
> +	 * FIXME: We need an MMIO address that we can safely read to test
> +	 * exits to userspace. Ideally, the test-dev would provide us this
> +	 * address (and one we could write to too), but until it does we
> +	 * use a virtio-mmio transport address. FIXME2: We should be getting
> +	 * this address (and the future test-dev address) from the devicetree,
> +	 * but so far we lazily hardcode it.
>  	 */
> -	userspace_emulated_addr = (void*)ioremap(0x0a000008, sizeof(u32));
> +	userspace_emulated_addr = (void *)ioremap(mmio_addr, sizeof(u32));
>  	return true;
>  }
>  
> @@ -378,10 +383,29 @@ static void loop_test(struct exit_test *test)
>  		test->name, total_ns.ns, total_ns.ns_frac, avg_ns.ns, avg_ns.ns_frac);
>  }
>  
> +static void parse_args(int argc, char **argv)
> +{
> +	int i, len;
> +	long val;
> +
> +	for (i = 1; i < argc; ++i) {
> +		len = parse_keyval(argv[i], &val);
> +		if (len == -1)
> +			continue;
> +
> +		if (strncmp(argv[i], "mmio-addr", len) == 0) {
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

Pushed

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

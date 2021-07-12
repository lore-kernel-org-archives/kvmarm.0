Return-Path: <SRS0=bTo6=ME=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E03C07E99
	for <kvmarm@archiver.kernel.org>; Mon, 12 Jul 2021 16:52:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 69B1D60FF3
	for <kvmarm@archiver.kernel.org>; Mon, 12 Jul 2021 16:52:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69B1D60FF3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEC5F406E0;
	Mon, 12 Jul 2021 12:52:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dFv7URP73UMf; Mon, 12 Jul 2021 12:52:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE0F240821;
	Mon, 12 Jul 2021 12:52:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 143B7406E0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jul 2021 12:52:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 594cCGpiH7DA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Jul 2021 12:52:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DD65404F8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jul 2021 12:52:29 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C5A51FB;
 Mon, 12 Jul 2021 09:52:29 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1437A3F694;
 Mon, 12 Jul 2021 09:52:26 -0700 (PDT)
Date: Mon, 12 Jul 2021 17:51:55 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 1/5] lib: arm: Print test exit status
 on exit if chr-testdev is not available
Message-ID: <20210712175155.7c6f8dc3@slackpad.fritz.box>
In-Reply-To: <20210702163122.96110-2-alexandru.elisei@arm.com>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-2-alexandru.elisei@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Cc: lvivier@redhat.com, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
 kvm@vger.kernel.org, david@redhat.com, maz@kernel.org, cohuck@redhat.com,
 thuth@redhat.com, kvm-ppc@vger.kernel.org, vivek.gautam@arm.com,
 pbonzini@redhat.com, imbrenda@linux.ibm.com, kvmarm@lists.cs.columbia.edu
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

On Fri,  2 Jul 2021 17:31:18 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> The arm64 tests can be run under kvmtool, which doesn't emulate a
> chr-testdev device. In preparation for adding run script support for
> kvmtool, print the test exit status so the scripts can pick it up and
> correctly mark the test as pass or fail.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/chr-testdev.h |  1 +
>  lib/arm/io.c      | 10 +++++++++-
>  lib/chr-testdev.c |  5 +++++
>  3 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/chr-testdev.h b/lib/chr-testdev.h
> index ffd9a851aa9b..09b4b424670e 100644
> --- a/lib/chr-testdev.h
> +++ b/lib/chr-testdev.h
> @@ -11,4 +11,5 @@
>   */
>  extern void chr_testdev_init(void);
>  extern void chr_testdev_exit(int code);
> +extern bool chr_testdev_available(void);
>  #endif
> diff --git a/lib/arm/io.c b/lib/arm/io.c
> index 343e10822263..9e62b571a91b 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -125,7 +125,15 @@ extern void halt(int code);
>  
>  void exit(int code)
>  {
> -	chr_testdev_exit(code);
> +	if (chr_testdev_available()) {
> +		chr_testdev_exit(code);
> +	} else {
> +		/*
> +		 * Print the test return code in the format used by chr-testdev
> +		 * so the runner script can parse it.
> +		 */
> +		printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);

It's more me being clueless here rather than a problem, but where does
this "EXIT: STATUS" line come from? In lib/chr-testdev.c I see "%dq",
so it this coming from QEMU (but I couldn't find it in there)?

But anyways the patch looks good and matches what PPC and s390 do.

Cheers,
Andre


> +	}
>  	psci_system_off();
>  	halt(code);
>  	__builtin_unreachable();
> diff --git a/lib/chr-testdev.c b/lib/chr-testdev.c
> index b3c641a833fe..301e73a6c064 100644
> --- a/lib/chr-testdev.c
> +++ b/lib/chr-testdev.c
> @@ -68,3 +68,8 @@ void chr_testdev_init(void)
>  	in_vq = vqs[0];
>  	out_vq = vqs[1];
>  }
> +
> +bool chr_testdev_available(void)
> +{
> +	return vcon != NULL;
> +}

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

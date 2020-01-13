Return-Path: <SRS0=vgt5=3C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 729EFC3F68F
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jan 2020 18:41:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E3B1A20CC7
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jan 2020 18:41:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d6kdelts"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E3B1A20CC7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23BBA4AE94;
	Mon, 13 Jan 2020 13:41:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K+ONv9QOAxjL; Mon, 13 Jan 2020 13:41:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 151DD4AEE1;
	Mon, 13 Jan 2020 13:41:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CEEB4AE94
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jan 2020 13:41:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SzlU4t-t0iXm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jan 2020 13:41:08 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D7314ACF4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jan 2020 13:41:08 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1578940868;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=lzsvSn3vm+wBgNMJ8PeCKY2Pk4Acog14y15igrOXvYo=;
 b=d6kdeltsXvLjomuQzyokg6k14UrxjQmgfnPK3L7BjHh4UYhnM5F6UPbURpyodEqmL+dr9L
 bcJE2OsbLDjWeSCLmlt7COnyDdPtWw90kuHtLaSB8O3XcGGExteL5PbYkUObYhybHIUTT5
 ky1UxweChrNp+5V2Zz7Su/EQOTCvq+4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-5paUai2PN46VI-a3bWSjqw-1; Mon, 13 Jan 2020 13:41:05 -0500
X-MC-Unique: 5paUai2PN46VI-a3bWSjqw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E10E9907607;
 Mon, 13 Jan 2020 18:41:02 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3302A19C5B;
 Mon, 13 Jan 2020 18:40:57 +0000 (UTC)
Date: Mon, 13 Jan 2020 19:40:55 +0100
From: Andrew Jones <drjones@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 14/16] arm/run: Allow Migration tests
Message-ID: <20200113184055.tu3qqpsc72xqfw6t@kamzik.brq.redhat.com>
References: <20200110145412.14937-1-eric.auger@redhat.com>
 <20200110145412.14937-15-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200110145412.14937-15-eric.auger@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: thuth@redhat.com, kvm@vger.kernel.org, maz@kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

On Fri, Jan 10, 2020 at 03:54:10PM +0100, Eric Auger wrote:
> Let's link getchar.o to use puts and getchar from the
> tests.
> 
> Then allow tests belonging to the migration group to
> trigger the migration from the test code by putting
> "migrate" into the uart. Then the code can wait for the
> migration completion by using getchar().
> 
> The __getchar implement is minimalist as it just reads the
> data register. It is just meant to read the single character
> emitted at the end of the migration by the runner script.
> 
> It is not meant to read more data (FIFOs are not enabled).
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  arm/Makefile.common |  2 +-
>  arm/run             |  2 +-
>  lib/arm/io.c        | 13 +++++++++++++
>  3 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index 7cc0f04..327f112 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -32,7 +32,7 @@ CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib
>  asm-offsets = lib/$(ARCH)/asm-offsets.h
>  include $(SRCDIR)/scripts/asm-offsets.mak
>  
> -cflatobjs += lib/util.o
> +cflatobjs += lib/util.o lib/getchar.o
>  cflatobjs += lib/alloc_phys.o
>  cflatobjs += lib/alloc_page.o
>  cflatobjs += lib/vmalloc.o
> diff --git a/arm/run b/arm/run
> index 277db9b..a390ca5 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -61,6 +61,6 @@ fi
>  M+=",accel=$ACCEL"
>  command="$qemu -nodefaults $M -cpu $processor $chr_testdev $pci_testdev"
>  command+=" -display none -serial stdio -kernel"
> -command="$(timeout_cmd) $command"
> +command="$(migration_cmd) $(timeout_cmd) $command"
>  
>  run_qemu $command "$@"
> diff --git a/lib/arm/io.c b/lib/arm/io.c
> index 99fd315..ed89e19 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -87,6 +87,19 @@ void puts(const char *s)
>  	spin_unlock(&uart_lock);
>  }
>  
> +/*
> + * Minimalist implementation for migration completion detection.
> + * Needs to be improved for more advanced Rx cases

Please add that QEMU supports reading a maximum of 16 characters in
this minimal mode. We could even add a counter and then assert if
we try to read 16 or more.

> + */
> +int __getchar(void)
> +{
> +	int ret;
> +
> +	ret = readb(uart0_base);
> +	if (!ret)
> +		return -1;
> +	return ret;
> +}

What about taking the lock?

>  
>  /*
>   * Defining halt to take 'code' as an argument guarantees that it will
> -- 
> 2.20.1
> 

What do you think of the __getchar below?

Thanks,
drew


diff --git a/lib/arm/io.c b/lib/arm/io.c
index 99fd31560084..77beb331d6b2 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -79,6 +79,31 @@ void io_init(void)
 	chr_testdev_init();
 }
 
+static int ____getchar(void)
+{
+	int c;
+
+	spin_lock(&uart_lock);
+	c = readb(uart0_base);
+	spin_unlock(&uart_lock);
+
+	return c ?: -1;
+}
+
+int __getchar(void)
+{
+	static int count;
+	int c;
+
+	if ((c = ____getchar()) != -1)
+		++count;
+
+	/* Without special UART initialization we can only read 16 characters. */
+	assert(count < 16);
+
+	return c;
+}
+
 void puts(const char *s)
 {
 	spin_lock(&uart_lock);

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

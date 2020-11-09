Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF7A9C388F7
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 16:00:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 25B2A2067B
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 16:00:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O0+4Oaey"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25B2A2067B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A40B4B4F3;
	Mon,  9 Nov 2020 11:00:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TdkcmXmUIdMY; Mon,  9 Nov 2020 11:00:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05DE64B57B;
	Mon,  9 Nov 2020 11:00:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54D294B3F5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 11:00:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8wefn2V5d1R5 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 11:00:35 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F59E4B38C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 11:00:35 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604937635;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=9x2i9FhJ3FEdl0CuO9z7pB7e6HrDm7nT6Y35uAhzyuQ=;
 b=O0+4OaeyJOskKl+h9wU7b/zOcD1FipYPKjI+vWsCGtjXNJ0m8luA3OTORReISqrYABdCBh
 8F8euwjs2R771aNjK0cF3JCLpXgPGySDO9FGHdX1TZzh1QoUKAvmSuXdbpfkSX5Oz3jUXI
 jdqdzG3yupUtZLAu/otXxScM7rgPqGc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-ji2dBrXoOme5FwMdlQUdSQ-1; Mon, 09 Nov 2020 11:00:31 -0500
X-MC-Unique: ji2dBrXoOme5FwMdlQUdSQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5430CCE642;
 Mon,  9 Nov 2020 16:00:30 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.176])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E219E5DA82;
 Mon,  9 Nov 2020 16:00:23 +0000 (UTC)
Date: Mon, 9 Nov 2020 17:00:20 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH] arm: Fix compilation errors
Message-ID: <20201109160020.atjjurkh3mwteork@kamzik.brq.redhat.com>
References: <20201105135936.55088-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201105135936.55088-1-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 Alexander Graf <graf@amazon.com>, pbonzini@redhat.com,
 kvmarm@lists.cs.columbia.edu
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

On Thu, Nov 05, 2020 at 01:59:36PM +0000, Alexandru Elisei wrote:
> Using arm-none-eabi-gcc triggers the following compilation errors:
> 
> $ ./configure --arch=arm --cross-prefix=arm-none-eabi-
> $ make clean
> $ make -j8
> [..]
> arm/pmu.c: In function 'pmu_probe':
> arm/pmu.c:1000:47: error: format '%c' expects argument of type 'int', but argument 3 has type 'long unsigned int' [-Werror=format=]
>  1000 |  report_info("PMU implementer/ID code: %#x(\"%c\")/%#x",
>       |                                              ~^
>       |                                               |
>       |                                               int
>       |                                              %ld
>  1001 |       (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK,
>  1002 |       ((pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK) ? : ' ',
>       |       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                                                            |
>       |                                                            long unsigned int
> [..]
> arm/gic.c: In function 'test_byte_access':
> arm/gic.c:460:31: error: format '%x' expects argument of type 'unsigned int', but argument 2 has type 'u32' {aka 'long unsigned int'} [-Werror=format=]
>   460 |   report_info("byte 1 of 0x%08x => 0x%02x", pattern & mask, reg);
>       |                            ~~~^             ~~~~~~~~~~~~~~
>       |                               |                     |
>       |                               unsigned int          u32 {aka long unsigned int}
>       |                            %08lx
> [..]
> arm/pl031.c: In function 'irq_handler':
> arm/pl031.c:153:39: error: format '%d' expects argument of type 'int', but argument 2 has type 'u32' {aka 'long unsigned int'} [-Werror=format=]
>   153 |   report_info("Unexpected interrupt: %d\n", irqnr);
>       |                                      ~^     ~~~~~
>       |                                       |     |
>       |                                       int   u32 {aka long unsigned int}
>       |                                      %ld
> 
> The errors were observed when using arm-none-eabi-gcc versions 10.2.0 and
> 9.2.0. No errors were found when using arm-linux-gnu-gcc version 10.2.1.
> 
> Replace the offending printf format specifiers with their PRIxxx
> counterparts defined by C99 and available in libcflat.h. Also remove the
> unnecessary call to get_pmcr() in pmu_probe(), as the pmcr value hasn't
> changed since initialization.
> 
> Nu functional changes intended by this patch.

  ^ I've fixed this typo

> 
> CC: Eric Auger <eric.auger@redhat.com>
> CC: Alexander Graf <graf@amazon.com>
> CC: Andre Przywara <andre.przywara@arm.com>
> CC: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---

Thanks Alex. I've queued this for the next Arm pull request.

> 
> Andre suggested that we drop using gcc's stdint.h and implement our own to avoid
> such errors in the future. The distro that I'm using on my desktop doesn't have
> the arm-linux-gnu toolchain in the default repos, so I figured I should send
> this fix to get things compiling again.
> 
> I have no preference for, or against, implementing our own types.h header file.
> I imagine it's not going to be easy to change the code to use it (possibly for
> all architectures), and it should be worth it in the long run.

I'd keep gcc's stdint.h for now, but it might be a good idea to post a
travis patch that tests compiling with your preferred toolchain.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=VJ1f=EF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54DF4C4741F
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 15:30:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AAC0820791
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 15:30:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZsXSn4+/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AAC0820791
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 232514B572;
	Fri, 30 Oct 2020 11:30:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ISYdUgToty1U; Fri, 30 Oct 2020 11:29:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05E4D4B548;
	Fri, 30 Oct 2020 11:29:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A09624B560
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 11:29:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XYhokLRixyWY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Oct 2020 11:29:56 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCEA74B502
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 11:29:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604071796;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=b0W7QMQzHbpC22wVvKeK+U/xelKfT4N9vj2I59aNa5o=;
 b=ZsXSn4+/xq2FaAYLEfbqgX27cr89Xz1E+eXX5rHbTrZtqlX6cVoYAobOAovrZhsFiA7Eo/
 5KQSzXArauK/bYL+T3Dcrrh9DWQEHQMKI6/1PIy/QXg7375IR/tO6Fem/GeDzbBe7ipuP6
 h1hkKPwGR1ktxoy9ZuIVuP5KPvwDLrQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-FbkiMC06OMK-jBPuqMqXUQ-1; Fri, 30 Oct 2020 11:29:53 -0400
X-MC-Unique: FbkiMC06OMK-jBPuqMqXUQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F8BA8F62E4;
 Fri, 30 Oct 2020 15:29:52 +0000 (UTC)
Received: from [10.36.114.125] (ovpn-114-125.ams2.redhat.com [10.36.114.125])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1074F55772;
 Fri, 30 Oct 2020 15:29:50 +0000 (UTC)
From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests RFC PATCH v2 2/5] lib/{bitops, alloc_page}.h: Add
 missing headers
To: Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20201027171944.13933-1-alexandru.elisei@arm.com>
 <20201027171944.13933-3-alexandru.elisei@arm.com>
Message-ID: <8474ba0a-ab47-9b83-5f30-0418cf6f0b24@redhat.com>
Date: Fri, 30 Oct 2020 16:29:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201027171944.13933-3-alexandru.elisei@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: pbonzini@redhat.com
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

Hi Alexandru,
On 10/27/20 6:19 PM, Alexandru Elisei wrote:
> bitops.h uses the 'bool' and 'size_t' types, but doesn't include the
> stddef.h and stdbool.h headers, where the types are defined. This can cause
> the following error when compiling:
> 
> In file included from arm/new-test.c:9:
> /path/to/kvm-unit-tests/lib/bitops.h:77:15: error: unknown type name 'bool'
>    77 | static inline bool is_power_of_2(unsigned long n)
>       |               ^~~~
> /path/to/kvm-unit-tests/lib/bitops.h:82:38: error: unknown type name 'size_t'
>    82 | static inline unsigned int get_order(size_t size)
>       |                                      ^~~~~~
> /path/to/kvm-unit-tests/lib/bitops.h:24:1: note: 'size_t' is defined in header '<stddef.h>'; did you forget to '#include <stddef.h>'?
>    23 | #include <asm/bitops.h>
>   +++ |+#include <stddef.h>
>    24 |
> make: *** [<builtin>: arm/new-test.o] Error 1
> 
> The same errors were observed when including alloc_page.h. Fix both files
> by including stddef.h and stdbool.h.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/alloc_page.h | 2 ++
>  lib/bitops.h     | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/lib/alloc_page.h b/lib/alloc_page.h
> index 88540d1def06..182862c43363 100644
> --- a/lib/alloc_page.h
> +++ b/lib/alloc_page.h
> @@ -4,6 +4,8 @@
>   * This is a simple allocator that provides contiguous physical addresses
>   * with byte granularity.
>   */
> +#include <stdbool.h>
> +#include <stddef.h>
nit: you may move those includes after the #ifndef ALLOC_PAGE_H as it is
usually done.
>  
>  #ifndef ALLOC_PAGE_H
>  #define ALLOC_PAGE_H 1
> diff --git a/lib/bitops.h b/lib/bitops.h
> index 308aa86514a8..5aeea0b998b1 100644
> --- a/lib/bitops.h
> +++ b/lib/bitops.h
> @@ -1,5 +1,7 @@
>  #ifndef _BITOPS_H_
>  #define _BITOPS_H_
> +#include <stdbool.h>
> +#include <stddef.h>
>  
>  /*
>   * Adapted from
> 
Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=fzUG=OL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF2B7C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 07:19:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 37457610CA
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 07:19:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 37457610CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A90454079A;
	Tue, 21 Sep 2021 03:19:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1lPqh0DYpEiY; Tue, 21 Sep 2021 03:19:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92BBF49F5D;
	Tue, 21 Sep 2021 03:19:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFA0249F5D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 03:19:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7PdEb5QyOZcV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 03:19:10 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 039604079A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 03:19:09 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632208749;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=vd756pui6KEC1UbpIk1pqZxBtMYyZDzhx0CEGUXBa3g=;
 b=gCm1hs7A7EefNvG2JMRJntP6f/kJ408bMnGSt+dRoC4l1Z4Jjpn04Ne+y662hsULpWHlox
 G0b1bsOjiYwYOrhrXnnooWlDYWllvo4rcjQiAMn+rkLpMOsB1ssI2fbmu8uwNBAoqLrsHo
 8Xh3SxvfP6hwwFrGUiWb6XqZtBApC18=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-eLjnAkPFMG6fywSiEWFyIA-1; Tue, 21 Sep 2021 03:19:08 -0400
X-MC-Unique: eLjnAkPFMG6fywSiEWFyIA-1
Received: by mail-ed1-f71.google.com with SMTP id
 j6-20020aa7de86000000b003d4ddaf2bf9so18099691edv.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 00:19:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=vd756pui6KEC1UbpIk1pqZxBtMYyZDzhx0CEGUXBa3g=;
 b=1ieWtLCU6kRT0ZGgVtmuehBVCiYrtd9MM6mskJOVrRykZKDLMLHu+YMFSd+A1EO83B
 ANToeucp8ebtYMbIjUceXY6hpIc6vgEOtf2sjVhc3lOfKdyDvZvGU9J3lOVUvmRndikV
 d0Hkk+U4I9OGJvv0RY7A+6DgQqtmNTI643/PJvLTB8RGcTO4cVkkfZ0vj8TjA9Vs8L+K
 UsxSStZAGVcQVuN/EbEOI3dkCQZ/BH4sffObPwseK6sFJwTu/aWM/39Ka0go+JYGpIt1
 eTTPqZL0vuJNGj97zTAMXsIpI5tF9P+1sY13OuCnMFYgrGzKL+xQNHtM9M5gOQPlKjxJ
 ivwA==
X-Gm-Message-State: AOAM531TCFzuctJ2kU5uf5psJemtuQbUhGzl+fF1dWuVfsfhd5YvU1T+
 UDf29F4OUjQwYy51j4fi+zR1Iy1VD7E5H328cetSLjy9eHUv6n+0uAHvZB8+ZjVLXLydpmPD2aD
 OPZu05Dy025Gr9KYliUs5mWnP
X-Received: by 2002:a17:906:39cb:: with SMTP id
 i11mr34466637eje.168.1632208747404; 
 Tue, 21 Sep 2021 00:19:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwI0XEybugInECb0uqIoYxDJZLvNGiDElvnIwBQk5rwedeJJwROpvlubrUCVRAUxU8E/axZ8g==
X-Received: by 2002:a17:906:39cb:: with SMTP id
 i11mr34466616eje.168.1632208747251; 
 Tue, 21 Sep 2021 00:19:07 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id bf28sm8078306edb.45.2021.09.21.00.19.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 21 Sep 2021 00:19:06 -0700 (PDT)
Date: Tue, 21 Sep 2021 09:19:04 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 2/2] selftests: KVM: Fix 'asm-operand-width' warnings in
 steal_time.c
Message-ID: <20210921071904.5irj3q5yiquoubj2@gator.home>
References: <20210921010120.1256762-1-oupton@google.com>
 <20210921010120.1256762-3-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210921010120.1256762-3-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

On Tue, Sep 21, 2021 at 01:01:20AM +0000, Oliver Upton wrote:
> Building steal_time.c for arm64 with clang throws the following:
> 
> >> steal_time.c:130:22: error: value size does not match register size specified by the constraint and modifier [-Werror,-Wasm-operand-widths]
>           : "=r" (ret) : "r" (func), "r" (arg) :
>                               ^
> >> steal_time.c:130:34: error: value size does not match register size specified by the constraint and modifier [-Werror,-Wasm-operand-widths]
>           : "=r" (ret) : "r" (func), "r" (arg) :
>                                           ^
> 
> Silence by casting operands to 64 bits.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/steal_time.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
> index ecec30865a74..eb75b31122c5 100644
> --- a/tools/testing/selftests/kvm/steal_time.c
> +++ b/tools/testing/selftests/kvm/steal_time.c
> @@ -127,7 +127,7 @@ static int64_t smccc(uint32_t func, uint32_t arg)
>  		"mov	x1, %2\n"
>  		"hvc	#0\n"
>  		"mov	%0, x0\n"
> -	: "=r" (ret) : "r" (func), "r" (arg) :
> +	: "=r" (ret) : "r" ((uint64_t)func), "r" ((uint64_t)arg) :

Actually, I think I'd rather fix this smccc implementation to match the
spec, which I think should be done like this

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index ecec30865a74..7da957259ce4 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -118,12 +118,12 @@ struct st_time {
        uint64_t st_time;
 };
 
-static int64_t smccc(uint32_t func, uint32_t arg)
+static int64_t smccc(uint32_t func, uint64_t arg)
 {
        unsigned long ret;
 
        asm volatile(
-               "mov    x0, %1\n"
+               "mov    w0, %w1\n"
                "mov    x1, %2\n"
                "hvc    #0\n"
                "mov    %0, x0\n"


Thanks,
drew

>  	  "x0", "x1", "x2", "x3");
>  
>  	return ret;
> -- 
> 2.33.0.464.g1972c5931b-goog
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=b97j=N4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B7FC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  6 Sep 2021 06:52:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F8C760F43
	for <kvmarm@archiver.kernel.org>; Mon,  6 Sep 2021 06:52:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9F8C760F43
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A2734B249;
	Mon,  6 Sep 2021 02:52:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fschBR+sWAPU; Mon,  6 Sep 2021 02:52:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B8E34B278;
	Mon,  6 Sep 2021 02:52:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A14E4B249
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Sep 2021 02:52:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IKC2qSAxhjJN for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Sep 2021 02:52:53 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84DB04B1D5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Sep 2021 02:52:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1630911173;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=xVvCRd48vUd0s8Qhx9wbKeg3e9TGn2LMc3TD1wv0YoU=;
 b=DL2lPzPktfdlY+hz1b+p++yiLUjmPUXLiby6HHqaMOt1+mwMrn3VqNnut2IHJLQpDb4k5S
 FNKdE0dlbcVFoFqge8ARlzBIZf8dF26qrI/6I2pP71hDHZ+FotRwnN7qQv2/D7UqyBy5ez
 KjEdwWcj5raoBCT9ns90ITCFfplY+j0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-8waTainPOyeN9nahk9Ffgw-1; Mon, 06 Sep 2021 02:52:51 -0400
X-MC-Unique: 8waTainPOyeN9nahk9Ffgw-1
Received: by mail-ed1-f69.google.com with SMTP id
 y10-20020a056402270a00b003c8adc4d40cso3061603edd.15
 for <kvmarm@lists.cs.columbia.edu>; Sun, 05 Sep 2021 23:52:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xVvCRd48vUd0s8Qhx9wbKeg3e9TGn2LMc3TD1wv0YoU=;
 b=hS18POKSwD0/mJ+g5riGUwppmXi3fcgyLELOdjZSgCmhvLO+l51x5TB0+LTpLB1hEo
 faFk6e+dk9j9xD5kdFZugJ+lJAvdlm6NmpMjzltVeng8dzAXKyyi8+cglmj7KY3nJzTc
 YQn+0+gnUOeLX0xNoR3Q4VToFTpjRxgLD9Xs2nb0vwVIStGds05NLh7S9pgxyAiijBg/
 5sNrTcq/Ryyk8y7eDAzttAeHXwDJbSWLN89FCHRM0LV/NidIPHkV/nM9d+12sBPXHTLB
 gLaWolNLYkG7y0W7yaYucOBfI1Kwm8keaHnZFw/JZ/YJfD/6kMpJvG5vt5+9B7ZCTGuW
 sv8A==
X-Gm-Message-State: AOAM531/nYar8vEBz1sSBe72bIS1QHi7CJJFK+RE4K/X121S5e76Ov7p
 oHtsV19IDYthYHCCZPdPgOajE8N9cUxiPqSkQWJZXYiOrTSS1/TRX4XYoXI4LpLzUwCxViYTwQM
 Ds9fBaimm0JOCBGrI8K+2x3hd
X-Received: by 2002:a05:6402:51c9:: with SMTP id
 r9mr12121008edd.65.1630911170674; 
 Sun, 05 Sep 2021 23:52:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvQtH1K6Jl6Ax+4IS9Z1Fidzt0mgTUD+ttCz7gh3k7oW9A0+M0GapKR8goF6sKX6zAEV6ZVg==
X-Received: by 2002:a05:6402:51c9:: with SMTP id
 r9mr12120993edd.65.1630911170505; 
 Sun, 05 Sep 2021 23:52:50 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id e3sm3315715ejr.118.2021.09.05.23.52.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 05 Sep 2021 23:52:50 -0700 (PDT)
Date: Mon, 6 Sep 2021 08:52:48 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: build the memslot tests for arm64
Message-ID: <20210906065248.c57sluz2764ixe7u@gator.home>
References: <20210903231154.25091-1-ricarkol@google.com>
 <20210903231154.25091-3-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20210903231154.25091-3-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, maciej.szmigiero@oracle.com,
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

On Fri, Sep 03, 2021 at 04:11:54PM -0700, Ricardo Koller wrote:
> Add memslot_perf_test and memslot_modification_stress_test to the list
> of aarch64 selftests.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 5832f510a16c..e6e88575c40b 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -84,6 +84,8 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
>  TEST_GEN_PROGS_x86_64 += steal_time
>  TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
>  
> +TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
> +TEST_GEN_PROGS_aarch64 += memslot_perf_test
>  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
>  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
>  TEST_GEN_PROGS_aarch64 += aarch64/vgic_init

These tests need to be added below the aarch64/* tests and in alphabetical
order.

Thanks,
drew

> -- 
> 2.33.0.153.gba50c8fa24-goog
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

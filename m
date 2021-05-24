Return-Path: <SRS0=3L6A=KT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF0BC04FF3
	for <kvmarm@archiver.kernel.org>; Mon, 24 May 2021 12:15:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 63C9C610C8
	for <kvmarm@archiver.kernel.org>; Mon, 24 May 2021 12:15:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 63C9C610C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2AE94B178;
	Mon, 24 May 2021 08:15:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rQFTiu860CJL; Mon, 24 May 2021 08:14:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A15554B0EA;
	Mon, 24 May 2021 08:14:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 901594B0EA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 May 2021 08:14:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XLW2pmTZOUyJ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 May 2021 08:14:57 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82DD84B0E3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 May 2021 08:14:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1621858497;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=6VKp1xofZhd/+4tFw02ffWXfwhEtsPe1dVI9fvTfESM=;
 b=JiY7ZDWxMr8dtjKbS5Us40gqWc2IjcgupS8KRIayqY3FiwvefA2l7u2YVERLZSP0ri3sQq
 Yghe/2nu0YRy2WH2H0CfaDBY3qEdy45J8RJkPbhM3GyS8FLsGBeR9BYCI6xYBJjV1sj3/R
 DxUTGiLo1cjBMfqQ8oMfPkhphCOTlw8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-qeZ-RUO2PHi9C6XyQ00oGg-1; Mon, 24 May 2021 08:14:55 -0400
X-MC-Unique: qeZ-RUO2PHi9C6XyQ00oGg-1
Received: by mail-ed1-f71.google.com with SMTP id
 cn20-20020a0564020cb4b029038d0b0e183fso15502991edb.22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 May 2021 05:14:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=6VKp1xofZhd/+4tFw02ffWXfwhEtsPe1dVI9fvTfESM=;
 b=Fd1iU7WSpl4SM6HpSPVxAcuM3gsOjmLpz/c3Ut2UaFvxf7PYXEqa+LIR2//5qj2RaQ
 5mcHOj6n6OdQVUY1oRdgBsqylM4sV7uSFikMaZVftjISHX3RMNxTdlRrtMlfTsFHwmer
 FiSLK8nVdvZp0/7vaf/5ENz0ys7gK7eJvpowJTliiheigQHh3776St+bZLSKlO8SiFb6
 8GvV3BsVd8jRRNYHNFwFZUJltJbRlr6+BznzCGTVEtT9utaD+yNeQeJg7hzB3LbpsBhv
 0CgdNOU6yKjo4C3s51imAOU6Ylzp1JC+098uUwWy9mjGb5BfcWWjDcIC3FLLN1fO9i+4
 Lmwg==
X-Gm-Message-State: AOAM532DTrz8Lz1j5O72JkEHOJg8/qjrJZ63QUGRniLAjtwJ3Sh0D77R
 nTEKXUOGD02JKU7alp7/8GnhXTUP8zWVWOl/tPo6e7xqx/KOY84unt5jB9RsWnqmgc0Pr3oXKQ/
 9NAUwonSHVpaSluKL5Ag9ijUn
X-Received: by 2002:a17:906:eb10:: with SMTP id
 mb16mr23517149ejb.209.1621858494184; 
 Mon, 24 May 2021 05:14:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxk+0l0weiOvjyF1AGyYnOo0VG6EnvzCZZGMcmr4Lu8V//fg+XmZ0li0ktd4Yb2OtYjlpR1Ug==
X-Received: by 2002:a17:906:eb10:: with SMTP id
 mb16mr23517131ejb.209.1621858494009; 
 Mon, 24 May 2021 05:14:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id v23sm9221937edx.31.2021.05.24.05.14.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 24 May 2021 05:14:53 -0700 (PDT)
Subject: Re: [PATCH v2 0/5] KVM: selftests: arm64 exception handling and debug
 test
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20210430232408.2707420-1-ricarkol@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <362e360d-40c3-1e50-18b0-a2f4297d3746@redhat.com>
Date: Mon, 24 May 2021 14:14:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210430232408.2707420-1-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: maz@kernel.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 01/05/21 01:24, Ricardo Koller wrote:
> Hi,
> 
> These patches add a debug exception test in aarch64 KVM selftests while
> also adding basic exception handling support.
> 
> The structure of the exception handling is based on its x86 counterpart.
> Tests use the same calls to initialize exception handling and both
> architectures allow tests to override the handler for a particular
> vector, or (vector, ec) for synchronous exceptions in the arm64 case.
> 
> The debug test is similar to x86_64/debug_regs, except that the x86 one
> controls the debugging from outside the VM. This proposed arm64 test
> controls and handles debug exceptions from the inside.
> 
> Thanks,
> Ricardo

Marc, are you going to queue this in your tree?

Thanks,

Paolo

> v1 -> v2:
> 
> Addressed comments from Andrew and Marc (thank you very much):
> - rename vm_handle_exception in all tests.
> - introduce UCALL_UNHANDLED in x86 first.
> - move GUEST_ASSERT_EQ to common utils header.
> - handle sync and other exceptions separately: use two tables (like
>    kvm-unit-tests).
> - add two separate functions for installing sync versus other exceptions
> - changes in handlers.S: use the same layout as user_pt_regs, treat the
>    EL1t vectors as invalid, refactor the vector table creation to not use
>    manual numbering, add comments, remove LR from the stored registers.
> - changes in debug-exceptions.c: remove unused headers, use the common
>    GUEST_ASSERT_EQ, use vcpu_run instead of _vcpu_run.
> - changes in processor.h: write_sysreg with support for xzr, replace EL1
>    with current in macro names, define ESR_EC_MASK as ESR_EC_NUM-1.
> 
> Ricardo Koller (5):
>    KVM: selftests: Rename vm_handle_exception
>    KVM: selftests: Introduce UCALL_UNHANDLED for unhandled vector
>      reporting
>    KVM: selftests: Move GUEST_ASSERT_EQ to utils header
>    KVM: selftests: Add exception handling support for aarch64
>    KVM: selftests: Add aarch64/debug-exceptions test
> 
>   tools/testing/selftests/kvm/.gitignore        |   1 +
>   tools/testing/selftests/kvm/Makefile          |   3 +-
>   .../selftests/kvm/aarch64/debug-exceptions.c  | 244 ++++++++++++++++++
>   .../selftests/kvm/include/aarch64/processor.h |  90 ++++++-
>   .../testing/selftests/kvm/include/kvm_util.h  |  10 +
>   .../selftests/kvm/include/x86_64/processor.h  |   4 +-
>   .../selftests/kvm/lib/aarch64/handlers.S      | 130 ++++++++++
>   .../selftests/kvm/lib/aarch64/processor.c     | 124 +++++++++
>   .../selftests/kvm/lib/x86_64/processor.c      |  19 +-
>   .../selftests/kvm/x86_64/kvm_pv_test.c        |   2 +-
>   .../selftests/kvm/x86_64/tsc_msrs_test.c      |   9 -
>   .../kvm/x86_64/userspace_msr_exit_test.c      |   8 +-
>   .../selftests/kvm/x86_64/xapic_ipi_test.c     |   2 +-
>   13 files changed, 611 insertions(+), 35 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/aarch64/debug-exceptions.c
>   create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

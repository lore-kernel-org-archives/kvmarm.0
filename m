Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB7CBC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 16:43:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 47C9861100
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 16:43:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 47C9861100
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC6C84B086;
	Fri, 24 Sep 2021 12:43:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ClEHecM+Gk9I; Fri, 24 Sep 2021 12:43:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2DB44B0B8;
	Fri, 24 Sep 2021 12:43:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B1964B086
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 12:43:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8YcTSJqXjfeZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 12:43:46 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D3BA4AC78
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 12:43:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632501826;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=2ayfGdTCBtiqgPiJaceqi1OGn0mBN7usLeKdCjt4NNw=;
 b=Et+NPhxDCb8MUTmqcsquftp1YII6Fa+6JCf0GTd5UaSoz3z5EPl1NakfokzDae4veSg+Zn
 LYQIAuu56YTpo1yfOt9G1Ba8UIsMWrD4+pw/OuHQfc8q2yrQoUL/Icl6iLCEIwKeHC0iXM
 wYMMHvenrhWwxVdM2tDStpE/wLyRIu4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-8g6u_IW_OhWyeYmTfUgecg-1; Fri, 24 Sep 2021 12:43:45 -0400
X-MC-Unique: 8g6u_IW_OhWyeYmTfUgecg-1
Received: by mail-ed1-f72.google.com with SMTP id
 ec14-20020a0564020d4e00b003cf5630c190so10952988edb.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 09:43:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=2ayfGdTCBtiqgPiJaceqi1OGn0mBN7usLeKdCjt4NNw=;
 b=gz905W4JctQCn6PEHeR0Rar2QqMHP0FnCsbXrrqIxeWVFFwkUgrok0teiDxz8QasIk
 +tTBDVnHl8LPgQA4bhUtQnaFpq7BgJOXHaAI+Z6b/2Sy4gKN1SO56SCAq8Z7ud0+1Y+E
 /INmkCELsWlwUyuK33mOKrAnzBJB6oeNhrVUkgwxs7eWv8FxxK+eS6GdCF1utK+RQ3A+
 9YGhu6pDlO46PY4suQVwehrY571hx6p2xVK6ergdhMPu/Vybay7PJxD5xmd7DL9LlxX8
 GwAy5u1+f6LjrZS3ritexT4bohzLcXt/L5A/kYxDyM+Yv9HQsdd6ZERLyxO7DUT0P/64
 NFcg==
X-Gm-Message-State: AOAM533PDrkDqZ6LtLyJNcCFuggyCHeySMCMKf6ZPkyNvnjS0POnLolQ
 Pk9dVA7KY6XBn8ZCVQFC75scIKN1yyPtzea8WLTDHqityYBS7R9DzCsZKKP0A9yZ41pbC3kdVRy
 8EP+Yra29hjGLDG2UcHLftfpQ
X-Received: by 2002:a17:906:1484:: with SMTP id
 x4mr12169314ejc.72.1632501823824; 
 Fri, 24 Sep 2021 09:43:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+Yv3J2nN2uB7FgYH5ZxA5zjL/80SexpKmfVSqrcDD0N8I1bfA249hQ9sfmzeDIxBqSeb+tQ==
X-Received: by 2002:a17:906:1484:: with SMTP id
 x4mr12169286ejc.72.1632501823639; 
 Fri, 24 Sep 2021 09:43:43 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id z3sm5228855eju.34.2021.09.24.09.43.42
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 24 Sep 2021 09:43:43 -0700 (PDT)
Message-ID: <9982d53a-8160-d7f7-09eb-ea640f99136b@redhat.com>
Date: Fri, 24 Sep 2021 18:43:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 0/9] selftests: KVM: Test offset-based counter controls
To: Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20210916181555.973085-1-oupton@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210916181555.973085-1-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

On 16/09/21 20:15, Oliver Upton wrote:
> This series implements new tests for the x86 and arm64 counter migration
> changes that I've mailed out. These are sent separately as a dependent
> change since there are cross-arch dependencies here.
> 
> Patch 1 yanks the pvclock headers into the tools/ directory so we can
> make use of them within a KVM selftest guest.
> 
> Patch 2 tests the new capabilities of the KVM_*_CLOCK ioctls, ensuring
> that the kernel accounts for elapsed time when restoring the KVM clock.
> 
> Patches 3-4 add some device attribute helpers and clean up some mistakes
> in the assertions thereof.
> 
> Patch 5 implements a test for the KVM_VCPU_TSC_OFFSET attribute,
> asserting that manipulation of the offset results in correct TSC values
> within the guest.
> 
> Patch 6 adds basic arm64 support to the counter offset test, checking
> that the virtual counter-timer offset works correctly. Patch 7 does the
> same for the physical counter-timer offset.
> 
> Patch 8 adds a benchmark for physical counter offsetting, since most
> implementations available right now will rely on emulation.
> 
> Lastly, patch 9 extends the get-reg-list test to check for
> KVM_REG_ARM_TIMER_OFFSET if userspace opts-in to the kernel capability.
> 
> This series applies cleanly to 5.15-rc1
> 
> Tests were ran against the respective architecture changes on the
> following systems:
> 
>   - Haswell (x86)
>   - Ampere Mt. Jade (non-ECV, nVHE and VHE)

Queued patches 1-5, thanks.

Paolo

> v7: https://lore.kernel.org/r/20210816001246.3067312-1-oupton@google.com
> 
> v7 -> v8:
>   - Rebased to 5.15-rc1
>   - Dropped helper for checking if reg exists in reg list (no longer
>     necessary)
>   - Test and enable KVM_CAP_ARM_VTIMER_OFFSET
>   - Add get-reg-list changes
> 
> Oliver Upton (9):
>    tools: arch: x86: pull in pvclock headers
>    selftests: KVM: Add test for KVM_{GET,SET}_CLOCK
>    selftests: KVM: Fix kvm device helper ioctl assertions
>    selftests: KVM: Add helpers for vCPU device attributes
>    selftests: KVM: Introduce system counter offset test
>    selftests: KVM: Add support for aarch64 to system_counter_offset_test
>    selftests: KVM: Test physical counter offsetting
>    selftests: KVM: Add counter emulation benchmark
>    selftests: KVM: Test vtimer offset reg in get-reg-list
> 
>   tools/arch/x86/include/asm/pvclock-abi.h      |  48 ++++
>   tools/arch/x86/include/asm/pvclock.h          | 103 ++++++++
>   tools/testing/selftests/kvm/.gitignore        |   3 +
>   tools/testing/selftests/kvm/Makefile          |   4 +
>   .../kvm/aarch64/counter_emulation_benchmark.c | 207 ++++++++++++++++
>   .../selftests/kvm/aarch64/get-reg-list.c      |  42 ++++
>   .../selftests/kvm/include/aarch64/processor.h |  24 ++
>   .../testing/selftests/kvm/include/kvm_util.h  |  11 +
>   tools/testing/selftests/kvm/lib/kvm_util.c    |  44 +++-
>   .../kvm/system_counter_offset_test.c          | 220 ++++++++++++++++++
>   .../selftests/kvm/x86_64/kvm_clock_test.c     | 204 ++++++++++++++++
>   11 files changed, 907 insertions(+), 3 deletions(-)
>   create mode 100644 tools/arch/x86/include/asm/pvclock-abi.h
>   create mode 100644 tools/arch/x86/include/asm/pvclock.h
>   create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
>   create mode 100644 tools/testing/selftests/kvm/system_counter_offset_test.c
>   create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C52EAC47088
	for <kvmarm@archiver.kernel.org>; Fri,  2 Dec 2022 18:23:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B8B04B1B7;
	Fri,  2 Dec 2022 13:23:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s3j8nk3ZE27f; Fri,  2 Dec 2022 13:23:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BAAB4B256;
	Fri,  2 Dec 2022 13:23:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01C6E4B1B7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 13:23:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rk7Yn3knXCD4 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Dec 2022 13:23:19 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8517740683
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 13:23:19 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1670005399;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=P84c+bfPSykX3YQiadeIHsZVz2UzMEmnzobF5uJ1pLI=;
 b=F3oCjZEBQzV7H8/VkSQCzuQDvABRqY7t6sxrmNJ1lzwP7zEb9EMGfnG8j5kTnqdQ7XT5Ob
 03KuEDVYIrmxpbqkKCzGRASJ2Y2V3+Zx0FeX1h0BgERi10c3e+pe9FsrNoSh6jViW3kMNm
 QrilHS8XIcrWZpp6PPa+2KD2EUZ3ZkU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-97-Y8k9-o1KMrm9L-QI9Lj0JA-1; Fri, 02 Dec 2022 13:23:17 -0500
X-MC-Unique: Y8k9-o1KMrm9L-QI9Lj0JA-1
Received: by mail-wm1-f70.google.com with SMTP id
 v188-20020a1cacc5000000b003cf76c4ae66so4484891wme.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Dec 2022 10:23:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=P84c+bfPSykX3YQiadeIHsZVz2UzMEmnzobF5uJ1pLI=;
 b=xhlV74QRz3rlQwCInMR/O6zHKj5wyWD8jJMKM/0hyzwg5E4fHYzhyv5N5Bl+4ppkrn
 7hCGd34OwWUPcYfRcOKYO6pdPNK4fYyNT/kEuR6/J0H6//c169AB8J77IquyRGzkM8YH
 jQdZIuJoltaZnw9jE1Xo3aaoeaMf2JbHqO6Rwoe6thWapTMBvBd9FDU3w18z19CrrHVo
 HuPrpjKuXEtCjDNFD+Aqh1SgPq6+mTmy659XEHXbVPlCrhFl/h2h1FSQcsjtMPkzm8B0
 E52lWhuiuccO0ZBSxGpe40ZcurCsrz6pt7zHsvZldHJeJKKGuIjxVGkgLyoeYdQc5RUr
 IxjQ==
X-Gm-Message-State: ANoB5pkuGFBvSxCpMhX/bbeWtoCVvjkwbnuUC6+roKL+7VGb/j+p8nIi
 ISlXzCsq1wgCy52l5JaT36UKJgtvEp4c5YgS5maomTnrCVnaJcLsKXnZPoKQO20S/p8OUrKiEhu
 pMV5KKraf8iwoLmr10rHSTf9j
X-Received: by 2002:a05:600c:414d:b0:3d0:878e:6fed with SMTP id
 h13-20020a05600c414d00b003d0878e6fedmr2684218wmm.150.1670005396555; 
 Fri, 02 Dec 2022 10:23:16 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4ce8iPe1eG0lC8Hd032B6FnUH8YAiPhO90ACJEtpgSAmnJV++j8/y61/KMnH5cyF16TO0mfw==
X-Received: by 2002:a05:600c:414d:b0:3d0:878e:6fed with SMTP id
 h13-20020a05600c414d00b003d0878e6fedmr2684196wmm.150.1670005396315; 
 Fri, 02 Dec 2022 10:23:16 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 z10-20020a05600c0a0a00b003c70191f267sm15411305wmp.39.2022.12.02.10.23.14
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 02 Dec 2022 10:23:15 -0800 (PST)
Message-ID: <7c6ac714-7ed8-0106-2e45-d1ca3055f39b@redhat.com>
Date: Fri, 2 Dec 2022 19:23:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 0/9] tools: Make {clear,set}_bit() atomic for reals
To: Sean Christopherson <seanjc@google.com>, Yury Norov
 <yury.norov@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Marc Zyngier <maz@kernel.org>
References: <20221119013450.2643007-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221119013450.2643007-1-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
 kvmarm@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 11/19/22 02:34, Sean Christopherson wrote:
> For obvious reasons I'd like to route the this through Paolo's tree.
> In theory, taking just patch 5 through tip would work, but creating a
> topic branch seems like the way to go, though maybe I'm being overly
> paranoid.  The current tip/perf/core doesn't have any conflicts, nor does
> it have new set_bit() or clear_bit() users.
> 
>   
> Code sitting in kvm/queue for 6.2 adds functionality that relies on
> clear_bit() being an atomic operation.  Unfortunately, despite being
> implemented in atomic.h (among other strong hits that they should be
> atomic), clear_bit() and set_bit() aren't actually atomic (and of course
> I realized this _just_ after everything got queued up).
> 
> Move current tools/ users of clear_bit() and set_bit() to the
> double-underscore versions (which tools/ already provides and documents
> as being non-atomic), and then implement clear_bit() and set_bit() as
> actual atomics to fix the KVM selftests bug.
> 
> Perf and KVM are the only affected users.  NVDIMM also has test code
> in tools/, but that builds against the kernel proper.  The KVM code is
> well tested and fully audited.  The perf code is lightly tested; if I
> understand the build system, it's probably not even fully compile tested.
> 
> Patches 1 and 2 are completely unrelated and are fixes for patches
> sitting in kvm/queue.  Paolo, they can be squashed if you want to rewrite
> history.
> 
> Patch 3 fixes a hilarious collision in a KVM ARM selftest that will arise
> when clear_bit() is converted to an atomic.
> 
> Patch 4 changes clear_bit() and set_bit() to take an "unsigned long"
> instead of an "int" so that patches 5-6 aren't accompanied by functional
> changes.  I.e. if something in perf is somehow relying on "bit" being a
> signed int, failures will bisect to patch 4 and not to the
> supposed-to-be-a-nop conversion to __clear_bit() and __set_bit().
> 
> Patch 5-9 switch perf+KVM and complete the conversion.
> 
> Applies on:
>    
>    git://git.kernel.org/pub/scm/virt/kvm/kvm.git queue

Queued, thanks Namhyung for the ACK!

Paolo

> 
> Sean Christopherson (9):
>    KVM: selftests: Add rdmsr_from_l2() implementation in Hyper-V eVMCS
>      test
>    KVM: selftests: Remove unused "vcpu" param to fix build error
>    KVM: arm64: selftests: Enable single-step without a "full" ucall()
>    tools: Take @bit as an "unsigned long" in {clear,set}_bit() helpers
>    perf tools: Use dedicated non-atomic clear/set bit helpers
>    KVM: selftests: Use non-atomic clear/set bit helpers in KVM tests
>    tools: Drop conflicting non-atomic test_and_{clear,set}_bit() helpers
>    tools: Drop "atomic_" prefix from atomic test_and_set_bit()
>    tools: KVM: selftests: Convert clear/set_bit() to actual atomics
> 
>   tools/arch/x86/include/asm/atomic.h           |  6 +++-
>   tools/include/asm-generic/atomic-gcc.h        | 13 ++++++-
>   tools/include/asm-generic/bitops/atomic.h     | 15 ++++----
>   tools/include/linux/bitmap.h                  | 34 -------------------
>   tools/perf/bench/find-bit-bench.c             |  2 +-
>   tools/perf/builtin-c2c.c                      |  6 ++--
>   tools/perf/builtin-kwork.c                    |  6 ++--
>   tools/perf/builtin-record.c                   |  6 ++--
>   tools/perf/builtin-sched.c                    |  2 +-
>   tools/perf/tests/bitmap.c                     |  2 +-
>   tools/perf/tests/mem2node.c                   |  2 +-
>   tools/perf/util/affinity.c                    |  4 +--
>   tools/perf/util/header.c                      |  8 ++---
>   tools/perf/util/mmap.c                        |  6 ++--
>   tools/perf/util/pmu.c                         |  2 +-
>   .../util/scripting-engines/trace-event-perl.c |  2 +-
>   .../scripting-engines/trace-event-python.c    |  2 +-
>   tools/perf/util/session.c                     |  2 +-
>   tools/perf/util/svghelper.c                   |  2 +-
>   .../selftests/kvm/aarch64/arch_timer.c        |  2 +-
>   .../selftests/kvm/aarch64/debug-exceptions.c  | 21 ++++++------
>   tools/testing/selftests/kvm/dirty_log_test.c  | 34 +++++++++----------
>   .../selftests/kvm/include/ucall_common.h      |  8 +++++
>   .../testing/selftests/kvm/lib/ucall_common.c  |  2 +-
>   .../selftests/kvm/x86_64/hyperv_evmcs.c       | 13 +++++--
>   .../selftests/kvm/x86_64/hyperv_svm_test.c    |  4 +--
>   .../selftests/kvm/x86_64/hyperv_tlb_flush.c   |  2 +-
>   27 files changed, 102 insertions(+), 106 deletions(-)
> 
> 
> base-commit: 3321eef4acb51c303f0598d8a8493ca58528a054

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

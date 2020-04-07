Return-Path: <SRS0=lOre=5X=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C307C2BA80
	for <kvmarm@archiver.kernel.org>; Tue,  7 Apr 2020 15:29:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 863FD20747
	for <kvmarm@archiver.kernel.org>; Tue,  7 Apr 2020 15:29:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UGk5Jp/4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 863FD20747
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10FAC4B0B1;
	Tue,  7 Apr 2020 11:29:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id edjZoPYCH4Hu; Tue,  7 Apr 2020 11:29:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5B534A3A5;
	Tue,  7 Apr 2020 11:29:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85C504A3A5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Apr 2020 11:29:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cXt53PCVJXIJ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Apr 2020 11:29:04 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBCC14A2E5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Apr 2020 11:29:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586273344;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=gWUgiHbWY/VnfopGlKJ1NN6MztUwrlxf5LJ/Y6VfBgk=;
 b=UGk5Jp/4OCuE6qmQQRyfo+AJuSmW8jt9v2O5BNAN0UyXLJ7okBohb/R7GsYIe3KtoH9vik
 d2IsTMB265prQ1LQG0EGN3JiwLS5OhKwGKYn/f+JlFGfnSdXwy66jZMsKw3wQj9BOTGJAt
 NdaeiPHakJ7ngPYYaic6xp9yDi72JRk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-Ok6GT1JMMka1LMzOY1kuXw-1; Tue, 07 Apr 2020 11:29:00 -0400
X-MC-Unique: Ok6GT1JMMka1LMzOY1kuXw-1
Received: by mail-wr1-f72.google.com with SMTP id q9so2102767wrw.22
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Apr 2020 08:29:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=gWUgiHbWY/VnfopGlKJ1NN6MztUwrlxf5LJ/Y6VfBgk=;
 b=gALcIadKAy9UWyo+5yIvmI9/39hlHtwa+r6In6Qy5lkNY0hNf75Zdt4sKVhNae6u2X
 s1Tzx2+jU9WYpJr4sTdsVkGKD5NUWbHIqfRtX+810+8qGK2rcLmvWNPkFyIRf6kMH1RP
 jAsZQRhVPqYI3aCxf1QhSNzNqZI9Pb0TAt14Q1eOOiRws6Fpn8XtTyOl8cMXXDN6/oXs
 yYchxhH/hPV8GPK1steYv5SrDrdX+BUQVcoCNnC7gYaxQDRNlyoxBvbKFk/Nea3mB9r0
 QMuZMby2BqY+9e+6hmx5+6uo5fhODE8mQfKwyEhaELH9ew75AIq+KSiUk+LbpKXONTFP
 oGSw==
X-Gm-Message-State: AGi0PubgPLx6x8SdrMAo0KUAoj49LpIXueX3AkeA5T/NilD5vwhyMEiP
 nwRoQOy3HPeDA0XJ414eBWeMHZSLjldzHOM6GU/FJkpVEKLmFJuyYiblwTrPIVgnL24vm1gW17O
 1yHBmaJWgebP7SzvGcWQFS9zC
X-Received: by 2002:a05:600c:2245:: with SMTP id
 a5mr3021907wmm.171.1586273339158; 
 Tue, 07 Apr 2020 08:28:59 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ6y8t8M3s1o6shGbsX5ew9e/lrfMaPAL2jkphzu7vRXsUNpkEsjGyjrf4I5PbpdhL9PhsXFQ==
X-Received: by 2002:a05:600c:2245:: with SMTP id
 a5mr3021882wmm.171.1586273338848; 
 Tue, 07 Apr 2020 08:28:58 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
 by smtp.gmail.com with ESMTPSA id v9sm21292630wrv.18.2020.04.07.08.28.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 07 Apr 2020 08:28:58 -0700 (PDT)
Subject: Re: [PULL kvm-unit-tests 00/39] arm/arm64: The old and new
To: Andrew Jones <drjones@redhat.com>
References: <20200404143731.208138-1-drjones@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bbee7fe4-56c2-f958-cddc-18b92d8e4380@redhat.com>
Date: Tue, 7 Apr 2020 17:28:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200404143731.208138-1-drjones@redhat.com>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On 04/04/20 16:36, Andrew Jones wrote:
> Hi Paolo,
> 
> This pull request is a repost of an older request, plus it
> contains Eric's new PMU and ITS tests.
> 
> Thanks,
> drew
> 
> 
> The following changes since commit ce27fa2c7cd4d07859a9a2e81c7ff641897818d1:
> 
>   x86: vmx: skip atomic_switch_overflow_msrs_test on bare metal (2020-03-31 13:01:41 -0400)
> 
> are available in the Git repository at:
> 
>   https://github.com/rhdrjones/kvm-unit-tests arm/queue
> 
> for you to fetch changes up to de582149c5be94a1ff7d3d8ee3526501b26c7f03:
> 
>   arm/arm64: ITS: pending table migration test (2020-04-04 10:03:44 +0200)
> 
> ----------------------------------------------------------------
> Alexandru Elisei (10):
>       Makefile: Use no-stack-protector compiler options
>       arm/arm64: psci: Don't run C code without stack or vectors
>       arm64: timer: Add ISB after register writes
>       arm64: timer: Add ISB before reading the counter value
>       arm64: timer: Make irq_received volatile
>       arm64: timer: EOIR the interrupt after masking the timer
>       arm64: timer: Wait for the GIC to sample timer interrupt state
>       arm64: timer: Check the timer interrupt state
>       arm64: timer: Test behavior when timer disabled or masked
>       arm/arm64: Perform dcache clean + invalidate after turning MMU off
> 
> Andrew Jones (2):
>       arm64: timer: Speed up gic-timer-state check
>       arm64: Provide read/write_sysreg_s
> 
> Eric Auger (24):
>       arm: pmu: Let pmu tests take a sub-test parameter
>       arm: pmu: Don't check PMCR.IMP anymore
>       arm: pmu: Add a pmu struct
>       arm: pmu: Introduce defines for PMU versions
>       arm: pmu: Check Required Event Support
>       arm: pmu: Basic event counter Tests
>       arm: pmu: Test SW_INCR event count
>       arm: pmu: Test chained counters
>       arm: pmu: test 32-bit <-> 64-bit transitions
>       arm: gic: Introduce gic_irq_set_clr_enable() helper
>       arm: pmu: Test overflow interrupts
>       libcflat: Add other size defines
>       page_alloc: Introduce get_order()
>       arm/arm64: gic: Introduce setup_irq() helper
>       arm/arm64: gicv3: Add some re-distributor defines
>       arm/arm64: gicv3: Set the LPI config and pending tables
>       arm/arm64: ITS: Introspection tests
>       arm/arm64: ITS: its_enable_defaults
>       arm/arm64: ITS: Device and collection Initialization
>       arm/arm64: ITS: Commands
>       arm/arm64: ITS: INT functional tests
>       arm/run: Allow Migration tests
>       arm/arm64: ITS: migration tests
>       arm/arm64: ITS: pending table migration test
> 
> Zenghui Yu (3):
>       arm/arm64: gic: Move gic_state enumeration to asm/gic.h
>       arm64: timer: Use the proper RDist register name in GICv3
>       arm64: timer: Use existing helpers to access counter/timers
> 
>  Makefile                   |   4 +-
>  arm/Makefile.arm64         |   1 +
>  arm/Makefile.common        |   2 +-
>  arm/cstart.S               |  22 ++
>  arm/cstart64.S             |  23 ++
>  arm/gic.c                  | 482 ++++++++++++++++++++++++--
>  arm/pmu.c                  | 831 +++++++++++++++++++++++++++++++++++++++++++--
>  arm/psci.c                 |  14 +-
>  arm/run                    |   2 +-
>  arm/timer.c                |  82 +++--
>  arm/unittests.cfg          | 101 +++++-
>  errata.txt                 |   1 +
>  lib/alloc_page.c           |   7 +-
>  lib/alloc_page.h           |   1 +
>  lib/arm/asm/gic-v3-its.h   |  27 ++
>  lib/arm/asm/gic-v3.h       |  33 ++
>  lib/arm/asm/gic.h          |  13 +
>  lib/arm/asm/processor.h    |  15 +
>  lib/arm/gic-v3.c           |  78 +++++
>  lib/arm/gic.c              | 116 ++++++-
>  lib/arm/io.c               |  28 ++
>  lib/arm/setup.c            |   8 +
>  lib/arm64/asm/gic-v3-its.h | 174 ++++++++++
>  lib/arm64/asm/processor.h  |  12 +
>  lib/arm64/asm/sysreg.h     |  17 +
>  lib/arm64/gic-v3-its-cmd.c | 459 +++++++++++++++++++++++++
>  lib/arm64/gic-v3-its.c     | 171 ++++++++++
>  lib/bitops.h               |   3 +
>  lib/libcflat.h             |   3 +
>  29 files changed, 2635 insertions(+), 95 deletions(-)
>  create mode 100644 lib/arm/asm/gic-v3-its.h
>  create mode 100644 lib/arm64/asm/gic-v3-its.h
>  create mode 100644 lib/arm64/gic-v3-its-cmd.c
>  create mode 100644 lib/arm64/gic-v3-its.c
> 

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

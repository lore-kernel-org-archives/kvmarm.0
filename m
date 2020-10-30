Return-Path: <SRS0=VJ1f=EF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA82C4741F
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 16:00:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A02922067D
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 16:00:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A02922067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1216F4B590;
	Fri, 30 Oct 2020 12:00:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M+NVKVna2btU; Fri, 30 Oct 2020 12:00:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAE384B576;
	Fri, 30 Oct 2020 12:00:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41B6D4B579
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 12:00:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZiPC+oH9aNp4 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Oct 2020 12:00:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E38394B559
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 12:00:53 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 93CCD1435;
 Fri, 30 Oct 2020 09:00:53 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F3CA13F719;
 Fri, 30 Oct 2020 09:00:52 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC PATCH v2 0/5] arm64: Statistical Profiling
 Extension Tests
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20201027171944.13933-1-alexandru.elisei@arm.com>
Message-ID: <a231b40f-ff99-1529-387b-d9708862cc62@arm.com>
Date: Fri, 30 Oct 2020 16:02:06 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201027171944.13933-1-alexandru.elisei@arm.com>
Content-Language: en-US
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

Hi,

Adding Andrew to CC list, somehow I forgot, sorry for that.

Thanks,

Alex

On 10/27/20 5:19 PM, Alexandru Elisei wrote:
> This series implements two basic tests for KVM SPE: one that checks that
> the reported features match what is specified in the architecture,
> implemented in patch #3 ("arm64: spe: Add introspection test"), and another
> test that checks that the buffer management interrupt is asserted
> correctly, implemented in patch #5 ("am64: spe: Add buffer test"). The rest
> of the patches are either preparatory patches, or a fix, in the case of
> patch #2 ("lib/{bitops,alloc_page}.h: Add missing headers").
>
> This series builds on Eric's initial version [1], to which I've added the
> buffer tests that I used while developing SPE support for KVM.
>
> KVM SPE support is current in RFC phase, hence why this series is also sent
> as RFC. The KVM patches needed for the tests to work can be found at [2].
> Userspace support is also necessary, which I've implemented for kvmtool;
> this can be found at [3]. This series is also available in a repo [4] to make
> testing easier.
>
> [1] https://www.spinics.net/lists/kvm/msg223792.html
> [2] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/kvm-spe-v3
> [3] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/kvm-spe-v3
> [4] https://gitlab.arm.com/linux-arm/kvm-unit-tests-ae/-/tree/kvm-spe-v2
>
> Alexandru Elisei (3):
>   lib/{bitops,alloc_page}.h: Add missing headers
>   lib: arm/arm64: Add function to unmap a page
>   am64: spe: Add buffer test
>
> Eric Auger (2):
>   arm64: Move get_id_aa64dfr0() in processor.h
>   arm64: spe: Add introspection test
>
>  arm/Makefile.arm64        |   1 +
>  lib/arm/asm/mmu-api.h     |   1 +
>  lib/arm64/asm/processor.h |   5 +
>  lib/alloc_page.h          |   2 +
>  lib/bitops.h              |   2 +
>  lib/libcflat.h            |   1 +
>  lib/arm/mmu.c             |  32 +++
>  arm/pmu.c                 |   1 -
>  arm/spe.c                 | 506 ++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg         |  15 ++
>  10 files changed, 565 insertions(+), 1 deletion(-)
>  create mode 100644 arm/spe.c
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=OpMx=BP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF674C433E0
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 15:37:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3CAE022D05
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 15:37:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3CAE022D05
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F0394B443;
	Wed,  5 Aug 2020 11:37:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R9Om8gqK5iAv; Wed,  5 Aug 2020 11:37:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DAE44B446;
	Wed,  5 Aug 2020 11:37:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EE734B442
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 11:37:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H4WnooofC87Y for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Aug 2020 11:37:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D12C4B441
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 11:37:24 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1FC041045;
 Wed,  5 Aug 2020 08:37:23 -0700 (PDT)
Received: from [192.168.1.84] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5DE223F7D7;
 Wed,  5 Aug 2020 08:37:22 -0700 (PDT)
Subject: Re: [PATCH v2 0/6] KVM: arm64: pvtime: Fixes and a new cap
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20200804170604.42662-1-drjones@redhat.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <c5dbe385-d0d5-94f5-5e8a-620e439e482b@arm.com>
Date: Wed, 5 Aug 2020 16:37:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200804170604.42662-1-drjones@redhat.com>
Content-Language: en-GB
Cc: maz@kernel.org, pbonzini@redhat.com
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

On 04/08/2020 18:05, Andrew Jones wrote:
> v2:
>    - ARM_SMCCC_HV_PV_TIME_FEATURES now also returns SMCCC_RET_NOT_SUPPORTED
>      when steal time is not supported
>    - Added READ_ONCE() for the run_delay read
>    - Reworked kvm_put/get_guest to not require type as a parameter
>    - Added some more text to the documentation for KVM_CAP_STEAL_TIME
>    - Enough changed that I didn't pick up Steven's r-b's

Feel free to add my r-b's - the changes all look fine to me.

Thanks,

Steve

> 
> The first four patches in the series are fixes that come from testing
> and reviewing pvtime code while writing the QEMU support[*]. The last
> patch is only a convenience for userspace, and I wouldn't be heartbroken
> if it wasn't deemed worth it. The QEMU patches are currently written
> without the cap. However, if the cap is accepted, then I'll change the
> QEMU code to use it.
> 
> Thanks,
> drew
> 
> [*] https://lists.gnu.org/archive/html/qemu-devel/2020-07/msg03856.html
>      (a v2 of this series will also be posted shortly)
> 
> Andrew Jones (6):
>    KVM: arm64: pvtime: steal-time is only supported when configured
>    KVM: arm64: pvtime: Fix potential loss of stolen time
>    KVM: arm64: Drop type input from kvm_put_guest
>    KVM: arm64: pvtime: Fix stolen time accounting across migration
>    KVM: Documentation: Minor fixups
>    arm64/x86: KVM: Introduce steal-time cap
> 
>   Documentation/virt/kvm/api.rst    | 22 ++++++++++++++++++----
>   arch/arm64/include/asm/kvm_host.h |  2 +-
>   arch/arm64/kvm/arm.c              |  3 +++
>   arch/arm64/kvm/pvtime.c           | 29 +++++++++++++----------------
>   arch/x86/kvm/x86.c                |  3 +++
>   include/linux/kvm_host.h          | 31 ++++++++++++++++++++++++++-----
>   include/uapi/linux/kvm.h          |  1 +
>   7 files changed, 65 insertions(+), 26 deletions(-)
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

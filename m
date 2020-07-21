Return-Path: <SRS0=7ri5=BA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B50C433E5
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jul 2020 03:26:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1721720792
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jul 2020 03:26:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1721720792
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DBE24B28A;
	Mon, 20 Jul 2020 23:26:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6iqJr4pdiFWr; Mon, 20 Jul 2020 23:26:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE1A14B276;
	Mon, 20 Jul 2020 23:26:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11E9C4B276
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2020 23:26:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mBLeyBCY08X7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jul 2020 23:26:43 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5AE5E4B186
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2020 23:26:43 -0400 (EDT)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id A0D07E63F265E152B026;
 Tue, 21 Jul 2020 11:26:39 +0800 (CST)
Received: from [10.174.187.22] (10.174.187.22) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Tue, 21 Jul 2020 11:26:31 +0800
Subject: Re: [PATCH 0/9] arm64: Stolen time support
To: Steven Price <steven.price@arm.com>
References: <20190802145017.42543-1-steven.price@arm.com>
From: zhukeqian <zhukeqian1@huawei.com>
Message-ID: <1611996b-1ec1-dee7-ed61-b3b9df23f138@huawei.com>
Date: Tue, 21 Jul 2020 11:26:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20190802145017.42543-1-steven.price@arm.com>
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org,
 yebiaoxiang@huawei.com, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Steven,

On 2019/8/2 22:50, Steven Price wrote:
> This series add support for paravirtualized time for arm64 guests and
> KVM hosts following the specification in Arm's document DEN 0057A:
> 
> https://developer.arm.com/docs/den0057/a
> 
> It implements support for stolen time, allowing the guest to
> identify time when it is forcibly not executing.
> 
> It doesn't implement support for Live Physical Time (LPT) as there are
> some concerns about the overheads and approach in the above
Do you plan to pick up LPT support? As there is demand of cross-frequency migration
(from older platform to newer platform).

I am not clear about the overheads and approach problem here, could you please
give some detail information? Maybe we can work together to solve these concerns. :-)

Thanks,
Keqian
> specification, and I expect an updated version of the specification to
> be released soon with just the stolen time parts.
> 
> I previously posted a series including LPT (as well as stolen time):
> https://lore.kernel.org/kvmarm/20181212150226.38051-1-steven.price@arm.com/
> 
> Patches 2, 5, 7 and 8 are cleanup patches and could be taken separately.
> 
> Christoffer Dall (1):
>   KVM: arm/arm64: Factor out hypercall handling from PSCI code
> 
> Steven Price (8):
>   KVM: arm64: Document PV-time interface
>   KVM: arm64: Implement PV_FEATURES call
>   KVM: arm64: Support stolen time reporting via shared structure
>   KVM: Allow kvm_device_ops to be const
>   KVM: arm64: Provide a PV_TIME device to user space
>   arm/arm64: Provide a wrapper for SMCCC 1.1 calls
>   arm/arm64: Make use of the SMCCC 1.1 wrapper
>   arm64: Retrieve stolen time as paravirtualized guest
> 
>  Documentation/virtual/kvm/arm/pvtime.txt | 107 +++++++++++++
>  arch/arm/kvm/Makefile                    |   2 +-
>  arch/arm/kvm/handle_exit.c               |   2 +-
>  arch/arm/mm/proc-v7-bugs.c               |  13 +-
>  arch/arm64/include/asm/kvm_host.h        |  13 +-
>  arch/arm64/include/asm/kvm_mmu.h         |   2 +
>  arch/arm64/include/asm/pvclock-abi.h     |  20 +++
>  arch/arm64/include/uapi/asm/kvm.h        |   6 +
>  arch/arm64/kernel/Makefile               |   1 +
>  arch/arm64/kernel/cpu_errata.c           |  80 ++++------
>  arch/arm64/kernel/kvm.c                  | 155 ++++++++++++++++++
>  arch/arm64/kvm/Kconfig                   |   1 +
>  arch/arm64/kvm/Makefile                  |   2 +
>  arch/arm64/kvm/handle_exit.c             |   4 +-
>  include/kvm/arm_hypercalls.h             |  44 ++++++
>  include/kvm/arm_psci.h                   |   2 +-
>  include/linux/arm-smccc.h                |  58 +++++++
>  include/linux/cpuhotplug.h               |   1 +
>  include/linux/kvm_host.h                 |   4 +-
>  include/linux/kvm_types.h                |   2 +
>  include/uapi/linux/kvm.h                 |   2 +
>  virt/kvm/arm/arm.c                       |  18 +++
>  virt/kvm/arm/hypercalls.c                | 138 ++++++++++++++++
>  virt/kvm/arm/mmu.c                       |  44 ++++++
>  virt/kvm/arm/psci.c                      |  84 +---------
>  virt/kvm/arm/pvtime.c                    | 190 +++++++++++++++++++++++
>  virt/kvm/kvm_main.c                      |   6 +-
>  27 files changed, 848 insertions(+), 153 deletions(-)
>  create mode 100644 Documentation/virtual/kvm/arm/pvtime.txt
>  create mode 100644 arch/arm64/include/asm/pvclock-abi.h
>  create mode 100644 arch/arm64/kernel/kvm.c
>  create mode 100644 include/kvm/arm_hypercalls.h
>  create mode 100644 virt/kvm/arm/hypercalls.c
>  create mode 100644 virt/kvm/arm/pvtime.c
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

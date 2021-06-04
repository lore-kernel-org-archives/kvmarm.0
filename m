Return-Path: <SRS0=VfsR=K6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B48C07E94
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 08:13:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C0E036140C
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 08:13:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0E036140C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38C7A4B0C3;
	Fri,  4 Jun 2021 04:13:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XODFCP8vGZfg; Fri,  4 Jun 2021 04:13:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCA5B4B0C7;
	Fri,  4 Jun 2021 04:13:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC8054B0C7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 04:13:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JX8oIr79bvJg for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Jun 2021 04:13:19 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D8B514B0C3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 04:13:18 -0400 (EDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FxFl0079FzWrcJ;
 Fri,  4 Jun 2021 16:08:28 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 16:13:13 +0800
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 16:13:12 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2176.012; Fri, 4 Jun 2021 09:13:10 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu"
 <kvmarm@lists.cs.columbia.edu>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH 0/3] kvm/arm: New VMID allocator based on asid(2nd
 approach) 
Thread-Topic: [RFC PATCH 0/3] kvm/arm: New VMID allocator based on asid(2nd
 approach) 
Thread-Index: AQHXQph5pwodb0a/4kShAMz7Pnc+rqsDq0rQ
Date: Fri, 4 Jun 2021 08:13:10 +0000
Message-ID: <e62829990c50479292af94c4152011fc@huawei.com>
References: <20210506165232.1969-1-shameerali.kolothum.thodi@huawei.com>
In-Reply-To: <20210506165232.1969-1-shameerali.kolothum.thodi@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.88.52]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Cc: "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 "maz@kernel.org" <maz@kernel.org>, Linuxarm <linuxarm@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>
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

> -----Original Message-----
> From: Shameerali Kolothum Thodi
> Sent: 06 May 2021 17:52
> To: linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> linux-kernel@vger.kernel.org
> Cc: maz@kernel.org; will@kernel.org; catalin.marinas@arm.com;
> james.morse@arm.com; julien.thierry.kdev@gmail.com;
> suzuki.poulose@arm.com; jean-philippe@linaro.org; Linuxarm
> <linuxarm@huawei.com>
> Subject: [RFC PATCH 0/3] kvm/arm: New VMID allocator based on asid(2nd
> approach)
> 
> This is based on a suggestion from Will [0] to try out the asid
> based kvm vmid solution as a separate VMID allocator instead of
> the shared lib approach attempted in v4[1].
> 
> The idea is to compare both the approaches and see whether the
> shared lib solution with callbacks make sense or not.

A gentle ping on this. Please take a look and let me know.

Thanks,
Shameer

> Though we are not yet using the pinned vmids yet, patch #2 has
> code for pinned vmid support. This is just to help the comparison.
> 
> Test Setup/Results
> ----------------
> The measurement was made with maxcpus set to 8 and with the
> number of VMID limited to 4-bit. The test involves running
> concurrently 40 guests with 2 vCPUs. Each guest will then
> execute hackbench 5 times before exiting.
> 
> The performance difference between the current algo and the
> new one are(avg. of 10 runs):
>     - 1.9% less entry/exit from the guest
>     - 0.5% faster
> This is more or less comparable to v4 numbers.
> 
> For the complete series, please see,
> https://github.com/hisilicon/kernel-dev/tree/private-v5.12-rc7-vmid-2nd-rfc
> 
> and for the shared asid lib v4 solution,
> https://github.com/hisilicon/kernel-dev/tree/private-v5.12-rc7-asid-v4
> 
> As you can see there are of course code duplication with this
> approach but may be this one is more easy to maintain considering
> the complexity involved.
> 
> Please take a look and let me know your feedback.
> 
> Thanks,
> Shameer
> 
> 
> [0] https://lore.kernel.org/lkml/20210422160846.GB2214@willie-the-truck/
> [1]
> https://lore.kernel.org/lkml/20210414112312.13704-1-shameerali.kolothum.t
> hodi@huawei.com/
> 
> Julien Grall (2):
>   arch/arm64: Introduce a capability to tell whether 16-bit VMID is
>     available
>   kvm/arm: Align the VMID allocation with the arm64 ASID one
> 
> Shameer Kolothum (1):
>   kvm/arm: Introduce a new vmid allocator for KVM
> 
>  arch/arm64/include/asm/cpucaps.h   |   3 +-
>  arch/arm64/include/asm/kvm_asm.h   |   4 +-
>  arch/arm64/include/asm/kvm_host.h  |  11 +-
>  arch/arm64/include/asm/kvm_mmu.h   |   7 +-
>  arch/arm64/kernel/cpufeature.c     |   9 +
>  arch/arm64/kvm/Makefile            |   2 +-
>  arch/arm64/kvm/arm.c               | 115 ++++--------
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c |   6 +-
>  arch/arm64/kvm/hyp/nvhe/tlb.c      |  10 +-
>  arch/arm64/kvm/hyp/vhe/tlb.c       |  10 +-
>  arch/arm64/kvm/mmu.c               |   1 -
>  arch/arm64/kvm/vmid.c              | 285
> +++++++++++++++++++++++++++++
>  12 files changed, 354 insertions(+), 109 deletions(-)
>  create mode 100644 arch/arm64/kvm/vmid.c
> 
> --
> 2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

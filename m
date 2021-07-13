Return-Path: <SRS0=yjsw=MF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0180C07E95
	for <kvmarm@archiver.kernel.org>; Tue, 13 Jul 2021 07:07:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F0DED6120A
	for <kvmarm@archiver.kernel.org>; Tue, 13 Jul 2021 07:07:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0DED6120A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44AF140856;
	Tue, 13 Jul 2021 03:07:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mFgf1UKljTH1; Tue, 13 Jul 2021 03:07:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E889C405EE;
	Tue, 13 Jul 2021 03:07:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8670E4048B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Jul 2021 03:07:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N0QAeQmd02op for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Jul 2021 03:07:27 -0400 (EDT)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EBA1240463
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Jul 2021 03:07:26 -0400 (EDT)
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.207])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GPBCx5y37z6BBWR;
 Tue, 13 Jul 2021 14:53:01 +0800 (CST)
Received: from lhreml718-chm.china.huawei.com (10.201.108.69) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 13 Jul 2021 09:07:24 +0200
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml718-chm.china.huawei.com (10.201.108.69) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 13 Jul 2021 08:07:24 +0100
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2176.012; Tue, 13 Jul 2021 08:07:23 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu"
 <kvmarm@lists.cs.columbia.edu>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "maz@kernel.org" <maz@kernel.org>
Subject: RE: [PATCH v2 0/3] kvm/arm: New VMID allocator based on asid
Thread-Topic: [PATCH v2 0/3] kvm/arm: New VMID allocator based on asid
Thread-Index: AQHXYshE9jEBx3DaO0yBdBUJuC9xNqtApHOQ
Date: Tue, 13 Jul 2021 07:07:23 +0000
Message-ID: <de5eee0cd5814b779827b982f0b1f270@huawei.com>
References: <20210616155606.2806-1-shameerali.kolothum.thodi@huawei.com>
In-Reply-To: <20210616155606.2806-1-shameerali.kolothum.thodi@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.90.246]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Cc: "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
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

Hi Marc,

> -----Original Message-----
> From: Shameerali Kolothum Thodi
> Sent: 16 June 2021 16:56
> To: linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> linux-kernel@vger.kernel.org
> Cc: maz@kernel.org; will@kernel.org; catalin.marinas@arm.com;
> james.morse@arm.com; julien.thierry.kdev@gmail.com;
> suzuki.poulose@arm.com; jean-philippe@linaro.org;
> Alexandru.Elisei@arm.com; Linuxarm <linuxarm@huawei.com>
> Subject: [PATCH v2 0/3] kvm/arm: New VMID allocator based on asid
> 
> Hi,
> 
> RFCv1 --> v2
>    - Dropped "pinned VMID" support for now.
>    - Dropped RFC tag.
> 
> Sanity tested on HiSilicon D06 board.

A gentle ping on this one. Please let me know if you had a chance to look
at this and have any feedback. I could do a rebase to 5.14-rc1 if required.

Thanks,
Shameer

> 
> Thanks,
> Shameer
> 
> History:
> -------
> Please find the RFC series here,
> https://lore.kernel.org/kvmarm/20210506165232.1969-1-shameerali.kolothu
> m.thodi@huawei.com/
> 
> From RFCv1:
> 
> This is based on a suggestion from Will [0] to try out the asid
> based kvm vmid solution as a separate VMID allocator instead of
> the shared lib approach attempted in v4[1].
> 
> The idea is to compare both the approaches and see whether the
> shared lib solution with callbacks make sense or not.
> 
> Though we are not using the pinned vmids yet, patch #2 has
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
> 
> This is more or less comparable to v4 numbers.
> 
> For the complete series, please see,
> https://github.com/hisilicon/kernel-dev/tree/private-v5.12-rc7-vmid-2nd-rfc
> 
> and for the shared asid lib v4 solution,
> https://github.com/hisilicon/kernel-dev/tree/private-v5.12-rc7-asid-v4
> 
> As you can see there are ofcourse code duplication with this
> approach but may be it is more easy to maintain considering
> the complexity involved.
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
>  arch/arm64/include/asm/kvm_asm.h      |   4 +-
>  arch/arm64/include/asm/kvm_host.h     |  10 +-
>  arch/arm64/include/asm/kvm_mmu.h      |   7 +-
>  arch/arm64/kernel/cpufeature.c        |   9 ++
>  arch/arm64/kvm/Makefile               |   2 +-
>  arch/arm64/kvm/arm.c                  | 115 ++++----------
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c    |   6 +-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c |   3 +-
>  arch/arm64/kvm/hyp/nvhe/tlb.c         |  10 +-
>  arch/arm64/kvm/hyp/vhe/tlb.c          |  10 +-
>  arch/arm64/kvm/mmu.c                  |   1 -
>  arch/arm64/kvm/vmid.c                 | 206
> ++++++++++++++++++++++++++
>  arch/arm64/tools/cpucaps              |   1 +
>  13 files changed, 273 insertions(+), 111 deletions(-)
>  create mode 100644 arch/arm64/kvm/vmid.c
> 
> --
> 2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

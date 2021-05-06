Return-Path: <SRS0=4Pzf=KB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DED3C433ED
	for <kvmarm@archiver.kernel.org>; Thu,  6 May 2021 16:54:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B8C56611AE
	for <kvmarm@archiver.kernel.org>; Thu,  6 May 2021 16:54:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8C56611AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F3CDA4B0B1;
	Thu,  6 May 2021 12:54:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ycFVS6Y+hkf5; Thu,  6 May 2021 12:54:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2F824B468;
	Thu,  6 May 2021 12:54:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C68C14B462
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 May 2021 12:54:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c7rjarv7DGkT for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 May 2021 12:54:32 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ACCF14B0B1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 May 2021 12:54:32 -0400 (EDT)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FbfjV3ckdzqSVg;
 Fri,  7 May 2021 00:51:10 +0800 (CST)
Received: from A2006125610.china.huawei.com (10.47.85.115) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Fri, 7 May 2021 00:54:16 +0800
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 0/3] kvm/arm: New VMID allocator based on asid(2nd
 approach) 
Date: Thu, 6 May 2021 17:52:29 +0100
Message-ID: <20210506165232.1969-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.47.85.115]
X-CFilter-Loop: Reflected
Cc: jean-philippe@linaro.org, maz@kernel.org, linuxarm@huawei.com,
 catalin.marinas@arm.com, will@kernel.org
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

This is based on a suggestion from Will [0] to try out the asid
based kvm vmid solution as a separate VMID allocator instead of
the shared lib approach attempted in v4[1].

The idea is to compare both the approaches and see whether the
shared lib solution with callbacks make sense or not. 

Though we are not yet using the pinned vmids yet, patch #2 has
code for pinned vmid support. This is just to help the comparison.

Test Setup/Results
----------------
The measurement was made with maxcpus set to 8 and with the
number of VMID limited to 4-bit. The test involves running
concurrently 40 guests with 2 vCPUs. Each guest will then
execute hackbench 5 times before exiting.

The performance difference between the current algo and the
new one are(avg. of 10 runs):
    - 1.9% less entry/exit from the guest
    - 0.5% faster
This is more or less comparable to v4 numbers.

For the complete series, please see,
https://github.com/hisilicon/kernel-dev/tree/private-v5.12-rc7-vmid-2nd-rfc

and for the shared asid lib v4 solution,
https://github.com/hisilicon/kernel-dev/tree/private-v5.12-rc7-asid-v4

As you can see there are of course code duplication with this
approach but may be this one is more easy to maintain considering
the complexity involved.

Please take a look and let me know your feedback.

Thanks,
Shameer


[0] https://lore.kernel.org/lkml/20210422160846.GB2214@willie-the-truck/
[1] https://lore.kernel.org/lkml/20210414112312.13704-1-shameerali.kolothum.thodi@huawei.com/

Julien Grall (2):
  arch/arm64: Introduce a capability to tell whether 16-bit VMID is
    available
  kvm/arm: Align the VMID allocation with the arm64 ASID one

Shameer Kolothum (1):
  kvm/arm: Introduce a new vmid allocator for KVM

 arch/arm64/include/asm/cpucaps.h   |   3 +-
 arch/arm64/include/asm/kvm_asm.h   |   4 +-
 arch/arm64/include/asm/kvm_host.h  |  11 +-
 arch/arm64/include/asm/kvm_mmu.h   |   7 +-
 arch/arm64/kernel/cpufeature.c     |   9 +
 arch/arm64/kvm/Makefile            |   2 +-
 arch/arm64/kvm/arm.c               | 115 ++++--------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |   6 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c      |  10 +-
 arch/arm64/kvm/hyp/vhe/tlb.c       |  10 +-
 arch/arm64/kvm/mmu.c               |   1 -
 arch/arm64/kvm/vmid.c              | 285 +++++++++++++++++++++++++++++
 12 files changed, 354 insertions(+), 109 deletions(-)
 create mode 100644 arch/arm64/kvm/vmid.c

-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

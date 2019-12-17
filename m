Return-Path: <SRS0=Hq6c=2H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74C7C3F68F
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 13:56:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A8F6121D7D
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 13:56:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8F6121D7D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64F644AC65;
	Tue, 17 Dec 2019 08:56:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eqYXf6aKjQfn; Tue, 17 Dec 2019 08:56:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D3804A524;
	Tue, 17 Dec 2019 08:56:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38BC74A4CD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 08:56:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tl+UNwsgAlF1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Dec 2019 08:56:36 -0500 (EST)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A0584A5A8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 08:56:36 -0500 (EST)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 7104DDED043953C7AA42;
 Tue, 17 Dec 2019 21:56:30 +0800 (CST)
Received: from DESKTOP-1NISPDV.china.huawei.com (10.173.221.248) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Tue, 17 Dec 2019 21:56:21 +0800
From: <yezengruan@huawei.com>
To: <yezengruan@huawei.com>, <linux-kernel@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
 <virtualization@lists.linux-foundation.org>
Subject: [PATCH 0/5] KVM: arm64: vcpu preempted check support
Date: Tue, 17 Dec 2019 21:55:44 +0800
Message-ID: <20191217135549.3240-1-yezengruan@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.173.221.248]
X-CFilter-Loop: Reflected
Cc: catalin.marinas@arm.com, daniel.lezcano@linaro.org, linux@armlinux.org.uk,
 steven.price@arm.com, maz@kernel.org, will@kernel.org
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

From: Zengruan Ye <yezengruan@huawei.com>

This patch set aims to support the vcpu_is_preempted() functionality
under KVM/arm64, which allowing the guest to obtain the vcpu is
currently running or not. This will enhance lock performance on
overcommitted hosts (more runnable vcpus than physical cpus in the
system) as doing busy waits for preempted vcpus will hurt system
performance far worse than early yielding.

We have observed some performace improvements in uninx benchmark tests.

unix benchmark result:
  host:  kernel 5.5.0-rc1, HiSilicon Kunpeng920, 8 cpus
  guest: kernel 5.5.0-rc1, 16 vcpus

               test-case                |    after-patch    |   before-patch
----------------------------------------+-------------------+------------------
 Dhrystone 2 using register variables   | 334600751.0 lps   | 335319028.3 lps
 Double-Precision Whetstone             |     32856.1 MWIPS |   32849.6 MWIPS
 Execl Throughput                       |      3662.1 lps   |    2718.0 lps
 File Copy 1024 bufsize 2000 maxblocks  |    432906.4 KBps  |  158011.8 KBps
 File Copy 256 bufsize 500 maxblocks    |    116023.0 KBps  |   37664.0 KBps
 File Copy 4096 bufsize 8000 maxblocks  |   1432769.8 KBps  |  441108.8 KBps
 Pipe Throughput                        |   6405029.6 lps   | 6021457.6 lps
 Pipe-based Context Switching           |    185872.7 lps   |  184255.3 lps
 Process Creation                       |      4025.7 lps   |    3706.6 lps
 Shell Scripts (1 concurrent)           |      6745.6 lpm   |    6436.1 lpm
 Shell Scripts (8 concurrent)           |       998.7 lpm   |     931.1 lpm
 System Call Overhead                   |   3913363.1 lps   | 3883287.8 lps
----------------------------------------+-------------------+------------------
 System Benchmarks Index Score          |      1835.1       |    1327.6

Zengruan Ye (5):
  KVM: arm64: Document PV-lock interface
  KVM: arm64: Implement PV_LOCK_FEATURES call
  KVM: arm64: Support pvlock preempted via shared structure
  KVM: arm64: Add interface to support vcpu preempted check
  KVM: arm64: Support the vcpu preemption check

 Documentation/virt/kvm/arm/pvlock.rst  | 31 +++++++++
 arch/arm/include/asm/kvm_host.h        | 13 ++++
 arch/arm64/include/asm/kvm_host.h      | 17 +++++
 arch/arm64/include/asm/paravirt.h      | 15 ++++
 arch/arm64/include/asm/pvlock-abi.h    | 16 +++++
 arch/arm64/include/asm/spinlock.h      |  7 ++
 arch/arm64/kernel/Makefile             |  2 +-
 arch/arm64/kernel/paravirt-spinlocks.c | 13 ++++
 arch/arm64/kernel/paravirt.c           | 95 +++++++++++++++++++++++++-
 arch/arm64/kernel/setup.c              |  2 +
 arch/arm64/kvm/Makefile                |  1 +
 include/linux/arm-smccc.h              | 13 ++++
 include/linux/cpuhotplug.h             |  1 +
 virt/kvm/arm/arm.c                     |  8 +++
 virt/kvm/arm/hypercalls.c              |  7 ++
 virt/kvm/arm/pvlock.c                  | 21 ++++++
 16 files changed, 260 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/pvlock.rst
 create mode 100644 arch/arm64/include/asm/pvlock-abi.h
 create mode 100644 arch/arm64/kernel/paravirt-spinlocks.c
 create mode 100644 virt/kvm/arm/pvlock.c

-- 
2.19.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

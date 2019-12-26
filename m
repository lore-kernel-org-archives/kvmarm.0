Return-Path: <SRS0=3oJT=2Q=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D094C2D0DB
	for <kvmarm@archiver.kernel.org>; Thu, 26 Dec 2019 13:59:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 03B3A2075E
	for <kvmarm@archiver.kernel.org>; Thu, 26 Dec 2019 13:59:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03B3A2075E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 588C54AC70;
	Thu, 26 Dec 2019 08:59:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s8jtca9oKGpF; Thu, 26 Dec 2019 08:59:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 351DF4A95D;
	Thu, 26 Dec 2019 08:59:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBB3C4A959
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Dec 2019 08:59:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qk2Sh-u7dz+T for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Dec 2019 08:59:01 -0500 (EST)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A5314A4E8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Dec 2019 08:59:01 -0500 (EST)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 17720E927BC04C10696D;
 Thu, 26 Dec 2019 21:58:57 +0800 (CST)
Received: from DESKTOP-1NISPDV.china.huawei.com (10.173.221.248) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Thu, 26 Dec 2019 21:58:51 +0800
From: Zengruan Ye <yezengruan@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <virtualization@lists.linux-foundation.org>
Subject: [PATCH v2 0/6] KVM: arm64: VCPU preempted check support
Date: Thu, 26 Dec 2019 21:58:27 +0800
Message-ID: <20191226135833.1052-1-yezengruan@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.173.221.248]
X-CFilter-Loop: Reflected
Cc: maz@kernel.org, daniel.lezcano@linaro.org, linux@armlinux.org.uk,
 steven.price@arm.com, yezengruan@huawei.com, catalin.marinas@arm.com,
 will@kernel.org
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

This patch set aims to support the vcpu_is_preempted() functionality
under KVM/arm64, which allowing the guest to obtain the VCPU is
currently running or not. This will enhance lock performance on
overcommitted hosts (more runnable VCPUs than physical CPUs in the
system) as doing busy waits for preempted VCPUs will hurt system
performance far worse than early yielding.

We have observed some performace improvements in uninx benchmark tests.

unix benchmark result:
  host:  kernel 5.5.0-rc1, HiSilicon Kunpeng920, 8 CPUs
  guest: kernel 5.5.0-rc1, 16 VCPUs

               test-case                |    after-patch    |   before-patch
----------------------------------------+-------------------+------------------
 Dhrystone 2 using register variables   | 334600751.0 lps   | 335319028.3 lps
 Double-Precision Whetstone             |     32856.1 MWIPS |     32849.6 MWIPS
 Execl Throughput                       |      3662.1 lps   |      2718.0 lps
 File Copy 1024 bufsize 2000 maxblocks  |    432906.4 KBps  |    158011.8 KBps
 File Copy 256 bufsize 500 maxblocks    |    116023.0 KBps  |     37664.0 KBps
 File Copy 4096 bufsize 8000 maxblocks  |   1432769.8 KBps  |    441108.8 KBps
 Pipe Throughput                        |   6405029.6 lps   |   6021457.6 lps
 Pipe-based Context Switching           |    185872.7 lps   |    184255.3 lps
 Process Creation                       |      4025.7 lps   |      3706.6 lps
 Shell Scripts (1 concurrent)           |      6745.6 lpm   |      6436.1 lpm
 Shell Scripts (8 concurrent)           |       998.7 lpm   |       931.1 lpm
 System Call Overhead                   |   3913363.1 lps   |   3883287.8 lps
----------------------------------------+-------------------+------------------
 System Benchmarks Index Score          |      1835.1       |      1327.6

Changes from v1:
https://lore.kernel.org/lkml/20191217135549.3240-1-yezengruan@huawei.com/
 * Guest kernel no longer allocates the PV lock structure, instead it
   is allocated by user space to avoid lifetime issues about kexec.
 * Provide VCPU attributes for PV lock.
 * Update SMC number of PV lock features.
 * Report some basic validation when PV lock init.
 * Document preempted field.
 * Bunch of typo fixes.

Zengruan Ye (6):
  KVM: arm64: Document PV-lock interface
  KVM: arm64: Add SMCCC paravirtualised lock calls
  KVM: arm64: Support pvlock preempted via shared structure
  KVM: arm64: Provide VCPU attributes for PV lock
  KVM: arm64: Add interface to support VCPU preempted check
  KVM: arm64: Support the VCPU preemption check

 Documentation/virt/kvm/arm/pvlock.rst   |  63 ++++++++++++
 Documentation/virt/kvm/devices/vcpu.txt |  14 +++
 arch/arm/include/asm/kvm_host.h         |  18 ++++
 arch/arm64/include/asm/kvm_host.h       |  28 ++++++
 arch/arm64/include/asm/paravirt.h       |  15 +++
 arch/arm64/include/asm/pvlock-abi.h     |  16 ++++
 arch/arm64/include/asm/spinlock.h       |   7 ++
 arch/arm64/include/uapi/asm/kvm.h       |   2 +
 arch/arm64/kernel/Makefile              |   2 +-
 arch/arm64/kernel/paravirt-spinlocks.c  |  13 +++
 arch/arm64/kernel/paravirt.c            | 121 +++++++++++++++++++++++-
 arch/arm64/kernel/setup.c               |   2 +
 arch/arm64/kvm/Makefile                 |   1 +
 arch/arm64/kvm/guest.c                  |   9 ++
 include/linux/arm-smccc.h               |  14 +++
 include/linux/cpuhotplug.h              |   1 +
 include/uapi/linux/kvm.h                |   2 +
 virt/kvm/arm/arm.c                      |   8 ++
 virt/kvm/arm/hypercalls.c               |   8 ++
 virt/kvm/arm/pvlock.c                   | 103 ++++++++++++++++++++
 20 files changed, 445 insertions(+), 2 deletions(-)
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

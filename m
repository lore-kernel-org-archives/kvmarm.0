From: Wei Huang <wei@redhat.com>
Subject: [kvm-unit-tests PATCH v13 0/4] ARM PMU tests
Date: Wed, 30 Nov 2016 23:16:38 -0600
Message-ID: <1480569402-8848-1-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42CAB404FF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 00:15:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hFEHEo-Dwc0i for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2016 00:15:57 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F0CD4047D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 00:15:56 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: cov@codeaurora.org
Cc: alindsay@codeaurora.org, kvm@vger.kernel.org, andre.przywara@arm.com, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Changes from v12:
* Define macros for system register accessors
* Re-write PMU code using the newly-defined macros
* Code tested under both AArch32 and AArch64 modes

Note:
1) Current KVM code has bugs in handling PMCCFILTR write. A fix (see
below) is required for this unit testing code to work correctly under
KVM mode.
https://lists.cs.columbia.edu/pipermail/kvmarm/2016-November/022134.html.

Thanks,
-Wei

Christopher Covington (3):
  arm: Add PMU test
  arm: pmu: Check cycle count increases
  arm: pmu: Add CPI checking

Wei Huang (1):
  arm: Define macros for accessing system registers

 arm/Makefile.common       |   3 +-
 arm/pmu.c                 | 277 ++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg         |  19 ++++
 lib/arm/asm/processor.h   |  37 ++++++-
 lib/arm64/asm/processor.h |  35 ++++--
 5 files changed, 358 insertions(+), 13 deletions(-)
 create mode 100644 arm/pmu.c

-- 
1.8.3.1

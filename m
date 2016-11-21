From: Wei Huang <wei@redhat.com>
Subject: [kvm-unit-tests PATCH v10 0/3] ARM PMU tests
Date: Mon, 21 Nov 2016 14:24:52 -0600
Message-ID: <1479759895-10042-1-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 481C440501
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Nov 2016 15:24:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nqWvPzyxNcnD for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Nov 2016 15:24:20 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 44398402AF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Nov 2016 15:24:20 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Changes from v9:
* Move PMCCNTR related configuration from pmu_init() to sub-tests
* Change the name of loop test function to precise_cycles_loop()
* Print out error detail for each test case in check_cpi()
* Fix cpi convertion from argv
* Change the loop calculation in measure_instrs() after cpi is fixed

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

 arm/Makefile.common |   3 +-
 arm/pmu.c           | 347 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg   |  19 +++
 3 files changed, 368 insertions(+), 1 deletion(-)
 create mode 100644 arm/pmu.c

-- 
1.8.3.1

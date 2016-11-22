From: Wei Huang <wei@redhat.com>
Subject: [kvm-unit-tests PATCH v11 0/3] ARM PMU tests
Date: Tue, 22 Nov 2016 12:29:11 -0600
Message-ID: <1479839354-22061-1-git-send-email-wei@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: cov@codeaurora.org
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org, alistair.francis@xilinx.com, croberts@codeaurora.org, alindsay@codeaurora.org, drjones@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Changes from v10:
* Change the name of loop test function to precise_instrs_loop()
* Minor comment fixes to measure_instrs() and to explain isb() in loop funcs 

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
 arm/pmu.c           | 351 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg   |  19 +++
 3 files changed, 372 insertions(+), 1 deletion(-)
 create mode 100644 arm/pmu.c

-- 
1.8.3.1


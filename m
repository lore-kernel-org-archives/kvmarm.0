From: Wei Huang <wei@redhat.com>
Subject: [kvm-unit-tests PATCH v8 0/3] ARM PMU tests
Date: Tue,  8 Nov 2016 12:17:12 -0600
Message-ID: <1478629035-12938-1-git-send-email-wei@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: cov@codeaurora.org
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org, alistair.francis@xilinx.com, croberts@codeaurora.org, alindsay@codeaurora.org, drjones@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Changes from v7:
* Standardize PMU register accessor names and remove unused ones
* Use bit defines instead of bit fields
* Change the testing configure for pmu.flat
* Commit comments were updated

Note:
1) Current KVM code has bugs in handling PMCCFILTR write. A fix (see
below) is required for this unit testing code to work correctly under
KVM mode.
https://lists.cs.columbia.edu/pipermail/kvmarm/2016-November/022134.html.
2) Because the code was changed, Drew's original reviewed-by needs to
be acknowledged by him again.

-Wei

Wei Huang (3):
  arm: Add PMU test
  arm: pmu: Check cycle count increases
  arm: pmu: Add CPI checking

 arm/Makefile.common |   3 +-
 arm/pmu.c           | 270 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg   |  19 ++++
 3 files changed, 291 insertions(+), 1 deletion(-)
 create mode 100644 arm/pmu.c

-- 
1.8.3.1


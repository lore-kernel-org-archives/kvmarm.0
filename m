From: Wei Huang <wei@redhat.com>
Subject: [kvm-unit-tests PATCHv7 0/3] ARM PMU tests
Date: Wed,  2 Nov 2016 17:22:14 -0500
Message-ID: <1478125337-11770-1-git-send-email-wei@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: cov@codeaurora.org
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org, alistair.francis@xilinx.com, croberts@codeaurora.org, alindsay@codeaurora.org, drjones@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Changes from v6:
* Add a new pmu testing for KVM mode in config file
* Add additional init code, including setting PMCNTENSET and PMCCFILTR, 
  before reading PMCCNTR. ARMv7 support is also provided
* Add cycle counter init code for CPI testing
* Fix pmu_data compilation issue (for gcc 4.8.5)
* Commit comments were updated

NOTE:
1) Current KVM code has bugs in handling PMCCFILTR write. A fix (see
below) is required for this unit testing code to work correctly under
KVM mode.
https://lists.cs.columbia.edu/pipermail/kvmarm/2016-November/022134.html.
2) Because the code was changed, Drew's original reviewed-by needs to
be acknowledged by him again.

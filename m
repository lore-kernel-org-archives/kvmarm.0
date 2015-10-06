From: Christopher Covington <cov@codeaurora.org>
Subject: [kvm-unit-tests PATCHv3] ARM PMU tests
Date: Tue,  6 Oct 2015 13:49:23 -0400
Message-ID: <1444153766-12532-1-git-send-email-cov@codeaurora.org>
References: <5612EDA5.9010506@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5612EDA5.9010506@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: drjones@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, wei@redhat.com
Cc: shannon.zhao@linaro.org, alistair.francis@xilinx.com, croberts@codeaurora.org, alindsay@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

Changes from v2:

* Explicit test for monotonically increasing cycle count
* Tests now pass or fail
* Tests broken into functions
* Tests/functions broken into separate patches in series
* Style improvements as suggested by Wei Huang and Linux checkpatch.pl
* Spelling and comment improvements


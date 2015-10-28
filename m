From: Christopher Covington <cov@codeaurora.org>
Subject: [kvm-unit-tests PATCHv6] ARM PMU tests
Date: Wed, 28 Oct 2015 15:12:52 -0400
Message-ID: <1446059575-23903-1-git-send-email-cov@codeaurora.org>
References: <1444662470-13045-1-git-send-email-cov@codeaurora.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1444662470-13045-1-git-send-email-cov@codeaurora.org>
Sender: kvm-owner@vger.kernel.org
To: drjones@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, wei@redhat.com
Cc: shannon.zhao@linaro.org, alistair.francis@xilinx.com, croberts@codeaurora.org, alindsay@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

Changes from v5:

2/3 arm: pmu: Check cycle count increases
* Use universal initializer {0} despite spurious compiler warnings.
* Add Drew's Reviewed-by.

3/3 arm: pmu: Add CPI checking
* Use numeric constant 0 directly with no intermediate variable.
* More tabs in inline assembly.
* Make A32/A64 inline assembly justification comments uniform.
* Check argc properly.

Thanks,
Christopher Covington

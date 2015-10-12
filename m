From: Christopher Covington <cov@codeaurora.org>
Subject: [kvm-unit-tests PATCHv4] ARM PMU tests
Date: Mon, 12 Oct 2015 11:07:47 -0400
Message-ID: <1444662470-13045-1-git-send-email-cov@codeaurora.org>
References: <5612EDA5.9010506@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5612EDA5.9010506@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: drjones@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, wei@redhat.com
Cc: shannon.zhao@linaro.org, alistair.francis@xilinx.com, croberts@codeaurora.org, alindsay@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

Changes from v3 in response to Drew's suggestions:

* Improved pmu_data / PMCR fields and usage
* Straightened out awkward conditionals
* Added 32-bit support
* Styling enhancements
* Deferred -icount testing to later patch


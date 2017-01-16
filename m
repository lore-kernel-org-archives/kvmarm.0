From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH RFC 0/6] target-arm: KVM64: Cross type vCPU support
Date: Mon, 16 Jan 2017 17:26:55 +0800
Message-ID: <1484558821-15512-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B538B405CC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jan 2017 04:27:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M4zblEUc8IkW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Jan 2017 04:27:17 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 19B6B40501
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jan 2017 04:26:51 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: qemu-arm@nongnu.org
Cc: qemu-devel@nongnu.org, wu.wubin@huawei.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

This patch set support use cross type vCPU when using KVM on ARM and add
two new CPU types: generic and cortex-a72.

You can test this patch set with QEMU using
-cpu cortex-a53/cortex-a57/generic/cortex-a72

These patches can be fetched from:
https://git.linaro.org/people/shannon.zhao/qemu.git cross_vcpu_rfc

You corresponding KVM patches can be fetched from:
https://git.linaro.org/people/shannon.zhao/linux-mainline.git cross_vcpu_rfc

Shannon Zhao (6):
  headers: update linux headers
  target: arm: Add the qemu target for KVM_ARM_TARGET_GENERIC_V8
  arm: kvm64: Check if kvm supports cross type vCPU
  target: arm: Add a generic type cpu
  arm: virt: Enable generic type CPU in virt machine
  target-arm: cpu64: Add support for Cortex-A72

 hw/arm/virt.c                 |   2 +
 linux-headers/asm-arm64/kvm.h |   1 +
 linux-headers/linux/kvm.h     |   2 +
 target/arm/cpu64.c            | 110 +++++++++++++++++++++++++
 target/arm/kvm-consts.h       |   2 +
 target/arm/kvm64.c            | 182 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 299 insertions(+)

-- 
2.0.4

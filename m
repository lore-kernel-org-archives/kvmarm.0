From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH RFC 0/7] ARM64: KVM: Cross type vCPU support
Date: Mon, 16 Jan 2017 17:33:27 +0800
Message-ID: <1484559214-2248-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BC6F401B9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jan 2017 04:43:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5YiZ7fJjHpP9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Jan 2017 04:43:49 -0500 (EST)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [119.145.14.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8ADFC40019
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jan 2017 04:43:47 -0500 (EST)
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
Cc: marc.zyngier@arm.com, qemu-arm@nongnu.org, wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

This patch set adds support for Cross type vCPU in KVM-ARM64. It allows
userspace to request a different vCPU type with the physical ones and
check whether the physical CPUs could support that specific vCPU. If so,
KVM will trap the ID registers and return guest with the values from
usersapce.

This patch set is not complete since the CPU Errata is not considered
and currently it only checks if the id_aa64mmfr0_el1 register value is
legal. I want this as an example and need some feedback from folks if
this approach is right or proper.

You can test this patch set with QEMU using
-cpu cortex-a53/cortex-a57/generic/cortex-a72

These patches can be fetched from:
https://git.linaro.org/people/shannon.zhao/linux-mainline.git cross_vcpu_rfc

You corresponding QEMU patches can be fetched from:
https://git.linaro.org/people/shannon.zhao/qemu.git cross_vcpu_rfc

Thanks,
Shannon

Shannon Zhao (7):
  ARM64: KVM: Add the definition of ID registers
  ARM64: KVM: Add reset handlers for all ID registers
  ARM64: KVM: Reset ID registers when creating the VCPUs
  ARM64: KVM: emulate accessing ID registers
  ARM64: KVM: Support cross type vCPU
  ARM64: KVM: Support heterogeneous system
  ARM64: KVM: Add user set handler for id_aa64mmfr0_el1

 arch/arm/kvm/arm.c                   |  36 ++++-
 arch/arm64/include/asm/kvm_coproc.h  |   1 +
 arch/arm64/include/asm/kvm_emulate.h |   3 +
 arch/arm64/include/asm/kvm_host.h    |  49 +++++-
 arch/arm64/include/uapi/asm/kvm.h    |   1 +
 arch/arm64/kvm/guest.c               |  18 ++-
 arch/arm64/kvm/hyp/sysreg-sr.c       |   2 +
 arch/arm64/kvm/sys_regs.c            | 290 +++++++++++++++++++++++------------
 include/uapi/linux/kvm.h             |   2 +
 9 files changed, 296 insertions(+), 106 deletions(-)

-- 
2.0.4

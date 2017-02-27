From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 0/5] KVM: arm/arm64: fix some races and allow userspace to set
 MPIDR
Date: Mon, 27 Feb 2017 18:54:59 +0100
Message-ID: <20170227175504.15751-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F50B40C21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Feb 2017 12:54:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1jFhvJGdRx66 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Feb 2017 12:54:01 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EEFAA40B5E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Feb 2017 12:54:00 -0500 (EST)
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
Cc: marc.zyngier@arm.com, ashoks@broadcom.com, imammedo@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

This series fixes four races. Two are easy to produce with a
kvm-unit-test test[1], but the other two would be quite hard. I
didn't even try to produce those. The two hard to produce races are
addressed by changing vcpu->arch.pause and vcpu->arch.power_off to
vcpu requests. The two easy to produce races are addressed in two
different ways: the first takes advantage of power_off having been
changed to a vcpu request, the second caches vcpu MPIDRs in order
to avoid extracting them from sys_regs. When introducing the MPIDR
cache we also introduce a new feature (userspace settable MPIDRs).

Support for userspace settable MPIDRs was already posted once[2],
but rejected due to not having a use case. We have one now, which
is to satisfy QEMU's need for the MPDIR information very early,
before vcpu-init has even run. While the original posting author
wasn't me, I've taken authorship now, as I've changed the patch
substantially. If anybody disagrees with that, then feel free to
suggest alternatives. The QEMU counterpart has been posted[3].

This series is based on Radim's recent posting[4] that improves
the vcpu-request framework. I've tested the series on a couple
AArch64 platforms and compile-tested the arm bits.

[1] https://lists.cs.columbia.edu/pipermail/kvmarm/2017-February/023820.html
[2] https://lists.cs.columbia.edu/pipermail/kvmarm/2016-April/019691.html
[3] http://lists.nongnu.org/archive/html/qemu-devel/2017-02/msg06895.html
[4] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1340496.html

Andrew Jones (4):
  KVM: arm/arm64: prepare to use vcpu requests
  KVM: arm/arm64: replace vcpu->arch.pause with a vcpu-request
  KVM: arm/arm64: replace vcpu->arch.power_off with a vcpu-request
  KVM: arm/arm64: allow userspace to set MPIDR

Levente Kurusa (1):
  KVM: arm/arm64: fix race in kvm_psci_vcpu_on

 arch/arm/include/asm/kvm_emulate.h   |  2 +-
 arch/arm/include/asm/kvm_host.h      | 12 +++----
 arch/arm/kvm/arm.c                   | 49 ++++++++++++++-------------
 arch/arm/kvm/coproc.c                | 61 +++++++++++++++++++++++++++++-----
 arch/arm/kvm/coproc.h                |  6 ++++
 arch/arm/kvm/handle_exit.c           |  1 +
 arch/arm/kvm/psci.c                  | 18 ++++------
 arch/arm64/include/asm/kvm_emulate.h |  2 +-
 arch/arm64/include/asm/kvm_host.h    | 12 +++----
 arch/arm64/kvm/handle_exit.c         |  1 +
 arch/arm64/kvm/sys_regs.c            | 64 ++++++++++++++++++++++++++++--------
 include/linux/kvm_host.h             |  5 +++
 include/uapi/linux/kvm.h             |  1 +
 13 files changed, 162 insertions(+), 72 deletions(-)

-- 
2.9.3

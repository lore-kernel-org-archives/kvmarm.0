From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 0/7]  arm64: KVM: vgic-v2: Allow unsafe GICV accesses
Date: Tue,  6 Sep 2016 09:28:40 +0100
Message-ID: <1473150527-4729-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96CEC49B51
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 04:20:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pvIq-6NGKJ-q for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 04:20:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F3BD49B46
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 04:20:33 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

In a number of cases, KVM cannot give access direct access to the
GICv2 GICV region, either because GICV is not page aligned, or its
size is not a multiple of the page size. This is especially visible
with 16kB/64kB pages and the original GIC-400 layout where each region
is only 4k aligned.

Instead of disabling KVM altogether (which is the current behaviour),
there is some value in trapping each guest GICV access, performing the
access as quickly as possible at EL2, and resuming the guest. This
allows us to keep KVM enabled on this HW.

Implementation wise, this is done with a static key controlling the
workaround being enabled, hence coming at zero cost (well, an extra
nop on the exit hot path) for unaffected platforms. On the affected
HW, I've measured a 10 to 15% overhead for a self-IPI test, which is
pretty bad, but still much better than not having a GIC at all.

There is two pending issues:

- A failed write to GICV ends up being forwarded to userspace. This
  will be addressed in a follow-up series where we deal with injecting
  vSError in the guest

- Skipping instructions (as we do when emulating anything) breaks
  things like guest single-step and watchpoints. This is a long
  standing problem, and someone should probably have a look at
  it. Alex?

Tested on Juno-r1 with 64kB pages.

* From v1:
  - Made the AArch32 conditional code common to both 32 and 64bit
  ports, as well as accessible from EL2 (suggested by Christoffer)
  - Made the workaround message a bit more scary

Marc Zyngier (7):
  arm64: KVM: Move kvm_vcpu_get_condition out of emulate.c
  arm64: KVM: Move the AArch32 conditional execution to common code
  arm: KVM: Use common AArch32 conditional execution code
  arm64: KVM: Make kvm_skip_instr32 available to HYP
  arm64: KVM: vgic-v2: Add the GICV emulation infrastructure
  arm64: KVM: vgic-v2: Add GICV access from HYP
  arm64: KVM: vgic-v2: Enable GICV access from HYP if access from guest
    is unsafe

 arch/arm/include/asm/kvm_emulate.h   |  34 ++++++--
 arch/arm/kvm/Makefile                |   1 +
 arch/arm/kvm/emulate.c               |  99 ----------------------
 arch/arm64/include/asm/kvm_emulate.h |  10 +++
 arch/arm64/include/asm/kvm_hyp.h     |   1 +
 arch/arm64/kvm/Makefile              |   3 +-
 arch/arm64/kvm/emulate.c             | 159 -----------------------------------
 arch/arm64/kvm/hyp/switch.c          |  32 +++++++
 include/kvm/arm_vgic.h               |   6 ++
 virt/kvm/arm/aarch32.c               | 152 +++++++++++++++++++++++++++++++++
 virt/kvm/arm/hyp/vgic-v2-sr.c        |  46 ++++++++++
 virt/kvm/arm/vgic/vgic-v2.c          |  71 ++++++++++------
 12 files changed, 321 insertions(+), 293 deletions(-)
 delete mode 100644 arch/arm64/kvm/emulate.c
 create mode 100644 virt/kvm/arm/aarch32.c

-- 
2.1.4

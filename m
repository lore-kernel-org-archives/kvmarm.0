From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/4] Workaround for Cortex-A76 erratum 1165522
Date: Mon,  5 Nov 2018 14:36:12 +0000
Message-ID: <20181105143617.120602-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3F5C4A30E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Nov 2018 09:36:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YWHmg+3PsFZN for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Nov 2018 09:36:49 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B4DA4A30C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Nov 2018 09:36:49 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Early Cortex-A76 suffer from an erratum that can result in invalid
TLBs when the CPU speculatively executes an AT instruction in the
middle of a guest world switch, while the guest virtual memory
configuration is in an inconsistent state.

We handle this issue by mandating the use of VHE and making sure that
the guest context is fully installed before switching HCR_EL2.TGE to
zero. This ensures that a speculated AT instruction is either executed
on the host context (TGE set) or the guest context (TGE clear), and
that there is no intermediate state.

Marc Zyngier (4):
  KVM: arm64: Rework detection of SVE, !VHE systems
  KVM: arm64: Allow implementations to be confined to using VHE
  arm64: KVM: Install stage-2 translation before enabling traps on VHE
  arm64: KVM: Implement workaround for Cortex-A76 erratum 1165522

 Documentation/arm64/silicon-errata.txt |  1 +
 arch/arm/include/asm/kvm_host.h        |  3 ++-
 arch/arm64/Kconfig                     | 12 ++++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/include/asm/kvm_host.h      | 14 ++++++++++----
 arch/arm64/include/asm/kvm_hyp.h       |  6 ++++++
 arch/arm64/kernel/cpu_errata.c         |  8 ++++++++
 arch/arm64/kvm/hyp/switch.c            | 16 +++++++++++++++-
 virt/kvm/arm/arm.c                     | 17 ++++++++++++-----
 9 files changed, 68 insertions(+), 12 deletions(-)

-- 
2.19.1

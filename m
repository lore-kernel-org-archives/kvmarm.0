From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 0/2] arm64: spectre-v1 write fixes (CVE-2018-3693)
Date: Tue, 10 Jul 2018 19:01:21 +0100
Message-ID: <20180710180123.56461-1-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 337984A0CA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jul 2018 13:48:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WndXDMQwqnVM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Jul 2018 13:48:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E944F4A0C9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jul 2018 13:48:45 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

These patches inhibit spectre-v1-write gadgets found in arch/arm64, using the
same mitigation applied to existing spectre-v1-read gadgets.

This issue is also known as CVE-2018-3693, or "bounds check bypass store".
More details can be found in the Arm Cache Speculation Side-channels
whitepaper, available from the Arm security updates site [1].

Thanks,
Mark.

[1] https://developer.arm.com/support/arm-security-updates/speculative-processor-vulnerability

Mark Rutland (2):
  arm64: fix possible spectre-v1 write in ptrace_hbp_set_event()
  KVM: arm/arm64: vgic: fix possible spectre-v1 write in
    vgic_mmio_write_apr()

 arch/arm64/kernel/ptrace.c       | 19 +++++++++++--------
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  3 +++
 2 files changed, 14 insertions(+), 8 deletions(-)

-- 
2.11.0

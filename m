From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/3] arm64: KVM: Allow direct function calls on VHE
Date: Wed,  9 Jan 2019 13:54:32 +0000
Message-ID: <20190109135435.178664-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16F024A462
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jan 2019 08:54:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r+Ld9mrhL9jh for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jan 2019 08:54:53 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66A074A439
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jan 2019 08:54:53 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

It recently appeared that the nasty hack we use to call a HYP function
on a non-VHE system has an interesting side effect on VHE: We wrap any
such call into a hypercall, losing any form of type checking between
the caller and the callee.

This isn't a big deal if you can guarantee to write code that is
always 100% correct, but it appears that I'm not you.

In order to restore some sanity, let's use the following property: On
a VHE system, it is always possible to call any function directly as
they live in the same address space. We can thus always emit a direct
call, and use a static key to flip from one to the other. As a bonus,
this also sanitizes !VHE systems as we always generate code for noth
revisions of the architecture.

Marc Zyngier (3):
  arm/arm64: KVM: Introduce kvm_call_hyp_ret()
  arm64: KVM: Allow for direct call of HYP functions when using VHE
  arm64: KVM: Drop VHE-specific HYP call stub

 arch/arm/include/asm/kvm_host.h   |  3 +++
 arch/arm64/include/asm/kvm_host.h | 31 ++++++++++++++++++++++++++++++-
 arch/arm64/kvm/debug.c            |  2 +-
 arch/arm64/kvm/hyp.S              |  3 ---
 arch/arm64/kvm/hyp/hyp-entry.S    | 12 ------------
 virt/kvm/arm/arm.c                |  2 +-
 virt/kvm/arm/vgic/vgic-v3.c       |  4 ++--
 7 files changed, 37 insertions(+), 20 deletions(-)

-- 
2.20.1

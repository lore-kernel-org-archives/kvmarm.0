From: James Morse <james.morse@arm.com>
Subject: [PATCH v2 0/4] Fix some KVM/HYP interactions with kprobes
Date: Thu, 24 Jan 2019 16:32:53 +0000
Message-ID: <20190124163257.233929-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55C5A4A3AF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 11:33:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mEZ-b6TsW1Ff for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jan 2019 11:33:14 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BB224A2E7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 11:33:14 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Masami Hiramatsu <mhiramat@kernel.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi guys,

When looking at Masami Hiramatsu's kprobe cleanup series, it occurred
to me the 'no KVM' isn't just about the EL1/EL2  split on non-VHE systems,
but whether KVM is prepared to handle stepping on a breakpoint. It's not.

This labels all the VHE-only KVM functions that run during world switch
with NOKPROBE_SYMBOL(), and always blacklists __hyp_text for kprobes
to cover the common guest entry/exit code.

I anticipate patch 1 going via the KVM tree to avoid conflicts.
Patch 2 will conflict with [0].


I'm not sure what the best thing to do with the hyp-stub is.
Patch 3 moves it to __hyp_text, and patch 4 covers the hibernate fallout
from doing that. We don't have any other mmu-off but not idmap'd text.
Probing the hyp-stub has to be done by address as the symbol names
alias those in the __entry_text, which is blacklisted. (although this
might depend on link order). I think anyone doing this is trying to
shoot themselves in the foot.


Know issues:
* Other regions we should blacklist are the kexec and hibernate 'copy
  everything' code, as the vectors may have been overwritten by the time
  we step on the probe. cpu-suspend needs investigating...


Thanks,

James

[0] lore.kernel.org/r/154753341900.31541.8135985235882849464.stgit@devbox

James Morse (4):
  KVM: arm64: Forbid kprobing of the VHE world-switch code
  arm64: kprobe: Always blacklist the KVM world-switch code
  arm64: hyp-stub: Forbid kprobing of the hyp-stub
  arm64: hibernate: Clean the __hyp_text to PoC after resume

 arch/arm64/kernel/hibernate.c      | 4 +++-
 arch/arm64/kernel/hyp-stub.S       | 2 ++
 arch/arm64/kernel/probes/kprobes.c | 6 +++---
 arch/arm64/kvm/hyp/switch.c        | 5 +++++
 arch/arm64/kvm/hyp/sysreg-sr.c     | 5 +++++
 5 files changed, 18 insertions(+), 4 deletions(-)

-- 
2.20.1

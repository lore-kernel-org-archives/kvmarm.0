From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 0/3] arm/arm64: KVM: Add support for page aging
Date: Thu, 12 Mar 2015 18:16:49 +0000
Message-ID: <1426184212-29333-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D32D48BA6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2015 14:10:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BD8BzUGUJE-6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Mar 2015 14:10:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48DDF48BA2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2015 14:10:35 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

So far, KVM/arm doesn't implement any support for page aging, leading
to rather bad performance when the system is swapping. This short
series implements the required hooks and fault handling to deal with
pages being marked old/young.

The three patches are fairly straightforward:

- First patch changes the range iterator to be able to return a value

- Second patch implements the actual page aging (clearing the AF bit
  in the page tables, and relying on the normal faulting code to set
  the bit again).

- Last patch optimizes the access fault path by only doing the minimum
  to satisfy the fault.

The end result is a system that behaves visibly better under load, as
VM pages don't get evicted that easily.

Based on 4.0-rc3, tested on Seattle and X-Gene.

Also at git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/page-aging

* From v1 [1]:
- Removed all TLBIs from kvm_age_hva_handler, as the core KVM code
  already does use quite a large hammer to nuke the TLBs on its own
- Don't mark old a page that is already old
- Rebased on top of 4.0-rc3

[1]: https://lists.cs.columbia.edu/pipermail/kvmarm/2015-January/013315.html

Marc Zyngier (3):
  arm/arm64: KVM: Allow handle_hva_to_gpa to return a value
  arm/arm64: KVM: Implement Stage-2 page aging
  arm/arm64: KVM: Optimize handling of Access Flag faults

 arch/arm/include/asm/kvm_arm.h    |   1 +
 arch/arm/include/asm/kvm_host.h   |  13 +---
 arch/arm/kvm/mmu.c                | 134 +++++++++++++++++++++++++++++++++++---
 arch/arm/kvm/trace.h              |  48 ++++++++++++++
 arch/arm64/include/asm/esr.h      |   1 +
 arch/arm64/include/asm/kvm_arm.h  |   1 +
 arch/arm64/include/asm/kvm_host.h |  13 +---
 7 files changed, 179 insertions(+), 32 deletions(-)

-- 
2.1.4

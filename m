From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/3] arm/arm64: KVM: SCTLR_EL2/HSCTLR setup fixes
Date: Tue,  6 Jun 2017 19:08:32 +0100
Message-ID: <20170606180835.14421-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4939340C92
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 14:04:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OVgD68gJ5AWG for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Jun 2017 14:04:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0358940962
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 14:04:43 -0400 (EDT)
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

A couple of issues have recently cropped up regarding the way we setup
SCTLR_EL2:

(1) We accidentally zero some RES1 bits. This doesn't have any impact
    on current revision of the architecture, but may have unexpected
    impacts on future revisions.

(2) We set SCTLR_EL2.A (trap on aligned accesses), but don't provide
    any code to handle such trap (we panic). So far, this has never
    been an issue, but GCC 7 has started emiting such accesses, and
    the EL2 code explodes. The best course of action is actually to
    let these accesses take place, as we don't have any particular
    restrictions there.

This short series addresses both issues, and provides (2) for 32bit
ARM as well (though we haven't had any report of that exploding yet).

Marc Zyngier (3):
  arm64: KVM: Preserve RES1 bits in SCTLR_EL2
  arm64: KVM: Allow unaligned accesses at EL2
  arm: KVM: Allow unaligned accesses at HYP

 arch/arm/kvm/init.S             |  5 ++---
 arch/arm64/include/asm/sysreg.h |  4 ++++
 arch/arm64/kvm/hyp-init.S       | 11 +++++++----
 3 files changed, 13 insertions(+), 7 deletions(-)

-- 
2.11.0

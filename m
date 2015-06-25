From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v3 0/2] arm/arm64: KVM: Optimize arm64 fp/simd,
 saves 30-50% on exits
Date: Wed, 24 Jun 2015 17:04:10 -0700
Message-ID: <1435190652-5831-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E1F856F0B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 19:53:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bs7XNKCbIfa3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jun 2015 19:53:33 -0400 (EDT)
Received: from usmailout3.samsung.com (mailout3.w2.samsung.com
 [211.189.100.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 672CB56F0A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 19:53:32 -0400 (EDT)
Received: from uscpsbgex1.samsung.com
 (u122.gpu85.samsung.co.kr [203.254.195.122]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NQH001PG47IZU10@usmailout3.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 24 Jun 2015 20:04:30 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently we save/restore fp/simd on each exit. Fist  patch optimizes arm64
save/restore, we only do so on Guest access. hackbench and
several lmbench tests show anywhere from 30% to above 50% optimzation
achieved.

In second patch 32-bit handler is updated to keep exit handling consistent
with 64-bit code.

Changes since v1:
- Addressed Marcs comments
- Verified optimization improvements with lmbench and hackbench, updated 
  commit message

Changes since v2:
- only for patch 2/2
  - Reworked trapping to vfp access handler

Changes since v3:
- Only for patch 2/2
  - Removed load_vcpu in switch_to_guest_vfp per Marcs comment
  - Got another chance to replace an unreferenced label with a comment


Mario Smarduch (2):
  Optimize arm64 skip 30-50% vfp/simd save/restore on exits
  keep arm vfp/simd exit handling consistent with arm64

 arch/arm/kvm/interrupts.S        |   14 +++++++-----
 arch/arm64/include/asm/kvm_arm.h |    5 ++++-
 arch/arm64/kvm/hyp.S             |   46 +++++++++++++++++++++++++++++++++++---
 3 files changed, 55 insertions(+), 10 deletions(-)

-- 
1.7.9.5

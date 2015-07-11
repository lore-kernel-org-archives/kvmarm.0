From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v4 0/2] arm/arm64: KVM: Optimize arm64 fp/simd,
 saves 30-50% on exits for non-VHE
Date: Fri, 10 Jul 2015 18:19:05 -0700
Message-ID: <1436577547-5646-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F258958615
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 21:07:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 43AwnpunlhJZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jul 2015 21:07:36 -0400 (EDT)
Received: from usmailout1.samsung.com (mailout1.w2.samsung.com
 [211.189.100.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3860158611
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 21:07:35 -0400 (EDT)
Received: from uscpsbgex3.samsung.com
 (u124.gpu85.samsung.co.kr [203.254.195.124]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NRA003VTUC2YP40@mailout1.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 10 Jul 2015 21:19:14 -0400 (EDT)
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
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

This is a followp to previous iteration but implemented on top of VHE patches. 
Only non-VHE path is addressied by this patch. In second patch 32-bit handler 
is updated to keep exit handling consistent with 64-bit code, and nothing
has changed.

Currently we save/restore fp/simd on each exit, the first  patch optimizes 
arm64 save/restore, we only do so on Guest access. hackbench and
several lmbench tests show anywhere from 30% to 50% of exits don't 
save/restore fp/simd register set.

Tested on Foundation Model, unfortuntely not tested yet on VHE enabled model.

Mario Smarduch (2):
  Optimize arm64 non-VHE fpsimd skip 30-50% save/restore on exits
  keep arm vfp/simd exit handling consistent with arm64

 arch/arm/kvm/interrupts.S        | 14 +++++-----
 arch/arm64/include/asm/kvm_arm.h |  5 +++-
 arch/arm64/kvm/hyp.S             | 58 +++++++++++++++++++++++++++++++++++++---
 3 files changed, 66 insertions(+), 11 deletions(-)

-- 
1.9.1

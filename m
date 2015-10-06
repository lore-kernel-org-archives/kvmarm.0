From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v2 0/2] KVM/arm64: add fp/simd lazy switch support
Date: Mon, 05 Oct 2015 19:33:12 -0700
Message-ID: <1444098794-19244-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B928412DD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Oct 2015 22:31:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4fX12zdQvi8R for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Oct 2015 22:31:29 -0400 (EDT)
Received: from usmailout2.samsung.com (mailout2.w2.samsung.com
 [211.189.100.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C174A412D0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Oct 2015 22:31:29 -0400 (EDT)
Received: from uscpsbgex3.samsung.com
 (u124.gpu85.samsung.co.kr [203.254.195.124]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NVS0069X1RLBR70@mailout2.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 05 Oct 2015 22:33:21 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch series is a followup to the armv7 fp/simd lazy switch
implementation, uses similar approach and depends on the series -
https://lists.cs.columbia.edu/pipermail/kvmarm/2015-September/016567.html
Patches are based on 4.3-rc2 commit 1f93e4a96c91093

Patches are based on earlier arm64 fp/simd optimization work -
https://lists.cs.columbia.edu/pipermail/kvmarm/2015-July/015748.html

And subsequent fixes by Marc and Christoffer at KVM Forum hackathon to handle
32-bit guest on 64 bit host - 
https://lists.cs.columbia.edu/pipermail/kvmarm/2015-August/016128.html

The patch series have been tested on Foundation Model arm64/arm64 and
arm32/arm64. The test program used can be found here 

https://github.com/mjsmar/arm-arm64-fpsimd-test

Launched upto 16 instances on 4-way Guest and another 16 on the host (both 
cases 1mS sleep), ran overnight. 

Changes v1->v2:
- Tested arm32/arm64
- rebased to 4.3-rc2
- changed a couple register accesses from 64 to 32 bit 

Mario Smarduch (2):
  add hooks for armv8 fp/simd lazy switch
  enable armv8 fp/simd lazy switch

 arch/arm/kvm/arm.c                |  2 --
 arch/arm64/include/asm/kvm_asm.h  |  1 +
 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kernel/asm-offsets.c   |  1 +
 arch/arm64/kvm/hyp.S              | 59 ++++++++++++++++++++++++++-------------
 5 files changed, 45 insertions(+), 21 deletions(-)

-- 
1.9.1

From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [RFT - PATCH 0/2] KVM/arm64: add fp/simd lazy switch support
Date: Mon, 21 Sep 2015 14:26:21 -0700
Message-ID: <1442870783-30752-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C812B48EEA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2015 17:25:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QxKnrA+KoBB3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Sep 2015 17:25:27 -0400 (EDT)
Received: from usmailout2.samsung.com (mailout2.w2.samsung.com
 [211.189.100.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D77F848EE9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2015 17:25:27 -0400 (EDT)
Received: from uscpsbgex4.samsung.com
 (u125.gpu85.samsung.co.kr [203.254.195.125]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NV100C9MQ8GOM50@mailout2.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 21 Sep 2015 17:26:40 -0400 (EDT)
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
implementation, uses similar approach and depends on the series - see
https://lists.cs.columbia.edu/pipermail/kvmarm/2015-September/016516.html

It's based on earlier arm64 fp/simd optimization work - see
https://lists.cs.columbia.edu/pipermail/kvmarm/2015-July/015748.html

And subsequent fixes by Marc and Christoffer at KVM Forum hackathon to handle
32-bit guest on 64 bit host - see
https://lists.cs.columbia.edu/pipermail/kvmarm/2015-August/016128.html

This series has be tested on arm64/arm64 but not arm32/arm64 which needs
validation (the RFT tag). The results substantially decrease the numbe of
fp/simd context switches for a FP load. 

At this time I don't have arm32/arm64 working and requesting Christoffer and/or 
Marc to test 32 bit guest on 64 bit host.

Mario Smarduch (2):
  add hooks for armv8 fp/simd lazy switch support
  enable armv8 fp/simd lazy switch

 arch/arm/kvm/arm.c                |  2 --
 arch/arm64/include/asm/kvm_asm.h  |  1 +
 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kernel/asm-offsets.c   |  1 +
 arch/arm64/kvm/hyp.S              | 59 ++++++++++++++++++++++++++-------------
 5 files changed, 45 insertions(+), 21 deletions(-)

-- 
1.9.1

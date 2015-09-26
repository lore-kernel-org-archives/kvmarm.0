From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v2 0/2] KVM/arm: enhance arvm7 vfp/simd lazy switch support
Date: Sat, 26 Sep 2015 16:43:27 -0700
Message-ID: <1443311009-4811-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AFEC42F5A
 for <kvmarm@lists.cs.columbia.edu>; Sat, 26 Sep 2015 19:42:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NS8gHVW5-dzx for <kvmarm@lists.cs.columbia.edu>;
 Sat, 26 Sep 2015 19:42:32 -0400 (EDT)
Received: from usmailout3.samsung.com (mailout3.w2.samsung.com
 [211.189.100.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A779542E58
 for <kvmarm@lists.cs.columbia.edu>; Sat, 26 Sep 2015 19:42:32 -0400 (EDT)
Received: from uscpsbgex4.samsung.com
 (u125.gpu85.samsung.co.kr [203.254.195.125]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NVB009QV5XB1480@usmailout3.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Sat, 26 Sep 2015 19:43:59 -0400 (EDT)
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

Current lazy vfp/simd implementation switches hardware context only on 
guest access and again on exit to host, otherwise hardware context is
skipped.

This patch set builds on that functionality and executes a hardware context 
switch only when  vCPU is scheduled out or returns to user space.

Patches were tested on FVP sw platform. FP crunching applications summing up 
values, with outcome compared to known result were executed on several guests, 
and host. 

Changes since v1->v2:
* Fixed vfp/simd trap configuration to enable trace trapping
* Removed set_hcptr branch label
* Fixed handling of FPEXC to restore guest and host versions on vcpu_put

Mario Smarduch (2):
  add hooks for armv7 fp/simd lazy switch support
  enable armv7 fp/simd lazy switch

 arch/arm/include/asm/kvm_asm.h  |  1 +
 arch/arm/include/asm/kvm_host.h |  6 +++++
 arch/arm/kernel/asm-offsets.c   |  2 ++
 arch/arm/kvm/arm.c              | 17 ++++++++++++
 arch/arm/kvm/interrupts.S       | 60 ++++++++++++++++++++++++++++++-----------
 arch/arm/kvm/interrupts_head.S  | 12 ++++++---
 6 files changed, 79 insertions(+), 19 deletions(-)

-- 
1.9.1

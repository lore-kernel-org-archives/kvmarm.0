From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH 0/2] KVM/arm: add fp/simd lazy switch support
Date: Thu, 17 Sep 2015 18:05:15 -0700
Message-ID: <1442538317-13618-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7339431BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2015 21:04:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Uq5TI-YpwtBB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Sep 2015 21:04:18 -0400 (EDT)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 11FF242E5B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2015 21:04:17 -0400 (EDT)
Received: from uscpsbgex2.samsung.com
 (u123.gpu85.samsung.co.kr [203.254.195.123]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NUU003GSLOWQZ30@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 17 Sep 2015 21:05:20 -0400 (EDT)
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

These patches enable armv7 fp/simd lazy switch. On guest entry fp/simd
access trap is set, and on guest first access fp/simd registers are switched -
host saved, guest restored. CPU continues with guest fp/simd content until
vcpu_put where guest is saved and host is restored. 

Running floating point workload illustrates reduction of fp/simd context 
switches the amount depends on the load. For a light load with with FP 
application running only 2% of all exits result in calls to lazy switch.

arm64 version is in test and appears to work fine, remaining work is
boot arm32 guest on arm64 and verify operation. Initial intent was to post
all patches at once, but arm64 version will be posted soon.

Mario Smarduch (2):
  add hooks for armv7 vfp/simd lazy switch support
  enable armv7 vfp/simd lazy switch

 arch/arm/include/asm/kvm_asm.h  |  1 +
 arch/arm/include/asm/kvm_host.h |  3 +++
 arch/arm/kernel/asm-offsets.c   |  1 +
 arch/arm/kvm/arm.c              | 17 +++++++++++++++++
 arch/arm/kvm/interrupts.S       | 40 +++++++++++++++++++++++++++++-----------
 5 files changed, 51 insertions(+), 11 deletions(-)

-- 
1.9.1

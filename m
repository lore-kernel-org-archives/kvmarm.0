From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 03/12] KVM: arm/arm64: remove now unneeded include directory
 from Makefile
Date: Fri, 13 Mar 2015 16:10:03 +0000
Message-ID: <1426263012-22935-4-git-send-email-andre.przywara@arm.com>
References: <1426263012-22935-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A124448C42
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Mar 2015 12:03:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lCucr17vkcdu for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Mar 2015 12:03:49 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B38F48C38
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Mar 2015 12:03:48 -0400 (EDT)
In-Reply-To: <1426263012-22935-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, pbonzini@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

virt/kvm was never really a good include directory for anything else
than locally included headers.
With the move of iodev.h there is no need anymore to add this
directory the compiler's include path, so remove it from the arm and
arm64 kvm Makefile.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm/kvm/Makefile   |    2 +-
 arch/arm64/kvm/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index a093bf1..139e46c 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -7,7 +7,7 @@ ifeq ($(plus_virt),+virt)
 	plus_virt_def := -DREQUIRES_VIRT=1
 endif
 
-ccflags-y += -Ivirt/kvm -Iarch/arm/kvm
+ccflags-y += -Iarch/arm/kvm
 CFLAGS_arm.o := -I. $(plus_virt_def)
 CFLAGS_mmu.o := -I.
 
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index b22c636..d5904f8 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -2,7 +2,7 @@
 # Makefile for Kernel-based Virtual Machine module
 #
 
-ccflags-y += -Ivirt/kvm -Iarch/arm64/kvm
+ccflags-y += -Iarch/arm64/kvm
 CFLAGS_arm.o := -I.
 CFLAGS_mmu.o := -I.
 
-- 
1.7.9.5

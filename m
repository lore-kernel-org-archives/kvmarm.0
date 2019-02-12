From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] KVM: arm/arm64: Update MAINTAINERS entries
Date: Tue, 12 Feb 2019 11:06:48 +0000
Message-ID: <20190212110648.177490-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B42C94A2E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Feb 2019 06:07:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nXXdP1NzS-wT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Feb 2019 06:07:02 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C382E49F94
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Feb 2019 06:07:02 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

For historical reasons, KVM/arm and KVM/arm64 have had different
entries in the MAINTAINER file. This makes little sense, as they are
maintained together.

On top of that, we have a bunch of talented people helping with
the reviewing, and they deserve to be mentionned in the consolidated
entry.

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 MAINTAINERS | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 51029a425dbe..91ec0682443b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8297,29 +8297,25 @@ S:	Maintained
 F:	arch/x86/include/asm/svm.h
 F:	arch/x86/kvm/svm.c
 
-KERNEL VIRTUAL MACHINE FOR ARM (KVM/arm)
+KERNEL VIRTUAL MACHINE FOR ARM/ARM64 (KVM/arm, KVM/arm64)
 M:	Christoffer Dall <christoffer.dall@arm.com>
 M:	Marc Zyngier <marc.zyngier@arm.com>
+R:	James Morse <james.morse@arm.com>
+R:	Julien Thierry <julien.thierry@arm.com>
+R:	Suzuki Pouloze <suzuki.poulose@arm.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	kvmarm@lists.cs.columbia.edu
 W:	http://systems.cs.columbia.edu/projects/kvm-arm
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
-S:	Supported
+S:	Maintained
 F:	arch/arm/include/uapi/asm/kvm*
 F:	arch/arm/include/asm/kvm*
 F:	arch/arm/kvm/
-F:	virt/kvm/arm/
-F:	include/kvm/arm_*
-
-KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)
-M:	Christoffer Dall <christoffer.dall@arm.com>
-M:	Marc Zyngier <marc.zyngier@arm.com>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-L:	kvmarm@lists.cs.columbia.edu
-S:	Maintained
 F:	arch/arm64/include/uapi/asm/kvm*
 F:	arch/arm64/include/asm/kvm*
 F:	arch/arm64/kvm/
+F:	virt/kvm/arm/
+F:	include/kvm/arm_*
 
 KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
 M:	James Hogan <jhogan@kernel.org>
-- 
2.20.1

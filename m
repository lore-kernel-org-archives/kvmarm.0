From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v2 2/7] arm64: KVM: Move vgic-v3 save/restore to
 virt/kvm/arm/hyp
Date: Tue, 16 Aug 2016 11:46:53 +0100
Message-ID: <1471344418-19568-3-git-send-email-vladimir.murzin@arm.com>
References: <1471344418-19568-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A865449B44
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2016 06:39:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gY0gWqdYw36t for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Aug 2016 06:39:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8299749B30
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2016 06:39:46 -0400 (EDT)
In-Reply-To: <1471344418-19568-1-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

So we can reuse the code under arch/arm

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm64/kvm/hyp/Makefile                       |    2 +-
 {arch/arm64/kvm => virt/kvm/arm}/hyp/vgic-v3-sr.c |    0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename {arch/arm64/kvm => virt/kvm/arm}/hyp/vgic-v3-sr.c (100%)

diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 0c85feb..aaf42ae 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -5,9 +5,9 @@
 KVM=../../../../virt/kvm
 
 obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v2-sr.o
+obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v3-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/timer-sr.o
 
-obj-$(CONFIG_KVM_ARM_HOST) += vgic-v3-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += sysreg-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += debug-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += entry.o
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
similarity index 100%
rename from arch/arm64/kvm/hyp/vgic-v3-sr.c
rename to virt/kvm/arm/hyp/vgic-v3-sr.c
-- 
1.7.9.5

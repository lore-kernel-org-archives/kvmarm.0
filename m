From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 22/27] KVM: arm/arm64: Update MAINTAINERS entries
Date: Fri, 22 Feb 2019 16:26:00 +0000
Message-ID: <20190222162605.5054-23-marc.zyngier@arm.com>
References: <20190222162605.5054-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 910964A2E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:28:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bbFpdJErJF1S for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 11:28:52 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 101E64A36B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:28:52 -0500 (EST)
In-Reply-To: <20190222162605.5054-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Daniel Lezcano <daniel.lezcano@linaro.org>, kvmarm@lists.cs.columbia.edu, Shaokun Zhang <zhangshaokun@hisilicon.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-arm-kernel@lists.infradead.org, Zenghui Yu <yuzenghui@huawei.com>, Colin Ian King <colin.king@canonical.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

For historical reasons, KVM/arm and KVM/arm64 have had different
entries in the MAINTAINER file. This makes little sense, as they are
maintained together.

On top of that, we have a bunch of talented people helping with
the reviewing, and they deserve to be mentioned in the consolidated
entry.

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Acked-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 MAINTAINERS | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 51029a425dbe..5d68f050d155 100644
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
+R:	Suzuki K Pouloze <suzuki.poulose@arm.com>
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

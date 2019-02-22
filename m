From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 21/27] KVM: arm/arm64: Prefix header search paths with
 $(srctree)/
Date: Fri, 22 Feb 2019 16:25:59 +0000
Message-ID: <20190222162605.5054-22-marc.zyngier@arm.com>
References: <20190222162605.5054-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67C824A331
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:28:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Leli2SDfx-6U for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 11:28:47 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0BFD4A369
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:28:46 -0500 (EST)
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

From: Masahiro Yamada <yamada.masahiro@socionext.com>

Currently, the Kbuild core manipulates header search paths in a crazy
way [1].

To fix this mess, I want all Makefiles to add explicit $(srctree)/ to
the search paths in the srctree. Some Makefiles are already written in
that way, but not all. The goal of this work is to make the notation
consistent, and finally get rid of the gross hacks.

Having whitespaces after -I does not matter since commit 48f6e3cf5bc6
("kbuild: do not drop -I without parameter").

[1]: https://patchwork.kernel.org/patch/9632347/

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/Makefile   | 2 +-
 arch/arm64/kvm/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index bca775e222c3..531e59f5be9c 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -8,7 +8,7 @@ ifeq ($(plus_virt),+virt)
 	plus_virt_def := -DREQUIRES_VIRT=1
 endif
 
-ccflags-y += -Iarch/arm/kvm -Ivirt/kvm/arm/vgic
+ccflags-y += -I $(srctree)/$(src) -I $(srctree)/virt/kvm/arm/vgic
 CFLAGS_arm.o := $(plus_virt_def)
 
 AFLAGS_init.o := -Wa,-march=armv7-a$(plus_virt)
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 3089b3159135..690e033a91c0 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -3,7 +3,7 @@
 # Makefile for Kernel-based Virtual Machine module
 #
 
-ccflags-y += -Iarch/arm64/kvm -Ivirt/kvm/arm/vgic
+ccflags-y += -I $(srctree)/$(src) -I $(srctree)/virt/kvm/arm/vgic
 
 KVM=../../../virt/kvm
 
-- 
2.20.1

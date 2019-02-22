From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 20/27] KVM: arm/arm64: Remove -I. header search paths
Date: Fri, 22 Feb 2019 16:25:58 +0000
Message-ID: <20190222162605.5054-21-marc.zyngier@arm.com>
References: <20190222162605.5054-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3F484A2E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:28:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oFMUhzo4cVFu for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 11:28:42 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 262DE4A36B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:28:42 -0500 (EST)
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

The header search path -I. in kernel Makefiles is very suspicious;
it allows the compiler to search for headers in the top of $(srctree),
where obviously no header file exists.

I was able to build without these extra header search paths.

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/Makefile   | 3 +--
 arch/arm64/kvm/Makefile | 2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index 48de846f2246..bca775e222c3 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -9,8 +9,7 @@ ifeq ($(plus_virt),+virt)
 endif
 
 ccflags-y += -Iarch/arm/kvm -Ivirt/kvm/arm/vgic
-CFLAGS_arm.o := -I. $(plus_virt_def)
-CFLAGS_mmu.o := -I.
+CFLAGS_arm.o := $(plus_virt_def)
 
 AFLAGS_init.o := -Wa,-march=armv7-a$(plus_virt)
 AFLAGS_interrupts.o := -Wa,-march=armv7-a$(plus_virt)
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 0f2a135ba15b..3089b3159135 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -4,8 +4,6 @@
 #
 
 ccflags-y += -Iarch/arm64/kvm -Ivirt/kvm/arm/vgic
-CFLAGS_arm.o := -I.
-CFLAGS_mmu.o := -I.
 
 KVM=../../../virt/kvm
 
-- 
2.20.1

From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 2/3] KVM: arm/arm64: remove -I. header search paths
Date: Fri, 25 Jan 2019 16:57:29 +0900
Message-ID: <1548403050-6585-3-git-send-email-yamada.masahiro@socionext.com>
References: <1548403050-6585-1-git-send-email-yamada.masahiro@socionext.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1548403050-6585-1-git-send-email-yamada.masahiro@socionext.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org, Masahiro Yamada <yamada.masahiro@socionext.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The header search path -I. in kernel Makefiles is very suspicious;
it allows the compiler to search for headers in the top of $(srctree),
where obviously no header file exists.

I was able to build without these extra header search paths.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 arch/arm/kvm/Makefile   | 3 +--
 arch/arm64/kvm/Makefile | 2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index 48de846..bca775e 100644
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
index 0f2a135..3089b31 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -4,8 +4,6 @@
 #
 
 ccflags-y += -Iarch/arm64/kvm -Ivirt/kvm/arm/vgic
-CFLAGS_arm.o := -I.
-CFLAGS_mmu.o := -I.
 
 KVM=../../../virt/kvm
 
-- 
2.7.4

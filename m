From: Abbott Liu <liuwenliang@huawei.com>
Subject: [PATCH v5 2/6] Disable instrumentation for some code
Date: Tue, 5 Jun 2018 14:14:12 +0800
Message-ID: <20180605061416.18690-3-liuwenliang__5764.84728740088$1528180551$gmane$org@huawei.com>
References: <20180605061416.18690-1-liuwenliang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C02764A0C8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jun 2018 02:25:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SQDRZdWrZAwl for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jun 2018 02:24:43 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 521E04A0E8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jun 2018 02:24:43 -0400 (EDT)
In-Reply-To: <20180605061416.18690-1-liuwenliang@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: aryabinin@virtuozzo.com, glider@google.com, dvyukov@google.com, corbet@lwn.net, linux@armlinux.org.uk, christoffer.dall@arm.com, marc.zyngier@arm.com, arnd@arndb.de, nicolas.pitre@linaro.org, vladimir.murzin@arm.com, keescook@chromium.org, jinb.park7@gmail.com, alexandre.belloni@bootlin.com, ard.biesheuvel@linaro.org, daniel.lezcano@linaro.org, pombredanne@nexb.com, kstewart@linuxfoundation.org, liuwenliang@huawei.com, rob@landley.net, gregkh@linuxfoundation.org, f.fainelli@gmail.com, mawilcox@microsoft.com, akpm@linux-foundation.org, mark.rutland@arm.com, catalin.marinas@arm.com, yamada.masahiro@socionext.com, alexander.levin@verizon.com, tglx@linutronix.de, thgarnie@google.com, dhowells@redhat.com, geert@linux-m68k.org, andre.przywara@arm.com, julien.thierry@arm.com, drjones@redhat.com, philip@cog.sys
Cc: a.ryabinin@samsung.com, ryabinin.a.a@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Andrey Ryabinin <aryabinin@virtuozzo.com>

Disable instrumentation for arch/arm/boot/compressed/*
and arch/arm/vdso/* because those code won't linkd with
kernel image.

Disable instrumentation for arch/arm/kvm/hyp/*. See commit a6cdf1c08cbf
("kvm: arm64: Disable compiler instrumentation for hypervisor code")
for more details.

Disable instrumentation for arch/arm/mm/physaddr.c. See
commit ec6d06efb0ba ("arm64: Add support for CONFIG_DEBUG_VIRTUAL")
for more details.

Disable kasan check in the function unwind_pop_register
because it doesn't matter that kasan checks failed when
unwind_pop_register read stack memory of task.

Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Reported-by: Marc Zyngier <marc.zyngier@arm.com>
Tested-by: Joel Stanley <joel@jms.id.au>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Abbott Liu <liuwenliang@huawei.com>
Signed-off-by: Abbott Liu <liuwenliang@huawei.com>
---
 arch/arm/boot/compressed/Makefile | 1 +
 arch/arm/kernel/unwind.c          | 3 ++-
 arch/arm/kvm/hyp/Makefile         | 4 ++++
 arch/arm/mm/Makefile              | 1 +
 arch/arm/vdso/Makefile            | 2 ++
 5 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 6a4e734..b29e0a3 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -24,6 +24,7 @@ OBJS		+= hyp-stub.o
 endif
 
 GCOV_PROFILE		:= n
+KASAN_SANITIZE		:= n
 
 #
 # Architecture dependencies
diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index 0bee233..2e55c7d 100644
--- a/arch/arm/kernel/unwind.c
+++ b/arch/arm/kernel/unwind.c
@@ -249,7 +249,8 @@ static int unwind_pop_register(struct unwind_ctrl_block *ctrl,
 		if (*vsp >= (unsigned long *)ctrl->sp_high)
 			return -URC_FAILURE;
 
-	ctrl->vrs[reg] = *(*vsp)++;
+	ctrl->vrs[reg] = READ_ONCE_NOCHECK(*(*vsp));
+	(*vsp)++;
 	return URC_OK;
 }
 
diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
index 7fc0638..1bd89ed 100644
--- a/arch/arm/kvm/hyp/Makefile
+++ b/arch/arm/kvm/hyp/Makefile
@@ -23,3 +23,7 @@ obj-$(CONFIG_KVM_ARM_HOST) += hyp-entry.o
 obj-$(CONFIG_KVM_ARM_HOST) += switch.o
 CFLAGS_switch.o		   += $(CFLAGS_ARMV7VE)
 obj-$(CONFIG_KVM_ARM_HOST) += s2-setup.o
+
+GCOV_PROFILE	:= n
+KASAN_SANITIZE	:= n
+UBSAN_SANITIZE	:= n
diff --git a/arch/arm/mm/Makefile b/arch/arm/mm/Makefile
index 9dbb849..c056e17 100644
--- a/arch/arm/mm/Makefile
+++ b/arch/arm/mm/Makefile
@@ -16,6 +16,7 @@ endif
 obj-$(CONFIG_ARM_PTDUMP_CORE)	+= dump.o
 obj-$(CONFIG_ARM_PTDUMP_DEBUGFS)	+= ptdump_debugfs.o
 obj-$(CONFIG_MODULES)		+= proc-syms.o
+KASAN_SANITIZE_physaddr.o	:= n
 obj-$(CONFIG_DEBUG_VIRTUAL)	+= physaddr.o
 
 obj-$(CONFIG_ALIGNMENT_TRAP)	+= alignment.o
diff --git a/arch/arm/vdso/Makefile b/arch/arm/vdso/Makefile
index bb411821..87abbb7 100644
--- a/arch/arm/vdso/Makefile
+++ b/arch/arm/vdso/Makefile
@@ -30,6 +30,8 @@ CFLAGS_vgettimeofday.o = -O2
 # Disable gcov profiling for VDSO code
 GCOV_PROFILE := n
 
+KASAN_SANITIZE := n
+
 # Force dependency
 $(obj)/vdso.o : $(obj)/vdso.so
 
-- 
2.9.0

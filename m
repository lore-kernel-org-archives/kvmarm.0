Return-Path: <SRS0=vHWX=7L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1628DC433E1
	for <kvmarm@archiver.kernel.org>; Fri, 29 May 2020 16:01:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C2EF9207BC
	for <kvmarm@archiver.kernel.org>; Fri, 29 May 2020 16:01:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="fpP1nSMq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2EF9207BC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B8524B281;
	Fri, 29 May 2020 12:01:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id buT8gijMRwrA; Fri, 29 May 2020 12:01:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68FB74B2A8;
	Fri, 29 May 2020 12:01:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBA3B4B28E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2020 12:01:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8-8O5td2yeKC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 May 2020 12:01:48 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 227AF4B2A4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2020 12:01:46 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 53661208B8;
 Fri, 29 May 2020 16:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590768105;
 bh=LZ30L6JfHr68OqgXl/j/De7pkTJdoqp2orMzu9RwlW8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=fpP1nSMqOUm1aBOcQsQHfU9QtUiBarRbXGHm1YHZYo93oGxjlPIcV+0NSTUcl/unn
 3bD0sRibgWrrVVHSqk74YROKgQGnQcM4zQ7DgJrG8Trjc12/Q1hhSR0+25vdkfHron
 u00q6GqnNJK04vXQ7vLiMAR4kB91GUqkiG7bTE6Y=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jehS3-00GJKc-PJ; Fri, 29 May 2020 17:01:43 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 05/24] KVM: arm64: Clean up kvm makefiles
Date: Fri, 29 May 2020 17:01:02 +0100
Message-Id: <20200529160121.899083-6-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529160121.899083-1-maz@kernel.org>
References: <20200529160121.899083-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 ascull@google.com, ardb@kernel.org, christoffer.dall@arm.com,
 dbrazdil@google.com, tabba@google.com, james.morse@arm.com, giangyi@amazon.com,
 zhukeqian1@huawei.com, mark.rutland@arm.com, suzuki.poulose@arm.com,
 will@kernel.org, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Jiang Yi <giangyi@amazon.com>,
 Ard Biesheuvel <ardb@kernel.org>, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Fuad Tabba <tabba@google.com>

Consolidate references to the CONFIG_KVM configuration item to encompass
entire folders rather than per line.

Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20200505154520.194120-5-tabba@google.com
---
 arch/arm64/kvm/Makefile     | 38 +++++++++++++------------------------
 arch/arm64/kvm/hyp/Makefile | 15 ++++-----------
 2 files changed, 17 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 419696e615b3..8d3d9513cbfe 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -10,30 +10,18 @@ KVM=../../../virt/kvm
 obj-$(CONFIG_KVM) += kvm.o
 obj-$(CONFIG_KVM) += hyp/
 
-kvm-$(CONFIG_KVM) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
-kvm-$(CONFIG_KVM) += $(KVM)/eventfd.o $(KVM)/vfio.o $(KVM)/irqchip.o
-kvm-$(CONFIG_KVM) += arm.o mmu.o mmio.o
-kvm-$(CONFIG_KVM) += psci.o perf.o
-kvm-$(CONFIG_KVM) += hypercalls.o
-kvm-$(CONFIG_KVM) += pvtime.o
+kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
+	 $(KVM)/vfio.o $(KVM)/irqchip.o \
+	 arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
+	 inject_fault.o regmap.o va_layout.o hyp.o hyp-init.o handle_exit.o \
+	 guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o \
+	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
+	 aarch32.o arch_timer.o \
+	 vgic/vgic.o vgic/vgic-init.o \
+	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
+	 vgic/vgic-v3.o vgic/vgic-v4.o \
+	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
+	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
+	 vgic/vgic-its.o vgic/vgic-debug.o
 
-kvm-$(CONFIG_KVM) += inject_fault.o regmap.o va_layout.o
-kvm-$(CONFIG_KVM) += hyp.o hyp-init.o handle_exit.o
-kvm-$(CONFIG_KVM) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
-kvm-$(CONFIG_KVM) += vgic-sys-reg-v3.o fpsimd.o pmu.o
-kvm-$(CONFIG_KVM) += aarch32.o
-kvm-$(CONFIG_KVM) += arch_timer.o
 kvm-$(CONFIG_KVM_ARM_PMU)  += pmu-emul.o
-
-kvm-$(CONFIG_KVM) += vgic/vgic.o
-kvm-$(CONFIG_KVM) += vgic/vgic-init.o
-kvm-$(CONFIG_KVM) += vgic/vgic-irqfd.o
-kvm-$(CONFIG_KVM) += vgic/vgic-v2.o
-kvm-$(CONFIG_KVM) += vgic/vgic-v3.o
-kvm-$(CONFIG_KVM) += vgic/vgic-v4.o
-kvm-$(CONFIG_KVM) += vgic/vgic-mmio.o
-kvm-$(CONFIG_KVM) += vgic/vgic-mmio-v2.o
-kvm-$(CONFIG_KVM) += vgic/vgic-mmio-v3.o
-kvm-$(CONFIG_KVM) += vgic/vgic-kvm-device.o
-kvm-$(CONFIG_KVM) += vgic/vgic-its.o
-kvm-$(CONFIG_KVM) += vgic/vgic-debug.o
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 8229e47ba870..8c9880783839 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -6,17 +6,10 @@
 ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING \
 		$(DISABLE_STACKLEAK_PLUGIN)
 
-obj-$(CONFIG_KVM) += vgic-v3-sr.o
-obj-$(CONFIG_KVM) += timer-sr.o
-obj-$(CONFIG_KVM) += aarch32.o
-obj-$(CONFIG_KVM) += vgic-v2-cpuif-proxy.o
-obj-$(CONFIG_KVM) += sysreg-sr.o
-obj-$(CONFIG_KVM) += debug-sr.o
-obj-$(CONFIG_KVM) += entry.o
-obj-$(CONFIG_KVM) += switch.o
-obj-$(CONFIG_KVM) += fpsimd.o
-obj-$(CONFIG_KVM) += tlb.o
-obj-$(CONFIG_KVM) += hyp-entry.o
+obj-$(CONFIG_KVM) += hyp.o
+
+hyp-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o sysreg-sr.o \
+	 debug-sr.o entry.o switch.o fpsimd.o tlb.o hyp-entry.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

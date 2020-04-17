Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE4FFC2D0EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 13:58:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 83C0821D6C
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 13:58:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="SBJTzZpq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 83C0821D6C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C8734B296;
	Fri, 17 Apr 2020 09:58:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 570ZYtiXOwPI; Fri, 17 Apr 2020 09:58:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BD9A4B256;
	Fri, 17 Apr 2020 09:58:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 015234B1FE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 09:58:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1vDuVhrLsDNx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 09:58:18 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 567024B177
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 09:58:17 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id u4so1036566wrm.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 06:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=bJqUnSoWANSCWdbLRNIEnNYKcollKcvJOm58uLKYs6E=;
 b=SBJTzZpqCfVVDK5i4j/zbD162RUvdE9yu8jsPueUd6aFKELwola3+IW/af2Dvtdgc+
 1R2S+7T5w4aHwPVYlSZlGul/vyLQVjPxmQvSwu3tJYiiH0s1QW8eSDrISgnQq4WtVpWr
 oN0mXIQYRm12dKfvjseW84ngKSDvG7mTIMkdlSJISNr95k5QUlE8/2jlxwWNMzzd0E3e
 o7k7FJ7EDhn98mabrOFitCOXOygpLx600AZl8DRsoa5g4OnwWpTq+zIZ/Gq76H9ZOJIO
 7fSkH/gID4qrvXC8CXj48kuR4ZAZJdVhUNyfcmhwhNCIj/ewHI29VXZ7e1aRCHgqhgst
 KxCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=bJqUnSoWANSCWdbLRNIEnNYKcollKcvJOm58uLKYs6E=;
 b=pbyo1q8+eh9WfAUKsp7o+qxVTqEyGSK+6VQDmqqb710LQCDqCVjmofyQxdKy+BF0ma
 altq4GW6JiRhiqrVP8sQBTo3esXGWoTFODr1PBlvMFPJr3gmBWAUIqXlIlP2Cs4HVCBG
 dAgMw5KnZAE3RcdaKrODDt5WevXtJATh7Npr4WMqIHYcDR7vwNXEso+vqXfQcax4VePp
 TYJbHmGQI8oNg293XrdWHorK6gm83kCtFjtga+8KrROqzd5+hROszErzbV9xeqK2C+Qd
 yG5XaI/iprW1YhIGobhPqDS2h0f9AzZ5GYz9V3w54KyCh0EJkz/oKVj6HueG+UfjDkkY
 gUmg==
X-Gm-Message-State: AGi0PubY274cdroBIBGnLec+F7nCMdNdUBgDvRXnIVDIoW30gpYAemSh
 dBpuKL7m3ScZNzfr9UHv9IBOO3eHiw==
X-Google-Smtp-Source: APiQypIMhqMA1UdKORBgj5iC56kau/PG1ijt5pgb5Hz+uO0ojlGc/zqOaNOoSHftOUSvHHni/LCB3Ucw6g==
X-Received: by 2002:adf:e711:: with SMTP id c17mr2439841wrm.334.1587131896431; 
 Fri, 17 Apr 2020 06:58:16 -0700 (PDT)
Date: Fri, 17 Apr 2020 14:58:01 +0100
In-Reply-To: <20200417135801.82871-1-tabba@google.com>
Message-Id: <20200417135801.82871-5-tabba@google.com>
Mime-Version: 1.0
References: <20200417135801.82871-1-tabba@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v2 4/4] KVM: arm64: Clean up kvm makefiles
From: Fuad Tabba <tabba@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, julien.thierry.kdev@gmail.com, 
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu
Cc: will@kernel.org
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

Consolidate references to the CONFIG_KVM configuration item to encompass
entire folders rather than per line.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/Makefile     | 40 ++++++++++++-------------------------
 arch/arm64/kvm/hyp/Makefile | 15 ++++----------
 2 files changed, 17 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index a5334b91729a..5354ca1b1bfb 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -10,30 +10,16 @@ KVM=../../../virt/kvm
 obj-$(CONFIG_KVM) += kvm.o
 obj-$(CONFIG_KVM) += hyp/
 
-kvm-$(CONFIG_KVM) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
-kvm-$(CONFIG_KVM) += $(KVM)/eventfd.o $(KVM)/vfio.o $(KVM)/irqchip.o
-kvm-$(CONFIG_KVM) += arm.o mmu.o mmio.o
-kvm-$(CONFIG_KVM) += psci.o perf.o
-kvm-$(CONFIG_KVM) += hypercalls.o
-kvm-$(CONFIG_KVM) += pvtime.o
-
-kvm-$(CONFIG_KVM) += inject_fault.o regmap.o va_layout.o
-kvm-$(CONFIG_KVM) += hyp.o hyp-init.o handle_exit.o
-kvm-$(CONFIG_KVM) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
-kvm-$(CONFIG_KVM) += vgic-sys-reg-v3.o fpsimd.o pmu.o
-kvm-$(CONFIG_KVM) += aarch32.o
-kvm-$(CONFIG_KVM) += arch_timer.o
-kvm-$(CONFIG_KVM)  += pmu-emul.o
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
+kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
+	 $(KVM)/vfio.o $(KVM)/irqchip.o \
+	 arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
+	 inject_fault.o regmap.o va_layout.o hyp.o hyp-init.o handle_exit.o \
+	 guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o \
+	 vgic-sys-reg-v3.o fpsimd.o pmu.o pmu-emul.o \
+	 aarch32.o arch_timer.o \
+	 vgic/vgic.o vgic/vgic-init.o \
+	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
+	 vgic/vgic-v3.o vgic/vgic-v4.o \
+	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
+	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
+	 vgic/vgic-its.o vgic/vgic-debug.o
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 8229e47ba870..529aecbd0231 100644
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
+  	 debug-sr.o entry.o switch.o fpsimd.o tlb.o hyp-entry.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
-- 
2.26.1.301.g55bc3eb7cb9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

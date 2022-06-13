Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDDE9C43334
	for <kvmarm@archiver.kernel.org>; Tue, 14 Jun 2022 08:16:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DD8A49E5F;
	Tue, 14 Jun 2022 04:16:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@nifty.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rjcLT1mal+g4; Tue, 14 Jun 2022 04:16:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55DC04B1C4;
	Tue, 14 Jun 2022 04:16:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB1CC4B388
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jun 2022 05:21:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2bu8Adb+ELvS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jun 2022 05:21:11 -0400 (EDT)
Received: from conuserg-11.nifty.com (conuserg-11.nifty.com [210.131.2.78])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B48B34B0B6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jun 2022 05:21:10 -0400 (EDT)
Received: from grover.sesame (133-32-177-133.west.xps.vectant.ne.jp
 [133.32.177.133]) (authenticated)
 by conuserg-11.nifty.com with ESMTP id 25D9Kgx7000823;
 Mon, 13 Jun 2022 18:20:42 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-11.nifty.com 25D9Kgx7000823
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
 s=dec2015msa; t=1655112043;
 bh=sUeQiGOXKyxAl0UcjFY0Rce/KrFiD5fobjE1eCXei3Y=;
 h=From:To:Cc:Subject:Date:From;
 b=tg5xx0WFjhtsWOYFCUHrzxlt1EIpxO7a0yE3L3du7kUgVp1E6TLXPi6gpOO04yr2e
 D7SWOpfowWBJbLp8NGBXeol+tTlojiNCRSaqVW0XzexYzV8LBN19Hu50s+wf82sz6t
 DGTw6LTVPBmGRZ7SLoQaN3EehFvjTU2fu7QS1L1diREfr7VD9gT9s/1wFAE7wcZ44a
 rbxJGz2RA2pn8neAKkszhzUo10+z27U6iRV+E9RB1AgKaTY2WA1N3nmS6wyL5scb1n
 ph9G/7oG8TJZyC1DTUI9mUtu1GVO9UY18PryP5+LxfwP2Lp/vp0Jc4B5vb3loDBmJc
 FmI3ACPNrSOLg==
X-Nifty-SrcIP: [133.32.177.133]
From: Masahiro Yamada <masahiroy@kernel.org>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH 1/2] KVM: arm64: nvhe: rename confusing obj-y
Date: Mon, 13 Jun 2022 18:20:25 +0900
Message-Id: <20220613092026.1705630-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Mailman-Approved-At: Tue, 14 Jun 2022 04:16:17 -0400
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Masahiro Yamada <masahiroy@kernel.org>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>
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

This Makefile appends several objects to obj-y from line 15, but none
of them is linked to vmlinux in an ordinary way.

obj-y is overwritten at line 30:

  obj-y := kvm_nvhe.o

So, kvm_nvhe.o is the only object directly linked to vmlinux.

Replace the abused obj-y with hyp-obj-y.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 arch/arm64/kvm/hyp/nvhe/Makefile | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index f9fe4dc21b1f..3c6d3a18171c 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -12,13 +12,13 @@ HOST_EXTRACFLAGS += -I$(objtree)/include
 lib-objs := clear_page.o copy_page.o memcpy.o memset.o
 lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
+hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
 	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o
-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
+hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
-obj-$(CONFIG_DEBUG_LIST) += list_debug.o
-obj-y += $(lib-objs)
+hyp-obj-$(CONFIG_DEBUG_LIST) += list_debug.o
+hyp-obj-y += $(lib-objs)
 
 ##
 ## Build rules for compiling nVHE hyp code
@@ -26,7 +26,7 @@ obj-y += $(lib-objs)
 ## file containing all nVHE hyp code and data.
 ##
 
-hyp-obj := $(patsubst %.o,%.nvhe.o,$(obj-y))
+hyp-obj := $(patsubst %.o,%.nvhe.o,$(hyp-obj-y))
 obj-y := kvm_nvhe.o
 extra-y := $(hyp-obj) kvm_nvhe.tmp.o kvm_nvhe.rel.o hyp.lds hyp-reloc.S hyp-reloc.o
 
-- 
2.32.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

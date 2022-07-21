Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6222AC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 05:57:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18B9A4DA57;
	Thu, 21 Jul 2022 01:57:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XyWRGd-6ktkN; Thu, 21 Jul 2022 01:57:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D47824DA4B;
	Thu, 21 Jul 2022 01:57:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D6394DA37
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:57:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GcyMBZV3Gqqx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 01:57:52 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 304884DA56
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:57:51 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-31e65a848daso6592117b3.20
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 22:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=yeyBTJJsTvi5Lbtf8j5GkDXpafK17xLid75yLfJdvNQ=;
 b=dWueVy4mpzAlbp9vxBRXeJMd0tOrV6DgI5a2e6BASoaxnz2I5NxUAY8AkTgRGmCsVg
 f8XsURQmmttj+5uIMsstpaW4L1YpnR+xueEWxP8tl4iVbAFyNc8PIafqD5mLoYfqD7Ho
 pnv/c3XtqJhRETItrsayIOkmYAHQ+qaDb+c3j3c+u3ja5nMOcFF6Fzcob7sVHui35WkC
 4VGeUs4GQkHIbx3TjkCEthiZik8f2nFDWYDSn0Hf/OTdq97Vyi85fPhnMfb1IVu+49uu
 uOxiS7tqX1KUacYvZ6fjhWwmwIIFicdAdaRM3bgDywnoMhKGH1RXI9725m++3/YQlnPn
 DQNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=yeyBTJJsTvi5Lbtf8j5GkDXpafK17xLid75yLfJdvNQ=;
 b=Ad+G+VNZWnt7oNwXgnMDFpN32BBwSiPA9U/GP3H5/7OMo+VrUWTNKXc1iyYMmEUw4p
 s4stuBUp4GuZeUAyweijZALjrR9yrxJpxATC04LDrGic+vQ3m/L20AnrhEkqz0cvnoU+
 ja0Y0HUddigdHga8mzhExOvDAVCP2kh+GdR0KKT/Slw5D6nd+kDr/cqxQReokanKqxzg
 v1BJ5KpFwGgGd0GW3nGpSbK3HaOQtHj7XadViNUvjOR5k9SZCOJzADiG7ALnYzaRu8Lk
 1vpVoDD9NWZ21Ky88xKLDLtSJgjyzdXYyVO0KDekpidENDfqdR1fOqfdJArm1uP/Oiwd
 WjNw==
X-Gm-Message-State: AJIora8NGzBs6TliBxhVyVncdEy4u3TN7YY10TVgfHNc+Yp9eVk6QcMl
 udmEkke7u3asVPIIK63a+JB15vTtXZC/aLTQfw==
X-Google-Smtp-Source: AGRyM1vMDEeYTxMSnumL6MvPEWUwBYRfyhLjpam3+BcX4vkhcXktAspjirIUgqM+LOZb4VluKzDtrI8VdjNV2nHveQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5a87:b61e:76b5:d1e0])
 (user=kaleshsingh job=sendgmr) by 2002:a25:4cb:0:b0:670:7c80:609b with SMTP
 id 194-20020a2504cb000000b006707c80609bmr12459399ybe.620.1658383070821; Wed,
 20 Jul 2022 22:57:50 -0700 (PDT)
Date: Wed, 20 Jul 2022 22:57:18 -0700
In-Reply-To: <20220721055728.718573-1-kaleshsingh@google.com>
Message-Id: <20220721055728.718573-8-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v5 07/17] KVM: arm64: On stack overflow switch to hyp
 overflow_stack
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com, tabba@google.com
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, elver@google.com,
 vincenzo.frascino@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 android-mm@google.com, kernel-team@android.com, drjones@redhat.com,
 ast@kernel.org, linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

On hyp stack overflow switch to 16-byte aligned secondary stack.
This provides us stack space to better handle overflows; and is
used in a subsequent patch to dump the hypervisor stacktrace.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
---

Changes in v5:
  - Add Reviewed-by tag from Fuad

 arch/arm64/kvm/hyp/nvhe/Makefile     |  2 +-
 arch/arm64/kvm/hyp/nvhe/host.S       |  9 ++-------
 arch/arm64/kvm/hyp/nvhe/stacktrace.c | 11 +++++++++++
 3 files changed, 14 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/stacktrace.c

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index f9fe4dc21b1f..524e7dad5739 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -14,7 +14,7 @@ lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
-	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o
+	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index ea6a397b64a6..b6c0188c4b35 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -177,13 +177,8 @@ SYM_FUNC_END(__host_hvc)
 	b	hyp_panic
 
 .L__hyp_sp_overflow\@:
-	/*
-	 * Reset SP to the top of the stack, to allow handling the hyp_panic.
-	 * This corrupts the stack but is ok, since we won't be attempting
-	 * any unwinding here.
-	 */
-	ldr_this_cpu	x0, kvm_init_params + NVHE_INIT_STACK_HYP_VA, x1
-	mov	sp, x0
+	/* Switch to the overflow stack */
+	adr_this_cpu sp, overflow_stack + OVERFLOW_STACK_SIZE, x0
 
 	b	hyp_panic_bad_stack
 	ASM_BUG()
diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
new file mode 100644
index 000000000000..a3d5b34e1249
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KVM nVHE hypervisor stack tracing support.
+ *
+ * Copyright (C) 2022 Google LLC
+ */
+#include <asm/memory.h>
+#include <asm/percpu.h>
+
+DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
+	__aligned(16);
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

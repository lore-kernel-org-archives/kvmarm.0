Return-Path: <SRS0=nF4w=P6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C20C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 02:08:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 77826619E1
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 02:08:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 77826619E1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C74D4B26D;
	Wed, 10 Nov 2021 21:08:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yRXyK9ol2k25; Wed, 10 Nov 2021 21:08:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 063AB4B275;
	Wed, 10 Nov 2021 21:08:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBCC94B270
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 21:08:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0aW+MjNQelft for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Nov 2021 21:08:08 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC75B4B25F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 21:08:07 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 x3-20020a17090a1f8300b001a285b9f2cbso2023190pja.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 18:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=4wLzPjAo6SC+6dg2XS8LE13lS3wGpQbHkLiaUdVh1zk=;
 b=MuegJeAyDDNZ2tSTgnRGgC7IKnaetIrZypWHgoI7HXfYfypgKJOXeWWLy35dN1C9Kq
 TYdkeXtBhBOimwcZ3top4kHa71CLV6qdvRNUhm81hZ5K3i6YVl/7AXor+8dNYxvAPJer
 ZwGoTfRUt1iBgIiACbYvtCaYyKTtXhPXR+X+RVc6NhZKJJXGXYjtiG/SPUOKx15Mns+w
 h7LMujRE3QFVnTWofLpidFxhxt+qp0BXQN3PgH1ZjZAnDhIuNVlz9u1BvqFo2bLBUTc6
 Fb2NGscm3LpQizlsfcqGjFJsDCfeEgXwB7noSeS86XmgLfWQWeulkCp9qWhLyPOP5PC4
 rOAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=4wLzPjAo6SC+6dg2XS8LE13lS3wGpQbHkLiaUdVh1zk=;
 b=HD4k010LEzXl55d6JNUqDJ9gFH1xdKx5UTSmo5VD7Yp359h3pHrCPakHRb7eaVOH80
 2d7ehoj8QddWR8WUXLA0vgBh7oGb/Zpc2KPrvuLBWf7xcBVu7ZzNGsFtRggRtV+315c3
 fCPSSmhlIE/NQ/QEPO0c2Bms1V6bSOH1TMhc4exk8RMqGyk1rd4dq2nh3BLq1Znxere1
 s3ehP1xkU3h1rQ7VZ1OKnN1Xo+oCnaiDFAkVo2+rEKPy/2BIAY59mLQTj480LiGrJWhs
 wNsGVRHN+Ms3/ASoh4v4Abbhqdfabev5zHh3f27JggcFgjTplLl9rjmHA7foeFLZhx+W
 xlLA==
X-Gm-Message-State: AOAM531z/pcScV4u2DpGt/yWFKeR9FywnoJVJo+329IJ50c2AWZ1lxOT
 t8V2p4ZXoOFGF5W+sg9gEq3j2QV/YWI=
X-Google-Smtp-Source: ABdhPJzOf3D2n0+h+qFn/cUAHxeQwCrLXPititoZgPJ6cdaqRRoa4xxgHhA3Yjjnbd9PcZR94r6p632KxHo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:16c7:0:b0:49f:a6cc:c77d with
 SMTP id
 190-20020a6216c7000000b0049fa6ccc77dmr3410123pfw.23.1636596486947; Wed, 10
 Nov 2021 18:08:06 -0800 (PST)
Date: Thu, 11 Nov 2021 02:07:37 +0000
In-Reply-To: <20211111020738.2512932-1-seanjc@google.com>
Message-Id: <20211111020738.2512932-17-seanjc@google.com>
Mime-Version: 1.0
References: <20211111020738.2512932-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH v4 16/17] KVM: arm64: Drop perf.c and fold its tiny bits of
 code into arm.c
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, 
 Russell King <linux@armlinux.org.uk>, Marc Zyngier <maz@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Guo Ren <guoren@kernel.org>, 
 Nick Hu <nickhu@andestech.com>, Greentime Hu <green.hu@gmail.com>, 
 Vincent Chen <deanbo422@gmail.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 Paolo Bonzini <pbonzini@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
 Juergen Gross <jgross@suse.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Jiri Olsa <jolsa@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Stefano Stabellini <sstabellini@kernel.org>, Like Xu <like.xu@linux.intel.com>,
 Joerg Roedel <joro@8bytes.org>, linux-csky@vger.kernel.org,
 xen-devel@lists.xenproject.org, Zhu Lingshan <lingshan.zhu@intel.com>,
 Namhyung Kim <namhyung@kernel.org>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Like Xu <like.xu.linux@gmail.com>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Call KVM's (un)register perf callbacks helpers directly from arm.c and
delete perf.c

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 ---
 arch/arm64/kvm/Makefile           |  2 +-
 arch/arm64/kvm/arm.c              |  5 +++--
 arch/arm64/kvm/perf.c             | 22 ----------------------
 4 files changed, 4 insertions(+), 28 deletions(-)
 delete mode 100644 arch/arm64/kvm/perf.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 72e2afe6e8e3..824040b174ab 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -675,9 +675,6 @@ unsigned long kvm_mmio_read_buf(const void *buf, unsigned int len);
 int kvm_handle_mmio_return(struct kvm_vcpu *vcpu);
 int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa);
 
-void kvm_perf_init(void);
-void kvm_perf_teardown(void);
-
 /*
  * Returns true if a Performance Monitoring Interrupt (PMI), a.k.a. perf event,
  * arrived in guest context.  For arm64, any event that arrives while a vCPU is
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 989bb5dad2c8..0bcc378b7961 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -12,7 +12,7 @@ obj-$(CONFIG_KVM) += hyp/
 
 kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 $(KVM)/vfio.o $(KVM)/irqchip.o $(KVM)/binary_stats.o \
-	 arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
+	 arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 inject_fault.o va_layout.o handle_exit.o \
 	 guest.o debug.o reset.o sys_regs.o \
 	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 93c952375f3b..8d18a64a72f1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1776,7 +1776,8 @@ static int init_subsystems(void)
 	if (err)
 		goto out;
 
-	kvm_perf_init();
+	kvm_register_perf_callbacks(NULL);
+
 	kvm_sys_reg_table_init();
 
 out:
@@ -2164,7 +2165,7 @@ int kvm_arch_init(void *opaque)
 /* NOP: Compiling as a module not supported */
 void kvm_arch_exit(void)
 {
-	kvm_perf_teardown();
+	kvm_unregister_perf_callbacks();
 }
 
 static int __init early_kvm_mode_cfg(char *arg)
diff --git a/arch/arm64/kvm/perf.c b/arch/arm64/kvm/perf.c
deleted file mode 100644
index 52cfab253c65..000000000000
--- a/arch/arm64/kvm/perf.c
+++ /dev/null
@@ -1,22 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Based on the x86 implementation.
- *
- * Copyright (C) 2012 ARM Ltd.
- * Author: Marc Zyngier <marc.zyngier@arm.com>
- */
-
-#include <linux/perf_event.h>
-#include <linux/kvm_host.h>
-
-#include <asm/kvm_emulate.h>
-
-void kvm_perf_init(void)
-{
-	kvm_register_perf_callbacks(NULL);
-}
-
-void kvm_perf_teardown(void)
-{
-	kvm_unregister_perf_callbacks();
-}
-- 
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

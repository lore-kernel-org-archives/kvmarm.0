Return-Path: <SRS0=LYRx=QG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB40C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 12:29:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B03EE61ACE
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 12:29:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B03EE61ACE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65C594B186;
	Fri, 19 Nov 2021 07:29:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HtMnhT5wSd0J; Fri, 19 Nov 2021 07:29:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 56DFC4B175;
	Fri, 19 Nov 2021 07:29:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33D0F49F5D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 05:21:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aftqI9ohMAQi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Nov 2021 05:21:51 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CB534B08F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 05:21:51 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637317310;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Ct7CtyToJccif4yM7473FLAuHcnDcJ5KfOy6FoPwk00=;
 b=WMRrWysEV7mrnj6DPvIydUY1XiTA6VUXhlpnjoIML2xmI0m8oyBH/ychSeDvb4wjtZT7vk
 DF0F5jdvYEXDCDRCEdC6d+2UKc2x4ZBGC5CyybznHXuge5E+5M1MDBDxjwolpxh8SEQM2f
 TxXtu9jjMhbNmvTrDqY1Uyuln4Tc0dY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-l90Inb0VMI2nTfCgDmfj2Q-1; Fri, 19 Nov 2021 05:21:47 -0500
X-MC-Unique: l90Inb0VMI2nTfCgDmfj2Q-1
Received: by mail-wm1-f72.google.com with SMTP id
 l6-20020a05600c4f0600b0033321934a39so4496947wmq.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 02:21:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=Ct7CtyToJccif4yM7473FLAuHcnDcJ5KfOy6FoPwk00=;
 b=UJl5CBcEybt/72EtZWHjqM6w39TlL32yP2+C9CgKXMwsN3X8iA18oqpx6+tmdDts4I
 WgnKDUBgfBczS5lPh1X2wAOx7mnRfkz0t3JfWGBvzNaBaJHVYb4XR4seLfall7W3ozVj
 MWf+tgf+K4iosSXmO/c38vJ49tkZpXbHGYfgiWdxtc+aDARAV9nee7qmGAdrlDZFpxlE
 G/IL0pkWuRa9RE6QO6bR279L6duUSxeoLLIaiK4P6nNg9YXQX+0Q691zg1nqWjBgP3Oo
 NNpWH33eP6zMnZr4DaDAi6ub4dughJvfBd1MRJunEcCNLh0k5nogilA3bVu93LW+w2aU
 vNYQ==
X-Gm-Message-State: AOAM532vo50adwnCH16TUc/TAXBGOr316uufWvS1CErPDytab9AWJ9R4
 W1Urm2xXKTv5aj6BWkqs4qx2cvuyh5pEICOD4Kc6djIIR+OHQZ6JPclqNBRTv8XbKVvMZ1EQwYs
 HAb5zu1ZmO6aY1SqkHOGWWEvl
X-Received: by 2002:a1c:6a0e:: with SMTP id f14mr5372827wmc.58.1637317305274; 
 Fri, 19 Nov 2021 02:21:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxIUdO9kJGSkL5mvaE1u7YqQr35Qw1TrQUV/WROHnbGRLAbqb5SG0+IyiEIxSlskLareoN6zA==
X-Received: by 2002:a1c:6a0e:: with SMTP id f14mr5372797wmc.58.1637317305056; 
 Fri, 19 Nov 2021 02:21:45 -0800 (PST)
Received: from vian.redhat.com ([2a0c:5a80:3c10:3400:3c70:6643:6e71:7eae])
 by smtp.gmail.com with ESMTPSA id k27sm14336026wms.41.2021.11.19.02.21.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 19 Nov 2021 02:21:44 -0800 (PST)
From: Nicolas Saenz Julienne <nsaenzju@redhat.com>
To: linux-arm-kernel@lists.infradead.org, maz@kernel.org, rostedt@goodmis.org
Subject: [RFC PATCH 2/2] KVM: arm64: export cntvoff in debugfs
Date: Fri, 19 Nov 2021 11:21:18 +0100
Message-Id: <20211119102117.22304-3-nsaenzju@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119102117.22304-1-nsaenzju@redhat.com>
References: <20211119102117.22304-1-nsaenzju@redhat.com>
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nsaenzju@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Fri, 19 Nov 2021 07:29:31 -0500
Cc: will@kernel.org, catalin.marinas@arm.com, mtosatti@redhat.com,
 linux-kernel@vger.kernel.org, mingo@redhat.com, nsaenzju@redhat.com,
 nilal@redhat.com, kvmarm@lists.cs.columbia.edu
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

While using cntvct as the raw clock for tracing, it's possible to
synchronize host/guest traces just by knowing the virtual offset applied
to the guest's virtual counter.

This is also the case on x86 when TSC is available. The offset is
exposed in debugfs as 'tsc-offset' on a per vcpu basis. So let's
implement the same for arm64.

Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/Makefile           |  2 +-
 arch/arm64/kvm/arch_timer.c       |  2 +-
 arch/arm64/kvm/debugfs.c          | 25 +++++++++++++++++++++++++
 include/kvm/arm_arch_timer.h      |  3 +++
 5 files changed, 31 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/debugfs.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2a5f7f38006f..130534c9079e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -29,6 +29,7 @@
 #include <asm/thread_info.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
+#define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
 #define KVM_HALT_POLL_NS_DEFAULT 500000
 
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 989bb5dad2c8..17be7cf770f2 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -14,7 +14,7 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 $(KVM)/vfio.o $(KVM)/irqchip.o $(KVM)/binary_stats.o \
 	 arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
 	 inject_fault.o va_layout.o handle_exit.o \
-	 guest.o debug.o reset.o sys_regs.o \
+	 guest.o debug.o debugfs.o reset.o sys_regs.o \
 	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
 	 arch_timer.o trng.o\
 	 vgic/vgic.o vgic/vgic-init.o \
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 3df67c127489..ee69387f7fb6 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -82,7 +82,7 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
 	}
 }
 
-static u64 timer_get_offset(struct arch_timer_context *ctxt)
+u64 timer_get_offset(struct arch_timer_context *ctxt)
 {
 	struct kvm_vcpu *vcpu = ctxt->vcpu;
 
diff --git a/arch/arm64/kvm/debugfs.c b/arch/arm64/kvm/debugfs.c
new file mode 100644
index 000000000000..f0f5083ea8d4
--- /dev/null
+++ b/arch/arm64/kvm/debugfs.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021 Red Hat Inc.
+ */
+
+#include <linux/kvm_host.h>
+#include <linux/debugfs.h>
+
+#include <kvm/arm_arch_timer.h>
+
+static int vcpu_get_cntv_offset(void *data, u64 *val)
+{
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)data;
+
+	*val = timer_get_offset(vcpu_vtimer(vcpu));
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(vcpu_cntvoff_fops, vcpu_get_cntv_offset, NULL, "%lld\n");
+
+void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry)
+{
+	debugfs_create_file("cntvoff", 0444, debugfs_dentry, vcpu, &vcpu_cntvoff_fops);
+}
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 51c19381108c..de0cd9be825c 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -106,4 +106,7 @@ void kvm_arm_timer_write_sysreg(struct kvm_vcpu *vcpu,
 u32 timer_get_ctl(struct arch_timer_context *ctxt);
 u64 timer_get_cval(struct arch_timer_context *ctxt);
 
+/* Nedded for debugfs */
+u64 timer_get_offset(struct arch_timer_context *ctxt);
+
 #endif
-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

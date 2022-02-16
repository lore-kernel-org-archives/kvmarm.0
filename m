Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F293DC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 17 Feb 2022 09:22:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7447C49B0E;
	Thu, 17 Feb 2022 04:22:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nHqrc-v9aEAl; Thu, 17 Feb 2022 04:22:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C635A49E1E;
	Thu, 17 Feb 2022 04:22:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58DD549E27
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Feb 2022 11:16:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id npuRmp+0l7AI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Feb 2022 11:16:51 -0500 (EST)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com
 [209.85.128.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2933649E18
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Feb 2022 11:16:51 -0500 (EST)
Received: by mail-wm1-f43.google.com with SMTP id
 l123-20020a1c2581000000b0037b9d960079so4165289wml.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Feb 2022 08:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
 bh=H3gHrgMTfocFjTPlthx24Op4v2ZtezvXjgsNGzJCP90=;
 b=dCXnSdTuIIf2eyYh3riusSZHwXL+NnU7icSOSc+Qv+f54GniZFezvYNYIq6w3E3FCV
 LmzYyj4LclmxjWkDH78zSBT6rqccbqo28/2qkkE+lk1/vp8So+clEQienf6uFmpf9+Ux
 e3t3Yh568sYQGoP/97cn+oU735i/PwEfmU5SQeNp9f7cIoPxKbwYyePaYNwkFAcn8JVz
 tGeomKVq4UrGcw4mz82IqED1+WqPDbOQ6gqqhCI2A+l8flYjJiJovbdiEotKBtTcDLzK
 FKedMQovTJmpCtJV55i8c/Vc82w7mrbKMK3SDGkfTIx5163obS8M4bI1QM9rZKDyghxv
 GU6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
 :content-disposition;
 bh=H3gHrgMTfocFjTPlthx24Op4v2ZtezvXjgsNGzJCP90=;
 b=D3kRgKoLgk3XcSg/qSj3Yw6ULXVi2mXtAL7lbOzVHRv1hddJgWg2ilzpANHwEkMvPg
 XxEtQpRrXqr+ALq+FeuyXMfjlzKzfQRzWilFEdqgX6KKdoO7aoVAo2IpDTz28A/fwjZt
 55A6Ahi9hZ4f7UBQnWdoEZCwKqD34lElFj+p4AYC+X3JUVOc+ExC/YvmATgDIL4pkKBu
 HcM9GASN4qiGw1ESCFo/leuXatq/djkd03cL6p6bgY20k9YKlTvfTNmQCnyPYZoLC57p
 IAXStJHcATdUh8NYlDlX1YlsdOPriTgEnEszBDi7Fe09N4Z7tq2IxUwe4vX4cGElRgHL
 6mng==
X-Gm-Message-State: AOAM532cXY/gV+sRXoP9kYlmUJyFzhtbqiGL+5B7WW5cln9DtVvSh4gr
 I20Sa1J3Wqft4DvOs29OQQLMNw==
X-Google-Smtp-Source: ABdhPJx7FeJIsiXbjONZX2UTKtSQyEFokJwTL2ioUcuI3Oi1mbN1MMMPGCc3Hs38Ubc0NLqVS/PqcA==
X-Received: by 2002:a05:600c:3491:b0:37b:d710:f565 with SMTP id
 a17-20020a05600c349100b0037bd710f565mr2401004wmq.10.1645028209834; 
 Wed, 16 Feb 2022 08:16:49 -0800 (PST)
Received: from google.com (203.75.199.104.bc.googleusercontent.com.
 [104.199.75.203])
 by smtp.gmail.com with ESMTPSA id ba27sm8809744wrb.61.2022.02.16.08.16.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Feb 2022 08:16:49 -0800 (PST)
Date: Wed, 16 Feb 2022 16:16:48 +0000
From: Sebastian Ene <sebastianene@google.com>
To: kvm@vger.kernel.org
Subject: [PATCH kvmtool] aarch64: Add stolen time support
Message-ID: <Yg0jcO32I+zFz/0s@google.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Mailman-Approved-At: Thu, 17 Feb 2022 04:22:52 -0500
Cc: maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

This patch add support for stolen time by sharing a memory region
with the guest which will be used by the hypervisor to store the stolen
time information. The exact format of the structure stored by the
hypervisor is described in the ARM DEN0057A document.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 Makefile                          |  3 +-
 arm/aarch64/arm-cpu.c             |  2 +
 arm/aarch64/include/kvm/pvtime.h  |  6 +++
 arm/aarch64/pvtime.c              | 83 +++++++++++++++++++++++++++++++
 arm/include/arm-common/kvm-arch.h |  6 +++
 arm/kvm-cpu.c                     | 14 +++---
 6 files changed, 106 insertions(+), 8 deletions(-)
 create mode 100644 arm/aarch64/include/kvm/pvtime.h
 create mode 100644 arm/aarch64/pvtime.c

diff --git a/Makefile b/Makefile
index f251147..282ae99 100644
--- a/Makefile
+++ b/Makefile
@@ -182,6 +182,7 @@ ifeq ($(ARCH), arm64)
 	OBJS		+= arm/aarch64/arm-cpu.o
 	OBJS		+= arm/aarch64/kvm-cpu.o
 	OBJS		+= arm/aarch64/kvm.o
+	OBJS		+= arm/aarch64/pvtime.o
 	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
 	ARCH_INCLUDE	+= -Iarm/aarch64/include
 
@@ -582,4 +583,4 @@ ifneq ($(MAKECMDGOALS),clean)
 
 KVMTOOLS-VERSION-FILE:
 	@$(SHELL_PATH) util/KVMTOOLS-VERSION-GEN $(OUTPUT)
-endif
\ No newline at end of file
+endif
diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
index d7572b7..80bf83a 100644
--- a/arm/aarch64/arm-cpu.c
+++ b/arm/aarch64/arm-cpu.c
@@ -2,6 +2,7 @@
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
 #include "kvm/util.h"
+#include "kvm/pvtime.h"
 
 #include "arm-common/gic.h"
 #include "arm-common/timer.h"
@@ -22,6 +23,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
 static int arm_cpu__vcpu_init(struct kvm_cpu *vcpu)
 {
 	vcpu->generate_fdt_nodes = generate_fdt_nodes;
+	pvtime__setup_vcpu(vcpu);
 	return 0;
 }
 
diff --git a/arm/aarch64/include/kvm/pvtime.h b/arm/aarch64/include/kvm/pvtime.h
new file mode 100644
index 0000000..c31f019
--- /dev/null
+++ b/arm/aarch64/include/kvm/pvtime.h
@@ -0,0 +1,6 @@
+#ifndef KVM__PVTIME_H
+#define KVM__PVTIME_H
+
+void pvtime__setup_vcpu(struct kvm_cpu *vcpu);
+
+#endif /* KVM__PVTIME_H */
diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
new file mode 100644
index 0000000..eb92388
--- /dev/null
+++ b/arm/aarch64/pvtime.c
@@ -0,0 +1,83 @@
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/util.h"
+#include "kvm/pvtime.h"
+
+#include <linux/byteorder.h>
+#include <linux/types.h>
+
+struct pvtime_data_priv {
+	bool	is_supported;
+	char	*usr_mem;
+};
+
+static struct pvtime_data_priv pvtime_data = {
+	.is_supported	= true,
+	.usr_mem	= NULL
+};
+
+static int pvtime__aloc_region(struct kvm *kvm)
+{
+	char *mem;
+	int ret = 0;
+
+	mem = mmap(NULL, AARCH64_PVTIME_IPA_MAX_SIZE, PROT_RW,
+		   MAP_ANON_NORESERVE, -1, 0);
+	if (mem == MAP_FAILED)
+		return -ENOMEM;
+
+	ret = kvm__register_dev_mem(kvm, AARCH64_PVTIME_IPA_START,
+				    AARCH64_PVTIME_IPA_MAX_SIZE, mem);
+	if (ret) {
+		munmap(mem, AARCH64_PVTIME_IPA_MAX_SIZE);
+		return ret;
+	}
+
+	pvtime_data.usr_mem = mem;
+	return ret;
+}
+
+static int pvtime__teardown_region(struct kvm *kvm)
+{
+	kvm__destroy_mem(kvm, AARCH64_PVTIME_IPA_START,
+			 AARCH64_PVTIME_IPA_MAX_SIZE, pvtime_data.usr_mem);
+	munmap(pvtime_data.usr_mem, AARCH64_PVTIME_IPA_MAX_SIZE);
+	pvtime_data.usr_mem = NULL;
+	return 0;
+}
+
+void pvtime__setup_vcpu(struct kvm_cpu *vcpu)
+{
+	int ret;
+	u64 pvtime_guest_addr = AARCH64_PVTIME_IPA_START + vcpu->cpu_id *
+		AARCH64_PVTIME_SIZE;
+	struct kvm_device_attr pvtime_attr = (struct kvm_device_attr) {
+		.group	= KVM_ARM_VCPU_PVTIME_CTRL,
+		.addr	= KVM_ARM_VCPU_PVTIME_IPA
+	};
+
+	if (!pvtime_data.is_supported)
+		return;
+
+	if (!pvtime_data.usr_mem) {
+		ret = pvtime__aloc_region(vcpu->kvm);
+		if (ret)
+			goto out_err_alloc;
+	}
+
+	ret = ioctl(vcpu->vcpu_fd, KVM_HAS_DEVICE_ATTR, &pvtime_attr);
+	if (ret)
+		goto out_err_attr;
+
+	pvtime_attr.addr = (u64)&pvtime_guest_addr;
+	ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pvtime_attr);
+	if (!ret)
+		return;
+
+out_err_attr:
+	pvtime__teardown_region(vcpu->kvm);
+out_err_alloc:
+	pvtime_data.is_supported = false;
+}
+
+dev_exit(pvtime__teardown_region);
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index c645ac0..7b683d6 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -54,6 +54,12 @@
 #define ARM_PCI_MMIO_SIZE	(ARM_MEMORY_AREA - \
 				(ARM_AXI_AREA + ARM_PCI_CFG_SIZE))
 
+#define AARCH64_PVTIME_IPA_MAX_SIZE		(0x10000)
+#define AARCH64_PROTECTED_VM_FW_MAX_SIZE	(0x200000)
+#define AARCH64_PVTIME_IPA_START	(ARM_MEMORY_AREA - \
+					 AARCH64_PROTECTED_VM_FW_MAX_SIZE - \
+					 AARCH64_PVTIME_IPA_MAX_SIZE)
+#define AARCH64_PVTIME_SIZE		(64)
 
 #define ARM_LOMAP_MAX_MEMORY	((1ULL << 32) - ARM_MEMORY_AREA)
 #define ARM_HIMAP_MAX_MEMORY	((1ULL << 40) - ARM_MEMORY_AREA)
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 6a2408c..84ac1e9 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -116,6 +116,13 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 			die("Unable to find matching target");
 	}
 
+	/* Populate the vcpu structure. */
+	vcpu->kvm		= kvm;
+	vcpu->cpu_id		= cpu_id;
+	vcpu->cpu_type		= vcpu_init.target;
+	vcpu->cpu_compatible	= target->compatible;
+	vcpu->is_running	= true;
+
 	if (err || target->init(vcpu))
 		die("Unable to initialise vcpu");
 
@@ -125,13 +132,6 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 		vcpu->ring = (void *)vcpu->kvm_run +
 			     (coalesced_offset * PAGE_SIZE);
 
-	/* Populate the vcpu structure. */
-	vcpu->kvm		= kvm;
-	vcpu->cpu_id		= cpu_id;
-	vcpu->cpu_type		= vcpu_init.target;
-	vcpu->cpu_compatible	= target->compatible;
-	vcpu->is_running	= true;
-
 	if (kvm_cpu__configure_features(vcpu))
 		die("Unable to configure requested vcpu features");
 
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

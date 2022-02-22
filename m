Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93C9DC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 22 Feb 2022 10:49:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C30134B08E;
	Tue, 22 Feb 2022 05:49:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F+xCbNbPqOni; Tue, 22 Feb 2022 05:49:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF5FD4B08B;
	Tue, 22 Feb 2022 05:49:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 126054B0B8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 05:08:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T8oOAnTRFTNM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 05:08:33 -0500 (EST)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 256224A193
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 05:08:33 -0500 (EST)
Received: by mail-wr1-f49.google.com with SMTP id p9so32055931wra.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 02:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
 bh=4noxcyuFAgImzzAQFbzXSRryQNYK+yQdcRgbEx09zps=;
 b=ItgWNPLKUu3pHO3VpOTEPzFbeGENbBktmqN/9y5X4bUB8fTyrV6xQBAXin+dqF4yYS
 nYBefNG2dTCZku+AkdEc7vK8EwBGsdYc2KdJxXnEDhbKvRvrXdGfipGOy5IMFRDR8j+O
 zdHsRtW3ERx4FTuCzJ/xbA97zAa8xMdI9fINxYAY+5Sr1CfSg4MVUrV6AavCjLNAMUc1
 VIJipnRHx2tCslJ2oizzGi6tkYPRjFm9eHzzCeVd5WSl/koTHyoLqK5nFcX4FDg1ac1F
 PQqru1cJSdrNyO0i2riNQ8bhuA2+AUQdHWGd0S7CPccAO1Vm+Kg7wQEoIfIRcA/dteNL
 P96w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
 :content-disposition;
 bh=4noxcyuFAgImzzAQFbzXSRryQNYK+yQdcRgbEx09zps=;
 b=pmPo31+WbD+9vPInnPNI6KZGyEM++KMSOccPpIgC52sp2fWJ7wGnQcWzZ06ji8wclk
 uCVotsf003fPVwQOSIX4IcZTINRfNaZNxK410V19+2FlUcgMMBwkquF0wonWBMkVWYJn
 N5GJ25WEa8IsWt24mq8zM78MfRIDfRtS8Jr1qUebpjTXFJyo6qhIVclGTdCgUqQ+qEVX
 J+ekUSOnn4HMSKJGAL831b5ibpHkVVuNR304zU4RknRFBDTtDjyz5pWablR+/lpZo868
 1uy0d3F5V4bHX+3QvJzvlr09ZSWajaubD2An6TU2PjwVSXzwSBhybjIkqXcB8TEZPyyI
 0FoA==
X-Gm-Message-State: AOAM532HkQo74Cve670+qt/YfwhusItF0yXzmc0G1qg+LhNyfvWjnryF
 y8vDHbw3mBt38Ys/DipEjxb0Ww==
X-Google-Smtp-Source: ABdhPJxgqqnm3BH5ABsKk4NFgcnTNqoY05PNmRVsLoNlu5l1DmDMUkhqIrBh1ChBVvXIXKKSVkdjKA==
X-Received: by 2002:adf:a389:0:b0:1ea:95ea:58dc with SMTP id
 l9-20020adfa389000000b001ea95ea58dcmr1472168wrb.659.1645524511947; 
 Tue, 22 Feb 2022 02:08:31 -0800 (PST)
Received: from google.com (203.75.199.104.bc.googleusercontent.com.
 [104.199.75.203])
 by smtp.gmail.com with ESMTPSA id ay41sm1921137wmb.44.2022.02.22.02.08.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 22 Feb 2022 02:08:31 -0800 (PST)
Date: Tue, 22 Feb 2022 10:08:30 +0000
From: Sebastian Ene <sebastianene@google.com>
To: kvm@vger.kernel.org
Subject: [PATCH kvmtool v3] aarch64: Add stolen time support
Message-ID: <YhS2Htrzwks/allO@google.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Mailman-Approved-At: Tue, 22 Feb 2022 05:49:28 -0500
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

This patch adds support for stolen time by sharing a memory region
with the guest which will be used by the hypervisor to store the stolen
time information. The exact format of the structure stored by the
hypervisor is described in the ARM DEN0057A document.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 Changelog since v2:
 - Moved the AARCH64_PVTIME_* definitions from arm-common/kvm-arch.h to
   arm64/pvtime.c as pvtime is only available for arm64.

 Changelog since v1:
 - Removed the pvtime.h header file and moved the definitions to kvm-cpu-arch.h
   Verified if the stolen time capability is supported before allocating
   and mapping the memory.

 Makefile                               |  1 +
 arm/aarch64/arm-cpu.c                  |  1 +
 arm/aarch64/include/kvm/kvm-cpu-arch.h |  1 +
 arm/aarch64/pvtime.c                   | 89 ++++++++++++++++++++++++++
 arm/kvm-cpu.c                          | 14 ++--
 5 files changed, 99 insertions(+), 7 deletions(-)
 create mode 100644 arm/aarch64/pvtime.c

diff --git a/Makefile b/Makefile
index f251147..e9121dc 100644
--- a/Makefile
+++ b/Makefile
@@ -182,6 +182,7 @@ ifeq ($(ARCH), arm64)
 	OBJS		+= arm/aarch64/arm-cpu.o
 	OBJS		+= arm/aarch64/kvm-cpu.o
 	OBJS		+= arm/aarch64/kvm.o
+	OBJS		+= arm/aarch64/pvtime.o
 	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
 	ARCH_INCLUDE	+= -Iarm/aarch64/include
 
diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
index d7572b7..326fb20 100644
--- a/arm/aarch64/arm-cpu.c
+++ b/arm/aarch64/arm-cpu.c
@@ -22,6 +22,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
 static int arm_cpu__vcpu_init(struct kvm_cpu *vcpu)
 {
 	vcpu->generate_fdt_nodes = generate_fdt_nodes;
+	kvm_cpu__setup_pvtime(vcpu);
 	return 0;
 }
 
diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
index 8dfb82e..b57d6e6 100644
--- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
@@ -19,5 +19,6 @@
 
 void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init);
 int kvm_cpu__configure_features(struct kvm_cpu *vcpu);
+void kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu);
 
 #endif /* KVM__KVM_CPU_ARCH_H */
diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
new file mode 100644
index 0000000..247e4f3
--- /dev/null
+++ b/arm/aarch64/pvtime.c
@@ -0,0 +1,89 @@
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/util.h"
+
+#include <linux/byteorder.h>
+#include <linux/types.h>
+
+#define AARCH64_PVTIME_IPA_MAX_SIZE	SZ_64K
+#define AARCH64_PVTIME_IPA_START	(ARM_MEMORY_AREA - \
+					 AARCH64_PVTIME_IPA_MAX_SIZE)
+#define AARCH64_PVTIME_SIZE		(64)
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
+static int pvtime__alloc_region(struct kvm *kvm)
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
+	if (pvtime_data.usr_mem == NULL)
+		return 0;
+
+	kvm__destroy_mem(kvm, AARCH64_PVTIME_IPA_START,
+			 AARCH64_PVTIME_IPA_MAX_SIZE, pvtime_data.usr_mem);
+	munmap(pvtime_data.usr_mem, AARCH64_PVTIME_IPA_MAX_SIZE);
+	pvtime_data.usr_mem = NULL;
+	return 0;
+}
+
+void kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu)
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
+	ret = ioctl(vcpu->vcpu_fd, KVM_HAS_DEVICE_ATTR, &pvtime_attr);
+	if (ret)
+		goto out_err;
+
+	if (!pvtime_data.usr_mem) {
+		ret = pvtime__alloc_region(vcpu->kvm);
+		if (ret)
+			goto out_err;
+	}
+
+	pvtime_attr.addr = (u64)&pvtime_guest_addr;
+	ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pvtime_attr);
+	if (!ret)
+		return;
+
+	pvtime__teardown_region(vcpu->kvm);
+out_err:
+	pvtime_data.is_supported = false;
+}
+
+dev_exit(pvtime__teardown_region);
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
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

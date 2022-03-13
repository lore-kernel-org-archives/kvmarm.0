Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ECF9C433EF
	for <kvmarm@archiver.kernel.org>; Sun, 13 Mar 2022 16:20:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C1D140B78;
	Sun, 13 Mar 2022 12:20:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q6c7jEMacZeA; Sun, 13 Mar 2022 12:20:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CF5049EE7;
	Sun, 13 Mar 2022 12:20:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1289449EC2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Mar 2022 12:20:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DQopvqI4pwGx for <kvmarm@lists.cs.columbia.edu>;
 Sun, 13 Mar 2022 12:20:53 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E1C940B41
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Mar 2022 12:20:53 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id
 c62-20020a1c3541000000b003815245c642so8342422wma.6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Mar 2022 09:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=EyKnKMlDs3oKW1PMbKGcMuzZIc8VEaJSskTDb0/5zX0=;
 b=CbZ7vTtpENNJP0oXdYJWb4CWp5AELkdqCNiShpwXzsxrbWRHZyfv+vSoeD7Vv+ixiY
 GxCqAh9R6DMdx0kGg52ikSWhIogD97XSZiaPSCKdBJSn8WZRQ/h0PUwpoGBA9ly67DJF
 nuUadNdJ33LdJr/YG9LW8xGdc2LWxrrAHeGBK20jq+krAjqqhKeHLEd/WUEA5wo2kV9E
 afcaJbTpKHPDPIKDBhRNeSkxyYaJlnmk/7Jk+VV1KsDehrDzyKj7EJkuDGUfjgmzUrrX
 WeYTEzK7aa2BpxbR44OY3kGsT8GqxndQCWaxTtcS2E4O+cTw+YnoOBm0mUwxmpCdya+i
 GKEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=EyKnKMlDs3oKW1PMbKGcMuzZIc8VEaJSskTDb0/5zX0=;
 b=ddqk1PEYhu5xyg0CmDJDbc8WNGHoNctG1/kHKfUhXnFYdn/qdnk9ulpi+Xuiggzo7R
 tNAsXhsa+rkbHImHcs75Lad3Wgq8itTHmMV2wZotGa7IqFSUyb2ML0P8M1lhUJzW4XR9
 kIQPIjmP7ZA+7xtGGPLV8enOjFNTzKfHkMm3ZLhyioAuj/p8EhB7yfyqII6nzlfBXs5k
 s5nzA/JWx70ep+oStuBh+d1NDQn/SAKKbsXIxJF0Q8yR4hEJ4ojWwWx7uoQH1/nYgXf7
 faRzCsOkD/95HRaGZLhtAuwlrSvG2EaHrUibtL02sJHrqARPZzKJaupIqT/+W4KnpNIF
 oK7Q==
X-Gm-Message-State: AOAM531xfglME3BNZ95Sxc3XMGsonwNc70F08LuKx6rUR6YK3brFgyWp
 A9wk6rGgYp1ahcJFaM6b+JvOlyFNYDPWuRlD/7A=
X-Google-Smtp-Source: ABdhPJyBEiGRpN93dCyDh2C4GLeSPBWuwzjYaojgpXohF8gpf2N2s1LqtBsKv6g/umkbEDVdD3Sey+M4EDjulfzG46c=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a5d:5911:0:b0:1f0:3272:2ac9 with SMTP
 id v17-20020a5d5911000000b001f032722ac9mr13801146wrd.1.1647188452663; Sun, 13
 Mar 2022 09:20:52 -0700 (PDT)
Date: Sun, 13 Mar 2022 16:19:49 +0000
In-Reply-To: <20220313161949.3565171-1-sebastianene@google.com>
Message-Id: <20220313161949.3565171-3-sebastianene@google.com>
Mime-Version: 1.0
References: <20220313161949.3565171-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH kvmtool v11 2/3] aarch64: Add stolen time support
From: Sebastian Ene <sebastianene@google.com>
To: kvm@vger.kernel.org
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
time information. Reserve a 64kb MMIO memory region after the RTC peripheral
to be used by pvtime. The exact format of the structure stored by the
hypervisor is described in the ARM DEN0057A document.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 Makefile                               |  1 +
 arm/aarch32/include/kvm/kvm-cpu-arch.h |  5 ++
 arm/aarch64/arm-cpu.c                  |  2 +-
 arm/aarch64/include/kvm/kvm-cpu-arch.h |  2 +
 arm/aarch64/pvtime.c                   | 98 ++++++++++++++++++++++++++
 arm/include/arm-common/kvm-arch.h      |  6 +-
 arm/kvm-cpu.c                          |  1 +
 include/kvm/kvm-config.h               |  1 +
 8 files changed, 114 insertions(+), 2 deletions(-)
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
 
diff --git a/arm/aarch32/include/kvm/kvm-cpu-arch.h b/arm/aarch32/include/kvm/kvm-cpu-arch.h
index 780e0e2..6fe0206 100644
--- a/arm/aarch32/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch32/include/kvm/kvm-cpu-arch.h
@@ -20,4 +20,9 @@ static inline int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
 	return 0;
 }
 
+static inline int kvm_cpu__teardown_pvtime(struct kvm *kvm)
+{
+	return 0;
+}
+
 #endif /* KVM__KVM_CPU_ARCH_H */
diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
index d7572b7..7e4a3c1 100644
--- a/arm/aarch64/arm-cpu.c
+++ b/arm/aarch64/arm-cpu.c
@@ -22,7 +22,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
 static int arm_cpu__vcpu_init(struct kvm_cpu *vcpu)
 {
 	vcpu->generate_fdt_nodes = generate_fdt_nodes;
-	return 0;
+	return kvm_cpu__setup_pvtime(vcpu);
 }
 
 static struct kvm_arm_target target_generic_v8 = {
diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
index 8dfb82e..35996dc 100644
--- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
@@ -19,5 +19,7 @@
 
 void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init);
 int kvm_cpu__configure_features(struct kvm_cpu *vcpu);
+int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu);
+int kvm_cpu__teardown_pvtime(struct kvm *kvm);
 
 #endif /* KVM__KVM_CPU_ARCH_H */
diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
new file mode 100644
index 0000000..2f5774e
--- /dev/null
+++ b/arm/aarch64/pvtime.c
@@ -0,0 +1,98 @@
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/util.h"
+
+#include <linux/byteorder.h>
+#include <linux/types.h>
+
+#define ARM_PVTIME_STRUCT_SIZE		(64)
+
+static void *usr_mem;
+
+static int pvtime__alloc_region(struct kvm *kvm)
+{
+	char *mem;
+	int ret = 0;
+
+	mem = mmap(NULL, ARM_PVTIME_BASE, PROT_RW,
+		   MAP_ANON_NORESERVE, -1, 0);
+	if (mem == MAP_FAILED)
+		return -errno;
+
+	ret = kvm__register_ram(kvm, ARM_PVTIME_BASE,
+				ARM_PVTIME_BASE, mem);
+	if (ret) {
+		munmap(mem, ARM_PVTIME_BASE);
+		return ret;
+	}
+
+	usr_mem = mem;
+	return ret;
+}
+
+static int pvtime__teardown_region(struct kvm *kvm)
+{
+	if (usr_mem == NULL)
+		return 0;
+
+	kvm__destroy_mem(kvm, ARM_PVTIME_BASE,
+			 ARM_PVTIME_BASE, usr_mem);
+	munmap(usr_mem, ARM_PVTIME_BASE);
+	usr_mem = NULL;
+	return 0;
+}
+
+int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu)
+{
+	int ret;
+	bool has_stolen_time;
+	u64 pvtime_guest_addr = ARM_PVTIME_BASE + vcpu->cpu_id *
+		ARM_PVTIME_STRUCT_SIZE;
+	struct kvm_config *kvm_cfg = NULL;
+	struct kvm_device_attr pvtime_attr = (struct kvm_device_attr) {
+		.group	= KVM_ARM_VCPU_PVTIME_CTRL,
+		.attr	= KVM_ARM_VCPU_PVTIME_IPA
+	};
+
+	kvm_cfg = &vcpu->kvm->cfg;
+	if (kvm_cfg->no_pvtime)
+		return 0;
+
+	has_stolen_time = kvm__supports_extension(vcpu->kvm,
+						  KVM_CAP_STEAL_TIME);
+	if (!has_stolen_time) {
+		kvm_cfg->no_pvtime = true;
+		return 0;
+	}
+
+	ret = ioctl(vcpu->vcpu_fd, KVM_HAS_DEVICE_ATTR, &pvtime_attr);
+	if (ret) {
+		ret = -errno;
+		perror("KVM_HAS_DEVICE_ATTR failed\n");
+		goto out_err;
+	}
+
+	if (!usr_mem) {
+		ret = pvtime__alloc_region(vcpu->kvm);
+		if (ret) {
+			perror("Failed allocating pvtime region\n");
+			goto out_err;
+		}
+	}
+
+	pvtime_attr.addr = (u64)&pvtime_guest_addr;
+	ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pvtime_attr);
+	if (!ret)
+		return 0;
+
+	ret = -errno;
+	perror("KVM_SET_DEVICE_ATTR failed\n");
+	pvtime__teardown_region(vcpu->kvm);
+out_err:
+	return ret;
+}
+
+int kvm_cpu__teardown_pvtime(struct kvm *kvm)
+{
+	return pvtime__teardown_region(kvm);
+}
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index c645ac0..43b1f77 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -15,7 +15,8 @@
  * |  PCI  |////| plat  |       |        |     |         |
  * |  I/O  |////| MMIO: | Flash | virtio | GIC |   PCI   |  DRAM
  * | space |////| UART, |       |  MMIO  |     |  (AXI)  |
- * |       |////| RTC   |       |        |     |         |
+ * |       |////| RTC,  |       |        |     |         |
+ * |       |////| PVTIME|       |        |     |         |
  * +-------+----+-------+-------+--------+-----+---------+---......
  */
 
@@ -34,6 +35,9 @@
 #define ARM_RTC_MMIO_BASE	(ARM_UART_MMIO_BASE + ARM_UART_MMIO_SIZE)
 #define ARM_RTC_MMIO_SIZE	0x10000
 
+#define ARM_PVTIME_BASE		(ARM_RTC_MMIO_BASE + ARM_RTC_MMIO_SIZE)
+#define ARM_PVTIME_SIZE		SZ_64K
+
 #define KVM_FLASH_MMIO_BASE	(ARM_MMIO_AREA + 0x1000000)
 #define KVM_FLASH_MAX_SIZE	0x1000000
 
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 84ac1e9..00660d6 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -144,6 +144,7 @@ void kvm_cpu__arch_nmi(struct kvm_cpu *cpu)
 
 void kvm_cpu__delete(struct kvm_cpu *vcpu)
 {
+	kvm_cpu__teardown_pvtime(vcpu->kvm);
 	free(vcpu);
 }
 
diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
index 6a5720c..48adf27 100644
--- a/include/kvm/kvm-config.h
+++ b/include/kvm/kvm-config.h
@@ -62,6 +62,7 @@ struct kvm_config {
 	bool no_dhcp;
 	bool ioport_debug;
 	bool mmio_debug;
+	bool no_pvtime;
 };
 
 #endif
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

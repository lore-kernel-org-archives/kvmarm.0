Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD461C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 16:55:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 796F94BD3C;
	Thu, 24 Feb 2022 11:55:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1d3zykGqcT8O; Thu, 24 Feb 2022 11:55:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9188F4BA0E;
	Thu, 24 Feb 2022 11:55:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2017D4B904
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 11:55:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vGbch4cBPgpa for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 11:55:38 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9DBB249E1A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 11:55:38 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id
 az39-20020a05600c602700b00380e48f5994so122077wmb.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 08:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=HW3TuP83maeuG31dO10ept4LUcJ204ZVCGTVYkO2Y7c=;
 b=CGomys7UB4+4gusFykVd8cEDg/bRcAX2jDVuWNy4r2sx3QwdKB4cIEveHMXCPMlnZw
 q8bfnI4GUrhW51n3ylBUCOF8KPita/P/HFOlnJDREdZ5wKTZ3Lb/7KcDkFutV8gpdomc
 tYsntZnrJAOUGnfBznaEZYPv630GpvhxeDr1r1FAlkS4nrbthnZ2+g1hBh7tSOQYJ969
 ummU33OXyJN9kGSOb75oq5NCl5EBQWtOLRZiYrlf7fqvYMdvI3oDT5LfvopceFx7MBd0
 MEts8Ec16+qDAwMyY9jRw6/lU2/5n17M8G7yNZUBBp2CVN8vuPDBn636P6EnV9P7yx6j
 xf3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=HW3TuP83maeuG31dO10ept4LUcJ204ZVCGTVYkO2Y7c=;
 b=wZeG2jlacsOy9aqX7/DEe2eIXqvRK0lZkegAfaPA0+ytKY6TzK+G7yhAZxoXCHikRJ
 juoUuiEY9+GBYZxaLyojtz07kUYno3yTH4WJCIE8utukVQWPs0VQR4Jw2Z9AYHr1GSPW
 oAY9t5onEY7QqDY6bDbLywrt8j4G9Laxwmz5aMRZNKrLAW8vJXx/ws6fxXDpfqornCKF
 nbzssc6h+xg3Dj+nC6q9H7phJ+1fjyzVl1HdmO23DgSy5aOAmSsTCxA252M9Yg9BvC7V
 fBfWq94s/PL3SS9Vkb1sarebr6RmjNvw3tuO55f/G355waflWx4d/6rH4Eb3qvtjQEia
 Oh1A==
X-Gm-Message-State: AOAM5335NFhD5nIFm/veYqQxBQ/QAqwLZqJXrvdZbo1O+ZdtjgLsUTYP
 R14LAexDdnwSSbUV7FLhMyLpFMVsswXX2UwyMS4=
X-Google-Smtp-Source: ABdhPJwknJHETyqxJ197sy2tRBtrE2Sb3xH4l4IHiDILEcl11/zJWWcwjzdgE75YizhxKX6kSqXxdGKSu7WmNBo5/Qs=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a1c:7419:0:b0:37b:b96e:81a6 with SMTP
 id p25-20020a1c7419000000b0037bb96e81a6mr12542311wmc.8.1645721737565; Thu, 24
 Feb 2022 08:55:37 -0800 (PST)
Date: Thu, 24 Feb 2022 16:51:03 +0000
In-Reply-To: <20220224165103.1157358-1-sebastianene@google.com>
Message-Id: <20220224165103.1157358-2-sebastianene@google.com>
Mime-Version: 1.0
References: <20220224165103.1157358-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH kvmtool v4 1/3] aarch64: Add stolen time support
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

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 Makefile                               |  1 +
 arm/aarch64/arm-cpu.c                  |  1 +
 arm/aarch64/include/kvm/kvm-cpu-arch.h |  1 +
 arm/aarch64/pvtime.c                   | 94 ++++++++++++++++++++++++++
 arm/include/arm-common/kvm-arch.h      |  6 +-
 include/kvm/kvm-config.h               |  1 +
 6 files changed, 103 insertions(+), 1 deletion(-)
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
index 0000000..8251f6a
--- /dev/null
+++ b/arm/aarch64/pvtime.c
@@ -0,0 +1,94 @@
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/util.h"
+
+#include <linux/byteorder.h>
+#include <linux/types.h>
+
+#define ARM_PVTIME_STRUCT_SIZE		(64)
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
+	mem = mmap(NULL, ARM_PVTIME_MMIO_SIZE, PROT_RW,
+		   MAP_ANON_NORESERVE, -1, 0);
+	if (mem == MAP_FAILED)
+		return -ENOMEM;
+
+	ret = kvm__register_dev_mem(kvm, ARM_PVTIME_MMIO_BASE,
+				    ARM_PVTIME_MMIO_SIZE, mem);
+	if (ret) {
+		munmap(mem, ARM_PVTIME_MMIO_SIZE);
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
+	kvm__destroy_mem(kvm, ARM_PVTIME_MMIO_BASE,
+			 ARM_PVTIME_MMIO_SIZE, pvtime_data.usr_mem);
+	munmap(pvtime_data.usr_mem, ARM_PVTIME_MMIO_SIZE);
+	pvtime_data.usr_mem = NULL;
+	return 0;
+}
+
+void kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu)
+{
+	int ret;
+	u64 pvtime_guest_addr = ARM_PVTIME_MMIO_BASE + vcpu->cpu_id *
+		ARM_PVTIME_STRUCT_SIZE;
+	struct kvm_config *kvm_cfg = NULL;
+	struct kvm_device_attr pvtime_attr = (struct kvm_device_attr) {
+		.group	= KVM_ARM_VCPU_PVTIME_CTRL,
+		.addr	= KVM_ARM_VCPU_PVTIME_IPA
+	};
+
+	BUG_ON(!vcpu);
+	BUG_ON(!vcpu->kvm);
+
+	kvm_cfg = &vcpu->kvm->cfg;
+	if (kvm_cfg && kvm_cfg->no_pvtime)
+		return;
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
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index c645ac0..3f82663 100644
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
 
+#define ARM_PVTIME_MMIO_BASE	(ARM_RTC_MMIO_BASE + ARM_RTC_MMIO_SIZE)
+#define ARM_PVTIME_MMIO_SIZE	SZ_64K
+
 #define KVM_FLASH_MMIO_BASE	(ARM_MMIO_AREA + 0x1000000)
 #define KVM_FLASH_MAX_SIZE	0x1000000
 
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
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

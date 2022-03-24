Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1916C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 24 Mar 2022 15:44:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 283BC49F3E;
	Thu, 24 Mar 2022 11:44:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qIIFko3BPGS1; Thu, 24 Mar 2022 11:43:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6557410BB;
	Thu, 24 Mar 2022 11:43:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79B07410BB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 11:43:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JNo7ZYK358xY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2022 11:43:56 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3216240BBF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 11:43:56 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 h11-20020a5d430b000000b001f01a35a86fso1809786wrq.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 08:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=rWoUPKu0AaJWm8l2aQCNG1PmHsFWS0Tjs1BlR+KeXSo=;
 b=F42fUyJCuMK5arWCFGN29kI5mU1nxES6fc2W7TIjsAOLovM99OY8KNdVq/oTHni2mF
 E7ovxFATJU9oVS/0qDYxcaoyl7zlGDJYMMEoFT33/qBygNRaeenX7k4Y3fYFLGzVIgDD
 91aRQP543zaepKPUwi+uYrTl4byb/pE+gn2DW7113WbzDcqabEfx1/J9gqZx5hkT5Z6Y
 Z9/MA0ILTViF7rYYYSpzAasabejhJjvMGMpU4rMoAZRZn0JlC4kpT6hQt/Sd9Hmph8jB
 +pY1zBgLwVoa8Pca1UkqN6Yq/DNN/GCcPAKmkB98G9sVMakZZgm2cWR307aseM60oYIP
 9X6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=rWoUPKu0AaJWm8l2aQCNG1PmHsFWS0Tjs1BlR+KeXSo=;
 b=43qfz+jH5stu1Z4SWFiVZ3jS0SPgauN3NAhSJtm95rRTm3qxFE7qtMf7sP9E3xc86N
 YuGhIiBi8eh1AAPwJ7WUoEDKNhH79VqKu4msu7azqhOPb8TPV/I7FrT/dZNVW6Thpgl1
 o5URnWO+hFVEunnbzgCpeLtODfHQJnIsQ+3SfADnsQtJUp0AFlqzhlhFjc92K265DLYr
 S6a2zc8fba/ucaNCwsVF6c39NjnUpeDy2VyqVX7lFnarVhkLcCDGaY+5zxjA0BW1FBPL
 3ANzQx0PF0MKg/wcJlUuqGD60ptrFg8+vC/xSLntxvMikhFnEweMwk0d0T2otX4vdPWy
 x+uQ==
X-Gm-Message-State: AOAM531iPFDhgFd7tbPR3L3jGQYdr3FlwRnQYclA42anL6kloLA4Tqts
 sZE1qRZb72t2zEYgKxnplJZ63DaySq2cFOYb/f0=
X-Google-Smtp-Source: ABdhPJx0dUAc+CPGDR5fCVWncoXBTYBEoFnp3BZG+yihBm+1aLnW1hvzxkvOCAtA/5o6APLgOSlW+cYrdOQktSzt0fg=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a1c:7518:0:b0:381:c77:ceec
 with SMTP
 id o24-20020a1c7518000000b003810c77ceecmr5353400wmc.57.1648136624209; Thu, 24
 Mar 2022 08:43:44 -0700 (PDT)
Date: Thu, 24 Mar 2022 15:43:05 +0000
Message-Id: <20220324154304.2572891-1-sebastianene@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH kvmtool v1] Make --no-pvtime command argument arm specific
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

The stolen time option is available only for aarch64 and is enabled by
default. Move the option that disables stolen time functionality in the
arch specific path.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arm/aarch64/include/kvm/kvm-config-arch.h | 5 +++--
 arm/aarch64/pvtime.c                      | 4 ++--
 arm/include/arm-common/kvm-config-arch.h  | 1 +
 builtin-run.c                             | 2 --
 include/kvm/kvm-config.h                  | 1 -
 5 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index 04be43d..a9b0576 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -8,8 +8,9 @@
 			"Create PMUv3 device"),				\
 	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
 			"Specify random seed for Kernel Address Space "	\
-			"Layout Randomization (KASLR)"),
-
+			"Layout Randomization (KASLR)"),		\
+	OPT_BOOLEAN('\0', "no-pvtime", &(cfg)->no_pvtime, "Disable"	\
+			" stolen time"),
 #include "arm-common/kvm-config-arch.h"
 
 #endif /* KVM__KVM_CONFIG_ARCH_H */
diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
index 2f5774e..a49cf3e 100644
--- a/arm/aarch64/pvtime.c
+++ b/arm/aarch64/pvtime.c
@@ -48,13 +48,13 @@ int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu)
 	bool has_stolen_time;
 	u64 pvtime_guest_addr = ARM_PVTIME_BASE + vcpu->cpu_id *
 		ARM_PVTIME_STRUCT_SIZE;
-	struct kvm_config *kvm_cfg = NULL;
+	struct kvm_config_arch *kvm_cfg = NULL;
 	struct kvm_device_attr pvtime_attr = (struct kvm_device_attr) {
 		.group	= KVM_ARM_VCPU_PVTIME_CTRL,
 		.attr	= KVM_ARM_VCPU_PVTIME_IPA
 	};
 
-	kvm_cfg = &vcpu->kvm->cfg;
+	kvm_cfg = &vcpu->kvm->cfg.arch;
 	if (kvm_cfg->no_pvtime)
 		return 0;
 
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 5734c46..9f97778 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -12,6 +12,7 @@ struct kvm_config_arch {
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
 	u64		fw_addr;
+	bool no_pvtime;
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);
diff --git a/builtin-run.c b/builtin-run.c
index 7c8be9d..9a1a0c1 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -128,8 +128,6 @@ void kvm_run_set_wrapper_sandbox(void)
 			" rootfs"),					\
 	OPT_STRING('\0', "hugetlbfs", &(cfg)->hugetlbfs_path, "path",	\
 			"Hugetlbfs path"),				\
-	OPT_BOOLEAN('\0', "no-pvtime", &(cfg)->no_pvtime, "Disable"	\
-			" stolen time"),				\
 									\
 	OPT_GROUP("Kernel options:"),					\
 	OPT_STRING('k', "kernel", &(cfg)->kernel_filename, "kernel",	\
diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
index 48adf27..6a5720c 100644
--- a/include/kvm/kvm-config.h
+++ b/include/kvm/kvm-config.h
@@ -62,7 +62,6 @@ struct kvm_config {
 	bool no_dhcp;
 	bool ioport_debug;
 	bool mmio_debug;
-	bool no_pvtime;
 };
 
 #endif
-- 
2.35.1.894.gb6a874cedc-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

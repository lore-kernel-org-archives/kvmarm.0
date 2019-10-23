Return-Path: <SRS0=cDTT=YQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E95CA9EB9
	for <kvmarm@archiver.kernel.org>; Wed, 23 Oct 2019 13:50:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 46B3C20663
	for <kvmarm@archiver.kernel.org>; Wed, 23 Oct 2019 13:50:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46B3C20663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6D9F4A956;
	Wed, 23 Oct 2019 09:50:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Rfyv1OkmxJ-T; Wed, 23 Oct 2019 09:50:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 919A34A965;
	Wed, 23 Oct 2019 09:50:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88CBA4A956
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Oct 2019 09:50:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2S2xlKVYsgAL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Oct 2019 09:50:38 -0400 (EDT)
Received: from foss.arm.com (unknown [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B5234A955
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Oct 2019 09:50:38 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9FA494A7;
 Wed, 23 Oct 2019 06:50:17 -0700 (PDT)
Received: from [10.1.194.43] (e112269-lin.cambridge.arm.com [10.1.194.43])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C3E743F71F;
 Wed, 23 Oct 2019 06:50:15 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v7 00/10] arm64: Stolen time support
To: Marc Zyngier <maz@kernel.org>
References: <20191021152823.14882-1-steven.price@arm.com>
 <f0d79362ab994e269680fba75f913044@www.loen.fr>
Message-ID: <5b3968d8-9a5a-ee9d-70b3-436dc052dd0a@arm.com>
Date: Wed, 23 Oct 2019 14:50:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <f0d79362ab994e269680fba75f913044@www.loen.fr>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On 23/10/2019 13:39, Marc Zyngier wrote:
> Hi Steven,
> 
> On 2019-10-21 16:28, Steven Price wrote:
>> This series add support for paravirtualized time for arm64 guests and
>> KVM hosts following the specification in Arm's document DEN 0057A:
>>
>> https://developer.arm.com/docs/den0057/a
>>
>> It implements support for stolen time, allowing the guest to
>> identify time when it is forcibly not executing.
>>
>> Note that Live Physical Time (LPT) which was previously part of the
>> above specification has now been removed.
>>
>> Also available as a git tree:
>> git://linux-arm.org/linux-sp.git stolen_time/v7
> 
> Can you please point me to userspace patches that I could apply to
> kvmtool? I'd like to give this series a go as part of my normal testing.

I don't have a proper patch yet, but the below is what I've been testing
with (this breaks with kernels without PV-time).

Steve

----8<----
From 8f6540cfbe2842f3ee422c07fbd1f590534cc90a Mon Sep 17 00:00:00 2001
From: Steven Price <steven.price@arm.com>
Date: Thu, 8 Nov 2018 13:43:56 +0000
Subject: [PATCH kvmtool] ARM PV time support

Signed-off-by: Steven Price <steven.price@arm.com>
---
 Makefile                 |  2 +-
 arm/kvm-cpu.c            |  4 ++++
 arm/pvtime.c             | 47 ++++++++++++++++++++++++++++++++++++++++
 include/kvm/arm-pvtime.h |  6 +++++
 4 files changed, 58 insertions(+), 1 deletion(-)
 create mode 100644 arm/pvtime.c
 create mode 100644 include/kvm/arm-pvtime.h

diff --git a/Makefile b/Makefile
index 3862112..a79956b 100644
--- a/Makefile
+++ b/Makefile
@@ -158,7 +158,7 @@ endif
 # ARM
 OBJS_ARM_COMMON		:= arm/fdt.o arm/gic.o arm/gicv2m.o arm/ioport.o \
 			   arm/kvm.o arm/kvm-cpu.o arm/pci.o arm/timer.o \
-			   arm/pmu.o
+			   arm/pmu.o arm/pvtime.o
 HDRS_ARM_COMMON		:= arm/include
 ifeq ($(ARCH), arm)
 	DEFINES		+= -DCONFIG_ARM
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 7780251..c903b05 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -1,5 +1,6 @@
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
+#include "kvm/arm-pvtime.h"
 
 static int debug_fd;
 
@@ -122,6 +123,9 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	vcpu->cpu_compatible	= target->compatible;
 	vcpu->is_running	= true;
 
+	if (pvtime_vcpu_init(vcpu))
+		die("Unable to initialise pvtime");
+
 	return vcpu;
 }
 
diff --git a/arm/pvtime.c b/arm/pvtime.c
new file mode 100644
index 0000000..fc152d3
--- /dev/null
+++ b/arm/pvtime.c
@@ -0,0 +1,47 @@
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/arm-pvtime.h"
+
+#define PVTIME_BASE 0x10000000
+
+#define KVM_ARM_VCPU_PVTIME_CTRL	2
+#define   KVM_ARM_VCPU_PVTIME_IPA	0
+
+static int pvtime_init(struct kvm *kvm)
+{
+	char *mem;
+	int size = ALIGN(64 * kvm->cfg.nrcpus, PAGE_SIZE);
+
+	mem = mmap(NULL, size, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
+	if (mem == MAP_FAILED)
+		return -ENOMEM;
+
+	if (kvm__register_dev_mem(kvm, PVTIME_BASE, size, mem))
+		return -EINVAL;
+
+	return 0;
+}
+
+base_init(pvtime_init);
+
+int pvtime_vcpu_init(struct kvm_cpu *vcpu)
+{
+	int err;
+	u64 st_paddr = PVTIME_BASE;
+
+	st_paddr += vcpu->cpu_id * 64;
+
+	struct kvm_device_attr st_base = {
+		.group = KVM_ARM_VCPU_PVTIME_CTRL,
+		.attr = KVM_ARM_VCPU_PVTIME_IPA,
+		.addr = (u64)&st_paddr
+	};
+
+	err = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &st_base);
+	if (err) {
+		perror("ioctl st_base failed");
+		return err;
+	}
+
+	return 0;
+}
diff --git a/include/kvm/arm-pvtime.h b/include/kvm/arm-pvtime.h
new file mode 100644
index 0000000..f5db286
--- /dev/null
+++ b/include/kvm/arm-pvtime.h
@@ -0,0 +1,6 @@
+#ifndef ARM_PVTIME_H
+#define ARM_PVTIME_H
+
+int pvtime_vcpu_init(struct kvm_cpu *vcpu);
+
+#endif
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

From: linucherian@gmail.com
Subject: [PATCH] KVM: arm64: Increase number of memslots to 512
Date: Wed, 11 Jan 2017 22:22:17 +0530
Message-ID: <1484153537-20984-1-git-send-email-linucherian@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACDAE403F8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 11:55:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FF7kKKV2NSBR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Jan 2017 11:55:05 -0500 (EST)
Received: from mail-pf0-f195.google.com (mail-pf0-f195.google.com
 [209.85.192.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA90B40354
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 11:55:05 -0500 (EST)
Received: by mail-pf0-f195.google.com with SMTP id 127so33227372pfg.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 08:56:50 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, rkrcmar@redhat.com
Cc: sunil.goutham@cavium.com, Linu Cherian <linu.cherian@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Linu Cherian <linu.cherian@cavium.com>

Having only 32 memslots is a real constraint for the maximum number of
PCI devices that can be assigned to a single guest. Assuming each PCI
device/virtual function having two memory BAR regions, we could assign
only 15 devices/virtual functions to a guest.

So increase KVM_MEM_SLOTS_NUM to 512 as done in other archs like x86 and
powerpc. For this, KVM_USER_MEM_SLOTS has been changed to 508.

Signed-off-by: Linu Cherian <linu.cherian@cavium.com>
---
 arch/arm/kvm/arm.c                | 3 +++
 arch/arm64/include/asm/kvm_host.h | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 8f92efa..a19389b 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -221,6 +221,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
 		break;
+	case KVM_CAP_NR_MEMSLOTS:
+		r = KVM_USER_MEM_SLOTS;
+		break;
 	case KVM_CAP_MSI_DEVID:
 		if (!kvm)
 			r = -EINVAL;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e505038..88f017d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -30,7 +30,7 @@
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
 
-#define KVM_USER_MEM_SLOTS 32
+#define KVM_USER_MEM_SLOTS 508
 #define KVM_PRIVATE_MEM_SLOTS 4
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 #define KVM_HALT_POLL_NS_DEFAULT 500000
-- 
1.9.1

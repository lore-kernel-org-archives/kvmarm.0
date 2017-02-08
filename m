From: linucherian@gmail.com
Subject: [PATCH V2 2/2] KVM: arm64: Increase number of user memslots to 508
Date: Wed,  8 Feb 2017 12:45:41 +0530
Message-ID: <1486538141-30627-3-git-send-email-linucherian@gmail.com>
References: <1486538141-30627-1-git-send-email-linucherian@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54DC940BAC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Feb 2017 02:16:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sYCLOLpoau+6 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Feb 2017 02:16:17 -0500 (EST)
Received: from mail-pg0-f65.google.com (mail-pg0-f65.google.com [74.125.83.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 86C3940962
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Feb 2017 02:16:17 -0500 (EST)
Received: by mail-pg0-f65.google.com with SMTP id 204so14388988pge.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Feb 2017 23:16:50 -0800 (PST)
In-Reply-To: <1486538141-30627-1-git-send-email-linucherian@gmail.com>
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
Cc: sunil.goutham@cavium.com, linu.cherian@cavium.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Linu Cherian <linu.cherian@cavium.com>

Having only 32 memslots is a real constraint for the maximum
number of PCI devices that can be assigned to a single guest.
Assuming each PCI device/virtual function having two memory BAR
regions, we could assign only 15 devices/virtual functions to a
guest.

Hence increase KVM_USER_MEM_SLOTS to 508, so that KVM_MEM_SLOTS_NUM is
512 as done in other archs like x86 and powerpc.

Signed-off-by: Linu Cherian <linu.cherian@cavium.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

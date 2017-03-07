From: linucherian@gmail.com
Subject: [PATCH V3 3/4] KVM: arm/arm64: Remove KVM_PRIVATE_MEM_SLOTS
 definition that are unused
Date: Tue,  7 Mar 2017 11:22:43 +0530
Message-ID: <1488865964-17346-4-git-send-email-linucherian@gmail.com>
References: <1488865964-17346-1-git-send-email-linucherian@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C384840A86
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Mar 2017 00:52:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xfRvobB+9Coz for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Mar 2017 00:52:23 -0500 (EST)
Received: from mail-pf0-f193.google.com (mail-pf0-f193.google.com
 [209.85.192.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF3C340969
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Mar 2017 00:52:22 -0500 (EST)
Received: by mail-pf0-f193.google.com with SMTP id o126so5816684pfb.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Mar 2017 21:53:43 -0800 (PST)
In-Reply-To: <1488865964-17346-1-git-send-email-linucherian@gmail.com>
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
Cc: Linu Cherian <linu.cherian@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Linu Cherian <linu.cherian@cavium.com>

Signed-off-by: Linu Cherian <linu.cherian@cavium.com>
---
 arch/arm/include/asm/kvm_host.h   | 1 -
 arch/arm64/include/asm/kvm_host.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index d5423ab..b9b39f0 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -30,7 +30,6 @@
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
 
 #define KVM_USER_MEM_SLOTS 32
-#define KVM_PRIVATE_MEM_SLOTS 4
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 #define KVM_HAVE_ONE_REG
 #define KVM_HALT_POLL_NS_DEFAULT 500000
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e505038..a0409b0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -31,7 +31,6 @@
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
 
 #define KVM_USER_MEM_SLOTS 32
-#define KVM_PRIVATE_MEM_SLOTS 4
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 #define KVM_HALT_POLL_NS_DEFAULT 500000
 
-- 
1.9.1

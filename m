From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 10/10] KVM: arm64: Increase number of user memslots to 512
Date: Thu,  9 Mar 2017 09:55:39 +0000
Message-ID: <20170309095539.14512-11-marc.zyngier@arm.com>
References: <20170309095539.14512-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0397C40A7B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 04:55:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bqduL6VhHIDb for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 04:55:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 367CB40A66
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 04:55:26 -0500 (EST)
In-Reply-To: <20170309095539.14512-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Linu Cherian <linu.cherian@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Linu Cherian <linu.cherian@cavium.com>

Having only 32 memslots is a real constraint for the maximum
number of PCI devices that can be assigned to a single guest.
Assuming each PCI device/virtual function having two memory BAR
regions, we could assign only 15 devices/virtual functions to a
guest.

Hence increase KVM_USER_MEM_SLOTS to 512 as done in other archs like
powerpc.

Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Linu Cherian <linu.cherian@cavium.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6ac17ee887c9..e7705e7bb07b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -30,7 +30,7 @@
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
 
-#define KVM_USER_MEM_SLOTS 32
+#define KVM_USER_MEM_SLOTS 512
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 #define KVM_HALT_POLL_NS_DEFAULT 500000
 
-- 
2.11.0

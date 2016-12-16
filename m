From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 12/13] KVM: arm: avoid binary number literals for gcc-4.2
Date: Fri, 16 Dec 2016 11:56:33 +0100
Message-ID: <20161216105634.235457-13-arnd@arndb.de>
References: <20161216105634.235457-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A6E5407EF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 05:55:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BLEAnJMaSEi5 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Dec 2016 05:55:41 -0500 (EST)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C266406F1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 05:55:41 -0500 (EST)
In-Reply-To: <20161216105634.235457-1-arnd@arndb.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arch@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, kernel-build-reports@lists.linaro.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Old gcc versions prior to 4.3 don't understand the 0b... syntax for
numbers, and this seems to be the only instance in the kernel, so better
use hexadecimal instead.

arch/arm/include/asm/kvm_mmu.h:127:38: error: invalid suffix "b101" on integer constant

Fixes: 159793001d7d ("ARM: KVM: force cache clean on page fault when caches are off")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/kvm_mmu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 74a44727f8e1..61121300174f 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -124,7 +124,7 @@ struct kvm;
 
 static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 {
-	return (vcpu_cp15(vcpu, c1_SCTLR) & 0b101) == 0b101;
+	return (vcpu_cp15(vcpu, c1_SCTLR) & 0x5) == 0x5;
 }
 
 static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
-- 
2.9.0

From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 05/18] arm64: Add ARM64_HYP_OFFSET_LOW capability
Date: Thu, 30 Jun 2016 18:40:38 +0100
Message-ID: <1467308451-13365-6-git-send-email-marc.zyngier@arm.com>
References: <1467308451-13365-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E74949B68
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 13:35:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m3xI8s5kGb7Q for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2016 13:35:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46AA549B54
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 13:35:47 -0400 (EDT)
In-Reply-To: <1467308451-13365-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

As we need to indicate to the rest of the kernel which region of
the HYP VA space is safe to use, add a capability that will
indicate that KVM should use the [VA_BITS-2:0] range.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/cpufeature.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 224efe7..d40edbb 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -36,8 +36,9 @@
 #define ARM64_HAS_VIRT_HOST_EXTN		11
 #define ARM64_WORKAROUND_CAVIUM_27456		12
 #define ARM64_HAS_32BIT_EL0			13
+#define ARM64_HYP_OFFSET_LOW			14
 
-#define ARM64_NCAPS				14
+#define ARM64_NCAPS				15
 
 #ifndef __ASSEMBLY__
 
-- 
2.1.4

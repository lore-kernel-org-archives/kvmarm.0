From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 17/50] arm64: KVM: Rename HCR_VA to HCR_VSE
Date: Tue, 27 Sep 2016 20:05:25 +0200
Message-ID: <20160927180558.14699-18-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 633BB49B72
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p0aw3al7qF6U for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:56:42 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B96A249B89
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:39 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id 197so30492455wmk.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:03 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

HCR_VA is a leftover from ARMv7, On ARMv8, this is HCR_VSE
(which stands for Virtual System Error), and has better
defined semantics.

Let's rename the constant.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_arm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 4b5c977..2a2752b 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -50,7 +50,7 @@
 #define HCR_BSU		(3 << 10)
 #define HCR_BSU_IS	(UL(1) << 10)
 #define HCR_FB		(UL(1) << 9)
-#define HCR_VA		(UL(1) << 8)
+#define HCR_VSE		(UL(1) << 8)
 #define HCR_VI		(UL(1) << 7)
 #define HCR_VF		(UL(1) << 6)
 #define HCR_AMO		(UL(1) << 5)
@@ -80,7 +80,7 @@
 #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
 			 HCR_TVM | HCR_BSU_IS | HCR_FB | HCR_TAC | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW)
-#define HCR_VIRT_EXCP_MASK (HCR_VA | HCR_VI | HCR_VF)
+#define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
 #define HCR_INT_OVERRIDE   (HCR_FMO | HCR_IMO)
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
-- 
2.9.0

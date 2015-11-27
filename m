From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 17/21] arm64: KVM: Map the kernel RO section into HYP
Date: Fri, 27 Nov 2015 18:50:11 +0000
Message-ID: <1448650215-15218-18-git-send-email-marc.zyngier@arm.com>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4E3D48534
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2015 13:49:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xp3GZyoWSmBZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Nov 2015 13:49:52 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E82949857
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2015 13:49:51 -0500 (EST)
In-Reply-To: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

In order to run C code in HYP, we must make sure that the kernel's
RO section in mapped into HYP (otherwise things break badly).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/arm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index e06fd29..d80aefe 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -44,6 +44,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_coproc.h>
 #include <asm/kvm_psci.h>
+#include <asm/sections.h>
 
 #ifdef REQUIRES_VIRT
 __asm__(".arch_extension	virt");
@@ -1067,6 +1068,12 @@ static int init_hyp_mode(void)
 		goto out_free_mappings;
 	}
 
+	err = create_hyp_mappings(__start_rodata, __end_rodata);
+	if (err) {
+		kvm_err("Cannot map rodata section\n");
+		goto out_free_mappings;
+	}
+
 	/*
 	 * Map the Hyp stack pages
 	 */
-- 
2.1.4

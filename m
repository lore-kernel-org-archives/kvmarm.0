From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 20/31] arm64: KVM: Map the kernel RO section into HYP
Date: Thu, 24 Dec 2015 11:12:28 +0000
Message-ID: <1450955559-15639-21-git-send-email-marc.zyngier@arm.com>
References: <1450955559-15639-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450955559-15639-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Gleb Natapov <gleb@kernel.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Amit Singh Tomar <amittomer25@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, David Binderman <dcb314@hotmail.com>, Fengguang Wu <fengguang.wu@intel.com>, Jisheng Zhang <jszhang@marvell.com>, Mark Rutland <mark.rutland@arm.com>, Pavel Fedin <p.fedin@samsung.com>, Vladimir Murzin <vladimir.murzin@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

In order to run C code in HYP, we must make sure that the kernel's
RO section is mapped into HYP (otherwise things break badly).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 8a79a57..6e35d1d 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -44,6 +44,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_coproc.h>
 #include <asm/kvm_psci.h>
+#include <asm/sections.h>
 
 #ifdef REQUIRES_VIRT
 __asm__(".arch_extension	virt");
@@ -1068,6 +1069,12 @@ static int init_hyp_mode(void)
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


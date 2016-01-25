From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 27/27] ARM: KVM: Remove __kvm_hyp_exit/__kvm_hyp_exit_end
Date: Mon, 25 Jan 2016 16:38:43 +0000
Message-ID: <1453739923-17846-28-git-send-email-marc.zyngier@arm.com>
References: <1453739923-17846-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1453739923-17846-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

I have no idea what these were for - probably a leftover from an
early implementation. Good bye!

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_asm.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 0895f5b..80f4e4a 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -55,9 +55,6 @@ struct kvm_vcpu;
 extern char __kvm_hyp_init[];
 extern char __kvm_hyp_init_end[];
 
-extern char __kvm_hyp_exit[];
-extern char __kvm_hyp_exit_end[];
-
 extern char __kvm_hyp_vector[];
 
 extern void __kvm_flush_vm_context(void);
-- 
2.1.4


From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] arm64: KVM: Do not inject a 64bit fault for a 32bit guest
Date: Thu, 27 Aug 2015 15:05:47 +0100
Message-ID: <1440684348-5292-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Russell King <linux@arm.linux.org.uk>
List-Id: kvmarm@lists.cs.columbia.edu

When injecting a fault into a 32bit guest, it seems rather idiotic
to also inject a 64bit fault that is only going to corrupt the
guest state, and lead to a situation where we restore an illegal
context.

Just fix the stupid bug that has been there from day 1.

Cc: stable@vger.kernel.org
Reported-by: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
Will: Paolo being on holiday, do you mind merging this one
via your tree?

Thanks,

	M.

 arch/arm64/kvm/inject_fault.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index f02530e..85c5715 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -168,8 +168,8 @@ void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr)
 {
 	if (!(vcpu->arch.hcr_el2 & HCR_RW))
 		inject_abt32(vcpu, false, addr);
-
-	inject_abt64(vcpu, false, addr);
+	else
+		inject_abt64(vcpu, false, addr);
 }
 
 /**
@@ -184,8 +184,8 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr)
 {
 	if (!(vcpu->arch.hcr_el2 & HCR_RW))
 		inject_abt32(vcpu, true, addr);
-
-	inject_abt64(vcpu, true, addr);
+	else
+		inject_abt64(vcpu, true, addr);
 }
 
 /**
@@ -198,6 +198,6 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
 {
 	if (!(vcpu->arch.hcr_el2 & HCR_RW))
 		inject_undef32(vcpu);
-
-	inject_undef64(vcpu);
+	else
+		inject_undef64(vcpu);
 }
-- 
2.1.4


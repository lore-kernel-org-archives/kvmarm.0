From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 25/36] KVM: arm64: Prepare to handle traps on deferred
 AArch32 sysregs
Date: Thu,  7 Dec 2017 18:06:19 +0100
Message-ID: <20171207170630.592-26-christoffer.dall@linaro.org>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A947D49D74
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:04:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id onTxAmnXM4tt for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Dec 2017 12:04:06 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D23449DBD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:04:05 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id r78so14371847wme.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Dec 2017 09:07:21 -0800 (PST)
In-Reply-To: <20171207170630.592-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Handle accesses to any AArch32 EL1 system registers where we can defer
saving and restoring them to vcpu_load and vcpu_put, and which are
stored in special EL2 registers only used support 32-bit guests.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 3f765b9de94d..e7234f823cba 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -91,9 +91,16 @@ static inline bool vcpu_mode_is_32bit(const struct kvm_vcpu *vcpu)
 /* Set the SPSR for the current mode */
 static inline void vcpu_set_spsr(struct kvm_vcpu *vcpu, u64 val)
 {
-	if (vcpu_mode_is_32bit(vcpu))
+	if (vcpu_mode_is_32bit(vcpu)) {
+		if (vcpu->arch.sysregs_loaded_on_cpu)
+			__sysreg32_save_state(vcpu);
+
 		*vcpu_spsr32(vcpu) = val;
 
+		if (vcpu->arch.sysregs_loaded_on_cpu)
+			__sysreg32_restore_state(vcpu);
+	}
+
 	if (vcpu->arch.sysregs_loaded_on_cpu)
 		write_sysreg_el1(val, spsr);
 	else
-- 
2.14.2

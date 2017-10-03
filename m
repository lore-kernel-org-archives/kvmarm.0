From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 31/31] KVM: arm64: Fixes to toggle_cache for nesting
Date: Mon,  2 Oct 2017 22:11:13 -0500
Message-ID: <1507000273-3735-29-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83AAF49D49
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9P-bxuXEwLpj for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:54 -0400 (EDT)
Received: from mail-io0-f173.google.com (mail-io0-f173.google.com
 [209.85.223.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 345CB49D3E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:54 -0400 (EDT)
Received: by mail-io0-f173.google.com with SMTP id z187so6429934ioz.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:12:13 -0700 (PDT)
In-Reply-To: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

So far we were flushing almost the entire universe whenever a VM would
load/unload the SCTLR_EL1 and the two versions of that register had
different MMU enabled settings.  This turned out to be so slow that it
prevented forward progress for a nested VM, because a scheduler timer
tick interrupt would always be pending when we reached the nested VM.

To avoid this problem, we consider the SCTLR_EL2 when evaluating if
caches are on or off when entering virtual EL2 (because this is the
value that we end up shadowing onto the hardware EL1 register).

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/include/asm/kvm_mmu.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 601f431..7a1c581 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -240,7 +240,10 @@ static inline bool kvm_page_empty(void *ptr)
 
 static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 {
-	return (vcpu_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
+	if (vcpu_mode_el2(vcpu))
+		return (vcpu_sys_reg(vcpu, SCTLR_EL2) & 0b101) == 0b101;
+	else
+		return (vcpu_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
 }
 
 static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
-- 
1.9.1

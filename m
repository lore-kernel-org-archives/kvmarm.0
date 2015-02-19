From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC/RFT PATCH 3/3] arm64: KVM: keep trapping of VM sysreg writes
 enabled
Date: Thu, 19 Feb 2015 10:54:46 +0000
Message-ID: <1424343286-6792-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B728A46000
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 05:49:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6gHx11KyUGhn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Feb 2015 05:49:42 -0500 (EST)
Received: from mail-wg0-f41.google.com (mail-wg0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CFC5545FFD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 05:49:41 -0500 (EST)
Received: by mail-wg0-f41.google.com with SMTP id b13so6498384wgh.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 02:55:09 -0800 (PST)
In-Reply-To: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: lersek@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, peter.maydell@linaro.org
Cc: pbonzini@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

---
 arch/arm/kvm/mmu.c               | 2 +-
 arch/arm64/include/asm/kvm_arm.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 136662547ca6..fa8ec55220ea 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1530,7 +1530,7 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
 		stage2_flush_vm(vcpu->kvm);
 
 	/* Caches are now on, stop trapping VM ops (until a S/W op) */
-	if (now_enabled)
+	if (0)//now_enabled)
 		vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) & ~HCR_TVM);
 
 	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 8afb863f5a9e..437e1ec17539 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -75,7 +75,7 @@
  * FMO:		Override CPSR.F and enable signaling with VF
  * SWIO:	Turn set/way invalidates into set/way clean+invalidate
  */
-#define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
+#define HCR_GUEST_FLAGS (HCR_TSC | /* HCR_TSW | */ HCR_TWE | HCR_TWI | HCR_VM | \
 			 HCR_TVM | HCR_BSU_IS | HCR_FB | HCR_TAC | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW)
 #define HCR_VIRT_EXCP_MASK (HCR_VA | HCR_VI | HCR_VF)
-- 
1.8.3.2

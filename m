From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 13/50] arm64: KVM: Make kvm_skip_instr32 available to HYP
Date: Tue, 27 Sep 2016 20:05:21 +0200
Message-ID: <20160927180558.14699-14-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B1F949B1A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aojqxHZglo3P for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:56:39 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F92E4998D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:36 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id w84so190347843wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:05:59 -0700 (PDT)
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

As we plan to do some emulation at HYP, let's make kvm_skip_instr32
as part of the hyp_text section. This doesn't preclude the kernel
from using it.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/aarch32.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/aarch32.c b/virt/kvm/arm/aarch32.c
index ba4417b..528af4b 100644
--- a/virt/kvm/arm/aarch32.c
+++ b/virt/kvm/arm/aarch32.c
@@ -23,6 +23,7 @@
 
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_hyp.h>
 
 #ifndef CONFIG_ARM64
 #define COMPAT_PSR_T_BIT	PSR_T_BIT
@@ -108,7 +109,7 @@ bool kvm_condition_valid32(const struct kvm_vcpu *vcpu)
  *
  * IT[7:0] -> CPSR[26:25],CPSR[15:10]
  */
-static void kvm_adjust_itstate(struct kvm_vcpu *vcpu)
+static void __hyp_text kvm_adjust_itstate(struct kvm_vcpu *vcpu)
 {
 	unsigned long itbits, cond;
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
@@ -138,7 +139,7 @@ static void kvm_adjust_itstate(struct kvm_vcpu *vcpu)
  * kvm_skip_instr - skip a trapped instruction and proceed to the next
  * @vcpu: The vcpu pointer
  */
-void kvm_skip_instr32(struct kvm_vcpu *vcpu, bool is_wide_instr)
+void __hyp_text kvm_skip_instr32(struct kvm_vcpu *vcpu, bool is_wide_instr)
 {
 	bool is_thumb;
 
-- 
2.9.0

From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 3/3] kvm: arm64: Disable compiler instrumentation for
 hypervisor code
Date: Tue, 22 Mar 2016 09:19:36 +0100
Message-ID: <1458634776-18388-4-git-send-email-christoffer.dall@linaro.org>
References: <1458634776-18388-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 358FB40C9A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2016 04:18:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g55qk2+luWxK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2016 04:18:48 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5FAD040B40
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2016 04:18:48 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id r129so81032031wmr.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2016 01:19:27 -0700 (PDT)
In-Reply-To: <1458634776-18388-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Catalin Marinas <catalin.marinas@arm.com>

With the recent rewrite of the arm64 KVM hypervisor code in C, enabling
certain options like KASAN would allow the compiler to generate memory
accesses or function calls to addresses not mapped at EL2. This patch
disables the compiler instrumentation on the arm64 hypervisor code for
gcov-based profiling (GCOV_KERNEL), undefined behaviour sanity checker
(UBSAN) and kernel address sanitizer (KASAN).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: <stable@vger.kernel.org> # 4.5+
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index b6a8fc5..778d0ef 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -16,3 +16,7 @@ obj-$(CONFIG_KVM_ARM_HOST) += fpsimd.o
 obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
 obj-$(CONFIG_KVM_ARM_HOST) += hyp-entry.o
 obj-$(CONFIG_KVM_ARM_HOST) += s2-setup.o
+
+GCOV_PROFILE	:= n
+KASAN_SANITIZE	:= n
+UBSAN_SANITIZE	:= n
-- 
2.1.2.330.g565301e.dirty

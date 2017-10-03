From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 07/31] KVM: arm64: Setup vttbr_el2 on each VM entry
Date: Mon,  2 Oct 2017 22:10:49 -0500
Message-ID: <1507000273-3735-5-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70FD649D20
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XnKNSFhacVC7 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:25 -0400 (EDT)
Received: from mail-it0-f42.google.com (mail-it0-f42.google.com
 [209.85.214.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 99A304060C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:25 -0400 (EDT)
Received: by mail-it0-f42.google.com with SMTP id x15so9995532itb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:11:45 -0700 (PDT)
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

Now that the vttbr value will be different depending on the VM's
exception level, we set it on each VM entry.

We only have one mmu instance at this point, but there will be
multiple of them if we come to run nested VMs.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/kvm/context.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/context.c b/arch/arm64/kvm/context.c
index a7811e1..afd1702 100644
--- a/arch/arm64/kvm/context.c
+++ b/arch/arm64/kvm/context.c
@@ -18,6 +18,7 @@
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
 #include <asm/esr.h>
+#include <asm/kvm_mmu.h>
 
 struct el1_el2_map {
 	enum vcpu_sysreg	el1;
@@ -174,6 +175,15 @@ static void flush_shadow_el1_sysregs(struct kvm_vcpu *vcpu)
 		flush_shadow_el1_sysregs_nvhe(vcpu);
 }
 
+static void setup_s2_mmu(struct kvm_vcpu *vcpu)
+{
+	struct kvm_s2_mmu *mmu = &vcpu->kvm->arch.mmu;
+	struct kvm_s2_vmid *vmid = vcpu_get_active_vmid(vcpu);
+
+	vcpu->arch.hw_vttbr = kvm_get_vttbr(vmid, mmu);
+	vcpu->arch.hw_mmu = mmu;
+}
+
 /*
  * List of EL0 and EL1 registers which we allow the virtual EL2 mode to access
  * directly without trapping. This is possible because the impact of
@@ -323,6 +333,8 @@ void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu)
 		setup_mpidr_el1(vcpu);
 		ctxt->hw_sys_regs = ctxt->sys_regs;
 	}
+
+	setup_s2_mmu(vcpu);
 }
 
 /**
-- 
1.9.1

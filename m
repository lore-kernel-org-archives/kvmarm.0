From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 37/55] KVM: arm64: Setup vttbr_el2 on each VM entry
Date: Mon,  9 Jan 2017 01:24:33 -0500
Message-ID: <1483943091-1364-38-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6173340696
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z4gmX7+HE+8D for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:38 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 089014027C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:38 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PXLt017324
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:19 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id A1B187E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:19 -0500 (EST)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu
 [128.59.72.13]) by hazelnut (Postfix) with ESMTP id 780328F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:19 -0500 (EST)
Received: from mail-qk0-f199.google.com (mail-qk0-f199.google.com
 [209.85.220.199])
 by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QJRq041439
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:19 -0500
Received: by mail-qk0-f199.google.com with SMTP id a195so63264029qkg.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:19 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Now that the vttbr value will be different depending on the VM's
exception level, we set it on each VM entry.

We only have one mmu instance at this point, but there will be
multiple of them when we run nested VMs.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/kvm/context.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/context.c b/arch/arm64/kvm/context.c
index a93ffe4..b2c0220 100644
--- a/arch/arm64/kvm/context.c
+++ b/arch/arm64/kvm/context.c
@@ -18,6 +18,7 @@
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
 #include <asm/esr.h>
+#include <asm/kvm_mmu.h>
 
 struct el1_el2_map {
 	enum vcpu_sysreg	el1;
@@ -88,6 +89,15 @@ static void create_shadow_el1_sysregs(struct kvm_vcpu *vcpu)
 	s_sys_regs[CPACR_EL1] = cptr_el2_to_cpacr_el1(el2_regs[CPTR_EL2]);
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
  * List of EL1 registers which we allow the virtual EL2 mode to access
  * directly without trapping and which haven't been paravirtualized.
@@ -166,6 +176,8 @@ void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu)
 	}
 
 	vgic_v2_setup_shadow_state(vcpu);
+
+	setup_s2_mmu(vcpu);
 }
 
 /**
-- 
1.9.1

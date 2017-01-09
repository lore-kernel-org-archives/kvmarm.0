From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 53/55] KVM: arm64: Reflect shadow VMPIDR_EL2 value to MPIDR_EL1
Date: Mon,  9 Jan 2017 01:24:49 -0500
Message-ID: <1483943091-1364-54-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A9A0406A0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Et6UlJf4whxw for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:25:00 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 961AE403FB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:57 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q5Cv006198
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:39 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 168037E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:39 -0500 (EST)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu
 [128.59.72.16]) by hazelnut (Postfix) with ESMTP id BFED783
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:38 -0500 (EST)
Received: from mail-qk0-f200.google.com (mail-qk0-f200.google.com
 [209.85.220.200])
 by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QcBQ005958
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:38 -0500
Received: by mail-qk0-f200.google.com with SMTP id d75so52984504qkc.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:38 -0800 (PST)
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

A non-secure EL0 or EL1 read of MPIDR_EL1 should return the value of
VMPIDR_EL2. We emulate this by copying the virtual VMPIDR_EL2 value to
MPIDR_EL1 when entering VM's EL0 or EL1.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/kvm/context.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/context.c b/arch/arm64/kvm/context.c
index 9ebc38f..dd79b0e 100644
--- a/arch/arm64/kvm/context.c
+++ b/arch/arm64/kvm/context.c
@@ -173,6 +173,12 @@ void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu)
 		ctxt->hw_pstate = *vcpu_cpsr(vcpu);
 		ctxt->hw_sys_regs = ctxt->sys_regs;
 		ctxt->hw_sp_el1 = ctxt->gp_regs.sp_el1;
+
+		/*
+		 * A non-secure EL0 or EL1 read of MPIDR_EL1 returns
+		 * the value of VMPIDR_EL2.
+		 */
+		ctxt->hw_sys_regs[MPIDR_EL1] = ctxt->el2_regs[VMPIDR_EL2];
 	}
 
 	vgic_v2_setup_shadow_state(vcpu);
-- 
1.9.1

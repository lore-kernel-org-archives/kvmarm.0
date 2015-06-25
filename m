From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH 3/3] arm: KVM: Add VFP lazy switch hooks in Host KVM
Date: Wed, 24 Jun 2015 20:30:28 -0700
Message-ID: <1435203028-23142-4-git-send-email-m.smarduch@samsung.com>
References: <1435203028-23142-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93A1956F3C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 23:20:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FVdFG10DZjJW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jun 2015 23:20:06 -0400 (EDT)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DEA7D56F42
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 23:20:06 -0400 (EDT)
Received: from uscpsbgex1.samsung.com
 (u122.gpu85.samsung.co.kr [203.254.195.122]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NQH00HXJDRTDW40@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 24 Jun 2015 23:31:05 -0400 (EDT)
In-reply-to: <1435203028-23142-1-git-send-email-m.smarduch@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch implements host KVM interface to Hyp mode VFP function to 
switch out guest and switch in host.

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm/kvm/arm.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index d9631ec..77b41f5 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -105,6 +105,17 @@ void kvm_arch_check_processor_compat(void *rtn)
 	*(int *)rtn = 0;
 }
 
+/**
+ * kvm_switch_vp_regs() - switch guest/host VFP registers
+ * @vcpu:	pointer to vcpu structure.
+ *
+ * HYP interface functions to save guest and restore host VFP registers
+ */
+static void kvm_switch_fp_regs(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.vfp_guest_saved == 1)
+		kvm_call_hyp(__kvm_restore_host_vfp_state, vcpu);
+}
 
 /**
  * kvm_arch_init_vm - initializes a VM data structure
@@ -292,6 +303,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+
+	/* Check if Guest accessed VFP registers */
+	kvm_switch_fp_regs(vcpu);
+
 	/*
 	 * The arch-generic KVM code expects the cpu field of a vcpu to be -1
 	 * if the vcpu is no longer assigned to a cpu.  This is used for the
-- 
1.7.9.5

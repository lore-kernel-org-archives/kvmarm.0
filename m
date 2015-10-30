From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v3 1/3] KVM/arm: add hooks for armv7 fp/simd lazy switch
 support
Date: Fri, 30 Oct 2015 14:56:31 -0700
Message-ID: <1446242193-8424-2-git-send-email-m.smarduch@samsung.com>
References: <1446242193-8424-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C5E741280
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2015 17:53:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UIX3wMN9rwvv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Oct 2015 17:53:55 -0400 (EDT)
Received: from usmailout3.samsung.com (mailout3.w2.samsung.com
 [211.189.100.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2F8E1410D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2015 17:53:55 -0400 (EDT)
Received: from uscpsbgex1.samsung.com
 (u122.gpu85.samsung.co.kr [203.254.195.122]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NX100JF8ZMV2K50@usmailout3.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 30 Oct 2015 17:56:55 -0400 (EDT)
In-reply-to: <1446242193-8424-1-git-send-email-m.smarduch@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds vcpu fields to track lazy state, save host FPEXC, and
offsets to fields.

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm/include/asm/kvm_host.h | 6 ++++++
 arch/arm/kernel/asm-offsets.c   | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 3df1e97..f1bf551 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -107,6 +107,12 @@ struct kvm_vcpu_arch {
 	/* Interrupt related fields */
 	u32 irq_lines;		/* IRQ and FIQ levels */
 
+	/* fp/simd dirty flag true if guest accessed register file */
+	bool    vfp_dirty;
+
+	/* Save host FPEXC register to later restore on vcpu put */
+	u32	host_fpexc;
+
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
 
diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
index 871b826..9f79712 100644
--- a/arch/arm/kernel/asm-offsets.c
+++ b/arch/arm/kernel/asm-offsets.c
@@ -186,6 +186,8 @@ int main(void)
   DEFINE(VCPU_CPSR,		offsetof(struct kvm_vcpu, arch.regs.usr_regs.ARM_cpsr));
   DEFINE(VCPU_HCR,		offsetof(struct kvm_vcpu, arch.hcr));
   DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
+  DEFINE(VCPU_VFP_DIRTY,	offsetof(struct kvm_vcpu, arch.vfp_dirty));
+  DEFINE(VCPU_VFP_HOST_FPEXC,	offsetof(struct kvm_vcpu, arch.host_fpexc));
   DEFINE(VCPU_HSR,		offsetof(struct kvm_vcpu, arch.fault.hsr));
   DEFINE(VCPU_HxFAR,		offsetof(struct kvm_vcpu, arch.fault.hxfar));
   DEFINE(VCPU_HPFAR,		offsetof(struct kvm_vcpu, arch.fault.hpfar));
-- 
1.9.1

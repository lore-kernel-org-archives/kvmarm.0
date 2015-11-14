From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v4 1/3] KVM/arm/arm64: add hooks for armv7 fp/simd lazy switch
 support
Date: Sat, 14 Nov 2015 14:12:08 -0800
Message-ID: <1447539130-4613-2-git-send-email-m.smarduch@samsung.com>
References: <1447539130-4613-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7570941AF6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Nov 2015 17:12:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VWFM0TknAPLo for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Nov 2015 17:12:04 -0500 (EST)
Received: from usmailout1.samsung.com (mailout1.w2.samsung.com
 [211.189.100.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A5C7148529
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Nov 2015 17:12:04 -0500 (EST)
Received: from uscpsbgex4.samsung.com
 (u125.gpu85.samsung.co.kr [203.254.195.125]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NXT00J1JSCR9N40@mailout1.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Sat, 14 Nov 2015 17:12:27 -0500 (EST)
In-reply-to: <1447539130-4613-1-git-send-email-m.smarduch@samsung.com>
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

From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 24/37] KVM: arm64: Share the parts of get/set events useful to
 32bit
Date: Mon, 13 Aug 2018 15:57:42 +0100
Message-ID: <20180813145755.16566-25-marc.zyngier@arm.com>
References: <20180813145755.16566-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3E644A1DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 11:00:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9ywc8J80aoXi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Aug 2018 11:00:06 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C4DF4A246
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 11:00:06 -0400 (EDT)
In-Reply-To: <20180813145755.16566-1-marc.zyngier@arm.com>
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
Cc: Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Andre Przywara <andre.przywara@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Jia He <jia.he@hxt-semitech.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: James Morse <james.morse@arm.com>

The get/set events helpers to do some work to check reserved
and padding fields are zero. This is useful on 32bit too.

Move this code into virt/kvm/arm/arm.c, and give the arch
code some underscores.

This is temporarily hidden behind __KVM_HAVE_VCPU_EVENTS until
32bit is wired up.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Dongjiu Geng <gengdongjiu@huawei.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  8 ++++----
 arch/arm64/kvm/guest.c            | 21 ++++-----------------
 virt/kvm/arm/arm.c                | 28 ++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bc244cc6e451..f26055f2306e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -350,11 +350,11 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
 int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
-int kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
-			    struct kvm_vcpu_events *events);
+int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
+			      struct kvm_vcpu_events *events);
 
-int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
-			    struct kvm_vcpu_events *events);
+int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
+			      struct kvm_vcpu_events *events);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index dd05be96d981..725c7545e91a 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -289,11 +289,9 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	return -EINVAL;
 }
 
-int kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
-			struct kvm_vcpu_events *events)
+int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
+			      struct kvm_vcpu_events *events)
 {
-	memset(events, 0, sizeof(*events));
-
 	events->exception.serror_pending = !!(vcpu->arch.hcr_el2 & HCR_VSE);
 	events->exception.serror_has_esr = cpus_have_const_cap(ARM64_HAS_RAS_EXTN);
 
@@ -303,23 +301,12 @@ int kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
-			struct kvm_vcpu_events *events)
+int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
+			      struct kvm_vcpu_events *events)
 {
-	int i;
 	bool serror_pending = events->exception.serror_pending;
 	bool has_esr = events->exception.serror_has_esr;
 
-	/* check whether the reserved field is zero */
-	for (i = 0; i < ARRAY_SIZE(events->reserved); i++)
-		if (events->reserved[i])
-			return -EINVAL;
-
-	/* check whether the pad field is zero */
-	for (i = 0; i < ARRAY_SIZE(events->exception.pad); i++)
-		if (events->exception.pad[i])
-			return -EINVAL;
-
 	if (serror_pending && has_esr) {
 		if (!cpus_have_const_cap(ARM64_HAS_RAS_EXTN))
 			return -EINVAL;
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 1c72247aeb1d..14f8fad1c7ae 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1050,6 +1050,34 @@ static int kvm_arm_vcpu_has_attr(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+#ifdef __KVM_HAVE_VCPU_EVENTS	/* temporary: until 32bit is wired up */
+static int kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
+				   struct kvm_vcpu_events *events)
+{
+	memset(events, 0, sizeof(*events));
+
+	return __kvm_arm_vcpu_get_events(vcpu, events);
+}
+
+static int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
+				   struct kvm_vcpu_events *events)
+{
+	int i;
+
+	/* check whether the reserved field is zero */
+	for (i = 0; i < ARRAY_SIZE(events->reserved); i++)
+		if (events->reserved[i])
+			return -EINVAL;
+
+	/* check whether the pad field is zero */
+	for (i = 0; i < ARRAY_SIZE(events->exception.pad); i++)
+		if (events->exception.pad[i])
+			return -EINVAL;
+
+	return __kvm_arm_vcpu_set_events(vcpu, events);
+}
+#endif /* __KVM_HAVE_VCPU_EVENTS */
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
-- 
2.18.0

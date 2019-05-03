Return-Path: <SRS0=WQmE=TD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0862BC004C9
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:46:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BDC8E2075E
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:46:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BDC8E2075E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7513D4A541;
	Fri,  3 May 2019 08:46:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CBjVPYdelXTA; Fri,  3 May 2019 08:46:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22B154A54D;
	Fri,  3 May 2019 08:46:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D8DD4A55C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:46:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JKjCDYagqznf for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 May 2019 08:46:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DDAC4A51F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:46:07 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2740D1682;
 Fri,  3 May 2019 05:46:07 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E3DDB3F220;
 Fri,  3 May 2019 05:46:03 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 24/56] KVM: arm64/sve: Allow userspace to enable SVE for vcpus
Date: Fri,  3 May 2019 13:43:55 +0100
Message-Id: <20190503124427.190206-25-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 "zhang . lei" <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>,
 kvmarm@lists.cs.columbia.edu, Amit Daniel Kachhap <amit.kachhap@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Dave Martin <Dave.Martin@arm.com>

Now that all the pieces are in place, this patch offers a new flag
KVM_ARM_VCPU_SVE that userspace can pass to KVM_ARM_VCPU_INIT to
turn on SVE for the guest, on a per-vcpu basis.

As part of this, support for initialisation and reset of the SVE
vector length set and registers is added in the appropriate places,
as well as finally setting the KVM_ARM64_GUEST_HAS_SVE vcpu flag,
to turn on the SVE support code.

Allocation of the SVE register storage in vcpu->arch.sve_state is
deferred until the SVE configuration is finalized, by which time
the size of the registers is known.

Setting the vector lengths supported by the vcpu is considered
configuration of the emulated hardware rather than runtime
configuration, so no support is offered for changing the vector
lengths available to an existing vcpu across reset.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 +--
 arch/arm64/kvm/reset.c            | 43 ++++++++++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5475cc4df35c..9d57cf8be879 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -49,8 +49,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-/* Will be incremented when KVM_ARM_VCPU_SVE is fully implemented: */
-#define KVM_VCPU_MAX_FEATURES 4
+#define KVM_VCPU_MAX_FEATURES 5
 
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index e7f9c06fdbbb..32c5ac0a3872 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -20,10 +20,12 @@
  */
 
 #include <linux/errno.h>
+#include <linux/kernel.h>
 #include <linux/kvm_host.h>
 #include <linux/kvm.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/types.h>
 
 #include <kvm/arm_arch_timer.h>
@@ -37,6 +39,7 @@
 #include <asm/kvm_coproc.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
+#include <asm/virt.h>
 
 /* Maximum phys_shift supported for any VM on this host */
 static u32 kvm_ipa_limit;
@@ -130,6 +133,27 @@ int kvm_arm_init_arch_resources(void)
 	return 0;
 }
 
+static int kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
+{
+	if (!system_supports_sve())
+		return -EINVAL;
+
+	/* Verify that KVM startup enforced this when SVE was detected: */
+	if (WARN_ON(!has_vhe()))
+		return -EINVAL;
+
+	vcpu->arch.sve_max_vl = kvm_sve_max_vl;
+
+	/*
+	 * Userspace can still customize the vector lengths by writing
+	 * KVM_REG_ARM64_SVE_VLS.  Allocation is deferred until
+	 * kvm_arm_vcpu_finalize(), which freezes the configuration.
+	 */
+	vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_SVE;
+
+	return 0;
+}
+
 /*
  * Finalize vcpu's maximum SVE vector length, allocating
  * vcpu->arch.sve_state as necessary.
@@ -188,13 +212,20 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 	kfree(vcpu->arch.sve_state);
 }
 
+static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
+{
+	if (vcpu_has_sve(vcpu))
+		memset(vcpu->arch.sve_state, 0, vcpu_sve_state_size(vcpu));
+}
+
 /**
  * kvm_reset_vcpu - sets core registers and sys_regs to reset value
  * @vcpu: The VCPU pointer
  *
  * This function finds the right table above and sets the registers on
  * the virtual CPU struct to their architecturally defined reset
- * values.
+ * values, except for registers whose reset is deferred until
+ * kvm_arm_vcpu_finalize().
  *
  * Note: This function can be called from two paths: The KVM_ARM_VCPU_INIT
  * ioctl or as part of handling a request issued by another VCPU in the PSCI
@@ -217,6 +248,16 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	if (loaded)
 		kvm_arch_vcpu_put(vcpu);
 
+	if (!kvm_arm_vcpu_sve_finalized(vcpu)) {
+		if (test_bit(KVM_ARM_VCPU_SVE, vcpu->arch.features)) {
+			ret = kvm_vcpu_enable_sve(vcpu);
+			if (ret)
+				goto out;
+		}
+	} else {
+		kvm_vcpu_reset_sve(vcpu);
+	}
+
 	switch (vcpu->arch.target) {
 	default:
 		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

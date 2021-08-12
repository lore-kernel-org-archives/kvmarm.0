Return-Path: <SRS0=3mia=ND=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A50CC4338F
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 05:09:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D606E60FED
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 05:09:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D606E60FED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E69F4A4A0;
	Thu, 12 Aug 2021 01:09:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cYX2kMQolWCp; Thu, 12 Aug 2021 01:09:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E6114B07F;
	Thu, 12 Aug 2021 01:09:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9805C40569
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 01:09:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KSlPn12VXmeb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Aug 2021 01:09:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DEAE4A3A3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 01:09:29 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2CF281042;
 Wed, 11 Aug 2021 22:09:29 -0700 (PDT)
Received: from p8cg001049571a15.arm.com (unknown [10.163.68.17])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 89A413F40C;
 Wed, 11 Aug 2021 22:09:25 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH V2 4/5] KVM: arm64: Drop check_kvm_target_cpu() based percpu
 probe
Date: Thu, 12 Aug 2021 10:39:53 +0530
Message-Id: <1628744994-16623-5-git-send-email-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1628744994-16623-1-git-send-email-anshuman.khandual@arm.com>
References: <1628744994-16623-1-git-send-email-anshuman.khandual@arm.com>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

kvm_target_cpu() never returns a negative error code, so check_kvm_target()
would never have 'ret' filled with a negative error code. Hence the percpu
probe via check_kvm_target_cpu() does not make sense as its never going to
find an unsupported CPU, forcing kvm_arch_init() to exit early. Hence lets
just drop this percpu probe (and also check_kvm_target_cpu()) altogether.

While here, this also changes kvm_target_cpu() return type to a u32, making
it explicit that an error code will not be returned from this function.

Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-kernel@vger.kernel.org
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/arm.c              | 16 +---------------
 arch/arm64/kvm/guest.c            |  4 ++--
 3 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 41911585ae0c..26bbd84a02de 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -66,7 +66,7 @@ DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 extern unsigned int kvm_sve_max_vl;
 int kvm_arm_init_sve(void);
 
-int __attribute_const__ kvm_target_cpu(void);
+u32 __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 19560e457c11..ee9b1166f330 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1035,7 +1035,7 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 			       const struct kvm_vcpu_init *init)
 {
 	unsigned int i, ret;
-	int phys_target = kvm_target_cpu();
+	u32 phys_target = kvm_target_cpu();
 
 	if (init->target != phys_target)
 		return -EINVAL;
@@ -2010,11 +2010,6 @@ static int finalize_hyp_mode(void)
 	return 0;
 }
 
-static void check_kvm_target_cpu(void *ret)
-{
-	*(int *)ret = kvm_target_cpu();
-}
-
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
 {
 	struct kvm_vcpu *vcpu;
@@ -2074,7 +2069,6 @@ void kvm_arch_irq_bypass_start(struct irq_bypass_consumer *cons)
 int kvm_arch_init(void *opaque)
 {
 	int err;
-	int ret, cpu;
 	bool in_hyp_mode;
 
 	if (!is_hyp_mode_available()) {
@@ -2089,14 +2083,6 @@ int kvm_arch_init(void *opaque)
 		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
 			 "Only trusted guests should be used on this system.\n");
 
-	for_each_online_cpu(cpu) {
-		smp_call_function_single(cpu, check_kvm_target_cpu, &ret, 1);
-		if (ret < 0) {
-			kvm_err("Error, CPU %d not supported!\n", cpu);
-			return -ENODEV;
-		}
-	}
-
 	err = kvm_set_ipa_limit();
 	if (err)
 		return err;
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 1dfb83578277..8ce850fa7b49 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -842,7 +842,7 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-int __attribute_const__ kvm_target_cpu(void)
+u32 __attribute_const__ kvm_target_cpu(void)
 {
 	unsigned long implementor = read_cpuid_implementor();
 	unsigned long part_number = read_cpuid_part_number();
@@ -874,7 +874,7 @@ int __attribute_const__ kvm_target_cpu(void)
 
 int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init)
 {
-	int target = kvm_target_cpu();
+	u32 target = kvm_target_cpu();
 
 	if (target < 0)
 		return -ENODEV;
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

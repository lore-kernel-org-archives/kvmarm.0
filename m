Return-Path: <SRS0=SHHE=UG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A347C2BCA1
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jun 2019 11:27:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E4A0C207E0
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jun 2019 11:27:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4A0C207E0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99F284A51F;
	Fri,  7 Jun 2019 07:27:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YUhUKVhjplz1; Fri,  7 Jun 2019 07:27:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A95D4A50F;
	Fri,  7 Jun 2019 07:27:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C63E4A51E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jun 2019 07:27:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Uwgc66tVO1+m for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jun 2019 07:27:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D49454A521
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jun 2019 07:27:27 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88D8E707;
 Fri,  7 Jun 2019 04:27:26 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AD1BB3F246;
 Fri,  7 Jun 2019 04:29:05 -0700 (PDT)
From: Dave Martin <Dave.Martin@arm.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH kvmtool v4 8/8] arm64: Add SVE support
Date: Fri,  7 Jun 2019 12:26:29 +0100
Message-Id: <1559906789-20936-9-git-send-email-Dave.Martin@arm.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1559906789-20936-1-git-send-email-Dave.Martin@arm.com>
References: <1559906789-20936-1-git-send-email-Dave.Martin@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>,
 Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Amit Daniel Kachhap <amit.kachhap@arm.com>,
 linux-arm-kernel@lists.infradead.org
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

This patch enables the Scalable Vector Extension for the guest when
the host supports it.

This requires use of the new KVM_ARM_VCPU_FINALIZE ioctl before the
vcpu is runnable, so a new hook kvm_cpu__configure_features() is
added to provide an appropriate place to do this work.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>

---

Changes since v3:

 * Drop command-line options and simply default SVE to on where
   supported.
---
 arm/aarch32/include/kvm/kvm-cpu-arch.h |  4 ++++
 arm/aarch64/include/kvm/kvm-cpu-arch.h |  1 +
 arm/aarch64/kvm-cpu.c                  | 18 ++++++++++++++++++
 arm/kvm-cpu.c                          |  3 +++
 4 files changed, 26 insertions(+)

diff --git a/arm/aarch32/include/kvm/kvm-cpu-arch.h b/arm/aarch32/include/kvm/kvm-cpu-arch.h
index 01983f0..780e0e2 100644
--- a/arm/aarch32/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch32/include/kvm/kvm-cpu-arch.h
@@ -15,5 +15,9 @@
 
 static inline void kvm_cpu__select_features(struct kvm *kvm,
 					    struct kvm_vcpu_init *init) { }
+static inline int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
+{
+	return 0;
+}
 
 #endif /* KVM__KVM_CPU_ARCH_H */
diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
index e6875fc..8dfb82e 100644
--- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
@@ -18,5 +18,6 @@
 #define ARM_CPU_CTRL_SCTLR_EL1	0
 
 void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init);
+int kvm_cpu__configure_features(struct kvm_cpu *vcpu);
 
 #endif /* KVM__KVM_CPU_ARCH_H */
diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index 8c29a21..9f3e858 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -136,6 +136,24 @@ void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init)
 		init->features[0] |= 1UL << KVM_ARM_VCPU_PTRAUTH_ADDRESS;
 		init->features[0] |= 1UL << KVM_ARM_VCPU_PTRAUTH_GENERIC;
 	}
+
+	/* Enable SVE if available */
+	if (kvm__supports_extension(kvm, KVM_CAP_ARM_SVE))
+		init->features[0] |= 1UL << KVM_ARM_VCPU_SVE;
+}
+
+int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
+{
+	if (kvm__supports_extension(vcpu->kvm, KVM_CAP_ARM_SVE)) {
+		int feature = KVM_ARM_VCPU_SVE;
+
+		if (ioctl(vcpu->vcpu_fd, KVM_ARM_VCPU_FINALIZE, &feature)) {
+			pr_err("KVM_ARM_VCPU_FINALIZE: %s", strerror(errno));
+			return -1;
+		}
+	}
+
+	return 0;
 }
 
 void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu)
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 1652f6f..554414f 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -124,6 +124,9 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	vcpu->cpu_compatible	= target->compatible;
 	vcpu->is_running	= true;
 
+	if (kvm_cpu__configure_features(vcpu))
+		die("Unable to configure requested vcpu features");
+
 	return vcpu;
 }
 
-- 
2.1.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

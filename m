Return-Path: <SRS0=WQmE=TD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1F5C43219
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:46:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7EEC72075E
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:46:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7EEC72075E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37D874A562;
	Fri,  3 May 2019 08:46:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sSKTH7l62FiR; Fri,  3 May 2019 08:46:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3C114A532;
	Fri,  3 May 2019 08:46:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91BFB4A579
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:46:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K-dxVmUu-n0n for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 May 2019 08:46:53 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8D214A543
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:46:52 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A6C9615AD;
 Fri,  3 May 2019 05:46:52 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6ECD63F220;
 Fri,  3 May 2019 05:46:49 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 37/56] KVM: arm64/sve: Simplify KVM_REG_ARM64_SVE_VLS array
 sizing
Date: Fri,  3 May 2019 13:44:08 +0100
Message-Id: <20190503124427.190206-38-marc.zyngier@arm.com>
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

A complicated DIV_ROUND_UP() expression is currently written out
explicitly in multiple places in order to specify the size of the
bitmap exchanged with userspace to represent the value of the
KVM_REG_ARM64_SVE_VLS pseudo-register.

Userspace currently has no direct way to work this out either: for
documentation purposes, the size is just quoted as 8 u64s.

To make this more intuitive, this patch replaces these with a
single define, which is also exported to userspace as
KVM_ARM64_SVE_VLS_WORDS.

Since the number of words in a bitmap is just the index of the last
word used + 1, this patch expresses the bound that way instead.
This should make it clearer what is being expressed.

For userspace convenience, the minimum and maximum possible vector
lengths relevant to the KVM ABI are exposed to UAPI as
KVM_ARM64_SVE_VQ_MIN, KVM_ARM64_SVE_VQ_MAX.  Since the only direct
use for these at present is manipulation of KVM_REG_ARM64_SVE_VLS,
no corresponding _VL_ macros are defined.  They could be added
later if a need arises.

Since use of DIV_ROUND_UP() was the only reason for including
<linux/kernel.h> in guest.c, this patch also removes that #include.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/api.txt | 10 ++++++----
 arch/arm64/include/uapi/asm/kvm.h |  5 +++++
 arch/arm64/kvm/guest.c            |  7 +++----
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 68509dee23e8..03df379a02b0 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2171,13 +2171,15 @@ and KVM_ARM_VCPU_FINALIZE for more information about this procedure.
 KVM_REG_ARM64_SVE_VLS is a pseudo-register that allows the set of vector
 lengths supported by the vcpu to be discovered and configured by
 userspace.  When transferred to or from user memory via KVM_GET_ONE_REG
-or KVM_SET_ONE_REG, the value of this register is of type __u64[8], and
-encodes the set of vector lengths as follows:
+or KVM_SET_ONE_REG, the value of this register is of type
+__u64[KVM_ARM64_SVE_VLS_WORDS], and encodes the set of vector lengths as
+follows:
 
-__u64 vector_lengths[8];
+__u64 vector_lengths[KVM_ARM64_SVE_VLS_WORDS];
 
 if (vq >= SVE_VQ_MIN && vq <= SVE_VQ_MAX &&
-    ((vector_lengths[(vq - 1) / 64] >> ((vq - 1) % 64)) & 1))
+    ((vector_lengths[(vq - KVM_ARM64_SVE_VQ_MIN) / 64] >>
+		((vq - KVM_ARM64_SVE_VQ_MIN) % 64)) & 1))
 	/* Vector length vq * 16 bytes supported */
 else
 	/* Vector length vq * 16 bytes not supported */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 2a04ef015469..edd2db8e5160 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -258,9 +258,14 @@ struct kvm_vcpu_events {
 	 KVM_REG_SIZE_U256 |						\
 	 ((i) & (KVM_ARM64_SVE_MAX_SLICES - 1)))
 
+#define KVM_ARM64_SVE_VQ_MIN __SVE_VQ_MIN
+#define KVM_ARM64_SVE_VQ_MAX __SVE_VQ_MAX
+
 /* Vector lengths pseudo-register: */
 #define KVM_REG_ARM64_SVE_VLS		(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
 					 KVM_REG_SIZE_U512 | 0xffff)
+#define KVM_ARM64_SVE_VLS_WORDS	\
+	((KVM_ARM64_SVE_VQ_MAX - KVM_ARM64_SVE_VQ_MIN) / 64 + 1)
 
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 73044e3f8706..5bb909c3ff7c 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -23,7 +23,6 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/nospec.h>
-#include <linux/kernel.h>
 #include <linux/kvm_host.h>
 #include <linux/module.h>
 #include <linux/stddef.h>
@@ -210,7 +209,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 #define vq_mask(vq) ((u64)1 << ((vq) - SVE_VQ_MIN) % 64)
 
 static bool vq_present(
-	const u64 (*const vqs)[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)],
+	const u64 (*const vqs)[KVM_ARM64_SVE_VLS_WORDS],
 	unsigned int vq)
 {
 	return (*vqs)[vq_word(vq)] & vq_mask(vq);
@@ -219,7 +218,7 @@ static bool vq_present(
 static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	unsigned int max_vq, vq;
-	u64 vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
+	u64 vqs[KVM_ARM64_SVE_VLS_WORDS];
 
 	if (!vcpu_has_sve(vcpu))
 		return -ENOENT;
@@ -243,7 +242,7 @@ static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	unsigned int max_vq, vq;
-	u64 vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
+	u64 vqs[KVM_ARM64_SVE_VLS_WORDS];
 
 	if (!vcpu_has_sve(vcpu))
 		return -ENOENT;
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

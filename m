Return-Path: <SRS0=5+eb=MG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A1F7C07E9C
	for <kvmarm@archiver.kernel.org>; Wed, 14 Jul 2021 09:55:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 475CA613AB
	for <kvmarm@archiver.kernel.org>; Wed, 14 Jul 2021 09:55:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 475CA613AB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC5AC4B08F;
	Wed, 14 Jul 2021 05:55:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GzVunQ7d+FmI; Wed, 14 Jul 2021 05:55:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5EA44B09A;
	Wed, 14 Jul 2021 05:55:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB4FC4A5A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Jul 2021 05:55:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jCsv3hwl606f for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Jul 2021 05:55:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE3A14B09E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Jul 2021 05:55:12 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 873FB11FB;
 Wed, 14 Jul 2021 02:55:12 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B7443F774;
 Wed, 14 Jul 2021 02:55:11 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH 4/5] KVM: arm64: Add __vcpu_sys_reg()
Date: Wed, 14 Jul 2021 10:56:00 +0100
Message-Id: <20210714095601.184854-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714095601.184854-1-alexandru.elisei@arm.com>
References: <20210714095601.184854-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

Similar to how __ctxt_sys_reg() returns a reference to a system register,
add the __vcpu_sys_reg() macro which returns the pointer, but using a
struct kvm_vcpu as a parameter instead of a kvm_cpu_context.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 arch/arm64/kvm/guest.c            | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 76efede8beae..267b5e6f1c28 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -469,6 +469,8 @@ struct kvm_vcpu_arch {
 
 #define ctxt_sys_reg(c,r)	(*__ctxt_sys_reg(c,r))
 
+#define __vcpu_sys_reg(v,r)	(__ctxt_sys_reg(&(v)->arch.ctxt, (r)))
+
 #define vcpu_sys_reg(v,r)	(ctxt_sys_reg(&(v)->arch.ctxt, (r)))
 
 u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 1dfb83578277..a8c5a76a8e7a 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -148,13 +148,13 @@ static void *core_reg_addr(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		return &vcpu->arch.ctxt.regs.pstate;
 
 	case KVM_REG_ARM_CORE_REG(sp_el1):
-		return __ctxt_sys_reg(&vcpu->arch.ctxt, SP_EL1);
+		return __vcpu_sys_reg(vcpu, SP_EL1);
 
 	case KVM_REG_ARM_CORE_REG(elr_el1):
-		return __ctxt_sys_reg(&vcpu->arch.ctxt, ELR_EL1);
+		return __vcpu_sys_reg(vcpu, ELR_EL1);
 
 	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_EL1]):
-		return __ctxt_sys_reg(&vcpu->arch.ctxt, SPSR_EL1);
+		return __vcpu_sys_reg(vcpu, SPSR_EL1);
 
 	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_ABT]):
 		return &vcpu->arch.ctxt.spsr_abt;
-- 
2.32.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 756B3C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  7 Apr 2022 16:23:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFD6549E57;
	Thu,  7 Apr 2022 12:23:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2rxM1Rj-0vmE; Thu,  7 Apr 2022 12:23:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2610749F09;
	Thu,  7 Apr 2022 12:23:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CB5B49EEF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 12:23:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id phtXtDeqShjs for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2022 12:23:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 493FC49F29
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 12:23:43 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DAD251650;
 Thu,  7 Apr 2022 09:23:42 -0700 (PDT)
Received: from e121798.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 81D6A3F885;
 Thu,  7 Apr 2022 09:23:41 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org, james.morse@arm.com,
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu, mark.rutland@arm.com
Subject: [PATCH 5/5] KVM: arm64: uapi: Add kvm_debug_exit_arch.hsr_high
Date: Thu,  7 Apr 2022 17:23:27 +0100
Message-Id: <20220407162327.396183-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407162327.396183-1-alexandru.elisei@arm.com>
References: <20220407162327.396183-1-alexandru.elisei@arm.com>
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

When userspace is debugging a VM, the kvm_debug_exit_arch part of the
kvm_run struct contains arm64 specific debug information: the ESR_EL2
value, encoded in the field "hsr", and the address of the instruction
that caused the exception, encoded in the field "far".

Linux has moved to treating ESR_EL2 as a 64-bit register, but unfortunately
kvm_debug_exit_arch.hsr cannot be changed to match because that would
change the memory layout of the struct on big endian machines:

Current layout:			| Layout with "hsr" extended to 64 bits:
				|
offset 0: ESR_EL2[31:0] (hsr)   | offset 0: ESR_EL2[61:32] (hsr[61:32])
offset 4: padding		| offset 4: ESR_EL2[31:0]  (hsr[31:0])
offset 8: FAR_EL2[61:0] (far)	| offset 8: FAR_EL2[61:0]  (far)

which breaks existing code.

The padding is inserted by the compiler because the "far" field must be
aligned to 8 bytes (each field must be naturally aligned - aapcs64 [1],
page 18) and the struct itself must be aligned to 8 bytes (the struct must
be aligned to the maximum alignment of its fields - aapcs64, page 18),
which means that "hsr" must be aligned to 8 bytes as it is the first field
in the struct.

To avoid changing the struct size and layout for the existing fields, add a
new field, "hsr_high", which replaces the existing padding. "hsr_high" will
be used to hold the ESR_EL2[61:32] bits of the register. The memory layout,
both on big and little endian machine, becomes:

Layout with "hsr_high" added:

offset 0: ESR_EL2[31:0]  (hsr)
offset 4: ESR_EL2[61:32] (hsr_high)
offset 8: FAR_EL2[61:0]  (far)

[1] https://github.com/ARM-software/abi-aa/releases/download/2021Q3/aapcs64.pdf

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
I'm happy to drop the patch if this change is premature; I made the change
now, instead of waiting until there's a use case for the upper 32 bits, so
userspace has had the time to pick up the updated struct definition by the
time KVM will start making use of the new field.

 arch/arm64/include/uapi/asm/kvm.h | 1 +
 arch/arm64/kvm/handle_exit.c      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index c1b6ddc02d2f..f51f9e413cb8 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -141,6 +141,7 @@ struct kvm_guest_debug_arch {
 
 struct kvm_debug_exit_arch {
 	__u32 hsr;
+	__u32 hsr_high;	/* ESR_EL2[61:32] */
 	__u64 far;	/* used for watchpoints */
 };
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 93d92130d36c..2ccf4e6372c2 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -121,6 +121,7 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
 
 	run->exit_reason = KVM_EXIT_DEBUG;
 	run->debug.arch.hsr = lower_32_bits(esr);
+	run->debug.arch.hsr_high = upper_32_bits(esr);
 
 	if (ESR_ELx_EC(esr) == ESR_ELx_EC_WATCHPT_LOW)
 		run->debug.arch.far = vcpu->arch.fault.far_el2;
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

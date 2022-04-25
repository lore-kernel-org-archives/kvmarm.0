Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B931C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 25 Apr 2022 11:45:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6F334B0B3;
	Mon, 25 Apr 2022 07:45:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mv6H2ZFJ2onu; Mon, 25 Apr 2022 07:45:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F9FC4B1AF;
	Mon, 25 Apr 2022 07:45:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 947ED4B131
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 07:45:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LR09bkH4pbxu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Apr 2022 07:45:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17021410FF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 07:45:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 95F5412FC;
 Mon, 25 Apr 2022 04:45:05 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 332683F73B;
 Mon, 25 Apr 2022 04:45:04 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org, james.morse@arm.com,
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu, mark.rutland@arm.com
Subject: [PATCH v3 5/5] KVM: arm64: uapi: Add kvm_debug_exit_arch.hsr_high
Date: Mon, 25 Apr 2022 12:44:44 +0100
Message-Id: <20220425114444.368693-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220425114444.368693-1-alexandru.elisei@arm.com>
References: <20220425114444.368693-1-alexandru.elisei@arm.com>
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
kvm_debug_exit_arch.hsr cannot be changed because that would change the
memory layout of the struct on big endian machines:

Current layout:			| Layout with "hsr" extended to 64 bits:
				|
offset 0: ESR_EL2[31:0] (hsr)   | offset 0: ESR_EL2[61:32] (hsr[61:32])
offset 4: padding		| offset 4: ESR_EL2[31:0]  (hsr[31:0])
offset 8: FAR_EL2[61:0] (far)	| offset 8: FAR_EL2[61:0]  (far)

which breaks existing code.

The padding is inserted by the compiler because the "far" field must be
aligned to 8 bytes (each field must be naturally aligned - aapcs64 [1],
page 18), and the struct itself must be aligned to 8 bytes (the struct must
be aligned to the maximum alignment of its fields - aapcs64, page 18),
which means that "hsr" must be aligned to 8 bytes as it is the first field
in the struct.

To avoid changing the struct size and layout for the existing fields, add a
new field, "hsr_high", which replaces the existing padding. "hsr_high" will
be used to hold the ESR_EL2[61:32] bits of the register. The memory layout,
both on big and little endian machine, becomes:

offset 0: ESR_EL2[31:0]  (hsr)
offset 4: ESR_EL2[61:32] (hsr_high)
offset 8: FAR_EL2[61:0]  (far)

The padding that the compiler inserts for the current struct layout is
unitialized. To prevent an updated userspace running on an old kernel
mistaking the padding for a valid "hsr_high" value, add a new flag,
KVM_DEBUG_ARCH_HSR_HIGH_VALID, to kvm_run->flags to let userspace know that
"hsr_high" holds a valid ESR_EL2[61:32] value.

[1] https://github.com/ARM-software/abi-aa/releases/download/2021Q3/aapcs64.pdf

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/api.rst    | 2 ++
 arch/arm64/include/uapi/asm/kvm.h | 2 ++
 arch/arm64/kvm/arm.c              | 1 +
 arch/arm64/kvm/handle_exit.c      | 2 ++
 4 files changed, 7 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 85c7abc51af5..ecd70d99f3e0 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5713,6 +5713,8 @@ affect the device's behavior. Current defined flags::
   #define KVM_RUN_X86_SMM     (1 << 0)
   /* x86, set if bus lock detected in VM */
   #define KVM_RUN_BUS_LOCK    (1 << 1)
+  /* arm64, set for KVM_EXIT_DEBUG */
+  #define KVM_DEBUG_ARCH_HSR_HIGH_VALID  (1 << 0)
 
 ::
 
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index c1b6ddc02d2f..ab585359242d 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -139,8 +139,10 @@ struct kvm_guest_debug_arch {
 	__u64 dbg_wvr[KVM_ARM_MAX_DBG_REGS];
 };
 
+#define KVM_DEBUG_ARCH_HSR_HIGH_VALID	(1 << 0)
 struct kvm_debug_exit_arch {
 	__u32 hsr;
+	__u32 hsr_high;	/* ESR_EL2[61:32] */
 	__u64 far;	/* used for watchpoints */
 };
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 523bc934fe2f..7ef4fd2fe20a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -783,6 +783,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	ret = 1;
 	run->exit_reason = KVM_EXIT_UNKNOWN;
+	run->flags = 0;
 	while (ret > 0) {
 		/*
 		 * Check conditions before entering the guest
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 93d92130d36c..0b829292dc54 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -121,6 +121,8 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
 
 	run->exit_reason = KVM_EXIT_DEBUG;
 	run->debug.arch.hsr = lower_32_bits(esr);
+	run->debug.arch.hsr_high = upper_32_bits(esr);
+	run->flags = KVM_DEBUG_ARCH_HSR_HIGH_VALID;
 
 	if (ESR_ELx_EC(esr) == ESR_ELx_EC_WATCHPT_LOW)
 		run->debug.arch.far = vcpu->arch.fault.far_el2;
-- 
2.36.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E12F6C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:48:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A070A4B4C9;
	Thu, 19 May 2022 09:48:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BBGzEEV3Lwr7; Thu, 19 May 2022 09:48:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27F114B4E0;
	Thu, 19 May 2022 09:48:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE9194B4C2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:48:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K2kIMNpoST-6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:48:12 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B9A484B466
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:48:11 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id CEDE161790;
 Thu, 19 May 2022 13:48:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2605C34117;
 Thu, 19 May 2022 13:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652968090;
 bh=OVnUUIfJD5cEpFAJ7GyZGCXUvefbmDSGP1cFzFXgN2I=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=d971vyFNl+PaYVERA4ZRaeJkiiGI0hjyo6CHX66oWawBWpjjLcxD5zF9/9+Z3ZsgR
 igaiFl2all+VZWDRB59V7iS6ax0UkAUmN19WjqHJQna0jyLuwEskRKS4lXC2zbE1MD
 ci5Wu3x+zdeDuw+UpChBuQAe9dXYd52184lZ8lMrrfLYbx0h0+BGX+f6PwF+WydyAL
 eUr7BDpgQRvaL4e7juNkF1ds+0xdn96cg92oWtqi9DWYDkR4ZT/BzKoQE4bG7nU/DZ
 A7yQyTwCLgjjYLFVzA9tww4Xf850s8arEhVC9uW+WIoIeZ8xd0Xw59MeS/WKRDlPxn
 2+7YyRN3B+n+w==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 87/89] KVM: arm64: Expose memory sharing hypercalls to
 protected guests
Date: Thu, 19 May 2022 14:42:02 +0100
Message-Id: <20220519134204.5379-88-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

Extend our KVM "vendor" hypercalls to expose three new hypercalls to
protected guests for the purpose of opening and closing shared memory
windows with the host:

  MEMINFO:	Query the stage-2 page size (i.e. the minimum granule at
		which memory can be shared)

  MEM_SHARE:	Share a page RWX with the host, faulting the page in if
  		necessary.

  MEM_UNSHARE:	Unshare a page with the host. Subsequent host accesses
		to the page will result in a fault being injected by the
		hypervisor.

Signed-off-by: Will Deacon <will@kernel.org>
---
 Documentation/virt/kvm/arm/hypercalls.rst |  72 ++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c        |  24 ++++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c            | 109 +++++++++++++++++++++-
 include/linux/arm-smccc.h                 |  21 +++++
 4 files changed, 223 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
index 17be111f493f..d96c9fd7d8c5 100644
--- a/Documentation/virt/kvm/arm/hypercalls.rst
+++ b/Documentation/virt/kvm/arm/hypercalls.rst
@@ -44,3 +44,75 @@ Provides a discovery mechanism for other KVM/arm64 hypercalls.
 ----------------------------------------
 
 See ptp_kvm.rst
+
+``ARM_SMCCC_KVM_FUNC_HYP_MEMINFO``
+----------------------------------
+
+Query the memory protection parameters for a protected virtual machine.
+
++---------------------+-------------------------------------------------------------+
+| Presence:           | Optional; protected guests only.                            |
++---------------------+-------------------------------------------------------------+
+| Calling convention: | HVC64                                                       |
++---------------------+----------+--------------------------------------------------+
+| Function ID:        | (uint32) | 0xC6000002                                       |
++---------------------+----------+----+---------------------------------------------+
+| Arguments:          | (uint64) | R1 | Reserved / Must be zero                     |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint64) | R2 | Reserved / Must be zero                     |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint64) | R3 | Reserved / Must be zero                     |
++---------------------+----------+----+---------------------------------------------+
+| Return Values:      | (int64)  | R0 | ``INVALID_PARAMETER (-3)`` on error, else   |
+|                     |          |    | memory protection granule in bytes          |
++---------------------+----------+----+---------------------------------------------+
+
+``ARM_SMCCC_KVM_FUNC_MEM_SHARE``
+--------------------------------
+
+Share a region of memory with the KVM host, granting it read, write and execute
+permissions. The size of the region is equal to the memory protection granule
+advertised by ``ARM_SMCCC_KVM_FUNC_HYP_MEMINFO``.
+
++---------------------+-------------------------------------------------------------+
+| Presence:           | Optional; protected guests only.                            |
++---------------------+-------------------------------------------------------------+
+| Calling convention: | HVC64                                                       |
++---------------------+----------+--------------------------------------------------+
+| Function ID:        | (uint32) | 0xC6000003                                       |
++---------------------+----------+----+---------------------------------------------+
+| Arguments:          | (uint64) | R1 | Base IPA of memory region to share          |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint64) | R2 | Reserved / Must be zero                     |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint64) | R3 | Reserved / Must be zero                     |
++---------------------+----------+----+---------------------------------------------+
+| Return Values:      | (int64)  | R0 | ``SUCCESS (0)``                             |
+|                     |          |    +---------------------------------------------+
+|                     |          |    | ``INVALID_PARAMETER (-3)``                  |
++---------------------+----------+----+---------------------------------------------+
+
+``ARM_SMCCC_KVM_FUNC_MEM_UNSHARE``
+----------------------------------
+
+Revoke access permission from the KVM host to a memory region previously shared
+with ``ARM_SMCCC_KVM_FUNC_MEM_SHARE``. The size of the region is equal to the
+memory protection granule advertised by ``ARM_SMCCC_KVM_FUNC_HYP_MEMINFO``.
+
++---------------------+-------------------------------------------------------------+
+| Presence:           | Optional; protected guests only.                            |
++---------------------+-------------------------------------------------------------+
+| Calling convention: | HVC64                                                       |
++---------------------+----------+--------------------------------------------------+
+| Function ID:        | (uint32) | 0xC6000004                                       |
++---------------------+----------+----+---------------------------------------------+
+| Arguments:          | (uint64) | R1 | Base IPA of memory region to unshare        |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint64) | R2 | Reserved / Must be zero                     |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint64) | R3 | Reserved / Must be zero                     |
++---------------------+----------+----+---------------------------------------------+
+| Return Values:      | (int64)  | R0 | ``SUCCESS (0)``                             |
+|                     |          |    +---------------------------------------------+
+|                     |          |    | ``INVALID_PARAMETER (-3)``                  |
++---------------------+----------+----+---------------------------------------------+
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 694e0071b13e..be000d457e44 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -45,7 +45,7 @@ static void handle_pvm_entry_wfx(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *sh
 				   KVM_ARM64_INCREMENT_PC;
 }
 
-static void handle_pvm_entry_hvc64(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *shadow_vcpu)
+static void handle_pvm_entry_psci(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *shadow_vcpu)
 {
 	u32 psci_fn = smccc_get_function(shadow_vcpu);
 	u64 ret = READ_ONCE(host_vcpu->arch.ctxt.regs.regs[0]);
@@ -81,6 +81,22 @@ static void handle_pvm_entry_hvc64(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *
 	vcpu_set_reg(shadow_vcpu, 0, ret);
 }
 
+static void handle_pvm_entry_hvc64(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *shadow_vcpu)
+{
+	u32 fn = smccc_get_function(shadow_vcpu);
+
+	switch (fn) {
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID:
+		fallthrough;
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID:
+		vcpu_set_reg(shadow_vcpu, 0, SMCCC_RET_SUCCESS);
+		break;
+	default:
+		handle_pvm_entry_psci(host_vcpu, shadow_vcpu);
+		break;
+	}
+}
+
 static void handle_pvm_entry_sys64(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *shadow_vcpu)
 {
 	unsigned long host_flags;
@@ -257,6 +273,12 @@ static void handle_pvm_exit_hvc64(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *s
 		n = 1;
 		break;
 
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID:
+		fallthrough;
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID:
+		n = 4;
+		break;
+
 	case PSCI_1_1_FN_SYSTEM_RESET2:
 	case PSCI_1_1_FN64_SYSTEM_RESET2:
 		n = 3;
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index d44f524c936b..e33ba9067d7b 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -1118,6 +1118,82 @@ static bool pkvm_handle_psci(struct kvm_vcpu *vcpu)
 	return pvm_psci_not_supported(vcpu);
 }
 
+static u64 __pkvm_memshare_page_req(struct kvm_vcpu *vcpu, u64 ipa)
+{
+	u64 elr;
+
+	/* Fake up a data abort (Level 3 translation fault on write) */
+	vcpu->arch.fault.esr_el2 = (u32)ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT |
+				   ESR_ELx_WNR | ESR_ELx_FSC_FAULT |
+				   FIELD_PREP(ESR_ELx_FSC_LEVEL, 3);
+
+	/* Shuffle the IPA around into the HPFAR */
+	vcpu->arch.fault.hpfar_el2 = (ipa >> 8) & HPFAR_MASK;
+
+	/* This is a virtual address. 0's good. Let's go with 0. */
+	vcpu->arch.fault.far_el2 = 0;
+
+	/* Rewind the ELR so we return to the HVC once the IPA is mapped */
+	elr = read_sysreg(elr_el2);
+	elr -= 4;
+	write_sysreg(elr, elr_el2);
+
+	return ARM_EXCEPTION_TRAP;
+}
+
+static bool pkvm_memshare_call(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	u64 ipa = smccc_get_arg1(vcpu);
+	u64 arg2 = smccc_get_arg2(vcpu);
+	u64 arg3 = smccc_get_arg3(vcpu);
+	int err;
+
+	if (arg2 || arg3)
+		goto out_guest_err;
+
+	err = __pkvm_guest_share_host(vcpu, ipa);
+	switch (err) {
+	case 0:
+		/* Success! Now tell the host. */
+		goto out_host;
+	case -EFAULT:
+		/*
+		 * Convert the exception into a data abort so that the page
+		 * being shared is mapped into the guest next time.
+		 */
+		*exit_code = __pkvm_memshare_page_req(vcpu, ipa);
+		goto out_host;
+	}
+
+out_guest_err:
+	smccc_set_retval(vcpu, SMCCC_RET_INVALID_PARAMETER, 0, 0, 0);
+	return true;
+
+out_host:
+	return false;
+}
+
+static bool pkvm_memunshare_call(struct kvm_vcpu *vcpu)
+{
+	u64 ipa = smccc_get_arg1(vcpu);
+	u64 arg2 = smccc_get_arg2(vcpu);
+	u64 arg3 = smccc_get_arg3(vcpu);
+	int err;
+
+	if (arg2 || arg3)
+		goto out_guest_err;
+
+	err = __pkvm_guest_unshare_host(vcpu, ipa);
+	if (err)
+		goto out_guest_err;
+
+	return false;
+
+out_guest_err:
+	smccc_set_retval(vcpu, SMCCC_RET_INVALID_PARAMETER, 0, 0, 0);
+	return true;
+}
+
 /*
  * Handler for protected VM HVC calls.
  *
@@ -1127,13 +1203,42 @@ static bool pkvm_handle_psci(struct kvm_vcpu *vcpu)
 bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	u32 fn = smccc_get_function(vcpu);
+	u64 val[4] = { SMCCC_RET_NOT_SUPPORTED };
 
 	switch (fn) {
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		/* Nothing to be handled by the host. Go back to the guest. */
-		smccc_set_retval(vcpu, ARM_SMCCC_VERSION_1_1, 0, 0, 0);
-		return true;
+		val[0] = ARM_SMCCC_VERSION_1_1;
+		break;
+	case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
+		val[0] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0;
+		val[1] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1;
+		val[2] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2;
+		val[3] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3;
+		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
+		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
+		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_HYP_MEMINFO);
+		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MEM_SHARE);
+		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MEM_UNSHARE);
+		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_HYP_MEMINFO_FUNC_ID:
+		if (smccc_get_arg1(vcpu) ||
+		    smccc_get_arg2(vcpu) ||
+		    smccc_get_arg3(vcpu)) {
+			val[0] = SMCCC_RET_INVALID_PARAMETER;
+		} else {
+			val[0] = PAGE_SIZE;
+		}
+		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID:
+		return pkvm_memshare_call(vcpu, exit_code);
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID:
+		return pkvm_memunshare_call(vcpu);
 	default:
 		return pkvm_handle_psci(vcpu);
 	}
+
+	smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
+	return true;
 }
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 220c8c60e021..25c576a910df 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -112,6 +112,9 @@
 /* KVM "vendor specific" services */
 #define ARM_SMCCC_KVM_FUNC_FEATURES		0
 #define ARM_SMCCC_KVM_FUNC_PTP			1
+#define ARM_SMCCC_KVM_FUNC_HYP_MEMINFO		2
+#define ARM_SMCCC_KVM_FUNC_MEM_SHARE		3
+#define ARM_SMCCC_KVM_FUNC_MEM_UNSHARE		4
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -134,6 +137,24 @@
 			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
 			   ARM_SMCCC_KVM_FUNC_PTP)
 
+#define ARM_SMCCC_VENDOR_HYP_KVM_HYP_MEMINFO_FUNC_ID			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_HYP_MEMINFO)
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_MEM_SHARE)
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_MEM_UNSHARE)
+
 /* ptp_kvm counter type ID */
 #define KVM_PTP_VIRT_COUNTER			0
 #define KVM_PTP_PHYS_COUNTER			1
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

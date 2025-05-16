Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B06823C8A0;
	Fri, 16 May 2025 12:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747397651; cv=none; b=bh8/7ZddxjoRiCRjipwsi9JIrz7nkSdQs/pNr5fV9k7MdDb3SYB2suS5std3udtLaGFP9GL+ZY5HeS72LVVn5YrnIfCLFZQgNoB6EMEY2l/7T6CyadZVjc0ZYGnz54twysyj6ntl8G4Wv1F3bw2a8NjwYlakmI3RoDvjCt0vMxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747397651; c=relaxed/simple;
	bh=AbTOZo2bIHYa+AuZXgK7wBfGLHVL/DsMiueumhxEIwI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OH53AFU2gDXNhVFxu1HtKtahsQQDIMEk8DXlWrV8omp+GbYW69XwFSCdbRmhLl6LeUn+S74w9R1x8QfjUijycmmdpD1ozCr71QduKaLIWnQGqOJnWwyTFB6ehJAQoNH7gK+tQubDdSBaNpmk8emlBady7PDCTgS+VKbN5tHAbXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ozuVXQL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ozuVXQL9"
Received: by smtp.kernel.org (Postfix) with ESMTPS id DDD8FC4CEF4;
	Fri, 16 May 2025 12:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747397650;
	bh=AbTOZo2bIHYa+AuZXgK7wBfGLHVL/DsMiueumhxEIwI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ozuVXQL9pso3mx6vj2sKLbWCP2SVEwtcSjwdfJZBf3ZKM/qlaYB7yf/S5tOHzqaSI
	 uAZOEJt4Sb6EMqujqKzB08x1gxx9rCJF2khiBlJ3NBzM6fAAyIJVMOwAkm4ntfLple
	 PU2kYFTHJeGqDQ/Iko8/tvMquLLoZEFLxj7swdUJRTn88kBJSaS9RMR6opO2g+zvtM
	 1R5YybYN8sLr1eEYqIPlynWoZ/mDvkfcycO+yifMJjpm116YZV/TFwG4k0bITVw5GN
	 2oW5BtwVRJsM2bzXKWu0Q6dddGaf+9q0nrIWbf5onGRHsek3KZ3Eykf1sbq8SCKNT+
	 JQb+i2Urn84Yw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E1EC54755;
	Fri, 16 May 2025 12:14:10 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Fri, 16 May 2025 12:14:03 +0000
Subject: [PATCH v4 4/5] KVM: arm64: Bump the supported version of FF-A to
 1.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250516-virtio-msg-ffa-v4-4-580ee70e5081@google.com>
References: <20250516-virtio-msg-ffa-v4-0-580ee70e5081@google.com>
In-Reply-To: <20250516-virtio-msg-ffa-v4-0-580ee70e5081@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, sebastianene@google.com, qperret@google.com, 
 qwandor@google.com, arve@android.com, perl@immunant.com, 
 lpieralisi@kernel.org, kernel-team@android.com, tabba@google.com, 
 james.morse@arm.com, armellel@google.com, jean-philippe@linaro.org, 
 ahomescu@google.com, Ayrton Munoz <ayrton@google.com>, 
 Per Larsen <perlarsen@google.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1747397650; l=6027;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=CRuCyLKNFxMaf56e9Y4I4+VaRj1h0S9SBtIGcRCH7Y8=;
 b=LXvUXDce7fu7RCfcKhj2RihIzanwXdYDk53LfDW/aC5vxWH+lOcb0BKUEie3ZMvMBmKKGHBNh
 pzWxOwfuYQZAlgWXTgUhrRH5mblPsS2RiWEdqhkvVTJ65xUpgC/WZ9K
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

From: Per Larsen <perlarsen@google.com>

FF-A version 1.2 introduces the DIRECT_REQ2 ABI. Bump the FF-A version
preferred by the hypervisor as a precursor to implementing the 1.2-only
FFA_MSG_SEND_DIRECT_REQ2 and FFA_MSG_SEND_RESP2 messaging interfaces.

We must also use SMCCC 1.2 for 64-bit SMCs if hypervisor negotiated FF-A
1.2, so ffa_set_retval is updated and a new function to call 64-bit smcs
using SMCCC 1.2 with fallback to SMCCC 1.1 is introduced.

Update ffa_call_supported to mark FF-A 1.2 interfaces as unsupported
lest they get forwarded.

Co-developed-by: Ayrton Munoz <ayrton@google.com>
Signed-off-by: Ayrton Munoz <ayrton@google.com>
Signed-off-by: Per Larsen <perlarsen@google.com>
---
 arch/arm64/kvm/hyp/nvhe/Makefile |  1 +
 arch/arm64/kvm/hyp/nvhe/ffa.c    | 61 ++++++++++++++++++++++++++++++++++++----
 include/linux/arm_ffa.h          |  1 +
 3 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index b43426a493df5a388caa920e259cc8c54d118a1b..95404ff16dac0389f45a3ee2c13a93b3ebebaf6d 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -27,6 +27,7 @@ hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o
 	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
+hyp-obj-y += ../../../kernel/smccc-call.o
 hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
 hyp-obj-y += $(lib-objs)
 
diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index a545d25002c85b79a8d281739479dab7838a7cd3..0b952ace29f6847b4e941262c4c1b05a5bc13e5a 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -105,6 +105,48 @@ static void ffa_set_retval(struct kvm_cpu_context *ctxt,
 	cpu_reg(ctxt, 5) = 0;
 	cpu_reg(ctxt, 6) = 0;
 	cpu_reg(ctxt, 7) = 0;
+
+	/*
+	 * Per DEN0077A v1.2 11.2, the caller is expected to write zeroes to
+	 * unused parameter registers.
+	 */
+	if (ARM_SMCCC_IS_64(res->a0)) {
+		/* Prevent race with CPU performing version negotiation */
+		if (smp_load_acquire(&has_version_negotiated) &&
+			hyp_ffa_version >= FFA_VERSION_1_2) {
+			cpu_reg(ctxt, 8) = 0;
+			cpu_reg(ctxt, 9) = 0;
+			cpu_reg(ctxt, 10) = 0;
+			cpu_reg(ctxt, 11) = 0;
+			cpu_reg(ctxt, 12) = 0;
+			cpu_reg(ctxt, 13) = 0;
+			cpu_reg(ctxt, 14) = 0;
+			cpu_reg(ctxt, 15) = 0;
+			cpu_reg(ctxt, 16) = 0;
+			cpu_reg(ctxt, 17) = 0;
+		}
+	}
+}
+
+/* Call SMC64 using SMCCC 1.2 if hyp negotiated FF-A 1.2 falling back to 1.1 */
+static void arm_smccc_1_x_smc(u64 func_id, u64 a1, u64 a2, u64 a3,
+			      u64 a4, u64 a5, u64 a6, u64 a7,
+			      struct arm_smccc_res *res)
+{
+	struct arm_smccc_1_2_regs args, regs = {0};
+
+	/* SMC64 only as SMC32 must preserve x8-x30 per DEN0028 1.6G Sec 2.6 */
+	if (ARM_SMCCC_IS_64(func_id) &&
+		hyp_ffa_version >= FFA_VERSION_1_2) {
+		args = (struct arm_smccc_1_2_regs) { func_id, a1, a2, a3, a4,
+						     a5, a6, a7 };
+		arm_smccc_1_2_smc(&args, &regs);
+		*res = (struct arm_smccc_res) { .a0 = regs.a0, .a1 = regs.a1,
+						.a2 = regs.a2, .a3 = regs.a3 };
+		return;
+	}
+
+	arm_smccc_1_1_smc(func_id, a1, a2, a3, a4, a5, a6, a7, res);
 }
 
 static bool is_ffa_call(u64 func_id)
@@ -119,7 +161,7 @@ static int ffa_map_hyp_buffers(u64 ffa_page_count)
 {
 	struct arm_smccc_res res;
 
-	arm_smccc_1_1_smc(FFA_FN64_RXTX_MAP,
+	arm_smccc_1_x_smc(FFA_FN64_RXTX_MAP,
 			  hyp_virt_to_phys(hyp_buffers.tx),
 			  hyp_virt_to_phys(hyp_buffers.rx),
 			  ffa_page_count,
@@ -178,7 +220,7 @@ static void ffa_mem_reclaim(struct arm_smccc_res *res, u32 handle_lo,
 
 static void ffa_retrieve_req(struct arm_smccc_res *res, u32 len)
 {
-	arm_smccc_1_1_smc(FFA_FN64_MEM_RETRIEVE_REQ,
+	arm_smccc_1_x_smc(FFA_FN64_MEM_RETRIEVE_REQ,
 			  len, len,
 			  0, 0, 0, 0, 0,
 			  res);
@@ -640,6 +682,12 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
+	/* Unimplemented interfaces added in FF-A 1.2 */
+	case FFA_MSG_SEND_DIRECT_REQ2:
+	case FFA_MSG_SEND_DIRECT_RESP2:
+	case FFA_CONSOLE_LOG:
+	case FFA_PARTITION_INFO_GET_REGS:
+	case FFA_EL3_INTR_HANDLE:
 		return false;
 	}
 
@@ -692,7 +740,7 @@ static int hyp_ffa_post_init(void)
 	if (res.a0 != FFA_SUCCESS)
 		return -EOPNOTSUPP;
 
-	switch (res.a2) {
+	switch (res.a2 & FFA_FEAT_RXTX_MIN_SZ_MASK) {
 	case FFA_FEAT_RXTX_MIN_SZ_4K:
 		min_rxtx_sz = SZ_4K;
 		break;
@@ -881,7 +929,7 @@ int hyp_ffa_init(void *pages)
 	if (kvm_host_psci_config.smccc_version < ARM_SMCCC_VERSION_1_2)
 		return 0;
 
-	arm_smccc_1_1_smc(FFA_VERSION, FFA_VERSION_1_1, 0, 0, 0, 0, 0, 0, &res);
+	arm_smccc_1_1_smc(FFA_VERSION, FFA_VERSION_1_2, 0, 0, 0, 0, 0, 0, &res);
 	if (res.a0 == FFA_RET_NOT_SUPPORTED)
 		return 0;
 
@@ -901,10 +949,11 @@ int hyp_ffa_init(void *pages)
 	if (FFA_MAJOR_VERSION(res.a0) != 1)
 		return -EOPNOTSUPP;
 
-	if (FFA_MINOR_VERSION(res.a0) < FFA_MINOR_VERSION(FFA_VERSION_1_1))
+	/* See do_ffa_guest_version before bumping maximum supported version. */
+	if (FFA_MINOR_VERSION(res.a0) < FFA_MINOR_VERSION(FFA_VERSION_1_2))
 		hyp_ffa_version = res.a0;
 	else
-		hyp_ffa_version = FFA_VERSION_1_1;
+		hyp_ffa_version = FFA_VERSION_1_2;
 
 	tx = pages;
 	pages += KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE;
diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index 5bded24dc24fea8cdcbe42bf79c7c025c3fa5f4b..c0dd6183d956043192114a522b7eef465e7078ac 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -128,6 +128,7 @@
 #define FFA_FEAT_RXTX_MIN_SZ_4K		0
 #define FFA_FEAT_RXTX_MIN_SZ_64K	1
 #define FFA_FEAT_RXTX_MIN_SZ_16K	2
+#define FFA_FEAT_RXTX_MIN_SZ_MASK	3
 
 /* FFA Bus/Device/Driver related */
 struct ffa_device {

-- 
2.49.0.1101.gccaa498523-goog



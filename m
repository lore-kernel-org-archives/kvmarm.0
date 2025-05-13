Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCB01E9B1D;
	Tue, 13 May 2025 06:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747117741; cv=none; b=SSz6UO65i/iarJ+5OAQnG7oB7gLw12WMeCRv1xRX5jEU2nS5GqjeZjGIFh+Ksfes705EJStawW+0WkB9J65JDLwEH8A3LjpvU7I17vYJyetsOCxxE7l29NDFDufDpBJN3TEjpEajKY63+6+SJHpRdYwpMacSCyVWxSp29ByqGS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747117741; c=relaxed/simple;
	bh=zIqZ8mY23RQJhAj77wYw9Px2AB5GSsIUWCZP9gcmjRM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cfOUL5OidmVLxN1X+VcNDIFVFF3LEc7147DMaiRBMrNAwz/OslYlsC99EM5KRwf6atBTR1x4aBAhLuvvFVhQkKPEhdrOmw367zSfmBwDwp4ocxKtT0UnVZu8NuakcsJaE0Z4DqK11Ut+EVibjNBI0WQF6sDeJD3GdbHpiAomja0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qjngvyWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qjngvyWw"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A18ADC4CEF3;
	Tue, 13 May 2025 06:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747117740;
	bh=zIqZ8mY23RQJhAj77wYw9Px2AB5GSsIUWCZP9gcmjRM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qjngvyWwMnQ9hhr4MMAChh20WvIP15xyh017u/hE9n2lZ4Oknp2x4GP3pvl6Tpzi7
	 2K9gQT+9vgfD8pvbnbw9vaJT6YCNUj0GnZO16gjppi9t8ko+mfgRMR0flwASQNnPEE
	 4vQvphrgkEV5Lou/QvHj+7HW3Tl+Bp9bRWC6G2QBITv2WY0ejI6rNmmGP4p1yuP9g+
	 eQnpEhDLUiIdckx8YVf1V8xeCHFWg/7tRUjGjuPUGXtmuTW7M5HiYJh/r6sv1XfEpQ
	 uJbkgKx6CZn1oxC2fOBwy+SZpzKwKglbHmZm4ffCJN4ONPWgGWPzHV7U1+JjitQ5pe
	 PMXE0kR4fcnUA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9508FC3ABD8;
	Tue, 13 May 2025 06:29:00 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Tue, 13 May 2025 06:28:32 +0000
Subject: [PATCH v3 3/3] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in
 host handler
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250513-virtio-msg-ffa-v3-3-d66c76ff1b2c@google.com>
References: <20250513-virtio-msg-ffa-v3-0-d66c76ff1b2c@google.com>
In-Reply-To: <20250513-virtio-msg-ffa-v3-0-d66c76ff1b2c@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, sebastianene@google.com, 
 lpieralisi@kernel.org, arve@android.com, qwandor@google.com, 
 kernel-team@android.com, armellel@google.com, perl@immunant.com, 
 jean-philippe@linaro.org, ahomescu@google.com, tabba@google.com, 
 qperret@google.com, james.morse@arm.com, Per Larsen <perlarsen@google.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1747117739; l=6690;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=QsNngW/tP9HNcpTRVnWjcXkhCLoKBIw7/dGeqhEUdHg=;
 b=0WQm8kABvwfwLy151PBVPZ1WrJc8Pz3DUZzdiEGOqlDJ6Gr70Hjrq6NCK7+fPV/RzIJk75xlm
 Rw0FkIhZ4YXAZ1hon95c7wk2Ecz1BlG2fATi98du40ha5RDbH5DZ54T
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

From: Per Larsen <perlarsen@google.com>

FF-A 1.2 adds the DIRECT_REQ2 messaging interface which is similar to
the existing FFA_MSG_SEND_DIRECT_{REQ,RESP} functions except that it
uses the SMC calling convention v1.2 which allows calls to use x4-x17 as
argument and return registers. Add support for FFA_MSG_SEND_DIRECT_REQ2
in the host ffa handler.

Signed-off-by: Per Larsen <perlarsen@google.com>
Signed-off-by: Per Larsen <perl@immunant.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 111 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/arm_ffa.h       |   2 +
 2 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 403fde6ca4d6ec49566ef60709cedbaef9f04592..437289aa5d902b0d2a4a8760403f0190f2320813 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -79,6 +79,14 @@ static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
 	};
 }
 
+static void ffa_to_smccc_1_2_error(struct arm_smccc_1_2_regs *regs, u64 ffa_errno)
+{
+	*regs = (struct arm_smccc_1_2_regs) {
+		.a0	= FFA_ERROR,
+		.a2	= ffa_errno,
+	};
+}
+
 static void ffa_to_smccc_res_prop(struct arm_smccc_res *res, int ret, u64 prop)
 {
 	if (ret == FFA_RET_SUCCESS) {
@@ -89,11 +97,25 @@ static void ffa_to_smccc_res_prop(struct arm_smccc_res *res, int ret, u64 prop)
 	}
 }
 
+static void ffa_to_smccc_1_2_regs_prop(struct arm_smccc_1_2_regs *regs, int ret, u64 prop)
+{
+	if (ret == FFA_RET_SUCCESS)
+		*regs = (struct arm_smccc_1_2_regs) { .a0 = FFA_SUCCESS,
+						      .a2 = prop };
+	else
+		ffa_to_smccc_1_2_error(regs, ret);
+}
+
 static void ffa_to_smccc_res(struct arm_smccc_res *res, int ret)
 {
 	ffa_to_smccc_res_prop(res, ret, 0);
 }
 
+static void ffa_to_smccc_1_2_regs(struct arm_smccc_1_2_regs *regs, int ret)
+{
+	ffa_to_smccc_1_2_regs_prop(regs, ret, 0);
+}
+
 static void ffa_set_retval(struct kvm_cpu_context *ctxt,
 			   struct arm_smccc_res *res)
 {
@@ -131,6 +153,29 @@ static void ffa_set_retval(struct kvm_cpu_context *ctxt,
 	}
 }
 
+static void ffa_set_retval_smccc_1_2(struct kvm_cpu_context *ctxt,
+			   struct arm_smccc_1_2_regs *regs)
+{
+	cpu_reg(ctxt, 0) = regs->a0;
+	cpu_reg(ctxt, 1) = regs->a1;
+	cpu_reg(ctxt, 2) = regs->a2;
+	cpu_reg(ctxt, 3) = regs->a3;
+	cpu_reg(ctxt, 4) = regs->a4;
+	cpu_reg(ctxt, 5) = regs->a5;
+	cpu_reg(ctxt, 6) = regs->a6;
+	cpu_reg(ctxt, 7) = regs->a7;
+	cpu_reg(ctxt, 8) = regs->a8;
+	cpu_reg(ctxt, 9) = regs->a9;
+	cpu_reg(ctxt, 10) = regs->a10;
+	cpu_reg(ctxt, 11) = regs->a11;
+	cpu_reg(ctxt, 12) = regs->a12;
+	cpu_reg(ctxt, 13) = regs->a13;
+	cpu_reg(ctxt, 14) = regs->a14;
+	cpu_reg(ctxt, 15) = regs->a15;
+	cpu_reg(ctxt, 16) = regs->a16;
+	cpu_reg(ctxt, 17) = regs->a17;
+}
+
 /* Call SMC64 using SMCCC 1.2 if hyp negotiated FF-A 1.2 falling back to 1.1 */
 static void arm_smccc_1_x_smc(u64 func_id, u64 a1, u64 a2, u64 a3,
 			      u64 a4, u64 a5, u64 a6, u64 a7,
@@ -686,7 +731,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
 	/* Unimplemented interfaces added in FF-A 1.2 */
-	case FFA_MSG_SEND_DIRECT_REQ2:
 	case FFA_MSG_SEND_DIRECT_RESP2:
 	case FFA_CONSOLE_LOG:
 	case FFA_PARTITION_INFO_GET_REGS:
@@ -697,6 +741,21 @@ static bool ffa_call_supported(u64 func_id)
 	return true;
 }
 
+/*
+ * Must a given FFA function use the SMC calling convention v1.2?
+ */
+static bool ffa_call_needs_smccc_1_2(u64 func_id)
+{
+	switch (func_id) {
+	case FFA_MSG_SEND_DIRECT_REQ2:
+	case FFA_MSG_SEND_DIRECT_RESP2:
+	case FFA_PARTITION_INFO_GET_REGS:
+		return true;
+	}
+
+	return false;
+}
+
 static bool do_ffa_features(struct arm_smccc_res *res,
 			    struct kvm_cpu_context *ctxt)
 {
@@ -855,9 +914,47 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
 	hyp_spin_unlock(&host_buffers.lock);
 }
 
+static void do_ffa_direct_msg2(struct arm_smccc_1_2_regs *regs,
+			       struct kvm_cpu_context *ctxt,
+			       u64 vm_handle)
+{
+	DECLARE_REG(u32, func_id, ctxt, 0);
+	DECLARE_REG(u32, endp, ctxt, 1);
+	DECLARE_REG(u64, uuid_lo, ctxt, 2);
+	DECLARE_REG(u64, uuid_hi, ctxt, 3);
+	DECLARE_REG(u64, x4, ctxt, 4);
+	DECLARE_REG(u64, x5, ctxt, 5);
+	DECLARE_REG(u64, x6, ctxt, 6);
+	DECLARE_REG(u64, x7, ctxt, 7);
+	DECLARE_REG(u64, x8, ctxt, 8);
+	DECLARE_REG(u64, x9, ctxt, 9);
+	DECLARE_REG(u64, x10, ctxt, 10);
+	DECLARE_REG(u64, x11, ctxt, 11);
+	DECLARE_REG(u64, x12, ctxt, 12);
+	DECLARE_REG(u64, x13, ctxt, 13);
+	DECLARE_REG(u64, x14, ctxt, 14);
+	DECLARE_REG(u64, x15, ctxt, 15);
+	DECLARE_REG(u64, x16, ctxt, 16);
+	DECLARE_REG(u64, x17, ctxt, 17);
+
+	if (FIELD_GET(FFA_SRC_ENDPOINT_MASK, endp) != vm_handle) {
+		ffa_to_smccc_1_2_regs(regs, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	struct arm_smccc_1_2_regs args = {
+		func_id, endp, uuid_lo, uuid_hi,
+		 x4,  x5,  x6,  x7,  x8,  x9, x10,
+		x11, x12, x13, x14, x15, x16, x17
+	};
+
+	arm_smccc_1_2_smc(&args, regs);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_res res;
+	struct arm_smccc_1_2_regs regs;
 
 	/*
 	 * There's no way we can tell what a non-standard SMC call might
@@ -913,14 +1010,24 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_PARTITION_INFO_GET:
 		do_ffa_part_get(&res, host_ctxt);
 		goto out_handled;
+	case FFA_MSG_SEND_DIRECT_REQ2:
+		if (ffa_get_hypervisor_version() >= FFA_VERSION_1_2) {
+			do_ffa_direct_msg2(&regs, host_ctxt, HOST_FFA_ID);
+			goto out_handled;
+		}
+		goto out_not_supported;
 	}
 
 	if (ffa_call_supported(func_id))
 		return false; /* Pass through */
 
+out_not_supported:
 	ffa_to_smccc_error(&res, FFA_RET_NOT_SUPPORTED);
 out_handled:
-	ffa_set_retval(host_ctxt, &res);
+	if (ffa_call_needs_smccc_1_2(func_id))
+		ffa_set_retval_smccc_1_2(host_ctxt, &regs);
+	else
+		ffa_set_retval(host_ctxt, &res);
 	return true;
 }
 
diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index c0dd6183d956043192114a522b7eef465e7078ac..82a35a3b22de426f7e9a8894e76fdf1e933b3d6b 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -269,6 +269,8 @@ bool ffa_partition_check_property(struct ffa_device *dev, u32 property)
 	(ffa_partition_check_property(dev, FFA_PARTITION_DIRECT_REQ2_RECV) && \
 	 !dev->mode_32bit)
 
+#define FFA_SRC_ENDPOINT_MASK	GENMASK(31, 16)
+
 /* For use with FFA_MSG_SEND_DIRECT_{REQ,RESP} which pass data via registers */
 struct ffa_send_direct_data {
 	unsigned long data0; /* w3/x3 */

-- 
2.49.0.1045.g170613ef41-goog



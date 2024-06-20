Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0881B3F08
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 16:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718902041; cv=none; b=dTI9Gbk6OLVTeGiGlf7KTGXLU8B/FJm9OjzPEli90iw66mqLvcXXDDG1Nudtu7jWQRoyus5p+WCSIo/xOHwggk1EyXqw4Q19dv1JyW1C+3EgdNrO2nsuhWbcIUznYqYmmYsFI3fYSsKQeEaHIqnmImxJbRyIESlrm5sIWnCMS3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718902041; c=relaxed/simple;
	bh=VC3cAS1vVLoMoF5Tcsry/hVzapF0FahnZnOna4JN5yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gL3d2DzixvYwcqVqKVgATAvOO0k2HKrd+8UH2FW9XjvLO8C1cbd6z2uxreigccOlpESy2m1tE65kDd784PhKgqe724I44Z1fVTTakjy13r4H3zqE5iKsiUCtr9yWT3VUzr2DBtV7LZweC1N/+7IAHgK2NJbcnzrQYBU0++8jTig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a+ytgbh/; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a+ytgbh/"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718902038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VqLkG/Vh8Bov5AOtu1PNtbm0dwVwhXMlOkximXK5PoU=;
	b=a+ytgbh/ArUlnySWyK44RFFDYDICgO+ixGaZ5/s5rb7gCMaDmflmBL3kiDUaHM/osLw1gT
	+7v0IybqQ/Uc+lHhBVUKthykeRtkiBON81Mo9lWY4idY5/hjQvu9aHIAD8fQS7QIQCLtBs
	kGlFnxqlpRfQljowqXrnAKmLCecXdAQ=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: tabba@google.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 09/15] KVM: arm64: nv: Handle CPACR_EL1 traps
Date: Thu, 20 Jun 2024 16:46:46 +0000
Message-ID: <20240620164653.1130714-10-oliver.upton@linux.dev>
In-Reply-To: <20240620164653.1130714-1-oliver.upton@linux.dev>
References: <20240620164653.1130714-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Marc Zyngier <maz@kernel.org>

Handle CPACR_EL1 accesses when running a VHE guest. In order to
limit the cost of the emulation, implement it ass a shallow exit.

In the other cases:

- this is a nVHE L1 which will write to memory, and we don't trap

- this is a L2 guest:

  * the L1 has CPTR_EL2.TCPAC==0, and the L2 has direct register
   access

  * the L1 has CPTR_EL2.TCPAC==1, and the L2 will trap, but the
    handling is defered to the general handling for forwarding

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 697253673d7b..564655277594 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -261,10 +261,40 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return true;
 }
 
+static bool kvm_hyp_handle_cpacr_el1(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	u64 esr = kvm_vcpu_get_esr(vcpu);
+	int rt;
+
+	if (!is_hyp_ctxt(vcpu) || esr_sys64_to_sysreg(esr) != SYS_CPACR_EL1)
+		return false;
+
+	rt = kvm_vcpu_sys_get_rt(vcpu);
+
+	if ((esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ) {
+		vcpu_set_reg(vcpu, rt, __vcpu_sys_reg(vcpu, CPTR_EL2));
+	} else {
+		vcpu_write_sys_reg(vcpu, vcpu_get_reg(vcpu, rt), CPTR_EL2);
+		__activate_cptr_traps(vcpu);
+	}
+
+	__kvm_skip_instr(vcpu);
+
+	return true;
+}
+
+static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	if (kvm_hyp_handle_cpacr_el1(vcpu, exit_code))
+		return true;
+
+	return kvm_hyp_handle_sysreg(vcpu, exit_code);
+}
+
 static const exit_handler_fn hyp_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
-	[ESR_ELx_EC_SYS64]		= kvm_hyp_handle_sysreg,
+	[ESR_ELx_EC_SYS64]		= kvm_hyp_handle_sysreg_vhe,
 	[ESR_ELx_EC_SVE]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
-- 
2.45.2.741.gdbec12cfda-goog


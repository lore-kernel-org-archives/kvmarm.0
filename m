Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6771B3730
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 16:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718902044; cv=none; b=WOSDu4+0gA6mQNGMNVM1xjnkMOxjpkMU4CQv+uMuNrbATgj2FGeR6FCkxveBVfo3igzcKT/eqti4v8o80Q9ROymr3Ql361kfeE9xv2fiLDMXkJG0cLm8FubaaYHk6gAYeqcLGNaAoDuXjjzyVWQD2+5McS9S1ZDYEyKY+EphS88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718902044; c=relaxed/simple;
	bh=zkZovDalC9gFu65wm4cMj/WQvuSt5whQvWU2OVTRS5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGewGqYFosDa5FNXhu3eXn3vn/KCtUfSx9bXoO4d5p5xFKcxCoTg7Te60oJrEseNnnGah34/EjBQKmuvEACU50nxJ/4qmoo5ycli6HqZr903n/SXGco33s+zGbKDq2Xg/ytAgrGO+JWIm9uOoj9iTQSHfY7GDirt8M5a9k1gwS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ecpOFhVw; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ecpOFhVw"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718902040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y6NlTN6bjYXUbwX0JsU1ZMZzb/6fyUage7s/Df7QDZA=;
	b=ecpOFhVw+w+ZaKG+veiSJgm6v1xMv/9BEjHa/xE66TjqSkiEX9w3tKqbFVrsp5Vepdc3TP
	FZnIPZHQGTNQy7voMWucvvmWBnL2lGcCeOFO1B5/Li8bvojB7HDD+WPnMNQpODy7v1O612
	h8lECKZYiPTP/Dp8ve9uqxOUixWps9Q=
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
Subject: [PATCH v3 10/15] KVM: arm64: nv: Load guest FP state for ZCR_EL2 trap
Date: Thu, 20 Jun 2024 16:46:47 +0000
Message-ID: <20240620164653.1130714-11-oliver.upton@linux.dev>
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

Round out the ZCR_EL2 gymnastics by loading SVE state in the fast path
when the guest hypervisor tries to access SVE state.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++++
 arch/arm64/kvm/hyp/vhe/switch.c         | 27 +++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index aaad4d68b6e7..ad8dec0b450b 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -358,6 +358,10 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 		if (guest_hyp_fpsimd_traps_enabled(vcpu))
 			return false;
 		break;
+	case ESR_ELx_EC_SYS64:
+		if (WARN_ON_ONCE(!is_hyp_ctxt(vcpu)))
+			return false;
+		fallthrough;
 	case ESR_ELx_EC_SVE:
 		if (!sve_guest)
 			return false;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 564655277594..925de4b4efd2 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -283,11 +283,38 @@ static bool kvm_hyp_handle_cpacr_el1(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return true;
 }
 
+static bool kvm_hyp_handle_zcr_el2(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
+
+	if (!vcpu_has_nv(vcpu))
+		return false;
+
+	if (sysreg != SYS_ZCR_EL2)
+		return false;
+
+	if (guest_owns_fp_regs())
+		return false;
+
+	/*
+	 * ZCR_EL2 traps are handled in the slow path, with the expectation
+	 * that the guest's FP context has already been loaded onto the CPU.
+	 *
+	 * Load the guest's FP context and unconditionally forward to the
+	 * slow path for handling (i.e. return false).
+	 */
+	kvm_hyp_handle_fpsimd(vcpu, exit_code);
+	return false;
+}
+
 static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (kvm_hyp_handle_cpacr_el1(vcpu, exit_code))
 		return true;
 
+	if (kvm_hyp_handle_zcr_el2(vcpu, exit_code))
+		return true;
+
 	return kvm_hyp_handle_sysreg(vcpu, exit_code);
 }
 
-- 
2.45.2.741.gdbec12cfda-goog


Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C0A2940B
	for <kvmarm@lists.linux.dev>; Fri, 31 May 2024 23:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717197264; cv=none; b=kB+Uh2VZkvOwLAETqzdjo56jRh3ThObBHVFpgSB+yUlHdOeLDVX6Tvl5SB6f85Jzo0tWmRilp768PJB6vT92inE5TwhtE1FbFJFaluU0Z8jWHe62CGL4mL0szh0KkrnjZBstesR2V7BrWfXxMbhanecDDJvR8jrML1Xmyaszzj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717197264; c=relaxed/simple;
	bh=XYh9wHjl5V28GRK+6Dr5HDtrT95UrdY5pPmxCmEcnPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lp+GesbCJnLma4plOtQjK21RrzXwLyQ+t2zC0/WT4Qr/ZAoF3OGhMlh0A5zvszWZLHv2XP9yZwV6tmKE6lSOvff5THemtYVKnn6/jkKLv6CpoLD6vPfR0Hta4k/K/nOQx9/4RmBHODG4dUOfCYWpYTDjaPT7GTmXO4tDrXIyuWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hCDtge2T; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hCDtge2T"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717197258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TD8+utALo+OI93RusizDFrCRluWD6BOQQWIE11fbI0A=;
	b=hCDtge2T+bY0BXPhs9FTi6IgtWj/974DvKaO6+y26cNhXHB9QE94S9CpO9kpK//sxia2Sv
	78oRTUEtDFXSa/guGvpwE2CRGWm+2zEz8hxLSZh/XE2kgAVYJE0JwX6uyQOVwjWdPhfwcs
	8WQB2qBEz9XnONn5rAPkf4pUWeZKO/o=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 03/11] KVM: arm64: nv: Load guest FP state for ZCR_EL2 trap
Date: Fri, 31 May 2024 23:13:50 +0000
Message-ID: <20240531231358.1000039-4-oliver.upton@linux.dev>
In-Reply-To: <20240531231358.1000039-1-oliver.upton@linux.dev>
References: <20240531231358.1000039-1-oliver.upton@linux.dev>
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

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 428ee15dd6ae..5872eaafc7f0 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -345,6 +345,10 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
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
@@ -520,6 +524,22 @@ static bool handle_ampere1_tcr(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static bool kvm_hyp_handle_zcr(struct kvm_vcpu *vcpu, u64 *exit_code)
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
+	return kvm_hyp_handle_fpsimd(vcpu, exit_code);
+}
+
 static bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
@@ -537,6 +557,9 @@ static bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (kvm_hyp_handle_cntpct(vcpu))
 		return true;
 
+	if (kvm_hyp_handle_zcr(vcpu, exit_code))
+		return true;
+
 	return false;
 }
 
-- 
2.45.1.288.g0e0cd299f1-goog


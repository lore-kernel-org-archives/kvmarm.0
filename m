Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B606146012
	for <kvmarm@lists.linux.dev>; Tue,  4 Jun 2024 13:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717506360; cv=none; b=dSsopbBlzqrjjcrsgKM7YIk1qEmfheTKazViCH9AcLyFPjKBdUvo2E1G/fuId7+qZRfH8Ol1Z+p3At034F7khRQaW2RZTC8lBtpkSQ9NdXml4soiG8Ri+BP+IX8LSC8eoaha50pigad5BFe74h1bKUelo5PxszwHIhjA6ww2KdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717506360; c=relaxed/simple;
	bh=W4XtQbfKfPiW8qFhBjSSzdUa5W+6VR/bSx7605s9t/k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ks/LqWFOaw3GuhdsZB1U4msbsj6FANgOOCoA5Xb7FG9pu4pBJY8xftmaCNal1oiTJWLeT/cwV6VCQxqDRVpFqemFJcCaXFcmCiiOr26hbQXloywHttQo++YQKqK+3pSp+cHhEn7dYYo8EeaKeenbMybKl4oDTm4OfCtLc2XJw2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=roM4mJEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="roM4mJEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E5CC3277B;
	Tue,  4 Jun 2024 13:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717506359;
	bh=W4XtQbfKfPiW8qFhBjSSzdUa5W+6VR/bSx7605s9t/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=roM4mJEnLK8KlmFzS2WdPUl6U74GyJJPZa4siHn8vKobsMun3PMTGOVimVRyVSCbD
	 tBdZvNBDjlanrnChiIdg+JIHpPZJr1TZjIIgN4loyu2/1O+plErxcnuHHPq8ziQTSa
	 cWNYFkGd5gyEAty8rE3xaISHl/Sc39CB/GTc/4rvUwtDUQxOOMvql3ErJ9aNyRF7ie
	 e83EZ71LfubI32VY1hw9r1g90o5JVTrFjU/OzyGnNcFdCkxm6NqpMtUOtpKvIUhEmC
	 EwjxJlMdyJnAxx4nidl4rFCvMl6rBjYxptwKoNGXH1WV5UKwcb69pEEQq9nuPcebDm
	 S33D8hKkkw2fA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sETrS-000ZSS-3k;
	Tue, 04 Jun 2024 14:05:58 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 4/4] KVM: arm64: nv: Handle CPACR_EL1 traps
Date: Tue,  4 Jun 2024 14:05:53 +0100
Message-Id: <20240604130553.199981-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240604130553.199981-1-maz@kernel.org>
References: <20240604130553.199981-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

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
---
 arch/arm64/kvm/hyp/vhe/switch.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index b4ba236526d6..c1711f2b92b8 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -295,10 +295,40 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
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
2.39.2


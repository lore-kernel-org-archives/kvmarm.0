Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F5F397E89;
	Tue,  1 Sep 2026 21:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788299456; cv=none; b=ss9dw5ANo2uM5Ba23+6CqqatGDErQ6zdKv6MaCYSD/IA4kACblNeixjwCLIGzgFY5nf8wL77zorV8dg9St3QvCC+jFxJc79Xcy6FMlKCNjD3+yqduEFYO1Hi4sH/y9qadppLcqBgj8ri+wLtE84DPVa7fv/jlag4364AzAOat8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788299456; c=relaxed/simple;
	bh=3iH+1nUhsEJN00Qw463PdcsZjZP8Q5hktNUuslTMlxM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZmC9kkQRTLE93Hw4YR2pKymzVsL7YiPDwsh1YVz4W2YKCmfynErYUAJ7LBstzIWmPCAP0cNdKQa9YdTJ9NiClOeGvon1W5/DMRa/zvr9pu24+79gieVH3TKbwHklfKXs1B+2sB7akjQyODwBww3Xs8eBD//7qsMl/OaNcXrTgVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I2FmYZZM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I2FmYZZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B056F1F00A3E;
	Tue,  1 Sep 2026 21:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788299454;
	bh=lBA+J448Iua93g/qbLnqNUoqyaKmMk0WVYNGvf6vR94=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=I2FmYZZMBKjKRsiG89p1iHHkHB7EVMZWBb8uxGs6+81oUK3ZwPon5F7nKEhaYVXdu
	 WodzHb5fF9HjI+DliUmDTnwPxsKlwHdu+NZW8WpwU424aadbWzc7/NnbdNH7bfzpML
	 XgZCGrO/4+y+BUR6ENXnS/tIS0TUG1vmJLGmczC71m5IK1ocJ4eCoyhqiGVMzTkE8/
	 0IJiPezXUcx9r2wrNqUfS+GRgLEM6Avm1y5p+vWO/J2BGEg6d9cp+CIxXmCOBTPlvz
	 6U/VwYeUZvQcx8+l2/W27z4wkxRlaQGn7MkzXNDs3HTg05JKbydgSri2U8odGTlD2D
	 2w3iMZ2WDqWHw==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 01 Sep 2026 22:47:03 +0100
Subject: [PATCH v20 05/14] KVM: arm64: Set PSTATE.EXLOCK when entering an
 exception
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-arm64-gcs-v20-5-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
In-Reply-To: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
 Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2743; i=broonie@kernel.org;
 h=from:subject:message-id; bh=3iH+1nUhsEJN00Qw463PdcsZjZP8Q5hktNUuslTMlxM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBql0igEXcjS1jffnwhPl/7D+f19Fp5b7boxQo5U
 EPFTqc+3kWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCapdIoAAKCRAk1otyXVSH
 0AvTB/sEU0gXvVDV7maD6BHIZmkQiZN3btgN5V+6+jmhJOL5LRfIRKLutr6BlKwWwhfRCMZ/0BN
 pzsc8DcNc3Wd2/IS/kHpyEP4MPXsvwL9vyLngsyFpBgL8RqRWh3Yadu68IuDLC8mQ49RvTAoiVk
 h4Np6Smsjk717sR1A3p4/u3jqBbJtg01K20IDEjPTVOwZvqP/9jfsqXE7fUJ/vVHEMw5DV9NjxB
 fBehd7s9H7+af3YfxeZ8FHoGGhXDmkMKSwxqkBjuwJGglPuJXNXDuIp6e8M3ALhgVHOREgd2QqZ
 UN3I8dme2tFsI+2CYBv0P3M9AD4omM/dl4PqyoaqygH3gT3u
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

As per DDI 0487 R_WTXBY we need to manage PSTATE.EXLOCK when entering an
exception, when the exception is entered from a lower EL the bit is cleared
while if entering from the same EL it is set to GCSCR_ELx.EXLOCKEN.
Implement this behaviour in enter_exception64().

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/uapi/asm/ptrace.h |  1 +
 arch/arm64/kvm/hyp/exception.c       | 37 ++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/uapi/asm/ptrace.h
index 15649a253a57..eed7f1226be6 100644
--- a/arch/arm64/include/uapi/asm/ptrace.h
+++ b/arch/arm64/include/uapi/asm/ptrace.h
@@ -56,6 +56,7 @@
 #define PSR_C_BIT	0x20000000
 #define PSR_Z_BIT	0x40000000
 #define PSR_N_BIT	0x80000000
+#define PSR_EXLOCK_BIT 0x400000000
 
 #define PSR_BTYPE_SHIFT		10
 
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 754e2dc1df54..85c873644fe9 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -49,6 +49,38 @@ static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
 		vcpu->arch.ctxt.spsr_und = val;
 }
 
+static unsigned long compute_exlock(struct kvm_vcpu *vcpu,
+				    unsigned long mode,
+				    unsigned long target_mode)
+{
+	u64 gcscr;
+
+	if (!kvm_has_gcs(kern_hyp_va(vcpu->kvm)))
+		return 0;
+
+	/* GCS can't be enabled for 32 bit */
+	if (mode & PSR_MODE32_BIT)
+		return 0;
+
+	/* When taking an exception to a higher EL EXLOCK is cleared. */
+	if ((mode | PSR_MODE_THREAD_BIT) != target_mode)
+		return 0;
+
+	/*
+	 * When taking an exception to the same EL EXLOCK is set to
+	 * the effective value of GCSR_ELx.EXLOCKEN.
+	 */
+	if (is_hyp_ctxt(vcpu))
+		gcscr = vcpu_read_sys_reg(vcpu, GCSCR_EL2);
+	else
+		gcscr = vcpu_read_sys_reg(vcpu, GCSCR_EL1);
+
+	if (gcscr & GCSCR_ELx_EXLOCKEN)
+		return PSR_EXLOCK_BIT;
+
+	return 0;
+}
+
 /*
  * This performs the exception entry at a given EL (@target_mode), stashing PC
  * and PSTATE into ELR and SPSR respectively, and compute the new PC/PSTATE.
@@ -138,6 +170,11 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 	// PSTATE.BTYPE is set to zero upon any exception to AArch64
 	// See ARM DDI 0487E.a, pages D1-2293 to D1-2294.
 
+	// PSTATE.EXLOCK is set to 0 upon any exception to a higher
+	// EL, or to GCSCR_ELx.EXLOCKEN for an exception to the same
+	// exception level.  See ARM DDI 0487 R_WTXBY.
+	new |= compute_exlock(vcpu, mode, target_mode);
+
 	new |= PSR_D_BIT;
 	new |= PSR_A_BIT;
 	new |= PSR_I_BIT;

-- 
2.47.3


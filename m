Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBA452E04E;
	Wed, 30 Sep 2026 21:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804954; cv=none; b=It1sjcdjm0z/mJqoUse50niNlHtYAyUE4E/6IWHzSxJBRUoi4asl0bxoRpG5ysGnrOSCLc3UlNIfYKFWFMmi9vSaYlOHMykaDWt42msbkFf0VoB5YemugcvNyJlfrmZaSta2S84qcK49dfcUJUa04EVCnaKoVcygjTsgDraj5zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804954; c=relaxed/simple;
	bh=aNoJ3V8nZd2+GGpGyDVqbDlbmnpADLGv/VzgqgiASdI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=s8t5QVxr+rQ2DFW6AgSSjgZ1jsdaxdtjVwFfhoSs+KMP7KuZv24Zo4WW7JsxOcaS44oblrs7tYOm6g6wBsqse9PGcE1CC1oENg+ubZPpNJTh8Wv0m8XIIfAY0GpsZ+objbsnPVC4AchEivF8wsbp/zVzTotWWy11mAIgqJQ9ka0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V4RynEcj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V4RynEcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E091F000FF;
	Wed, 30 Sep 2026 21:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790804952;
	bh=dFLnt75MTV/WN//EyOWGqDTK+6P19LegSAMQd0i6wA0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=V4RynEcj1NgscFf1Rmry4WY+8F+TmzdpbxNgnCVPngptpncfalTSgs2rWPYlHupox
	 XrAu28S9nGwLAOQX/DK1V8417eNPdZzFypD2XMUXQrgYFwnCBlgkeD8FwJE1vUwy2H
	 GJzZueBmQb2oUmTIXJ9K2TB8+S/n45m+fFhfq7uGPVLn5lZzcRKmhV4FREQ2iplTlb
	 tChlv2GcALcEaHW21fN3Q5EEl3ubIREJKWQmOrlL9EPSu4bc6LCUeFKK6j68CjjnV5
	 8JlNdrM8sjf7M47oZSzCnKGIVR2BDhm/515dTYOVSTlK1P8fm8JdaFlU2OtcyNKBBn
	 pCSpjlbWeN87Q==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 30 Sep 2026 22:48:15 +0100
Subject: [PATCH v21 05/15] KVM: arm64: Set PSTATE.EXLOCK when entering an
 exception
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-arm64-gcs-v21-5-3556644cd927@kernel.org>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
In-Reply-To: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2795; i=broonie@kernel.org;
 h=from:subject:message-id; bh=aNoJ3V8nZd2+GGpGyDVqbDlbmnpADLGv/VzgqgiASdI=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqvYO3BxMtZg6CNKL6cawCHZ4SM+hDNUqT1FuaX
 +YU+cxcc36JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCar2DtwAKCRAk1otyXVSH
 0JVLB/wJXVZCHypd/SUA/b8N6mo1O143FlQqywKn9p/iLfCyUgNap6EJOFkMcXEzrxJToKzZO/z
 8wZjUoMpmSEFpJLVzZD45NFQT03xyXjUJXYXLrphq8ptEI0C5BzLhWErc9qs6vETUs+3+Qkn8s7
 AMbd6NMTu9V8x9bKqUCrbEbBOC17Pny7Lipidd9NX+wnl5CSISVfw4ijwZi49JgAMuEELpA4Vb9
 Vi1QORQM60PHSqnJvU7TJDKpfUyG98GgiZ9sCbEX8HwohL9YUVs5APP10AFRVpN1LX9cgulP0Ol
 38wEuhoR/6tTOsbb0qrnO8CzYMTYztpgQNVpw/e0umjj6U0/
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

As per DDI 0487 R_WTXBY we need to manage PSTATE.EXLOCK when entering an
exception, when the exception is entered from a lower EL the bit is cleared
while if entering from the same EL it is set to GCSCR_ELx.EXLOCKEN.
Implement this behaviour in enter_exception64().

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Reviewed-by: Leonardo Bras <leo.bras@arm.com>
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
index 754e2dc1df54..820849631df9 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -49,6 +49,37 @@ static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
 		vcpu->arch.ctxt.spsr_und = val;
 }
 
+static bool set_exlock(struct kvm_vcpu *vcpu, unsigned long mode,
+		       unsigned long target_mode)
+{
+	u64 gcscr;
+
+	if (!kvm_has_gcs(kern_hyp_va(vcpu->kvm)))
+		return false;
+
+	/* GCS can't be enabled for 32 bit */
+	if (mode & PSR_MODE32_BIT)
+		return false;
+
+	/* When taking an exception to a higher EL EXLOCK is cleared. */
+	if ((mode | PSR_MODE_THREAD_BIT) != target_mode)
+		return false;
+
+	/*
+	 * When taking an exception to the same EL EXLOCK is set to
+	 * the effective value of GCSCR_ELx.EXLOCKEN.
+	 */
+	if (is_hyp_ctxt(vcpu))
+		gcscr = vcpu_read_sys_reg(vcpu, GCSCR_EL2);
+	else
+		gcscr = vcpu_read_sys_reg(vcpu, GCSCR_EL1);
+
+	if (gcscr & GCSCR_ELx_EXLOCKEN)
+		return true;
+
+	return false;
+}
+
 /*
  * This performs the exception entry at a given EL (@target_mode), stashing PC
  * and PSTATE into ELR and SPSR respectively, and compute the new PC/PSTATE.
@@ -138,6 +169,12 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 	// PSTATE.BTYPE is set to zero upon any exception to AArch64
 	// See ARM DDI 0487E.a, pages D1-2293 to D1-2294.
 
+	// PSTATE.EXLOCK is set to 0 upon any exception to a higher
+	// EL, or to GCSCR_ELx.EXLOCKEN for an exception to the same
+	// exception level.  See ARM DDI 0487 R_WTXBY.
+	if (set_exlock(vcpu, mode, target_mode))
+		new |= PSR_EXLOCK_BIT;
+
 	new |= PSR_D_BIT;
 	new |= PSR_A_BIT;
 	new |= PSR_I_BIT;

-- 
2.47.3


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFBB367293;
	Wed, 12 Aug 2026 19:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786562013; cv=none; b=pNuHtkb0oCYxmzvvIpMLqHb2xgHytQVeVmYLST4cYIBWtvhomQ9M/5Q1LNYPEa+NgnkuQepszaB70aPcwJ/z2auukGow6pwHdkRQoJxgjxaffwK9G7CndEdmsRUp1u2BgwcBTA4bdGno131GVrc+YmTFVswabxlygScVvxku058=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786562013; c=relaxed/simple;
	bh=H3c1Jh7WLAAKL7rV53HLXW8JW4g583Mc1btS7G2+Em8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=W7aoTZMSmOkzLuck5l6MpkSZz+z9jGifNG0tlgGJdaAlGH5FH3qEvu1GOPEewrOc1Gt8deeeGgZ5VjXuwD6/RuAGt9uji/zI1vqx+NQpwKnjNAIdqoQeknAzdyC3PDxR5z25nIfBtnNw4ePeZ5zF9Iuxmu96y3ug2ByUS6ZUYrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TZPHQcai; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TZPHQcai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8918E1F00A3E;
	Wed, 12 Aug 2026 19:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786562011;
	bh=zpPF6g6mv2qCipDhexYQv5Qfeex5nKKdMrziB5Fg7G8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TZPHQcai0EIuELpzh/yP3abL+DK35Pvo8/x8PbIo83pjff/0SpX/mUSTqgCM39j1v
	 pU8Dzc7MmxGZ7rGyF5SmTiyxIMC9zeBG6nKg9XrihOSjOtBsU9SR6LumZAvMpziZ8l
	 VAPHlvQ+xUK7mvReuejy0Hn+cEwyN+PssBc4RqZ6wso5RxZ0bHdQg/I5+LZtdfwmY7
	 51y9Ck0seU9oHcoZkLEPr4/Od7SxEi/DCIRjUwgIOggAw9zHofdPdK7znvFGf4/c66
	 CzLDskgsWz3UFXR2ZULypG0+ElcE5ypiyliU3VIyuRT2wccKSxB3ncxs4gVb2HRTF+
	 0e75p/DL3bTjA==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 12 Aug 2026 20:12:04 +0100
Subject: [PATCH v19 05/14] KVM: arm64: Set PSTATE.EXLOCK when entering an
 exception
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260812-arm64-gcs-v19-5-9105afd828ac@kernel.org>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
In-Reply-To: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2747; i=broonie@kernel.org;
 h=from:subject:message-id; bh=H3c1Jh7WLAAKL7rV53HLXW8JW4g583Mc1btS7G2+Em8=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqfMW+trzvBUaOPlpy/4ImxRK63UnKSrXcFfCJB
 MxZtLAPTfaJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanzFvgAKCRAk1otyXVSH
 0IBnB/sGWt6+y/Od4WD0+rs5F4WdcAI+Wr6UadUN1FbKz7BrkyoBRewPybLhqhUhhBuaWHVZv83
 k/08N7muzN+DA9b74GeE/XOZCvfKsD9uxci36t7dRG9iG+wLPhrJoDD2uN23eZtc+VAfGrgU8s+
 nW3FFjQ1l4BhbUB99B9NXWDE+ARr9fgM1tKOc93ZRoFdlaswpJy9PJ5IqMO8hQVcXdJFZg/rJJM
 EQUkwqB8iJ793FJJ2EPMx+mlbSwSLzj8N2BgumShpwiF3f6oEYEgGFUiHUuyoSUylrQdPiiRgxh
 UVWriel4QCOLzHLae8AqFiegsAKcJNCllzIt+39j12JdiTWe
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
index 6fed93fb2536..6113b9f9771b 100644
--- a/arch/arm64/include/uapi/asm/ptrace.h
+++ b/arch/arm64/include/uapi/asm/ptrace.h
@@ -56,6 +56,7 @@
 #define PSR_C_BIT	0x20000000
 #define PSR_Z_BIT	0x40000000
 #define PSR_N_BIT	0x80000000
+#define PSR_EXLOCK_BIT 0x400000000
 
 #define PSR_BTYPE_SHIFT		10
 
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index bef40ddb16db..15b00e0ee1ec 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -65,6 +65,38 @@ static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
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
+		gcscr = __vcpu_read_sys_reg(vcpu, GCSCR_EL2);
+	else
+		gcscr = __vcpu_read_sys_reg(vcpu, GCSCR_EL1);
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
@@ -154,6 +186,11 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
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


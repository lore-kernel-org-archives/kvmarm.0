Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DD4378D7D;
	Mon,  3 Aug 2026 23:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785798846; cv=none; b=CpJlZv0ZU+9WZhWLEeHpvKSctOX3QCQCo3xBBEpQlHhzh1JB3lFUdA5oOIHl+WD0kbS1ohRBrDuz9egPPS1nCJ8B8ub85yV4RMnbZ8h3yVwmmyAW7c44/ktEdfq5hQ0H4QDr7a3OmS77QjswS28gddwScUGiB42//YSQp9/0RkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785798846; c=relaxed/simple;
	bh=rvtRV62usxvYDabRiDuT5QzOKER095ZOoLBRwH9Xwsc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nfseiRuxmfQRx6DxxUr+rU7ienMuACNhT3h20xS06FRbHhW481DYsAcPjHLMqFp0aJjV5SZpAvDGoevVTBaSOGyR0J3BmE6wcsiyylvO1kQj3hsuZHGUhnncN5XlKF5S07xsYuQ2UT++1ZLC9UYD6P7N2woOFvxgqXCz3pXUnEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QOd1UUAu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QOd1UUAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198FC1F000E9;
	Mon,  3 Aug 2026 23:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785798840;
	bh=2SztSUpbsqfIgO005x2FPAmHBQNw5E5n0LUq/NdA0HU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QOd1UUAuA0wysoBcq8FqfSKC2Se2YLbkKhOEL08FZ85CrNr8EC2g9zfYT8Vtj+Ex6
	 oop1fwUYFrKHlMu+5rqGa8PBnl4PhrEijse4ombi7g6Z1i9NNvT8maELylZqzUsb48
	 1jUXul74YiNI+c49SnP3h0ZFuxhp4T2JAsAqdX2XuLIUo1cZGVQ/Cs84o9aWBGfMNa
	 FWysRxBGeWMed3mpMIM4wUGNu7VeWrBuDayjeOfA5TOevxi4MAVS8/y12LmzrCS421
	 CP5z+T38fjAwKALoX8d1H6kpo8ub+7WbqUkSltwBgaOxXmtnAk/yitV4v62KVDaaaZ
	 92uHFTxv/w1Sw==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 03 Aug 2026 23:56:50 +0100
Subject: [PATCH v18 05/14] KVM: arm64: Set PSTATE.EXLOCK when entering an
 exception
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-arm64-gcs-v18-5-fd8c40f5ad88@kernel.org>
References: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
In-Reply-To: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2696; i=broonie@kernel.org;
 h=from:subject:message-id; bh=rvtRV62usxvYDabRiDuT5QzOKER095ZOoLBRwH9Xwsc=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqcSCd6PEHl3QFHLPPxtobM1uSd2n0Wo8YAbYo7
 O5LFRktw0aJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanEgnQAKCRAk1otyXVSH
 0HK/B/0aeWDR87DHcNDUqhWkFohvbpfdwxSXXg9pT4seEAp2+Szhs3jmJyiv9iVpmFbxKRHkjGq
 ktTIQ+HtgP1TV7PzQJ4qimkqDl1DWuvQVrNcv5nxsbLnRYuGxCyDBwagBag/23J1Yn+OcAEr0SM
 UqZsxgnPj6fn+CtgGbmrvhnglCbu66Kw1lN+7AwUYkJxhFyAQQGJvDpwHeUwt1FFkKL4XjrSQRy
 Tev05VETk7uLLZfziD7sFKio8tQzz4CjesIad65cZtN2FFUTm6cFXheiBcdBk7grUjf5Dse4/qV
 ywLXs9NYEoksIwYZMQskGDcPBjYqsekSJSKCg39220B7V3G8
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

As per DDI 0487 R_WTXBY we need to manage PSTATE.EXLOCK when entering an
exception, when the exception is entered from a lower EL the bit is cleared
while if entering from the same EL it is set to GCSCR_ELx.EXLOCKEN.
Implement this behaviour in enter_exception64().

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


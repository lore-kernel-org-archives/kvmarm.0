Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEEC397695;
	Thu,  9 Jul 2026 00:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783558411; cv=none; b=SViWfA6wcwFsSpnGEXnEDmnX06fzUt61my/j8CMoOuqFS1RO+iP19OtsobvnYN/MyP0kfqg0Y7hZrOY1/b2KxVdHW+QOa+EaFECvwFuk2zeiI02pLsXYkPVuENpYuGp2zOAA6quvu6kn6VQr4p1HoFzU7ZdyXKY+yn6RyG2C7Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783558411; c=relaxed/simple;
	bh=zkAz4EpB+oD/CW01W7HnqzjEzUv3OlXONmLnbiTh4s0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=j9tnA/kbg1lq184MQh+0gqnlBRIOnPrRQdukMUlEjEq3RzToVGau8vNLfTFRRKZp/nNkcT3Zxq+kilOMKx88NxG8ldsE+dzp4F3LjVdj9uPvJsyL5tpqC7rLFI82E75HRfWMbHCYSG+No5mi9X4MjEVGSttvnysbjnVsMUZWW+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lnJag7uh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lnJag7uh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1157E1F000E9;
	Thu,  9 Jul 2026 00:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783558410;
	bh=Hf3ZnwbaPwB7JWA6xLw/d7mljky+WZ0YaL8vLXxrCY0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lnJag7uhXSbc6gAqfsNjUOEEOISSi4+UVgi9JC4SFD0jTvHaLnTPevSB8a8tUZQDH
	 kvsjr9kE+4qwi65wBBZYesCrZAEfXJ0tAAf200yVQ2i5T9w+F+UGSNhiS1wjf0T0w6
	 xhJXU+zu9z2nq48aFpU6poHXxfzy2Q5Y8lPHJihhtoCNYhex7f4z//pamuHGg53daB
	 tmqjEJ40jtJhkNLWGyaWOSU9XM7gIbE11IbkUpuKoEwAs9ogyLw7GWakjwWUNYymjU
	 pQ0U7ahs/SqweQe+Fjw+LFJk1tGQ/bIdNr5i78WY23qNxO1iqlzUGDU0NKwp+Xa4/x
	 91v6uqBL1M4PA==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 01:51:49 +0100
Subject: [PATCH v11 12/29] KVM: arm64: Factor SVE code out of
 fpsimd_lazy_switch_to_host()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v11-12-32799f66db9d@kernel.org>
References: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
In-Reply-To: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Jean-Philippe Brucker <jpb@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2931; i=broonie@kernel.org;
 h=from:subject:message-id; bh=zkAz4EpB+oD/CW01W7HnqzjEzUv3OlXONmLnbiTh4s0=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqTvDD7/Xx9ta5CrALzJXJKvg31N6RsWrYUX7GP
 L1W5TbJcHeJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak7wwwAKCRAk1otyXVSH
 0BssB/9aKKli2QQoBIvu8+/YCT5VzaRd5S15Yar5jA128wd/Q1sa9UZPZIjcTi4Rg+1AIcpdmY+
 BPbvEYAPsMsgYY9O4mm392WpF/hLKYOYxxxDGmuIXYpQlyHRc4btkuvHkOBuyl5nUjWwR+L42oM
 GEtLs7Vqq2qt+r88BeyIFOesWfTCn6X+l2RymzdLejcAUuLf9YyUYCtQswNVJpHeLANJ57WYD51
 kuMs7vFqX2YISlEoiNUEy2a88lI7TraWj0hst55SBWC8z8/0hD5YhRG6T7GG083J9y+AkmQclHE
 fqZNXn8Rl98ESs75QbY6FJk8bj+tkjTWJuI1EeWKM3OFFThi
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Since the function will grow as a result of adding SME support move the
SVE code out of fpsimd_lazy_switch_to_host(). No functional change, just
code motion.

Reviewed-by: Jean-Philippe Brucker <jpb@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 48 ++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 33729e218c0a..e444f0a94dcf 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -519,11 +519,11 @@ static inline void fpsimd_lazy_switch_to_guest(struct kvm_vcpu *vcpu)
 	}
 }
 
-static inline void fpsimd_lazy_switch_to_host(struct kvm_vcpu *vcpu)
+static inline void sve_lazy_switch_to_host(struct kvm_vcpu *vcpu)
 {
 	u64 zcr_el1, zcr_el2;
 
-	if (!guest_owns_fp_regs())
+	if (!vcpu_has_sve(vcpu))
 		return;
 
 	/*
@@ -534,29 +534,35 @@ static inline void fpsimd_lazy_switch_to_host(struct kvm_vcpu *vcpu)
 	 * synchronization event, we don't need an ISB here to avoid taking
 	 * traps for anything that was exposed to the guest.
 	 */
-	if (vcpu_has_sve(vcpu)) {
-		zcr_el1 = read_sysreg_el1(SYS_ZCR);
-		__vcpu_assign_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu), zcr_el1);
+	zcr_el1 = read_sysreg_el1(SYS_ZCR);
+	__vcpu_assign_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu), zcr_el1);
 
-		/*
-		 * The guest's state is always saved using the guest's max VL.
-		 * Ensure that the host has the guest's max VL active such that
-		 * the host can save the guest's state lazily, but don't
-		 * artificially restrict the host to the guest's max VL.
-		 */
-		if (has_vhe()) {
-			zcr_el2 = vcpu_sve_max_vq(vcpu) - 1;
-			write_sysreg_el2(zcr_el2, SYS_ZCR);
-		} else {
-			zcr_el2 = sve_vq_from_vl(kvm_host_max_vl[ARM64_VEC_SVE]) - 1;
-			write_sysreg_el2(zcr_el2, SYS_ZCR);
-
-			zcr_el1 = vcpu_sve_max_vq(vcpu) - 1;
-			write_sysreg_el1(zcr_el1, SYS_ZCR);
-		}
+	/*
+	 * The guest's state is always saved using the guest's max VL.
+	 * Ensure that the host has the guest's max VL active such
+	 * that the host can save the guest's state lazily, but don't
+	 * artificially restrict the host to the guest's max VL.
+	 */
+	if (has_vhe()) {
+		zcr_el2 = vcpu_sve_max_vq(vcpu) - 1;
+		write_sysreg_el2(zcr_el2, SYS_ZCR);
+	} else {
+		zcr_el2 = sve_vq_from_vl(kvm_host_max_vl[ARM64_VEC_SVE]) - 1;
+		write_sysreg_el2(zcr_el2, SYS_ZCR);
+
+		zcr_el1 = vcpu_sve_max_vq(vcpu) - 1;
+		write_sysreg_el1(zcr_el1, SYS_ZCR);
 	}
 }
 
+static inline void fpsimd_lazy_switch_to_host(struct kvm_vcpu *vcpu)
+{
+	if (!guest_owns_fp_regs())
+		return;
+
+	sve_lazy_switch_to_host(vcpu);
+}
+
 static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);

-- 
2.47.3


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E333A38944D;
	Sun, 19 Jul 2026 23:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784502694; cv=none; b=QPtVAZOT5ibIRCnKJ1P1rOHUiTpfoMZdJe7CSQAkbCJ9FQ+ubiNLVzdVZ6RvbHBE3IrjjnMC/T0t/ztJvs5E18EnVrqHL6+6d1o80X/hc6SciH/7NBE4RrmYPisasLEasl4ZBoXhOQwrIlvjMn7dLw6p0B0PkKUKVa6DOKJSO+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784502694; c=relaxed/simple;
	bh=tF/rTI6kXtiaueeuMEdKDBM0umIPPyuiK559017fv78=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=S8wI+dbqbKL8QJmTd7NY9gsdtXixCedXt+MjiF+s+jmSxQpX1fjHouv7t7V8SyGnf3eW+c8qxrMz2Yq8LrS8SstlYMEEFdCaZ52S3hquAuq0evHiVMn78O13bBuj570+S6IABSis3BBZ/1qGYHUDNEZF4VaEjEhdcmVENHzv4/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eNRvKHFw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eNRvKHFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29CC1F00A3D;
	Sun, 19 Jul 2026 23:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784502692;
	bh=09GSqoIFH97qhBcTcWix53S4U0RqlEqjOFCeSslb6OA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eNRvKHFwdAyLQU9GTKrLNzoZmjWpffh1MAcH2esJfruW5N7bDD0k38zDey5j6y4A6
	 ogDuekcugkH/oObOEOXcK4rru6my/LS+oJG34St+Sbmc0/Jn0EwtNL3A//mcrCmE1B
	 FYpcnOam2wrFOsIFhw07UJsZoeYOLjl1bQXIDTrSyzQWWVsCMekKZE2TDaIFBPePId
	 me9+UVDq4NYsAag15A5IOoUtUwdAF/8ERXTb0l9wz1r775GXjSPIUGGHtB2sD0LnTK
	 auBY/m1snXBxsgo/EXHf76gQEqBbsvU8YBQurroDnLQnHFxJD5Bn9pvxLATweSj7gk
	 82hE/rVbvNMCA==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 20 Jul 2026 00:07:49 +0100
Subject: [PATCH v13 22/32] KVM: arm64: Support userspace access to
 streaming mode Z and P registers
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kvm-arm64-sme-v13-22-d9abd3ffa245@kernel.org>
References: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
In-Reply-To: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6944; i=broonie@kernel.org;
 h=from:subject:message-id; bh=tF/rTI6kXtiaueeuMEdKDBM0umIPPyuiK559017fv78=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqXVk4dNeNxf5g+4y7GoMNNlqNIh88nlaLMWtSi
 cmDLNynEciJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCal1ZOAAKCRAk1otyXVSH
 0OTKB/wIkLqIsYRjKDq3CwdlRnqFJjOegFm+1z5GvN0+rKB/1gL8im51tu9wMnpmOXKLEPV+3bU
 OOLXiSA0O6EAImE5iPu0h0zQbi2PlHAtbkQEgwYV4w+1vonanODY2BNt2xJTL9KGzG+XPv5XYdf
 d2rGBvhWYtB/Kuul8qolm1Qu3/pEvPngwdvgpoRYzQ9mqT0EYwHy03RrrN2mTIUG27z0WYzqAjD
 44v+XM25vj5n0/rt7PuEVpUKE/4h3QCAzN5KlmUeBNKX39pMXim7zss3xiztr1nCQY5RwwHpkxx
 Q6TvXJRdj2inNQIeyvHvI9gP9JyzQG2J1tlDEdKI489ALAfB
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

SME introduces a mode called streaming mode where the Z, P and optionally
FFR registers can be accessed using the SVE instructions but with the SME
vector length. Reflect this in the ABI for accessing the guest registers by
making the vector length for the vcpu reflect the vector length that would
be seen by the guest were it running, using the SME vector length when the
guest is configured for streaming mode.

Since SME may be present without SVE we also update the existing checks for
access to the Z, P and V registers to check for either SVE or streaming
mode. When not in streaming mode the guest floating point state may be
accessed via the V registers.

Any VMM that supports SME must be aware of the need to configure streaming
mode prior to writing the floating point registers that this creates.

Since this makes the set of registers that are visible depend on the
current state of the vCPU also add processing of PSCI reset requests to
register enumeration similarly to register reads and writes.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/arm.c   |  9 ++++++
 arch/arm64/kvm/guest.c | 83 +++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 74 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 50adfff75be8..d43cfdcaee64 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1882,6 +1882,15 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&reg_list, user_list, sizeof(reg_list)))
 			break;
+
+		/*
+		 * We could owe a reset due to PSCI. Handle the pending reset
+		 * here since for SME the set of registers varies depending
+		 * on vCPU state.
+		 */
+		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
+			kvm_reset_vcpu(vcpu);
+
 		n = reg_list.n;
 		reg_list.n = kvm_arm_num_regs(vcpu);
 		if (copy_to_user(user_list, &reg_list, sizeof(reg_list)))
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 48e6b500f531..110cc7f7527a 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -73,6 +73,19 @@ static u64 core_reg_offset_from_id(u64 id)
 	return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
 }
 
+static bool vcpu_has_sve_regs(const struct kvm_vcpu *vcpu)
+{
+	return vcpu_has_sve(vcpu) || vcpu_in_streaming_mode(vcpu);
+}
+
+static bool vcpu_ffr_enabled(const struct kvm_vcpu *vcpu)
+{
+	if (vcpu_in_streaming_mode(vcpu))
+		return vcpu_has_fa64(vcpu);
+	else
+		return vcpu_has_sve(vcpu);
+}
+
 static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
 {
 	int size;
@@ -110,9 +123,10 @@ static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
 	/*
 	 * The KVM_REG_ARM64_SVE regs must be used instead of
 	 * KVM_REG_ARM_CORE for accessing the FPSIMD V-registers on
-	 * SVE-enabled vcpus:
+	 * SVE-enabled vcpus or when a SME enabled vcpu is in
+	 * streaming mode:
 	 */
-	if (vcpu_has_sve(vcpu) && core_reg_offset_is_vreg(off))
+	if (vcpu_has_sve_regs(vcpu) && core_reg_offset_is_vreg(off))
 		return -EINVAL;
 
 	return size;
@@ -423,6 +437,24 @@ struct vec_state_reg_region {
 	unsigned int upad;	/* extra trailing padding in user memory */
 };
 
+/*
+ * We represent the Z and P registers to userspace using either the
+ * SVE or SME vector length, depending on which features the guest has
+ * and if the guest is in streaming mode.
+ */
+static unsigned int vcpu_sve_cur_vq(struct kvm_vcpu *vcpu)
+{
+	unsigned int vq = 0;
+
+	if (vcpu_has_sve(vcpu))
+		vq = vcpu_sve_max_vq(vcpu);
+
+	if (vcpu_in_streaming_mode(vcpu))
+		vq = vcpu_sme_max_vq(vcpu);
+
+	return vq;
+}
+
 /*
  * Validate SVE register ID and get sanitised bounds for user/kernel SVE
  * register copy
@@ -460,20 +492,25 @@ static int sve_reg_to_region(struct vec_state_reg_region *region,
 	reg_num = (reg->id & SVE_REG_ID_MASK) >> SVE_REG_ID_SHIFT;
 
 	if (reg->id >= zreg_id_min && reg->id <= zreg_id_max) {
-		if (!vcpu_has_sve(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)
+		if (!vcpu_has_sve_regs(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)
 			return -ENOENT;
 
-		vq = vcpu_sve_max_vq(vcpu);
+		vq = vcpu_sve_cur_vq(vcpu);
 
 		reqoffset = SVE_SIG_ZREG_OFFSET(vq, reg_num) -
 				SVE_SIG_REGS_OFFSET;
 		reqlen = KVM_SVE_ZREG_SIZE;
 		maxlen = SVE_SIG_ZREG_SIZE(vq);
 	} else if (reg->id >= preg_id_min && reg->id <= preg_id_max) {
-		if (!vcpu_has_sve(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)
+		if (!vcpu_has_sve_regs(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)
 			return -ENOENT;
 
-		vq = vcpu_sve_max_vq(vcpu);
+		if (!vcpu_ffr_enabled(vcpu) &&
+		    (reg->id >= KVM_REG_ARM64_SVE_FFR(0)) &&
+		    (reg->id <= KVM_REG_ARM64_SVE_FFR(SVE_NUM_SLICES - 1)))
+			return -ENOENT;
+
+		vq = vcpu_sve_cur_vq(vcpu);
 
 		reqoffset = SVE_SIG_PREG_OFFSET(vq, reg_num) -
 				SVE_SIG_REGS_OFFSET;
@@ -640,15 +677,21 @@ static unsigned long num_core_regs(const struct kvm_vcpu *vcpu)
 static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
 {
 	const unsigned int slices = vcpu_sve_slices(vcpu);
+	int regs, ret;
 
-	if (!vcpu_has_sve(vcpu))
+	if (!vcpu_has_sve(vcpu) && !vcpu_in_streaming_mode(vcpu))
 		return 0;
 
 	/* Policed by KVM_GET_REG_LIST: */
 	WARN_ON(!kvm_arm_vcpu_vec_finalized(vcpu));
 
-	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */)
-		+ 1; /* KVM_REG_ARM64_SVE_VLS */
+	regs = SVE_NUM_PREGS + SVE_NUM_ZREGS;
+	if (vcpu_ffr_enabled(vcpu))
+		regs++;  /* FFR */
+	ret = regs * slices;
+	if (vcpu_has_sve(vcpu))
+		ret++; /* KVM_REG_ARM64_SVE_VLS */
+	return ret;
 }
 
 static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
@@ -659,7 +702,7 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 	unsigned int i, n;
 	int num_regs = 0;
 
-	if (!vcpu_has_sve(vcpu))
+	if (!vcpu_has_sve_regs(vcpu))
 		return 0;
 
 	/* Policed by KVM_GET_REG_LIST: */
@@ -669,10 +712,12 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 	 * Enumerate this first, so that userspace can save/restore in
 	 * the order reported by KVM_GET_REG_LIST:
 	 */
-	reg = KVM_REG_ARM64_SVE_VLS;
-	if (put_user(reg, uindices++))
-		return -EFAULT;
-	++num_regs;
+	if (vcpu_has_sve(vcpu)) {
+		reg = KVM_REG_ARM64_SVE_VLS;
+		if (put_user(reg, uindices++))
+			return -EFAULT;
+		++num_regs;
+	}
 
 	for (i = 0; i < slices; i++) {
 		for (n = 0; n < SVE_NUM_ZREGS; n++) {
@@ -689,10 +734,12 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 			num_regs++;
 		}
 
-		reg = KVM_REG_ARM64_SVE_FFR(i);
-		if (put_user(reg, uindices++))
-			return -EFAULT;
-		num_regs++;
+		if (vcpu_ffr_enabled(vcpu)) {
+			reg = KVM_REG_ARM64_SVE_FFR(i);
+			if (put_user(reg, uindices++))
+				return -EFAULT;
+			num_regs++;
+		}
 	}
 
 	return num_regs;

-- 
2.47.3


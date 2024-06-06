Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70071197A6A;
	Thu,  6 Jun 2024 15:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717687926; cv=none; b=Rzf3IdtfLvZVSpgJJeqBZPUPi5Gq7F+HbOuwCEks+T35EPkQITQRaCmfc7PzIjan9KfFZlH6OIIqrDAq5AnViLHIjgnfeeIcJQEdqqAdGpZqDuI1fLF92k1QZQJyAcyfq6LZaxm8xxleXuKegv43BxQzTCbVpF3vu66Z8oOjKeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717687926; c=relaxed/simple;
	bh=H3jcxvAHXptT4L841OkSY/wbD68Q058k6Wy2910HAmg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=miCqEcLGqZY+UhhpEJG1EM3KLKkkmjNsSGEwLj6Ysqk3v7Q8PPocka3/HhfQbacw3XlIaG0yW2WrHOs6KiLeYDdOaFAP6G0pA9FMfjqv8YXlqE0qEEri7pA/UHq1AsAYfrnGb1s0Mz3+FN2e9fG3aI4KDln5Hmv2Eoc1IQ7DxvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y1ABfoKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y1ABfoKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B976DC2BD10;
	Thu,  6 Jun 2024 15:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717687926;
	bh=H3jcxvAHXptT4L841OkSY/wbD68Q058k6Wy2910HAmg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Y1ABfoKraIr62CY8JwyBPb7z6fKdniAElsElHbF1eC/TLRRG+mRO1IhFeDSy0cuCv
	 JMyt1NSw6J2OK2NmVX0wUfOO3grajN6DD4G0MshYmeZuOHJcfpaLenC9SmZH/O4LcS
	 rWAHBJLdoOHMTFDD23gmILoMj3u782w447FCYumDYslRhYqgJ3qPbR7xVoqI2bg5Mn
	 jUl8/BnlDtUnpUI+NqWwghBel1DQeqWg8OcAQGaTM5i+H+YzLrObwXG3D5q6xPrYuG
	 1mmIWeEt2n1GP1gXWRAorkRbR6gaQ0mhftA5rbU5Xp+NbC+31Gj3/NaR+hN7aE5JSG
	 6kfuXb+cdNLkA==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 06 Jun 2024 16:21:44 +0100
Subject: [PATCH v2 2/4] arm64/fpsimd: Discover maximum vector length
 implemented by any CPU
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-2-c88f4eb4b14b@kernel.org>
References: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-0-c88f4eb4b14b@kernel.org>
In-Reply-To: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-0-c88f4eb4b14b@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.14-dev-d4707
X-Developer-Signature: v=1; a=openpgp-sha256; l=4151; i=broonie@kernel.org;
 h=from:subject:message-id; bh=H3jcxvAHXptT4L841OkSY/wbD68Q058k6Wy2910HAmg=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmYdZrXwyvssj4DZUsq5Oq0pfKbm9b2RzxxDY7A4mX
 rG4EM4SJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZmHWawAKCRAk1otyXVSH0MW7B/
 4zRzbdQVt988qBR2E0HSNmsQ3ScD6/w8A55zELsnqftkLXWoPyjvYA4oWQdIluke0jF5N7T/6kJgWb
 B7itNqcV5SEgVK/IvQ86Sq/NkJ/bedLgWyqyELlEwHs6z0Fxu062KcZAyrczajDmuMgKeYg/q3n3nB
 MCmA32OMYiWDZ5Nh0xdrrO1pQWacYtiN9mQsRqhFHi8TjzV4n3DBIw8f1j1X3Og3BcwlOalXdF54X/
 Kd68sOpBD89fYBkh0ROlMJ2Yc6Hp3rZfPdasagZo8MY9/RjUrQ3XqcRovWFVFf+tbfQzUI2E3PL4eV
 +LPMypMoA0HM6PfdjDcVXPFMT30j31
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

When discovering the vector lengths for SVE and SME we do not currently
record the maximum VL supported on any individual CPU.  This is expected
to be the same for all CPUs but the architecture allows asymmetry, if we
do encounter an asymmetric system then some CPUs may support VLs higher
than the maximum Linux will use.  Since the pKVM hypervisor needs to
support saving and restoring anything the host can physically set it
needs to know the maximum value any CPU could have, add support for
enumerating it and validation for late CPUs.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h | 13 +++++++++++++
 arch/arm64/kernel/fpsimd.c      | 26 +++++++++++++++++++++++++-
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 51c21265b4fa..cd19713c9deb 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -188,6 +188,9 @@ struct vl_info {
 	int max_vl;
 	int max_virtualisable_vl;
 
+	/* Maximum vector length observed on any CPU */
+	int max_cpu_vl;
+
 	/*
 	 * Set of available vector lengths,
 	 * where length vq encoded as bit __vq_to_bit(vq):
@@ -278,6 +281,11 @@ static inline int vec_max_virtualisable_vl(enum vec_type type)
 	return vl_info[type].max_virtualisable_vl;
 }
 
+static inline int vec_max_cpu_vl(enum vec_type type)
+{
+	return vl_info[type].max_cpu_vl;
+}
+
 static inline int sve_max_vl(void)
 {
 	return vec_max_vl(ARM64_VEC_SVE);
@@ -288,6 +296,11 @@ static inline int sve_max_virtualisable_vl(void)
 	return vec_max_virtualisable_vl(ARM64_VEC_SVE);
 }
 
+static inline int sve_max_cpu_vl(void)
+{
+	return vec_max_cpu_vl(ARM64_VEC_SVE);
+}
+
 /* Ensure vq >= SVE_VQ_MIN && vq <= SVE_VQ_MAX before calling this function */
 static inline bool vq_available(enum vec_type type, unsigned int vq)
 {
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 22542fb81812..ee6fb8c4b16d 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -129,6 +129,7 @@ __ro_after_init struct vl_info vl_info[ARM64_VEC_MAX] = {
 		.min_vl			= SVE_VL_MIN,
 		.max_vl			= SVE_VL_MIN,
 		.max_virtualisable_vl	= SVE_VL_MIN,
+		.max_cpu_vl		= SVE_VL_MIN,
 	},
 #endif
 #ifdef CONFIG_ARM64_SME
@@ -1041,8 +1042,13 @@ static void vec_probe_vqs(struct vl_info *info,
 void __init vec_init_vq_map(enum vec_type type)
 {
 	struct vl_info *info = &vl_info[type];
+	unsigned long b;
+
 	vec_probe_vqs(info, info->vq_map);
 	bitmap_copy(info->vq_partial_map, info->vq_map, SVE_VQ_MAX);
+
+	b = find_first_bit(info->vq_map, SVE_VQ_MAX);
+	info->max_cpu_vl = __bit_to_vl(b);
 }
 
 /*
@@ -1054,11 +1060,16 @@ void vec_update_vq_map(enum vec_type type)
 {
 	struct vl_info *info = &vl_info[type];
 	DECLARE_BITMAP(tmp_map, SVE_VQ_MAX);
+	unsigned long b;
 
 	vec_probe_vqs(info, tmp_map);
 	bitmap_and(info->vq_map, info->vq_map, tmp_map, SVE_VQ_MAX);
 	bitmap_or(info->vq_partial_map, info->vq_partial_map, tmp_map,
 		  SVE_VQ_MAX);
+
+	b = find_first_bit(tmp_map, SVE_VQ_MAX);
+	if (__bit_to_vl(b) > info->max_cpu_vl)
+		info->max_cpu_vl = __bit_to_vl(b);
 }
 
 /*
@@ -1069,10 +1080,23 @@ int vec_verify_vq_map(enum vec_type type)
 {
 	struct vl_info *info = &vl_info[type];
 	DECLARE_BITMAP(tmp_map, SVE_VQ_MAX);
-	unsigned long b;
+	unsigned long b, max_vl;
 
 	vec_probe_vqs(info, tmp_map);
 
+	/*
+	 * Currently the maximum VL is only used for pKVM which
+	 * doesn't allow late CPUs but we don't expect asymmetry and
+	 * if we encounter any then future users will need handling so
+	 * warn if we see anything.
+	 */
+	max_vl = __bit_to_vl(find_first_bit(tmp_map, SVE_VQ_MAX));
+	if (max_vl > info->max_cpu_vl) {
+		pr_warn("%s: cpu%d: increases maximum VL to %u\n",
+			info->name, smp_processor_id(), max_vl);
+		info->max_cpu_vl = max_vl;
+	}
+
 	bitmap_complement(tmp_map, tmp_map, SVE_VQ_MAX);
 	if (bitmap_intersects(tmp_map, info->vq_map, SVE_VQ_MAX)) {
 		pr_warn("%s: cpu%d: Required vector length(s) missing\n",

-- 
2.39.2


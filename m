Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C2F1A01AB;
	Tue, 30 Jul 2024 13:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722346265; cv=none; b=XwK7aXmp3S2ZM17ASU8BpLzQQDfhz0oAVli4kRxFDcQH2lh2i7I2dX/Ppgi5+EogDp61hmaULSQohR4pVgkMQxb3m3w4WTWaMLRG8jMzcYRBcF3x06KT6IN5gmqRy+2p937Gk9ZwqysnOkyW4nx3glS6WJ9g0btHJl1XXNffggc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722346265; c=relaxed/simple;
	bh=gxPQeR4JEm4ED3xLchT5zAbPzANcTdMNMhIHx/82Uz0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bns3Eclyqc11UX/I4m81pGW8N23fvavi1DSRrVwRzjh0qMpb6t2QF7iiNbZWjFcYIcvfF5mMO3horunq3hM2t6TNRn0zRsYwKb33nFuSCisFC7a/suemWd8I3zhsdkZlza6ItuVVfoJ0WFgu/ojLOZnMHyiVbjkjOz+APd3BGuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZIMfhpV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZIMfhpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6F3C32782;
	Tue, 30 Jul 2024 13:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722346265;
	bh=gxPQeR4JEm4ED3xLchT5zAbPzANcTdMNMhIHx/82Uz0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=PZIMfhpVnD5TXNCVpu81Vu9Zf20macrzd8iD0N/ztCOh8mQ+wH1a8HssbwzdfSW/H
	 zXyM/0eCYq5PxhKaI/RqtSsMbYJHRc3xS1Pl5Jd0vtQAV/x1maRyTPUH+sU3mV3AVx
	 0D904Wsh1SKqHNfQ4/Vlb0M+Loou/3dPMRga6sPSR1uDOPD/Hos6oySclyXi43U6Tg
	 oXocISUvUERZyQmHAxJH1HieMH/Ze4393mMF0NTjGKtE4KFwIc9uOaY5FBAtj5Wt8W
	 CboShfMbh01gBE12JGXABXZ3TzjW6QWS5eR3VJJdD8P8kRaIW6Z9KB4QHV1/oN9ky7
	 c+swJMORJRVsw==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 30 Jul 2024 14:29:14 +0100
Subject: [PATCH v6 2/4] arm64/fpsimd: Discover maximum vector length
 implemented by any CPU
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240730-kvm-arm64-fix-pkvm-sve-vl-v6-2-cae8a2e0bd66@kernel.org>
References: <20240730-kvm-arm64-fix-pkvm-sve-vl-v6-0-cae8a2e0bd66@kernel.org>
In-Reply-To: <20240730-kvm-arm64-fix-pkvm-sve-vl-v6-0-cae8a2e0bd66@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=openpgp-sha256; l=4205; i=broonie@kernel.org;
 h=from:subject:message-id; bh=gxPQeR4JEm4ED3xLchT5zAbPzANcTdMNMhIHx/82Uz0=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmqOsPLRabMhVM/5P25hmNsYB5kqWoe6yX2/VVbRsu
 OVa/KZKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZqjrDwAKCRAk1otyXVSH0FnEB/
 9XXxxphdLHXNVf9+3cixke8oXrd98bWG26W7HuY/f3O0KoiTl2TgieB+5f1E3J1p2BnguzoIqmVMbP
 Z9DCo+SKme/Jv9NrTEKS51ONvzghY31bZYC+VnCjiv+ndJqsSYxwIE29aM8jOvVdqNnoXxGUrJY2qt
 25yfFgX5JIt95X1IM/Ysm6LeBT5QLgA6zP6DI55rjrpk8jVD6ptzb8bizvCw58oxG7dq3UQvX5WYF2
 +OQMn8DhnvAVRgeqmNEBQiTv5PBD5sGwORFjmBEwTjHkWGfYxZKNhwNFFgoLcwy4DzC9SJBX6wKRTP
 gQ+ErMwYIGhXoE4FXxhhGamgXTAHdN
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

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
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
index 8a080dbd8988..0bf0837d4adb 100644
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
+		pr_warn("%s: cpu%d: increases maximum VL to %lu\n",
+			info->name, smp_processor_id(), max_vl);
+		info->max_cpu_vl = max_vl;
+	}
+
 	bitmap_complement(tmp_map, tmp_map, SVE_VQ_MAX);
 	if (bitmap_intersects(tmp_map, info->vq_map, SVE_VQ_MAX)) {
 		pr_warn("%s: cpu%d: Required vector length(s) missing\n",

-- 
2.39.2


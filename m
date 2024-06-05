Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F23194143;
	Wed,  5 Jun 2024 11:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717588210; cv=none; b=DpRw+gyJjxqVlyLQYsfJfEm3TM3ehQDBcoxXI/7VVv/9JopFmzkoi1ZxcTKbRJ5KFH+Ci2rRB7RJK90VQYxcyQxJTD/1eNnzwhMOytINdLZoW/e7opjOH85ZV5NWiENCCMTpRdsIAMvKKU85q2yhxs/9gSf54xxxJVZ4eNPpVNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717588210; c=relaxed/simple;
	bh=0HRuKE8VlXUba+j3EwHzj90KT4DQxSJsorHaMRo2+XQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RUwOhn1qTlAO5N1kul6YytgyN7kwDyqWKPBJ82KYThZh0IMj/9UUJvlOmNJGInDuk3nXT92Ry1z0liyeRYIcBy2ECydTeFB1BnDA+zgs/+/BKbxdjLDLWYxgIL6vXafhOz8K77rZLmcQ5SbMMwskoShTaOMRsgdpFAQm7a/TnC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JTc6iI5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JTc6iI5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB49BC4AF0A;
	Wed,  5 Jun 2024 11:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717588210;
	bh=0HRuKE8VlXUba+j3EwHzj90KT4DQxSJsorHaMRo2+XQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=JTc6iI5Xt2gKkG6jzOLpgp9JosGSx32VAglx5WX3G2X2sRgBDpIM9ChF7WDq+GHBE
	 cturpVQV9rI/nKk+lShBopKjb0v5c7jNQQg6dxIbtOwJOoFpwsTdJKK4zDXwSi2RYE
	 s7RwqJHwqfFZRqhzLC73vkblm98Xz/h716R6kZBid7jMKLP4LjLOgwz2yd6O61Shq5
	 3b3ODe5E3QJwAZkDUEL/YgW7C45P8d6OGVZ27cDG0WLUZT+TpXAJvBFO2h5fBdZAyX
	 V6SRCgojTr+9u+C9Rt2EuGDBTpp3Yk65p6TPM9ZhkGb9kf6+Jlb9o9U1IOKlhINLj8
	 8LAa8X/N9sTWg==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 05 Jun 2024 12:41:28 +0100
Subject: [PATCH 2/4] arm64/fpsimd: Discover maximum vector length
 implemented by any CPU
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-2-680d6b43b4c1@kernel.org>
References: <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-0-680d6b43b4c1@kernel.org>
In-Reply-To: <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-0-680d6b43b4c1@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.14-dev-d4707
X-Developer-Signature: v=1; a=openpgp-sha256; l=4299; i=broonie@kernel.org;
 h=from:subject:message-id; bh=0HRuKE8VlXUba+j3EwHzj90KT4DQxSJsorHaMRo2+XQ=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmYFDniQKKB3lNFxU6WDccvOf/Ww+JlNUgz3udSCRy
 bnFnw/uJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZmBQ5wAKCRAk1otyXVSH0OqyB/
 wNfv5HhFD0WNmHYdHM/Rb5yPlCnrAftBkUrzdEtnR5ro/4hHSlplNLYs57As2SqP7e8hwPe0TYSYFk
 DhvCSELsGfkDFn7PYz+os1aOPgFGHO0SVZ/pJuFLC/ZqI9argK5wg7VoQHZUP9yAy7N3ji7kC5KxLr
 8iEa8CzZaIdaMX90p0o4RMO2D7kwv0A0k5VLLaQHZDEUGbbJARn+KBR+huwM3AFw0dvSYc+VkHCc23
 po3tNZVqfEeB3xHfXKK2OMkY+NDfGRbSX24mznjzplDD1VlVAFO3O28BAe6S+zYU3o0BBPituikoEH
 Ae+vh9utlClmvraRzvOBzvbt361e0i
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
index 22542fb81812..27f3593547f1 100644
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
@@ -1069,9 +1080,10 @@ int vec_verify_vq_map(enum vec_type type)
 {
 	struct vl_info *info = &vl_info[type];
 	DECLARE_BITMAP(tmp_map, SVE_VQ_MAX);
-	unsigned long b;
+	unsigned long b, max_vl;
 
 	vec_probe_vqs(info, tmp_map);
+	max_vl = __bit_to_vl(find_first_bit(tmp_map, SVE_VQ_MAX));
 
 	bitmap_complement(tmp_map, tmp_map, SVE_VQ_MAX);
 	if (bitmap_intersects(tmp_map, info->vq_map, SVE_VQ_MAX)) {
@@ -1083,6 +1095,18 @@ int vec_verify_vq_map(enum vec_type type)
 	if (!IS_ENABLED(CONFIG_KVM) || !is_hyp_mode_available())
 		return 0;
 
+	/*
+	 * pKVM allocates and uses storage for host state based on the
+	 * largest per-PE VL, reject new PEs with a larger maximum.
+	 */
+	if (is_protected_kvm_enabled()) {
+		if (max_vl > info->max_cpu_vl) {
+			pr_warn("%s: cpu%d: would increase maximum VL\n",
+				info->name, smp_processor_id());
+			return -EINVAL;
+		}
+	}
+
 	/*
 	 * For KVM, it is necessary to ensure that this CPU doesn't
 	 * support any vector length that guests may have probed as

-- 
2.39.2


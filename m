Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857C513DDCA;
	Mon,  8 Jul 2024 14:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720448479; cv=none; b=WmlpzX/zEIQnqe2vKrLxHSBnPV6h136Q9G9H0E6ZK2Q86XGze78Dsv5atN0fjib62B8tN5aIKZHY8pqiCAuj67xZkQg1ba2cPS4Jr1/zGEvZQ1NjVErLoKJo7ahkW2PRMQdM00q1cpsMN59m4RB+R33vBXDfEeiZB9PAxP2RYxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720448479; c=relaxed/simple;
	bh=qYUCz/GnFjAVns0VEq9hJ3jJLihZ2D7gvH2hjVtPvmE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WPfeCtx+05uTjl83c0wfjpYHq5+pHRa4GpBxw3SLteekG1XD76fjhVhhI1K/ILCMHeexgIwGHsYRiqfKWzUt72R8uK5adKqzTjNc9hJdGgObPdL426pcqSyH1J7YuZjUDmN4Jkr09GfVW+n7Q3weZXMuwdogUWst9uZGuWy9nAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=itHV/iQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="itHV/iQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5FFC4AF0C;
	Mon,  8 Jul 2024 14:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720448479;
	bh=qYUCz/GnFjAVns0VEq9hJ3jJLihZ2D7gvH2hjVtPvmE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=itHV/iQJwX8AF0mI9TaSqAD973EohWsJWScNxYGLJWJTGYEIC6IKqWebdTzlgP9tb
	 lrY9lQw1dBCemPH2nR2Zl+LJ0Ng69HF7xguBjtKXYvjlKPhZPEkKUOQZZ/xvk66um1
	 Tk9bpL2U3K9ZfHYq7lQ7MUm9DpVJLZGmc19AjRMYKn/AQ96pesrEzlTLSRidQ4x+xu
	 WCxElCKnuT5EkUQ30/DM+gOqffsPWf0buki3itzo3tBr+dHz84evoVgYgucyI9x846
	 NrVyueuGOb9CqNN5iqKpYd9x2Tm+BzLWNd54TRn2XzWcuN1ZpUgrL1B+jr3WWQN+Fd
	 Lwzh7V8N5Y/oA==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 08 Jul 2024 15:19:14 +0100
Subject: [PATCH v5 2/4] arm64/fpsimd: Discover maximum vector length
 implemented by any CPU
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240708-kvm-arm64-fix-pkvm-sve-vl-v5-2-d2175738456b@kernel.org>
References: <20240708-kvm-arm64-fix-pkvm-sve-vl-v5-0-d2175738456b@kernel.org>
In-Reply-To: <20240708-kvm-arm64-fix-pkvm-sve-vl-v5-0-d2175738456b@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.14-dev-d4707
X-Developer-Signature: v=1; a=openpgp-sha256; l=4205; i=broonie@kernel.org;
 h=from:subject:message-id; bh=qYUCz/GnFjAVns0VEq9hJ3jJLihZ2D7gvH2hjVtPvmE=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmi/XKqIXw3fqv/owoP6gSsQUyUHt0UKjGj4ewoE4Y
 aUiUetuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZov1ygAKCRAk1otyXVSH0LALB/
 9loGOqhZh6mzKtDzQY7Gt3WP8tKnsrr8g3ThOs4gC1wusZ15hNO9LnmgRrdGew8JfJbMNnXsIDJcju
 WBy3IKnes8EvHng3lyvt8kFK7tVd/qnpmjoa+B/a4F/sds3n75V2QcWeDZu4Ss3ohtocFnTa/OR3CV
 PjgaMuVr6yHq+QzPKIoG2+ct49pPmJMIH1npDHAy5PKT80Sk4dUQHtyofOtjmyuTsvIVQVLVJ2/sId
 R8pnUNFShoC+4ChVRAEW0I+a2OS3vCgyEFg3JfZte9sMgpeJtiPdPzYq95EEal/SSosY2u7KCs8LJW
 ksqORQ+4LddvoKt7XqD1YAICWUsqqX
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
index 22542fb81812..83984cb3f21a 100644
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


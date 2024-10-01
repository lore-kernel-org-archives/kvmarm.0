Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704331C1ACC;
	Tue,  1 Oct 2024 11:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727782279; cv=none; b=YyvlVGBf0+NZgiqylwJCVvP5xUK2lzTmkE8fX6DLXknkH3NfHBcHhgE6QNzZ6sstLvvzDQmyj1qEelL9nos2BeoMChSWg6q0tKV2P+i+fTNiNF2oLDPevlWBvubEbIPNmXD0VfsNpMcDUgv6tD0lA4wfrmi0feFivTJWGmRa4YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727782279; c=relaxed/simple;
	bh=T8FjmI+5TxAQIynPAIQoQkfPmrHt9l4M/rmCIDXWNk8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ie8k8Tx89ahz+lkFdlcQDLCKyTJo4Y5BwDlZPPu/f/uUsobZp/lsaltIHKcwtBbREngpVLA3920LtbpIerqvDn4J5PdXXnLD1F48AfSpqbEx71RtZC7eK6fDhPY6VW7g5Z/qcD9lKd18q9tER+RzKy6A1PlXJTGlbQUX1PWsnGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Niupd6pT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Niupd6pT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E53C4CEC6;
	Tue,  1 Oct 2024 11:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727782279;
	bh=T8FjmI+5TxAQIynPAIQoQkfPmrHt9l4M/rmCIDXWNk8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Niupd6pTw/ZNvqwxoEImGBsdNK8Psgwq8K6LKc4ziELCbvvS0OVtx/T0EN6fBiPnd
	 pK8ioArLpJv2NZWn/en39KA5U3aZxJ5xDZgQyWgwrTvrRakq1H1La3O0Pnjt5MVn/j
	 JLQKYgTtF2yfhUs/+j2BS0YHQE8vmptykquie25DsL2apAXGouXTx6nveONf6Vlg9w
	 G8On63/UDgyvG4R85fTUfi3kkUTR5MGXXwNf3lJI/TAEV2HZpNcqFr8hQOhLAkedU6
	 yWVwbIo8sfF0/bdaEWixDvv3Vzy4qnFTVFtVs5Up8V9QjfxAGyyCCb7/fJOPj/jWCP
	 hvED56DYkN/Ag==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 01 Oct 2024 12:29:07 +0100
Subject: [PATCH v7 2/4] arm64/fpsimd: Discover maximum vector length
 implemented by any CPU
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241001-kvm-arm64-fix-pkvm-sve-vl-v7-2-7b0171a36695@kernel.org>
References: <20241001-kvm-arm64-fix-pkvm-sve-vl-v7-0-7b0171a36695@kernel.org>
In-Reply-To: <20241001-kvm-arm64-fix-pkvm-sve-vl-v7-0-7b0171a36695@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-99b12
X-Developer-Signature: v=1; a=openpgp-sha256; l=4205; i=broonie@kernel.org;
 h=from:subject:message-id; bh=T8FjmI+5TxAQIynPAIQoQkfPmrHt9l4M/rmCIDXWNk8=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBm+919ztNN3f1p7RnUQbLl+kj+u0eNguOZjwmLwrCH
 RRxsJ7uJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZvvdfQAKCRAk1otyXVSH0HE+B/
 9TyWHjKOKfGCjZIC6IfjLAEsXXFeXkrEwn6BlS9R81DdltxbYEk4weYzWvbTIe7A2JO52fqD51KLVn
 4Fl7BLZny2+KsuDXIjp8LRdmXg+vmeKJ6DPY8pLQYCDUy4JtexwtLVDT/ptuX+FYC5gZaV84wgCM5Y
 E0kZPQMf3JM3vRzMo7SbQiQdZF9Rkio1ZRlvaNriPgg9SJdXitsGSr9ciTQ3iIInNXbHuYVl+wH5yM
 /DnCYlZRIs13UaBO2wxIqrFCcIIzL15k1c8cgZXWaeh6YlxTmcD+mBBbRYTRAaJgzpu7IZvRlCR08Y
 aD7eXunfqinvaatVVlbQ2Jb7R/a8tx
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
index 3c30da35c285..754b0eb09fe8 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -186,6 +186,9 @@ struct vl_info {
 	int max_vl;
 	int max_virtualisable_vl;
 
+	/* Maximum vector length observed on any CPU */
+	int max_cpu_vl;
+
 	/*
 	 * Set of available vector lengths,
 	 * where length vq encoded as bit __vq_to_bit(vq):
@@ -276,6 +279,11 @@ static inline int vec_max_virtualisable_vl(enum vec_type type)
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
@@ -286,6 +294,11 @@ static inline int sve_max_virtualisable_vl(void)
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


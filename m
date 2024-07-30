Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C91019FA66;
	Tue, 30 Jul 2024 13:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722346263; cv=none; b=cFWmhnrgVKpIan9N2pb3n6feg5ZcE4fznLyr/3PD4UQDHiozylACZG4Zmhpg/pFhmyuSOpzYeGilTjg4IoGlbnzi2Van5MVO4vc0MuLGFvgI0kKqDc1ycAMu6OsvUwsuTYO6q6r+58/dsWJQZymAjY8LMgv7irkeb82si04Uy6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722346263; c=relaxed/simple;
	bh=NbB0wtTd9/6wN6rW9W6ApESo3bbFx8yYxHqilIZ4buw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZX0ZgUd/OQcYttyX6e+RJ89vO51OeMbqM1Icdxlx2rJWPh6t0GL+BLuK9PHYmkXcvlrufNlp3Aul7vH6aBHb2n3dsZdvSkt9NXeVH9lUbL6/9w1MHGdMgZ7bEZgj3hCGvxtBDv6U438cGQmUsiFmHOfuN2wkkbBOdy1mPoV5/9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rcXyM5Er; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rcXyM5Er"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F795C4AF0A;
	Tue, 30 Jul 2024 13:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722346262;
	bh=NbB0wtTd9/6wN6rW9W6ApESo3bbFx8yYxHqilIZ4buw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=rcXyM5EruvY1lEGPpUyu1Ns7OH/+cYB/9zc2CqD92dK+skajJAm/OS5Lez9Gj/QJm
	 fauN3jDgR1LyjBZ7ZQQPb7jUvGdGmPaWMmg6DFrGuhc0DnyGbAPqEfWj/Ndc0a+CEl
	 ZHxgiYW5rrPzoXXD2mo5c4EA1lNwekDd+/iM3lMduWZUHRSOI5fxgZITcnKl9a5tDQ
	 LpMd8CAGnP8eoFFANHoGd+NHLZGPe2rP9yN/mAB4wuO0qa6OgOiDzImlCjoBOKVn/a
	 1K74TE5ahUIXlqtMXmWGx4osfqq5yiAxJDOtqr0efW1npyPr+X/HQqnukVfRvy15Ai
	 wusQjN+cPKMbA==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 30 Jul 2024 14:29:13 +0100
Subject: [PATCH v6 1/4] arm64/fpsimd: Introduce __bit_to_vl() helper
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240730-kvm-arm64-fix-pkvm-sve-vl-v6-1-cae8a2e0bd66@kernel.org>
References: <20240730-kvm-arm64-fix-pkvm-sve-vl-v6-0-cae8a2e0bd66@kernel.org>
In-Reply-To: <20240730-kvm-arm64-fix-pkvm-sve-vl-v6-0-cae8a2e0bd66@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=openpgp-sha256; l=3064; i=broonie@kernel.org;
 h=from:subject:message-id; bh=NbB0wtTd9/6wN6rW9W6ApESo3bbFx8yYxHqilIZ4buw=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmqOsOI5kTkWURoz5mMs9dngUzBcq7zZEGfZxLhdSL
 3pASJIiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZqjrDgAKCRAk1otyXVSH0EZxB/
 wPz2QT0RwfeWLLwSrqIuqwD0KCtOK2+QxCkhjtuSSTwgYHH9N6b4PZeJ/JFQYQOCW8/7O8oUebrIe5
 jZCoO/aKjMDwsyfXTC7WqNBOT8ZoegqH9drOJUB22FHzGbTBgwGtXsWFHy3JM/4I7trcG0k3PprB+B
 dym8i7nSYB8zMWEvVR9Jz8fsfABsqSjLmz/ktXSHcIHeZZ9cKSBr5E7HMxPLn2QLxswPoBgk4/1+ru
 DjM6YnrCjw57o3bYXyWOvkj9wrknByigsv1Vuyf47QHRe/SosdDLn1otiSoAz68Svn30VAbsxCvvIE
 ZjPQCTyjIFXe+PCChpl132oXYPV39B
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

In all cases where we use the existing __bit_to_vq() helper we immediately
convert the result into a VL. Provide and use __bit_to_vl() doing this
directly.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h |  4 ++++
 arch/arm64/kernel/fpsimd.c      | 12 ++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index bc69ac368d73..51c21265b4fa 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -172,6 +172,10 @@ static inline unsigned int __bit_to_vq(unsigned int bit)
 	return SVE_VQ_MAX - bit;
 }
 
+static inline unsigned int __bit_to_vl(unsigned int bit)
+{
+	return sve_vl_from_vq(__bit_to_vq(bit));
+}
 
 struct vl_info {
 	enum vec_type type;
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 77006df20a75..8a080dbd8988 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -530,7 +530,7 @@ static unsigned int find_supported_vector_length(enum vec_type type,
 
 	bit = find_next_bit(info->vq_map, SVE_VQ_MAX,
 			    __vq_to_bit(sve_vq_from_vl(vl)));
-	return sve_vl_from_vq(__bit_to_vq(bit));
+	return __bit_to_vl(bit);
 }
 
 #if defined(CONFIG_ARM64_SVE) && defined(CONFIG_SYSCTL)
@@ -1103,7 +1103,7 @@ int vec_verify_vq_map(enum vec_type type)
 	 * Mismatches above sve_max_virtualisable_vl are fine, since
 	 * no guest is allowed to configure ZCR_EL2.LEN to exceed this:
 	 */
-	if (sve_vl_from_vq(__bit_to_vq(b)) <= info->max_virtualisable_vl) {
+	if (__bit_to_vl(b) <= info->max_virtualisable_vl) {
 		pr_warn("%s: cpu%d: Unsupported vector length(s) present\n",
 			info->name, smp_processor_id());
 		return -EINVAL;
@@ -1169,7 +1169,7 @@ void __init sve_setup(void)
 		set_bit(__vq_to_bit(SVE_VQ_MIN), info->vq_map);
 
 	max_bit = find_first_bit(info->vq_map, SVE_VQ_MAX);
-	info->max_vl = sve_vl_from_vq(__bit_to_vq(max_bit));
+	info->max_vl = __bit_to_vl(max_bit);
 
 	/*
 	 * For the default VL, pick the maximum supported value <= 64.
@@ -1188,7 +1188,7 @@ void __init sve_setup(void)
 		/* No virtualisable VLs?  This is architecturally forbidden. */
 		info->max_virtualisable_vl = SVE_VQ_MIN;
 	else /* b + 1 < SVE_VQ_MAX */
-		info->max_virtualisable_vl = sve_vl_from_vq(__bit_to_vq(b + 1));
+		info->max_virtualisable_vl = __bit_to_vl(b + 1);
 
 	if (info->max_virtualisable_vl > info->max_vl)
 		info->max_virtualisable_vl = info->max_vl;
@@ -1305,10 +1305,10 @@ void __init sme_setup(void)
 	WARN_ON(bitmap_empty(info->vq_map, SVE_VQ_MAX));
 
 	min_bit = find_last_bit(info->vq_map, SVE_VQ_MAX);
-	info->min_vl = sve_vl_from_vq(__bit_to_vq(min_bit));
+	info->min_vl = __bit_to_vl(min_bit);
 
 	max_bit = find_first_bit(info->vq_map, SVE_VQ_MAX);
-	info->max_vl = sve_vl_from_vq(__bit_to_vq(max_bit));
+	info->max_vl = __bit_to_vl(max_bit);
 
 	WARN_ON(info->min_vl > info->max_vl);
 

-- 
2.39.2


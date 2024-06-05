Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CDC195F3F;
	Wed,  5 Jun 2024 11:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717588207; cv=none; b=C2FCOZsjZZtId1o7X81i4zbrywxkn1QEcAmQHDxUJODbwGVXqmGbnFVXh/w9v7OpthohglplPmtmJtGQ6p5TANb5i/Ea3h4N9NGlI80otcbo5u5aYzEVesOFtgx5hcQRSy8sYU0zKbyz+pu6R+qzTNEkRMSWEkCrO/pY/QXTof0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717588207; c=relaxed/simple;
	bh=Aa17kOoXpX/HoXHXzofiE99MuhIDY6p0rI+xW1GTtrQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=npW5daJsUotxYKqNW7Jlmwa+JjHd7i2GYlaUHs9fnC2oND/5b8AYXMOm/ah0pc5LuyBd5WOkQMHkMlqEyFt2ROsDR6xcCuomLQV7YKqG5kq5kmZ51MEnJSmcG9DipPKwb6wPh57mxy/6moUsVXrqfH6WO8P5D18HowYaIBPmyv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rVCBHKWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rVCBHKWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F53C4AF09;
	Wed,  5 Jun 2024 11:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717588207;
	bh=Aa17kOoXpX/HoXHXzofiE99MuhIDY6p0rI+xW1GTtrQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=rVCBHKWhHA237EB6RPwpSILVDLYPNE8KqNzQsXy07/6G4MO60f7LdDvSId8e3ewyB
	 sCb7rF95UCszxwUW6VUZhAGczzdeUQymomZohA7uaO3jo3CBpZ/PBO5j2YlxbDbNed
	 ezgjrg3H++OknfISav5F19mA+IklAr8wStlaRHGzBXnokhHbg9MQJwhma7tfWXom47
	 UMJ57499EtmomkSD0euqqYZ7Ry7kcDuQvkvf5u6dFrAzlVUT7d+G/06afLdT6J6ql9
	 1YiEiV/+kYSDprMf2qUIAU51c/U8VTnjU/fMFj3pR6LVCYepfxOkA3YZsQ7c9D5hLV
	 FBkDxotBeVopg==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 05 Jun 2024 12:41:27 +0100
Subject: [PATCH 1/4] arm64/fpsimd: Introduce __bit_to_vl() helper
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-1-680d6b43b4c1@kernel.org>
References: <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-0-680d6b43b4c1@kernel.org>
In-Reply-To: <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-0-680d6b43b4c1@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.14-dev-d4707
X-Developer-Signature: v=1; a=openpgp-sha256; l=3011; i=broonie@kernel.org;
 h=from:subject:message-id; bh=Aa17kOoXpX/HoXHXzofiE99MuhIDY6p0rI+xW1GTtrQ=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmYFDmUQYv4GiElk8lqZoB3sQBV0ApYQH/AfmNeizO
 1sflt5KJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZmBQ5gAKCRAk1otyXVSH0HqICA
 CDvBoq6AwiNa+cnUxr9ztBR/u4A5iQIk71gQXuIzvTwZTDP9PwOfqkmq/W/xeYVHxnJNJc5NVRJ2p8
 dhrOBC3DxAlnEFw/pLhSxU6XsARczaz3CnNE3X6ulv9PypAG6sOy+auofHZPMKS9dfvnVdskiZ60Hs
 1NeDFb+OlRuqY5+2LCYtkDWWZDE7UyWHuedBoK+KJZ/SGJ5VpLWG7Z0WNihx4bR4NRjBdSwELH63eT
 0wqlTPMOd3TxdzTSL8M5nyX3QUR4tEW0ApLJyDAxtMdUa/1xDV6Ada/mZjQnwNFKpbL+w/O+q85KMJ
 B7PhUoXwIlZzexuq4cAtwl1hQzM9lP
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

In all cases where we use the existing __bit_to_vq() helper we immediately
convert the result into a VL. Provide and use __bit_to_vl() doing this
directly.

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
index 82e8a6017382..22542fb81812 100644
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


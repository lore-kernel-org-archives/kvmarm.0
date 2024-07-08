Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA4A25745;
	Mon,  8 Jul 2024 14:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720448473; cv=none; b=KcT3fPlHzQjVgbbDl1E1TdnJv0zwebKrSR6oitXi4NKdMqRntHg8qZ+OKqq3hdbCHDJ5iGT9MC6K0oOF1IJwjJ4aBvIXqhOtPTU8/1anszcdNoh7VUx5JrWnHuUnVuLFLMrDYMF4Qn2zOjnZVcsH3tx6upLv9JcZNHQVFLlZCao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720448473; c=relaxed/simple;
	bh=hZLMZ8MyT6kMtoPFEmNPK6rAznf1lF+TnbSpYE4U9Gw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=twt7TbjDPpot4Uj++7e5OLGrZcn28yvTYhXvlcozRERO5eKa4cIytJVZdYZta9K8MQTU3J6bmxC822U73m4ekEGdr7ENnQ/XJuG6LACdFdD/xOPE5z0Tbn2Z6PCXf6pazikpyq7DOkX6ZBZ0Rc8tfqjlrOq7jd6Y6O0kHVWiOtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=igG2dyhb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="igG2dyhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CE2C32786;
	Mon,  8 Jul 2024 14:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720448473;
	bh=hZLMZ8MyT6kMtoPFEmNPK6rAznf1lF+TnbSpYE4U9Gw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=igG2dyhbNOmzvNvCMHEukqBdePfK9G/NYPDS2EO7nic3MZZh8iNe8dGQbeuIr1GDG
	 /NDtmIHVZFsz3jzVxElOZhTorpMTlkbL/3u0tJ2c4IxfFSKxxfilnR8cmOmecf9kpp
	 xIHbyV4NI4iyvHJja+b+pvE7vF8vtpU1/SIfP+0CcYI68WLkady/Sb+XiQl1iuUWPE
	 fjTMedVifM0hnFBIlY8kP/YHGiOV9/zgh2vixqzRuEuAAnwxGg5BnhuMJgLl7YkzYH
	 vA3Oy7REIpn5tJETofvIXhZzUOK3qfCROzzip5O+R0iSvoXOThUNj732pEfm/ISGqe
	 RtXjR7AfDj8Yg==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 08 Jul 2024 15:19:13 +0100
Subject: [PATCH v5 1/4] arm64/fpsimd: Introduce __bit_to_vl() helper
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240708-kvm-arm64-fix-pkvm-sve-vl-v5-1-d2175738456b@kernel.org>
References: <20240708-kvm-arm64-fix-pkvm-sve-vl-v5-0-d2175738456b@kernel.org>
In-Reply-To: <20240708-kvm-arm64-fix-pkvm-sve-vl-v5-0-d2175738456b@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.14-dev-d4707
X-Developer-Signature: v=1; a=openpgp-sha256; l=3064; i=broonie@kernel.org;
 h=from:subject:message-id; bh=hZLMZ8MyT6kMtoPFEmNPK6rAznf1lF+TnbSpYE4U9Gw=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmi/XKD2+TUI1Cyn7ePjXDspx0VpCug0kIGJ3W17j+
 9vXMgyOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZov1ygAKCRAk1otyXVSH0GrqB/
 9NYKedb06mp3A8L+/yLmh/C+DS10cFI2D9vDHdMbYe2lm1NaaFK1UeX3fKV6oOa0V2K0ginMD8xQmZ
 9By4lViccEEJXgGM+Bs51VZ0KwFl51N34wiC3fLMOhYZCGRGPp1YdjNrSmbKHQGvevm3og64/1Oq+r
 qXl+Zf3CA6vL3hWf4vlV666MHRQtMQjHhyB3kR69RkgWG3apvWSorwWjsIQdIFBNC//FnpR72bjR/N
 e1RNkqY/lIDaXMccswaDgANHVFuJMRN7tCFk4d0YEVT5n+4xEeT5VQxtg7a/mf9az+l845mutVc1l+
 gjd4cUB8a5FUeU7ux5Ysfua/xbC+lP
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


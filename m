Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E235813C9A1;
	Thu,  4 Jul 2024 17:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720114126; cv=none; b=ndfqC+6I4u76C4HOXkEg35JNbMRTLJFGgYM7VuwVSPUzG3J+1vSuu8b225DbjYQxW7GG/GiS9kE8bYEg93xmsJPp/zcLqUtDVQ5CYRr0OJVrwnXTRSYdJZ5jxt33vNYZtGT/fRS2gK2GVou9EqkxOLjMneXXeBuIKntLrGoxiec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720114126; c=relaxed/simple;
	bh=hZLMZ8MyT6kMtoPFEmNPK6rAznf1lF+TnbSpYE4U9Gw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=d5up8EHD0Zr/23V3dcUH0ONXxiED1+zYS7B6jnWDDLIVTSuVOmuUgAQUCW8ti+bE9GMAP06Qwg9MOunmOtc9SHmkMMTIHjVdtRhuGyBEow5JTvlxKewW9woe5QpNoUPTtFuxhzeg1vFUKabJXMi41P/pu329b6Rkq/+JRi5QiZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=czq7fVvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="czq7fVvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54163C4AF0A;
	Thu,  4 Jul 2024 17:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720114125;
	bh=hZLMZ8MyT6kMtoPFEmNPK6rAznf1lF+TnbSpYE4U9Gw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=czq7fVvfpw8zZ9PDpBBuOELWM23B9djKCrim22XAI5fmUIN8QOucWyYZe3144UcOk
	 /Kk5oa+UvNcHYK/24TZZjwKpkkOMwmG6/ugf+Oyq+goVadm2v9Vs70Its8M9d6t07Q
	 t/KyuJ49x5qKjggMfrelShf+DEQ3LNf3nAp2OLjVQCKZmdiDhjsyICOzYYPL2i3YZ+
	 oY60zGybNcrgw3502h0+WOZ1iD3FxBV49x8+9ZjdHnnGPs8uYZf1geyoaGbxgI1uxE
	 OgO/EzxTTCPJweyQqe8TKF6tj80KsuwjzaJNwkbsEAKnPN8ezdmANRWdw9RVmYVabJ
	 g/nhuZmJiAJog==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 04 Jul 2024 18:28:16 +0100
Subject: [PATCH v4 1/4] arm64/fpsimd: Introduce __bit_to_vl() helper
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-1-b6898ab23dc4@kernel.org>
References: <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-0-b6898ab23dc4@kernel.org>
In-Reply-To: <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-0-b6898ab23dc4@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.14-dev-d4707
X-Developer-Signature: v=1; a=openpgp-sha256; l=3064; i=broonie@kernel.org;
 h=from:subject:message-id; bh=hZLMZ8MyT6kMtoPFEmNPK6rAznf1lF+TnbSpYE4U9Gw=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmhtvFK7ynTjDA3VBW5+3nCTmmSgV+pDygMv8Pa5of
 tovF3L2JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZobbxQAKCRAk1otyXVSH0NjzB/
 9wAyCRckkz1EF1KyO3aLbh6rTu90S/RI2qugJgleo/PlnfJsFd0CP4Jhk6M1hPpm6EyqjwD47VRihf
 1dvghkKGzVEbbk9UNzGROESbYg5fq8g8V+CZZnF5CCI9iSpdwHRnkERVuzwWVG7T35vlRf2fKrJ5ru
 xGRteEn1YU9i4c2txqKYLHuwV2KmOSXcan0h3hfV5N3SThCpBzJ6X5/Wy7AiYAtTeRZzy6Wycxobxj
 zf/5/zXZ/82T/8W0WC4IWJ6rmolkkDK/39Zz6pfvc8KdYYzPCrwyT4luLwp9PU5TqOG2z/firzEwFR
 0s8nhJ/IZhIdnIqp4SStA7Qj0TcTWG
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


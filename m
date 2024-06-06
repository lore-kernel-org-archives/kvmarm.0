Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8D1197509;
	Thu,  6 Jun 2024 15:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717687923; cv=none; b=tSADZvkFcL5xtRYNEvi/mjKEofkSEQvko/Um/NtdKMLy3IAefGG3jBEtRbukJNPZtaSiGiGOGe06lEB96L8wvCQ9L2/7kSSVp+lj4C3JKkOKaGvrJ0DW6lgceYL7oRLeieN27hCLsDCY0y7WKdGQ5ShrZp2RzXhcXOFxIQXkuY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717687923; c=relaxed/simple;
	bh=Aa17kOoXpX/HoXHXzofiE99MuhIDY6p0rI+xW1GTtrQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LzFK4rUjnLOntqLe7DOQmMSdJKDxceiKxU+lO2fa12ydC/DxNeJCKq2H/VSsB9s9IaQIq9XqZk4f6K0llrHbHy0nXGo5G3+uIS/4yGZyP0jP8ncivOtKNFKd+mZ4FdxMMnz+1ahnkW5EM3FQ2lOlzSuHqRr+C0hOop1HSWSAQ54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mTQrRX1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mTQrRX1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E65C4AF07;
	Thu,  6 Jun 2024 15:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717687923;
	bh=Aa17kOoXpX/HoXHXzofiE99MuhIDY6p0rI+xW1GTtrQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=mTQrRX1dO1n+8cgLj61SGwqQly5aDKw24AUm7MUQgBslD5lkSJYXmBDZGG9a+UAv/
	 5H5AFUbHgj9iDcGuMtzZb8IgPhVitB1FBeDcsZ0hLc+RZBDmg27EnIku+LiXi7yV1T
	 nZCnBq9jpVB5BweNWUHxeGbQuaMHzE3BCbVa8cwgafdDuHZSCMfLtw8TNR8+np+3Fb
	 Zt8ODaNFL2whdpI1s1R+S1JTqE43YsBdKVSjTZhvJh5Slh7e2pnHIkkBghLHKGo3Ba
	 pG4nhziKIYhgdT5SFjhYuo7CUO8jFcbIEomwzu+1Bn3oTJZh/W9Vv6Gfe5qdyMLaIg
	 UPIwurMsIPvQA==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 06 Jun 2024 16:21:43 +0100
Subject: [PATCH v2 1/4] arm64/fpsimd: Introduce __bit_to_vl() helper
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-1-c88f4eb4b14b@kernel.org>
References: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-0-c88f4eb4b14b@kernel.org>
In-Reply-To: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-0-c88f4eb4b14b@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.14-dev-d4707
X-Developer-Signature: v=1; a=openpgp-sha256; l=3011; i=broonie@kernel.org;
 h=from:subject:message-id; bh=Aa17kOoXpX/HoXHXzofiE99MuhIDY6p0rI+xW1GTtrQ=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmYdZq5XeihIh4fcv6onzasAqm1cre+hwvJKRCbbeQ
 C7IZOfSJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZmHWagAKCRAk1otyXVSH0Ly5B/
 4u1wKyoe85K4X+FUsIco+bd3WhkFtaFxx7izIviLRWJQIkq/EGCq2oJ4HWCvyJzVi7oS9+5T0ARm5H
 6dHLTbKAN+aFnuujqOlzMb7uJdakO7HiMPhOHW2jhssMwQnuHC2I43GU+nwwWvPlAgSDTpjk1RuWK3
 MEvLMNoAAUy1C6NDXwDJqV6TcQd8O4vEBxE9WkZSKlczYdHOh+Nmq0yfD3dH798mXDWd6Ezk33xdK6
 rbqgveKpI+1vuQUV5Y74eYzpTK5JZpl7LD/sioaDBZDhJivBVd4pJw8SJZh+DL5Rh+y125JZh4CqPb
 xhHS8RuI5NLIyrmR1XLFn7UakgBWzA
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


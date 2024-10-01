Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7ED91C0DF5;
	Tue,  1 Oct 2024 11:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727782276; cv=none; b=CiuNJ1V7Wiv/7tRX0qzO5khUChNb3aEDpj3WO6fkHhhglm/yY7RhEC9rO8Vu8vZ52jXv1VfdcAxyELHQmKJ8Q+Omr2CCVZQDEMlEkztH6BWQDE1czkrrvreIV00JIkxZhmskMx2l+WDTCpHG2g42YPUfZAZ9UYbP9kXbIgf8xnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727782276; c=relaxed/simple;
	bh=/8kAC4uyafUpiRRGXlRqbKMN4dLMMXoXHxOXxaPQDDQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=A2SG+4iNT6yd6XYIJquAFaxjGNKJj0r2MHYKgKLaBUnIXlEulXjipKrysWN8z/FFq2AJBjAhVkpEszG3PWooMZgGgexcHy6ITe0LlWzBnm6pU0wRV9HbsfDZ4euGt/RAG3wZF5frJI4M81WYo8i6Rt3JNJIoXujzyM97S4rpBFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T5Umuq7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T5Umuq7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BC4C4CECD;
	Tue,  1 Oct 2024 11:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727782276;
	bh=/8kAC4uyafUpiRRGXlRqbKMN4dLMMXoXHxOXxaPQDDQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=T5Umuq7ljlHWXhSLe/eIw8E95ukpdJgREL82FZYdJJxHAVrGCZSWDIckIz7LVxQKp
	 3tIWa9HnmYvQl2nd2+VeaCoz0P3x9R+DWElTguisIqt3Wosl/cFoZyIEb9Sr6WiPUx
	 rsNggS0pfUwCI5P0uYcNEUYH6FBQftvAJZn92YAx01DQS9eyiFqReamTnES6Vw0q/L
	 rqcrPFCFINIW7a3eSb3ySpan+9FOrd1kn0HMD0Mjkvrp4+w2D26bQbLHMwZDeqXeM+
	 qyPtRFnc0ZjgMjtQxYSobYY4RkH9iV1FuiGbjsWgNGmVrqDdpxeDPnX85em1jr7JSg
	 BZxCJowBjoO/A==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 01 Oct 2024 12:29:06 +0100
Subject: [PATCH v7 1/4] arm64/fpsimd: Introduce __bit_to_vl() helper
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241001-kvm-arm64-fix-pkvm-sve-vl-v7-1-7b0171a36695@kernel.org>
References: <20241001-kvm-arm64-fix-pkvm-sve-vl-v7-0-7b0171a36695@kernel.org>
In-Reply-To: <20241001-kvm-arm64-fix-pkvm-sve-vl-v7-0-7b0171a36695@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-99b12
X-Developer-Signature: v=1; a=openpgp-sha256; l=3064; i=broonie@kernel.org;
 h=from:subject:message-id; bh=/8kAC4uyafUpiRRGXlRqbKMN4dLMMXoXHxOXxaPQDDQ=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBm+918K2dkt+RyTe17B6hQuE/kqMhTsruB9gMWraGq
 ay4fjSqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZvvdfAAKCRAk1otyXVSH0ADvB/
 47xx2/156+0n1vm9GXaOjaUWX7fxRYKsC/VK02LjPI2bwp0DxUXHhJAidXhkijDjq6DuXua6jkqdDD
 kEQN3rBkcn/KcMLk/jkYToMkAcWfeoRFqWzIXZrGQR+3j5E4NHoGxv5yFTKNPNyNkkd3sNW2ReTBne
 ni4Hi3asHXhG20ls6oh42qwpnDXWAvCG3InygpC60/mxi7LuGdvDeIW6y5gxMzqdjRmP/vy0A1MoYr
 wdM8ices0RXqLg/lepRarbl0U+kacax9uEc9njx4VrUGsjIXne2rIMqG6bTgYK43yXlruLL0J3lRPj
 Mscn4z+5Oi8cIZwzIk2cHF7yKWo2S9
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
index f2a84efc3618..3c30da35c285 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -170,6 +170,10 @@ static inline unsigned int __bit_to_vq(unsigned int bit)
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


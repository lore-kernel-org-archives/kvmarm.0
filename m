Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E72396579;
	Thu,  9 Jul 2026 00:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783558376; cv=none; b=WxOO+EdHgpx6gYDcbTBsUGD+/vYiRNiF6Tj5pYutiitvv5FbjvHoN9dQjrkjOo+xHrMfD1kVgYBnqomX1bFdZkURs+1Fu7p/5i8/zjytSURU8OKFHk9uen9F6SSrhQCT4HFvSRtPPdYaKQZ5B1YuoBN+0IftpMn9NXTcdAmN8Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783558376; c=relaxed/simple;
	bh=neew/zQKQc9VPVi7macEuVISGaMZgaNeHcW5WvUvtiM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gKvThChSCOuWEgNp71tzlGGZTv0GA6cvulEnJsmVUZQd/9kf6vhq55ZPyMHJiJZlGQeT95+e+pynQDww6mqOFBefoj2QGcGGBNxrMTtpNilRk60J5dk5oUOX1a8kmx1LhhOgzWOjf873U+rzljHorKS1YVd1E6ayc2b7uRflaDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JUMu2w8v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JUMu2w8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4780E1F000E9;
	Thu,  9 Jul 2026 00:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783558375;
	bh=X4HlyMbyPhKCnIL3AvhZ79kxUeT3XQMJg0KjZKyp1dU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JUMu2w8vQvMzmt9ADpIztO/PmzTnYneDyT5/F4o3erz9msnqX3P9z8fXTBB9hefcO
	 TimcoUmZWagvDEJ06ggP1wAQ4rWD+dgTPXEScAXrKiCco1TzKYI2IgCZ2f+vVn6fZO
	 hbf1Tq5GozmKATaallMSTfrvqR4qFJ0QaCAK58ExTcQ2JDNulgpHZWy9+dlVgE5l4C
	 gU9CbfOh50UD0HXSxQ1MrmGxUYys+IKzRKRggaPOcWdBKQfGSSF45BIjzctNUUbE88
	 dkjnNGci72JcbcosJACqzDqma7Sx7SZJEF4Cw8KFd1HWN/UlYee5iiT3U/V5qR60Gu
	 mLx7XHCrmy9lw==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 01:51:41 +0100
Subject: [PATCH v11 04/29] arm64/sve: Factor virtualizable VL discovery out
 of SVE specific code
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v11-4-32799f66db9d@kernel.org>
References: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
In-Reply-To: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Jean-Philippe Brucker <jpb@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2673; i=broonie@kernel.org;
 h=from:subject:message-id; bh=neew/zQKQc9VPVi7macEuVISGaMZgaNeHcW5WvUvtiM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqTvC98EPz3V9/AxA2ctVBmogPMysf+ANGUElc6
 7/1yiSJoPeJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak7wvQAKCRAk1otyXVSH
 0GhLCACDfFY28B+Wo/awGJVxfMtSbkkTmZNrOlZrdlIvJ6eQMO87Ms6n3g0qMcvOC7vXYMzZS39
 cgBX2ZmVnnOdwLoEcdBaBBFkpjQ4DLlt5WmeNT8JgE+Dh1DcrO+dlq8otC3ymw4u4n7fwflzon7
 YsmNKzD478AXFIEisgACc5zZXsG6OjXy3OWxvQXIbb25AhX6jYAiaTV+rCDTu9GO8JNNguwOA2Q
 xGnJjf7p/Z0JW6eTKYzVGpiEjXfnE6KEvggu7yB+dsVpo6zx+9PVT6tNT7uYqIrloX5YSzkgS0s
 0KOioxQA4AaDKZKn26K+bK7yhXYky8q5SzPDHC/S4n+azFL6
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

In preparation for reuising it for SME pull the code for discovering the
maximum virtualizable vector length out of sve_setup() into a separate
function.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index dc1ad10e39a2..5c156e2a47ea 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1114,6 +1114,29 @@ int vec_verify_vq_map(enum vec_type type)
 	return 0;
 }
 
+static int vec_virtualisable_vl(struct vl_info *info)
+{
+	DECLARE_BITMAP(partial_only_map, SVE_VQ_MAX);
+	unsigned long b_min_partial, b_max_virt;
+
+	bitmap_andnot(partial_only_map, info->vq_partial_map, info->vq_map,
+		      SVE_VQ_MAX);
+	b_min_partial = find_last_bit(partial_only_map, SVE_VQ_MAX);
+
+	/* All implemented VLs are virtualisable */
+	if (b_min_partial >= SVE_VQ_MAX)
+		return info->max_vl;
+
+	b_max_virt = find_next_bit(info->vq_map, SVE_VQ_MAX, b_min_partial);
+
+	/* No implemented VLs are virtualisable */
+	if (b_max_virt >= SVE_VQ_MAX)
+		return 0;
+
+	/* At least one virtualisable VL exists */
+	return sve_vl_from_vq(__bit_to_vq(b_max_virt));
+}
+
 void cpu_enable_sve(const struct arm64_cpu_capabilities *__always_unused p)
 {
 	write_sysreg(read_sysreg(CPACR_EL1) | CPACR_EL1_ZEN_EL1EN, CPACR_EL1);
@@ -1125,8 +1148,6 @@ void cpu_enable_sve(const struct arm64_cpu_capabilities *__always_unused p)
 void __init sve_setup(void)
 {
 	struct vl_info *info = &vl_info[ARM64_VEC_SVE];
-	DECLARE_BITMAP(tmp_map, SVE_VQ_MAX);
-	unsigned long b;
 	int max_bit;
 
 	if (!system_supports_sve())
@@ -1149,21 +1170,7 @@ void __init sve_setup(void)
 	 */
 	set_sve_default_vl(find_supported_vector_length(ARM64_VEC_SVE, 64));
 
-	bitmap_andnot(tmp_map, info->vq_partial_map, info->vq_map,
-		      SVE_VQ_MAX);
-
-	b = find_last_bit(tmp_map, SVE_VQ_MAX);
-	if (b >= SVE_VQ_MAX)
-		/* No non-virtualisable VLs found */
-		info->max_virtualisable_vl = SVE_VQ_MAX;
-	else if (WARN_ON(b == SVE_VQ_MAX - 1))
-		/* No virtualisable VLs?  This is architecturally forbidden. */
-		info->max_virtualisable_vl = SVE_VQ_MIN;
-	else /* b + 1 < SVE_VQ_MAX */
-		info->max_virtualisable_vl = sve_vl_from_vq(__bit_to_vq(b + 1));
-
-	if (info->max_virtualisable_vl > info->max_vl)
-		info->max_virtualisable_vl = info->max_vl;
+	info->max_virtualisable_vl = vec_virtualisable_vl(info);
 
 	pr_info("%s: maximum available vector length %u bytes per vector\n",
 		info->name, info->max_vl);

-- 
2.47.3


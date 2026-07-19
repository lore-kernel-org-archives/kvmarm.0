Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC9A37F8BD;
	Sun, 19 Jul 2026 23:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784502620; cv=none; b=g9HNxonpV+XERVGzket+MRjSMNSYPmuV40b3L6O47hPcNjZj2DINmZ1PGmu4xy68tEOFKMhljzkeQ1qRNGgcaj5257HWbQUBgUFgJLzF+Fw4ybMZJ2oLxRoZ0lzdEgm5ph50sgrJDZPoFSD1nf9kD2xbp2nb6fKhdUl7ZV48Gt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784502620; c=relaxed/simple;
	bh=+zyEiRn4TZGrkp1zrM7y7JLFFhEzfJlzJup4jyLspPk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZiI5mfLL3wdwDju2shHH+DCkhECiSsoYrzDyiUUvcGN1LTWkM3B1v6Znud2hGkzVatLpZhr85VIgXu+yKLMlB6B+jDiXedLBf50DnnH0pUt+Qdj48L2Rq9WoY0vUCT4sZnyxtjEmNm3MoPjv1Si0jxq1IfNUI1WgiA8uVA3U0iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZcn60qK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZcn60qK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603871F00A3A;
	Sun, 19 Jul 2026 23:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784502619;
	bh=NedY6/OlzwTYxAtSditYiHpWbPSndrvxVk87IdXM00s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RZcn60qKqWUeqexSTmP40SRqFeZ6/8h5A5I+G7j7pYzDaIpVHshhnROKKVo/smlvg
	 jlkNEXHhbvXUFKTZopUg49/sSYprnU/zD9LQj5tUe4JFTGwa51LSMVy2pDtWk5oJOl
	 8E9JsYyS86bQstmy2rhi/FAuhrTZlsgDO0T7D5SLGB3QH1MjXfJuQUnQrozY73SzBP
	 RdB4VqeSEbTyYsDP/1Gn8T11kC1Qn/DeuRBPjYdbF4bna+JT3fWXLG50aCGmrueeKp
	 9e3/UZV68YYzZnAsDZM7SSYElQs+nkwkUlHBRoLhipUF6LosTds/xUMhHLyIaXLWh3
	 U7C84ZffO0DkQ==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 20 Jul 2026 00:07:32 +0100
Subject: [PATCH v13 05/32] arm64/sve: Factor virtualizable VL discovery out
 of SVE specific code
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kvm-arm64-sme-v13-5-d9abd3ffa245@kernel.org>
References: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
In-Reply-To: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2856; i=broonie@kernel.org;
 h=from:subject:message-id; bh=+zyEiRn4TZGrkp1zrM7y7JLFFhEzfJlzJup4jyLspPk=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqXVkrxveMIWtmYorGSKcx5B2y2hXm1FuAf3p3s
 oVBySvNN6mJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCal1ZKwAKCRAk1otyXVSH
 0IZNB/941fd8pdEduv+KVtwJ7DqG2jArwAHyIGwrXJWnObUMpcQ+JLh79PcqhiF/4AcFRIImaTx
 75IMeQ0/QbL2kS1Ra/C7cQ9cQjcOVJawH89iPJqn20jDmC7wZWxBuKJ7MsEiywgGUkxuYiOsv7Z
 jKF5csamwIm8qH4RucIXoUi/86nzr2lcn9UKfaE234U4tFWHMvUa9yOdlrFyHDt+zmx7+HIrZ8C
 ypP952b5GpwJamyFu8/a/mjvCPVaSiB6feL2GsY2EzjEWxjJt6SHMVwtrg4yNbt7FZjgpTIaKYs
 oTgH8LvIqr8naveNhHpL5kmDkhxMYHLrruG/ZSfo3148m59y
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

In preparation for reuising it for SME pull the code for discovering the
maximum virtualizable vector length out of sve_setup() into a separate
function, updating to return 0 without a WARN_ON() for the case where no
virtualisable VL exists.  For SVE this case is architecturally invalid
but for SME it is valid if ill advised.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index b5535f8c9bd9..314f5d61be11 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1118,6 +1118,29 @@ int vec_verify_vq_map(enum vec_type type)
 	return 0;
 }
 
+static int __init vec_virtualisable_vl(struct vl_info *info)
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
@@ -1129,8 +1152,6 @@ void cpu_enable_sve(const struct arm64_cpu_capabilities *__always_unused p)
 void __init sve_setup(void)
 {
 	struct vl_info *info = &vl_info[ARM64_VEC_SVE];
-	DECLARE_BITMAP(tmp_map, SVE_VQ_MAX);
-	unsigned long b;
 	int max_bit;
 
 	if (!system_supports_sve())
@@ -1153,21 +1174,7 @@ void __init sve_setup(void)
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAAD4F799E;
	Thu,  9 Jul 2026 18:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783622425; cv=none; b=qiVID4rxMOaBRPOd7mENjoXmmHLCqfEMZ50B2soyKFdGuf1xk/3g9CbkojXMuCOerRQuglVGeE3H4CL2+YG/JNiWhVZ6K38PhUaJlxhmOF3p6JNQVleC9GHmMLqsc4HXRzPxN1r92bp+s/r305H0Q/ySAWEfXmTVx0F3SKvXK/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783622425; c=relaxed/simple;
	bh=neew/zQKQc9VPVi7macEuVISGaMZgaNeHcW5WvUvtiM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=q2/CZTY2ljCgR72drTsblkrmAw4A3tl4yGr+XEJwLgWNlWziYaopj/H7jGfCugktLvE3UX0hbjy1D8qShbejdUYeBmlfrH3SMUkFF/QG2QBy0awas02XeR2p/jsV4yf2S2wxpakL189XpOh6Vpui7RRqOExcwQUt2EU2AG0Zt6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F2uBsk/V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F2uBsk/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5C51F00A3A;
	Thu,  9 Jul 2026 18:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783622424;
	bh=X4HlyMbyPhKCnIL3AvhZ79kxUeT3XQMJg0KjZKyp1dU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=F2uBsk/Vwn+HtLHg3ciBoZS0lou2xWoDVEWwYesEEGBRK7yHGSN1NZHS1Jrxbdxs5
	 IN0kMOc28tqsmUQ+bpDWnBJ7wJE6Q236/KYjpHaFYTxV9ZJXxd0OKr+tOiEBFL51sC
	 axNdt6JNehXGQEJmZc15VUCMQ9q9iBv82Rv4cTr47L/oLtaWpIoHDW/9Rec2y9+Twr
	 PMs6FXk0fv1//EBA8O1bnYEsAKwCW6VdKrEWtyeVtiz4yfgCKLUI9iCObuMkLImd5S
	 Pband2E0PPQ9+2+uijLBi6razJZCyMl/hSqIFEJ2dyDXFlraeaiq40Eto7JvxDkxYr
	 D+tUwfFbnTZYg==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 19:27:25 +0100
Subject: [PATCH v12 04/29] arm64/sve: Factor virtualizable VL discovery out
 of SVE specific code
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v12-4-d0301d79ef58@kernel.org>
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
In-Reply-To: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
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
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqT+rtT/m0eK9SlRIe/SGmYC9t7dpPWB9eE/M37
 +zo+6Cyb8iJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak/q7QAKCRAk1otyXVSH
 0IjnB/0eRU+G2bCmOTokgdLLuZk5znuDYAEAX60xA6kEE+As+EPR4JUgTHGmvY+RTA8i1ahwURI
 bOYucBN3owHKHVfVJd3XrX/q1mWLHpaTKjEzEEJqM7DYV6rC2VUB8CSEfuf+LeDudALLTw+aFXv
 7FeWwsznBsXC0dYrWhjiQjTg48yFaQQKS/X7zgihckyIVGQF0YwLSsZSC5a7/JzOCtXWV5ZIf7C
 /Pn416eVKBHoxOyJdXIR7UcA6tqq5a4HjhL5H66uEAlaK8IK9Fmh0uT3qZl8WhesrMgFBa4a6Un
 sZ4PunDTGYt/42wYvDIOBIDq4lKlDt1pM3x+fW9TbJ7EUybX
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


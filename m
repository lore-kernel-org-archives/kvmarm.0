Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EDE426439;
	Fri, 31 Jul 2026 12:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501460; cv=none; b=iJfzuevAXyyeV41KfmuZ1JY/SS/0FmKvsqIjTYOX5yY6o0jKVWlfBZp7eTfM8P3TpbQ99D7pv60r2+zgvx5DAahsOe6KdG3xYyH3WW9/6mzJNM8dg8Ek3q3tiuDBw0MC/Kh2vrqKrjJAVa/QVRK2ZBzwExsCkjTmDs7ncu9+ywA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501460; c=relaxed/simple;
	bh=cmvAQBxB4SuCRvDZjmRe7yIsmwDDWXuwPP1P7cDHpHg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mxTvD1jOOBYNV9hFct0LjkqHoXIWuvar8dtZMg1mTm2oVhhQ1/kmtod9LiRkl/LvfHlIgcTBx0HjRjoLIsLoLXWy60Fv3vuBvklvpl+x94MmqjWVxjtB3/qC15KvoqKosxQ3nba9+9EsFqdtKi20hMXnY0xwdxsmKN9sVs7t1Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=egRCpJ+H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="egRCpJ+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772C71F00A3A;
	Fri, 31 Jul 2026 12:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785501457;
	bh=YWlLd/PWbYINVwpXcYMDnYu5TnVLNXcprwUMzPtexF8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=egRCpJ+H6L+w3dfFkKpNxYqBDFcAfJamNTxxvLvPTRHAwFJhD0+M4T+jLanaPb/nR
	 8Y5XiOe+qRVfIzEfyEh7SSoc3HWPyVbs4ZdfcT77E6STAMlIWQotJIbfb/DnCb/sjc
	 ybBn1SxXXceQOaH7zwKnf7VD7K6itJbzENMDW8Lp+eGb1uW7msVkqXsUqBrR45Cf7d
	 P6YW4iDZK6HnMqcSfbcnqJ1YyqPBE/DOGPwnR9HmBIsSu3mXzkHmsu/GGFDdYRZJrO
	 4RoAN/GxacZnShtYPam+C6GAJOIvJ0s91srYxH40hX36YlcyjDpTRtpp1WynQ8rU1m
	 47gPHf7Hb8Z2g==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 31 Jul 2026 13:25:40 +0100
Subject: [PATCH v17 02/14] KVM: arm64: Fix FGT mapping for
 HFGITR_EL2.nGCSEPP
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-arm64-gcs-v17-2-5e39ca01b14e@kernel.org>
References: <20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org>
In-Reply-To: <20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1184; i=broonie@kernel.org;
 h=from:subject:message-id; bh=cmvAQBxB4SuCRvDZjmRe7yIsmwDDWXuwPP1P7cDHpHg=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqbJb9ryZUssM2383dLfuqVg1a8N+tHrx4BX//v
 ut2+kHJBKmJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCamyW/QAKCRAk1otyXVSH
 0DYtB/99NhOxMegqJU3W95X2zE4hKONTVBnxagZmtOjar4WNxeGTnynGNqBFkuofmHROtVyR5qf
 RAVtiM/OlvilZ05gDNa7FYxJhYS2QEItKQsJgVeePGFNnxwGsW+ECl4pxhIaDWIWX7RO/1uZtyq
 g3m8ftYPH8/Sx8H5b5rGxxQzZl83CUdL4KoBCcgcsmwXMXxYFbMwqLtfIBgzfFN9BEdQZFxdWUY
 970pEYgMRmcfV2MC2lzC8SJihKVDVRwAVOMVKFeus7PajV/x5MLoIR4sEgcIrEhWC31rQijnM4y
 2LbswYOhx37fuy9jIVWFVH7UJwvNEOcZoJ2Yp6Jly73SDTes
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The encoding to trap mapping currently maps a FGT on OP_GCSPOPX to
HFGITR_EL2.nGCSEPP but as per DDI0601 2026-06 this FGT controls trapping
of GCSPUSHX and GCSPOPCX, and not the separate GCSPOPX instruction.
Update the mapping to reflect the architecture.

Fixes: 863ac38984a82 ("KVM: arm64: Add missing HFGITR_EL2 FGT entries to nested virt")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 3c82f392845d..b32742d9dd73 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1432,7 +1432,7 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(OP_AT_S1E1A, 		HFGITR, ATS1E1A, 1),
 	SR_FGT(OP_COSP_RCTX, 		HFGITR, COSPRCTX, 1),
 	SR_FGT(OP_GCSPUSHX, 		HFGITR, nGCSEPP, 0),
-	SR_FGT(OP_GCSPOPX, 		HFGITR, nGCSEPP, 0),
+	SR_FGT(OP_GCSPOPCX, 		HFGITR, nGCSEPP, 0),
 	SR_FGT(OP_GCSPUSHM, 		HFGITR, nGCSPUSHM_EL1, 0),
 	SR_FGT(OP_BRB_IALL, 		HFGITR, nBRBIALL, 0),
 	SR_FGT(OP_BRB_INJ, 		HFGITR, nBRBINJ, 0),

-- 
2.47.3

